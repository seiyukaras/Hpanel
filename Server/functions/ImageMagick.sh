#!/bin/bash
# Author:  himwe <Hpanel AT himwe.com>
# Support Site:  http://Hpanel.himwe.com

Install_ImageMagick()
{
cd $lnmp_dir/src
. ../functions/download.sh
. ../options.conf

src_url=http://downloads.sourceforge.net/project/imagemagick/old-sources/6.x/6.8/ImageMagick-6.8.9-10.tar.gz && Download_src

tar xzf ImageMagick-6.8.9-10.tar.gz
cd ImageMagick-6.8.9-10
./configure --prefix=/usr/local/imagemagick
make && make install
cd ../
/bin/rm -rf ImageMagick-6.8.9-10

if [ -e "$php_install_dir/bin/phpize" ];then
	src_url=http://pecl.php.net/get/imagick-3.1.2.tgz && Download_src
	tar xzf imagick-3.1.2.tgz
	cd imagick-3.1.2
	make clean
	export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
	$php_install_dir/bin/phpize
	./configure --with-php-config=$php_install_dir/bin/php-config --with-imagick=/usr/local/imagemagick
	make && make install
	cd ../
	/bin/rm -rf imagick-3.1.2

	if [ -f "$php_install_dir/lib/php/extensions/`ls $php_install_dir/lib/php/extensions | grep zts`/imagick.so" ];then
		[ -z "`cat $php_install_dir/etc/php.ini | grep '^extension_dir'`" ] && sed -i "s@extension_dir = \"ext\"@extension_dir = \"ext\"\nextension_dir = \"$php_install_dir/lib/php/extensions/`ls $php_install_dir/lib/php/extensions | grep zts`\"@" $php_install_dir/etc/php.ini
		sed -i 's@^extension_dir\(.*\)@extension_dir\1\nextension = "imagick.so"@' $php_install_dir/etc/php.ini
	        [ "$Apache_version" != '1' -a "$Apache_version" != '2' ] && service php-fpm restart || service httpd restart
	else
	        echo -e "\033[31mPHP imagick module install failed, Please contact the author! \033[0m"
	fi
fi
cd ../
}
