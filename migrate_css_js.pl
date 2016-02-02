use warnings;
use strict;

my $index_file = read_file('./index.html');
#print $index_file;

my ($vendor_css, $app_css, $vendor_js, $app_js);
if ($index_file =~ /(<link rel="stylesheet" href="app.*?\.vendor.css"\/>).*(<link rel="stylesheet" href="app.*?\.app\.css"\/>).*(<script src="app.*?\.vendor\.js"><\/script>).*(<script src="app.*?\.app\.js"><\/script>)/s) {
  $vendor_css = $1;
  $app_css    = $2;
  $vendor_js  = $3;
  $app_js     = $4;
} else {
  die 'no match for vendor.css and app.css';
}
print $vendor_css, $app_css, $vendor_js, $app_js;

my $loading_tpl_file = read_file('./loading.tpl.html');

$loading_tpl_file =~ s/<\/head>/$vendor_css\n$app_css\n<\/head>/;
$loading_tpl_file =~ s/<\/body>/$vendor_js\n$app_js\n<\/body>/;
$loading_tpl_file =~ s/\r//g;
#print $loading_tpl_file;

write_file('./loading.html', $loading_tpl_file);

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>
    };
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}
