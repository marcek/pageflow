module Pageflow
  # Options to be defined in the pageflow initializer of the main app.
  class Configuration
    # Default options for paperclip attachments which are supposed to use
    # s3 storage.
    attr_accessor :paperclip_s3_default_options

    # String to interpolate into paths of files generated by paperclip
    # preprocessors. This allows to refresh cdn caches after
    # reprocessing attachments.
    attr_accessor :paperclip_attachments_version

    # Root folder in S3 bucket to store files in. Can be used to
    # separate files of multiple development instances in a shared
    # development S3 bucket.
    #
    # @since 13.0
    attr_accessor :paperclip_s3_root

    # Upload options provided to direct upload form.
    # Defaults to S3 storage options.
    # returns a hash with keys:
    # - url: The URL to use as the action of the form
    # - fields: A hash of fields that will be included in the direct upload form.
    #           This hash should include the signed POST policy, the access key ID and
    #           security token (if present), etc.
    #           These fields will be included as input elements of type 'hidden' on the form
    #
    # # @since 14.0
    attr_accessor :paperclip_direct_upload_options

    # Refer to the pageflow initializer template for a list of
    # supported options.
    attr_accessor :zencoder_options

    # Contains key and iv used to encrypt string
    # used by SymmetricEncryption
    attr_accessor :encryption_options

    # A constraint used by the pageflow engine to restrict access to
    # the editor related HTTP end points. This can be used to ensure
    # the editor is only accessable via a certain host when different
    # CNAMES are used to access the public end points of pageflow.
    attr_accessor :editor_route_constraint

    # The email address to use as from header in invitation mails to
    # new users
    attr_accessor :mailer_sender

    # Extend the configuration based on feature flags set for accounts
    # or entries.
    #
    # @example
    #
    # Make a widget type only available if a feature flag is set on the
    # entry or its account
    #
    #   config.features.register('some_special_widget_type' do |config
    #     config.widget_types.register(Pageflow::SomeSpecial.widget_type)
    #   end
    #
    # @since 0.9
    # @returns [Features}
    attr_reader :features

    # Subscribe to hooks in order to be notified of events. Any object
    # with a call method can be a subscriber
    #
    # Example:
    #
    #     config.hooks.subscribe(:submit_file, -> { do_something })
    #
    attr_reader :hooks

    # Limit the use of certain resources. Any object implementing the
    # interface of Pageflow::Quota can be registered.
    #
    # Example:
    #
    #     config.quotas.register(:users, UserQuota)
    #
    attr_accessor :quotas

    # Additional themes can be registered to use custom css.
    #
    # Example:
    #
    #     config.themes.register(:custom)
    #
    # @return [Themes]
    attr_reader :themes

    # Register new types of entries.
    # @return [EntryTypes]
    # @since 15.1
    attr_reader :entry_types

    # List of {FileType} instances.
    # Can be registered globally or provided by page types.
    # @return [FileTypes]
    attr_reader :file_types

    # Used to register components whose current state must be
    # persisted as part of a revision.
    # @return [RevisionComponents]
    attr_reader :revision_components

    # Used to register new types of widgets to be displayed in entries.
    # @return [WidgetTypes]
    attr_reader :widget_types

    # Used to register new file importers, to be used for importing files
    # @return [fileImporters]
    attr_reader :file_importers

    # Used to add new sections to the help dialog displayed in the
    # editor.
    #
    # @exmaple
    #
    #   config.help_entries.register('pageflow.rainbow.help_entries.colors', priority: 11)
    #   config.help_entries.register('pageflow.rainbow.help_entries.colors.blue',
    #                                parent: 'pageflow.rainbow.help_entries.colors')
    #
    # @since 0.7
    # @return [HelpEntries]
    attr_reader :help_entries

    # Paperclip style definitions of thumbnails used by Pageflow.
    # @return Hash
    attr_accessor :thumbnail_styles

    # Names of Paperclip styles that shall be rendered into entry
    # specific stylesheets.
    # @return Array<Symbol>
    attr_accessor :css_rendered_thumbnail_styles

    # Either a lambda or an object with a `match?` method, to restrict
    # access to the editor routes defined by Pageflow.
    #
    # This can be used if published entries shall be available under
    # different CNAMES but the admin and the editor shall only be
    # accessible via one official url.
    attr_accessor :editor_routing_constraint

    # Either a lambda or an object with a `call` method taking two
    # parameters: An `ActiveRecord` scope of {Pageflow::Theming} records
    # and an {ActionDispatch::Request} object. Has to return the scope
    # in which to find themings.
    #
    # Defaults to {CnameThemingRequestScope} which finds themings
    # based on the request subdomain. Can be used to alter the logic
    # of finding a theming whose home_url to redirect to when visiting
    # the public root path.
    #
    # Example:
    #
    #     config.theming_request_scope = lambda do |themings, request|
    #       themings.where(id: Pageflow::Account.find_by_name!(request.subdomain).default_theming_id)
    #     end
    attr_accessor :theming_request_scope

    # Either a lambda or an object with a `call` method taking two
    # parameters: An `ActiveRecord` scope of `Pageflow::Entry` records
    # and an `ActionDispatch::Request` object. Has to return the scope
    # in which to find entries.
    #
    # Used by all public actions that display entries to restrict the
    # available entries by hostname or other request attributes.
    #
    # Use {#public_entry_url_options} to make sure urls of published
    # entries conform twith the restrictions.
    #
    # Example:
    #
    #     # Only make entries of one account available under <account.name>.example.com
    #     config.public_entry_request_scope = lambda do |entries, request|
    #       entries.includes(:account).where(pageflow_accounts: {name: request.subdomain})
    #     end
    attr_accessor :public_entry_request_scope

    # Either a lambda or an object with a `call` method taking an
    # {Entry} record and an {ActionDispatch::Request} object and
    # returning `nil` or a path to redirect to. Can be used in
    # conjuction with {PrimaryDomainEntryRedirect} to make sure
    # entries are accessed via their account's configured cname.
    #
    # @since 12.4
    attr_accessor :public_entry_redirect

    # Either a lambda or an object with a `call` method taking a
    # {Theming} as paramater and returing a hash of options used to
    # construct the url of a published entry.
    #
    # Can be used to change the host of the url under which entries
    # are available.
    #
    # Example:
    #
    #     config.public_entry_url_options = lambda do |theming|
    #       {host: "#{theming.account.name}.example.com"}
    #     end
    attr_accessor :public_entry_url_options

    # Either a lambda or an object with a `call` method taking a
    # {Theming} as paramater and returing a hash of options used to
    # construct the embed url of a published entry.
    attr_accessor :entry_embed_url_options

    # Submit video/audio encoding jobs only after the user has
    # explicitly confirmed in the editor. Defaults to false.
    attr_accessor :confirm_encoding_jobs

    # Used by Pageflow extensions to provide new tabs to be displayed
    # in the admin.
    #
    # @example
    #
    #     config.admin_resource_tabs.register(:entry, Admin::CustomTab)
    #
    # @return [Admin::Tabs]
    attr_reader :admin_resource_tabs

    # Add custom form fields to admin forms.
    #
    # @example
    #
    #     config.admin_form_inputs.register(:entry, :custom_field) do
    #
    # @since 0.9
    # @return [Admin::FormInputs]
    attr_reader :admin_form_inputs

    # Insert additional rows into admin attributes tables.
    #
    # @example
    #
    #     config.admin_attributes_table_rows.register(:entry, :custom)
    #     config.admin_attributes_table_rows.register(:entry, :my_attribute, after: :title)
    #     config.admin_attributes_table_rows.register(:entry, :some_attribute, before: :updated_at)
    #
    # @example Custom content
    #
    #     config.admin_attributes_table_rows.register(:entry, :custom) do |entry|
    #       span(entry.custom_attribute)
    #     end
    #
    # @since 12.2
    # @return [Admin::AttributesTableRows]
    attr_reader :admin_attributes_table_rows

    # Array of locales which can be chosen as interface language by a
    # user. Defaults to `[:en, :de]`.
    # @since 0.7
    attr_accessor :available_locales

    # Array of locales which can be chosen as interface language for
    # an entry. Defaults to the locales supported by the
    # `pageflow-public-i18n` gem.
    # @since 0.10
    attr_accessor :available_public_locales

    # Array of sharing providers which can be configured on theming level.
    # Defaults to `[:facebook, :twitter, :linked_in, :whats_app, :telegram, :email]`.
    # @since 14.1
    attr_accessor :available_share_providers

    # How to handle https requests for URLs which will have assets in the page.
    # If you wish to serve all assets over http and prevent mixed-content warnings,
    # you can force a redirect to http. The inverse is also true: you can force
    # a redirect to https for all http requests.
    #
    # @example
    #
    #     config.public_https_mode = :prevent (default) # => redirects https to http
    #     config.public_https_mode = :enforce # => redirects http to https
    #     config.public_https_mode = :ignore # => does nothing
    # @since 0.9
    attr_accessor :public_https_mode

    # Meta tag defaults.
    #
    # These defaults will be included in the page <head> unless overriden by the Entry.
    # If you set these to <tt>nil</tt> or <tt>""</tt> the meta tag won't be included.
    # @since 0.10
    attr_accessor :default_keywords_meta_tag
    attr_accessor :default_author_meta_tag
    attr_accessor :default_publisher_meta_tag

    # Share provider defaults.
    #
    # Default share providers for new themings.
    # Must be a subset or equal to `available_share_providers`
    # @since 14.1
    attr_accessor :default_share_providers

    # Whether a user can be deleted.
    #
    # @example
    #
    #     config.authorize_user_deletion =
    #       lambda do |user_to_delete|
    #         if user_to_delete.accounts.all? { |account| account.users.size > 1 }
    #           true
    #         else
    #           'Last user on account. Permission denied'
    #         end
    #       end
    # @since 0.11
    attr_accessor :authorize_user_deletion

    # Array of values that the `kind` attribute on text tracks can
    # take. Defaults to `[:captions, :subtitles, :descriptions]`.
    attr_reader :available_text_track_kinds

    # Allow one user to be member of multiple accounts. Defaults to
    # true.
    # @since 12.1
    attr_accessor :allow_multiaccount_users

    # Options hash for account admin menu. Options from config precede
    # defaults.
    # @since 12.1
    attr_accessor :account_admin_menu_options

    # Sublayer for permissions related config.
    # @since 12.1
    attr_reader :permissions

    # Defines the editor lock polling interval.
    # @return [number]
    # @since 12.1
    attr_accessor :edit_lock_polling_interval

    # News collection to add items to. Can be used to integrate
    # Pageflow with Krant (see https://github.com/codevise/krant).
    # @return [#item]
    # @since 12.2
    attr_accessor :news

    def initialize(target_type_name = nil)
      @target_type_name = target_type_name

      @paperclip_attachments_version = 'v1'
      @paperclip_s3_root = 'main'

      @paperclip_s3_default_options = Defaults::PAPERCLIP_S3_DEFAULT_OPTIONS.dup

      @paperclip_direct_upload_options = lambda { |attachment|
        max_upload_size = 4_294_967_296 # max file size in bytes
        presigned_post_config = attachment.s3_bucket
                                          .presigned_post(key: attachment.path,
                                                          success_action_status: '201',
                                                          acl: 'public-read',
                                                          content_length_range: 0..max_upload_size)
        {
          url: presigned_post_config.url,
          fields: presigned_post_config.fields
        }
      }

      @zencoder_options = {}

      @encryption_options = {}

      @mailer_sender = 'pageflow@example.com'

      @features = Features.new
      @hooks = Hooks.new
      @quotas = Quotas.new
      @themes = Themes.new
      @entry_types = EntryTypes.new
      @entry_type_configs = {}
      @entry_type_configure_blocks = Hash.new { |h, k| h[k] = [] }
      @file_types = FileTypes.new
      @widget_types = WidgetTypes.new
      @file_importers = FileImporters.new
      @help_entries = HelpEntries.new
      @revision_components = RevisionComponents.new

      @thumbnail_styles = Defaults::THUMBNAIL_STYLES.dup
      @css_rendered_thumbnail_styles = Defaults::CSS_RENDERED_THUMBNAIL_STYLES.dup

      @theming_request_scope = CnameThemingRequestScope.new
      @public_entry_request_scope = lambda { |entries, request| entries }
      @public_entry_redirect = ->(_entry, _request) { nil }
      @public_entry_url_options = Pageflow::ThemingsHelper::DEFAULT_PUBLIC_ENTRY_OPTIONS
      @entry_embed_url_options = {protocol: 'https'}

      @confirm_encoding_jobs = false

      @admin_resource_tabs = Pageflow::Admin::Tabs.new
      @admin_form_inputs = Pageflow::Admin::FormInputs.new
      @admin_attributes_table_rows = Pageflow::Admin::AttributesTableRows.new

      @available_locales = [:en, :de]
      @available_public_locales = PublicI18n.available_locales
      @available_share_providers = [:email, :facebook, :linked_in, :twitter, :telegram, :whats_app]

      @public_https_mode = :prevent

      @default_keywords_meta_tag = 'pageflow, multimedia, reportage'
      @default_author_meta_tag = 'Pageflow'
      @default_publisher_meta_tag = 'Pageflow'

      @default_share_providers = @available_share_providers

      @authorize_user_deletion = lambda { |_user| true }

      @available_text_track_kinds = [:captions, :subtitles, :descriptions]

      @allow_multiaccount_users = true

      @account_admin_menu_options = {}

      @permissions = Permissions.new

      @edit_lock_polling_interval = 15.seconds
    end

    # Activate a plugin.
    #
    # @param [Plugin] plugin
    # @since 0.7
    def plugin(plugin)
      plugin.configure(self)
    end

    # Provide backwards compatibility as long as paged entry type has
    # not been extracted completely. Prefer accessing entry type
    # specific config via {#for_entry_type} for new code.
    #
    # @return {PageTypes}
    # @since 0.7
    def page_types
      get_entry_type_config(PageflowPaged.entry_type).page_types
    end

    # @deprecated Use `config.page_types.register` instead.
    def register_page_type(page_type)
      ActiveSupport::Deprecation.warn('Pageflow::Configuration#register_page_type is deprecated. Use config.page_types.register instead.', caller)
      page_types.register(page_type)
    end

    # @deprecated Pageflow now supports direct uploads to S3 via signed post requests.
    # Please change your forms accordingly.
    def paperclip_filesystem_root
      ActiveSupport::Deprecation.warn('Pageflow::Configuration#paperclip_filesystem_root is deprecated.', caller)
    end

    def paperclip_filesystem_root=(_val)
      ActiveSupport::Deprecation.warn('Pageflow::Configuration#paperclip_filesystem_root is deprecated.', caller)
    end

    # Scope configuration to entries of a certain entry type or access
    # entry type specific configuration. When building a configuration
    # object for an entry, the passed block is only evaluated when
    # types match. When building `Pageflow.config`, all
    # `for_entry_type` blocks are evaluated.
    #
    # @param [EntryType] type
    #
    # @yieldparam [EntryTypeConfiguration] entry_type_config -
    #   Instance of configuration class passed as `configuration`
    #   option during registration of entry type.
    #
    # @since 15.1
    def for_entry_type(type)
      return if @target_type_name && @target_type_name != type.name

      yield get_entry_type_config(type)
    end

    # @api private
    def get_entry_type_config(type)
      @entry_type_configs[type.name] ||= type.configuration.new(self, type)
    end

    # @api private
    def lint!
      @features.lint!
    end

    # @api private
    def theming_url_options(theming)
      options = public_entry_url_options
      options.respond_to?(:call) ? options.call(theming) : options
    end

    # @api private
    def enable_features(names)
      features.enable(names, FeatureLevelConfiguration.new(self))
    end

    # @api private
    def enable_all_features
      features.enable_all(FeatureLevelConfiguration.new(self))
    end

    # Restricts the configuration interface to those parts which can
    # be used from inside features.
    FeatureLevelConfiguration = Struct.new(:config) do
      delegate :page_types, to: :config
      delegate :widget_types, to: :config
      delegate :help_entries, to: :config
      delegate :admin_form_inputs, to: :config
      delegate :admin_attributes_table_rows, to: :config
      delegate :themes, to: :config
      delegate :file_importers, to: :config

      delegate :for_entry_type, to: :config
    end

    # @api private
    class ConfigView
      def initialize(config, entry_type)
        @config = config
        @entry_type_config = config.get_entry_type_config(entry_type)
      end

      def method_missing(method, *args)
        if @config.respond_to?(method)
          @config.send(method, *args)
        elsif @entry_type_config.respond_to?(method)
          @entry_type_config.send(method, *args)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @config.respond_to?(method_name) ||
          @entry_type_config.respond_to?(method_name) ||
          super
      end
    end
  end
end
