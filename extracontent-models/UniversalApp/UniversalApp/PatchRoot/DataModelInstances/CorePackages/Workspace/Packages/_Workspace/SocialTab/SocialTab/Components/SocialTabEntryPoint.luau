local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local Logger = require(SocialTab.Logger)
local Analytics = require(SocialTab.Analytics)
local UIBlox = dependencies.UIBlox
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local RoactNavigation = dependencies.RoactNavigation
local memoize = dependencies.memoize
local RetrievalStatus = dependencies.RetrievalStatus
local SocialTabContext = require(SocialTab.SocialTabContext)
local getSocialTabNavigator = require(SocialTab.Navigators.getSocialTabNavigator)
local EnumScreens = require(SocialTab.EnumScreens)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local mapStateToProps = require(SocialTab.Components.SocialTabEntryPoint.mapStateToProps)
local mapDispatchToProps = require(SocialTab.Components.SocialTabEntryPoint.mapDispatchToProps)
local FFlagCreateConnectionsHub = require(SocialTabParent.SharedFlags).FFlagCreateConnectionsHub
local v20 = Roact.PureComponent:extend("SocialTabEntryPoint")

v20.defaultProps = {
	logger = nil
}

function v20.getDerivedStateFromProps(p1, _) -- line: 43
	-- upvalues: RetrievalStatus (copy)
	local v24 = nil

	if p1.retrievalStatus == RetrievalStatus.Done then
		v24 = true
	end

	return {
		wasEverDoneRetrieving = v24
	}
end
function v20.init(p3) -- line: 55
	-- upvalues: Logger (copy), EnumScreens (copy), RoactNavigation (copy), memoize (copy), getSocialTabNavigator (copy), FFlagCreateConnectionsHub (copy), Analytics (copy), dependencies (copy), SocialTabContext (copy), Roact (copy), RetrievalStatus2 (copy), RetrievalStatus (copy), LoadingStateContainer (copy)
	if p3.props.logger then
		Logger:setParent(p3.props.logger)
	end

	function p3.connectSocTabExternalDispatch(p4) -- line: 60
		-- upvalues: p3 (copy), EnumScreens (copy), RoactNavigation (copy)
		if p3.props.updateExternalNavigationForScreen then
			local RoactChat = EnumScreens.RoactChat

			p3.props.updateExternalNavigationForScreen(function(p5) -- line: 63
				-- upvalues: p4 (copy), RoactNavigation (copy), EnumScreens (copy), p3 (copy)
				p4(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.RoactChat
				}))
				p3.props.navigateIntoChat({
					screen = "ChatConversation",
					params = p5
				})
			end, RoactChat)

			return function() -- line: 73
				-- upvalues: p3 (copy), RoactChat (copy)
				p3.props.updateExternalNavigationForScreen(nil, RoactChat)
			end
		end

		return function() -- line: 77
		end
	end

	p3._performanceTesting = p3.props.performanceTesting
	p3.androidBackButtonSignal = {
		[EnumScreens.SocialTab] = p3.props.signal.new(),
		[EnumScreens.RoactChat] = p3.props.signal.new()
	}
	p3.getAppContainer = memoize(function(p6, _) -- line: 88
		-- upvalues: EnumScreens (copy), getSocialTabNavigator (copy), p3 (copy), FFlagCreateConnectionsHub (copy), RoactNavigation (copy)
		local t1 = {
			[EnumScreens.RoactChat] = p6
		}
		local v37 = getSocialTabNavigator(t1, {
			setTabBarVisible = p3.props.setTabBarVisible,
			androidBackButtonSignal = p3.androidBackButtonSignal,
			connectToAndroidBackButton = p3.props.androidBackButtonConnection.connect,
			disconnectFromAndroidBackButton = p3.props.androidBackButtonConnection.disconnect,
			androidBackButtonConnection = p3.props.androidBackButtonConnection,
			initialRouteName = p3.props.initialRouteName,
			navigateToAddFriends = if not FFlagCreateConnectionsHub then p3.props.navigateToAddFriends else nil
		})

		return RoactNavigation.createAppContainer(v37)
	end)
	p3.getAnalytics = memoize(function(p8) -- line: 106
		-- upvalues: Analytics (copy), dependencies (copy)
		return Analytics.Class.new(dependencies.AnalyticsService, p8.localUserId)
	end)

	function p3.fetchChatSettings(p9) -- line: 110
		-- upvalues: p3 (copy)
		return p3.props.fetchChatSettings(p9)
	end
	function p3.renderRoactChat() -- line: 114
		-- upvalues: p3 (copy), SocialTabContext (copy), Roact (copy)
		if p3.props.debug_mockRenderRoactChat then
			return p3.props.debug_mockRenderRoactChat()
		end

		return SocialTabContext.with(function(p10) -- line: 118
			-- upvalues: Roact (copy), p3 (copy)
			return p10.wasEverVisible and Roact.createElement(p3.props.roactChatEntryPoint, p10) or nil
		end)
	end
	function p3.renderAppContainer(p11, p12) -- line: 125
		-- upvalues: p3 (copy), Roact (copy)
		if p3.props.debug_mockRenderAppContainer then
			return p3.props.debug_mockRenderAppContainer()
		end

		local connectSocTabExternalDispatch = p3.connectSocTabExternalDispatch

		return Roact.createElement(p11, {
			externalDispatchConnector = connectSocTabExternalDispatch,
			androidBackButtonHandlerDisabled = p12.androidBackButtonHandlerDisabled
		})
	end
	function p3.getLoadingState() -- line: 137
		-- upvalues: RetrievalStatus2 (copy), p3 (copy), RetrievalStatus (copy), Roact (copy), LoadingStateContainer (copy)
		local v43 = RetrievalStatus2.fromRawValue(p3.props.retrievalStatus)

		if p3.state.wasEverDoneRetrieving then
			v43 = RetrievalStatus2.fromRawValue(RetrievalStatus.Done)
		end

		return Roact.createElement(LoadingStateContainer, {
			dataStatus = v43,
			onRetry = p3.fetchChatSettings,
			renderOnLoaded = p3.renderOnLoaded
		})
	end
	function p3.renderOnLoaded() -- line: 150
		-- upvalues: SocialTabContext (copy), p3 (copy), Roact (copy), Analytics (copy)
		return SocialTabContext.with(function(p13) -- line: 151
			-- upvalues: p3 (copy), Roact (copy), Analytics (copy)
			local v48 = p3.getAppContainer(p13.roactChatEntryPoint)

			return Roact.createElement(Analytics.Context.Provider, {
				value = p3.getAnalytics(p13)
			}, {
				appContainer = p3.renderAppContainer(v48, p13)
			})
		end)
	end
