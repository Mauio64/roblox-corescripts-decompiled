local module = require("@luauforge/deferred/hmD")

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Logger")
local module3 = require("@luauforge/deferred/hno")
local uiBlox = module.UIBlox

local roact = module.Roact
local roactRodux = module.RoactRodux
local roactNavigation = module.RoactNavigation
local memoize = module.memoize
local retrievalStatus = module.RetrievalStatus

local Context = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Context")
local module5 = require("@luauforge/deferred/hnv")
local module6 = require("@luauforge/deferred/hnx")
local loadingStateContainer = uiBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = uiBlox.App.Loading.Enum.RetrievalStatus
local module7 = require("@luauforge/deferred/hnz")
local module8 = require("@luauforge/deferred/hnB")

local fFlagCreateConnectionsHub = require("@luauforge/deferred/hmG").FFlagCreateConnectionsHub
local fFlagSignalsNavP3Final = require("@luauforge/deferred/hmG").FFlagSignalsNavP3Final

local extended = roact.PureComponent:extend("SocialTabEntryPoint")
extended.defaultProps = { logger = nil }

function extended.getDerivedStateFromProps(p2, p3)
	return {
		wasEverDoneRetrieving = p2.retrievalStatus == retrievalStatus.Done or nil
	}
end

function extended:init()
	if self.props.logger then
		Logger:setParent(self.props.logger)
	end

	function self.connectSocTabExternalDispatch(callback)
		if not self.props.updateExternalNavigationForScreen then
			return function() end
		end

		local roactChat = module6.RoactChat
		self.props.updateExternalNavigationForScreen(function(p2)
			callback(roactNavigation.Actions.navigate({ routeName = module6.RoactChat }))

			self.props.navigateIntoChat({ screen = "ChatConversation", params = p2 })
		end, roactChat)

		return function()
			self.props.updateExternalNavigationForScreen(nil, roactChat)
		end
	end

	self._performanceTesting = self.props.performanceTesting

	local signals = {
		[module6.SocialTab] = self.props.signal.new(),
		[module6.RoactChat] = self.props.signal.new()
	}
	self.androidBackButtonSignal = signals

	self.getAppContainer = memoize(function(p2, p3)
		local v5 = { [module6.RoactChat] = p2 }

		local v7 = {
			setTabBarVisible = self.props.setTabBarVisible,
			androidBackButtonSignal = self.androidBackButtonSignal,
			connectToAndroidBackButton = self.props.androidBackButtonConnection.connect,
			disconnectFromAndroidBackButton = self.props.androidBackButtonConnection.disconnect,
			androidBackButtonConnection = self.props.androidBackButtonConnection,
			initialRouteName = self.props.initialRouteName,
			navigateToAddFriends = 0
		}
		local v8 = if not fFlagCreateConnectionsHub then self.props.navigateToAddFriends else nil
		v7.navigateToAddFriends = v8
		local v9 = module5(v5, v7)

		return roactNavigation.createAppContainer(v9)
	end)

	self.getAnalytics = memoize(function(p2)
		return module3.Class.new(module.AnalyticsService, p2.localUserId)
	end)

	function self.fetchChatSettings(p2)
		return self.props.fetchChatSettings(p2)
	end

	function self.renderRoactChat()
		if self.props.debug_mockRenderRoactChat then
			return self.props.debug_mockRenderRoactChat()
		end

		return Context.with(function(p2)
			return p2.wasEverVisible and roact.createElement(self.props.roactChatEntryPoint, p2) or nil
		end)
	end

	function self.renderAppContainer(p2, p3)
		if self.props.debug_mockRenderAppContainer then
			return self.props.debug_mockRenderAppContainer()
		end

		local connectSocTabExternalDispatch = self.connectSocTabExternalDispatch
		local createElement = roact.createElement
		local v5 = {
			externalDispatchConnector = connectSocTabExternalDispatch,
			androidBackButtonHandlerDisabled = p3.androidBackButtonHandlerDisabled,
			getAndroidBackButtonHandlerDisabled = 0
		}

		local v6 = if fFlagSignalsNavP3Final then p3.getAndroidBackButtonHandlerDisabled else nil
		v5.getAndroidBackButtonHandlerDisabled = v6
		return createElement(p2, v5)
	end

	function self.getLoadingState()
		local v5 = retrievalStatus2.fromRawValue(self.props.retrievalStatus)

		if self.state.wasEverDoneRetrieving then
			v5 = retrievalStatus2.fromRawValue(retrievalStatus.Done)
		end

		return roact.createElement(loadingStateContainer, {
			dataStatus = v5,
			onRetry = self.fetchChatSettings,
			renderOnLoaded = self.renderOnLoaded
		})
	end

	function self.renderOnLoaded()
		return Context.with(function(p2)
			local appContainer = self.getAppContainer(p2.roactChatEntryPoint)
			return roact.createElement(module3.Context.Provider, {
				value = self.getAnalytics(p2)
			}, {
				appContainer = self.renderAppContainer(appContainer, p2)
			})
		end)
	end
end

function extended.didMount(p2)
	if p2.androidBackButtonSignal then
		p2.androidBackButtonSignal[module6.SocialTab]:connect(function()
			if p2.props.isVisible then
				p2.props.androidBackButtonConnection.showExitDialog()
			end
		end)
	end
end

function extended.didUpdate(p2, p3, p4)
	if not p3.chatLoaded and p2.props.chatLoaded then
		p2.props.notificationService:ActionEnabled(Enum.AppShellActionType.TapConversationEntry)
	end

	if p2.props.retrievalStatus == retrievalStatus.NotStarted then
		p2.fetchChatSettings(p2.props.setAppLoaded)
	end
end

function extended.render(p2)
	return Context.with(function(p3)
		return roact.createElement(module3.Context.Provider, {
			value = p2.getAnalytics(p3)
		}, {
			LoadingState = p2.getLoadingState()
		})
	end)
end

local v5 = roactRodux.connect(module7, module8)(extended)
return (Context.connect(function(data)
	return {
		fetchUnreadConversationCount = data.fetchUnreadConversationCount,
		setAppLoaded = data.setAppLoaded,
		roactChatEntryPoint = data.roactChatEntryPoint,
		notificationService = data.notificationService,
		config = data.config,
		performanceTesting = data.performanceTesting,
		notificationType = data.notificationType,
		updateExternalNavigationForScreen = data.updateExternalNavigationForScreen
	}
end)(v5))
