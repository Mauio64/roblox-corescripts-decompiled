local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local React = require(Parent.React)
local useTCStreamNotificationEventHandler = require(Parent.TrustedContacts).EventHandlers.useTCStreamNotificationEventHandler

local function useClientTriggerEventHandler() -- line: 7
	-- upvalues: useTCStreamNotificationEventHandler (copy), React (copy)
	local v5 = useTCStreamNotificationEventHandler()

	return (React.useCallback(function(s1: string?, p1) -- line: 10
		-- upvalues: v5 (copy)
		if s1 == "TrustedContactsDoubleOptInModal" then
			v5({
				clientEventsPayload = p1.clientEventsPayload,
				callback = p1.callback
			})
		end
	end, { v5 }))
end

return useClientTriggerEventHandler
