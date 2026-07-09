local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local ScriptContext = game:GetService("ScriptContext")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local GameSortGroups = DiscoveryTypes.GameSortGroups
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local useSponsoredAdViewabilityDetector = require(CorePackages.Workspace.Packages.SponsoredAdViewability).useSponsoredAdViewabilityDetector
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactAnalytics = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalytics
local AppStartupSequenceTag = require(CorePackages.Workspace.Packages.RoactServiceTags).AppStartupSequenceTag
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local AppPrefetch = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPrefetch
local AppAppLifecycleObserverService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppAppLifecycleObserverService
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Promise = require(CorePackages.Packages.Promise)
local SetNetworkingErrorToast = require(CorePackages.Workspace.Packages.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local RetrievalStatus2 = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local feedScroll = require(CorePackages.Workspace.Packages.ScrollTelemetry).feedScroll
local FetchStatusRodux = require(CorePackages.Workspace.Packages.FetchStatusRodux)
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local VerticalEfficiencyExperimentation = require(CorePackages.Workspace.Packages.DiscoveryUtils).VerticalEfficiencyExperimentation
local DiscoveryAppLaunchTracker = require(CorePackages.Workspace.Packages.AppLaunchTracker).DiscoveryAppLaunchTracker
local MemStorageService = game:GetService("MemStorageService")
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local AppStartup = require(CorePackages.Workspace.Packages.AppStartup)
local SocialUpsell = require(CorePackages.Workspace.Packages.SocialUpsell)
local default = AppStartup.AppStartupSequence.default
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local FeedVideoPlaybackContext = require(CorePackages.Workspace.Packages.VideoUtils).FeedVideoPlaybackContext
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local ApiFetchOmniRecommendations = Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local OmniFeedAutoRefresher = Modules.LuaApp.Components.Games.OmniFeedAutoRefresher
local RefreshGameSorts = Modules.LuaApp.Thunks.RefreshGameSorts
local FetchHomePageData = Modules.LuaApp.Thunks.FetchHomePageData
local FetchHomePageContactMethodModuleVariation = Modules.LuaApp.Thunks.FetchHomePageContactMethodModuleVariation
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local RefreshSiteAlertInfo = require(Modules2.LuaApp.Actions.RefreshSiteAlertInfo)
local AddLocalOmniItems = require(Modules2.Personalization.OmniFeed.DataStore.AddLocalOmniItems)
local PageSessionManager = require(Modules2.Personalization.Sessions.PageSessionManager)
local setHomePageSessionInfo = require(Modules2.Personalization.Sessions.setHomePageSessionInfo)
local OmniFeedViewLoadMore = require(Modules2.Personalization.OmniFeed.FeedViews.OmniFeedViewLoadMore)
local ScrollingPerfTracker = require(Modules2.Personalization.Analytics.ScrollingPerfTracker)
local useBannerContainer = require(Modules2.LuaApp.Components.Banner.useBannerContainer)
local HomeOmniFeedExperimentation = require(Modules2.Personalization.Home.HomeOmniFeed.HomeOmniFeedExperimentation)
local OptionalContactMethodUpsellTypes = require(Modules2.LuaApp.Enum.OptionalContactMethodUpsellTypes)
local GetFFlagEnableHomePageEmailUpsellCard = require(Modules2.LuaApp.Flags.GetFFlagEnableHomePageEmailUpsellCard)
local GetFFlagEnableVoiceTrialUpsellCard = require(Modules2.LuaApp.Flags.GetFFlagEnableVoiceTrialUpsellCard)
local ServerTriggeredModals = require(CorePackages.Workspace.Packages.ServerTriggeredModals)
local PromptsEntryPoint = ServerTriggeredModals.PromptsEntryPoint
local PromptStyle = ServerTriggeredModals.PromptStyle
local v70 = game:DefineFastInt("LuaAppHomeFeedProfilePosition", 1)
local v71 = game:DefineFastInt("LuaAppHomeFeedFriendsPosition", 1)
local v72 = game:DefineFastInt("LuaAppHomeFeedUpsellCardPosition", 1)
local v73 = game:DefineFastFlag("TriggerLuaAppInteractiveFromLua", false)
local v74 = game:DefineFastFlag("LeaveExperienceLatencyTrackingEnabled", false)
local EngineFeature = game:GetEngineFeature("TriggerReportLuaRequireCountFromLua")
local GetFFlagFixFetchNextOmniWithoutPageToken = Modules.LuaApp.Flags.GetFFlagFixFetchNextOmniWithoutPageToken
local GetFFlagEnableHomePageUpsellCard = Modules.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard
local FFlagLuaAppMoveProfileIntoTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBar
local FFlagLuaAppMoveProfileIntoTopBarIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBarIXP
local FFlagLuaAppEnableRelativeGuiHomeForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableRelativeGuiHomeForAll
local FFlagLuaAppEnableRelativeGuiHomeWithIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableRelativeGuiHomeWithIxp
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppCompositionHome = SharedFlags.FFlagLuaAppCompositionHome
local FFlagLuaAppRfySignalApportioning = SharedFlags.FFlagLuaAppRfySignalApportioning
local FFlagEnableAppStoreAgeSignalsOnHomePage = SharedFlags.FFlagEnableAppStoreAgeSignalsOnHomePage
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = SharedFlags.FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = SharedFlags.FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppSponsoredAdViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdViewabilityEnabled
local FFlagHomePagePromptsHandlerEnabled = SharedFlags.FFlagHomePagePromptsHandlerEnabled
local FFlagDisableHomePageUpsellCardFeedItem = SharedFlags.FFlagDisableHomePageUpsellCardFeedItem
local FFlagLuaAppScrollTelemetryIntegration = SharedFlags.FFlagLuaAppScrollTelemetryIntegration
local FFlagEnableIAFlyoutIXPHomeProfileRemoval = require(Modules2.Personalization.Flags.FFlagEnableIAFlyoutIXPHomeProfileRemoval)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local v96 = game:DefineFastFlag("RemoveMobileHomeProfileHeader", false)
local v97 = game:DefineFastFlag("AppIaHomeOmniFeedFix", false)
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local Home = AppPage.Home
local v100 = if not v97 then nil else {}
local v101 = Roact.PureComponent:extend("HomeOmniFeed")

v101.validateProps = t.strictInterface({
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else t.optional(t.number),
	hasNextPage = t.optional(t.boolean),
	homeOmniFetchStatus = if not GetFFlagFixFetchNextOmniWithoutPageToken() then nil else t.optional(t.string),
	localUserId = t.string,
	homePageDataStatus = t.string,
	omniFeedItems = if not v97 then t.optional(t.table) else t.table,
	hasLocalOmniItems = t.optional(t.boolean),
	recommendationsRequestId = t.optional(t.string),
	omniSessionId = t.optional(t.string),
	omniItemsGlobalLayoutData = t.optional(t.table),
	screenSize = t.Vector2,
	formFactor = if not FFlagLuaAppMoveProfileIntoTopBar then nil else t.string,
	upsellCardVariation = t.optional(t.table),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	addLocalFeedItems = t.callback,
	refresh = t.callback,
	loadNext = t.optional(t.callback),
	fetchHomePageData = t.callback,
	fetchHomePageContactMethodModuleVariation = t.optional(t.callback),
	isOmni = t.optional(t.boolean),
	appAnalytics = t.any,
	networking = t.any,
	loggingProtocol = t.optional(t.any),
	prefetchProtocol = t.optional(t.any),
	sessionService = t.optional(t.any),
	appStartupSequence = t.any,
	eventIngest = t.any,
	appLifecycleObserverService = if not v73 then nil else t.optional(t.any),
	navigation = t.any,
	header = t.optional(t.any),
	headerHeight = t.number,
	relativeGuiEnabled = if not FFlagLuaAppEnableRelativeGuiHomeForAll and not FFlagLuaAppEnableRelativeGuiHomeWithIxp then nil else t.optional(t.boolean),
	shouldStopAfterOneGameSort = t.boolean,
	sduiContext = t.table,
	setScrollingFrame = if not FFlagLuaAppLayoutParamsInContext then nil else t.optional(t.callback),
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.table),
	onScrollStart = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.callback),
	onScrollSettled = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.callback)
})

