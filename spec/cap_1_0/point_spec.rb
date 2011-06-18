require 'spec_helper'

describe( RCAP::CAP_1_0::Point ) do
  describe( 'is not valid if' ) do
    before( :each ) do
      @point = RCAP::CAP_1_0::Point.new( :lattitude => 0, :longitude => 0 )
      @point.should( be_valid )
    end

    it( 'does not have a longitude defined' ) do
      @point.longitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid longitude' ) do
      @point.longitude = RCAP::CAP_1_0::Point::MAX_LONGITUDE + 1
      @point.should_not( be_valid )
      @point.longitude = RCAP::CAP_1_0::Point::MIN_LONGITUDE - 1
      @point.should_not( be_valid )
    end

    it( 'does not have a lattitude defined' ) do
      @point.lattitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid lattitude' ) do
      @point.lattitude = RCAP::CAP_1_0::Point::MAX_LATTITUDE + 1
      @point.should_not( be_valid )
      @point.lattitude = RCAP::CAP_1_0::Point::MIN_LATTITUDE - 1
      @point.should_not( be_valid )
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @point = RCAP::CAP_1_0::Point.new( :lattitude => 1, :longitude => 1 )
    end

    context( 'to hash' ) do
      it( 'should export correctly' ) do
        @point.to_h.should == { RCAP::CAP_1_0::Point::LATTITUDE_KEY => 1, RCAP::CAP_1_0::Point::LONGITUDE_KEY => 1 }
      end
    end
  end
end
