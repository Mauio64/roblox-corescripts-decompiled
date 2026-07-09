local CorePackages = game:GetService("CorePackages")
local ApolloClient = require(CorePackages.Packages.ApolloClient)

require(CorePackages.Workspace.Packages.GraphQLServer)

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local VirtualEvents = require(CorePackages.Workspace.Packages.VirtualEvents)
local useMutation = ApolloClient.useMutation
local EventNotificationsModal = VirtualEvents.EventNotificationsModal

local function EventNotificationsModalWrapper(p1) -- line: 17
	-- upvalues: useMutation (copy), VirtualEvents (copy), React (copy), EventNotificationsModal (copy), Cryo (copy)
	local v10 = useMutation(VirtualEvents.requests.NEVER_SHOW_NOTIFICATIONS_MODAL_AGAIN)
	local v11 = useMutation(VirtualEvents.requests.ENABLE_PUSH_NOTIFICATIONS)
	local v12 = React.useCallback(function() -- line: 21
		-- upvalues: v10 (copy), p1 (copy)
		v10[1]()

		if p1.onClose then
			p1.onClose()
		end
	end, {
		v10,
		p1.onClose
	})
	local v13 = React.useCallback(function() -- line: 32
		-- upvalues: v11 (copy), VirtualEvents (copy), p1 (copy)
		v11[1]()
		VirtualEvents.fireEventNotificationEnabled({
			virtualEventId = p1.virtualEvent.id,
			universeId = p1.virtualEvent.universeId,
			channel = p1.channel
		})

		if p1.onConfirm then
			p1.onConfirm()
		end
	end, {
		v11,
		p1.virtualEvent,
		p1.channel,
		p1.onConfirm
	})

	return React.createElement(EventNotificationsModal, Cryo.Dictionary.join(p1, {
		onClose = v12,
		onConfirm = v13
	}))
end

return EventNotificationsModalWrapper
