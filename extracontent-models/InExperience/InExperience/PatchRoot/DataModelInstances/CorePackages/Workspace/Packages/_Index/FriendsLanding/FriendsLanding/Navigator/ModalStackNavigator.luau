local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local parent = FriendsLanding.Parent

local roactNavigation = dependencies.RoactNavigation
local EnumScreens = require(FriendsLanding.EnumScreens)
local MainStackNavigatorConnector = require(FriendsLanding.Navigator.MainStackNavigatorConnector)
local FriendsLandingFilter = require(FriendsLanding.Components.FriendsLandingFilter)
local FriendsLandingContextualMenu = require(FriendsLanding.Components.FriendsLandingContextualMenu)
local discoverabilityOverlay = dependencies.DiscoverabilityOverlay
local roact = dependencies.Roact
require(FriendsLanding.Parent.React)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local ProfileQRCodePageWrapper = require(FriendsLanding.Navigator.ProfileQRCodePageWrapper)

local extend = roact.PureComponent:extend("DiscoverabilityWrapped")

function extend.render(p)
	return FriendsLandingContext.with(function(context)
		return roact.createElement(discoverabilityOverlay, {
			navigation = p.props.navigation,
			context = context
		})
	end)
end

local v = {
	[EnumScreens.FilterByModal] = { screen = FriendsLandingFilter }
}

local FriendsLandingContextualMenusByContextualMenu = {
	[EnumScreens.ContextualMenu] = FriendsLandingContextualMenu
}

local ProfileQRCodePageWrappersByProfileQRCodePage = {
	[EnumScreens.ProfileQRCodePage] = ProfileQRCodePageWrapper
}
return (roactNavigation.createRobloxStackNavigator({
	{
		MainStackNavigator = {
			screen = MainStackNavigatorConnector,
			navigationOptions = { overlayTransparency = 1 }
		}
	},
	v,
	FriendsLandingContextualMenusByContextualMenu,
	ProfileQRCodePageWrappersByProfileQRCodePage
}, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		absorbInputSelectable = false
	},
	mode = roactNavigation.StackPresentationStyle.Overlay
}))
