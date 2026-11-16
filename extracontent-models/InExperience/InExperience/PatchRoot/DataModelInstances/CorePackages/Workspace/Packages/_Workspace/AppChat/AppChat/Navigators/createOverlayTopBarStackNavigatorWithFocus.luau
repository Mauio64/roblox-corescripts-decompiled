local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)

local EnumScreens = require(AppChat.EnumScreens)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local isolatedAutoFocusNavigation = require(AppChat.Navigators.isolatedAutoFocusNavigation)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local FFlagFixPaginatedChatMembersCutoff = require(AppChat.Flags.FFlagFixPaginatedChatMembersCutoff)

local function getActiveRouteName(navigation)
	local v = navigation and navigation.state

	if not (v and v.routes and v.index) then
		return nil
	end

	while true do
		v = v and v.routes and v.index and v.routes[v.index]

		if not v then
			return nil
		end

		if not (v.routes and v.index) then
			return v.routeName
		end
	end
end

local function wrapInOverlay(robloxStackNavigator) -- 1 equivalent call inferred from this helper
	return function(p)
		local v = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v2 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small) and -24 or -72

		local udim = UDim2.new(1, v and -24 or -360, 1, v2)

		local v3 = nil

		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
		end

		local activeRouteName = getActiveRouteName(p.navigation)

		if
			activeRouteName == EnumScreens.CreateNewChat
			or activeRouteName == EnumScreens.EditChatMembers
			or activeRouteName == EnumScreens.QuickStartSquadInviteFriends
		then
			v3 = React.createElement(SystemMenuTopBar, {
				screenName = activeRouteName,
				navigation = p.navigation
			})
		end

		local topBar = v3 or configureTopBarWithNavigationOptions(p.navigation)

		return React.createElement(Foundation.View, {
			tag = "col position-center-center anchor-center-center radius-large clip bg-surface-0",
			Size = udim,
			sizeConstraint = { MaxSize = Vector2.new(1000, 800), MinSize = Vector2.new(0, 0) }
		}, {
			topBar = topBar,
			overlayContent = React.createElement(robloxStackNavigator, p)
		})
	end
end

return function(p)
	local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator(p, {
		defaultNavigationOptions = {
			isDialog = true,
			absorbInputSelectable = not FFlagFixPaginatedChatMembersCutoff and nil
		}
	})

	local extended = React.PureComponent:extend("OverlayNavigatorConnector")
	extended.router = robloxStackNavigator.router

	local v = isolatedAutoFocusNavigation(
		wrapInOverlay(robloxStackNavigator), -- inferred equivalent call
		FocusNavigableSurfaceIdentifierEnum.PopUp
	)

	function extended.render(p2)
		return React.createElement(v, p2.props)
	end

	return extended
end
