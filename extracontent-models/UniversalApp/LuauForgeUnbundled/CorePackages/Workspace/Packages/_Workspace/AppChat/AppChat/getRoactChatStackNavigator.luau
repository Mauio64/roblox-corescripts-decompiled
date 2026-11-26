local IXPService = game:GetService("IXPService")

local BackHandlerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/BackHandlerContext")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local fFlagAppChatFixRootChatBackNavigation = SharedFlags.FFlagAppChatFixRootChatBackNavigation

local defineFastFlag = game:DefineFastFlag("AppChatFixRootChatBackNavigationIxpEnabled", false)

local defineFastString = game:DefineFastString(
	"AppChatFixRootChatBackNavigationIxpLayer",
	"Party.LandingPage"
)

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local fFlagSignalsNavDeferProjection = SharedFlags.FFlagSignalsNavDeferProjection

local getIsChatVisibleNow = if fFlagSignalsNavDeferProjection then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getIsChatVisibleNow").getIsChatVisibleNow else nil

local FFlagAppChatFoundationHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationHeaderBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local function getActiveChildParams(data)
	local index = data.index
	local v5 = data.routes and data.routes[index]

	if v5 then
		return getActiveChildParams(v5)
	end

	return data.params
end

local function getActiveChildNavigationOptions(childNavigation)
	local state = childNavigation.state
	local index = state.index
	local v5 = state.routes and state.routes[index]

	if v5 and v5.routes then
		return getActiveChildNavigationOptions((childNavigation.getChildNavigation(v5.key)))
	end

	return RoactNavigation.getActiveChildNavigationOptions(childNavigation)
end

local function getActiveConversationId(p2)
	if not p2 then
		return nil
	end

	if p2.conversation then
		return p2.conversation.id
	end

	return p2.conversationId
end

local function RoactChatStackNavigatorWithFocusNavigation(props)
	local v5 = React.useCallback(InputHandlers.onRelease(function(object)
		if props.shouldSuppressNavigateBack(object) then
			object:cancel()
		elseif props.onNavigateBack() then
			object:cancel()
		end
	end), { props.onNavigateBack, props.shouldSuppressNavigateBack })

	local v6 = ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v5)

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v9 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = v6 }

	local createElement2 = Roact.createElement
	local navigator = props.navigator
	local v11 = { navigation = props.navigation, screenProps = 0 }

	local v12 = if FFlagAppChatFoundationHeaderBar then props.screenProps else nil
	v11.screenProps = v12
	return createFragment({
		FocusNavigationContainer = createElement("Frame", v9, {
			navigator = createElement2(navigator, v11)
		})
	})
end

local function RoactChatStackNavigatorWithBackHandler(props)
	local createElement = Roact.createElement
	local provider = BackHandlerContext.Provider
	local v5 = { value = props.registerBackHandler }

	local createElement2 = Roact.createElement
	local v8 = {
		navigation = props.navigation,
		screenProps = 0,
		navigator = 0,
		onNavigateBack = 0,
		shouldSuppressNavigateBack = 0
	}
	local v9 = if FFlagAppChatFoundationHeaderBar then props.screenProps else nil
	v8.screenProps = v9
	v8.navigator = props.navigator
	v8.onNavigateBack = props.onNavigateBack
	v8.shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
	return createElement(provider, v5, {
		FocusNavigation = createElement2(RoactChatStackNavigatorWithFocusNavigation, v8)
	})
end

return function(navigator, callback, object, p2)
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

		function self.shouldSuppressNavigateBack(p3): boolean
			if not self.suppressNextButtonBRelease then
				return false
			end

			self.suppressNextButtonBRelease = false
			return p3.eventData ~= nil and p3.eventData.KeyCode == Enum.KeyCode.ButtonB
		end

		function self.onBackButtonPressed(): boolean
			if self.backHandler then
				self.backHandler()
				return true
			end

			local navigation = self.props.navigation
			local state2 = navigation.state
			local index = state2.index
			local v5 = state2.routes and state2.routes[index]
			local v6

			if v5 and v5.routes then
				v6 = getActiveChildNavigationOptions((navigation.getChildNavigation(v5.key)))
			else
				v6 = RoactNavigation.getActiveChildNavigationOptions(navigation)
			end

			if not (callback and v6.isRoot) then
				self.props.navigation.pop()
				return true
			end

			if defineFastFlag then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end

			self.props.navigation.navigate(EnumScreens.EmptyConversation)
			callback()

			if not fFlagAppChatFixRootChatBackNavigation and p2 and self.props.chatIsVisible then
				p2.showExitDialog()
			end

			return false
		end

		function self.onDirectBackButtonPressed()
			self.suppressNextButtonBRelease = self.backHandler ~= nil

			return self.onBackButtonPressed()
		end
	end

	function extended.willUpdate(p3, p4)
		local state = p3.props.navigation.state
		local index = state.index
		local v5 = state.routes and state.routes[index]

		local v6 = if v5 then getActiveChildParams(v5) else state.params

		local state2 = p4.navigation.state
		local index2 = state2.index
		local v7 = state2.routes and state2.routes[index2]

		local v8 = if v7 then getActiveChildParams(v7) else state2.params

		local v9 = if v6 then (if v6.conversation then v6.conversation.id else v6.conversationId) else nil
		local v10 = if v8 then (if v8.conversation then v8.conversation.id else v8.conversationId) else nil

		if v9 ~= v10 then
			p3.props.setActiveConversationId(v10)
		end

		local v11 = if fFlagSignalsNavDeferProjection then getIsChatVisibleNow() else p4.chatIsVisible

		if not v11 then
			return
		end

		local state3 = p4.navigation.state
		local route = state3.routes[state3.index]
		local navigation = p4.navigation
		local state4 = navigation.state
		local index3 = state4.index
		local v12 = state4.routes and state4.routes[index3]
		local v13

		if v12 and v12.routes then
			v13 = getActiveChildNavigationOptions((navigation.getChildNavigation(v12.key)))
		else
			v13 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		local v14 = GetTopBarStore(false).getScreenTopBar(route.routeName)()

		if v14.backButtonEnabled ~= nil then
			p3.props.setBackButtonEnabled(v14.backButtonEnabled)
		end

		if v13 and v13.tabBarVisible ~= nil then
			p3.props.setTabBarVisible(v13.tabBarVisible)
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

		local v7 = if FFlagAppChatFoundationHeaderBar then props.props.screenProps else nil
		return createElement(RoactChatStackNavigatorWithBackHandler, {
			navigation = navigation,
			screenProps = v7,
			navigator = navigator,
			onNavigateBack = props.onBackButtonPressed,
			registerBackHandler = props.registerBackHandler,
			shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
		})
	end

	extended.router = navigator.router

	return extended
end
