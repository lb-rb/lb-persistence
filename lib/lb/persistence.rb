# frozen_string_literal: true

# ROM
require 'rom'
require 'rom-sql'

require 'lb/persistence/types'
require 'lb/persistence/settings'

# Helpers
require 'lb/persistence/relation/joins'
require 'lb/persistence/model/attributes'
require 'lb/persistence/functions'

# LB namespace
module LB
  # Persistence
  class Persistence
    attr_reader :settings

    def initialize(settings)
      @settings = settings
    end

    # Get ROM container
    #
    # @return [ROM::Conatainer]
    #
    # @api private
    #
    def container
      @container ||= rom_setup(uri)
    end

    # Get ROM Repository instance for Repository class
    #
    # @return [ROM::Repository]
    #
    # @api private
    #
    def repository(repository)
      repository.new(container)
    end

    # Connect to database definied by given URI
    #
    # @param [String]
    #
    # @return [Sequel::Database]
    #
    # @api private
    #
    def connect(uri)
      Sequel.connect(uri)
    end

    # Configure ROM for given connection or URI
    #
    # @param [Sequel::Database | String]
    #
    # @return [ROM::Configuration]
    #
    # @api private
    #
    def configure_for(connection)
      configure(configuration_for(connection))
    end

    # Get URI
    #
    # @return [String]
    #
    # @api private
    #
    def uri
      @uri ||= settings.database_uri
    end

    # Create ROM container for given config
    #
    # @param [ROM::Configuration] config
    #
    # @return [ROM::Container]
    #
    # @api private
    #
    def container_from(config)
      ROM.container(config)
    end

    # Create ROM configuration for given connection or URI
    #
    # @param [Sequel::Database | String]
    #
    # @return [ROM::Configuration]
    #
    # @api private
    #
    def configuration_for(connection)
      ROM::Configuration.new(:sql, connection)
    end

    private

    # Setup rom for given URI
    #
    # @param [String]
    #
    # @return [ROM::Conatainer]
    #
    # @api private
    #
    def rom_setup(uri)
      container_from(configure_for(uri))
    end

    # Configure ROM
    #
    # @param [ROM::Configuration] config
    #
    # @return [ROM::Configuration]
    #
    # @api private
    #
    def configure(config)
      config.auto_registration(settings.source_dir, options)

      config
    end

    # Get ROM auto registration options
    #
    # @param [IO] source
    # @param [IO] target
    #
    # @return [Hash]
    #
    # @api private
    #
    def options
      {
        component_dirs: {
          relations: :relations,
          commands: :commands,
          mappers: :mappers
        },
        namespace: settings.namespace
      }
    end
  end
end
