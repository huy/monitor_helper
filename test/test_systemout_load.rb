require 'test/unit'

require File.dirname(__FILE__) + '/../lib/system_out_err.rb'

class TestLoadSystemOut < Test::Unit::TestCase

  def setup
    @parsed = WAS::SystemOutErr.parse(File.read('SystemOut.log'))
    @parsed.save("SystemOut.yml")
    @loaded = WAS::SystemOutErr.load("SystemOut.yml") 
  end

  def test_events_size
    assert_equal @parsed.events.size, @loaded.events.size 
  end

  def test_event_detail
    assert_equal @parsed.events[0].timestamp, @loaded.events[0].timestamp
    assert_equal @parsed.events[0].message_id, @loaded.events[0].message_id
    assert_equal @parsed.events[0].message, @loaded.events[0].message
  end

end

