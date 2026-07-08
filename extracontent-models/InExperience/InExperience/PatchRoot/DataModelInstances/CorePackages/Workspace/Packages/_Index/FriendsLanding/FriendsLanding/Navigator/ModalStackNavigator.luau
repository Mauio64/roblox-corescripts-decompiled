local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local _ = FriendsLanding.Parent
local RoactNavigation = dependencies.RoactNavigation
local EnumScreens = require(FriendsLanding.EnumScreens)
local MainStackNavigatorConnector = require(FriendsLanding.Navigator.MainStackNavigatorConnector)
local FriendsLandingFilter = require(FriendsLanding.Components.FriendsLandingFilter)
local FriendsLandingContextualMenu = require(FriendsLanding.Components.FriendsLandingContextualMenu)
local DiscoverabilityOverlay = dependencies.DiscoverabilityOverlay
local Roact = dependencies.Roact

require(FriendsLanding.Parent.React)

local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local ProfileQRCodePageWrapper = require(FriendsLanding.Navigator.ProfileQRCodePageWrapper)

Roact.PureComponent:extend("DiscoverabilityWrapped").render = function(p1) -- line: 18
	-- upvalues: FriendsLandingContext (copy), Roact (copy), DiscoverabilityOverlay (copy)
	return FriendsLandingContext.with(function(p2) -- line: 19
		-- upvalues: Roact (copy), DiscoverabilityOverlay (copy), p1 (copy)
		return Roact.createElement(DiscoverabilityOverlay, {
			navigation = p1.props.navigation,
			context = p2
		})
	end)
end

local t1 = {
	{
		MainStackNavigator = {
			screen = MainStackNavigatorConnector,
			navigationOptions = {
				overlayTransparency = 1
			}
		}
	},
	{
		[EnumScreens.FilterByModal] = {
			screen = FriendsLandingFilter
		}
	},
	{
		[EnumScreens.ContextualMenu] = FriendsLandingContextualMenu
	},
	{
		[EnumScreens.ProfileQRCodePage] = ProfileQRCodePageWrapper
	}
}

return (RoactNavigation.createRobloxStackNavigator(t1, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		absorbInputSelectable = false
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
}))
