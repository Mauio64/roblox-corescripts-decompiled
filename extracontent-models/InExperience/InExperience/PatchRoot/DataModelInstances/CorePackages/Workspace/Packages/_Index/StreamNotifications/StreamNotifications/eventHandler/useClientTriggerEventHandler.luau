local parent = script:FindFirstAncestor("StreamNotifications").Parent
local React = require(parent.React)

local TrustedContacts = require(parent.TrustedContacts)
local useTCStreamNotificationEventHandler = TrustedContacts.EventHandlers.useTCStreamNotificationEventHandler

local function useClientTriggerEventHandler()
	local v = useTCStreamNotificationEventHandler()

	return (React.useCallback(function(p: string?, p2)
		if p == "TrustedContactsDoubleOptInModal" then
			v({ clientEventsPayload = p2.clientEventsPayload, callback = p2.callback })
		end
	end, { v }))
end

return useClientTriggerEventHandler