local function isRetrievalStatusFinal(p1) -- line: 185
	-- upvalues: RetrievalStatus2 (copy)
	return p1 ~= RetrievalStatus2.NotStarted and p1 ~= RetrievalStatus2.Fetching
end
local function v103(p2, p3) -- line: 189
	-- upvalues: OptionalContactMethodUpsellTypes (copy), GetFFlagEnableHomePageEmailUpsellCard (copy), GetFFlagEnableVoiceTrialUpsellCard (copy)
	return p2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumber or (p2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberVoiceOptIn or (p2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailVerticalLayout or (p2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout or (GetFFlagEnableHomePageEmailUpsellCard() and p2 == OptionalContactMethodUpsellTypes.ContactMethodEmail or (GetFFlagEnableVoiceTrialUpsellCard() and p2 == OptionalContactMethodUpsellTypes.VoiceWithoutPvTrial or p3 and (p3.upsellCardType ~= "" and p3.upsellCardV2Config ~= nil))))))
end

function v101.init(p4) -- line: 206
	-- upvalues: GetFFlagFixFetchNextOmniWithoutPageToken (copy), RetrievalStatus2 (copy), Promise (copy), Roact (copy), FFlagLuaAppLayoutParamsInContext (copy), feedScroll (copy), Home (copy), v74 (copy), MemStorageService (copy), DiscoveryAppLaunchTracker (copy), v73 (copy), EngineFeature (copy), ScriptContext (copy), setHomePageSessionInfo (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FormFactor (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), v70 (copy), FFlagEnableIAFlyoutIXPHomeProfileRemoval (copy), FlyoutSidePanelIXP (copy), v96 (copy), OmniFeedTypes (copy), FFlagHomePagePromptsHandlerEnabled (copy), v72 (copy), PromptsEntryPoint (copy), PromptStyle (copy), FFlagDisableHomePageUpsellCardFeedItem (copy), GetFFlagEnableHomePageUpsellCard (copy), v103 (copy), OmniFeedConstants (copy), v71 (copy), RoactNavigation (copy)
	p4.props.loggingProtocol:logEventOnce("home_page_container_init")
	p4.isMounted = false

	function p4.loadNext() -- line: 211
		-- upvalues: p4 (copy), GetFFlagFixFetchNextOmniWithoutPageToken (copy), RetrievalStatus2 (copy), Promise (copy)
		local hasNextPage = p4.props.hasNextPage
		local loadNext = p4.props.loadNext

		if GetFFlagFixFetchNextOmniWithoutPageToken() then
			local homeOmniFetchStatus = p4.props.homeOmniFetchStatus

			if hasNextPage and loadNext and homeOmniFetchStatus ~= RetrievalStatus2.Fetching then
				return loadNext(p4.props.networking, p4.props.omniRecommendationsRequest, p4.props.loggingProtocol)
			end
		elseif hasNextPage and loadNext then
			return loadNext(p4.props.networking, p4.props.omniRecommendationsRequest, p4.props.loggingProtocol)
		end

		return Promise.resolve()
	end
	function p4.fetchHomePageData() -- line: 240
		-- upvalues: p4 (copy)
		return p4.props.fetchHomePageData(p4.props.networking, p4.props.omniRecommendationsRequest, p4.props.appAnalytics, p4.props.localUserId, p4.props.isOmni, p4.props.loggingProtocol, p4.props.prefetchProtocol)
	end
	function p4.fetchHomePageContactMethodModuleVariation() -- line: 252
		-- upvalues: p4 (copy)
		return p4.props.fetchHomePageContactMethodModuleVariation(p4.props.networking)
	end

	p4.scrollingFrameRef = Roact.createRef()

	if FFlagLuaAppLayoutParamsInContext then
		function p4.setScrollingFrameRef(p5) -- line: 258
			-- upvalues: p4 (copy)
			p4.scrollingFrameRef.current = p5

			if p4.props.setScrollingFrame then
				p4.props.setScrollingFrame(p5)
			end
		end
	end

	function p4.sendScrollEvent(n1: number, n2: number, n3: number) -- line: 266
		-- upvalues: p4 (copy), feedScroll (copy), Home (copy)
		local ScrollingDirectionY = Enum.ScrollingDirection.Y

		if ScrollingDirectionY then
			local n4 = 0

			if p4.scrollingFrameRef.current then
				n4 = p4.scrollingFrameRef.current.AbsoluteSize.Y
			end

			local t1 = {
				distance = n1,
				screenSizeX = p4.props.screenSize.X,
				screenSizeY = p4.props.screenSize.Y,
				scrollAreaSize = n4,
				scrollDepth = if not (n4 > 0) then nil else n1 / n4,
				startDepth = if not (n4 > 0) then nil else n3 / n4,
				startPos = n3,
				scrollDuration = n2
			}

			feedScroll(p4.props.eventIngest, Home, ScrollingDirectionY, t1)
		end
	end
	function p4.logHomePageInteractive(p6) -- line: 290
		-- upvalues: p4 (copy), v74 (copy), MemStorageService (copy), DiscoveryAppLaunchTracker (copy), v73 (copy), EngineFeature (copy), ScriptContext (copy)
		if not p4.isMounted then
			return
		end

		if not p6 then
			return
		end

		if p4.props.appStartupSequence.isInteractive then
			return
		end

		if p6.AbsoluteSize.X > 1 and p6.AbsoluteSize.Y > 1 then
			p4.props.loggingProtocol:logEventOnce("home_page_interactive_legacy")
			task.defer(function() -- line: 305
				-- upvalues: p4 (copy), v74 (copy), MemStorageService (copy), DiscoveryAppLaunchTracker (copy), v73 (copy), EngineFeature (copy), ScriptContext (copy)
				p4.props.loggingProtocol:logEventOnce("home_page_interactive")

				if v74 and MemStorageService:GetItem("pendingLeaveExperienceWithDestroyedLuaApp") == "true" then
					MemStorageService:SetItem("pendingLeaveExperienceWithDestroyedLuaApp", "")
					p4.props.loggingProtocol:logEvent("leave_experience_end")
				end

				if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
					DiscoveryAppLaunchTracker.default:stopTracking()
				end

				if v73 and game:GetEngineFeature("LuaAppInteractiveSignalEnabled") then
					p4.props.appLifecycleObserverService:TriggerOnLuaAppInteractive()
				elseif EngineFeature then
					ScriptContext:ReportLuaRequireCount()
				end

				task.defer(function() -- line: 328
					-- upvalues: p4 (copy)
					p4.props.appStartupSequence:setInteractive()
				end)
			end)
		end
	end
	function p4.setHomePageSessionInfoFunc() -- line: 335
		-- upvalues: setHomePageSessionInfo (copy), p4 (copy)
		setHomePageSessionInfo(p4.props.sessionService, p4.props.recommendationsRequestId, p4.props.omniSessionId)
	end
	function p4.insertLocalFeedItem(p7, p8, p9, p10, p11) -- line: 339
		table.insert(p7, {
			orderIndex = p8,
			treatmentType = p9,
			treatmentProps = p10,
			numberOfRows = p11
		})
	end
	function p4.createLocalFeedItems() -- line: 348
		-- upvalues: p4 (copy), RetrievalStatus2 (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FormFactor (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), v70 (copy), FFlagEnableIAFlyoutIXPHomeProfileRemoval (copy), FlyoutSidePanelIXP (copy), v96 (copy), OmniFeedTypes (copy), FFlagHomePagePromptsHandlerEnabled (copy), v72 (copy), PromptsEntryPoint (copy), PromptStyle (copy), FFlagDisableHomePageUpsellCardFeedItem (copy), GetFFlagEnableHomePageUpsellCard (copy), v103 (copy), OmniFeedConstants (copy), v71 (copy)
		local homePageDataStatus = p4.props.homePageDataStatus

		if homePageDataStatus == RetrievalStatus2.NotStarted or homePageDataStatus == RetrievalStatus2.Fetching then
			return
		end

		local t2 = {}
		local v172 = nil

		if FFlagLuaAppMoveProfileIntoTopBar then
			v172 = p4.props.formFactor == FormFactor.COMPACT and (not FFlagLuaAppMoveProfileIntoTopBarIXP or VerticalEfficiencyExperimentation.getIsProfileMovedToTopBar())
		end

		if v70 > 0 and (not FFlagLuaAppMoveProfileIntoTopBar or not v172) and (not FFlagEnableIAFlyoutIXPHomeProfileRemoval or not FlyoutSidePanelIXP.isProfileEntryRemoved()) and not v96 then
			p4.insertLocalFeedItem(t2, v70, OmniFeedTypes.UserInfo, {}, 0)
		end

		if FFlagHomePagePromptsHandlerEnabled then
			p4.insertLocalFeedItem(t2, v72, OmniFeedTypes.Prompts, {
				entryPoint = PromptsEntryPoint.HomepageLaunch,
				promptStyle = PromptStyle.InlineBanner
			})
		end

		if not FFlagDisableHomePageUpsellCardFeedItem and (GetFFlagEnableHomePageUpsellCard() and (p4.props.upsellCardVariation and (v103(p4.props.upsellCardVariation.upsellCardType, p4.props.upsellCardVariation) and v72 > 0))) then
			p4.insertLocalFeedItem(t2, v72, OmniFeedTypes.UpsellCard, {})
		end

		local omniItemsGlobalLayoutData = p4.props.omniItemsGlobalLayoutData

		if (not omniItemsGlobalLayoutData or omniItemsGlobalLayoutData[OmniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] ~= "true" and omniItemsGlobalLayoutData[OmniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] ~= true) and v71 > 0 then
			p4.insertLocalFeedItem(t2, v71, OmniFeedTypes.FriendCarousel, {})
		end

		p4.props.addLocalFeedItems(t2)
	end
	function p4.fetchDataIfNeeded() -- line: 430
		-- upvalues: p4 (copy), RetrievalStatus2 (copy)
		if p4.props.homePageDataStatus == RetrievalStatus2.NotStarted then
			p4.fetchHomePageData()
		end
	end

	p4._willFocusListener = p4.props.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 436
		-- upvalues: p4 (copy)
		p4.fetchDataIfNeeded()
	end)

	function p4.omniFeedRefresh(s1: string?) -- line: 440
		-- upvalues: p4 (copy)
		return p4.props.refresh(p4.props.networking, p4.props.omniRecommendationsRequest, p4.props.isOmni, s1, p4.props.loggingProtocol)
	end

	p4.fetchDataIfNeeded()
	p4.createLocalFeedItems()
end
function v101.render(p12) -- line: 455
	-- upvalues: RetrievalStatus2 (copy), Roact (copy), SocialUpsell (copy), FFlagEnableAppStoreAgeSignalsOnHomePage (copy), OmniFeedAutoRefresher (copy), AppPage (copy), GameSortGroups (copy), PageSessionManager (copy), Home (copy), LoadingStateContainer (copy), RetrievalStatus (copy), OmniFeedViewLoadMore (copy), FFlagLuaAppLayoutParamsInContext (copy), OmniFeedConstants (copy), FFlagLuaAppEnableRelativeGuiHomeForAll (copy), FFlagLuaAppEnableRelativeGuiHomeWithIxp (copy), FFlagAppIaScrollAway (copy), FFlagLuaAppCompositionHome (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppsDefaultSelection (copy), FFlagLuaAppScrollTelemetryIntegration (copy)
	local homePageDataStatus = p12.props.homePageDataStatus
	local isOmni = p12.props.isOmni
	local v115 = homePageDataStatus

	if v115 ~= RetrievalStatus2.NotStarted and v115 ~= RetrievalStatus2.Fetching and not p12.props.hasLocalOmniItems then
		v115 = RetrievalStatus2.Fetching
	end

	if game:GetEngineFeature("SlowDownRendering") and homePageDataStatus ~= RetrievalStatus2.Done then
		p12.props.appLifecycleObserverService:TriggerOnLuaAppReadyToRender()
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		SocialUpsellEventReceiver = Roact.createElement(SocialUpsell.SocialUpsellEventReceiver, {
			onAgeVerifiedChange = p12.fetchHomePageContactMethodModuleVariation,
			shouldRequestAppAgeSignals = FFlagEnableAppStoreAgeSignalsOnHomePage
		}),
		TokenRefreshComponent = Roact.createElement(OmniFeedAutoRefresher, {
			isOmni = isOmni,
			pageType = AppPage.Home,
			sortToRefresh = GameSortGroups.HomeGames
		}),
		PageSessionManager = Roact.createElement(PageSessionManager, {
			appPage = Home,
			setPageSession = p12.setHomePageSessionInfoFunc
		}),
		LoadingStateContainer = Roact.createElement(LoadingStateContainer, {
			dataStatus = RetrievalStatus.fromRawValue(v115),
			onRetry = p12.fetchHomePageData,
			renderOnLoaded = function() -- line: 490
				-- upvalues: Roact (copy), OmniFeedViewLoadMore (copy), Home (copy), p12 (copy), FFlagLuaAppLayoutParamsInContext (copy), OmniFeedConstants (copy), FFlagLuaAppEnableRelativeGuiHomeForAll (copy), FFlagLuaAppEnableRelativeGuiHomeWithIxp (copy), FFlagAppIaScrollAway (copy), FFlagLuaAppCompositionHome (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppsDefaultSelection (copy), FFlagLuaAppScrollTelemetryIntegration (copy)
				return Roact.createElement(OmniFeedViewLoadMore, {
					impressionsTag = "FEEDITEM_IMPRESSIONS",
					pageContext = Home,
					refresh = p12.omniFeedRefresh,
					omniFeedItems = p12.props.omniFeedItems,
					onAbsoluteSizeChanged = p12.logHomePageInteractive,
					hasNextPage = p12.props.hasNextPage,
					loadNext = p12.loadNext,
					scrollingFrameRef = if not FFlagLuaAppLayoutParamsInContext then p12.scrollingFrameRef else p12.setScrollingFrameRef,
					analyticsContext = OmniFeedConstants.EventContext,
					header = p12.props.header,
					headerHeight = p12.props.headerHeight,
					sendScrollEvent = p12.sendScrollEvent,
					enableRelativeGui = if not FFlagLuaAppEnableRelativeGuiHomeForAll and not FFlagLuaAppEnableRelativeGuiHomeWithIxp then nil else p12.props.relativeGuiEnabled,
					shouldStopAfterOneGameSort = p12.props.shouldStopAfterOneGameSort,
					canvasTopPadding = if not FFlagAppIaScrollAway then nil else p12.props.canvasTopPadding,
					sduiContext = p12.props.sduiContext,
					appCompositionEnabled = not not FFlagLuaAppCompositionHome or nil,
					onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p12.props.onTileImageLoaded,
					videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else p12.props.videoPlaybackContext,
					onScrollStart = if not FFlagLuaAppHomeTouchAutoplay then nil else p12.props.onScrollStart,
					onScrollSettled = if not FFlagLuaAppHomeTouchAutoplay then nil else p12.props.onScrollSettled,
					defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p12.props.defaultFocusRef,
					scrollPerformanceIntervalName = if not FFlagLuaAppScrollTelemetryIntegration then nil else "LuaApp_Home_Scroll"
				})
			end
		})
	})
end
function v101.didUpdate(p13, p14, _) -- line: 532
	if not p13.props.hasLocalOmniItems or (p14.omniItemsGlobalLayoutData ~= p13.props.omniItemsGlobalLayoutData or p14.homePageDataStatus ~= p13.props.homePageDataStatus or p14.upsellCardVariation ~= p13.props.upsellCardVariation) then
		p13.createLocalFeedItems()
	end

	if p13.scrollingPerf then
		p13.scrollingPerf:setScrollingFrame(p13.scrollingFrameRef.current)
	end
end
function v101.didMount(p16) -- line: 554
	-- upvalues: ScrollingPerfTracker (copy)
	p16.isMounted = true
	p16.logHomePageInteractive(p16.scrollingFrameRef.current)

	if ScrollingPerfTracker then
		p16.scrollingPerf = ScrollingPerfTracker.new("HomeOmniFeed", {
			loggingProtocol = p16.props.loggingProtocol,
			analyticsService = p16.props.appAnalytics
		})
		p16.scrollingPerf:setScrollingFrame(p16.scrollingFrameRef.current)
	end
end
function v101.willUnmount(p17) -- line: 568
	if p17.scrollingPerf then
		p17.scrollingPerf:clean()
		p17.scrollingPerf = nil
	end

	p17.isMounted = false

	if p17._willFocusListener ~= nil then
		p17._willFocusListener.remove()
		p17._willFocusListener = nil
	end
end

local function useIsInteractive() -- line: 707
	-- upvalues: React (copy), default (copy)
	local v135, v136 = React.useState(default.isInteractive)

	React.useEffect(function() -- line: 710
		-- upvalues: v136 (copy), default (copy), v135 (copy)
		v136(default.isInteractive)

		if not v135 then
			local v194 = default.changed:connect(function() -- line: 714
				-- upvalues: v136 (copy), default (copy)
				v136(default.isInteractive)
			end)

			return function() -- line: 717
				-- upvalues: v194 (copy)
				v194:disconnect()
			end
		end

		return function() -- line: 721
		end
	end, { v135 })

	return v135
end

local v105 = RoactRodux.connect(function(p18, p19) -- line: 581
	-- upvalues: Players (copy), GetFFlagFixFetchNextOmniWithoutPageToken (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), AppPage (copy), Home (copy), v97 (copy), v100 (copy), FFlagLuaAppMoveProfileIntoTopBar (copy)
	local recommendationsId = nil
	local omniSessionId = nil
	local nextPageToken = nil
	local LocalUserId = p18.LocalUserId

	if not LocalUserId or LocalUserId == "" then
		LocalUserId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	end

	local v127 = if not GetFFlagFixFetchNextOmniWithoutPageToken() or not p19.isOmni then nil else p18.Personalization[FetchStatusReducer.key][FetchStatusNamespace.OmniRecommendations][AppPage.Home]

	if p19.isOmni then
		local v128 = p18.OmniRecommendations[AppPage.Home]

		if v128 then
			recommendationsId = v128.recommendationsId
			omniSessionId = v128.omniSessionId
			nextPageToken = v128.nextPageToken
		end
	end

	local v129 = nextPageToken ~= nil and (nextPageToken ~= "" and p19.isOmni)
	local v130 = p18.Personalization.OrderedOmniItems[Home]
	local v131 = v130 and v130.allItems or if not v97 then {} else v100
	local v132 = not not v130 and (v130.hasLocalItems or false)
	local OmniItemsGlobalLayoutData = p18.Personalization.OmniItemsGlobalLayoutData

	return {
		localUserId = tostring(LocalUserId),
		homePageDataStatus = p18.Startup.HomePageDataStatus,
		homeOmniFetchStatus = if not GetFFlagFixFetchNextOmniWithoutPageToken() then nil else v127,
		screenSize = p18.ScreenSize,
		formFactor = if not FFlagLuaAppMoveProfileIntoTopBar then nil else p18.FormFactor,
		upsellCardVariation = p18.HomePageUpsellCardVariation,
		hasNextPage = v129,
		recommendationsRequestId = recommendationsId,
		omniSessionId = omniSessionId,
		omniFeedItems = v131,
		hasLocalOmniItems = v132,
		omniItemsGlobalLayoutData = OmniItemsGlobalLayoutData
	}
end, function(p20) -- line: 631
	-- upvalues: AddLocalOmniItems (copy), Home (copy), ApiFetchOmniRecommendations (copy), AppPage (copy), OmniFeedConstants (copy), RefreshSiteAlertInfo (copy), RefreshGameSorts (copy), GameSortGroups (copy), Promise (copy), SetNetworkingErrorToast (copy), FetchHomePageData (copy), FetchHomePageContactMethodModuleVariation (copy)
	return {
		addLocalFeedItems = function(p21) -- line: 633
			-- upvalues: p20 (copy), AddLocalOmniItems (copy), Home (copy)
			p20(AddLocalOmniItems(p21, Home))
		end,
		loadNext = function(p22, p23, p24) -- line: 636
			-- upvalues: p20 (copy), ApiFetchOmniRecommendations (copy), AppPage (copy), OmniFeedConstants (copy)
			return p20(ApiFetchOmniRecommendations(p22, p23, AppPage.Home, true, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.LoadMore, p24))
		end,
		refresh = function(p25, p26, b1: boolean?, s2: string, p27) -- line: 649
			-- upvalues: p20 (copy), RefreshSiteAlertInfo (copy), ApiFetchOmniRecommendations (copy), AppPage (copy), RefreshGameSorts (copy), GameSortGroups (copy), Promise (copy), SetNetworkingErrorToast (copy)
			p20(RefreshSiteAlertInfo())

			local v184 = if not b1 then RefreshGameSorts(p25, { GameSortGroups.HomeGames }, nil, nil) else ApiFetchOmniRecommendations(p25, p26, AppPage.Home, nil, nil, s2, p27)
			local t3 = { p20(v184) }

			return Promise.all(t3):andThen(function(p28) -- line: 672
				-- upvalues: Promise (copy)
				return Promise.resolve(p28)
			end, function(p29) -- line: 674
				-- upvalues: p20 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p20(SetNetworkingErrorToast(p29))

				return Promise.reject(p29)
			end)
		end,
		fetchHomePageData = function(p30, p31, p32, p33, p34, p35, p36) -- line: 679
			-- upvalues: p20 (copy), FetchHomePageData (copy), OmniFeedConstants (copy)
			return p20(FetchHomePageData(p30, p31, p32, p33, p34, p35, p36, OmniFeedConstants.OmniRecommendationsRequestIntent.LogIn))
		end,
		fetchHomePageContactMethodModuleVariation = function(p37) -- line: 701
			-- upvalues: p20 (copy), FetchHomePageContactMethodModuleVariation (copy)
			return p20(FetchHomePageContactMethodModuleVariation(p37))
		end
	}
end)(v101)
local v106 = RoactAppPolicy.connect(function(p38, _) -- line: 814
	return {
		isOmni = p38.getUseOmniRecommendation()
	}
end)(function(p40) -- line: 727
	-- upvalues: useBannerContainer (copy), FFlagLuaAppEnableRelativeGuiHomeForAll (copy), FFlagLuaAppEnableRelativeGuiHomeWithIxp (copy), HomeOmniFeedExperimentation (copy), FFlagLuaAppHomeTouchAutoplay (copy), usePreferredInput (copy), useIsSpatial (copy), Responsive (copy), React (copy), FeedVideoPlaybackContext (copy), useIsInteractive (copy), FFlagLuaAppLayoutParamsInContext (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), Home (copy), FFlagLuaAppRfySignalApportioning (copy), FFlagLuaAppCompositionHome (copy), FFlagLuaAppSponsoredAdViewabilityEnabled (copy), useSponsoredAdViewabilityDetector (copy), Roact (copy), v105 (copy), Cryo (copy)
	local v138, v139 = useBannerContainer()
	local v140 = nil

	if FFlagLuaAppEnableRelativeGuiHomeForAll then
		v140 = true
	elseif FFlagLuaAppEnableRelativeGuiHomeWithIxp then
		v140 = HomeOmniFeedExperimentation.getRelativeGuiOnHomeEnabled()
	end

	local v141 = nil

	if FFlagLuaAppEnableRelativeGuiHomeForAll or FFlagLuaAppEnableRelativeGuiHomeWithIxp or FFlagLuaAppHomeTouchAutoplay then
		v141 = usePreferredInput()
	end

	if FFlagLuaAppEnableRelativeGuiHomeForAll or FFlagLuaAppEnableRelativeGuiHomeWithIxp then
		local v142 = useIsSpatial()

		if v141 == Responsive.Input.Directional or v142 then
			v140 = false
		end
	end

	local u143 = nil
	local v144 = nil
	local v145 = nil

	if FFlagLuaAppHomeTouchAutoplay then
		local v146 = v141 == Responsive.Input.Touch

		u143 = React.useMemo(function() -- line: 756
			-- upvalues: FeedVideoPlaybackContext (copy), v146 (copy)
			return FeedVideoPlaybackContext.new(v146)
		end, { v146 })
		v144 = React.useCallback(function() -- line: 760
			-- upvalues: u143 (ref)
			if u143.viewportVideoAutoplayController then
				u143.viewportVideoAutoplayController:onScrollStart()
			end
		end, { u143.viewportVideoAutoplayController })
		v145 = React.useCallback(function(n5: number) -- line: 765
			-- upvalues: u143 (ref)
			if u143.viewportVideoAutoplayController then
				u143.viewportVideoAutoplayController:onScrollSettled("Y", n5, nil)
			end
		end, { u143.viewportVideoAutoplayController })
	end

	local v147 = useIsInteractive()
	local v148, v149 = React.useState(nil)
	local v150 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(v148)
	local v151 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(Home, if not FFlagLuaAppLayoutParamsInContext then nil else v150)

	if FFlagLuaAppRfySignalApportioning then
		ServerDrivenUi.useApportioningPreprocessingFromOmniRecommendations(Home, v150, not not FFlagLuaAppCompositionHome or nil)
	end

	if FFlagLuaAppSponsoredAdViewabilityEnabled then
		useSponsoredAdViewabilityDetector(v148)
	end

	return Roact.createElement(v105, Cryo.Dictionary.join(p40, {
		sduiContext = v151,
		shouldStopAfterOneGameSort = not v147,
		header = v138,
		headerHeight = v139,
		setScrollingFrame = if not FFlagLuaAppLayoutParamsInContext then nil else v149,
		relativeGuiEnabled = if not FFlagLuaAppEnableRelativeGuiHomeForAll and not FFlagLuaAppEnableRelativeGuiHomeWithIxp then nil else v140,
		videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else u143,
		onScrollStart = if not FFlagLuaAppHomeTouchAutoplay then nil else v144,
		onScrollSettled = if not FFlagLuaAppHomeTouchAutoplay then nil else v145
	}))
end)
local v107 = RoactNavigation.withNavigation(v106)

return (RoactServices.connect({
	appAnalytics = RoactAnalytics,
	networking = RoactNetworking,
	loggingProtocol = AppLogging,
	prefetchProtocol = AppPrefetch,
	sessionService = AppSessionService,
	appStartupSequence = AppStartupSequenceTag,
	eventIngest = AppEventIngestService,
	appLifecycleObserverService = if not v73 then nil else AppAppLifecycleObserverService
})(v107))
