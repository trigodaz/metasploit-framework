# -*- coding: binary -*-

module Msf
  module Java
    module Rmi
      module Client
        module Jmx
          module Server
            module Builder

              # Builds an RMI call to javax/management/remote/rmi/RMIServer_Stub#newClient()
              # used to enumerate the names bound in a registry
              #
              # @param opts [Hash]
              # @option opts [String] :username the JMX role to establish the connection if needed
              # @option opts [String] :password the JMX password to establish the connection if needed
              # @return [Rex::Proto::Rmi::Model::Call]
              # @see Msf::Java::Rmi::Builder.build_call
              def build_jmx_new_client(opts = {})
                object_number = opts[:object_number] || 0
                uid_number = opts[:uid_number] || 0
                uid_time = opts[:uid_time] || 0
                uid_count = opts[:uid_count] || 0
                username = opts[:username]
                password = opts[:password] || ''

                if username
                  arguments = build_jmx_new_client_args(username, password)
                else
                  arguments = [Rex::Java::Serialization::Model::NullReference.new]
                end

                call = build_call(
                  object_number: object_number,
                  uid_number: uid_number,
                  uid_time: uid_time,
                  uid_count: uid_count,
                  operation: -1,
                  hash: -1089742558549201240, # javax.management.remote.rmi.RMIServer.newClient
                  arguments: arguments
                )

                call
              end

              # Builds a Rex::Java::Serialization::Model::NewArray with credentials
              # to make an javax/management/remote/rmi/RMIServer_Stub#newClient call
              #
              # @param username [String] The username (role) to authenticate with
              # @param password [String] The password to authenticate with
              # @return [Array<Rex::Java::Serialization::Model::NewArray>]
              def build_jmx_new_client_args(username = '', password = '')
                builder = Rex::Java::Serialization::Builder.new

                auth_array = builder.new_array(
                  name: '[Ljava.lang.String;',
                  serial: Msf::Java::Rmi::Client::Jmx::STRING_ARRAY_UID, # serialVersionUID
                  values_type: 'java.lang.String;',
                  values: [
                    Rex::Java::Serialization::Model::Utf.new(nil, username),
                    Rex::Java::Serialization::Model::Utf.new(nil, password)
                  ]
                )

                [auth_array]
              end
            end
          end
        end
      end
    end
  end
end
