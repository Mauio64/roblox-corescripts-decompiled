local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local Roact = require(AppChatParent.Roact)
local mountFrameWithTopBar = require(AppChat.Tests.MountFrameHelpers).mountFrameWithTopBar
local EnumScreens = require(AppChat.EnumScreens)
local TopBarContext = require(AppChat.TopBarContext)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local getRoactChatStackNavigator = require(AppChat.getRoactChatStackNavigator)

return function(p1, t1: {[any]: any}) -- line: 23
	-- upvalues: RoactNavigation (copy), Roact (copy), FFlagAppChatTopBarConfigDriven (copy), EnumScreens (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), getRoactChatStackNavigator (copy), TopBarContext (copy), mountFrameWithTopBar (copy)
	local v14 = RoactNavigation.createRobloxStackNavigator(t1.navigator)
	local v15 = Roact.Component:extend("testNavigatorConnector")

	v15.router = v14.router

	function v15.render(p2) -- line: 29
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), EnumScreens (copy), Roact (copy), SystemMenuTopBar (copy), configureTopBarWithNavigationOptions (copy), t1 (copy), v14 (copy)
		local v22 = nil

		if FFlagAppChatTopBarConfigDriven() then
			local state = p2.props.navigation.state
			local v24 = state and (state.routes and (state.routes[state.index] and state.routes[state.index].routeName))

			if v24 == EnumScreens.CreateNewChat or v24 == EnumScreens.EditChatMembers then
				v22 = Roact.createElement(SystemMenuTopBar, {
					screenName = v24,
					navigation = p2.props.navigation
				})
			end
		end

		if not v22 then
			v22 = configureTopBarWithNavigationOptions(p2.props.navigation)
		end

		return Roact.createFragment({
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			testButton = Roact.createElement("TextButton", {
				LayoutOrder = -2,
				Size = UDim2.new(0, 100, 0, 20),
				Text = "test button",
				[Roact.Event.Activated] = function() -- line: 55
					-- upvalues: p2 (copy), t1 (copy)
					p2.props.navigation.navigate(t1.testRoute, t1.testRouteParams)
				end
			}),
			topBar = v22,
			testNavigator = Roact.createElement(v14, p2.props)
		})
	end

	local v16 = RoactNavigation.createAppContainer(getRoactChatStackNavigator(v15))
	local v17 = Roact.createElement(TopBarContext.Consumer, {
		render = function(p3) -- line: 66
			-- upvalues: Roact (copy), v16 (copy)
			return Roact.createElement(v16, {
				screenProps = {
					topBarHeight = 64,
					getScreenTopBar = p3.getScreenTopBar,
					setScreenTopBar = p3.setScreenTopBar
				}
			})
		end
	})
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local v19, v20 = mountFrameWithTopBar(v17, {
		store = p1,
		parent = ScreenGui
	})

	return v19, v20
end
