require 'test_helper'

class PhixterTest < ActiveSupport::TestCase
  def test_basic
    phixter = Factory(:phixter)
    assert( phixter.valid? )
  end
  
  def test_default_status
    phixter = Factory.build(:phixter, :status => nil)
    
    assert_equal( nil, phixter.status )
    phixter.save!
    assert_equal( Phixter::STATUS[:UKNOWN], phixter.status )  
  end
  
  def test_uri_validation
    assert( !Factory.build(:phixter, :uri => '' ).valid? )
    assert( !Factory.build(:phixter, :uri => ':300' ).valid? )
    assert( !Factory.build(:phixter, :uri => 'wadus:300' ).valid? )
    assert( Factory.build(:phixter, :uri => 'wadus.wadus:300' ).valid? )
  end
  
  def test_uri_address
    phixter = Factory(:phixter, :uri => 'wadus.wadus:2000' )
    assert_equal( 'wadus.wadus', phixter.uri_address )
  end
  
  def test_uri_port
    phixter = Factory(:phixter, :uri => 'wadus.wadus:2000' )
    assert_equal( '2000', phixter.uri_port )
  end

  def test_check_with_ok
    phixter = Factory(:phixter, :uri => '127.0.0.1:2000' )
    
    string_io = StringIO.new    
    TCPSocket.expects(:open).with( '127.0.0.1', '2000' ).returns( string_io )
    string_io.expects(:write).with( phixter.value )
    
    assert_difference "HistoryEvent.count", 1 do
      assert_equal( Phixter::STATUS[:OK], phixter.check )      
    end
    
    assert_equal( Phixter::STATUS[:OK], phixter.status )
    assert_equal( Phixter::STATUS[:OK], phixter.history_events.last.status )
    assert_equal( nil, phixter.history_events.last.comment )
  end
    
  def test_check_with_error
    TCPSocket.expects(:open).with( '127.0.0.1', '2000' ).raises( Exception, 'wadus error' )
    
    phixter = Factory(:phixter, :uri => '127.0.0.1:2000' )
    
    assert_difference "HistoryEvent.count", 1 do
      assert_equal( Phixter::STATUS[:ERROR], phixter.check )      
    end
    
    assert_equal( Phixter::STATUS[:ERROR], phixter.status )
    assert_equal( Phixter::STATUS[:ERROR], phixter.history_events.last.status )
    assert_equal( 'wadus error', phixter.history_events.last.comment )
  end
end
