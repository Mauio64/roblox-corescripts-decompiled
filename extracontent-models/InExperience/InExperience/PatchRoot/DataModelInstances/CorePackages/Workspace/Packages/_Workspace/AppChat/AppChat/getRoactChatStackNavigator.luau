local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local IXPService = game:GetService("IXPService")

local BackHandlerContext = require(AppChat.Contexts.BackHandlerContext)
local EnumScreens = require(AppChat.EnumScreens)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local Roact = require(parent.Roact)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactNavigation = require(parent.RoactNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local SharedFlags = require(parent.SharedFlags)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagAppChatFixRootChatBackNavigation = SharedFlags.FFlagAppChatFixRootChatBackNavigation

local defineFastFlag = game:DefineFastFlag("AppChatFixRootChatBackNavigationIxpEnabled", false)

local defineFastString = game:DefineFastString("AppChatFixRootChatBackNavigationIxpLayer", "Party.LandingPage")

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local FFlagSignalsNavDeferProjection = SharedFlags.FFlagSignalsNavDeferProjection
local getIsChatVisibleNow

if FFlagSignalsNavDeferProjection then
	local getIsChatVisibleNow2 = require(AppChat.Utils.getIsChatVisibleNow)
	getIsChatVisibleNow = getIsChatVisibleNow2.getIsChatVisibleNow
else
	getIsChatVisibleNow = nil
end

local FFlagAppChatFoundationHeaderBar = require(AppChat.Flags.FFlagAppChatFoundationHeaderBar)

require(AppChat.types)
local function getActiveChildParams(data)
	local index = data.index
	local v = data.routes and data.routes[index]

	if v then
		return getActiveChildParams(v)
	end

	return data.params
end

local function getActiveChildNavigationOptions(childNavigation)
	local state = childNavigation.state
	local index = state.index
	local v = state.routes and state.routes[index]

	if v and v.routes then
		return getActiveChildNavigationOptions((childNavigation.getChildNavigation(v.key)))
	end

	return RoactNavigation.getActiveChildNavigationOptions(childNavigation)
end

local function getActiveConversationId(p) -- 2 equivalent calls inferred from this helper
	if not p then
		return nil
	end

	if p.conversation then
		return p.conversation.id
	end

	return p.conversationId
end

local function RoactChatStackNavigatorWithFocusNavigation(props)
	local v = React.useCallback(InputHandlers.onRelease(function(object)
		if props.shouldSuppressNavigateBack(object) then
			object:cancel()
		elseif props.onNavigateBack() then
			object:cancel()
		end
	end), { props.onNavigateBack, props.shouldSuppressNavigateBack })

	local ref = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v)

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v2 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = ref }

	local createElement2 = Roact.createElement
	local navigator = props.navigator
	local v3 = { navigation = props.navigation, screenProps = 0 }
	local screenProps

	if FFlagAppChatFoundationHeaderBar then
		screenProps = props.screenProps
	end

	v3.screenProps = screenProps
	return createFragment({
		FocusNavigationContainer = createElement("Frame", v2, {
			navigator = createElement2(navigator, v3)
		})
	})
end

local function RoactChatStackNavigatorWithBackHandler(props)
	local createElement = Roact.createElement
	local provider = BackHandlerContext.Provider
	local v = { value = props.registerBackHandler }

	local createElement2 = Roact.createElement
	local v2 = {
		navigation = props.navigation,
		screenProps = 0,
		navigator = 0,
		onNavigateBack = 0,
		shouldSuppressNavigateBack = 0
	}
	local screenProps

	if FFlagAppChatFoundationHeaderBar then
		screenProps = props.screenProps
	end

	v2.screenProps = screenProps
	v2.navigator = props.navigator
	v2.onNavigateBack = props.onNavigateBack
	v2.shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
	return createElement(provider, v, {
		FocusNavigation = createElement2(RoactChatStackNavigatorWithFocusNavigation, v2)
	})
end

