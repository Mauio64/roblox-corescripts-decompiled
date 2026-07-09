local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FocusNavigableSurfaceIdentifierEnum = require(AppChatParent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local React = require(AppChatParent.React)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local Foundation = require(AppChatParent.Foundation)
local Responsive = require(AppChatParent.Responsive)
local EnumScreens = require(AppChat.EnumScreens)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local isolatedAutoFocusNavigation = require(AppChat.Navigators.isolatedAutoFocusNavigation)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local function getActiveRouteName(p1) -- line: 25
	local v18 = p1 and p1.state

	if not v18 or (not v18.routes or not v18.index) then
		return nil
	end

	while v18 and v18.routes and v18.index do
		v18 = v18.routes[v18.index]

		if not v18 then
			return nil
		end

		if not v18.routes or not v18.index then
			return v18.routeName
		end
	end

	return nil
end
local function wrapInOverlay(p2) -- line: 52
	-- upvalues: Responsive (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), getActiveRouteName (copy), EnumScreens (copy), React (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), Foundation (copy)
	return function(p3) -- line: 53
		-- upvalues: Responsive (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), getActiveRouteName (copy), EnumScreens (copy), React (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), Foundation (copy), p2 (copy)
		local v25 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v26 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small)
		local v27 = not v25 and -360 or -24
		local v28 = not v26 and -72 or -24
		local uDim2 = UDim2.new(1, v27, 1, v28)
		local v30 = nil

		if FFlagAppChatTopBarConfigDriven() then
			if FFlagAppChatPerfTracking then
				AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
			end

			local v31 = getActiveRouteName(p3.navigation)

			if v31 == EnumScreens.CreateNewChat or v31 == EnumScreens.EditChatMembers or v31 == EnumScreens.QuickStartSquadInviteFriends then
				v30 = React.createElement(SystemMenuTopBar, {
					screenName = v31,
					navigation = p3.navigation
				})
			end
		end

		if not v30 then
			v30 = configureTopBarWithNavigationOptions(p3.navigation)
		end

		return React.createElement(Foundation.View, {
			tag = "col position-center-center anchor-center-center clip bg-surface-0 radius-large",
			Size = uDim2
		}, {
			sizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}),
			topBar = v30,
			overlayContent = React.createElement(p2, p3)
		})
	end
end

return function(p4) -- line: 100
	-- upvalues: RoactNavigation (copy), React (copy), isolatedAutoFocusNavigation (copy), Responsive (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), getActiveRouteName (copy), EnumScreens (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), Foundation (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v21 = RoactNavigation.createRobloxStackNavigator(p4, {
		defaultNavigationOptions = {
			isDialog = true
		}
	})
	local v22 = React.PureComponent:extend("OverlayNavigatorConnector")

	v22.router = v21.router

	local v23 = isolatedAutoFocusNavigation(function(p5) -- line: 53
		-- upvalues: Responsive (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), getActiveRouteName (copy), EnumScreens (copy), React (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), Foundation (copy), v21 (copy)
		local v33 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v34 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small)
		local v35 = not v33 and -360 or -24
		local v36 = not v34 and -72 or -24
		local uDim2 = UDim2.new(1, v35, 1, v36)
		local v38 = nil

		if FFlagAppChatTopBarConfigDriven() then
			if FFlagAppChatPerfTracking then
				AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
			end

			local v39 = getActiveRouteName(p5.navigation)

			if v39 == EnumScreens.CreateNewChat or v39 == EnumScreens.EditChatMembers or v39 == EnumScreens.QuickStartSquadInviteFriends then
				v38 = React.createElement(SystemMenuTopBar, {
					screenName = v39,
					navigation = p5.navigation
				})
			end
		end

		if not v38 then
			v38 = configureTopBarWithNavigationOptions(p5.navigation)
		end

		return React.createElement(Foundation.View, {
			tag = "col position-center-center anchor-center-center clip bg-surface-0 radius-large",
			Size = uDim2
		}, {
			sizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}),
			topBar = v38,
			overlayContent = React.createElement(v21, p5)
		})
	end, FocusNavigableSurfaceIdentifierEnum.PopUp)

	function v22.render(p6) -- line: 109
		-- upvalues: React (copy), v23 (copy)
		return React.createElement(v23, p6.props)
	end

	return v22
end
