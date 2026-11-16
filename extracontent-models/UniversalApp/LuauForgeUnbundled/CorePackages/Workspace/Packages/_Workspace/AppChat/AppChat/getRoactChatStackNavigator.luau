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

	return Roact.createFragment({
		FocusNavigationContainer = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = v6 },
			{
				navigator = Roact.createElement(props.navigator, {
					navigation = props.navigation
				})
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

return function(p2, callback, object, p3)
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

		function self.shouldSuppressNavigateBack(p4): boolean
			if not self.suppressNextButtonBRelease then
				return false
			end

			self.suppressNextButtonBRelease = false
			return p4.eventData ~= nil and p4.eventData.KeyCode == Enum.KeyCode.ButtonB
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

			if not fFlagAppChatFixRootChatBackNavigation and p3 and self.props.chatIsVisible then
				p3.showExitDialog()
			end

			return false
		end

		function self.onDirectBackButtonPressed()
			self.suppressNextButtonBRelease = self.backHandler ~= nil

			return self.onBackButtonPressed()
		end
	end

	function extended.willUpdate(p4, p5)
		local state = p4.props.navigation.state
		local index = state.index
		local v5 = state.routes and state.routes[index]

		local v6 = if v5 then getActiveChildParams(v5) else state.params

		local state2 = p5.navigation.state
		local index2 = state2.index
		local v7 = state2.routes and state2.routes[index2]

		local v8 = if v7 then getActiveChildParams(v7) else state2.params

		local v9 = if v6 then (if v6.conversation then v6.conversation.id else v6.conversationId) else nil
		local v10 = if v8 then (if v8.conversation then v8.conversation.id else v8.conversationId) else nil

		if v9 ~= v10 then
			p4.props.setActiveConversationId(v10)
		end

		if not p5.chatIsVisible then
			return
		end

		local state3 = p5.navigation.state
		local route = state3.routes[state3.index]
		local navigation = p5.navigation
		local state4 = navigation.state
		local index3 = state4.index
		local v11 = state4.routes and state4.routes[index3]
		local v12

		if v11 and v11.routes then
			v12 = getActiveChildNavigationOptions((navigation.getChildNavigation(v11.key)))
		else
			v12 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		local v13 = GetTopBarStore(false).getScreenTopBar(route.routeName)()

		if v13.backButtonEnabled ~= nil then
			p4.props.setBackButtonEnabled(v13.backButtonEnabled)
		end

		if v12 and v12.tabBarVisible ~= nil then
			p4.props.setTabBarVisible(v12.tabBarVisible)
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
			navigator = p2,
			onNavigateBack = props.onBackButtonPressed,
			registerBackHandler = props.registerBackHandler,
			shouldSuppressNavigateBack = props.shouldSuppressNavigateBack
		})
	end

	extended.router = p2.router

	return extended
end
