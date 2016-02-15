
.PHONY: all install uninstall
all:	servod

servod:	servod.c mailbox.c
	gcc -std=c11 -fdiagnostics-color=auto -D_POSIX_C_SOURCE=199309L -Wall -g -rdynamic -o servod servod.c mailbox.c -lm
	#gcc -std=c11 -fdiagnostics-color=auto -D_POSIX_C_SOURCE=199309L -Wall -g -O2 -o servod servod.c mailbox.c -lm

install: servod
	[ "`id -u`" = "0" ] || { echo "Must be run as root"; exit 1; }
	cp -f servod /usr/local/sbin
	cp -f init-script /etc/init.d/servoblaster
	chmod 755 /etc/init.d/servoblaster
	update-rc.d servoblaster defaults 92 08
	/etc/init.d/servoblaster start

uninstall:
	[ "`id -u`" = "0" ] || { echo "Must be run as root"; exit 1; }
	[ -e /etc/init.d/servoblaster ] && /etc/init.d/servoblaster stop || :
	update-rc.d servoblaster remove
	rm -f /usr/local/sbin/servod
	rm -f /etc/init.d/servoblaster

clean:
	rm -f servod

