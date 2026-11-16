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

require(AppChat.types)
local function getActiveChildParams(data)
	local index = data.index
	local v = data.routes and data.routes[index]

	if v then
		return getActiveChildParams(v)
	end

	return data.params
end

local function getActiveChildNavigationOptions(p)
	local state = p.state
	local index = state.index
	local v = state.routes and state.routes[index]

	if v and v.routes then
		return getActiveChildNavigationOptions((p.getChildNavigation(v.key)))
	end

	return RoactNavigation.getActiveChildNavigationOptions(p)
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

	return Roact.createFragment({
		FocusNavigationContainer = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = ref },
			{
				navigator = Roact.createElement(props.navigator, { navigation = props.navigation })
			}
		)
	})
end

local function RoactChatStackNavigatorWithBackHandler(props)
	return Roact.createElement(BackHandlerContext.Provider, { value = props.registerBackHandler }, {
		FocusNavigation = Roact.createElement(RoactChatStackNavigatorWithFocusNavigation, {
			navigation = props.navigation,
			navigator = props.navigator,
			onNavigateBack = props.onNavigateBack,
			shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
		})
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

		if not p3.chatIsVisible then
			return
		end

		local state3 = p3.navigation.state
		local route = state3.routes[state3.index]
		local navigation = p3.navigation
		local state4 = navigation.state
		local index3 = state4.index
		local v5 = state4.routes and state4.routes[index3]
		local v6

		if v5 and v5.routes then
			v6 = getActiveChildNavigationOptions((navigation.getChildNavigation(v5.key)))
		else
			v6 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		local v7 = GetTopBarStore(false).getScreenTopBar(route.routeName)()

		if v7.backButtonEnabled ~= nil then
			p2.props.setBackButtonEnabled(v7.backButtonEnabled)
		end

		if v6 and v6.tabBarVisible ~= nil then
			p2.props.setTabBarVisible(v6.tabBarVisible)
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
		return Roact.createElement(RoactChatStackNavigatorWithBackHandler, {
			navigation = navigation,
			navigator = navigator,
			onNavigateBack = props.onBackButtonPressed,
			registerBackHandler = props.registerBackHandler,
			shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
		})
	end

	extended.router = navigator.router

	return extended
end
