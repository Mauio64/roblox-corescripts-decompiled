local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local useOverlay = Foundation.Hooks.useOverlay

local TrustedFriendsCardWithActionsCheck = require(script.Parent.TrustedFriendsCardWithActionsCheck)

require(TrustedContacts.Common.Types)

return function(p)
	local modalProps = p.screenProps.modalProps
	local externalNavigation = p.screenProps.externalNavigation

	local v = useOverlay()

	if v then
		return ReactRoblox.createPortal(React.createElement(TrustedFriendsCardWithActionsCheck, {
			userId = modalProps.userId,
			onRequestAccepted = modalProps.onRequestAccepted,
			onRequestSent = modalProps.onRequestSent,
			source = modalProps.source,
			modalVariantOverride = modalProps.modalVariantOverride,
			sentFromQrCode = modalProps.sentFromQrCode,
			tokens = modalProps.tokens,
			isVerticallyConstrained = modalProps.isVerticallyConstrained,
			onAcknowledged = modalProps.onAcknowledged,
			externalNavigation = externalNavigation
		}), v)
	end

	return nil
end
