local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roactNavigation = dependencies.RoactNavigation
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local MainStackNavigatorConnector = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/MainStackNavigatorConnector")
local FriendsLandingFilter = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingFilter")
local FriendsLandingContextualMenu = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingContextualMenu")
local discoverabilityOverlay = dependencies.DiscoverabilityOverlay
local roact = dependencies.Roact
require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local ProfileQRCodePageWrapper = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/ProfileQRCodePageWrapper")

local extend = roact.PureComponent:extend("DiscoverabilityWrapped")

function extend.render(p2)
	return FriendsLandingContext.with(function(p3)
		return roact.createElement(discoverabilityOverlay, {
			navigation = p2.props.navigation,
			context = p3
		})
	end)
end

local v5 = {
	[EnumScreens.FilterByModal] = { screen = FriendsLandingFilter }
}

local modulesByContextualMenu = { [EnumScreens.ContextualMenu] = FriendsLandingContextualMenu }

local modulesByProfileQRCodePage = { [EnumScreens.ProfileQRCodePage] = ProfileQRCodePageWrapper }
return (roactNavigation.createRobloxStackNavigator({
	{
		MainStackNavigator = {
			screen = MainStackNavigatorConnector,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	v5,
	modulesByContextualMenu,
	modulesByProfileQRCodePage
}, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		absorbInputSelectable = false
	},
	mode = roactNavigation.StackPresentationStyle.Overlay
}))