end
function v20.didMount(p14) -- line: 162
	-- upvalues: EnumScreens (copy)
	if p14.props.isVisible and p14.props.toggleChatPaused ~= nil then
		p14.props.toggleChatPaused(false)
	end

	if p14.androidBackButtonSignal then
		p14.androidBackButtonSignal[EnumScreens.SocialTab]:connect(function() -- line: 170
			-- upvalues: p14 (copy)
			if p14.props.isVisible then
				p14.props.androidBackButtonConnection.showExitDialog()
			end
		end)
	end
end
function v20.didUpdate(p15, p16, _) -- line: 178
	-- upvalues: RetrievalStatus (copy)
	if not p16.chatLoaded and p15.props.chatLoaded then
		p15.props.notificationService:ActionEnabled(Enum.AppShellActionType.TapConversationEntry)
	end

	if p15.props.retrievalStatus == RetrievalStatus.NotStarted then
		p15.fetchChatSettings(p15.props.setAppLoaded)
	end
end
function v20.render(p18) -- line: 188
	-- upvalues: SocialTabContext (copy), Roact (copy), Analytics (copy)
	return SocialTabContext.with(function(p19) -- line: 189
		-- upvalues: Roact (copy), Analytics (copy), p18 (copy)
		return Roact.createElement(Analytics.Context.Provider, {
			value = p18.getAnalytics(p19)
		}, {
			LoadingState = p18.getLoadingState()
		})
	end)
end

local v21 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v20)

return (SocialTabContext.connect(function(p20) -- line: 199
	return {
		fetchUnreadConversationCount = p20.fetchUnreadConversationCount,
		setAppLoaded = p20.setAppLoaded,
		roactChatEntryPoint = p20.roactChatEntryPoint,
		notificationService = p20.notificationService,
		config = p20.config,
		toggleChatPaused = p20.toggleChatPaused,
		performanceTesting = p20.performanceTesting,
		notificationType = p20.notificationType,
		updateExternalNavigationForScreen = p20.updateExternalNavigationForScreen
	}
end)(v21))
