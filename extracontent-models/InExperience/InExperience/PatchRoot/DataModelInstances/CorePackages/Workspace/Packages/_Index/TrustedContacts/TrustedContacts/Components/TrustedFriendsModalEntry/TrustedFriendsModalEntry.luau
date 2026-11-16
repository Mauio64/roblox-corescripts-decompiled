local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local TrustedFriendsModalNavigator = require(script.Parent.TrustedFriendsModalNavigator)
local useExternalNavigationSetUp = require(script.Parent.useExternalNavigationSetUp)

require(TrustedContacts.Common.Types)

local function TrustedFriendsModalEntry(props)
	local navigation = props.navigation

	local v = React.useMemo(function()
		return RoactNavigation.createAppContainer(TrustedFriendsModalNavigator)
	end, {})

	if navigation then
		props = navigation.getParam("props")
	end

	if navigation then
		v = TrustedFriendsModalNavigator
	end

	local externalNavigation = useExternalNavigationSetUp({
		navigation = navigation,
		onClosed = props.onClosed
	})

	return React.createElement(v, {
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
			externalNavigation = externalNavigation
		}
	})
end

local extended = React.PureComponent:extend("classWrapper")
function extended.render(p)
	return React.createElement(TrustedFriendsModalEntry, p.props)
end

extended.router = TrustedFriendsModalNavigator.router

return extended
