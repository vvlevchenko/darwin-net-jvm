JVM_HOME:=${shell /usr/libexec/java_home}

JVMSOURCE?=

CFLAGS+=-I${JVM_HOME}/include
CFLAGS+=-I${JVM_HOME}/include/darwin
CFLAGS+=-Ibuild -I${JVMSOURCE}/jdk/src/share/javavm/export
CFLAGS+=-I${JVMSOURCE}/jdk/src/macosx/javavm/export
CFLAGS+=-I${JVMSOURCE}/jdk/src/share/native/common
CFLAGS+=-I${JVMSOURCE}/jdk/src/solaris/native/common
CFLAGS+=-I${JVMSOURCE}/jdk/src/share/native/java/net
CFLAGS+=-I${JVMSOURCE}/jdk/src/solaris/native/java/net
CFLAGS+=-D_ALLBSD_SOURCE -DNDEBUG
LDFLAGS+=-L${JVM_HOME}/jre/lib -ljava -L${JVM_HOME}/jre/lib/server -ljvm
LDFLAGS+=-compatibility_version 1.0.0 -current_version 1.0.0


_SOURCES=  jdk/src/share/native/java/net/Inet4Address.c \
	jdk/src/share/native/java/net/Inet6Address.c \
	jdk/src/share/native/java/net/InetAddress.c \
	jdk/src/share/native/java/net/DatagramPacket.c \
	jdk/src/solaris/native/java/net/Inet4AddressImpl.c \
	jdk/src/solaris/native/java/net/Inet6AddressImpl.c \
	jdk/src/solaris/native/java/net/InetAddressImplFactory.c \
	jdk/src/solaris/native/java/net/NetworkInterface.c \
	jdk/src/solaris/native/java/net/PlainDatagramSocketImpl.c \
	jdk/src/solaris/native/java/net/PlainSocketImpl.c \
	jdk/src/solaris/native/java/net/SocketOutputStream.c \
	jdk/src/solaris/native/java/net/SocketInputStream.c \
	jdk/src/solaris/native/java/net/bsd_close.c \
	jdk/src/share/native/common/jni_util.c \
	jdk/src/solaris/native/common/jni_util_md.c \
	jdk/src/share/native/java/net/net_util.c \
	jdk/src/solaris/native/java/net/net_util_md.c \
	jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c

NATIVES= \
	java.net.Inet4Address \
	java.net.Inet6Address \
	java.net.InetAddress \
	java.net.Inet4AddressImpl \
	java.net.Inet6AddressImpl \
	java.net.InetAddressImplFactory \
	java.net.NetworkInterface \
	java.net.SocketOptions \
	java.net.SocketOutputStream \
	java.net.SocketInputStream \
	java.net.DatagramPacket \
	java.net.PlainDatagramSocketImpl \
	java.net.PlainSocketImpl \
	sun.net.ExtendedOptionsImpl \
	jdk.net.SocketFlow \
	java.net.PlainSocketImpl \
	java.net.SocketOptions

HEADERS=$(foreach h,$(NATIVES), build/$(subst .,_,$h).h)

_OBJECTS=${_SOURCES:.c=.o}

OBJECTS=$(foreach o,${_OBJECTS}, build/${o})

SOURCES=$(foreach s,${_SOURCES}, ${JVMSOURCE}/${s})

VPATH=${JVMSOURCE}

DSO=libnet.dylib

all:${DSO}

clean:
	rm -rf ${DSO} build

${DSO}:${HEADERS} ${OBJECTS}
	${CC} -shared ${LDFLAGS} -o $@ ${OBJECTS}


build/%.o:${JVMSOURCE}/%.c
	-mkdir -p ${@D}
	${CC} ${CFLAGS} -c -o $@ $<

build/%.h:
	javah -o $@ $(subst _,.,$(basename ${@F}))

.PHONY:all clean
