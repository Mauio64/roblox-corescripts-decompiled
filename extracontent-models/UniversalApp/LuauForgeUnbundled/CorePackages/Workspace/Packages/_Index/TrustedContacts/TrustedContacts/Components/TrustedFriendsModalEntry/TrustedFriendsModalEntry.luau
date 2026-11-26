local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactNavigation")

local TrustedFriendsModalNavigator = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedFriendsModalEntry/TrustedFriendsModalNavigator")
local useExternalNavigationSetUp = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedFriendsModalEntry/useExternalNavigationSetUp")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local function TrustedFriendsModalEntry(props)
	local navigation = props.navigation

	local v5 = React.useMemo(function()
		return RoactNavigation.createAppContainer(TrustedFriendsModalNavigator)
	end, {})

	if navigation then
		props = navigation.getParam("props")
	end

	if navigation then
		v5 = TrustedFriendsModalNavigator
	end

	local v6 = useExternalNavigationSetUp({ navigation = navigation, onClosed = props.onClosed })

	return React.createElement(v5, {
		navigation = navigation,
		screenProps = {
			modalProps = {
				userId = props.userId,
				source = props.source,
				isVerticallyConstrained = props.isVerticallyConstrained,
				onRequestAccepted = props.onRequestAccepted,
				onRequestSent = props.onRequestSent,
				onAcknowledged = props.onAcknowledged,
				modalVariantOverride = props.modalVariantOverride,
				tokens = props.tokens,
				sentFromQrCode = props.sentFromQrCode,
				onClosed = nil
			},
			externalNavigation = v6
		}
	})
end

local extended = React.PureComponent:extend("classWrapper")
function extended.render(p2)
	return React.createElement(TrustedFriendsModalEntry, p2.props)
end

extended.router = TrustedFriendsModalNavigator.router

return extended
