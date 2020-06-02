require 'travis/addons/handlers/base'
require 'travis/addons/handlers/task'

module Travis
  module Addons
    module Handlers
      class Intercom < Base
        include Handlers::Task

        EVENTS = 'build:finished'

        class Notifier < Notifier
          def handle?
            p "handle? call"
            p payload
            payload.owner && payload.owner.type.downcase == 'user' # currently Intercom makes sense only for users, not for orgs
          end

          def handle
            p "handle call"
            run_task(:intercom, payload)
          end

          class Instrument < Addons::Instrument
            def notify_completed
              publish
            end
          end
          Instrument.attach_to(self)
        end
      end
    end
  end
end
