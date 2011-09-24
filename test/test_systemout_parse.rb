require 'test/unit'

require File.dirname(__FILE__) + '/../lib/system_out_err.rb'

class TestParseSystemOut < Test::Unit::TestCase

  def test_normal_event
    systemout = WAS::SystemOutErr.parse(
<<EOS
[10/31/08 17:44:05:605 JST] 00000108 DefaultLoadEv I org.hibernate.event.def.DefaultLoadEventListener onLoad Error performing load command
                                 org.hibernate.ObjectNotFoundException: No row with the given identifier exists: [com.iflex.fcr.entity.udf.MaintenanceLogData#com.iflex.fcr.entity.udf.MaintenanceLogData@0]
EOS
    )

    assert 1, systemout.events.size
    assert_not_nil systemout.events.first

    assert_match /ObjectNotFoundException/,systemout.events.first.message
  end

  def test_event_missing_some_part
        systemout = WAS::SystemOutErr.parse(
<<EOS
[12/25/08 11:58:42:091 JST] 0000020f WASLogger     E CLASSNAME METHODNAME rollback failed

[12/25/08 11:58:42:129 JST] 0000020f JMSExceptionL E   WMSG0018E: Error on JMSConnection for MDB FCRJSimulateTHBean , JMSDestination jms/FCBPROD

BatchShellQ2  : javax.jms.JMSException: MQJMS2002: failed to get message from MQ queue

        at com.ibm.mq.jms.services.ConfigEnvironment.newException(ConfigEnvironment.java:567)

        at com.ibm.mq.jms.MQSession.consume(MQSession.java:3113)

        at com.ibm.mq.jms.MQSession.run(MQSession.java:1612)

        at com.ibm.ejs.jms.JMSSessionHandle.run(JMSSessionHandle.java:968)

        at com.ibm.ejs.jms.listener.ServerSession.connectionConsumerOnMessage(ServerSession.java:862)

        at com.ibm.ejs.jms.listener.ServerSession.onMessage(ServerSession.java:627)

        at com.ibm.ejs.jms.listener.ServerSession.dispatch(ServerSession.java:594)

        at sun.reflect.GeneratedMethodAccessor50.invoke(Unknown Source)

        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java(Compiled Code))

        at java.lang.reflect.Method.invoke(Method.java(Compiled Code))

        at com.ibm.ejs.jms.listener.ServerSessionDispatcher.dispatch(ServerSessionDispatcher.java:37)

        at com.ibm.ejs.container.MDBWrapper.onMessage(MDBWrapper.java:91)

        at com.ibm.ejs.container.MDBWrapper.onMessage(MDBWrapper.java:127)

        at com.ibm.ejs.jms.listener.ServerSession.run(ServerSession.java:479)

        at com.ibm.ws.util.ThreadPool$Worker.run(ThreadPool.java(Compiled Code))

---- Begin backtrace for Nested Throwables

com.ibm.mq.MQException: MQJE001: Completion Code 2, Reason 2019

        at com.ibm.mq.jms.MQSession.consume(MQSession.java:3087)

        at com.ibm.mq.jms.MQSession.run(MQSession.java:1612)

        at com.ibm.ejs.jms.JMSSessionHandle.run(JMSSessionHandle.java:968)

        at com.ibm.ejs.jms.listener.ServerSession.connectionConsumerOnMessage(ServerSession.java:862)

        at com.ibm.ejs.jms.listener.ServerSession.onMessage(ServerSession.java:627)

        at com.ibm.ejs.jms.listener.ServerSession.dispatch(ServerSession.java:594)

        at sun.reflect.GeneratedMethodAccessor50.invoke(Unknown Source)

        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java(Compiled Code))

        at java.lang.reflect.Method.invoke(Method.java(Compiled Code))

        at com.ibm.ejs.jms.listener.ServerSessionDispatcher.dispatch(ServerSessionDispatcher.java:37)

        at com.ibm.ejs.container.MDBWrapper.onMessage(MDBWrapper.java:91)

        at com.ibm.ejs.container.MDBWrapper.onMessage(MDBWrapper.java:127)

        at com.ibm.ejs.jms.listener.ServerSession.run(ServerSession.java:479)

        at com.ibm.ws.util.ThreadPool$Worker.run(ThreadPool.java(Compiled Code))
EOS
    )

    assert 2, systemout.events.size

    assert_equal 'E',systemout.events.last.event_type
    assert_equal 'WMSG0018E',systemout.events.last.message_id
  end

end

