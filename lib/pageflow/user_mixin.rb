module Pageflow
  # ActiveRecord related functionality of the Pageflow users.
  module UserMixin
    extend ActiveSupport::Concern

    include Suspendable

    attr_accessor :initial_account, :initial_role

    included do
      has_many :memberships, dependent: :destroy, class_name: 'Pageflow::Membership'
      has_many :entries,
               through: :memberships,
               class_name: 'Pageflow::Entry',
               source: :entity,
               source_type: 'Pageflow::Entry'
      has_many :membership_accounts,
               through: :memberships,
               class_name: 'Pageflow::Account',
               source: :entity,
               source_type: 'Pageflow::Account'

      has_many :revisions, class_name: 'Pageflow::Revision', foreign_key: :creator_id

      validates :first_name, :last_name, presence: true

      scope :admins, -> { where(admin: true) }
    end

    def admin?
      admin
    end

    def account_manager?
      role == 'account_manager'
    end

    def full_name
      [first_name, last_name] * ' '
    end

    def formal_name
      [last_name, first_name] * ', '
    end

    def locale
      super.presence || I18n.default_locale
    end

    def update_with_password(attributes)
      if needs_password?(attributes)
        super(attributes)
      else
        # remove the virtual current_password attribute update_without_password
        # doesn't know how to ignore it
        update_without_password(attributes.except(:current_password))
      end
    end

    def destroy_with_password(password)
      if valid_password?(password)
        destroy
        true
      else
        errors.add(:current_password, password.blank? ? :blank : :invalid)
        false
      end
    end

    module ClassMethods
      def roles_accessible_by(ability)
        ability.can?(:read, Account) ? ROLES : NON_ADMIN_ROLES
      end
    end

    private

    def needs_password?(attributes)
      attributes[:password].present?
    end
  end
end
