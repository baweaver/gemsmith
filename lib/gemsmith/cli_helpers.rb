module Gemsmith
  module CLIHelpers
    # Answers the gem name (snake case).
    # ==== Parameters
    # * +name+ - Optional. The gem name. Default: nil
    def gem_name name = nil
      @gem_name ||= Thor::Util.snake_case name
    end

    # Answers the gem class (camel case).
    # ==== Parameters
    # * +name+ - Optional. The gem class. Default: nil
    def gem_class name = nil
      @gem_class ||= Thor::Util.camel_case name
    end

    # Answers the gem install path.
    def install_path
      @install_path ||= File.join Dir.pwd, gem_name
    end

    # Answers all gem template options.
    def template_options
      @template_options
    end

    module_function

    # Builds template options with default and/or custom settings (where the custom
    # settings trump default settings).
    # ==== Parameters
    # * +name+ - Required. The gem name.
    # * +settings+ - Optional. The custom settings. Default: {}.
    # * +options+ - Optional. Additional command line options. Default: {}.
    def build_template_options name, settings = {}, options = {}
      gem_name name
      gem_class name
      author_name = settings[:author_name] || Gemsmith::Kit.git_config_value("user.name") || "TODO: Add full name here."
      author_email = settings[:author_email] || Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address here."
      author_url = settings[:author_url] || "https://www.unknown.com"

      @template_options = {
        gem_name: gem_name,
        gem_class: gem_class,
        gem_platform: (settings[:gem_platform] || "Gem::Platform::RUBY"),
        author_name: author_name,
        author_email: author_email,
        author_url: (author_url || "http://www.unknown.com"),
        gem_url: (settings[:gem_url] || author_url),
        company_name: (settings[:company_name] || author_name),
        company_url: (settings[:company_url] || author_url),
        github_user: (settings[:github_user] || Gemsmith::Kit.git_config_value("github.user") || "unknown"),
        year: (settings[:year] || Time.now.year),
        ruby_version: (settings[:ruby_version] || "2.0.0"),
        ruby_patch: (settings[:ruby_patch] || "p0"),
        rails_version: (settings[:rails_version] || "3.0"),
        post_install_message: settings[:post_install_message],
        bin: (options[:bin] || false),
        rails: (options[:rails] || false),
        pry: (options[:pry] || true),
        guard: (options[:guard] || true),
        rspec: (options[:rspec] || true),
        travis: (options[:travis] || true),
        code_climate: (options[:code_climate] || true)
      }
    end

    # Prints currently installed gem name and version information.
    # ===== Parameters
    # * +gems+ - Required. The array of gem names (i.e. gem specifications).
    def print_gem_versions gems
      say "Multiple versions found:"
      gems.each_with_index do |spec, index|
        say "#{index + 1}. #{spec.name} #{spec.version.version}"
      end
    end

    # Opens selected gem within default editor.
    # ===== Parameters
    # * +gems+ - Required. The array of gem names (i.e. gem specifications).
    def open_gem gems
      result = ask "Please pick one (or type 'q' to quit):"

      return if result == 'q' # Exit early.

      if (1..gems.size).include?(result.to_i)
        spec = Gem::Specification.find_by_name name, gems[result.to_i - 1].version.version
        `$EDITOR #{spec.full_gem_path}`
      else
        error "Invalid option: #{result}"
      end
    end
  end
end
