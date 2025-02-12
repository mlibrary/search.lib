module Search
  module Patron
    def self.for(uniqname)
      body = {}
      Alma.new(body)
    end

    def self.from_session(session)
      FromSession.new(session)
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
    end
  end
end

module Search
  module Patron
    class Alma < Base
      include SessionHelper
      def initialize
      end

      def email
      end

      def sms
      end

      def campus
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
      def initialize(session_data)
        @session = session_data
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
      # What the current status of the user's affiliation is. Nil means we don't
      # know. aa or Flint means the user has selected Ann Arbor or Flint or we
      # have set their affiliation on login.
      #
      # @return [Nil or String] Options are [Nil || aa || flint ]
      #
      def affiliation
        @session[:affiliation]
      end
    end
  end
end
