local focusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").FocusNavigableSurfaceIdentifierEnum
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local SystemMenuTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/SystemMenuTopBar")
local configureTopBarWithNavigationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/configureTopBarWithNavigationOptions")
local isolatedAutoFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/isolatedAutoFocusNavigation")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local FFlagFixPaginatedChatMembersCutoff = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagFixPaginatedChatMembersCutoff")

local function getActiveRouteName(navigation)
	local v5 = navigation and navigation.state

	if not (v5 and v5.routes and v5.index) then
		return nil
	end

	while true do
		v5 = v5 and v5.routes and v5.index and v5.routes[v5.index]

		if not v5 then
			return nil
		end

		if not (v5.routes and v5.index) then
			return v5.routeName
		end
	end
end

local function wrapInOverlay(p2)
	return function(p3)
		local v5 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v6 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small) and -24 or -72

		local udim = UDim2.new(1, v5 and -24 or -360, 1, v6)

		local v7 = nil

		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
		end

		local activeRouteName = getActiveRouteName(p3.navigation)

		if
			activeRouteName == EnumScreens.CreateNewChat
			or activeRouteName == EnumScreens.EditChatMembers
			or activeRouteName == EnumScreens.QuickStartSquadInviteFriends
		then
			v7 = React.createElement(SystemMenuTopBar, {
				screenName = activeRouteName,
				navigation = p3.navigation
			})
		end

		local v8 = v7 or configureTopBarWithNavigationOptions(p3.navigation)

		return React.createElement(Foundation.View, {
			tag = "col position-center-center anchor-center-center radius-large clip bg-surface-0",
			Size = udim,
			sizeConstraint = {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}
		}, { topBar = v8, overlayContent = React.createElement(p2, p3) })
	end
end

return function(p2)
	local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator(p2, {
		defaultNavigationOptions = {
			isDialog = true,
			absorbInputSelectable = if FFlagFixPaginatedChatMembersCutoff then false else nil
		}
	})

	local extended = React.PureComponent:extend("OverlayNavigatorConnector")
	extended.router = robloxStackNavigator.router
	local v8 = isolatedAutoFocusNavigation(function(p3)
		local v9 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v10 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small) and -24 or -72

		local udim = UDim2.new(1, v9 and -24 or -360, 1, v10)

		local v11 = nil

		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
		end

		local activeRouteName = getActiveRouteName(p3.navigation)

		if
			activeRouteName == EnumScreens.CreateNewChat
			or activeRouteName == EnumScreens.EditChatMembers
			or activeRouteName == EnumScreens.QuickStartSquadInviteFriends
		then
			v11 = React.createElement(SystemMenuTopBar, {
				screenName = activeRouteName,
				navigation = p3.navigation
			})
		end

		local v12 = v11 or configureTopBarWithNavigationOptions(p3.navigation)

		return React.createElement(Foundation.View, {
			tag = "col position-center-center anchor-center-center radius-large clip bg-surface-0",
			Size = udim,
			sizeConstraint = {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}
		}, {
			topBar = v12,
			overlayContent = React.createElement(robloxStackNavigator, p3)
		})
	end, focusNavigableSurfaceIdentifierEnum.PopUp)

	function extended.render(p3)
		return React.createElement(v8, p3.props)
	end

	return extended
end
