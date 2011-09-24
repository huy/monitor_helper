require 'test/unit'

require File.dirname(__FILE__) + '/../lib/system_out_err.rb'

class TestErrorMessage < Test::Unit::TestCase

  def setup
     @event = WAS::NormalEvent.parse(
<<EOS
[10/6/08 15:05:41:539 JST] 00000039 MCWrapper     E   J2CA0081E: Method cleanup failed while trying to execute method cleanup on ManagedConnection WSRdbManagedConnectionImpl@de682a2 from resource jdbc/FCBN1DEVDataSource. Caught exception: com.ibm.ws.exception.WsException: DSRA0080E: An exception was received by the Data Store Adapter. See original exception message: Cannot call 'cleanup' on a ManagedConnection while it is still in a transaction..
	at com.ibm.ws.rsadapter.exceptions.DataStoreAdapterException.<init>(DataStoreAdapterException.java(Compiled Code))
	at com.ibm.ws.rsadapter.exceptions.DataStoreAdapterException.<init>(DataStoreAdapterException.java(Compiled Code))
	at com.ibm.ws.rsadapter.AdapterUtil.createDataStoreAdapterException(AdapterUtil.java(Compiled Code))
	at com.ibm.ws.rsadapter.spi.WSRdbManagedConnectionImpl.cleanupTransactions(WSRdbManagedConnectionImpl.java(Compiled Code))
	at com.ibm.ws.rsadapter.spi.WSRdbManagedConnectionImpl.cleanup(WSRdbManagedConnectionImpl.java(Compiled Code))
	at com.ibm.ejs.j2c.MCWrapper.cleanup(MCWrapper.java(Compiled Code))
	at com.ibm.ejs.j2c.poolmanager.FreePool.returnToFreePool(FreePool.java(Compiled Code))
	at com.ibm.ejs.j2c.poolmanager.PoolManager.release(PoolManager.java(Compiled Code))
	at com.ibm.ejs.j2c.MCWrapper.releaseToPoolManager(MCWrapper.java(Inlined Compiled Code))
	at com.ibm.ejs.j2c.ConnectionEventListener.connectionClosed(ConnectionEventListener.java(Compiled Code))
	at com.ibm.ws.rsadapter.spi.WSRdbManagedConnectionImpl.processConnectionClosedEvent(WSRdbManagedConnectionImpl.java(Compiled Code))
	at com.ibm.ws.rsadapter.jdbc.WSJdbcConnection.closeWrapper(WSJdbcConnection.java(Compiled Code))
	at com.ibm.ws.rsadapter.jdbc.WSJdbcObject.close(WSJdbcObject.java(Compiled Code))
	at com.ibm.ws.rsadapter.jdbc.WSJdbcObject.close(WSJdbcObject.java(Compiled Code))
	at com.iflex.fcr.infra.jdbc.FCRJConnection.closeConnection(FCRJConnection.java(Compiled Code))
	at com.iflex.fcr.infra.jdbc.FCRJConnection.closeConnection(FCRJConnection.java(Compiled Code))
	at com.iflex.fcr.bh.upload.SchedFileController.startSchedFiles(SchedFileController.java(Compiled Code))
	at com.iflex.fcr.bh.upload.SchedFileController.startProcessing(SchedFileController.java(Compiled Code))
	at com.iflex.fcr.bh.upload.SchedFileController.run(SchedFileController.java:128)

EOS
     )
  end

  def test_timestamp
    assert_equal '15:05:41 06/10/2008',@event.timestamp.strftime("%H:%M:%S %d/%m/%Y")
  end

  def test_thread_id
    assert_equal '00000039',@event.thread_id
  end

  def test_component
    assert_equal 'MCWrapper',@event.component
  end

  def test_event_type
    assert_equal 'E',@event.event_type
  end

  def test_message_id
    assert_equal 'J2CA0081E',@event.message_id
  end

  def test_message
    assert_match /\AMethod cleanup failed while trying to execute method cleanup/, @event.message
    assert_match /at com.iflex.fcr.bh.upload.SchedFileController.run\(SchedFileController.java:128\)\s*\z/,@event.message
  end

end

