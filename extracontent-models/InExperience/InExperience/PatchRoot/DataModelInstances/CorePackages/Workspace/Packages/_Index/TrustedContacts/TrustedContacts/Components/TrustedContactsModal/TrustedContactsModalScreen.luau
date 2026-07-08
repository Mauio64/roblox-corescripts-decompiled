local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local ReactRoblox = require(TrustedContactsParent.ReactRoblox)
local useOverlay = require(TrustedContactsParent.Foundation).Hooks.useOverlay
local v6 = if not require(TrustedContactsParent.SharedFlags).FFlagTFWithActionsCheck then require(script.Parent.TrustedContactsModalContainer) else require(script.Parent.TrustedFriendsCardWithActionsCheck)
local FFlagTCModalUseFoundationOverlay = require(TrustedContactsParent.SharedFlags).FFlagTCModalUseFoundationOverlay

require(TrustedContacts.Common.Types)

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: FFlagTCModalUseFoundationOverlay (copy), useOverlay (copy), ReactRoblox (copy), React (copy), v6 (copy)
	local modalProps = t1.screenProps.modalProps
	local externalNavigation = t1.screenProps.externalNavigation

	if FFlagTCModalUseFoundationOverlay then
		local v11 = useOverlay()

		if not v11 then
			return nil
		end

		return ReactRoblox.createPortal(React.createElement(v6, {
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
		}), v11)
	end

	return React.createElement("ScreenGui", {
		Enabled = true,
		DisplayOrder = 11,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, { React.createElement(v6, {
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
	}) })
end
