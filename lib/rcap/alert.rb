module RCAP
  module Alert

    XMLNS_KEY            = "xmlns"
    YAML_CAP_VERSION_KEY = "CAP Version"
    JSON_CAP_VERSION_KEY = "cap_version"

    CAP_NAMESPACES = [ RCAP::CAP_1_0::Alert::XMLNS, RCAP::CAP_1_1::Alert::XMLNS, RCAP::CAP_1_2::Alert::XMLNS ]

    # Initialise a RCAP Alert from a XML document. The namespace of the
    # document is inspected and a CAP_1_0::Alert, CAP_1_1::Alert
    # or CAP_1_2::Alert is instantiated.
    #
    # The namespace key ('cap' if the CAP document is stored under 'xmlns:cap')
    # can be specified explicitly by passing it in as a second parameter.
    def self.from_xml( xml, namespace_key = nil )
      xml_document = REXML::Document.new( xml )
      document_namespaces = xml_document.root.namespaces.invert
      namespace = namespace_key || CAP_NAMESPACES.find{ |namepsace| document_namespaces[ namepsace ]}

      case namespace
      when CAP_1_0::Alert::XMLNS
        CAP_1_0::Alert.from_xml_document( xml_document )
      when CAP_1_1::Alert::XMLNS
        CAP_1_1::Alert.from_xml_document( xml_document )
      else
        CAP_1_2::Alert.from_xml_document( xml_document )
      end
    end

    # Initialise a RCAP Alert from a YAML document produced by
    # CAP_1_2::Alert#to_yaml. The version of the document is inspected and a
    # CAP_1_0::Alert, CAP_1_1::Alert or CAP_1_2::Alert is instantiated.
    def self.from_yaml( yaml )
      yaml_data = YAML.load( yaml )

      case yaml_data[ YAML_CAP_VERSION_KEY ]
      when CAP_1_0::Alert::CAP_VERSION
        CAP_1_0::Alert.from_yaml_data( yaml_data )
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_yaml_data( yaml_data )
      else
        CAP_1_2::Alert.from_yaml_data( yaml_data )
      end
    end

    # Initialise a RCAP Alert from a JSON document produced by
    # CAP_1_2::Alert#to_json. The version of the document is inspected and a
    # CAP_1_0::Alert, CAP_1_1::Alert or CAP_1_2::Alert is instantiated.
    def self.from_json( json_string )
      json_hash = JSON.parse( json_string )
      self.from_h( json_hash )
    end

    def self.from_h( hash ) # :nodoc:
      case hash[ JSON_CAP_VERSION_KEY ]
      when CAP_1_0::Alert::CAP_VERSION
        CAP_1_0::Alert.from_h( hash )
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Alert.from_h( hash )
      else
        CAP_1_2::Alert.from_h( hash )
      end
    end
  end
end
