local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local IXPService = game:GetService("IXPService")
local EnumScreens = require(AppChat.EnumScreens)
local InputHandlers = require(AppChatParent.InputHandlers)
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local SharedFlags = require(AppChatParent.SharedFlags)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagAppChatFixRootChatBackNavigation = SharedFlags.FFlagAppChatFixRootChatBackNavigation
local v14 = game:DefineFastFlag("AppChatFixRootChatBackNavigationIxpEnabled", false)
local v15 = game:DefineFastString("AppChatFixRootChatBackNavigationIxpLayer", "Party.LandingPage")
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

require(AppChat.types)

local function getActiveChildParams(p1) -- line: 27
	-- upvalues: getActiveChildParams (copy)
	local index = p1.index
	local v24 = p1.routes and p1.routes[index]

	if v24 then
		return getActiveChildParams(v24)
	end

	return p1.params
end
local function getActiveChildNavigationOptions(p2) -- line: 37
	-- upvalues: getActiveChildNavigationOptions (copy), RoactNavigation (copy)
	local state = p2.state
	local index = state.index
	local v28 = state.routes and state.routes[index]

	if v28 and v28.routes then
		local v29 = p2.getChildNavigation(v28.key)

		return getActiveChildNavigationOptions(v29)
	end

	return RoactNavigation.getActiveChildNavigationOptions(p2)
end
local function getActiveConversationId(p3) -- line: 50
	if p3 then
		if p3.conversation then
			return p3.conversation.id
		end

		return p3.conversationId
	end

	return nil
end
local function RoactChatStackNavigatorWithFocusNavigation(p4) -- line: 63
	-- upvalues: React (copy), InputHandlers (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), Roact (copy)
	local v32 = React.useCallback(InputHandlers.onRelease(function(p5) -- line: 65
		-- upvalues: p4 (copy)
		if p4.onNavigateBack() then
			p5:cancel()
		end
	end), { p4.onNavigateBack })
	local v33 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v32)

	return Roact.createFragment({
		FocusNavigationContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ref = v33
		}, {
			navigator = Roact.createElement(p4.navigator, {
				navigation = p4.navigation
			})
		})
	})
end

return function(p6, p7, p8, p9) -- line: 89
	-- upvalues: Roact (copy), getActiveChildNavigationOptions (copy), RoactNavigation (copy), v14 (copy), IXPService (copy), v15 (copy), EnumScreens (copy), FFlagAppChatFixRootChatBackNavigation (copy), getActiveChildParams (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), RoactChatStackNavigatorWithFocusNavigation (copy)
	local v38 = Roact.PureComponent:extend("RoactChatStackNavigator")

	v38.defaultProps = {
		navigation = nil,
		parameters = nil,
		notificationCount = 0,
		setActiveConversationId = function() -- line: 100
		end,
		setBackButtonEnabled = function() -- line: 101
		end,
		setTabBarVisible = function() -- line: 102
		end
	}

	function v38.init(p10) -- line: 106
		-- upvalues: getActiveChildNavigationOptions (copy), RoactNavigation (copy), p7 (copy), v14 (copy), IXPService (copy), v15 (copy), EnumScreens (copy), FFlagAppChatFixRootChatBackNavigation (copy), p9 (copy)
		p10.backButtonConnection = nil

		function p10.onBackButtonPressed() -- line: 110
			-- upvalues: p10 (copy), getActiveChildNavigationOptions (copy), RoactNavigation (copy), p7 (copy), v14 (copy), IXPService (copy), v15 (copy), EnumScreens (copy), FFlagAppChatFixRootChatBackNavigation (copy), p9 (copy)
			local navigation = p10.props.navigation
			local state = navigation.state
			local index = state.index
			local v71 = state.routes and state.routes[index]
			local v73

			if v71 and v71.routes then
				local v72 = navigation.getChildNavigation(v71.key)

				v73 = getActiveChildNavigationOptions(v72)
			else
				v73 = RoactNavigation.getActiveChildNavigationOptions(navigation)
			end

			if p7 and v73.isRoot then
				if v14 then
					IXPService:LogFlagLinkedUserLayerExposure(v15)
				end

				p10.props.navigation.navigate(EnumScreens.EmptyConversation)
				p7()

				if not FFlagAppChatFixRootChatBackNavigation and p9 and p10.props.chatIsVisible then
					p9.showExitDialog()
				end

				return false
			end

			p10.props.navigation.pop()

			return true
		end
	end
	function v38.willUpdate(p11, p12) -- line: 134
		-- upvalues: getActiveChildParams (copy), getActiveChildNavigationOptions (copy), RoactNavigation (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy)
		local state = p11.props.navigation.state
		local index = state.index
		local v45 = state.routes and state.routes[index]
		local v46 = if not v45 then state.params else getActiveChildParams(v45)
		local state2 = p12.navigation.state
		local index2 = state2.index
		local v49 = state2.routes and state2.routes[index2]
		local v50 = if not v49 then state2.params else getActiveChildParams(v49)
		local v51 = if not v46 then nil else if not v46.conversation then v46.conversationId else v46.conversation.id
		local v52 = if not v50 then nil else if not v50.conversation then v50.conversationId else v50.conversation.id

		if v51 ~= v52 then
			p11.props.setActiveConversationId(v52)
		end

		if not p12.chatIsVisible then
			return
		end

		local navigation = p12.navigation
		local state3 = navigation.state
		local index3 = state3.index
		local v56 = state3.routes and state3.routes[index3]
		local v58

		if v56 and v56.routes then
			local v57 = navigation.getChildNavigation(v56.key)

			v58 = getActiveChildNavigationOptions(v57)
		else
			v58 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		if FFlagAppChatTopBarConfigDriven() then
			local state4 = p12.navigation.state
			local v60 = state4.routes[state4.index]
			local v61 = GetTopBarStore(false).getScreenTopBar(v60.routeName)()

			if v61.backButtonEnabled ~= nil then
				p11.props.setBackButtonEnabled(v61.backButtonEnabled)
			end
		elseif v58 and v58.backButtonEnabled ~= nil then
			p11.props.setBackButtonEnabled(v58.backButtonEnabled)
		end

		if v58 and v58.tabBarVisible ~= nil then
			p11.props.setTabBarVisible(v58.tabBarVisible)
		end
	end
	function v38.didMount(p13) -- line: 172
		-- upvalues: p8 (copy), p7 (copy), EnumScreens (copy)
		if p8 and p7 then
			p13.backButtonConnection = p8:connect(p13.onBackButtonPressed)
		end

		local parameters = p13.props.parameters
		local v64 = parameters and parameters.conversationId

		if v64 then
			p13.props.navigation.navigate(EnumScreens.ChatConversation, {
				conversationId = v64
			})
		end
	end
	function v38.willUnmount(p14) -- line: 185
		p14.props.setActiveConversationId(nil)

		if p14.backButtonConnection then
			p14.backButtonConnection:disconnect()
		end
	end
	function v38.render(p15) -- line: 192
		-- upvalues: Roact (copy), RoactChatStackNavigatorWithFocusNavigation (copy), p6 (copy)
		local navigation = p15.props.navigation

		return Roact.createElement(RoactChatStackNavigatorWithFocusNavigation, {
			navigation = navigation,
			navigator = p6,
			onNavigateBack = p15.onBackButtonPressed
		})
	end

	v38.router = p6.router

	return v38
end
