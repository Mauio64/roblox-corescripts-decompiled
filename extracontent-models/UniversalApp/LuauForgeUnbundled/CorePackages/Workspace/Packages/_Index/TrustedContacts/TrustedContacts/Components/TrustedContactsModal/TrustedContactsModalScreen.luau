local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ReactRoblox")
local useOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation").Hooks.useOverlay

local TrustedFriendsCardWithActionsCheck = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/TrustedFriendsCardWithActionsCheck")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

return function(p2)
	local modalProps = p2.screenProps.modalProps
	local externalNavigation = p2.screenProps.externalNavigation

	local v5 = useOverlay()

	if v5 then
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
		}), v5)
	end

	return nil
end
