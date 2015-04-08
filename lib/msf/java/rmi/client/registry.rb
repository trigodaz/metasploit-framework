# -*- coding: binary -*-

module Msf
  module Java
    module Rmi
      module Client
        # This mixin provides methods to simulate calls to the Java java/rmi/registry/RegistryImpl_Stub
        # interface
        module Registry
          require 'msf/java/rmi/client/registry/builder'
          require 'msf/java/rmi/client/registry/parser'

          include Msf::Java::Rmi::Client::Registry::Builder
          include Msf::Java::Rmi::Client::Registry::Parser

          # Sends a Registry lookup call to the RMI endpoint. Simulates a call to the Java
          # java/rmi/registry/RegistryImpl_Stub#lookup() method.
          #
          # @param opts [Hash]
          # @option opts [Rex::Socket::Tcp] :sock
          # @return [Hash, NilClass] The remote reference information if success, nil otherwise
          # @raise [Rex::Proto::Rmi::Exception] if the endpoint raises a remote exception
          # @see Msf::Java::Rmi::Client::Registry::Builder.build_registry_lookup
          def send_registry_lookup(opts = {})
            send_call(
              sock: opts[:sock] || sock,
              call: build_registry_lookup(opts)
            )

            return_value = recv_return(
              sock: opts[:sock] || sock
            )

            if return_value.nil?
              return nil
            end

            if return_value.is_exception?
              raise ::Rex::Proto::Rmi::Exception, return_value.get_class_name
            end

            remote_object = return_value.get_class_name

            if remote_object.nil?
              return nil
            end

            remote_location = parse_registry_lookup_endpoint(return_value)

            if remote_location.nil?
              return nil
            end

            remote_location.merge(object: remote_object)
          end

          # Sends a Registry list call to the RMI endpoint. Simulates a call to the Java
          # java/rmi/registry/RegistryImpl_Stub#list() method
          #
          # @param opts [Hash]
          # @option opts [Rex::Socket::Tcp] :sock
          # @return [Array, NilClass] The set of names if success, nil otherwise
          # @raise [Rex::Proto::Rmi::Exception] if the endpoint raises a remote exception
          # @see Msf::Java::Rmi::Client::Registry::Builder.build_registry_list
          def send_registry_list(opts = {})
            send_call(
              sock: opts[:sock] || sock,
              call: build_registry_list(opts)
            )

            return_value = recv_return(
              sock: opts[:sock] || sock
            )

            if return_value.nil?
              return nil
            end

            if return_value.is_exception?
              raise ::Rex::Proto::Rmi::Exception, return_value.get_class_name
            end

            names = parse_registry_list(return_value)

            names
          end

          # Calculates the hash to make RMI calls for the
          # java/rmi/registry/RegistryImpl_Stub interface
          #
          # @return [Fixnum] The interface's hash
          def registry_interface_hash
            hash = calculate_interface_hash(
              [
                {
                  name: 'bind',
                  descriptor: '(Ljava/lang/String;Ljava/rmi/Remote;)V',
                  exceptions: ['java.rmi.AccessException', 'java.rmi.AlreadyBoundException', 'java.rmi.RemoteException']
                },
                {
                  name: 'list',
                  descriptor: '()[Ljava/lang/String;',
                  exceptions: ['java.rmi.AccessException', 'java.rmi.RemoteException']
                },
                {
                  name: 'lookup',
                  descriptor: '(Ljava/lang/String;)Ljava/rmi/Remote;',
                  exceptions: ['java.rmi.AccessException', 'java.rmi.NotBoundException', 'java.rmi.RemoteException']
                },
                {
                  name: 'rebind',
                  descriptor: '(Ljava/lang/String;Ljava/rmi/Remote;)V',
                  exceptions: ['java.rmi.AccessException', 'java.rmi.RemoteException']
                },
                {
                  name: 'unbind',
                  descriptor: '(Ljava/lang/String;)V',
                  exceptions: ['java.rmi.AccessException', 'java.rmi.NotBoundException', 'java.rmi.RemoteException']
                }
              ]
            )

            hash
          end
        end
      end
    end
  end
end
