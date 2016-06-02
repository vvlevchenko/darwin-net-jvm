# darwin-net-jvm
fixed build of libnet.dylib to work with IPv6 on macosx

How to compile:
- mkdir jvm
- pushd jvm;hg clone http://hg.openjdk.java.net/jdk8u/jdk8u;cd jdk8u;sh get_source.sh .
- popd
- git clone git@github.com:vvlevchenko/darwin-net-jvm.git
- pushd darwin-net-jvm
- JVMSOURCE=../jdk8u make clean

USAGE:
	DYLD_LIBRARY_PATH=darwin-net-jvm java -cp ....


Example:

	package junk.minamoto;

	import java.net.Inet6Address;
	import java.net.InetAddress;
	import java.net.Socket;

	/**
	* Created by minamoto on 01/06/16.
	*/
	public class IPv6Test {
		public static void main(String[] arg) throws Exception {
			InetAddress addr = InetAddress.getByName("2a02:6b8:a::a"); /* yandex.ru */
			Inet6Address addr6 = (Inet6Address)addr;
			InetAddress inetAddress = Inet6Address.getByAddress(addr6.getHostAddress(), addr6.getAddress());
			Socket socket = new Socket(inetAddress, 80, null, 0);
		}
	}

RUN:

	0# /Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home/bin/java -cp ../target/classes junk.minamoto.IPv6Test
	Exception in thread "main" java.net.NoRouteToHostException: No route to host
        at java.net.PlainSocketImpl.socketConnect(Native Method)
        at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:350)
        at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:206)
        at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:188)
        at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
        at java.net.Socket.connect(Socket.java:589)
        at java.net.Socket.connect(Socket.java:538)
        at java.net.Socket.<init>(Socket.java:434)
        at java.net.Socket.<init>(Socket.java:328)
        at junk.minamoto.IPv6Test.main(IPv6Test.java:15)


	0# DYLD_LIBRARY_PATH=${HOME}/ws/ipv6 /Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home/bin/java -cp ../target/classes junk.minamoto.IPv6Test

with compiled version no exceptions occured. :)