return function(navigator, callback, object, p)
	local extended = Roact.PureComponent:extend("RoactChatStackNavigator")

	extended.defaultProps = {
		navigation = nil,
		parameters = nil,
		setActiveConversationId = function() end,
		setBackButtonEnabled = function() end,
		setTabBarVisible = function() end,
		notificationCount = 0
	}

	function extended:init()
		self.backButtonConnection = nil
		self.backHandler = nil
		self.suppressNextButtonBRelease = false
		function self.registerBackHandler(backHandler)
			self.backHandler = backHandler

			return function()
				if self.backHandler == backHandler then
					self.backHandler = nil
				end
			end
		end

		function self.shouldSuppressNavigateBack(p2): boolean
			if not self.suppressNextButtonBRelease then
				return false
			end

			self.suppressNextButtonBRelease = false
			return p2.eventData ~= nil and p2.eventData.KeyCode == Enum.KeyCode.ButtonB
		end

		function self.onBackButtonPressed(): boolean
			if self.backHandler then
				self.backHandler()
				return true
			end

			local navigation = self.props.navigation
			local state = navigation.state
			local index = state.index
			local v = state.routes and state.routes[index]
			local v2

			if v and v.routes then
				v2 = getActiveChildNavigationOptions((navigation.getChildNavigation(v.key)))
			else
				v2 = RoactNavigation.getActiveChildNavigationOptions(navigation)
			end

			if not (callback and v2.isRoot) then
				self.props.navigation.pop()
				return true
			end

			if defineFastFlag then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end

			self.props.navigation.navigate(EnumScreens.EmptyConversation)
			callback()

			if not FFlagAppChatFixRootChatBackNavigation and p and self.props.chatIsVisible then
				p.showExitDialog()
			end

			return false
		end

		function self.onDirectBackButtonPressed()
			self.suppressNextButtonBRelease = self.backHandler ~= nil

			return self.onBackButtonPressed()
		end
	end

	function extended.willUpdate(p2, p3)
		local state = p2.props.navigation.state
		local index = state.index
		local v = state.routes and state.routes[index]
		local v2

		if v then
			v2 = getActiveChildParams(v)
		else
			v2 = state.params
		end

		local state2 = p3.navigation.state
		local index2 = state2.index
		local v3 = state2.routes and state2.routes[index2]
		local v4

		if v3 then
			v4 = getActiveChildParams(v3)
		else
			v4 = state2.params
		end

		local activeConversationId = getActiveConversationId(v2) -- inferred equivalent call
		local activeConversationId2 = getActiveConversationId(v4) -- inferred equivalent call

		if activeConversationId ~= activeConversationId2 then
			p2.props.setActiveConversationId(activeConversationId2)
		end

		local v5

		if FFlagSignalsNavDeferProjection then
			v5 = getIsChatVisibleNow()
		else
			v5 = p3.chatIsVisible
		end

		if not v5 then
			return
		end

		local state3 = p3.navigation.state
		local route = state3.routes[state3.index]
		local navigation = p3.navigation
		local state4 = navigation.state
		local index3 = state4.index
		local v6 = state4.routes and state4.routes[index3]
		local v7

		if v6 and v6.routes then
			v7 = getActiveChildNavigationOptions((navigation.getChildNavigation(v6.key)))
		else
			v7 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		local v8 = GetTopBarStore(false).getScreenTopBar(route.routeName)()

		if v8.backButtonEnabled ~= nil then
			p2.props.setBackButtonEnabled(v8.backButtonEnabled)
		end

		if v7 and v7.tabBarVisible ~= nil then
			p2.props.setTabBarVisible(v7.tabBarVisible)
		end
	end

	function extended:didMount()
		if object and callback then
			self.backButtonConnection = object:connect(self.onDirectBackButtonPressed)
		end

		local parameters = self.props.parameters
		local conversationId = parameters and parameters.conversationId

		if conversationId then
			self.props.navigation.navigate(EnumScreens.ChatConversation, {
				conversationId = conversationId
			})
		end
	end

	function extended:willUnmount()
		self.props.setActiveConversationId(nil)
		self.backHandler = nil
		self.suppressNextButtonBRelease = false

		if self.backButtonConnection then
			self.backButtonConnection:disconnect()
		end
	end

	function extended.render(props)
		local navigation = props.props.navigation
		local createElement = Roact.createElement
		local screenProps

		if FFlagAppChatFoundationHeaderBar then
			screenProps = props.props.screenProps
		end

		return createElement(RoactChatStackNavigatorWithBackHandler, {
			navigation = navigation,
			screenProps = screenProps,
			navigator = navigator,
			onNavigateBack = props.onBackButtonPressed,
			registerBackHandler = props.registerBackHandler,
			shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
		})
	end

	extended.router = navigator.router

	return extended
end
