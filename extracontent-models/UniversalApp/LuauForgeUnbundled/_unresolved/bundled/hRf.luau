local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local tutils = require(CorePackages.Packages.tutils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/cBc")

local gameSortGroups = module.GameSortGroups
local omniFeedTypes = module.OmniFeedTypes
local omniFeedConstants = module.OmniFeedConstants
local useSponsoredAdViewabilityDetector = require("@luauforge/bundled/hRg").useSponsoredAdViewabilityDetector
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics
local appStartupSequenceTag = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupSequenceTag
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local appPrefetch = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPrefetch

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local Promise = require(CorePackages.Packages.Promise)

local setNetworkingErrorToast = require("@luauforge/bundled/egu").Thunks.SetNetworkingErrorToast
local retrievalStatus2 = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local feedScroll = require("@luauforge/bundled/hPW").feedScroll
local module2 = require("@luauforge/bundled/dCR")
local fetchStatusNamespace = module2.FetchStatusNamespace
local fetchStatusReducer = module2.FetchStatusReducer

local verticalEfficiencyExperimentation = require("@luauforge/bundled/egz").VerticalEfficiencyExperimentation
local parseBooleanString = require("@luauforge/bundled/egz").parseBooleanString
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local module4 = require("@luauforge/bundled/cBa")
local module5 = require("@luauforge/bundled/fDy")
local default = module4.AppStartupSequence.default
local module6 = require("@luauforge/bundled/dDZ")
local useCollectionLayoutConfig = require("@luauforge/bundled/ehg").useCollectionLayoutConfig
local module7 = require("@luauforge/bundled/gDL")
local getPlaybackDetectionMethod = module7.getPlaybackDetectionMethod
local useFeedVideoPlaybackContext = module7.useFeedVideoPlaybackContext

local modules = require("@luauforge/bundled/dtb").Modules
local apiFetchOmniRecommendations = modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local omniFeedAutoRefresher = modules.LuaApp.Components.Games.OmniFeedAutoRefresher
local refreshGameSorts = modules.LuaApp.Thunks.RefreshGameSorts
local fetchHomePageData = modules.LuaApp.Thunks.FetchHomePageData

local fetchHomePageContactMethodModuleVariation = modules.LuaApp.Thunks.FetchHomePageContactMethodModuleVariation

local module8 = require("@luauforge/bundled/dzL")
local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage
local getSiteMessageStore = require("@luauforge/bundled/fyU").GetSiteMessageStore
local module9 = require("@luauforge/bundled/dEb")
local module10 = require("@luauforge/bundled/hQE")
local module11 = require("@luauforge/bundled/hRh")
local module12 = require("@luauforge/bundled/hPX")
local module13 = require("@luauforge/bundled/hRi")
local module14 = require("@luauforge/bundled/fyO")
local module15 = require("@luauforge/bundled/hRk")
local module16 = require("@luauforge/bundled/hQP")
local module17 = require("@luauforge/bundled/hRl")
local module18 = require("@luauforge/bundled/hRm")
local module19 = require("@luauforge/bundled/dKq")

local module20 = require("@luauforge/bundled/fBo")
local promptsEntryPoint = module20.PromptsEntryPoint
local promptStyle = module20.PromptStyle

local defineFastInt = game:DefineFastInt("LuaAppHomeFeedProfilePosition", 1)
local defineFastInt2 = game:DefineFastInt("LuaAppHomeFeedFriendsPosition", 1)
local defineFastInt3 = game:DefineFastInt("LuaAppHomeFeedUpsellCardPosition", 1)
local getFFlagFixFetchNextOmniWithoutPageToken = modules.LuaApp.Flags.GetFFlagFixFetchNextOmniWithoutPageToken
local getFFlagEnableHomePageUpsellCard = modules.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard

local fFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBar

local fFlagLuaAppMoveProfileIntoTopBarIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBarIXP

local fFlagLuaAppEnableRelativeGuiHomeForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableRelativeGuiHomeForAll

local fFlagLuaAppEnableRelativeGuiHomeWithIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableRelativeGuiHomeWithIxp
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppRfySignalApportioning = SharedFlags.FFlagLuaAppRfySignalApportioning
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagEnableAppStoreAgeSignalsOnHomePage = SharedFlags.FFlagEnableAppStoreAgeSignalsOnHomePage
local fFlagHomePagePromptsHandlerEnabled = SharedFlags.FFlagHomePagePromptsHandlerEnabled
local fFlagDisableHomePageUpsellCardFeedItem = SharedFlags.FFlagDisableHomePageUpsellCardFeedItem
local fFlagLuaAppScrollTelemetryIntegration = SharedFlags.FFlagLuaAppScrollTelemetryIntegration
local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/gfE").GetStartupStore else nil

local fFlagLuaAppHomePageReadyToRender = SharedFlags.FFlagLuaAppHomePageReadyToRender
local fFlagAppContainerReadyToRender = SharedFlags.FFlagAppContainerReadyToRender
local fFlagLuaAppSupportHomeBackToTop = SharedFlags.FFlagLuaAppSupportHomeBackToTop

local module22 = require("@luauforge/bundled/hRn")
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
local defineFastFlag = game:DefineFastFlag("RemoveMobileHomeProfileHeader_v2", false)

local defineFastFlag2 = game:DefineFastFlag("AppIaHomeOmniFeedFix", false)

local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local useOnScreenNavigationListener

if fFlagEnableOnScreenAPIIntegration then
	useOnScreenNavigationListener = require("@luauforge/bundled/dFz").useOnScreenNavigationListener
else
	useOnScreenNavigationListener = nil
end

local v5 = { navigation = true }
local home = appPage.Home

local v6 = defineFastFlag2 and {} or nil

local function HomeOmniFeedOnScreenListener(p2): nil
	useOnScreenNavigationListener(p2.onFocus, nil)
	return nil
end

local extended = Roact.PureComponent:extend("HomeOmniFeed")

local strictInterface = t.strictInterface

local v8 = if fFlagAppIaScrollAway then t.optional(t.number) else nil
local v7 = {}
v7.canvasTopPadding = v8
v7.hasNextPage = t.optional(t.boolean)
local v9 = if getFFlagFixFetchNextOmniWithoutPageToken() then t.optional(t.string) else nil
v7.homeOmniFetchStatus = v9
v7.localUserId = t.string
v7.homePageDataStatus = t.string
local v10 = if defineFastFlag2 then t.table else t.optional(t.table)
v7.omniFeedItems = v10
v7.hasLocalOmniItems = t.optional(t.boolean)
v7.recommendationsRequestId = t.optional(t.string)
v7.omniSessionId = t.optional(t.string)
v7.omniItemsGlobalLayoutData = t.optional(t.table)
v7.screenSize = t.Vector2
local v11 = if fFlagLuaAppMoveProfileIntoTopBar then t.string else nil
v7.formFactor = v11
v7.upsellCardVariation = t.optional(t.table)
v7.defaultFocusRef = t.optional(t.callback)

v7.addLocalFeedItems = t.callback
v7.refresh = t.callback
v7.loadNext = t.optional(t.callback)
v7.fetchHomePageData = t.callback
v7.fetchHomePageContactMethodModuleVariation = t.optional(t.callback)

v7.isOmni = t.optional(t.boolean)

v7.appAnalytics = t.any
v7.networking = t.any
v7.loggingProtocol = t.optional(t.any)
v7.prefetchProtocol = t.optional(t.any)
v7.sessionService = t.optional(t.any)
v7.appStartupSequence = t.any
v7.eventIngest = t.any
v7.appLifecycleObserverService = t.optional(t.any)

v7.navigation = t.any

v7.header = t.optional(t.any)
v7.headerHeight = t.number

local v12 = if fFlagLuaAppEnableRelativeGuiHomeForAll or fFlagLuaAppEnableRelativeGuiHomeWithIxp then t.optional(t.boolean) else nil
v7.relativeGuiEnabled = v12

v7.shouldStopAfterOneGameSort = t.boolean
v7.sduiContext = t.table
local v13 = if fFlagLuaAppLayoutParamsInContext then t.optional(t.callback) else nil
v7.setScrollingFrame = v13

v7.videoPlaybackContext = t.optional(t.table)
v7.onScrollStart = t.optional(t.callback)
v7.onScrollSettled = t.optional(t.callback)
extended.validateProps = strictInterface(v7)

local function isRetrievalStatusFinal(p2): boolean
	return p2 ~= retrievalStatus2.NotStarted and p2 ~= retrievalStatus2.Fetching
end

local function fn(upsellCardType, upsellCardVariation)
	if
		upsellCardType == module17.ContactMethodPhoneNumber
		or upsellCardType == module17.ContactMethodPhoneNumberVoiceOptIn
		or upsellCardType == module17.ContactMethodPhoneNumberEmailVerticalLayout
		or upsellCardType == module17.ContactMethodPhoneNumberEmailHorizontalLayout
		or module18() and upsellCardType == module17.ContactMethodEmail
		or module19() and upsellCardType == module17.VoiceWithoutPvTrial
	then
		upsellCardVariation = true
	elseif upsellCardVariation then
		if upsellCardVariation.upsellCardType == "" then
			upsellCardVariation = false
		else
			upsellCardVariation = upsellCardVariation.upsellCardV2Config ~= nil
		end
	end

	return upsellCardVariation
end

function extended:init()
	self.props.loggingProtocol:logEventOnce("home_page_container_init")

	self.isMounted = false

	function self.loadNext()
		local hasNextPage = self.props.hasNextPage
		local loadNext = self.props.loadNext

		if getFFlagFixFetchNextOmniWithoutPageToken() then
			local homeOmniFetchStatus = self.props.homeOmniFetchStatus

			if hasNextPage and loadNext and homeOmniFetchStatus ~= retrievalStatus2.Fetching then
				return loadNext(
					self.props.networking,
					self.props.omniRecommendationsRequest,
					self.props.loggingProtocol
				)
			end
		elseif hasNextPage and loadNext then
			return loadNext(
				self.props.networking,
				self.props.omniRecommendationsRequest,
				self.props.loggingProtocol
			)
		end

		return Promise.resolve()
	end

	function self.fetchHomePageData()
		return self.props.fetchHomePageData(
			self.props.networking,
			self.props.omniRecommendationsRequest,
			self.props.appAnalytics,
			self.props.localUserId,
			self.props.isOmni,
			self.props.loggingProtocol,
			self.props.prefetchProtocol
		)
	end

	function self.fetchHomePageContactMethodModuleVariation()
		return self.props.fetchHomePageContactMethodModuleVariation(self.props.networking)
	end

	self.scrollingFrameRef = Roact.createRef()

	if fFlagLuaAppLayoutParamsInContext then
		function self.setScrollingFrameRef(current)
			self.scrollingFrameRef.current = current

			if self.props.setScrollingFrame then
				self.props.setScrollingFrame(current)
			end
		end
	end

	function self.sendScrollEvent(p2, scrollDuration, startPos)
		local y = Enum.ScrollingDirection.Y

		if y then
			local v14 = not self.scrollingFrameRef.current and 0
				or self.scrollingFrameRef.current.AbsoluteSize.Y

			local v15 = {
				distance = p2,
				screenSizeX = self.props.screenSize.X,
				screenSizeY = self.props.screenSize.Y,
				scrollAreaSize = v14,
				scrollDepth = 0,
				startDepth = 0,
				startPos = 0,
				scrollDuration = 0
			}

			local v16 = if v14 > 0 then p2 / v14 else nil
			v15.scrollDepth = v16
			local v17 = if v14 > 0 then startPos / v14 else nil
			v15.startDepth = v17
			v15.startPos = startPos
			v15.scrollDuration = scrollDuration

			feedScroll(self.props.eventIngest, home, y, v15)
		end
	end

	function self.logHomePageInteractive(p2)
		if not self.isMounted then
			return
		end

		module16(p2, {
			loggingProtocol = self.props.loggingProtocol,
			appStartupSequence = self.props.appStartupSequence,
			appLifecycleObserverService = self.props.appLifecycleObserverService
		})
	end

	function self.setHomePageSessionInfoFunc()
		module11(self.props.sessionService, self.props.recommendationsRequestId, self.props.omniSessionId)
	end

	function self.insertLocalFeedItem(list, p2, p3, p4, p5)
		table.insert(list, {
			orderIndex = p2,
			treatmentType = p3,
			treatmentProps = p4,
			numberOfRows = p5
		})
	end

	function self.createLocalFeedItems()
		local homePageDataStatus = self.props.homePageDataStatus
		local v14

		if homePageDataStatus == retrievalStatus2.NotStarted then
			v14 = false
		else
			v14 = homePageDataStatus ~= retrievalStatus2.Fetching
		end

		if not v14 then
			return
		end

		local v15 = {}
		local v16

		if fFlagLuaAppMoveProfileIntoTopBar then
			if self.props.formFactor == formFactor.COMPACT then
				v16 = not fFlagLuaAppMoveProfileIntoTopBarIXP
					or verticalEfficiencyExperimentation.getIsProfileMovedToTopBar()
			else
				v16 = false
			end
		end

		if
			defineFastInt > 0
			and not (fFlagLuaAppMoveProfileIntoTopBar and v16 or module22 and flyoutSidePanelIXP.isProfileEntryRemoved() or defineFastFlag)
		then
			self.insertLocalFeedItem(v15, defineFastInt, omniFeedTypes.UserInfo, {}, 0)
		end

		if fFlagHomePagePromptsHandlerEnabled then
			self.insertLocalFeedItem(v15, defineFastInt3, omniFeedTypes.Prompts, {
				entryPoint = promptsEntryPoint.HomepageLaunch,
				promptStyle = promptStyle.InlineBanner
			})
		end

		if
			not fFlagDisableHomePageUpsellCardFeedItem
			and getFFlagEnableHomePageUpsellCard()
			and self.props.upsellCardVariation
			and fn(self.props.upsellCardVariation.upsellCardType, self.props.upsellCardVariation)
			and defineFastInt3 > 0
		then
			self.insertLocalFeedItem(v15, defineFastInt3, omniFeedTypes.UpsellCard, {})
		end

		local omniItemsGlobalLayoutData = self.props.omniItemsGlobalLayoutData

		if
			(not omniItemsGlobalLayoutData or omniItemsGlobalLayoutData[omniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] ~= "true" and omniItemsGlobalLayoutData[omniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] ~= true)
			and defineFastInt2 > 0
		then
			self.insertLocalFeedItem(v15, defineFastInt2, omniFeedTypes.FriendCarousel, {})
		end

		self.props.addLocalFeedItems(v15)
	end

	function self.fetchDataIfNeeded()
		if self.props.homePageDataStatus == retrievalStatus2.NotStarted then
			self.fetchHomePageData()
		end
	end

	if not fFlagEnableOnScreenAPIIntegration then
		self._willFocusListener = self.props.navigation.addListener(
			RoactNavigation.Events.WillFocus,
			function()
				self.fetchDataIfNeeded()
			end
		)
	end

	function self.omniFeedRefresh(p2)
		return self.props.refresh(
			self.props.networking,
			self.props.omniRecommendationsRequest,
			self.props.isOmni,
			p2,
			self.props.loggingProtocol
		)
	end

	self.fetchDataIfNeeded()

	self.createLocalFeedItems()
end

function extended.render(props)
	local homePageDataStatus = props.props.homePageDataStatus
	local isOmni = props.props.isOmni
	local v14

	if homePageDataStatus == retrievalStatus2.NotStarted then
		v14 = false
	else
		v14 = homePageDataStatus ~= retrievalStatus2.Fetching
	end

	local v15

	if v14 and not props.props.hasLocalOmniItems then
		v15 = retrievalStatus2.Fetching
	else
		v15 = homePageDataStatus
	end

	if
		not fFlagLuaAppHomePageReadyToRender
		and not fFlagAppContainerReadyToRender
		and game:GetEngineFeature("SlowDownRendering")
		and homePageDataStatus ~= retrievalStatus2.Done
	then
		props.props.appLifecycleObserverService:TriggerOnLuaAppReadyToRender()
	end

	local createElement = Roact.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v18 = if fFlagEnableOnScreenAPIIntegration then Roact.createElement(HomeOmniFeedOnScreenListener, {
		onFocus = props.fetchDataIfNeeded
	}) else nil
	return createElement("Frame", v17, {
		OnScreenListener = v18,
		SocialUpsellEventReceiver = Roact.createElement(module5.SocialUpsellEventReceiver, {
			onAgeVerifiedChange = props.fetchHomePageContactMethodModuleVariation,
			shouldRequestAppAgeSignals = fFlagEnableAppStoreAgeSignalsOnHomePage
		}),
		TokenRefreshComponent = Roact.createElement(omniFeedAutoRefresher, {
			isOmni = isOmni,
			pageType = appPage.Home,
			sortToRefresh = gameSortGroups.HomeGames
		}),
		PageSessionManager = Roact.createElement(module10, {
			appPage = home,
			setPageSession = props.setHomePageSessionInfoFunc
		}),
		LoadingStateContainer = Roact.createElement(loadingStateContainer, {
			dataStatus = retrievalStatus.fromRawValue(v15),
			onRetry = props.fetchHomePageData,
			renderOnLoaded = function()
				local createElement2 = Roact.createElement
				local v20 = {
					pageContext = home,
					refresh = props.omniFeedRefresh,
					omniFeedItems = props.props.omniFeedItems,
					impressionsTag = "FEEDITEM_IMPRESSIONS",
					onAbsoluteSizeChanged = props.logHomePageInteractive,
					hasNextPage = props.props.hasNextPage,
					loadNext = props.loadNext,
					scrollingFrameRef = 0,
					analyticsContext = 0,
					header = 0,
					headerHeight = 0,
					sendScrollEvent = 0,
					enableRelativeGui = 0,
					shouldStopAfterOneGameSort = 0,
					topPadding = 0,
					canvasTopPadding = 0,
					sduiContext = 0,
					appCompositionEnabled = true,
					videoPlaybackContext = 0,
					onScrollStart = 0,
					onScrollSettled = 0,
					defaultFocusRef = 0,
					scrollPerformanceIntervalName = 0,
					createEndOfScrollElement = 0
				}

				local v21 = if fFlagLuaAppLayoutParamsInContext then props.setScrollingFrameRef else props.scrollingFrameRef
				v20.scrollingFrameRef = v21

				v20.analyticsContext = omniFeedConstants.EventContext
				v20.header = props.props.header
				v20.headerHeight = props.props.headerHeight
				v20.sendScrollEvent = props.sendScrollEvent

				local v22 = if fFlagLuaAppEnableRelativeGuiHomeForAll or fFlagLuaAppEnableRelativeGuiHomeWithIxp then props.props.relativeGuiEnabled else nil
				v20.enableRelativeGui = v22

				v20.shouldStopAfterOneGameSort = props.props.shouldStopAfterOneGameSort
				v20.topPadding = defineFastFlag and 0 or nil
				local v23 = if fFlagAppIaScrollAway then props.props.canvasTopPadding else nil
				v20.canvasTopPadding = v23
				v20.sduiContext = props.props.sduiContext

				v20.videoPlaybackContext = props.props.videoPlaybackContext
				v20.onScrollStart = props.props.onScrollStart
				v20.onScrollSettled = props.props.onScrollSettled
				v20.defaultFocusRef = props.props.defaultFocusRef
				v20.scrollPerformanceIntervalName = fFlagLuaAppScrollTelemetryIntegration
					and "LuaApp_Home_Scroll"
					or nil

				local v24 = if fFlagLuaAppSupportHomeBackToTop and not props.props.hasNextPage then parseBooleanString(props.props.omniItemsGlobalLayoutData and props.props.omniItemsGlobalLayoutData[omniFeedConstants.GlobalLayoutDataKeys.ShowBackToTop]) else nil
				v20.createEndOfScrollElement = v24
				return createElement2(module12, v20)
			end
		})
	})
end

function extended.didUpdate(data, data2, p2)
	if
		not data.props.hasLocalOmniItems
		or data2.omniItemsGlobalLayoutData ~= data.props.omniItemsGlobalLayoutData
		or data2.homePageDataStatus ~= data.props.homePageDataStatus
		or data2.upsellCardVariation ~= data.props.upsellCardVariation
	then
		data.createLocalFeedItems()
	end

	if data.scrollingPerf then
		data.scrollingPerf:setScrollingFrame(data.scrollingFrameRef.current)
	end
end

function extended:didMount()
	self.isMounted = true

	self.logHomePageInteractive(self.scrollingFrameRef.current)

	if module13 then
		self.scrollingPerf = module13.new("HomeOmniFeed", {
			loggingProtocol = self.props.loggingProtocol,
			analyticsService = self.props.appAnalytics
		})

		self.scrollingPerf:setScrollingFrame(self.scrollingFrameRef.current)
	end
end

function extended:willUnmount()
	if self.scrollingPerf then
		self.scrollingPerf:clean()
		self.scrollingPerf = nil
	end

	self.isMounted = false

	if self._willFocusListener ~= nil then
		self._willFocusListener.remove()
		self._willFocusListener = nil
	end
end

local v14 = RoactRodux.connect(function(data, p2)
	local recommendationsId = nil
	local omniSessionId = nil
	local nextPageToken = nil

	local localUserId = data.LocalUserId

	local userId = (not localUserId or localUserId == "")
		and (Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
		or localUserId
	local v15

	if getFFlagFixFetchNextOmniWithoutPageToken() and p2.isOmni then
		v15 = data.Personalization[fetchStatusReducer.key][fetchStatusNamespace.OmniRecommendations][appPage.Home]
	end

	if p2.isOmni then
		local omniRecommendation = data.OmniRecommendations[appPage.Home]

		if omniRecommendation then
			recommendationsId = omniRecommendation.recommendationsId
			omniSessionId = omniRecommendation.omniSessionId
			nextPageToken = omniRecommendation.nextPageToken
		end
	end

	local v16 = not (nextPageToken == nil or nextPageToken == "") and p2.isOmni

	local orderedOmniItem = data.Personalization.OrderedOmniItems[home]
	local allItems = orderedOmniItem and orderedOmniItem.allItems or not defineFastFlag2 and {} or v6
	local hasLocalItems = orderedOmniItem and orderedOmniItem.hasLocalItems or false
	local omniItemsGlobalLayoutData = data.Personalization.OmniItemsGlobalLayoutData

	local v17 = {
		localUserId = tostring(userId),
		homePageDataStatus = 0,
		homeOmniFetchStatus = 0,
		screenSize = 0,
		formFactor = 0,
		upsellCardVariation = 0,
		hasNextPage = 0,
		recommendationsRequestId = 0,
		omniSessionId = 0,
		omniFeedItems = 0,
		hasLocalOmniItems = 0,
		omniItemsGlobalLayoutData = 0
	}
	local v18 = if not fFlagUseSignalsForStartup then data.Startup.HomePageDataStatus else nil
	v17.homePageDataStatus = v18

	if not getFFlagFixFetchNextOmniWithoutPageToken() then
		v15 = nil
	end

	v17.homeOmniFetchStatus = v15
	v17.screenSize = data.ScreenSize
	local v19 = if fFlagLuaAppMoveProfileIntoTopBar then data.FormFactor else nil
	v17.formFactor = v19
	v17.upsellCardVariation = data.HomePageUpsellCardVariation
	v17.hasNextPage = v16
	v17.recommendationsRequestId = recommendationsId
	v17.omniSessionId = omniSessionId
	v17.omniFeedItems = allItems
	v17.hasLocalOmniItems = hasLocalItems
	v17.omniItemsGlobalLayoutData = omniItemsGlobalLayoutData
	return v17
end, function(callback)
	return {
		addLocalFeedItems = function(p2)
			callback(module9(p2, home))
		end,
		loadNext = function(p2, p3, p4)
			return callback(apiFetchOmniRecommendations(
				p2,
				p3,
				appPage.Home,
				true,
				nil,
				omniFeedConstants.OmniRecommendationsRequestIntent.LoadMore,
				p4
			))
		end,
		refresh = function(p2, p3, p4, p5, p6)
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).refreshSiteAlertInfo()
			else
				callback(module8())
			end

			local v15 = if p4 then apiFetchOmniRecommendations(p2, p3, appPage.Home, nil, nil, p5, p6) else refreshGameSorts(p2, { gameSortGroups.HomeGames }, nil, nil)

			local v16 = { callback(v15) }

			return Promise.all(v16):andThen(function(p7)
				return Promise.resolve(p7)
			end, function(p7)
				callback(setNetworkingErrorToast(p7))
				return Promise.reject(p7)
			end)
		end,
		fetchHomePageData = function(p2, p3, p4, p5, p6, p7, p8)
			return callback(fetchHomePageData(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				omniFeedConstants.OmniRecommendationsRequestIntent.LogIn
			))
		end,
		fetchHomePageContactMethodModuleVariation = function(p2)
			return callback(fetchHomePageContactMethodModuleVariation(p2))
		end
	}
end)(extended)
local v15

if fFlagUseSignalsForStartup then
	v15 = React.memo(function(p2)
		local v16 = useSignalState(getStartupStore(false).getHomePageDataStatus)
		return React.createElement(v14, Cryo.Dictionary.union(p2, {
			homePageDataStatus = v16
		}))
	end)
else
	v15 = v14
end

local function useIsInteractive()
	local state, setState = React.useState(default.isInteractive)

	React.useEffect(function()
		setState(default.isInteractive)

		if state then
			return function() end
		end

		local changedConnection = default.changed:connect(function()
			setState(default.isInteractive)
		end)
		return function()
			changedConnection:disconnect()
		end
	end, { state })
	return state
end

local v16 = roactAppPolicy.connect(function(p2, p3)
	return { isOmni = p2.getUseOmniRecommendation() }
end)(function(p2)
	local v17, v18 = module14()
	local v19 = nil

	if fFlagLuaAppEnableRelativeGuiHomeForAll then
		v19 = true
	elseif fFlagLuaAppEnableRelativeGuiHomeWithIxp then
		v19 = module15.getRelativeGuiOnHomeEnabled()
	end

	local v20 = usePreferredInput()

	if fFlagLuaAppEnableRelativeGuiHomeForAll or fFlagLuaAppEnableRelativeGuiHomeWithIxp then
		local v21 = useIsSpatial()

		if v20 == Responsive.Input.Directional or v21 then
			v19 = false
		end
	end

	local v21 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then v20 == Responsive.Input.Pointer else nil

	local v22 = v20 == Responsive.Input.Touch

	local v23 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then getPlaybackDetectionMethod(v20, v21) else nil
	local v24, v25, v26

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		v24, v25, v26 = useFeedVideoPlaybackContext(nil, nil, nil, nil, v23)
	else
		v24, v25, v26 = useFeedVideoPlaybackContext(v22)
	end

	local v27 = not useIsInteractive()

	local state, setState = React.useState(nil)

	local v28 = if fFlagLuaAppLayoutParamsInContext then useCollectionLayoutConfig(state) else nil

	local useSduiContextFromRoduxAndProcessConfigs = module6.useSduiContextFromRoduxAndProcessConfigs
	local v30 = if fFlagLuaAppLayoutParamsInContext then v28 else nil
	local v31 = useSduiContextFromRoduxAndProcessConfigs(home, v30)

	if fFlagLuaAppRfySignalApportioning then
		module6.useApportioningPreprocessingFromOmniRecommendations(home, v28, true)
	end

	useSponsoredAdViewabilityDetector(state, useSelector(function(p3)
		if not p2.isOmni then
			return nil
		end

		local omniRecommendation = p3.OmniRecommendations[appPage.Home]

		if omniRecommendation then
			return omniRecommendation.omniSessionId
		end

		return nil
	end), p2.appLifecycleObserverService)

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if not fFlagLuaAppLayoutParamsInContext then
		setState = nil
	end

	if not (fFlagLuaAppEnableRelativeGuiHomeForAll or fFlagLuaAppEnableRelativeGuiHomeWithIxp) then
		v19 = nil
	end

	return createElement(v15, join(p2, {
		sduiContext = v31,
		shouldStopAfterOneGameSort = v27,
		header = v17,
		headerHeight = v18,
		setScrollingFrame = setState,
		relativeGuiEnabled = v19,
		videoPlaybackContext = v24,
		onScrollStart = v25,
		onScrollSettled = v26
	}))
end)
local v17

if fFlagSignalsNavP3fGameDetails then
	local memo = React.memo(v16, function(p2, p3)
		return tutils.shallowEqual(p2, p3, v5)
	end)

	v17 = RoactNavigation.withNavigation(memo)
else
	v17 = RoactNavigation.withNavigation(v16)
end

return (roactServices.connect({
	appAnalytics = roactAnalytics,
	networking = roactNetworking,
	loggingProtocol = appLogging,
	prefetchProtocol = appPrefetch,
	sessionService = appSessionService,
	appStartupSequence = appStartupSequenceTag,
	eventIngest = appEventIngestService,
	appLifecycleObserverService = appAppLifecycleObserverService
})(v17))
