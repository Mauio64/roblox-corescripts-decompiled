local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")

local useTCStreamNotificationEventHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/TrustedContacts").EventHandlers.useTCStreamNotificationEventHandler

local function useClientTriggerEventHandler()
	local v5 = useTCStreamNotificationEventHandler()

	return (React.useCallback(function(p2, p3)
		if p2 == "TrustedContactsDoubleOptInModal" then
			v5({ clientEventsPayload = p3.clientEventsPayload, callback = p3.callback })
		end
	end, { v5 }))
end

return useClientTriggerEventHandler
