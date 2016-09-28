# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :occupations
  has_many :things, through: :occupations

  validates :name,
    presence: true,
    uniqueness: {
      case_sensitive: false
    },
    format: {
      # this validation to avoid conflict between name and email of different
      # users due signing in.
      with: /^[a-zA-Z0-9_\.]*$/,
      multiline: true
    }

    def associate(thing)
      unless [String, Thing].include?(thing.class)
        raise ArgumentError, 'argument must be String(title) or Thing(object)'
      end
      thing = Thing.find_by(title: thing) if thing.is_a?(String)
      return false if !thing || self.things.include?(thing)
      self.things << thing
      thing
    end
    # let authenticate with login. with help of
    # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    attr_accessor :login
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value", { value: login.downcase }]).first
      elsif conditions.has_key?(:name) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
    # let authenticate with login end
end
