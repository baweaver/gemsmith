# frozen_string_literal: true

module Gemsmith
  module Generators
    # Generates default gem support.
    class Gem < Base
      def run
        create_files
        cli.chmod "#{configuration.dig(:gem, :name)}/bin/setup", 0o755
      end

      private

      def create_files
        template "%gem_name%/bin/setup.tt"
        template "%gem_name%/Gemfile.tt"
        template "%gem_name%/%gem_name%.gemspec.tt"
        template "#{lib_gem_root}.rb.tt"
        template "#{lib_gem_root}/identity.rb.tt"
      end
    end
  end
end
