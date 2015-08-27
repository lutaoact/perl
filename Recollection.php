<?php
    include_once 'Db.php';

    class Recollection {
        private $_mysql;

        public function __construct($do_replication = true){
            $this->set_replication($do_replication);
		}

        public function set_replication($do_replication = true){
            $db = Db::getInstance($do_replication);
            $this->_mysql = $db->get_db_handle();
		}

        ##################
        # common functions
        ##################
        public function err_code(){
            return $this->_mysql->errno();
        }

        public function err_msg(){
            return $this->_mysql->errmsg();
        }

        public function escape( $data ) {
            return $this->_mysql->escape( $data );
        }
        
        /*
        * mysqli_insert_id
        */
        public function lastId()
        {
            return $this->_mysql->lastId();
        }

        public function format( $data = null){
            return array($data, $this->_mysql->errno(), $this->_mysql->errmsg());
        }

        public function getData( $sql ) {
            return $this->format( $this->_mysql->getData($sql) );
        }

        public function runSql( $sql ) {
            return $this->format( $this->_mysql->runSql($sql) ); 
        }

        public function getVar( $sql ) {
            return $this->format( $this->_mysql->getVar($sql) ); 
        }

        public function getLine( $sql ) {
            return $this->format( $this->_mysql->getLine($sql) );
        }

        private function format_data($params, $separator = ','){
            $str = $s = '';
            foreach ($params as $k => $v) {
                $v = $this->_mysql->escape($v);
				$v = is_int($v) ? $v : "'{$v}'";
                $str .= $s . "`{$k}`={$v}";
                $s = $separator;
            }
            return $str;
        }
		
		private function format_list_to_string($list) {
			$list_string = '';
			foreach($list as $e) {
				$e = $this->escape($e);
				if($list_string == '') {
					$list_string = "'{$e}'";
				} else {
					$list_string .= ", '{$e}'";
				}
			}
			return $list_string;
		}

        ##################
        # user
        ##################
        public function select_user_by_email($login_email){
            $sql = "SELECT 
                        * 
                    FROM 
                        `user` 
                    WHERE 
                        `login_email` = '{$this->escape( $login_email )}' 
                    LIMIT 1 ";

            return $this->getLine ($sql);
        }

        public function select_user_by_id($user_id){
            $sql = "SELECT 
                        * 
                    FROM 
                        `user` 
                    WHERE 
                        `user_id` = '{$this->escape( $user_id )}' 
                    LIMIT 1 ";

            return $this->getLine ($sql);
        }

        public function insert_user($params){
            $data = $this->format_data($params);
            $sql = "INSERT 
                        `user` 
                    SET {$data} , updated_time = NOW()";
            return $this->runSql( $sql);
        }

        public function update_user($user_id, $params){
        	$user_id = $this->escape($user_id);

        	$data = $this->format_data($params);
        	$sql = "UPDATE
        				`user` 
        			SET 
        				{$data},
        				`updated_time` = NOW()
					WHERE 
						`user_id` = '{$user_id}'";
        	return $this->runSql($sql);        	
        }


        public function select_user_list($user_id, $last_fetch_time) {
            $sql_member_id = "select 
                        distinct(member_id) 
                    from
                        book_member 
                    where 
                        book_uuid in (select book_uuid from book_member where member_id = $user_id and permission>0)
						and permission>=2";
            $data = $this->_mysql->getData($sql_member_id);
            if(!$data) {
                return $this->format(array());
            }

            $user_list = array();
            foreach($data as $item) {
                array_push($user_list, $item['member_id']);
            }
            $member_id_in = join(',', $user_list);

            $sql_user = "select 
                        user_id, login_email, user_name, mobile, gender, birthday, created_time, updated_time 
                    from 
                        `user` 
                    where 
                        user_id in ($member_id_in) and 
                        unix_timestamp(updated_time) > {$this->escape($last_fetch_time)}
                    order by 
                        updated_time asc";
            return $this->getData($sql_user);
        }

		function select_daily_register_user_count($limit_days = 45) {
			$time_stamp = time() - $limit_days * 86400;
			$sql = "select
						date(created_time) as register_date,
						count(user_id) as user_count
					from
						`user`
					where
						created_time > {$time_stamp}
					group by date(created_time);
			";
			return $this->getData($sql);
		}
		
		function select_user_count() {
			$sql = "
				SELECT
					count(*) as user_count
				FROM
					user
			";
			return $this->getLine($sql);
		}
		
        ##################
        # user pref
        ##################

        public function get_user_pref_by_id($user_id, $last_sync_key, $last_fetch_time) {
           $sql =   "select 
                        * 
                    from 
                        user_pref 
                    where 
                        user_id = {$this->escape($user_id)} 
                            and 
                        unix_timestamp(updated_time) > {$this->escape($last_fetch_time)} 
                            and 
                        sync_key != '{$this->escape( $last_sync_key )}' 
                    order by 
                        updated_time asc
            ";
            return $this->getData($sql);
        }

        //=====================
        // params : {pref_value : xxx, sync_key : zzz}
        public function insert_or_update_user_pref($user_id, $pref_name, $params) {
			if(!isset($params['sync_key'])){
				$params['sync_key'] = '';
			}
            $data = $this->format_data($params);
            $sql =  "insert 
                        user_pref 
                    set 
                        user_id = {$this->escape($user_id)},
                        pref_name = '{$this->escape($pref_name)}',
                        {$data},
                        updated_time = NOW()
                    on duplicate key update
                        {$data},
                        updated_time = NOW()
            ";
            return $this->runSql($sql);
        }

        public function get_user_all_prefs_by_id($user_id) {
           $sql =   "select 
                        * 
                    from 
                        user_pref 
                    where 
                        user_id = {$this->escape($user_id)} 
            ";
            return $this->getData($sql);
        }

        public function select_user_pref_by_pref_name($user_id, $pref_name) {
           $sql =   "select 
                        pref_value 
                    from 
                        user_pref 
                    where 
                        user_id = {$this->escape($user_id)} 
                            and
                        pref_name = '{$this->escape($pref_name)}'
            ";
            return $this->getVar($sql);
        }

        ##################
        # user buffer
        ##################

        public function get_user_buffer_by_email($login_email) {
            $sql = "SELECT 
                        * 
                    FROM 
                        `user_buffer` 
                    WHERE 
                        `login_email` = '{$this->escape( $login_email )}' 
                    LIMIT 1 ";
            return $this->getLine ($sql);
        }

        public function delete_user_buffer_by_email($login_email) {
            $sql = "DELETE 
					FROM 
                        `user_buffer` 
                    WHERE 
                        `login_email` = '{$this->escape( $login_email )}' ";

            return $this->runSql( $sql);
        }

        public function insert_user_buffer($login_email, $login_password, $user_name, $mobile, $verify_token){
            $sql = "INSERT 
                        `user_buffer` 
                    SET 
                        `login_email`   = '{$this->escape( $login_email )}',
                        `mobile`        = '{$this->escape( $mobile )}',
                        `verify_token`  = '{$this->escape( $verify_token )}' ";
            return $this->runSql( $sql);
        }

        public function insert_or_update_user_buffer_by_email($login_email, $verify_token) {
            $sql = "INSERT
                        `user_buffer`
                    SET
                        `login_email`   = '{$this->escape( $login_email )}',  
                        `verify_token`  = '{$this->escape( $verify_token )}', 
                        `updated_time`  = NOW()
                    ON DUPLICATE KEY UPDATE
                        `verify_token`  = '{$this->escape( $verify_token )}', 
                        `updated_time`  = NOW() ";
            return $this->runSql( $sql);
        }

        ##################
        # book_member
        ##################
        
        public function get_book_permission($book_uuid, $user_id){
        	$sql = "SELECT
                        `permission`
                    FROM
                        `book_member`
                    WHERE
                        `book_uuid` = '{$this->escape($book_uuid)}'
                            AND
                        `member_id` = '{$this->escape($user_id)}'";
            return $this->getVar($sql);
        }
        
        public function insert_or_update_book_member($book_uuid, $member_id, $permission = 1){
        	$book_uuid      = $this->escape($book_uuid);
        	$member_id      = $this->escape($member_id);
        	$permission     = $this->escape($permission);
        	$sql = "INSERT 
        				`book_member`
        			SET
        				`book_uuid`  = '{$book_uuid}',
        				`member_id`  = '{$member_id}',
        				`permission` = {$permission}
        			ON DUPLICATE KEY UPDATE
        				`permission` = {$permission}
        			
        	";
        	return $this->runSql($sql);
        }

		public function delete_book_member($book_uuid, $member_id) {
        	$book_uuid      = $this->escape($book_uuid);
        	$member_id      = $this->escape($member_id);
			$sql = "DELETE
					FROM
						`book_member`
					WHERE
						`book_uuid` = '{$book_uuid}'
							AND
						`member_id` = {$member_id}
			";
        	return $this->runSql($sql);
		}

        public function get_book_uuid_list( $user_id , $permission=0) {
           $sql_book_uuid = "select 
                        book_uuid 
                    from 
                        book_member 
                    where 
                        member_id = {$user_id}
                    and
                        permission >= {$permission}
            ";
            return $this->getData($sql_book_uuid);
        }
        
        public function get_book_member_by_user_id_and_updated_time($user_id, $last_fetch_time){
        	$user_id         = $this->escape($user_id);
        	$last_fetch_time = $this->escape($last_fetch_time);
        	$sql = "
        		SELECT
        			*
        		FROM
        			`book_member`
        		WHERE
        			`member_id` = {$user_id}
        		AND
        			UNIX_TIMESTAMP(`updated_time`) > {$last_fetch_time}
        		ORDER BY
        			`updated_time` ASC
        	";
        	return $this->getData($sql);
        }

        
        ##################
        # book
        ##################

        public function select_updated_book_list($user_id, $last_sync_key, $fields = array()) {
        	$select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}		
            $sql = "select 
                        {$select_fields} 
                    from 
                        book 
                    where
                        book_uuid in (
                            select 
                                book_uuid
                            from
                                book_member
                            where
                                member_id = {$this->escape($user_id)}
                                and
                                permission > 0
                        ) 
                     and
                        sync_key != '{$this->escape($last_sync_key)}'
                    order by
                    	updated_time asc";
            return $this->getData($sql);
        }

        //book_uuid可以是单个，也可以是uuid数组
        public function select_book_by_uuid($book_uuid, $fields = array()){
        	$select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
        	$sql = "SELECT 
        				{$select_fields}
        			FROM
        				`book`
        			WHERE 
        				`book_uuid` 
        	";			
			if(is_array($book_uuid)){
				foreach($book_uuid as &$uuid){
					$uuid = $this->_mysql->escape($uuid);
					$uuid = "'{$uuid}'";
				}
				$book_uuid_string = implode(',', $book_uuid);
				$sql .= " IN ({$book_uuid_string})";
				return $this->getData($sql);
			} else {
				$book_uuid = $this->_mysql->escape($book_uuid);
				$sql .= "='{$book_uuid}'";
				return $this->getLine($sql);
			}       	
        }
		
		/*获取用户所有未删除的book, 可以按permission过滤*/
		public function select_all_books_by_user_id($user_id, $permission=1, $fields = array()){
			$select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
			$user_id = $this->escape($user_id);
			$sql = "
				SELECT
					{$select_fields}
				FROM
					`book`
				WHERE
					`book_uuid`
					IN (    SELECT 
                                book_uuid
                            FROM
                                book_member
                            WHERE
                                member_id = {$this->escape($user_id)}
                                and
                                permission >= {$permission}
						)
					AND
						`delete_flag` = 0
				ORDER BY `created_time` ASC
			";
			return $this->getData($sql);
		}

        /*获取用户所有未删除的book详情*/
		public function select_book_detail_by_user_id($user_id){
			$user_id    = $this->escape($user_id);
			$sql = "
				SELECT
					`book`.*, 
                    `book_member`.`permission` as `permission`, 
                    `user`.`user_name` as `created_member_name`
				FROM
					`book_member`, `book`, `user`
				WHERE
                    `book_member`.member_id = {$user_id}
                        AND
                    `book_member`.permission > 0
                        AND
                    `book_member`.book_uuid = `book`.book_uuid
                        AND
                    `book`.`delete_flag` = 0
                        AND
                    `book`.`created_member` = `user`.`user_id`
				ORDER BY  `book`.`created_time` ASC
			";
			return $this->getData($sql);
		}


        /*获取用户所有未删除的book分享详情*/
		public function select_book_shared_detail_by_user_id($book_uuid, $user_id, $limit = 100){
			$book_uuid    = $this->escape($book_uuid);
			$user_id      = $this->escape($user_id);
            $limit        = intval($limit);
			$sql = "
				SELECT
                    `book_member`.`permission` as `permission`, 
                    `user`.`user_name` as `user_name`,
                    `user`.`login_email` as `login_email`,
					`user`.`user_id` as `share_to_user_id`
				FROM
					`book_member`,  `user`
				WHERE
                    `book_member`.book_uuid = '{$book_uuid}'
                        AND
                    `book_member`.permission > 0
                        AND
                    `book_member`.member_id != {$user_id}
                        AND
                    `book_member`.member_id = `user`.`user_id`
				ORDER BY  `user`.`login_email` ASC
                LIMIT {$limit}
			";
			return $this->getData($sql);
		}

		/*获取用户所有拥有的book*/
		public function select_own_books_by_user_id($user_id, $fields = array()){
			$select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
			$user_id = $this->escape($user_id);
			$sql = "
				SELECT
					{$select_fields}
				FROM
					`book`
				WHERE
						`created_member`= {$user_id}
					AND
						`delete_flag` = 0
				ORDER BY `created_time` ASC
			";
			return $this->getData($sql);
		}		
        
        /**
        * @param $book_uuid  为了避免漏掉强制传
        * @param $created_member 为了避免漏掉强制传
        * @param $params 其他字段
        */
        public function insert_book($book_uuid, $created_member, $params = array()){
        	$params['book_uuid']      = $book_uuid;
        	$params['created_member'] = $created_member;
        	$params['updated_member'] = $created_member;
        	$data = $this->format_data($params);
        	$sql = "INSERT
        				`book`
        			SET 
        				{$data},
        				`updated_time` = NOW()
        			";
        	return $this->runSql($sql);
        }
        
        /**
        * @param $book_uuid  作where条件
        * @param $updated_member 为了避免漏掉updated_member 强制传
        * @param $params 其他字段
        */
        public function update_book($book_uuid, $updated_member, $params){
        	$book_uuid = $this->_mysql->escape($book_uuid);
        	$params['updated_member'] = $updated_member;
			if(!isset($params['sync_key'])){
				$params['sync_key'] = '';
			}			
        	$data = $this->format_data($params);
        	$sql = "UPDATE
        				`book` 
        			SET 
        				{$data},
        				`updated_time` = NOW()
					WHERE 
						`book_uuid` = '{$book_uuid}'";
        	return $this->runSql($sql);
        	
        }
		
		public function select_user_book_count($user_id){
			$sql = "SELECT COUNT(*) FROM `book` WHERE `created_member`={$user_id} AND `delete_flag`=0";
			return $this->getVar($sql);
		}


        ##################
        # content
        ##################

        public function get_content_list($user_id, $last_fetch_time, $last_sync_key) {
           $sql = "select 
                        * 
                    from 
                        content 
                    where
                        book_uuid in (
                            select
                                book_uuid
                            from 
                                book_member
                            where
                                member_id = {$this->escape($user_id)}
                        ) 
                            and 
                        unix_timestamp(updated_time) > {$this->escape($last_fetch_time)} 
                            and
                        sync_key != '{$this->escape( $last_sync_key )}'
                    order by
                    updated_time asc";

            return $this->getData($sql);
        }
		
		public function select_content_list_by_book_uuid_list($book_uuid_list, $fields = array("*"), $limit_days = null, $order_by = "DESC", $delete_flag = array(0)){
			$book_uuid_string = $this->format_list_to_string($book_uuid_list);
			$fields         = implode(',', $fields);
            $delete_flags   = implode(',', $delete_flag);
        	$sql = "
        		SELECT
        			{$fields}
        		FROM
        			`content`
        		WHERE
        			`book_uuid` in ({$book_uuid_string})
                        AND
                    `delete_flag` in ({$delete_flags})
			";
			
			if($limit_days) {
				$time_stamp = time() - $limit_days * 86400;
				$sql .= " and unix_timestamp(content_time) > {$time_stamp} ";
			}

			$sql .= " ORDER BY content_time {$order_by}, updated_time {$order_by}";
			
        	return $this->getData($sql);
        }
         
       /**
        * @param $content_uuid  为了避免漏掉强制传
        * @param $book_uuid 为了避免漏掉强制传
        * @param $created_member 为了避免漏掉强制传
        * @param $params 其他字段
        */
        public function insert_content($content_uuid, $book_uuid, $created_member, $params = array()){
        	$params['content_uuid']   = $content_uuid;
        	$params['book_uuid']      = $book_uuid;
        	$params['created_member'] = $created_member;
        	$params['updated_member'] = $created_member;
			if(empty($params['created_time'])){
				$params['created_time'] = date('Y-m-d H:i:s', time());
			}
            $data = $this->format_data($params);
        	$sql = "INSERT
        				`content` 
        			SET 
        				{$data},
        				`updated_time` = NOW()
        			";
        	return $this->runSql($sql);
        }
        
       /**
        * @param $content_uuid  WHRER 条件
        * @param $updated_member 为了避免漏掉强制传
        * @param $params 其他字段
        */
        public function update_content($content_uuid, $updated_member, $params = array()){
        	$content_uuid = $this->_mysql->escape($content_uuid);
        	$params['updated_member'] = $updated_member;
			if(!isset($params['sync_key'])){
				$params['sync_key'] = '';
			}
        	$data = $this->format_data($params);
        	$sql = "UPDATE 
        				`content` 
        			SET 
        				{$data},
        				`updated_time` = NOW()
					WHERE 
						`content_uuid` = '{$content_uuid}'
        			";
        	return $this->runSql($sql);
        }        
        
        public function select_content_by_uuid($content_uuid, $book_uuid=null, $fields = array()){
		    $select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
            $sql = "
                    SELECT
                        {$select_fields}
                    FROM
                        `content`
                    WHERE
                        `content_uuid`  = '{$this->escape( $content_uuid )}'
            ";
			if($book_uuid != null){
				$sql .= " AND `book_uuid`='{$this->escape($book_uuid)}'";
			}
            return $this->getLine($sql);
        }
        
        public function select_content_in_book_uuid_list_and_content_time_between_dates($params, $fields = array()){			
			foreach($params['book_uuid_list'] as &$book_uuid){
				$book_uuid = "'{$book_uuid}'";
			}
			$book_uuid_list_str = implode(',', $params['book_uuid_list']);
            $start_time         = $this->escape($params['start_time']);
            $end_time           = $this->escape($params['end_time']);
			
		    $select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}			
						
            $sql = "SELECT
                        {$select_fields}
                    FROM
                        `content` as c
					LEFT JOIN 
						`user` AS u on c.created_member=u.user_id						
                    WHERE
                        c.`book_uuid` in ({$book_uuid_list_str})
                            AND
                        UNIX_TIMESTAMP(c.`content_time`) >= '{$start_time}'
                            AND
                        UNIX_TIMESTAMP(c.`content_time`) < '{$end_time}'
						AND
							c.`delete_flag` = 0
					ORDER BY
						c.`content_time` ASC, c.`created_time` ASC
					";
            return $this->getData($sql);
        }
        
        public function select_content_in_book_uuid_list_and_content_time_by_year_month($params){
            $start_date   = $this->escape(
                strtotime(date('y-m-d H:i:s', mktime(0,0,0,$params['month'],1,$params['year'])))
            );
            $end_date     = $this->escape(
                strtotime(date('y-m-d H:i:s', mktime(0,0,0,$params['month'] + 1,1,$params['year'])))
            );
            return $this->select_content_in_book_uuid_list_and_content_time_between_dates(
                array(
                    'book_uuid_list'    => $params['book_uuid_list'],
                    'start_time'        => $start_date,
                    'end_time'          => $end_date
                )
            );
        }
        
        public function select_updated_content_by_book_uuid($book_uuid, $last_sync_key, $last_sync_time = 0, $content_time = 0){
        	$book_uuid      = $this->escape($book_uuid);
        	$last_sync_key  = $this->escape($last_sync_key);
        	$last_sync_time = $this->escape($last_sync_time);        	
        	$sql = "
        		SELECT
        			*
        		FROM
        			`content`
        		WHERE
        			`book_uuid` = '{$book_uuid}'
        		AND
        			`sync_key` != '{$last_sync_key}'
        		AND 
        			UNIX_TIMESTAMP(`updated_time`) > {$last_sync_time}
				AND 
					UNIX_TIMESTAMP(`content_time`) >= {$content_time}
				ORDER BY `updated_time` ASC
        		";
        	return $this->getData($sql);
        }
		
		/*
		  分页获取content
		  @param $book_uuid_list 指定的book列表，每个uuid用逗号分隔
		  @param $page_num 页数
		  @param $page_size 每页个数
		*/
		public function select_content_list_by_page($book_uuid_list = array(), $page_num = 1, $page_size = 20, $keyword=null, $fields = array()){
		    $select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
			foreach($book_uuid_list as &$book_uuid){
				$book_uuid = "'{$book_uuid}'";
			}
			$book_uuid_string = implode(',', $book_uuid_list);			
			
			$sql = " 
				SELECT 
					{$select_fields}
				FROM
					`content` AS c
				JOIN 
					`user` AS u on c.created_member=u.user_id
				WHERE
					c.`book_uuid`
				IN ({$book_uuid_string}) 
				AND 
					c.`delete_flag` = 0
				";
			
			$total_sql = "SELECT COUNT(*) FROM `content` WHERE `book_uuid` IN ({$book_uuid_string}) AND `delete_flag`=0";
			if(!is_null($keyword)){
				$keyword = $this->escape($keyword);
				$sql .= " AND `title` LIKE '%{$keyword}%'";
				$total_sql .= " AND `title` LIKE '%{$keyword}%'";
			}

			$total_result = $this->_mysql->getVar($total_sql);
			$total_result = intval($total_result);
			if($total_result > 0){
				$total_page = intval(ceil($total_result / $page_size));
				$offset = ($page_num - 1) * $page_size;
				$sql .= "
					ORDER BY 
						c.`content_time` ASC,
						c.`created_time` ASC
					LIMIT {$offset}, {$page_size}
				";
				list($content_list, $mysql_err_no, $mysql_err_msg) = $this->getData($sql);
				if($mysql_err_no > 0){
					return $this->format($content_list);
				}
				$page_params = array('page' => $page_num, 'page_size' => $page_size, 'total' => $total_page);
				$res = array(
					'content_list' => $content_list,
					'page'         => $page_params
					);
				return $res;
			} else {
				return $this->format(array());
			}
			
		}

       /**
        * @param $book_uuid_list  
        * @param $content_time  当前content的时间 时间戳
		* @param $created_time  当前content的创建时间 时间戳
		* @param $type 类型 next|prev
        */		
		public function select_next_or_prev_content($book_uuid_list = array(), $content_time, $content_uuid, $type = 'next'){
			foreach($book_uuid_list as &$book_uuid){
				$book_uuid = "'{$book_uuid}'";
			}
			$book_uuid_string = implode(',', $book_uuid_list);
			
			$sql = "
				SELECT
					*
				FROM
					`content`
				WHERE
					`book_uuid` IN ({$book_uuid_string})
				AND `delete_flag` = 0
			";
			
			if($type == 'next'){
				$sql .= " AND ( (UNIX_TIMESTAMP(`content_time`) = {$content_time} AND `content_uuid` > '{$content_uuid}')
						  OR (UNIX_TIMESTAMP(`content_time`) > {$content_time}) )";
				$sql .= " ORDER BY `content_time` ASC, `content_uuid` ASC LIMIT 1";
			}
			if($type == 'prev'){
				$sql .= " AND ( (UNIX_TIMESTAMP(`content_time`) = {$content_time} AND `content_uuid` < '{$content_uuid}')
						  OR (UNIX_TIMESTAMP(`content_time`) < {$content_time}) )";
				$sql .= " ORDER BY `content_time` DESC, `content_uuid` DESC LIMIT 1";
			}
			return $this->getLine($sql);
		}
		
		/** 获取用户的记事数量
		 * @param $user_id 用户id
		 * @param $start   开始时间
		 * @param $end     结束时间
		*/
		public function select_user_content_count($user_id, $start=null, $end=null){
			$sql = " SELECT COUNT(*) FROM `content` WHERE `created_member`= {$user_id} AND `delete_flag`=0 ";
			if(!is_null($start) && !is_null($end)){
				$sql .= " AND `created_time` >= '{$start}' AND `created_time` <= '{$end}'";
			}
			return $this->getVar($sql);
		}
		
		function select_daily_content_count($limit_days = 45) {
			$time_stamp = time() - $limit_days * 86400;
			$sql = "select
						date(content_time) as created_date,
						count(content_uuid) as content_count
					from
						`content`
					where
						content_time > {$time_stamp}
					group by date(content_time);
			";
			return $this->getData($sql);
		}		
		
		function select_content_count() {
			$sql = "
				SELECT
					count(*) as content_count
				FROM
					content
			";
			return $this->getLine($sql);
		}
		
        ##################
        # media
        ##################
        
       /**
        * @param $media_uuid  为了避免漏掉强制传
        * @param $content_uuid  为了避免漏掉强制传
        * @param $book_uuid 为了避免漏掉强制传
        * @param $created_member 为了避免漏掉强制传
        * @param $params 其他字段
        */
        public function insert_media($media_uuid, $content_uuid, $book_uuid, $created_member, $params = array()){
        	if(empty($params)){
        		return false;
        	}
        	$params['media_uuid']     = $media_uuid;
        	$params['content_uuid']   = $content_uuid;
        	$params['book_uuid']      = $book_uuid;
        	$params['created_member'] = $created_member;
        	$params['updated_member'] = $created_member;
            $data = $this->format_data($params);
        	$sql = "INSERT
        				`media` 
        			SET 
        				{$data},
        				`created_time` = NOW(),
        				`updated_time` = NOW()
        			";
        	return $this->runSql($sql);
        }        

       /**
        * @param $media_uuid  为了避免漏掉强制传
        * @param $content_uuid  为了避免漏掉强制传
        * @param $book_uuid 为了避免漏掉强制传
        * @param $updated_member 为了避免漏掉强制传
        * @param $params 其他字段
        */
        public function update_media($media_uuid, $updated_member, $params = array()){
        	if(empty($params)){
        		return false;
        	}
        	$media_uuid               = $this->escape($media_uuid);
        	$params['updated_member'] = $updated_member;
			if(!isset($params['sync_key'])){
				$params['sync_key'] = '';
			}
            $data = $this->format_data($params);
        	$sql = "UPDATE
        				`media` 
        			SET 
        				{$data},
        				`updated_time` = NOW()
        			WHERE
        				`media_uuid` = '{$media_uuid}'
        			";
        	return $this->runSql($sql);
        }
        
        public function select_media_by_uuid($media_uuid){
        	$media_uuid = $this->escape($media_uuid);
        	$sql = "SELECT
        				`media`.*, content.book_uuid AS content_book_uuid
        			FROM
        				`media`, `content`
        			WHERE
        				`media`.`media_uuid`='{$media_uuid}'
							AND
						`media`.`content_uuid` = `content`.`content_uuid`
        			";
        	return $this->getLine($sql);
        }
        
        public function get_media_list_by_book_uuid($book_uuid, $last_sync_key, $last_sync_time = 0, $content_time = 0){
        	$book_uuid       = $this->escape($book_uuid);
        	$last_sync_key   = $this->escape($last_sync_key);
        	$last_sync_time  = $this->escape($last_sync_time);
            $content_time    = $this->escape($content_time);
        	
        	$sql = "
        		SELECT
        			`media`.* , content.book_uuid AS content_book_uuid
        		FROM
        			`media`, `content`
        		WHERE
                    `content`.`book_uuid` = '{$book_uuid}'
						AND
        			UNIX_TIMESTAMP(`content`.`content_time`) >= {$content_time}
                        AND
                    `media`.`content_uuid` = `content`.`content_uuid`
						AND
        			UNIX_TIMESTAMP(`media`.`updated_time`) > {$last_sync_time}
                        AND 
        			`media`.`sync_key` != '{$last_sync_key}'
        		ORDER BY 
        			`media`.`updated_time` ASC
        	";
        	return $this->getData($sql);
        }
		
		/*
		 根据content_uuid获取media list
		 @param $content_uuids string | array 如果是数组表示多个content_uuid
		*/
		public function select_media_list_by_content_uuid($content_uuid, $fields = array()){
		    $select_fields = '';
        	if(empty($fields)) {
        		$select_fields = '*';
        	} else {
        		$select_fields = implode(',', $fields);
        	}
			
			$content_uuid_string = '';
			if(is_array($content_uuid)){
				foreach($content_uuid as &$uuid){
					$uuid = "'{$this->escape($uuid)}'";
				}
				$content_uuid_string = implode(',', $content_uuid);
			} else {
				$content_uuid_string = "'{$this->escape($content_uuid)}'";
			}
			
			$sql = "
				SELECT 
					{$select_fields}
				FROM
					`media`
				WHERE `content_uuid` IN ({$content_uuid_string})
				AND `delete_flag` = 0
			";	
			return $this->getData($sql);
		}
		
		/** 获取用户的图片数量
		 * @param $user_id 用户id
		 * @param $start   开始时间
		 * @param $end     结束时间
		*/
		public function select_user_media_count($user_id, $start=null, $end=null){
			$sql = " SELECT COUNT(*) FROM `media` WHERE `created_member`= {$user_id} AND `delete_flag`=0 ";
			if(!is_null($start) && !is_null($end)){
				$sql .= " AND `created_time` >= '{$start}' AND `created_time` <= '{$end}'";
			}
			return $this->getVar($sql);
		}
		
        ##################
        # shared_content
        ##################
		
		public function insert_or_update_shared_content($content_uuid, $book_uuid, $platform, $token){
			$data = $this->format_data(
				array(
					'content_uuid' => $content_uuid,
					'book_uuid'    => $book_uuid,
					'platform'     => $platform,
					'token'        => $token
				)
			);
			
			$sql = "
				INSERT 
					`shared_content`
				SET
					{$data}
				ON DUPLICATE KEY UPDATE
					`token` = '{$token}'
			";
			return $this->runSql($sql);
		}
		
		public function select_shared_content($content_uuid, $platform){
			$content_uuid = $this->escape($content_uuid);
            $platform     = $this->escape($platform);

			$sql = "
				SELECT 
					*
				FROM
					`shared_content`
				WHERE
					`content_uuid` = '{$content_uuid}'
                        AND
                    `platform`  = {$platform}
			";
			return $this->getLine($sql);
		}
		
		public function delete_shared_content($content_uuid, $platform){
			$content_uuid = $this->escape($content_uuid);
			$platform     = $this->escape($platform);
			$sql = "
				DELETE  FROM `shared_content` WHERE `content_uuid`='{$content_uuid}' AND `platform`={$platform}
			";
			return $this->runSql($sql);
		}
		
        ##################
        # user_limit
        ##################
		
		/**
		 * 添加一条user_limit
		 * @param $params 参数数组
		 */
		public function insert_user_limit($params){
			$data = $this->format_data($params);
			$sql  = "INSERT `user_limit` SET {$data}, `created_time`=NOW()";
			return $this->runSql($sql);			
		}

		/**
		 * 修改一条user_limit
		 * @param $params 参数数组
		 */		
		public function update_user_limit($user_id, $params){
			$data = $this->format_data($params);
			$sql  = "UPDATE `user_limit` SET {$data} WHERE `user_id`={$user_id}";
			return $this->runSql($sql);		
		}
		
		/**
		 * 删除一条user_limit
		 * @param $user_id 用户id
		 */			
		public function delete_user_limit($user_id){
			$user_id = $this->escape($user_id);
			$sql = "DELETE FROM `user_limit` WHERE `user_id`={$user_id}";
			return $this->runSql($sql);
		}

		/**
		 * 查询用户user_limit
		 * @param $user_id 用户id
		 */			
		public function select_user_limit($user_id){
			$user_id = $this->escape($user_id);
			$sql     = "SELECT * FROM `user_limit` WHERE `user_id`={$user_id}";
			return $this->getLine($sql);
		}
		
        ##################
        # user_pay
        ##################
		/**
		 * 添加一条user_pay记录
		 * @param $params 参数数组
		 */
		public function insert_user_pay($params){
			$data = $this->format_data($params);
			$sql  = "INSERT `user_pay` SET {$data} ";
			return $this->runSql($sql);			
		}
		
		/**
		 * 删除一条user_pay
		 * @param $user_id 用户id
		 */			
		public function delete_user_pay($id){
			$user_id = $this->escape($id);
			$sql = "DELETE FROM `user_pay` WHERE `id`={$id}";
			return $this->runSql($sql);
		}

		/**
		 * 查询用户的付费记录
		 * @param $user_id 用户id
		 */			
		public function select_user_pay_list($user_id){
			$user_id = $this->escape($user_id);
			$sql     = "SELECT * FROM `user_pay` WHERE `user_id`={$user_id} ORDER BY `created_time` DESC";
			return $this->getData($sql);
		}
		
        ##################
        # shared_book
        ##################		
		public function insert_shared_book($from, $to, $book_uuid, $permission=1){
			$data = $this->format_data(array(
				'from'       => $from,
				'to'         => $to,
				'book_uuid'  => $book_uuid,
				'permission' => $permission
			));
			$sql  = "INSERT `shared_book` SET {$data} ON DUPLICATE KEY UPDATE `created_time`=NOW()";
			return $this->runSql($sql);	
		}
		
		public function update_shared_book($shared_book_id, $permission){
			$shared_book_id = $this->escape($shared_book_id);
			$permission     = $this->escape($permission);
			$sql = "UPDATE shared_book SET permission={$permission} WHERE id={$shared_book_id}";
			return $this->runSql($sql);
		}
		
		public function delete_shared_book($shared_book_id){
			$shared_book_id = $this->escape($shared_book_id);
			$sql = "DELETE FROM shared_book WHERE id={$shared_book_id}";
			return $this->runSql($sql);
		}
		
		public function select_shared_book_by_id($shared_book_id){
			$shared_book_id = $this->escape($shared_book_id);
			$sql = "SELECT * FROM shared_book WHERE id={$shared_book_id}";
			return $this->getLine($sql);
		}
				
        /*获取用户未确认的shared book详情*/
		public function select_unconfirmed_shared_books($user_id) {
			$user_id = $this->escape($user_id);
			$sql = "
				SELECT
					`user`.`user_name` as `user_name`,
					`shared_book`.`id` as `id`,
					`book`.`book_name` as `book_name`
				FROM
					`user`, `book`, `shared_book`
				WHERE
					shared_book.to = {$user_id}
						AND
					book.book_uuid = shared_book.book_uuid
						AND
					user.user_id = book.created_member
			";
        	return $this->getData($sql);
		}

        ##################
        # iCal
        ##################
        public function select_book_uuid_by_vcal_uid($vcal_uid, $user_id){
            $vcal_uid = $this->escape( $vcal_uid );
            $user_id  = $this->escape( $user_id  );

            $sql = "SELECT 
                        book_uuid 
                    FROM 
                        `vcal` 
                    WHERE 
                        `vcal_uid` = '{$vcal_uid}' 
                              AND
                        `user_id`  = {$user_id}
                    LIMIT 1 ";

            return $this->getVar($sql);
        }

        # vcal_uid, $book_uuid
        public function insert_vcal($params){
    		$data = $this->format_data($params);
			$sql  = "INSERT `vcal` SET {$data} ";
			return $this->runSql($sql);	
        }


        public function select_content_uuid_by_vevent_uid($vevent_uid, $user_id){
            $vevent_uid = $this->escape( $vevent_uid );
            $user_id  = $this->escape( $user_id  );

            $sql = "SELECT 
                        content_uuid 
                    FROM 
                        `vevent` 
                    WHERE 
                        `vevent_uid` = '{$vevent_uid}' 
                              AND
                        `user_id`    = {$user_id}
                    LIMIT 1 ";

            return $this->getVar($sql);
        }
 
        # vevent_uid, $content_uuid
        public function insert_vevent($params){
    		$data = $this->format_data($params);
			$sql  = "INSERT `vevent` SET {$data} ";
			return $this->runSql($sql);	
        }
        
        ##################
        # Anniversary
        ##################
        
        public function insert_anniversary($params){
			$data = $this->format_data($params);
			$sql = "INSERT
						`anniversary`
					SET
						{$data},
						`updated_time` = NOW()
			";
			return $this->runSql($sql);
        }
        
        public function  update_anniversary($anniversary_id, $user_id, $params){
			$data = $this->format_data($params);
			$sql = "UPDATE
						`anniversary`
					SET
						{$data},
						`updated_time` = NOW()
					WHERE
						`created_member` = {$user_id} 
							AND 
						`anniversary_id` = {$anniversary_id}";
			return $this->runSql($sql);
        }

        public function  delete_anniversary($anniversary_id, $user_id){
			$user_id 		= $this->escape($user_id);
			$anniversary_id = $this->escape($anniversary_id);
			$sql = "DELETE FROM
						`anniversary`
					WHERE
						`created_member` = {$user_id} 
							AND 
						`anniversary_id` = {$anniversary_id}";
			return $this->runSql($sql);
        }
        
        public function select_all_anniversaries_by_user_id($user_id){
			$user_id = $this->escape($user_id);
			$sql = "SELECT
						*
					FROM
						`anniversary`
					WHERE
						`created_member` = {$user_id}
			";
			return $this->getData($sql);
        }

        public function select_anniversaries_by_month_day_list($user_id,  $month_day_list, $calendar_type = 1){
			$user_id 			= $this->escape($user_id);
			$calendar_type 		= $this->escape($calendar_type);
			$month_day_string 	= $this->format_list_to_string($month_day_list);
			
			$sql = "SELECT
						*
					FROM
						`anniversary`
					WHERE
						created_member = {$user_id}
							AND
						calendar_type = {$calendar_type}
							AND
						month_day IN ({$month_day_string})
			";
			return $this->getData($sql);
        }
        
        public function select_anniversary_by_id($anniversary_id, $user_id){
			$user_id 		= $this->escape($user_id);
			$anniversary_id = $this->escape($anniversary_id);
			$sql = "SELECT
						*
					FROM
						`anniversary`
					WHERE
						`anniversary_id` = {$anniversary_id}
							AND
						`created_member` = {$user_id}
			";
			return $this->getLine($sql);
        }
    }
?>
