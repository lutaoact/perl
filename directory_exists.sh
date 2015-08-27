if [ ! -d '/home/mgsys/hello/world/hoho/haha' ]; then
    mkdir -p '/home/mgsys/hello/world/hoho/haha'
    echo 'not exist'
else
    echo 'exist'
fi
