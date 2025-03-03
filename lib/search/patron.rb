module Search
  module Patron
    def self.for(uniqname, session_affiliation = nil)
      alma_response = AlmaRestClient.client.get("users/#{uniqname}")
      if alma_response.status == 200
        Alma.new(alma_response.body)
      else
        S.logger.error(alma_response.body)
        not_logged_in
      end
    rescue Faraday::Error => e
      S.logger.error(e.detailed_message)
      not_logged_in
    end

    def self.from_session(session, affiliation_param)
      FromSession.new(session, affiliation_param)
    end

    def self.not_logged_in
      NotLoggedIn.new
    end
  end
end

module Search
  module Patron
    module SessionHelper
      def to_h
        {
          email: email,
          sms: sms,
          campus: campus,
          affiliation: affiliation,
          logged_in: logged_in?
        }
      end
    end
  end
end

module Search
  module Patron
    class Base
      def email
        raise NotImplementedError
      end

      def sms
        raise NotImplementedError
      end

      def campus
        raise NotImplementedError
      end

      def logged_in?
        raise NotImplementedError
      end

      def affiliation
        raise NotImplementedError
      end
    end
  end
end

module Search
  module Patron
    class Alma < Base
      include SessionHelper
      def initialize(data, session_affiliation = nil)
        @data = data
        @session_affiliation = session_affiliation
      end

      def email
        @data.dig("contact_info", "email")&.find do |email_entry|
          email_entry["preferred"]
        end&.dig("email_address")
      end

      def sms
        @data.dig("contact_info", "phone")&.find do |phone_entry|
          phone_entry["preferred_sms"]
        end&.dig("phone_number")
      end

      def campus
        campus_code = @data.dig("campus_code", "value")
        case campus_code
        when "UMFL"
          "flint"
        when "UMAA"
          "aa"
        end
      end

      def affiliation
        return @session_affiliation if @session_affiliation
        ["flint", "aa"].find { |x| x == campus }
      end

      def logged_in?
        true
      end
    end
  end
end

module Search
  module Patron
    class NotLoggedIn < Base
      include SessionHelper
      def email
        ""
      end

      def sms
        ""
      end

      def campus
        ""
      end

      def affiliation
        "aa"
      end

      def logged_in?
        false
      end
    end
  end
end

module Search
  module Patron
    class FromSession < Base
      def initialize(session_data, affiliation_param = nil)
        @session = session_data
        @affiliation_param = affiliation_param
      end

      def email
        @session[:email]
      end

      def sms
        @session[:sms]
      end

      def campus
        @session[:campus]
      end

      def logged_in?
        @session[:logged_in]
      end

      #
      # What the current status of the user's affiliation is.
      # aa or flint means the affiliation parameter has been set or
      # the user has selected Ann Arbor or Flint or
      # we have set their affiliation on login.
      #
      # @return [String] Options are [ aa || flint ]
      #
      def affiliation
        valid_param = ["aa", "flint"].find { |x| x == @affiliation_param }
        valid_param || @session[:affiliation] || "aa"
      end
    end
  end
end
