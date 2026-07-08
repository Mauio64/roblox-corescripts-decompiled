local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local RoactNavigation = require(TrustedContactsParent.RoactNavigation)
local TrustedFriendsModalNavigator = require(script.Parent.TrustedFriendsModalNavigator)
local useExternalNavigationSetUp = require(script.Parent.useExternalNavigationSetUp)

require(TrustedContacts.Common.Types)

local function TrustedFriendsModalEntry(p1) -- line: 19
	-- upvalues: React (copy), RoactNavigation (copy), TrustedFriendsModalNavigator (copy), useExternalNavigationSetUp (copy)
	local navigation = p1.navigation
	local v11 = React.useMemo(function() -- line: 22
		-- upvalues: RoactNavigation (copy), TrustedFriendsModalNavigator (copy)
		return RoactNavigation.createAppContainer(TrustedFriendsModalNavigator)
	end, {})
	local v12 = if not navigation then p1 else navigation.getParam("props")
	local v13 = if not navigation then v11 else TrustedFriendsModalNavigator
	local v14 = useExternalNavigationSetUp({
		navigation = navigation,
		onClosed = v12.onClosed
	})

	return React.createElement(v13, {
		navigation = navigation,
		screenProps = {
			modalProps = {
				onClosed = nil,
				userId = v12.userId,
				source = v12.source,
				isVerticallyConstrained = v12.isVerticallyConstrained,
				onRequestAccepted = v12.onRequestAccepted,
				onRequestSent = v12.onRequestSent,
				onAcknowledged = v12.onAcknowledged,
				modalVariantOverride = v12.modalVariantOverride,
				tokens = v12.tokens,
				sentFromQrCode = v12.sentFromQrCode
			},
			externalNavigation = v14
		}
	})
end

local v8 = React.PureComponent:extend("classWrapper")

function v8.render(p2) -- line: 59
	-- upvalues: React (copy), TrustedFriendsModalEntry (copy)
	return React.createElement(TrustedFriendsModalEntry, p2.props)
end

v8.router = TrustedFriendsModalNavigator.router

return v8
