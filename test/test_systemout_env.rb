require 'test/unit'

require File.dirname(__FILE__) + '/../lib/system_out_err.rb'

class TestSystemOutEnvironment < Test::Unit::TestCase

  def setup
     @env = WAS::Environment.parse(
<<EOS
************ Start Display Current Environment ************
WebSphere Platform 6.0 [ND 6.0.2.27 cf270815.03]  running with process name FCBDBWCELL01\\FCBDBWNODE01\\FCBINGN1DEVServer1 and process id 938208
Host Operating System is AIX, version 5.3
Java version = J2RE 1.4.2 IBM AIX build ca142-20080122 (SR10) (JIT enabled: jitc), Java Compiler = jitc, Java VM name = Classic VM
was.install.root = /usr/IBM/WebSphere/AppServer
user.install.root = /usr/IBM/WebSphere/AppServer/profiles/Custom01
Java Home = /usr/IBM/WebSphere/AppServer/java/jre
ws.ext.dirs = /usr/IBM/WebSphere/AppServer/java/lib:/usr/IBM/WebSphere/AppServer/profiles/Custom01/classes:/usr/IBM/WebSphere/AppServer/classes:/usr/IBM/WebSphere/AppServer/lib:/usr/IBM/WebSphere/AppServer/installedChannels:/usr/IBM/WebSphere/AppServer/lib/ext:/usr/IBM/WebSphere/AppServer/web/help:/usr/IBM/WebSphere/AppServer/deploytool/itp/plugins/com.ibm.etools.ejbdeploy/runtime:/home/flexapp/FCBDEVCluster/thirdpartyjars
Classpath = /usr/IBM/WebSphere/AppServer/profiles/Custom01/properties:/usr/IBM/WebSphere/AppServer/properties:/usr/IBM/WebSphere/AppServer/lib/bootstrap.jar:/usr/IBM/WebSphere/AppServer/lib/j2ee.jar:/usr/IBM/WebSphere/AppServer/lib/lmproxy.jar:/usr/IBM/WebSphere/AppServer/lib/urlprotocols.jar:/home/flexapp/FCBDEVCluster/FCBDEV01/flexcube/host/runarea/env
Java Library path = /usr/IBM/WebSphere/AppServer/java/jre/bin:/usr/IBM/WebSphere/AppServer/java/jre/bin/classic:/usr/IBM/WebSphere/AppServer/java/jre/bin:/usr/IBM/WebSphere/AppServer/bin:/usr/mqm/java/lib:/usr/opt/wemps/lib:/usr/IBM/WebSphere/AppServer/java/jre/bin/sovvm:/usr/IBM/WebSphere/AppServer/java/jre/bin/sovvm:/usr/IBM/WebSphere/AppServer/java/jre/bin/sovvm:/usr/IBM/WebSphere/AppServer/java/jre/bin/sovvm:/usr/lib
************* End Display Current Environment *************
EOS
    )
  end
  
  def test_pid
    assert_equal '938208',@env.pid
  end

  def test_servername
    assert_equal 'FCBINGN1DEVServer1',@env.servername
  end

end  