class TestNormalEventParse < Test::Unit::TestCase

  def test_parse
     event = WAS::NormalEvent.parse(
<<EOS
[10/31/08 17:44:05:605 JST] 00000108 DefaultLoadEv I org.hibernate.event.def.DefaultLoadEventListener onLoad Error performing load command
                                 org.hibernate.ObjectNotFoundException: No row with the given identifier exists: [com.iflex.fcr.entity.udf.MaintenanceLogData#com.iflex.fcr.entity.udf.MaintenanceLogData@0]
	at org.hibernate.ObjectNotFoundException.throwIfNull(ObjectNotFoundException.java(Compiled Code))
	at org.hibernate.event.def.DefaultLoadEventListener.load(DefaultLoadEventListener.java(Compiled Code))
	at org.hibernate.event.def.DefaultLoadEventListener.proxyOrLoad(DefaultLoadEventListener.java(Compiled Code))
	at org.hibernate.event.def.DefaultLoadEventListener.onLoad(DefaultLoadEventListener.java(Compiled Code))
	at org.hibernate.impl.SessionImpl.fireLoad(SessionImpl.java(Compiled Code))
	at org.hibernate.impl.SessionImpl.load(SessionImpl.java:781)
	at org.hibernate.impl.SessionImpl.load(SessionImpl.java:774)
	at com.iflex.fcr.infra.das.orm.hibernate.HibernateSessionWrapper.load(HibernateSessionWrapper.java:403)
	at com.iflex.fcr.infra.das.orm.hibernate.HibernateDataAccessor$2.workInSession(HibernateDataAccessor.java:242)
	at com.iflex.fcr.infra.das.orm.hibernate.HibernateDataAccessor.executeWithImplicitSession(HibernateDataAccessor.java:173)
	at com.iflex.fcr.infra.das.orm.hibernate.HibernateDataAccessor.execute(HibernateDataAccessor.java:95)
	at com.iflex.fcr.infra.das.orm.hibernate.HibernateDataAccessor.load(HibernateDataAccessor.java:239)
	at com.iflex.fcr.entity.common.PersistableEntity.load(PersistableEntity.java:101)
	at com.iflex.fcr.entity.common.MaintainableEntity.load(MaintainableEntity.java:976)
	at com.iflex.fcr.app.udf.UDFLogger.log(UDFLogger.java:474)
	at com.iflex.fcr.app.udf.UDFLogger.processUDFs(UDFLogger.java:196)
	at com.iflex.fcr.app.udf.UDFLogger.doLog(UDFLogger.java:139)
	at com.iflex.fcr.bh.mow.FCRJMntRootBean.initFunc(FCRJMntRootBean.java:2169)
	at com.iflex.fcr.bh.mow.FCRJMntRootBean.initFunc(FCRJMntRootBean.java:2236)
	at com.iflex.fcr.bh.mow.EJSRemoteStatelessFCRJMowMnt_a5ffb244.initFunc(Unknown Source)
	at com.iflex.fcr.bh.mow._FCRJMntRoot_Stub.initFunc(_FCRJMntRoot_Stub.java:295)
	at com.iflex.fcr.bh.mow.FCRJMntWebServiceBean.initFunc(Unknown Source)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java(Compiled Code))
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java(Compiled Code))
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java(Compiled Code))
	at java.lang.reflect.Method.invoke(Method.java(Compiled Code))
	at org.apache.soap.server.RPCRouter.invoke(Unknown Source)
	at org.apache.soap.providers.RPCJavaProvider.invoke(Unknown Source)
	at org.apache.soap.server.http.RPCRouterServlet.doPost(Unknown Source)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:763)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:856)
	at com.ibm.ws.webcontainer.servlet.ServletWrapper.service(ServletWrapper.java:1694)
	at com.ibm.ws.webcontainer.servlet.ServletWrapper.handleRequest(ServletWrapper.java:823)
	at com.ibm.ws.webcontainer.servlet.CacheServletWrapper.handleRequest(CacheServletWrapper.java:90)
	at com.ibm.ws.webcontainer.WebContainer.handleRequest(WebContainer.java:1936)
	at com.ibm.ws.webcontainer.channel.WCChannelLink.ready(WCChannelLink.java:116)
	at com.ibm.ws.http.channel.inbound.impl.HttpInboundLink.handleDiscrimination(HttpInboundLink.java:434)
	at com.ibm.ws.http.channel.inbound.impl.HttpInboundLink.handleNewInformation(HttpInboundLink.java:373)
	at com.ibm.ws.http.channel.inbound.impl.HttpInboundLink.ready(HttpInboundLink.java:253)
	at com.ibm.ws.tcp.channel.impl.NewConnectionInitialReadCallback.sendToDiscriminaters(NewConnectionInitialReadCallback.java:207)
	at com.ibm.ws.tcp.channel.impl.NewConnectionInitialReadCallback.complete(NewConnectionInitialReadCallback.java:109)
	at com.ibm.ws.tcp.channel.impl.WorkQueueManager.requestComplete(WorkQueueManager.java(Compiled Code))
	at com.ibm.ws.tcp.channel.impl.WorkQueueManager.attemptIO(WorkQueueManager.java(Compiled Code))
	at com.ibm.ws.tcp.channel.impl.WorkQueueManager.workerRun(WorkQueueManager.java(Compiled Code))
	at com.ibm.ws.tcp.channel.impl.WorkQueueManager$Worker.run(WorkQueueManager.java(Compiled Code))
	at com.ibm.ws.util.ThreadPool$Worker.run(ThreadPool.java(Compiled Code))

EOS
     )
     assert_not_nil event
  end

end


