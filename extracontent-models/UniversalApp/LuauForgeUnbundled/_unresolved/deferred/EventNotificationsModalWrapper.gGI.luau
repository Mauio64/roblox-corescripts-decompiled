local CorePackages = game:GetService("CorePackages")

local ApolloClient = require(CorePackages.Packages.ApolloClient)
require("@luauforge/bundled/ehD")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/deferred/gDA")

local useMutation = ApolloClient.useMutation
local eventNotificationsModal = module.EventNotificationsModal

local function EventNotificationsModalWrapper(props)
	local v5 = useMutation(module.requests.NEVER_SHOW_NOTIFICATIONS_MODAL_AGAIN)
	local v6 = useMutation(module.requests.ENABLE_PUSH_NOTIFICATIONS)

	local v7 = React.useCallback(function()
		v5[1]()

		if props.onClose then
			props.onClose()
		end
	end, { v5, props.onClose })

	local v8 = React.useCallback(function()
		v6[1]()

		module.fireEventNotificationEnabled({
			virtualEventId = props.virtualEvent.id,
			universeId = props.virtualEvent.universeId,
			channel = props.channel
		})

		if props.onConfirm then
			props.onConfirm()
		end
	end, { v6, props.virtualEvent, props.channel, props.onConfirm })

	return React.createElement(
		eventNotificationsModal,
		Cryo.Dictionary.join(props, { onClose = v7, onConfirm = v8 })
	)
end

return EventNotificationsModalWrapper
