module RCAP
  module CAP_1_1
    # A Polygon object is valid if
    # * it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon
      include Validation

      # Collection of Point objects.
      attr_reader( :points )

      validates_length_of( :points, :minimum => 3 )
      validates_collection_of( :points )

      XML_ELEMENT_NAME = 'polygon'                   # :nodoc:
      XPATH            = "cap:#{ XML_ELEMENT_NAME }" # :nodoc:

      def initialize( attributes = {})
        @points = Array( attributes[ :points ])
      end

      # Creates a new Point object and adds it to the points array. The
      # poitn_attributes are passed as a parameter to Point.new.
      def add_point( point_attributes = {})
        point = Point.new( point_attributes )
        self.points << point
        point
      end

      # Returns a string representation of the polygon of the form
      #  points[0] points[1] points[2] ... points[n-1] points[0]
      # where each point is formatted with Point#to_s
      def to_s
        (@points + [ @points.first ]).join( ' ' )
      end

      def inspect # :nodoc:
        "(#{ @points.map{|point| point.inspect}.join(', ')})"
      end

      def to_xml_element # :nodoc:
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_text( self.to_s )
        xml_element
      end

      # Two polygons are equivalent if their collection of points is equivalent.
      def ==( other )
        self.points == other.points
      end

      def self.parse_polygon_string( polygon_string ) # :nodoc:
        polygon_string.split( ' ' ).map{ |coordinate_string| coordinate_string.split( ',' ).map{|coordinate| coordinate.to_f }}
      end

      def self.from_xml_element( polygon_xml_element ) # :nodoc:
        coordinates = self.parse_polygon_string( polygon_xml_element.text )
        points = coordinates.map{ |lattitude, longitude| Point.new( :lattitude => lattitude, :longitude => longitude )}[0..-2]
        polygon = self.new( :points => points )
      end


      def to_yaml( options = {} ) # :nodoc:
        yaml_points = self.points.map{ |point| [ point.lattitude, point.longitude ]}
        def yaml_points.to_yaml_style; :inline; end

        yaml_points.to_yaml( options )
      end

      def self.from_yaml_data( polygon_yaml_data ) # :nodoc:
        self.new(
                 :points => Array( polygon_yaml_data ).map{ |lattitude, longitude| Point.new( :lattitude => lattitude, :longitude => longitude )}
                )
      end

      POINTS_KEY  = 'points' # :nodoc:

      def to_h # :nodoc:
        { POINTS_KEY => self.points.map{ |point| point.to_h }}
      end

      def self.from_h( polygon_hash ) # :nodoc:
        self.new( :points => polygon_hash[ POINTS_KEY ].map{ |point_hash| Point.from_h( point_hash )})
      end
    end
  end
end
