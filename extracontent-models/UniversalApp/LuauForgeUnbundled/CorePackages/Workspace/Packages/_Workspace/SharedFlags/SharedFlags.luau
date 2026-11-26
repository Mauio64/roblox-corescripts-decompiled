local defineFastFlag = game:DefineFastFlag("EnableBuildAdPromotion6", false)

local engineFeature = game:DefineFastFlag("BuildAdUpsell4", false)
	and defineFastFlag
	and game:GetEngineFeature("BuildAppStorageKey")

local defineFastFlag2 = game:DefineFastFlag("SduiHostedDependencies", false)
local v5 = game:DefineFastFlag("InitializeSduiForInExperience", false) and defineFastFlag2

local v6 = game:DefineFastFlag("SduiDefineUnreadRuntimeFlags", false) and v5

local defineFastFlag3 = game:DefineFastFlag("UseSignalsForAccountSecurityPrompt", false)

local defineFastFlag4 = game:DefineFastFlag("ExpChatDictationStateStore", false)

local defineFastFlag5 = game:DefineFastFlag("UseSignalsForSearchBar", false)

local defineFastFlag6 = game:DefineFastFlag("UseSignalsForAuthenticationStatus7", false)

local defineFastFlag7 = game:DefineFastFlag("UseSignalsForGlobalContextMenuInset1", false)

local defineFastFlag8 = game:DefineFastFlag("UseSignalsForCountryCode", false)

local defineFastFlag9 = game:DefineFastFlag("UseSignalsForSiteMessage", false)

local defineFastFlag10 = game:DefineFastFlag("UseSignalsForScreenGuiBlur", false)

local defineFastFlag11 = game:DefineFastFlag("UseSignalsForGameInvitesStatus", false)

local defineFastFlag12 = game:DefineFastFlag("UseSignalsForIsLocalUserUnder13", false)

local defineFastFlag13 = game:DefineFastFlag("UseSignalsForPlatform", false)

local defineFastFlag14 = game:DefineFastFlag("UseSignalsForStartup2", false)

local defineFastFlag15 = game:DefineFastFlag("UseSignalsForAppTopBanner", false)

local defineFastFlag16 = game:DefineFastFlag("UseSignalsForDeviceOrientation1", false)

local defineFastFlag17 = game:DefineFastFlag("UseSignalsForRobuxVirtualItem", false)

local defineFastFlag18 = game:DefineFastFlag("UseSignalsForSquadExperienceInviteStatus", false)
local v7 = game:DefineFastFlag("UseSignalsForSquadExperienceInvite", false) and defineFastFlag18

local defineFastFlag19 = game:DefineFastFlag("LuaAppLayoutParamsInContext2", false)

local v8 = defineFastFlag19 and game:DefineFastFlag("LuaAppRfySignalApportioningIxp4", false)
local defineFastFlag20 = game:DefineFastFlag("ConnectionAmpParentalApprovalUpsell", false)
local v9 = game:DefineFastFlag("ConnectionParentalApprovalLeaveOnly", false) and defineFastFlag20

local defineFastFlag21 = game:DefineFastFlag("ConnectionUpsellAnalytics", false)
local defineFastFlag22 = game:DefineFastFlag("LuaAppHomePageLoadTracker", false)
local v10 = game:DefineFastFlag("LuaAppHomePagePLTDualLog", false) and defineFastFlag22

local defineFastInt = game:DefineFastInt("HomePagePLTSampleRate", 1000)
local defineFastFlag23 = game:DefineFastFlag("LuaAppHomePageReadyToRender", false)
local defineFastFlag24 = game:DefineFastFlag("AppContainerReadyToRender", false)
local v11 = game:DefineFastFlag("LuaAppHomePageFirstImageLoadObserver2", false) and defineFastFlag22

local defineFastFlag25 = game:DefineFastFlag("LuaAppCompositionAlways4", false)
local defineFastFlag26 = game:DefineFastFlag("LuaAppSduiPageEntryPointSnackbar2", false)
local defineFastFlag27 = game:DefineFastFlag("EnableExperienceDetailsBottomSheet2", false)
local defineFastFlag28 = game:DefineFastFlag("EnableMeTabProfile", false)
local defineFastFlag29 = game:DefineFastFlag("EnableMeTabMarketplaceNav", false)

local defineFastFlag30 = game:DefineFastFlag("LuaAppSduiSearchAutocompleteSuggestionComponent", false)
local defineFastFlag31 = game:DefineFastFlag("SduiUseInputData", false)
local defineFastFlag32 = game:DefineFastFlag("SduiPageEntryPointResolvedSlot", false)
local v12 = game:DefineFastFlag("SduiSearchResultsPageEnabled", false)
	and defineFastFlag31
	and defineFastFlag32

local defineFastFlag33 = game:DefineFastFlag("SduiChartsPlaceholderMergeStrategySupport", false)
local defineFastFlag34 = game:DefineFastFlag("SduiDismissPromptAction", false)
local defineFastFlag35 = game:DefineFastFlag("SduiMilestoneCountActions", false)
local defineFastFlag36 = game:DefineFastFlag("LuaAppSduiMovePromptsActions", false)
local v13 = game:DefineFastFlag("SduiDismissPromptPageScope", false)
	and defineFastFlag34
	and defineFastFlag36

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableNxMRoduxApportioning")
local defineFastFlag37 = game:DefineFastFlag("SduiSkipFeedAnalyticsPosition", false)
local defineFastFlag38 = game:DefineFastFlag("SduiPerSectionPoolSizing2", false)
local defineFastFlag39 = game:DefineFastFlag("SduiIndividualFeedItemSpacing", false)
local v14 = game:DefineFastFlag("SduiSamePoolFeedItemSpacing", false) and defineFastFlag39

local engineFeature2 = game:DefineFastFlag("EnableSummarySystemMessageOnLua", false)
	and game:GetEngineFeature("EnableSummarySystemMessage")

local defineFastFlag40 = game:DefineFastFlag("SignalsNavExperiment6", false)
local v15 = game:DefineFastFlag("UseSignalsNavigation3", false) or defineFastFlag40
local v16

if game:DefineFastFlag("RoduxSignalsNavigationMigration2", false) or defineFastFlag40 then
	v16 = v15
else
	v16 = defineFastFlag40
end

local v17

if game:DefineFastFlag("SignalsNavP2NavigationPrimitives5", false) or defineFastFlag40 then
	v17 = v16
else
	v17 = defineFastFlag40
end

local v18

if game:DefineFastFlag("SignalsNavP3aWrapAppPage3", false) or defineFastFlag40 then
	v18 = v17
else
	v18 = defineFastFlag40
end

local v19

if game:DefineFastFlag("SignalsNavP3bTopBar4", false) or defineFastFlag40 then
	v19 = v17
else
	v19 = defineFastFlag40
end

local v20

if game:DefineFastFlag("SignalsNavP3dRouteGated3", false) or defineFastFlag40 then
	v20 = v17
else
	v20 = defineFastFlag40
end

local v21

if game:DefineFastFlag("SignalsNavP3cEvents5", false) or defineFastFlag40 then
	v21 = v17
else
	v21 = defineFastFlag40
end

local v22

if game:DefineFastFlag("SignalsNavP3eAuth3", false) or defineFastFlag40 then
	v22 = v17
else
	v22 = defineFastFlag40
end

local v23

if game:DefineFastFlag("SignalsNavP3fGameDetails3", false) or defineFastFlag40 then
	v23 = v17
else
	v23 = defineFastFlag40
end

local v24

if game:DefineFastFlag("SignalsNavP3gAvatarExperience4", false) or defineFastFlag40 then
	v24 = v17
else
	v24 = defineFastFlag40
end

local v25

if game:DefineFastFlag("SignalsNavP3hMisc4", false) or defineFastFlag40 then
	v25 = v17
else
	v25 = defineFastFlag40
end

local defineFastFlag41 = game:DefineFastFlag("UseSignalsForCountryCodeList", false)
local defineFastFlag42 = game:DefineFastFlag("UseSignalsForIsLocalUserSoothsayer", false)
local defineFastFlag43 = game:DefineFastFlag("UseSignalsForModeration", false)
local defineFastFlag44 = game:DefineFastFlag("UseSignalsForUserAccess", false)
local defineFastFlag45 = game:DefineFastFlag("SignalsRegistryOwnedFanout", false)
local v26

if game:DefineFastFlag("SignalsNavP3Dispatch6", false) or defineFastFlag40 then
	v26 = v17
else
	v26 = defineFastFlag40
end

local defineFastFlag46 = game:DefineFastFlag("NavigationCommandHandle", false)
local v27

if game:DefineFastFlag("SignalsNavP3Final", false) or defineFastFlag40 then
	v27 = v18 and v19 and v21 and v20 and v22 and v23 and v24 and v25 and v26
else
	v27 = defineFastFlag40
end

local v28

if game:DefineFastFlag("SignalsNavProjected2", false) or defineFastFlag40 then
	v28 = v27
else
	v28 = defineFastFlag40
end

local v29

if game:DefineFastFlag("SignalsNavDeferProjection", false) or defineFastFlag40 then
	v29 = v28
else
	v29 = defineFastFlag40
end

local v30

if game:DefineFastFlag("SignalsNavPendingLock", false) or defineFastFlag40 then
	v30 = v28
else
	v30 = defineFastFlag40
end

local v31

if game:DefineFastFlag("SignalsNavHomeFlowBegin", false) or defineFastFlag40 then
	v31 = v30 and defineFastFlag22
else
	v31 = defineFastFlag40
end

local v32 = game:DefineFastFlag("UseSignalsRoduxStore3", false)

if v32 then
	if v15 or v16 or v17 or v18 or v19 or v21 or v20 or v22 or v23 or v24 or v25 or v26 then
		v32 = not v27
	else
		v32 = v26
	end
end

local defineFastFlag47 = game:DefineFastFlag("LuaAppSupportDisablePlayableWhenLoading", false)
local defineFastString = game:DefineFastString("MomentsFeedWatchPageRouteName", "MomentsFeed")
local defineFastInt2 = game:DefineFastInt("MomentsSurfaceLoadTTISamplingRate", 1000)
local defineFastInt3 = game:DefineFastInt("MomentsSurfaceLoadTTIMaxMs", 0)
local defineFastFlag48 = game:DefineFastFlag("MomentsRemoveDeletedFromProfile", false)
local defineFastFlag49 = game:DefineFastFlag("MomentsOptimisticProfilePending", false)
local defineFastFlag50 = game:DefineFastFlag("MomentsRefreshProfileOnPostStatus", false)
local defineFastFlag51 = game:DefineFastFlag("MomentsRefreshOwnMomentsAfterPublish", false)
local defineFastFlag52 = game:DefineFastFlag("MomentsResolvePublishedPostFeedItem", false)

local defineFastFlag53 = game:DefineFastFlag("MomentsPostFeedback", false)

local v33 = game:DefineFastFlag("MomentsHidePostStatusToast", false) and defineFastFlag53

local defineFastFlag54 = game:DefineFastFlag("MomentsHidePostStatusToastEverywhere", false)
local defineFastFlag55 = game:DefineFastFlag("MomentsCreatorFollow", false)
local defineFastFlag56 = game:DefineFastFlag("SocialFollowAttribution", false)
local defineFastFlag57 = game:DefineFastFlag("MomentsServeEDPVideos4", false)
local defineFastFlag58 = game:DefineFastFlag("MomentsComments2", false)

local defineFastFlag59 = game:DefineFastFlag("MomentsCommentsIxpEnabled", false)
local defineFastFlag60 = game:DefineFastFlag("MomentsCommentsUseMockNetwork", false)

local v34 = game:DefineFastFlag("MomentsCommentDeepLinks", false) and defineFastFlag58
local defineFastFlag61 = game:DefineFastFlag("MomentsAutoplayAmpPolicy3", false)
local defineFastFlag62 = game:DefineFastFlag("MomentsReactFeatureGate", false)
local defineFastFlag63 = game:DefineFastFlag("MomentsCreationFeatureGate", false)
local defineFastFlag64 = game:DefineFastFlag("MomentsCreateAvatarPosts", false)
local defineFastFlag65 = game:DefineFastFlag("MomentsRenderAvatarPostsInFeed", false)
local v35 = game:DefineFastFlag("ProfileRenderAvatarMoments2", false) and defineFastFlag65

local defineFastFlag66 = game:DefineFastFlag("ProfileMomentsFeedRootRoute", false)
local defineFastFlag67 = game:DefineFastFlag("MomentsRenderCreatePostStatus", false)

local v36 = game:DefineFastFlag("AXAvatarMomentsCreation6", false) and defineFastFlag64 and defineFastFlag67

local defineFastFlag68 = game:DefineFastFlag("AppNavBarPerItemThemeOverride2", false)
local v37 = game:DefineFastFlag("AmpV2WizardParentModeNavTheme", false) and defineFastFlag68

local defineFastFlag69 = game:DefineFastFlag("EnableSplitPaneV1", false)
local v38 = game:DefineFastFlag("EnableSplitPaneTelemetry", false) and defineFastFlag69
local v39 = defineFastFlag69 and game:DefineFastFlag("EnableSplitPaneEDPFix", false)
local defineFastFlag70 = game:DefineFastFlag("EnableSplitPaneStackFallbackFix", false)
local v40 = game:DefineFastFlag("SplitPaneIneligibleStackFallback", false) and defineFastFlag69

local v41 = game:DefineFastFlag("EnableSplitPaneSessionL3", false) and defineFastFlag69
local v42 = game:DefineFastFlag("EnableOnScreenAPIIntegration", false) and defineFastFlag69

local v43 = game:DefineFastFlag("EnableSplitPaneAvatarOverlayV1", false) and defineFastFlag69

local v44 = game:DefineFastFlag("SplitPaneFixClassicThemeHeader", false) and defineFastFlag69

local v45 = game:DefineFastFlag("SplitPaneEducationalTour", false) and defineFastFlag69
local defineFastFlag71 = game:DefineFastFlag("AppThemeHalloween2026HomeBackground", false)
local v46 = game:DefineFastFlag("AppThemeHalloween2026FriendsBackground", false) and defineFastFlag71

local engineFeature3 = game:DefineFastFlag("AppIconSelectionPage2", false)
	and game:GetEngineFeature("SetAppIconAvailable")
	and game:GetEngineFeature("CustomAppIconStorageKey")
local v47 = game:DefineFastFlag("SplitPaneProfileMaxWidth", false) and defineFastFlag69
local v48 = game:DefineFastFlag("SplitPaneUnsavedDialogAlertStyle", false) and defineFastFlag69

local v49 = game:DefineFastFlag("FixSplitPaneGamepadLayoutJitter", false) and defineFastFlag69

local v50 = game:DefineFastFlag("FixDeviceInsetBackgroundSplitPaneWidth", false) and defineFastFlag69

local v51 = game:DefineFastFlag("SplitPaneAvatarOnlyAlwaysExpanded", false) and defineFastFlag69

local v52 = game:DefineFastFlag("SplitPaneProfileEditFillPane", false) and defineFastFlag69

local v53 = game:DefineFastFlag("SplitPaneFullBleedEditProfile", false) and v39

local v54 = game:DefineFastFlag("SocialTabsPageSplitPaneLayout", false) and defineFastFlag69

local defineFastFlag72 = game:DefineFastFlag("SplitPaneExperimentVariants1", false)
local defineFastFlag73 = game:DefineFastFlag("SplitPaneVariantDefaultCollapsed", false)
local defineFastFlag74 = game:DefineFastFlag("SplitPaneVariantAvatarOnHomeOnly", false)
local defineFastFlag75 = game:DefineFastFlag("SplitPaneVariantCollapsedAutoOpen", false)
local v55 = game:DefineFastFlag("SplitPaneDevStoreSeeAllSupportRegion", false) and defineFastFlag69

local v56 = game:DefineFastFlag("SplitPaneBadgesSeeAllSupportRegion", false) and defineFastFlag69

local v57 = game:DefineFastFlag("SplitPaneHostChromeYieldsInExpanded", false) and defineFastFlag69

local v58 = game:DefineFastFlag("SplitPaneOpaqueExpandedPages", false) and defineFastFlag69

local defineFastFlag76 = game:DefineFastFlag("SduiAdvertiseRuntimeSupportSets", false)

local engineFeature4 = game:DefineFastFlag("EnableHomePageSduiPrefetch", false)
	and game:GetEngineFeature("HomePageSduiPrefetch")

local engineFeature5 = game:GetEngineFeature("HomePageSduiPrefetchExtendedClientCapabilities")
local defineFastFlag77 = game:DefineFastFlag("LuaAppSduiHomePageSupport3", false)
local defineFastFlag78 = game:DefineFastFlag("SduiEdpClientTemplateCache", false)

local v59 = game:DefineFastFlag("SduiEdpTemplatePrewarm", false) and defineFastFlag78

local defineFastFlag79 = game:DefineFastFlag("SduiLaunchTemplatePrewarm2", false)

local v60 = game:DefineFastFlag("SduiExtendedCapabilitiesDiscovery", false) and defineFastFlag76

local v61 = game:DefineFastFlag("SduiExtendedCapabilitiesPrompts", false) and v60

local defineFastFlag80 = game:DefineFastFlag("SduiReleaseSearchResultsPageState", false)

local v62 = game:DefineFastFlag("SduiSearchClientTemplateCache", false) and v12 and v60

local v63 = game:DefineFastFlag("SduiUserSearchTile", false) and require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserSearchPresenceStoreMigration")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiEdpPersistentActionBarPlayButton")
local defineFastFlag81 = game:DefineFastFlag("AppChatDiscloseUpdateSecondVersion", false)
local defineFastFlag82 = game:DefineFastFlag("SduiPageCanvasCollectionLayout", false)
local defineFastFlag83 = game:DefineFastFlag("SduiContainerQueries2", false)
local defineFastFlag84 = game:DefineFastFlag("InfoTableStableItemKeys", false)
local defineFastFlag85 = game:DefineFastFlag("AppPageShellScrollToTopFocus", false)
local defineFastFlag86 = game:DefineFastFlag("FixSduiEdpTtiColdStart", false)
local v64 = game:DefineFastFlag("EDPTTIParityDefinitions", false) and defineFastFlag86

local defineFastFlag87 = game:DefineFastFlag("LuaAppPlayButtonPrivatePTSupport", false)
local v65 = game:DefineFastFlag("LuaAppPlayButtonPrivatePTEnableDualButton", false) and defineFastFlag87

local v66 = game:DefineFastFlag("LuaAppPlayButtonPrivatePTEnableSingleButton", false)
	and defineFastFlag87
	and not v65

local defineFastFlag88 = game:DefineFastFlag("AppPageShellScrollTelemetry", false)
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDataHydrationAccountReset")
local v67 = game:DefineFastFlag("BuildExperienceModelPicker4", false) and module3

local v68 = game:DefineFastFlag("HomePageRefetchOnDataHydrationAccountReset2", false) and module3

return {
	FIntUserProfileStoreBatchSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntUserProfileStoreBatchSize"),
	FFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserProfilePlatformProfile"),
	FFlagUserProfileMergeCachedNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserProfileMergeCachedNames"),
	Debug = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/Debug"),
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/UIBlox"),
	FStringApisCdnUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringApisCdnUrl"),
	FFlagAppPageShellScrollToTopFocus = defineFastFlag85,
	FFlagAppPageShellScrollTelemetry = defineFastFlag88,
	FFlagSduiFeedScrollBarFixes = game:DefineFastFlag("SduiFeedScrollBarFixes", false),
	isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/isSubjectToDesktopPolicies"),
	FFlagDisableGoogleAnalyticsErrorReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDisableGoogleAnalyticsErrorReporting"),
	FFlagExtendScrollingFramesBySafeInsets = game:DefineFastFlag(
		"ExtendScrollingFramesBySafeInsets2",
		false
	),
	FFlagCentralOverlayExcludeDeviceSafePadding = game:DefineFastFlag(
		"CentralOverlayExcludeDeviceSafePadding2",
		false
	),
	FFlagFixBulkPurchaseTopBarObfuscation = game:DefineFastFlag("FixBulkPurchaseTopBarObfuscation", false),
	GetFFlagAuthFlowProviderEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAuthFlowProviderEnabled"),
	FFlagAuthFlowStandaloneEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAuthFlowStandaloneEnabled"),
	FFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUseAppHttpStore"),
	FFlagLuaAppHeadShapeInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHeadShapeInventory"),
	FFlagEnableFlyoutOnNavRail = game:DefineFastFlag("EnableFlyoutOnNavRail", false),
	FFlagEnableFlyoutNavRailBumperNavigation = game:DefineFastFlag(
		"EnableFlyoutNavRailBumperNavigation",
		false
	),
	FFlagEnableNavRailTooltipAndTruncation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNavRailTooltipAndTruncation"),
	FFlagEnableOffersPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableOffersPrefetch"),
	FFlagFlyoutUseOpenHook = game:DefineFastFlag("FlyoutUseOpenHook", false),
	FFlagEnableLuaCommunityList = game:DefineFastFlag("EnableLuaCommunityList", false),
	FFlagEnableGroupOverviewPane = game:DefineFastFlag("EnableGroupOverviewPane", false),
	FFlagEnableGroupSidebarSdui = game:DefineFastFlag("EnableGroupSidebarSdui", false),
	FFlagManuallyMigrateDeprecatedIconUsage = game:DefineFastFlag(
		"ManuallyMigrateDeprecatedIconUsage",
		false
	),
	FFlagLuaAppAllowNilHookDepsCleanup = game:DefineFastFlag("LuaAppAllowNilHookDepsCleanup", false),
	FFlagEnablePopLatencyOverlay = game:DefineFastFlag("EnablePopLatencyOverlay", false),
	FFlagEnableGameplayPopLatencyOverlay = game:DefineFastFlag("EnableGameplayPopLatencyOverlay", false),
	FFlagEnableGameplayPopLatencyOverlayForAdmins = game:DefineFastFlag(
		"EnableGameplayPopLatencyOverlayForAdmins",
		false
	),
	FFlagDebugEnablePopForcePicker = game:DefineFastFlag("DebugEnablePopForcePicker", false),
	getFFlagRemoveVirtualEventsExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagRemoveVirtualEventsExperiment"),
	getFStringWhitelistVerifiedUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringWhitelistVerifiedUserId"),
	getFFlagOverridePlayerVerifiedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagOverridePlayerVerifiedBadge"),
	FFlagUnifyVerifiedBadgeComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifyVerifiedBadgeComponent"),
	FIntLuaAppBatchFetchingStatusDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLuaAppBatchFetchingStatusDelayMs"),
	ConvertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/ConvertUniverseIdToString"),
	GetFFlagEnableUseShowTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableUseShowTopBar"),
	GetFFlagEnableNavBarLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableNavBarLabels"),
	FStringLuaAppEphemeralCounterPrefix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringLuaAppEphemeralCounterPrefix"),
	GetFFlagEnablePeekViewStateOnMountParam = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePeekViewStateOnMountParam"),
	GetFFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagMigrateRoactUtilsToReactUtils"),
	FFlagLuaAppGamePassesDataHydrationMigrationEnabled = game:DefineFastFlag(
		"LuaAppGamePassesDataHydrationMigrationEnabled",
		false
	),
	FFlagLuaAppDataHydrationUpdateItem = game:DefineFastFlag("LuaAppDataHydrationUpdateItem", false),
	FFlagLuaAppDataHydrationConnectionsPlayedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppDataHydrationConnectionsPlayedStore"),
	FFlagSduiExperienceDetailsSocialProof = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiExperienceDetailsSocialProof"),
	GetFFlagConsoleApplyTokenizationEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagConsoleApplyTokenizationEdp"),
	GetFFlagApplyResolutionScale = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagApplyResolutionScale"),
	FFlagUIScaleEngineOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUIScaleEngineOptions"),
	GetFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableVirtualEventPlaceId"),
	FFlagInGameRsvpPushUpsellEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInGameRsvpPushUpsellEnabled"),
	FFlagEnableRetryForLinkingProtocolFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRetryForLinkingProtocolFetch"),
	FIntLinkingProtocolFetchRetries = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLinkingProtocolFetchRetries"),
	FIntLinkingProtocolFetchTimeoutMS = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLinkingProtocolFetchTimeoutMS"),
	FFlagEnableMicrosoftStorePaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMicrosoftStorePaymentsPlatform"),
	FFlagEnableMilkyWayPaymentsPlatformV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMilkyWayPaymentsPlatformV2"),
	FFlagFixOffSaleCurrentlyWearingItemNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixOffSaleCurrentlyWearingItemNavigation"),
	FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad"),
	FFlagAXLegacyIXPExposureLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXLegacyIXPExposureLogging"),
	FFlagAXCloseFilterOnBackgroundTap = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXCloseFilterOnBackgroundTap"),
	FFlagFontFaceAX = game:DefineFastFlag("FontFaceAX", false),
	FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation"),
	FFlagAXFixOrientationInputBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixOrientationInputBlocking"),
	FFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateSystemSliderToFoundationSlider"),
	FFlagLuaAppDerivedStackAndSwitchState = game:DefineFastFlag("LuaAppDerivedStackAndSwitchState", false),
	FFlagUseSignalsRoduxStore = v32,
	FFlagUseSignalsNavigation = v15,
	FFlagRoduxSignalsNavigationMigration = v16,
	FFlagSignalsNavP2NavigationPrimitives = v17,
	FFlagSignalsNavP3aWrapAppPage = v18,
	FFlagSignalsNavP3bTopBar = v19,
	FFlagSignalsNavP3dRouteGated = v20,
	FFlagSignalsNavP3fGameDetails = v23,
	FFlagSignalsNavP3cEvents = v21,
	FFlagSignalsNavP3eAuth = v22,
	FFlagSignalsNavP3gAvatarExperience = v24,
	FFlagUseSignalsForCountryCodeList = defineFastFlag41,
	FFlagUseSignalsForIsLocalUserSoothsayer = defineFastFlag42,
	FFlagUseSignalsForModeration = defineFastFlag43,
	FFlagUseSignalsForUserAccess = defineFastFlag44,
	FFlagSignalsNavP3hMisc = v25,
	FFlagSignalsNavP3Dispatch = v26,
	FFlagNavigationCommandHandle = defineFastFlag46,
	FFlagSignalsNavP3Final = v27,
	FFlagSignalsNavProjected = v28,
	FFlagSignalsNavDeferProjection = v29,
	FFlagSignalsNavPendingLock = v30,
	FFlagSignalsNavHomeFlowBegin = v31,
	FIntSignalsNavPendingLockFailsafeMs = game:DefineFastInt("SignalsNavPendingLockFailsafeMs", 5000),
	FFlagSignalsNavExperiment = defineFastFlag40,
	FStringMomentsFeedWatchPageRouteName = defineFastString,
	FIntMomentsSurfaceLoadTTISamplingRate = defineFastInt2,
	FIntMomentsSurfaceLoadTTIMaxMs = defineFastInt3,
	FFlagMomentsRemoveDeletedFromProfile = defineFastFlag48,
	FFlagMomentsOptimisticProfilePending = defineFastFlag49,
	FFlagMomentsRefreshProfileOnPostStatus = defineFastFlag50,
	FFlagMomentsRefreshOwnMomentsAfterPublish = defineFastFlag51,
	FFlagMomentsResolvePublishedPostFeedItem = defineFastFlag52,
	FFlagMomentsPostFeedback = defineFastFlag53,
	FFlagMomentsHidePostStatusToast = v33,
	FFlagMomentsHidePostStatusToastEverywhere = defineFastFlag54,
	FFlagMomentsCreatorFollow = defineFastFlag55,
	FFlagSocialFollowAttribution = defineFastFlag56,
	FFlagMomentsServeEDPVideos = defineFastFlag57,
	FFlagMomentsComments = defineFastFlag58,
	FFlagMomentsCommentsIxpEnabled = defineFastFlag59,
	FFlagMomentsCommentsUseMockNetwork = defineFastFlag60,
	FFlagMomentsCommentDeepLinks = v34,
	FFlagMomentsAutoplayAmpPolicy = defineFastFlag61,
	FFlagMomentsReactFeatureGate = defineFastFlag62,
	FFlagMomentsCreationFeatureGate = defineFastFlag63,
	FFlagMomentsCreateAvatarPosts = defineFastFlag64,
	FFlagMomentsRenderAvatarPostsInFeed = defineFastFlag65,
	FFlagProfileRenderAvatarMoments = v35,
	FFlagMomentsRenderCreatePostStatus = defineFastFlag67 and defineFastFlag64,
	FFlagAXAvatarMomentsCreation = v36,
	FFlagAddUILessMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddUILessMode"),
	FIntAddUILessModeVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntAddUILessModeVariant"),
	FFlagLuaAppDefaultHttpRetry = game:DefineFastFlag("LuaAppDefaultHttpRetry", false),
	FFlagAXMigrateEmoteMenuFromRoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateEmoteMenuFromRoactGamepad"),
	FFlagDebugEnablePageLoadTrackerVisualizer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugEnablePageLoadTrackerVisualizer"),
	FFlagLuaAppEnablePageLoadTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnablePageLoadTracker"),
	FFlagPageLoadAllowImprovedDisconnectTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPageLoadAllowImprovedDisconnectTiming"),
	FFlagLuaAppImproveComponentTrackingTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppImproveComponentTrackingTiming"),
	FFlagLuaAppEnableMilestoneDeduplication = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableMilestoneDeduplication"),
	FFlagLuaAppHomeThumbnailPrefetch = game:DefineFastFlag("LuaAppHomeThumbnailPrefetch", false),
	FFlagLuaAppHomePageLoadTracker = defineFastFlag22,
	FFlagLuaAppHomePagePLTDualLog = v10,
	FIntHomePagePLTSampleRate = defineFastInt,
	FFlagLuaAppHomePageReadyToRender = defineFastFlag23,
	FFlagAppContainerReadyToRender = defineFastFlag24,
	FFlagLuaAppHomePageFirstImageLoadObserver = v11,
	FFlagLuaAppDesignFoundationsBridge = game:DefineFastFlag("LuaAppDesignFoundationsBridge", false),
	FFlagLuaAppEnableChatMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableChatMilestones"),
	FFlagEnableTTIRecordWebViewMilestones = game:DefineFastFlag("EnableTTIRecordWebViewMilestones", false),
	FFlagLuaAppEnableContentfulPaintTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableContentfulPaintTracking"),
	GetFFlagEnableReadAloudInUA = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableReadAloudInUA"),
	FFlagLuaAppPageLoadTrackerJoinExperienceFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppPageLoadTrackerJoinExperienceFix"),
	FFlagEnableScreentimeMoreTimeOption = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableScreentimeMoreTimeOption"),
	FFlagLuaAppLCPTimingFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLCPTimingFix"),
	FFlagLuaAppSortDeeplinkFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSortDeeplinkFix"),
	FFlagImportVirtualCursorToUA = game:DefineFastFlag("ImportVirtualCursorToUA", false),
	FFlagVirtualCursorAutoFocusSuppression = game:DefineFastFlag("VirtualCursorAutoFocusSuppression", false),
	FFlagFocusNavigationRefocusSuppression = game:DefineFastFlag("FocusNavigationRefocusSuppression", false),
	FFlagVirtualCursorModularization = game:DefineFastFlag("VirtualCursorModularization6", false),
	FFlagLuaAppGamepadSelectionRespectsInteractable = game:DefineFastFlag(
		"LuaAppGamepadSelectionRespectsInteractable",
		false
	),
	FFlagEnableVirtualCursorMoveAssist = game:DefineFastFlag("EnableVirtualCursorMoveAssist2", false),
	FIntVirtualCursorMoveAssistLevel = game:DefineFastInt("VirtualCursorMoveAssistLevel", 0),
	FIntVirtualCursorMoveAssistHoverSpeed = game:DefineFastInt("VirtualCursorMoveAssistHoverSpeed", 0),
	FIntVirtualCursorMoveAssistSpeedSizeMinScale = game:DefineFastInt(
		"VirtualCursorMoveAssistSpeedSizeMinScale",
		0
	),
	FIntVirtualCursorMoveAssistSpeedSizeMaxScale = game:DefineFastInt(
		"VirtualCursorMoveAssistSpeedSizeMaxScale",
		0
	),
	FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs = game:DefineFastInt(
		"VirtualCursorMoveAssistSpeedSmoothingTimeMs",
		0
	),
	FFlagVirtualCursorMoveAssistIntentRamp = game:DefineFastFlag("VirtualCursorMoveAssistIntentRamp", false),
	FFlagEnableVirtualCursorDebugging = game:DefineFastFlag("EnableVirtualCursorDebugging", false),
	FFlagErrorPromptUseLeaveGameHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagErrorPromptUseLeaveGameHelper"),
	FFlagVirtualCursorForTVRemoteKeycodes = game:DefineFastFlag("VirtualCursorForTVRemoteKeycodes", false),
	FFlagEnableGameLeftMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableGameLeftMessage"),
	FFlagEnableAppRatingPromptLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAppRatingPromptLua"),
	FFlagEnableAndroidAppRatingPromptLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAndroidAppRatingPromptLua"),
	FFlagAXMISWithBlackbird = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMISWithBlackbird"),
	GetFFlagSystemTrayEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSystemTrayEnabled"),
	GetFFlagHideLaunchAtStartupMac = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagHideLaunchAtStartupMac"),
	GetFFlagMacMenuBarContentUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagMacMenuBarContentUpdates"),
	GetFFlagPlatformEventEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPlatformEventEnabled"),
	GetFStringPlatformEventUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPlatformEventUrl"),
	FFlagPlatformLeaderboardRccEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlatformLeaderboardRccEnabled"),
	FFlagPlatformLeaderboardDebugLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlatformLeaderboardDebugLogging"),
	FFlagPlatformLeaderboardPersistStoreOnRemount = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlatformLeaderboardPersistStoreOnRemount"),
	FFlagLuaAppForumsDeeplinkFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppForumsDeeplinkFix"),
	FStringLuaAppAdPreferencesUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringLuaAppAdPreferencesUrl"),
	FFlagLuaAppEnableReportBadge = game:DefineFastFlag("LuaAppEnableReportBadge", false),
	FFlagEnableGroupAnnouncementReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableGroupAnnouncementReporting"),
	FFlagShareTargetGameCleanup = game:DefineFastFlag("ShareTargetGameCleanup", false),
	FFlagSocialTabWrapperStableNavigationProps = game:DefineFastFlag(
		"SocialTabWrapperStableNavigationProps",
		false
	),
	FFlagExpChatWindowSyncUnibar = game:DefineFastFlag("ExpChatWindowSyncUnibar", false),
	FFlagExpChatInitializeWindowFromGameSettings = game:DefineFastFlag(
		"ExpChatInitializeWindowFromGameSettings",
		false
	),
	FFlagExpChatComposerFigmaParity = game:DefineFastFlag("ExpChatComposerFigmaParity", false),
	FFlagExpChatPresetChatBadgeExperimentCleanup = game:DefineFastFlag(
		"ExpChatPresetChatBadgeExperimentCleanup",
		false
	),
	FFlagChatInputBarGuardInvalidUtf8 = game:DefineFastFlag("ChatInputBarGuardInvalidUtf8", false),
	FFlagExpChatAutocompleteOptimization = game:DefineFastFlag("ExpChatAutocompleteOptimization", false),
	FFlagExpChatWhisperSetDirectChatRequester = game:DefineFastFlag(
		"ExpChatWhisperSetDirectChatRequester",
		false
	),
	FFlagExpChatIgnoreWhisperNameForDirectChat = game:DefineFastFlag(
		"ExpChatIgnoreWhisperNameForDirectChat",
		false
	),
	FFlagExpChatDictation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatDictation"),
	FFlagExpChatContinuousDictation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatContinuousDictation"),
	FFlagExpChatLongPressContinuousDictation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatLongPressContinuousDictation"),
	FFlagExpChatDictationVoiceTypingModeSetting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatDictationVoiceTypingModeSetting"),
	FFlagExpChatDictationContinuousSafetyReminder = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatDictationContinuousSafetyReminder"),
	FFlagExpChatDictationStateStore = defineFastFlag4,
	FFlagDictationAudioDeviceInputEnabled = game:DefineFastFlag("DictationAudioDeviceInputEnabled", false),
	FFlagExpChatContinuousListeningChatIconDot = game:DefineFastFlag(
		"ExpChatContinuousListeningChatIconDot",
		false
	) and defineFastFlag4,
	FFlagExpChatDictationStopOnSafetyIntervention = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatDictationStopOnSafetyIntervention"),
	FFlagExpChatIgnoreHistoricalMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatIgnoreHistoricalMessages"),
	FFlagExpChatRenderHistoricalMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatRenderHistoricalMessages"),
	FFlagExpChatReportHistoricalRenders = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatReportHistoricalRenders"),
	FFlagExpChatMessageHistoryExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatMessageHistoryExperiment"),
	FFlagExpChatHistoricalMessagesUnibarUnread = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatHistoricalMessagesUnibarUnread"),
	FFlagExpChatReportHistoryReplayed = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatReportHistoryReplayed"),
	EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = game:GetEngineFeature("PresetChatUseExpressionTrayOptionsEndpoint"),
	FFlagFontFaceSocialFriends = game:DefineFastFlag("FontFaceSocialFriends", false),
	FFlagAddFriendsSessionId = game:DefineFastFlag("AddFriendsSessionId", false),
	FFlagFriendsPageViewBtnEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsPageViewBtnEnabled"),
	FFlagFriendsPageUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsPageUserListEnabled"),
	FFlagFriendsPageAlwaysOpenPPV = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsPageAlwaysOpenPPV"),
	FFlagUserSearchEmptyPageNewIcons = game:DefineFastFlag("UserSearchEmptyPageNewIcons", false),
	FFlagExperiencesOnProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExperiencesOnProfile"),
	FFlagCiDeprecateFindFriendsModal = game:DefineFastFlag("CiDeprecateFindFriendsModal", false),
	FFlagUserSearchGoBackOnCancel = game:DefineFastFlag("UserSearchGoBackOnCancel", false),
	FFlagPPVEnable3DBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPPVEnable3DBackground"),
	FFlagProfilePlatformEnableAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableAvatarBackground"),
	FFlagEnableVerifiedBadgeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableVerifiedBadgeStore"),
	FFlagFriendRequestsEventReceiverListenTrustedFriends = game:DefineFastFlag(
		"FriendRequestsEventReceiverListenTrustedFriends",
		false
	),
	FFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlatformProfileContextualMenuOption"),
	FFlagPlayerSearchEnableOnlineFrequents = game:DefineFastFlag("PlayerSearchEnableOnlineFrequents", false),
	FFlagTCUpdateProfileCTAButton = game:DefineFastFlag("TCUpdateProfileCTAButton", false),
	FFlagTCShareLinkErrorModal = game:DefineFastFlag("TCShareLinkErrorModal", false),
	FFlagTCShareLinkErrorModalTextRename = game:DefineFastFlag("TCShareLinkErrorModalTextRename", false),
	FFlagTCShareLinkWrongRecipient = game:DefineFastFlag("TCShareLinkWrongRecipient", false),
	FFlagTCParentChildAutoUpgrade = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTCParentChildAutoUpgrade"),
	FFlagProfileInsightsSkipFetchNoCacheEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInsightsSkipFetchNoCacheEntry"),
	FFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserSearchClassmatesInsight"),
	FFlagProfileInsightsParseClassmates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInsightsParseClassmates"),
	FFlagProfileInsightsKeyByRankingStrategy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInsightsKeyByRankingStrategy"),
	FFlagTFClassmatesProfileInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTFClassmatesProfileInsight"),
	FStringConnectionGraphCoreAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringCanAccessTrustedContactsAmpNameSpace"),
	FStringParentLinkAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringParentLinkAmpNameSpace"),
	FFlagPlayerSearchEnableOnlineFrequentsForAll = game:DefineFastFlag(
		"PlayerSearchEnableOnlineFrequentsForAll",
		false
	),
	FFlagFriendSortedByPresenceSignalsImplementation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendSortedByPresenceSignalsImplementation"),
	FFlagFriendsStoreSortOnlineFriendsByRank = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsStoreSortOnlineFriendsByRank"),
	FFlagFriendsActivityFeedEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsActivityFeedEnabled"),
	FFlagBadgeVisibilitySettingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBadgeVisibilitySettingEnabled"),
	FStringIsVerified18PlusAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringIsVerified18PlusAmpFeature"),
	FStringEligibleForFacialAgeEstimationAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringEligibleForFacialAgeEstimationAmpFeature"),
	FStringEligibleToAgeVerifyAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringEligibleToAgeVerifyAmpFeature"),
	FFlagAmpWizardEntryPointEventCtxFallback = game:DefineFastFlag(
		"AmpWizardEntryPointEventCtxFallback",
		false
	),
	FStringShowAddTrustedFriendsHeaderTextAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringShowAddTrustedFriendsHeaderTextAmpFeature"),
	FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature"),
	FStringAgeCheckAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringAgeCheckAmpNameSpace"),
	FStringCoreContentAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringCoreContentAmpNameSpace"),
	FFlagQRInSearchProfileQR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagQRInSearchProfileQR"),
	FFlagQRInSearchScanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagQRInSearchScanner"),
	FFlagUserSearchAddFocusActionsSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserSearchAddFocusActionsSupport"),
	FFlagUserSearchCancelTileActivationOnHoldIntent = game:DefineFastFlag(
		"UserSearchCancelTileActivationOnHoldIntent2",
		false
	),
	FFlagUserSearchUsePreviousUsernameMatch = game:DefineFastFlag(
		"UserSearchUsePreviousUsernameMatch",
		false
	),
	FFlagUserSearchUseThisIsYou = game:DefineFastFlag("UserSearchUseThisIsYou", false),
	FFlagDisableCopyUsernameOnConsole = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDisableCopyUsernameOnConsole"),
	FFlagAddFriendsUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddFriendsUserListEnabled"),
	FFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddFriendsPageTrustedFriendRequestSection"),
	FFlagAddFriendsIgnoreAllMenuFocusNavigation = game:DefineFastFlag(
		"AddFriendsIgnoreAllMenuFocusNavigation",
		false
	),
	FIntTrustedFriendRequestsPageSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntTrustedFriendRequestsPageSize"),
	FIntInitialTrustedFriendRequestsPageSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntInitialTrustedFriendRequestsPageSize"),
	FFlagTrustedFriendCandidatesSection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTrustedFriendCandidatesSection"),
	FFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddFriendsPageHighlightUnseenTrustedRequests"),
	FFlagAddFriendsRefreshRequestOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddFriendsRefreshRequestOrder"),
	FFlagPPVBackgroundUse2DAsLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPPVBackgroundUse2DAsLoadingState"),
	FFlagEnableRecommendationsForPCGDK = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRecommendationsForPCGDK"),
	FFlagFixIsConsoleCheckForSocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixIsConsoleCheckForSocialCarousel"),
	FFlagFixSpatialUICaptures = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixSpatialUICaptures"),
	FFlagSkipBlockModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSkipBlockModal"),
	FFlagDisableBlockAndReport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDisableBlockAndReport"),
	FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugAppChatEnableDomLocators"),
	FFlagAppChatDomLocatorFoundationMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatDomLocatorFoundationMigration"),
	FFlagAppChatRemoveNotifications = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatRemoveNotifications"),
	FFlagAppChatMigrateChatEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatMigrateChatEventReceiver"),
	FFlagAppChatReactivePaneLayoutOnRotation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatReactivePaneLayoutOnRotation"),
	FFlagAppChatEarlyTestingLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatEarlyTestingLinks"),
	FFlagAppChatNavigateBackIfOSAUnacknowledged = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatNavigateBackIfOSAUnacknowledged"),
	FFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatEnableU13ChatOptIn"),
	FFlagAppChatShowOSAOnPageEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatShowOSAOnPageEntry"),
	FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPartyDevAPIToRespectThirdPartySettingsEnabled"),
	FFlagAppChatToastChatTerminologyFixEnabled = game:DefineFastFlag(
		"AppChatToastChatTerminologyFixEnabled",
		false
	),
	FFlagRemoveFriendsChatUnibarEntrypoints = game:DefineFastFlag(
		"RemoveFriendsChatUnibarEntrypoints",
		false
	),
	FFlagEnablePartyNudgeAfterJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePartyNudgeAfterJoin"),
	FFlagShowFriendJoinedYouToastForNonReferredJoins = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowFriendJoinedYouToastForNonReferredJoins"),
	FFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCreateConnectionsHub"),
	GetFFlagExpChatGuacChatDisabledReason = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagExpChatGuacChatDisabledReason"),
	FFlagGuacCanRenderTransferOnProfile = game:DefineFastFlag("GuacCanRenderTransferOnProfile", false),
	GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice"),
	FFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatConversationTrustedFriendUpsellBanner"),
	FFlagAppChatUseActivationOnFocus = game:DefineFastFlag("AppChatUseActivationOnFocus", false),
	FFlagEnableFriendsRenamingForAll = game:DefineFastFlag("EnableFriendsRenamingForAll", false),
	FFlagTCUpsellModalEnabled_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTCUpsellModalEnabled_DEV"),
	FFlagDebugEnableTCDoubleOptIn_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugEnableTCDoubleOptIn_DEV"),
	GetFFlagEnableProfileInsightsApolloMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableProfileInsightsApolloMigration"),
	GetFFlagFixPartyVoiceGetPermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixPartyVoiceGetPermissions"),
	FIntPartyVoiceJoinRequestPulseCheckTimeout = game:DefineFastInt(
		"PartyVoiceJoinRequestPulseCheckTimeout",
		0
	),
	GetFFlagSeamlessVoiceConsentToastPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSeamlessVoiceConsentToastPolicy"),
	FFlagMoveInExperienceModeToEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMoveInExperienceModeToEditProfile"),
	FFlagEnableSquadDeeplinkWithChatId = game:DefineFastFlag("EnableSquadDeeplinkWithChatId", false),
	FFlagForceEnableLuckyRecommendation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagForceEnableLuckyRecommendation"),
	FFlagEnableLuckyRecommendationExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLuckyRecommendationExperimentation"),
	FFlagEnableSquadTopBannerWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSquadTopBannerWideMode"),
	GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagIsSquadEnabled"),
	GetFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSocialCards"),
	FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals"),
	FFlagUseSignalsForSquadExperienceInviteStatus = defineFastFlag18,
	FFlagUseSignalsForSquadExperienceInvite = v7,
	FFlagEnablePrivatePartyStartJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePrivatePartyStartJoin"),
	FFlagEnablePrivatePartyAcceptInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePrivatePartyAcceptInvite"),
	FFlagEnableDeepLinkHistoryWithModalAPI = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableDeepLinkHistoryWithModalAPI"),
	FFlagDebugSquadLogsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugSquadLogsEnabled"),
	FFlagSquadAppChatRTNFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSquadAppChatRTNFix"),
	FFlagEnableAmpWizardDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAmpWizardDeepLink"),
	FFlagEnableAmpWizardDeepLinkValidateUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAmpWizardDeepLinkValidateUserId"),
	FFlagEnableAEGIS2CommsFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAEGIS2CommsFAEUpsell"),
	FFlagAFPConnectionsChannelsHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAFPConnectionsChannelsHeader"),
	FFlagEnableSchoolEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSchoolEntry"),
	FFlagSchoolDeepLinkUseConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSchoolDeepLinkUseConnectionsHub"),
	FFlagSchoolsEntryRequiresOpenSchool = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSchoolsEntryRequiresOpenSchool"),
	FFlagAddFriendsPageFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddFriendsPageFAEUpsell"),
	FFlagExpChatUseGuacForFOMOUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseGuacForFOMOUpsell"),
	FFlagExpChatUseGuacForCrossAgeChat = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseGuacForCrossAgeChat"),
	FFlagEnableAppStoreAgeSignalsOnHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAppStoreAgeSignalsOnHomePage"),
	FFlagAgeBasedUXHomepageVerificationBannerLockIcon = game:DefineFastFlag(
		"AgeBasedUXHomepageVerificationBannerLockIcon",
		false
	),
	FFlagAgeBasedUXHomepageVerificationBannerGreyButton = game:DefineFastFlag(
		"AgeBasedUXHomepageVerificationBannerGreyButton",
		false
	),
	FFlagEnableAEGIS2AppChatConversationBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAEGIS2AppChatConversationBanner"),
	FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = game:DefineFastString(
		"AEGIS2AppChatAgeVerifiedRealtimeNamespace",
		"AgeVerificationStatusChange"
	),
	GetFFlagLuaAppEnableTopBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableTopBanner"),
	getFFlagPYMKAddFriendsEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagPYMKAddFriendsEntry"),
	getFFlagSocialTabReplaceRefreshConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagSocialTabReplaceRefreshConversations"),
	isCharacterNameHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/isCharacterNameHandlerEnabled"),
	getFFlagRemoveDataLoaderTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagRemoveDataLoaderTimer"),
	getFStringSelfProfileView = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSelfProfileView"),
	FIntFriendsCarouselFetchPageDistance = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntFriendsCarouselFetchPageDistance"),
	FFlagDisableAutocorrectSocialUserSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDisableAutocorrectSocialUserSearch"),
	FFlagLuaAppLogSocialUserSearchUXExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLogSocialUserSearchUXExposure"),
	FStringCapturesIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringCapturesIXPLayer"),
	FStringSocialCaptureIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringSocialCaptureIXPLayer"),
	FStringSocialCaptureTakenIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringSocialCaptureTakenIXPLayer"),
	GetFFlagEnableCommonFriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCommonFriendsMenu"),
	GetFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAppChatInExperience"),
	getFStringAppChatInExperienceIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringAppChatInExperienceIXPLayer"),
	FIntFriendsCarouselSocialBtnFriendsLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntFriendsCarouselSocialBtnFriendsLimit"),
	FStringSocialOnboardingExperimentLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringSocialOnboardingExperimentLayer"),
	FStringPaginatedCarouselExperimentLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringPaginatedCarouselExperimentLayer"),
	FIntFriendsCarouselInitialFetchSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntFriendsCarouselInitialFetchSize"),
	FStringNewFriendRequestsBadgeLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringNewFriendRequestsBadgeLayer"),
	FFlagProfilePlatformEnableInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableInventory"),
	FFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableStore"),
	FFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableImpressions"),
	FFlagProfilePlatformEnableSchoolChip = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableSchoolChip"),
	GetFFlagEnableCurrencyTransferFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCurrencyTransferFlow"),
	FFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableCurrencyTransfer"),
	FFlagEnableCurrencyTransferDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableCurrencyTransferDeepLink"),
	FFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAmpV2Wizard"),
	FFlagRouteStandaloneAmpThroughUniversalApp = game:DefineFastFlag(
		"RouteStandaloneAmpThroughUniversalApp",
		false
	),
	FFlagCurrencyTransferDeepLinkValidateSender = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCurrencyTransferDeepLinkValidateSender"),
	FFlagEnablePlusUpsellDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusUpsellDeepLink"),
	FFlagEnableRobuxTransferFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRobuxTransferFlowEventIngest"),
	GetEngineFeatureEnablePromptRobuxTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetEngineFeatureEnablePromptRobuxTransfer"),
	GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent"),
	FFlagProfilePlatformTrustedConnectionsMVP = game:DefineFastFlag(
		"ProfilePlatformTrustedConnectionsMVP",
		false
	),
	FFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformNewProfileHeader"),
	FFlagProfilePlatformExitStandaloneEditor = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformExitStandaloneEditor"),
	FFlagProfilePlatformPeekDraggerContrast = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformPeekDraggerContrast"),
	FFlagProfilePlatformMeTabMobileProfileHero = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformMeTabMobileProfileHero"),
	FFlagProfileAboutDetailsUseSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileAboutDetailsUseSheet"),
	FFlagProfileMomentSceneOutfitPoster = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileMomentSceneOutfitPoster"),
	FFlagProfilePlatformPassPresenceToJoinUserInExperience = game:DefineFastFlag(
		"ProfilePlatformPassPresenceToJoinUserInExperience",
		false
	),
	FFlagProfilePlatformAddTC = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformAddTC"),
	FFlagProfileTFCardUseQrScanContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileTFCardUseQrScanContext"),
	FFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialEnableProfileInspectAndBuy"),
	FFlagSocialEnableProfileInspectAndBuyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialEnableProfileInspectAndBuyAnalytics"),
	FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav"),
	FFlagProfileInspectAvatarSpin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInspectAvatarSpin"),
	FFlagProfileInspectAvatarSlideIn = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInspectAvatarSlideIn"),
	FFlagProfileInspectAvatarShopChip = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInspectAvatarShopChip"),
	FFlagProfileContextualMenuDisableFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileContextualMenuDisableFix"),
	FFlagProfileFixMenuNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileFixMenuNavigation"),
	FFlagEnableProfileCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableProfileCompletion"),
	FFlagAddPlatformNameToProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddPlatformNameToProfileHeader"),
	FStringPreviousFriendRequestsCountEngineFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringPreviousFriendRequestsCountEngineFeature"),
	getFFlagDebugUnfilteredThreads = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagDebugUnfilteredThreads"),
	FFlagProfileEnableSocialNetworksUsernames = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileEnableSocialNetworksUsernames"),
	GetFFlagFixConnectTabSearchBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixConnectTabSearchBarHeight"),
	FFlagSearchTopResultsTabEnabledForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSearchTopResultsTabEnabledForAll"),
	FFlagCapturesPostEnabledForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCapturesPostEnabledForAll"),
	FFlagEnableOnPlatformSharingExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableOnPlatformSharingExperiment"),
	FFlagFriendsCarouselUseFindFriendsOnDesktop = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsCarouselUseFindFriendsOnDesktop"),
	FFlagSocialCarouselMigrateRecommendations = game:DefineFastFlag(
		"SocialCarouselMigrateRecommendations",
		false
	),
	FFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowRequestsInCarouselForAllUsers"),
	FFlagUserTileAvatarOverlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserTileAvatarOverlayIcon"),
	FFlagSocialCarouselInGameTitleMarquee = game:DefineFastFlag("SocialCarouselInGameTitleMarquee4", false),
	FFlagSocialCarouselInGamePlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselInGamePlayIcon"),
	FFlagSocialCarouselInGameTileInstantJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselInGameTileInstantJoin"),
	FFlagSocialCarouselInGameTextInstantJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselInGameTextInstantJoin"),
	getFFlagSettingsHubIndependentBackgroundVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagSettingsHubIndependentBackgroundVisibility"),
	getFFlagAppChatPCMFixBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagAppChatPCMFixBlocking"),
	GetFFlagLocalMutedNilFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLocalMutedNilFix"),
	GetFFlagAvatarChatServiceEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAvatarChatServiceEnabled"),
	GetFFlagJoinWithoutMicPermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagJoinWithoutMicPermissions"),
	GetFFlagAppChatInExpToastSnoozeMenuDismissFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAppChatInExpToastSnoozeMenuDismissFix"),
	FFlagBlendedSerpUserPresenceInLineEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBlendedSerpUserPresenceInLineEnabled"),
	FFlagRefactorButtonTileCircular = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRefactorButtonTileCircular"),
	FFlagEnableNewAddFriendsTileForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNewAddFriendsTileForAll"),
	GetFFlagSeamlessVoiceFTUX = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSeamlessVoiceFTUX"),
	GetFFlagNonVoiceFTUX = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagNonVoiceFTUX"),
	getFFlagExpChatAlwaysRunTCS = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagExpChatAlwaysRunTCS"),
	getFFlagExpChatProtectedChatInternalAPIs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagExpChatProtectedChatInternalAPIs"),
	GetFFlagMemoizeChatReportingMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagMemoizeChatReportingMenu"),
	GetFFlagCheckUniversePlaceBeforeSuspending = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagCheckUniversePlaceBeforeSuspending"),
	FFlagContentFeedEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagContentFeedEnableReactions"),
	FFlagQRCodeScannerDeeplinkEnabledForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagQRCodeScannerDeeplinkEnabledForAll"),
	FFlagProfilePlatformFavoritesEnableGameDetailAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformFavoritesEnableGameDetailAnalytics"),
	GetFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableInAppBugReporting"),
	FFlagRegisterQRCodeKeyInEngine = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRegisterQRCodeKeyInEngine"),
	FFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePartyQuickStartButton"),
	FFlagProfilePlatformImproveGameDetailsAnalytics = game:DefineFastFlag(
		"ProfilePlatformImproveGameDetailsAnalytics",
		false
	),
	FFlagExpChatUseAdorneeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseAdorneeStore"),
	FFlagExpChatUseProximityStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseProximityStore"),
	FFlagExpChatUseChatMuteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseChatMuteStore"),
	FFlagExpChatUseChannelTabsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseChannelTabsStore"),
	FFlagExpChatUseSharedChannelTabDisplayLabel = game:DefineFastFlag(
		"ExpChatUseSharedChannelTabDisplayLabel2",
		false
	),
	FFlagExpChatUseChatConfigStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatUseChatConfigStore"),
	FFlagExpChatTabShortcutNav = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatTabShortcutNav"),
	FFlagAppChatDistinctUnibarEntryPoint = game:DefineFastFlag("AppChatDistinctUnibarEntryPoint", false),
	FFlagExpChatFriendsTabRequireDefaultChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatFriendsTabRequireDefaultChannels"),
	FFlagExpChatCanShowFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatCanShowFriendsTab"),
	FFlagSideSheetHeaderChatIcon = game:DefineFastFlag("SideSheetHeaderChatIcon", false),
	FFlagFriendsChatHasFriendsGate = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsChatHasFriendsGate"),
	FFlagExpChatSelectTextChatTabByName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatSelectTextChatTabByName"),
	FFlagExpChatStickyTabs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatStickyTabs"),
	FFlagDebugFriendsChat = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugFriendsChat"),
	FFlagFriendsChatConversationListFocusNav = game:DefineFastFlag(
		"FriendsChatConversationListFocusNavRC1",
		false
	),
	FFlagFriendsChatDiscloseUpdateSecondVersion = game:DefineFastFlag(
		"FriendsChatDiscloseUpdateSecondVersion",
		false
	),
	FFlagFriendsChatEnableConversationConsent = game:DefineFastFlag(
		"FriendsChatEnableConversationConsent2",
		false
	),
	FFlagCIDeeplinkEnabledForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCIDeeplinkEnabledForAll"),
	FFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddSocialLinksToCommunityProfile"),
	FFlagAddCommunityLockedToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddCommunityLockedToCommunityProfile"),
	FFlagAddCommunityDeactivatedToJoinPrompt = game:DefineFastFlag(
		"AddCommunityDeactivatedToJoinPrompt",
		false
	),
	FFlagUseMediaPlayerInCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUseMediaPlayerInCarousel"),
	FStringSocialCarouselTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringSocialCarouselTreatment"),
	FFlagEnableSocialProofUserList = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSocialProofUserList"),
	FFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSocialTabsPage"),
	FFlagEnableSocialProofVerticalUserListSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSocialProofVerticalUserListSheet"),
	FFlagEnableSocialProofOnItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSocialProofOnItemDetails"),
	FFlagUserListUseSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListUseSheet"),
	FFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListCtaIntegrationEnabled"),
	FFlagUserListActionsV2 = game:DefineFastFlag("UserListActionsV2", false),
	FFlagUserListHideNotJoinableJoin = game:DefineFastFlag("UserListHideNotJoinableJoin", false) and game:GetFastFlag("UserListActionsV2"),
	FFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagJoinabilityCTARefactor"),
	FFlagJoinabilityCTAContextCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagJoinabilityCTAContextCopy"),
	FFlagJoinUserCTAsIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagJoinUserCTAsIxpEnabled"),
	FStringJoinUserCTAsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringJoinUserCTAsIxpLayer"),
	FFlagUseUserCtaCommonEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUseUserCtaCommonEnums"),
	FFlagUserListCtaAnalyticsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListCtaAnalyticsEnabled"),
	FFlagUserListSurfacePresenceWins = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListSurfacePresenceWins"),
	FFlagUserListDefaultCtaWidths = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListDefaultCtaWidths"),
	FFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListSurfaceExtensions"),
	FFlagUserListInviteCta = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListInviteCta"),
	FFlagUserListFixedRowHeightConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserListFixedRowHeightConfig"),
	FFlagMutualConnectionsListPagination = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMutualConnectionsListPagination"),
	FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation"),
	FFlagEnableUserListModule = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUserListModule"),
	FFlagEnableFontStylisticAlternativesOnSocialScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableFontStylisticAlternativesOnSocialScreens"),
	FFlagProfilePlatformEnableBundlesInAssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfilePlatformEnableBundlesInAssetsCarousel"),
	FFlagEnableVoiceEuConsentPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableVoiceEuConsentPrompt"),
	GetFFlagEnableVoiceChatMuteForVideoCaptures = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVoiceChatMuteForVideoCaptures"),
	FFlagPeopleListContextualMenuFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPeopleListContextualMenuFixFocusNavigation"),
	FStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringConnectionGraphCoreAmpNameSpace"),
	FStringCanAccessTrustedContactsAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringCanAccessTrustedContactsAmpFeature"),
	FStringIsUserInTcEligibleCountryAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringIsUserInTcEligibleCountryAmpFeature"),
	GetFFlagExpChatUseVoiceParticipantsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagExpChatUseVoiceParticipantsStore"),
	GetFFlagDebugShowAudioDeviceInputDebugger = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDebugShowAudioDeviceInputDebugger"),
	FFlagEditProfileBackgroundEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileBackgroundEnabled"),
	FFlagAppBloxConfirmationDialogFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppBloxConfirmationDialogFocusNav"),
	FFlagAppBloxConfirmationDialogBackCloses = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppBloxConfirmationDialogBackCloses"),
	FFlagEditProfileImageV2ConsoleEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageV2ConsoleEnabled"),
	FFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageV2Enabled"),
	FFlagEditProfileImageRigTypeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageRigTypeOverride"),
	FFlagEditProfileImageR15UpgradePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageR15UpgradePrompt"),
	FFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileFramesEnabled"),
	FFlagEditProfileImageV2Telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageV2Telemetry"),
	FFlagReadAppChatFetchingVariable = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagReadAppChatFetchingVariable"),
	FFlagEnableChatIconUnibarDropdownFixEnabled = game:DefineFastFlag(
		"EnableChatIconUnibarDropdownFixEnabled",
		false
	),
	FFlagMakeCreateOrJoinSquadAThunks = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMakeCreateOrJoinSquadAThunks"),
	FFlagEnablePartyVoiceChangersInLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePartyVoiceChangersInLua"),
	FFlagFriendsCallingClientGate_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsCallingClientGate_DEV"),
	FFlagFriendsCallingServiceLuaMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsCallingServiceLuaMigration"),
	FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = game:DefineFastFlag(
		"JoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel",
		false
	),
	FFlagEnableProfilePlatformDisabledActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableProfilePlatformDisabledActions"),
	FStringTimeoutLoadingLocalPlayerInBackgroundDM = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringTimeoutLoadingLocalPlayerInBackgroundDM"),
	FFlagAXEnableEditorCategoryDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXEnableEditorCategoryDeepLink"),
	FFlagAXFixEditorCategoryRenavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixEditorCategoryRenavigation"),
	FFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddIEMProfilePage"),
	FFlagEnablePartyNudgeV1_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePartyNudgeV1_DEV"),
	FFlagFriendsSignalMigrationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsSignalMigrationTelemetry"),
	FFlagSocialCarouselUseProfileStore = game:DefineFastFlag("SocialCarouselUseProfileStore_v2", false),
	FFlagAEGIS2UseGuacToShowEnabledMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAEGIS2UseGuacToShowEnabledMessage"),
	FFlagAEGIS2UseGuacToShowFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAEGIS2UseGuacToShowFAEUpsell"),
	FFlagSwitchProfileWidthHookToSocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSwitchProfileWidthHookToSocialCommon"),
	GetFFlagHomePYMKUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagHomePYMKUseProfileFrameThumbnail"),
	FFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSquadRegroupExperimentation"),
	FFlagEnableSquadRegroupExperimentationSmallScreenFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSquadRegroupExperimentationSmallScreenFix"),
	FFlagForceEnableSquadRegroup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagForceEnableSquadRegroup"),
	FFlagEnableSquadRegroupServerCapacityCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSquadRegroupServerCapacityCheck"),
	FFlagUserTileShowBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserTileShowBadges"),
	FFlagUserTileAddContextualInfoIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserTileAddContextualInfoIcon"),
	FFlagUserTileTitleStackAddExtraInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserTileTitleStackAddExtraInfo"),
	FFlagUserTileUnfilteredChatIndicator = game:DefineFastFlag("UserTileUnfilteredChatIndicator", false),
	FFlagEnableModerateChatRemoteEvent = game:GetEngineFeature("EnableChatModerationMode"),
	FFlagEnableSummarySystemMessageOnLua = engineFeature2,
	FFlagEnableClientSummarySystemMessageOnLua = engineFeature2 or game:DefineFastFlag(
		"EnableClientSummarySystemMessageOnLua",
		false
	),
	FFlagAIRephraseSettingEnabled = game:DefineFastFlag("AIRephraseSettingEnabled3", false) and game:GetEngineFeature("EnableExpChatRephraseMessageSettingOnLua2"),
	FFlagChatSummariesSettingEnabled = game:DefineFastFlag("ChatSummariesSettingEnabled3", false) and game:GetEngineFeature("EnableExpChatSummarySettingOnLua"),
	FFlagQRCodeCopyUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagQRCodeCopyUpdates"),
	FFlagQRCodePageVisualRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagQRCodePageVisualRefresh"),
	FFlagAddBackplateSupportToUserTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddBackplateSupportToUserTile"),
	FFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMobileGameJoinCard"),
	FFlagDeprecatePeopleListContextualMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDeprecatePeopleListContextualMenu"),
	FFlagConsoleOpenMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagConsoleOpenMobileGameJoinCard"),
	FFlagConsoleOpenGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagConsoleOpenGameJoinCard"),
	FFlagGameJoinCardAnalyticsCardId = game:DefineFastFlag("GameJoinCardAnalyticsCardId", false),
	FFlagGameJoinCardSourceAttribution = game:DefineFastFlag("GameJoinCardSourceAttribution", false),
	FFlagGameJoinCardOptionalActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGameJoinCardOptionalActions"),
	FFlagGameJoinCardContent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGameJoinCardContent"),
	FFlagBlockEDPClickthrough = game:DefineFastFlag("BlockEDPClickthrough", false),
	FFlagMobileGameJoinCardTTITracking = game:DefineFastFlag("MobileGameJoinCardTTITracking", false),
	FFlagMobileGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMobileGameJoinCardGamepadSupport"),
	FFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMobileGameJoinCardVideo"),
	FFlagDesktopGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDesktopGameJoinCardGamepadSupport"),
	FFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagConnectionManagementChips"),
	FFlagConnectionChannelsTileSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagConnectionChannelsTileSize"),
	FFlagTCPolicyCheckRedirect = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTCPolicyCheckRedirect"),
	FFlagEnableUserRecentActivityEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUserRecentActivityEntryPoint"),
	FFlagEnableRecentActivityInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRecentActivityInspectAndBuy"),
	FFlagEnableRecentActivitySingleItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRecentActivitySingleItemDetails"),
	FFlagFriendsActivityFeedFetchItemNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsActivityFeedFetchItemNames"),
	GetFFlagEnableChatNewMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableChatNewMessage"),
	GetFStringPCGDKFilteredNotificationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPCGDKFilteredNotificationTypes"),
	GetFStringNotificationsStreamNotificationUXLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringNotificationsStreamNotificationUXLayer"),
	getFStringDesktopToastNotificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringDesktopToastNotificationLayer"),
	GetFStringUniversalAppGameInviteMenuLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringUniversalAppGameInviteMenuLayer"),
	GetNotificationsExperienceDetailsVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetNotificationsExperienceDetailsVariant"),
	GetFFlagEnableGateNotificationPreferencesTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableGateNotificationPreferencesTab"),
	GetFFlagEnableGameInviteModalVRSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableGameInviteModalVRSupport"),
	FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt"),
	FFlagFixPromptGameInviteUIMissingDisplayName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixPromptGameInviteUIMissingDisplayName"),
	FFlagGameInviteModalUnlockMouse = game:DefineFastFlag("GameInviteModalUnlockMouse", false),
	GetFFlagEnableFriendsListSearchNormalizationErrorFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableFriendsListSearchNormalizationErrorFix"),
	GetFFlagEnablePushNotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePushNotificationsUpsellModal"),
	GetFFlagLuaAppPushUpsellDeprecateOldEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppPushUpsellDeprecateOldEvents"),
	FFlagSduiRequestPushNotificationPermissionActionHandler = game:DefineFastFlag(
		"SduiRequestPushNotificationPermissionActionHandler",
		false
	),
	FFlagNotificationsUpsellUseRequestPushPermissionHelper = game:DefineFastFlag(
		"NotificationsUpsellUseRequestPushPermissionHelper",
		false
	),
	FFlagPushPermissionRequestOpensAndroidSettings = game:DefineFastFlag(
		"PushPermissionRequestOpensAndroidSettings",
		false
	),
	GetFFlagNotificationsComplianceShouldRestrictStream = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagNotificationsComplianceShouldRestrictStream"),
	GetFStringPushUpsellVariantName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPushUpsellVariantName"),
	GetFStringPushUpsellOnFirstTimeVariantName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPushUpsellOnFirstTimeVariantName"),
	GetFStringPushUpsellChatVariantName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPushUpsellChatVariantName"),
	GetFFlagLuaAppPushSystemUpsellDevOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppPushSystemUpsellDevOverride"),
	GetFFlagLuaAppEnablePushUpsellOnFirstTime = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnablePushUpsellOnFirstTime"),
	GetFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagNotificationsForceEnableEDPDiscoverability"),
	GetFFlagEnableGameInviteRewardsBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableGameInviteRewardsBanner"),
	GetFStringReferralRewardsTermsURL = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringReferralRewardsTermsURL"),
	GetFFlagEnablePushNotificationsUpsellModalChat = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePushNotificationsUpsellModalChat"),
	GetFFlagDisablePVUpsellDataConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDisablePVUpsellDataConsent"),
	FFlagVoiceRewarmTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVoiceRewarmTelemetry"),
	FIntFriendsChatModeratedMaskMinLength = game:DefineFastInt("FriendsChatModeratedMaskMinLength", 3),
	FIntFriendsChatModeratedMaskMaxLength = game:DefineFastInt("FriendsChatModeratedMaskMaxLength", 8),
	FFlagEnableAppChatSnoozeMenuFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAppChatSnoozeMenuFocus"),
	FFlagAppChatFixRootChatBackNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppChatFixRootChatBackNavigation"),
	FFlagAppChatDiscloseUpdateSecondVersion = defineFastFlag81,
	FFlagStreamNotificationBellEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationBellEntryPoint"),
	FFlagStreamNotificationsStandardizeClickEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationsStandardizeClickEvents"),
	FFlagStreamNotificationUXDropdown = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationUXDropdown"),
	FFlagStreamNotificationUXSettingsHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationUXSettingsHeader"),
	FFlagStreamNotificationDropdownSingleOwner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationDropdownSingleOwner"),
	FFlagStreamNotificationDropdownFocusedOwner = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationDropdownFocusedOwner"),
	FFlagStreamNotificationImpressionLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStreamNotificationImpressionLogging"),
	GetFFlagLuafiedReportEntryPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuafiedReportEntryPoints"),
	GetFFlagLuafiedReportFullFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuafiedReportFullFlow"),
	GetFFlagLuafiedReportThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuafiedReportThumbnail"),
	GetFFlagLuafiedReportErrorStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuafiedReportErrorStates"),
	GetFFlagVRAbuseReportLocales = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagVRAbuseReportLocales"),
	GetFIntMaquettesAppPanelDistanceMultiplierPercentage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntMaquettesAppPanelDistanceMultiplierPercentage"),
	GetFFlagFriendsMenuDummyLoadingFriendsFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFriendsMenuDummyLoadingFriendsFix"),
	FFlagEnableUIManagerPackgify = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUIManagerPackgify"),
	GetFFlagEnableVolumeSliderQOLFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVolumeSliderQOLFix"),
	FFlagEnableSettingsHubUIDelegateRollout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSettingsHubUIDelegateRollout"),
	FFlagEnableInExperienceUIPCVRFix = game:DefineFastFlag("EnableInExperienceUIPCVRFix_dev", false),
	GetFFlagEnableVREnvironmentSetting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVREnvironmentSetting"),
	GetFStringDefaultVREnvironmentSetting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringDefaultVREnvironmentSetting"),
	GetFIntVREnvironmentSettingLightClockTime = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntVREnvironmentSettingLightClockTime"),
	GetFIntVREnvironmentSettingDarkClockTime = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntVREnvironmentSettingDarkClockTime"),
	GetFFlagEnableSkyStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSkyStyle"),
	GetFStringDefaultSkyStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringDefaultSkyStyle"),
	GetFIntSkyStyleDayClockTime = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntSkyStyleDayClockTime"),
	GetFFlagLuaAppCustomizableEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppCustomizableEntryPoint"),
	GetFIntIntervalPerformanceTrackerEventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntIntervalPerformanceTrackerEventStream"),
	GetFFlagEnableNavigationPerformanceIntervals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableNavigationPerformanceIntervals"),
	FFlagLuaAppScrollTelemetryIntegration = game:DefineFastFlag("LuaAppScrollTelemetryIntegration", false),
	FFlagAXScrollTelemetryIntegration2 = game:DefineFastFlag("AXScrollTelemetryIntegration2", false),
	FFlagLuaAppSkipStartupRouteHop = game:DefineFastFlag("LuaAppSkipStartupRouteHop", false),
	GetFFlagEnableTenftUiDetailsMoreDropupMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableTenftUiDetailsMoreDropupMenu"),
	GetFFlagEnableAbuseReport10ft = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAbuseReport10ft"),
	GetFFlagUseExternalBrowserForAgeGuidelines10ft = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagUseExternalBrowserForAgeGuidelines10ft"),
	GetFFlagLuaAppRefactorSelectRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppRefactorSelectRoute"),
	FFlagDebugForceConsoleSafeInsets = game:DefineFastFlag("DebugForceConsoleSafeInsets", false),
	FFlagAddGamepadBumperNavigation = game:DefineFastFlag("AddGamepadBumperNavigation3", false),
	FFlagMoveGamepadDisconnectHandlerToUniversalApp = game:DefineFastFlag(
		"MoveGamepadDisconnectHandlerToUniversalApp",
		false
	),
	FFlagAppChatOnConsoles = game:DefineFastFlag("AppChatOnConsoles", false),
	FFlagExpChatFriendsTabUsePolicy = game:DefineFastFlag("ExpChatFriendsTabUsePolicy", false),
	FFlagSearchAllRegistryEntriesForAutoFocus = game:DefineFastFlag(
		"SearchAllRegistryEntriesForAutoFocus",
		false
	),
	getFStringSocialUserSearchResultsPageLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialUserSearchResultsPageLayer"),
	getFStringSocialAddFriendsPageLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialAddFriendsPageLayer"),
	getFStringSocialFriendsLandingLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialFriendsLandingLayer"),
	getFStringSocialFriendsLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialFriendsLayer"),
	getFStringSocialProfileLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialProfileLayer"),
	getFStringSocialConnectTabLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFStringSocialConnectTabLayer"),
	GetFStringLargerRobuxUpsellIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringLargerRobuxUpsellIxpLayer"),
	GetFStringAndroidPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringAndroidPhoneVerificationLayer"),
	GetFStringIOSPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringIOSPhoneVerificationLayer"),
	FStringCapturesTabIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringCapturesTabIXPLayer"),
	FStringReportMenuIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringReportMenuIXPLayer"),
	FStringSelectInSceneIXPField = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringSelectInSceneIXPField"),
	FStringReportingIXPLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringReportingIXPLayer"),
	GetFStringLuaAppExperienceMenuLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringLuaAppExperienceMenuLayer"),
	FStringRMLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringRMLayer"),
	FStringRMDefinition = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringRMDefinition"),
	FFlagEnableRMOnMorePageGUAC = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRMOnMorePageGUAC"),
	FFlagEnableRMOnMorePageForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRMOnMorePageForAll"),
	FFlagEnableBlackbird = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbird"),
	FFlagEnableBlackbirdOnMorePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbirdOnMorePage"),
	FFlagEnableBlackbirdOnFlyoutMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbirdOnFlyoutMenu"),
	FFlagEnableFlyoutMenuRobuxCardRefactor = game:DefineFastFlag("EnableFlyoutMenuRobuxCardRefactor", false),
	FFlagEnableSharedFlyoutRobuxPill = game:DefineFastFlag("EnableSharedFlyoutRobuxPill", false),
	FFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbirdCheck"),
	FFlagEnableTradesEntryForNonPremium = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableTradesEntryForNonPremium"),
	FFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbirdPageCloseCallback"),
	FFlagHidePremiumIconography = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHidePremiumIconography"),
	GetFFlagFixUserInfoWidgetPlusBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixUserInfoWidgetPlusBadge"),
	FFlagBlackbirdRequiresIAP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBlackbirdRequiresIAP"),
	FFlagBlackbirdUpdateStringFlyoutMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBlackbirdUpdateStringFlyoutMenu"),
	GetFStringBlackbirdUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringBlackbirdUrl"),
	GetFFlagReportAnythingEnableAdReport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagReportAnythingEnableAdReport"),
	GetFFlagGetHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGetHumanoidDescription"),
	GetFFlagRAEnableCircleRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagRAEnableCircleRegion"),
	FFlagEnableModularizedUserAgreementsList = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableModularizedUserAgreementsList"),
	GetFFlagEnableAbuseReportMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAbuseReportMutedError"),
	GetFFlagEnableChatLineReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableChatLineReporting"),
	GetFFlagAddMorePhoneUpsellEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAddMorePhoneUpsellEvents"),
	GetFFlagIntegratePhoneUpsellJoinVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagIntegratePhoneUpsellJoinVoice"),
	GetFFlagInExperiencePhoneUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagInExperiencePhoneUpsellNewCopy"),
	FFlagPhoneUpsellLegalLinkPolicy = game:DefineFastFlag("PhoneUpsellLegalLinkPolicy", false),
	FFlagHomePhoneVerificationUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHomePhoneVerificationUpsellNewCopy"),
	FFlagLogoutPhoneVerificationUpsellCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLogoutPhoneVerificationUpsellCopy"),
	FFlagInExperienceAddPhoneViewNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInExperienceAddPhoneViewNewCopy"),
	FFlagEnableUserAccessServiceIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUserAccessServiceIntegration"),
	GetFFlagReportAnythingAnnotationIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagReportAnythingAnnotationIXP"),
	GetFStringReportAnythingAnnotationIXPLayerName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringReportAnythingAnnotationIXPLayerName"),
	GetFFlagEnableSecurityAlertDeeplink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSecurityAlertDeeplink"),
	FFlagRenameParentEmailForVerificationUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRenameParentEmailForVerificationUpsell"),
	FFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAbuseReportRevampFlow"),
	GetFFlagGameJoinTimeoutChatAttemptEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGameJoinTimeoutChatAttemptEnabled"),
	GetFFlagGetHumanoidDescriptionUpdatesV2E = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGetHumanoidDescriptionUpdatesV2E"),
	GetFFlagEnableSecurityAlertToastCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSecurityAlertToastCallback"),
	GetFFlagGenerateLinkWithChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGenerateLinkWithChannel"),
	FFlagEnableNapIxpLayerExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNapIxpLayerExposure"),
	FFlagKidsNotApprovedPageTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagKidsNotApprovedPageTreatment"),
	FFlagNotApprovedPageIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagNotApprovedPageIXPExposure"),
	FFlagCheckUserModerationAfterLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCheckUserModerationAfterLogin"),
	GetFFlagEnableToastIconSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableToastIconSupport"),
	GetFFlagFilterSecurityAlertsVRToastEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFilterSecurityAlertsVRToastEnabled"),
	FFlagFriendshipNotifsUseSendrExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendshipNotifsUseSendrExperiment"),
	FFlagEnableInlineSurveyOnUserReport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInlineSurveyOnUserReport"),
	FFlagInlineSurveyEnhancements = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineSurveyEnhancements"),
	FFlagInlineSurveyPartialResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineSurveyPartialResponse"),
	FFlagInlineSurveyBranching = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineSurveyBranching"),
	FFlagInlineSurveyChoiceTextEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineSurveyChoiceTextEntry"),
	FFlagEnableGlobalChatAbuseReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableGlobalChatAbuseReporting"),
	FFlagAbuseReportAttributedRBXSystemMessages = game:DefineFastFlag(
		"AbuseReportAttributedRBXSystemMessages",
		false
	),
	FFlagGenericAbuseReportingGranularExports = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGenericAbuseReportingGranularExports"),
	FFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddThumbnailSelectorReport"),
	FFlagDropUnroutableMultiReportOptions = game:DefineFastFlag("DropUnroutableMultiReportOptions", false),
	GetFFlagMoveAmpUpsellOffNavigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagMoveAmpUpsellOffNavigateDown"),
	GetFFlagInExperienceContainerScreenSizeReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagInExperienceContainerScreenSizeReducer"),
	GetFFlagInExperienceContainerAppLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagInExperienceContainerAppLinking"),
	GetFFlagInExperienceContainerRespectUserTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagInExperienceContainerRespectUserTheme"),
	FFlagHighlightModePreciseSelectionEnabled = game:GetEngineFeature("ExperienceStateCaptureSelectionMode") and game:DefineFastFlag(
		"HighlightModePreciseSelectionEnabled3",
		false
	),
	FStringHighlightModePreciseSelectionIXPField = game:DefineFastString(
		"HighlightModePreciseSelectionIXPField",
		"HighlightModePreciseSelectionVariant"
	),
	FStringHighlightModePreciseSelectionForceVariant = game:DefineFastString(
		"HighlightModePreciseSelectionForceVariant",
		""
	),
	GetFFlagPasswordErrorLength = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPasswordErrorLength"),
	FFlagMigrateAllOsaMessagingToCentralService = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMigrateAllOsaMessagingToCentralService"),
	FFlagPrefillPreciseSelectionChoices = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPrefillPreciseSelectionChoices"),
	FFlagSupportSubmissionOnAllReportNodes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSupportSubmissionOnAllReportNodes"),
	FFlagUpdateTranslateInReportRevamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUpdateTranslateInReportRevamp"),
	FFlagAppChatReactiveFeatureRestrictions = game:DefineFastFlag(
		"AppChatReactiveFeatureRestrictions",
		false
	),
	FFlagAppChatUniversalFeatureRestriction = game:DefineFastFlag(
		"AppChatUniversalFeatureRestriction",
		false
	),
	FFlagProactiveVoiceRestrictionsUFR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProactiveVoiceRestrictionsUFR"),
	FFlagReactiveVoiceRestrictionsUFR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagReactiveVoiceRestrictionsUFR"),
	FFlagNavigateToSafetyDashboardForAppeals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagNavigateToSafetyDashboardForAppeals"),
	FFlagAddTakeItDownReportLinkToSurfaces = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddTakeItDownReportLinkToSurfaces"),
	GetFFlagEnableSupportCenter = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSupportCenter"),
	FFlagEnableAccountUnlockDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAccountUnlockDeepLink"),
	FFlagEnableAdConsentUserSettingsPublish = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAdConsentUserSettingsPublish"),
	FFlagAdConsentForwardCachedRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAdConsentForwardCachedRegion"),
	FFlagMoveAdConsentReceiverToAccountManagement = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMoveAdConsentReceiverToAccountManagement"),
	FFlagAccountLockReceiverClosesModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAccountLockReceiverClosesModal"),
	FFlagShowAccountUnlockMismatchDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowAccountUnlockMismatchDialog"),
	FFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose"),
	FFlagEnablePersonaLivenessQR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePersonaLivenessQR"),
	FFlagSurvBloxEventTypeEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSurvBloxEventTypeEnabled"),
	FFlagAccountUnlockAllowMissingUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAccountUnlockAllowMissingUserId"),
	GetFFlagEnhancedPersonaLivenessEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnhancedPersonaLivenessEvents"),
	FFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAbuseReportInExpPlayerListV3"),
	FFlagAbuseReportSubmissionTargetV4 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAbuseReportSubmissionTargetV4"),
	FFlagAbuseReportVoiceMute = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAbuseReportVoiceMute"),
	FFlagEnableChatReportingTextChannelTag = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableChatReportingTextChannelTag"),
	FFlagEnableNewReportFlowGameTile = game:DefineFastFlag("EnableNewReportFlowGameTile", false),
	FFlagNAPUseRootLabelTranslationKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagNAPUseRootLabelTranslationKey"),
	FFlagSduiCommunitySectionSupport = game:DefineFastFlag("SduiCommunitySectionSupport", false),
	FFlagLuaAppEdpShowBuildTag = game:DefineFastFlag("LuaAppEdpShowBuildTag", false),
	FFlagSduiPreferredTextSizeLineBudgets = game:DefineFastFlag("SduiPreferredTextSizeLineBudgets", false),
	FFlagSduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiCollectionGridRevealRows"),
	FFlagLuaAppCollectionGridRemeasureOnMove = game:DefineFastFlag(
		"LuaAppCollectionGridRemeasureOnMove",
		false
	),
	FFlagSduiMuralSection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiMuralSection"),
	FFlagSduiCapabilityBindings = game:DefineFastFlag("SduiCapabilityBindings2", false),
	FFlagSduiCapabilityDevStoreSeeAllWebviewFallback = game:DefineFastFlag(
		"SduiCapabilityDevStoreSeeAllWebviewFallback",
		false
	),
	FFlagSduiEventRsvpFacePile = game:DefineFastFlag("SduiEventRsvpFacePile", false),
	FFlagSduiLeaderboardCapability = game:DefineFastFlag("SduiLeaderboardCapability", false),
	FFlagSduiScalePlayButtonAndImageSizes = game:DefineFastFlag("SduiScalePlayButtonAndImageSizes", false),
	FFlagSduiLinkActionSharedWebLink = game:DefineFastFlag("SduiLinkActionSharedWebLink", false),
	FFlagSduiOverflowMenuHideWhenEmpty = game:DefineFastFlag("SduiOverflowMenuHideWhenEmpty", false),
	FFlagSduiAlwaysCacheWithIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiAlwaysCacheWithIdentifier"),
	FFlagDataHydrationAccountReset = module3,
	FFlagBuildExperienceModelPickerData = v67,
	FFlagBuildExperienceChatOpenId = game:DefineFastFlag("BuildExperienceChatOpenId", false),
	FFlagDataHydrationStaleTime = game:DefineFastFlag("DataHydrationStaleTime", false),
	FFlagHomePageRefetchOnDataHydrationAccountReset = v68,
	FFlagSduiHomeStartupSnapshot = game:DefineFastFlag("SduiHomeStartupSnapshot", false),
	FFlagSduiHydrationDataCamelCasePropertyKeys = game:DefineFastFlag(
		"SduiHydrationDataCamelCasePropertyKeys",
		false
	),
	FFlagSduiNotificationBadgeHydration = game:DefineFastFlag("SduiNotificationBadgeHydration", false),
	FFlagSduiBuyRobuxHydration = game:DefineFastFlag("SduiBuyRobuxHydration", false),
	FFlagSduiSearchClientTemplateCache = v62,
	FFlagEnableHomePageSduiPrefetch = engineFeature4,
	FFlagHomePageSduiPrefetchExtendedClientCapabilities = engineFeature5,
	FFlagSduiEdpClientTemplateCache = defineFastFlag78,
	FFlagGroupAnnouncementsSdui = game:DefineFastFlag("GroupAnnouncementsSdui", false),
	FFlagGroupForumsDiscoverySdui = game:DefineFastFlag("GroupForumsDiscoverySdui", false),
	FFlagGroupForumPostTemplate = game:DefineFastFlag("GroupForumPostTemplate", false),
	FFlagGroupPeekEngagementTelemetry = game:DefineFastFlag("GroupPeekEngagementTelemetry", false),
	FFlagGroupSduiPublishContainerWidth = game:DefineFastFlag("GroupSduiPublishContainerWidth", false),
	FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = game:DefineFastFlag(
		"SduiFeatureEntryPointTakesAbsoluteSizeHandler",
		false
	),
	FFlagLuaAppAddHomeExtraTopPadding = game:DefineFastFlag("LuaAppAddHomeExtraTopPadding", false),
	FFlagSduiPageEntryUseSharedHooks = game:DefineFastFlag("SduiPageEntryUseSharedHooks", false),
	FFlagLuaAppSduiHomeFriendCarousel = game:DefineFastFlag("LuaAppSduiHomeFriendCarousel", false),
	FFlagSduiPropParsersShouldHandleTokens = game:DefineFastFlag("SduiPropParsersShouldHandleTokens", false),
	FFlagSduiUnwrapStructPropEnvelope = game:DefineFastFlag("SduiUnwrapStructPropEnvelope", false),
	FFlagSduiMarketplaceCatalogCategorySupport = game:DefineFastFlag(
		"SduiMarketplaceCatalogCategorySupport2",
		false
	),
	FFlagSduiSkipEmptyCatalogCategoryHydration = game:DefineFastFlag(
		"SduiSkipEmptyCatalogCategoryHydration",
		false
	),
	FFlagSduiMarketplaceCatalogSortSupport = game:DefineFastFlag(
		"SduiMarketplaceCatalogSortSupport6",
		false
	),
	FFlagSduiArrayMapEmptyWhileHydrationNotReady = game:DefineFastFlag(
		"SduiArrayMapEmptyWhileHydrationNotReady",
		false
	),
	FFlagSduiCatalogItemGrid = game:DefineFastFlag("SduiCatalogItemGrid", false),
	FFlagSduiItemMediaHeader = game:DefineFastFlag("SduiItemMediaHeader", false),
	FFlagSduiCatalogItemCard = game:DefineFastFlag("SduiCatalogItemCard", false),
	FFlagSduiCardBackgroundClickable = game:DefineFastFlag("SduiCardBackgroundClickable", false),
	FFlagAXFavoritesManagerSdui = game:DefineFastFlag("AXFavoritesManagerSdui", false),
	FFlagSduiMarketplaceCatalogActions = game:DefineFastFlag("SduiMarketplaceCatalogActions4", false),
	FFlagSduiAddMarketplaceEntityDataHydration = game:DefineFastFlag(
		"SduiAddMarketplaceEntityDataHydration",
		false
	),
	FFlagSduiAddCollectibleItemDataHydration = game:DefineFastFlag(
		"SduiAddCollectibleItemDataHydration",
		false
	),
	FFlagSduiLeaderboardComponent = game:DefineFastFlag("SduiLeaderboardComponent", false),
	FFlagLuaAppExperienceLeaderboardSeeAllEnabled = game:DefineFastFlag(
		"LuaAppExperienceLeaderboardSeeAllEnabled2",
		false
	),
	FFlagMarketplaceCatalogSortTrackLastReceived = game:DefineFastFlag(
		"MarketplaceCatalogSortTrackLastReceived",
		false
	),
	FFlagMarketplaceCatalogCategoryTrackLastReceived = game:DefineFastFlag(
		"MarketplaceCatalogCategoryTrackLastReceived",
		false
	),
	FFlagSduiPlayWithReward = game:DefineFastFlag("SduiPlayWithReward", false),
	FFlagSduiPlayWithRewardRefactor = game:DefineFastFlag("SduiPlayWithRewardRefactor2", false),
	FStringLuaAppPlayWithRewardBetaIxpVariantKey = game:DefineFastString(
		"LuaAppPlayWithRewardBetaIxpVariantKey",
		"Variant"
	),
	FStringLuaAppPlayWithRewardBetaIxpTreatmentValue = game:DefineFastString(
		"LuaAppPlayWithRewardBetaIxpTreatmentValue",
		"Treatment"
	),
	FIntPlayWithRewardFallbackBannerProductImageAssetId = game:DefineFastInt(
		"PlayWithRewardFallbackBannerProductImageAssetId",
		0
	),
	FFlagSduiActionSequence = game:DefineFastFlag("SduiActionSequence", false),
	FFlagConnectionAmpParentalApprovalUpsell = defineFastFlag20,
	FFlagConnectionParentalApprovalLeaveOnly = v9,
	FFlagConnectionUpsellAnalytics = defineFastFlag21,
	FFlagLuaAppAddIgrsImages = game:DefineFastFlag("LuaAppAddIgrsImages", false),
	FFlagLuaAppLogOmniRecommendationsMetadata = game:DefineFastFlag(
		"LuaAppLogOmniRecommendationsMetadata2",
		false
	),
	FFlagLuaAppUseEffectInSignalPreprocessing = game:DefineFastFlag(
		"LuaAppUseEffectInSignalPreprocessing",
		false
	),
	FFlagSduiErrorPaths = game:DefineFastFlag("SduiErrorPaths", false),
	FFlagSduiExperimentalComponent = game:DefineFastFlag("SduiExperimentalComponent", false),
	FFlagSduiSandboxContentInputData = game:DefineFastFlag("SduiSandboxContentInputData", false),
	FFlagLuaAppSortHeaderAnchorTag = game:DefineFastFlag("LuaAppSortHeaderAnchorTag", false),
	FFlagLuaAppRfyRevealRows = game:DefineFastFlag("LuaAppRfyRevealRows2", false),
	FFlagLuaAppBadgesSeeAllEnabled = game:DefineFastFlag("LuaAppBadgesSeeAllEnabled4", false),
	FFlagLuaAppBadgesSeeAllLogExposure = game:DefineFastFlag("LuaAppBadgesSeeAllLogExposure", false),
	FStringLuaAppBadgesSeeAllIxpLayer = game:DefineFastString(
		"LuaAppBadgesSeeAllIxpLayer",
		"PlayerApp.Badges.Exposure"
	),
	FFlagLuaAppBadgeDetailsEnabled = game:DefineFastFlag("LuaAppBadgeDetailsEnabled6", false),
	FFlagLuaAppBadgeDetailsLogExposure = game:DefineFastFlag("LuaAppBadgeDetailsLogExposure", false),
	FStringLuaAppBadgeDetailsIxpLayer = game:DefineFastString(
		"LuaAppBadgeDetailsIxpLayer",
		"PlayerApp.BadgeDetails.Exposure"
	),
	FFlagLuaAppSduiEdpEnabled = game:DefineFastFlag("LuaAppSduiEdpEnabled2", false),
	FFlagFixSduiEdpTtiColdStart = defineFastFlag86,
	FFlagEDPTTIParityDefinitions = v64,
	FFlagLuaAppFixPassesPageStoreFetch = game:DefineFastFlag("LuaAppFixPassesPageStoreFetch", false),
	FFlagLuaAppFixNotificationBadgeCountsSync = game:DefineFastFlag(
		"LuaAppFixNotificationBadgeCountsSync",
		false
	),
	FFlagLuaAppSduiEdpLogExposure = game:DefineFastFlag("LuaAppSduiEdpLogExposure", false),
	FFlagLuaAppSduiEdpLogExposureLayoutEffect = game:DefineFastFlag(
		"LuaAppSduiEdpLogExposureLayoutEffect",
		false
	),
	FFlagLuaAppSduiEdpFallbackAttributionFromCache = game:DefineFastFlag(
		"LuaAppSduiEdpFallbackAttributionFromCache2",
		false
	),
	FStringLuaAppSduiEdpIxpLayer = game:DefineFastString(
		"LuaAppSduiEdpIxpLayer",
		"PlayerApp.ExperienceDetails.Exposure"
	),
	FFlagLuaAppSduiEventDetailsEnabled = game:DefineFastFlag("LuaAppSduiEventDetailsEnabled", false),
	FFlagLuaAppSduiLandingPageEnabled = game:DefineFastFlag("LuaAppSduiLandingPageEnabled", false),
	FFlagLuaEnableGenreLandingDeeplink = game:DefineFastFlag("LuaEnableGenreLandingDeeplink", false),
	FFlagLuaAppSduiEventDetailsLogExposure = game:DefineFastFlag("LuaAppSduiEventDetailsLogExposure", false),
	FFlagLuaAppSduiEventDetailsCenterSheet = game:DefineFastFlag(
		"LuaAppSduiEventDetailsCenterSheet2",
		false
	),
	FFlagLuaAppSduiEventDetailsActionBarInFeed = game:DefineFastFlag(
		"LuaAppSduiEventDetailsActionBarInFeed",
		false
	),
	FStringLuaAppSduiEventDetailsIxpLayer = game:DefineFastString(
		"LuaAppSduiEventDetailsIxpLayer",
		"PlayerApp.EventDetails.Exposure"
	),
	FFlagLuaAppLogChartsAppPageExposure = game:DefineFastFlag("LuaAppLogChartsAppPageExposure", false),
	FFlagLuaAppLogSearchTopPageExposure = game:DefineFastFlag("LuaAppLogSearchTopPageExposure", false),
	FStringLuaAppSearchTopPageIxpLayer = game:DefineFastString(
		"LuaAppSearchTopPageIxpLayer",
		"PlayerApp.SearchResultsPage.PowerSearch"
	),
	FFlagSduiSearchResultsPageEnabled = v12,
	FFlagSduiReleaseSearchResultsPageState = defineFastFlag80,
	FFlagSduiUserSearchTile = v63,
	FFlagSduiAiOverviewEnabled = game:DefineFastFlag("SduiAiOverviewEnabled", false),
	FFlagLuaAppRespectClipAncestorImpressions = game:DefineFastFlag(
		"LuaAppRespectClipAncestorImpressions",
		false
	),
	FFlagSduiVerticalListWithImpressionsEnabled = game:DefineFastFlag(
		"SduiVerticalListWithImpressionsEnabled",
		false
	),
	FFlagSduiViewContainerRefEnabled = game:DefineFastFlag("SduiViewContainerRefEnabled", false),
	FFlagSduiViewStateLayerAffordance = game:DefineFastFlag("SduiViewStateLayerAffordance", false),
	FFlagSduiCarouselUseNestedImpressionsFeedContext = game:DefineFastFlag(
		"SduiCarouselUseNestedImpressionsFeedContext",
		false
	),
	FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = game:DefineFastInt(
		"LuaAppUpdateImpressionsViewportBoundsPositionThreshold",
		50
	),
	FIntLuaAppViewportBoundsScreenSizeThreshold = game:DefineFastInt(
		"LuaAppViewportBoundsScreenSizeThreshold",
		50
	),
	FFlagSduiOpenSearchResultsTabAction = game:DefineFastFlag("SduiOpenSearchResultsTabAction", false),
	FFlagLuaAppSduiOpenExternalLinkAction = game:DefineFastFlag("LuaAppSduiOpenExternalLinkAction", false),
	FFlagSafetyResourceBannerTelemetry = game:DefineFastFlag("SafetyResourceBannerTelemetry", false),
	FFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation = game:DefineFastFlag(
		"LuaAppSduiOpenExternalLinkSkipLeaveConfirmation",
		false
	),
	FFlagSduiSocialDataMigrateOffLegacyPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiSocialDataMigrateOffLegacyPresence"),
	FFlagSduiRequestFriendshipAction = game:DefineFastFlag("SduiRequestFriendshipAction4", false),
	FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUserSearchPresenceStoreMigration"),
	FFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMigrateFriendshipStatusesRemainingActions"),
	FFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableFriendsStoreChallengeInterceptor"),
	FFlagLuaAppAddTestIdsForArrow = game:DefineFastFlag("LuaAppAddTestIdsForArrow", false),
	FFlagLuaAppMigrateGameEventsTelemetryService = game:DefineFastFlag(
		"LuaAppMigrateGameEventsTelemetryService",
		false
	),
	FFlagLuaAppMigrateItemEventsTelemetryService = game:DefineFastFlag(
		"LuaAppMigrateItemEventsTelemetryService",
		false
	),
	FFlagLuaAppGameEventsTelemetryServiceShadowTraffic = game:DefineFastFlag(
		"LuaAppGameEventsTelemetryServiceShadowTraffic",
		false
	),
	FFlagLuaAppItemEventsTelemetryServiceShadowTraffic = game:DefineFastFlag(
		"LuaAppItemEventsTelemetryServiceShadowTraffic",
		false
	),
	FFlagLuaAppEdpPeekViewReserveBottomDockHeight = game:DefineFastFlag(
		"LuaAppEdpPeekViewReserveBottomDockHeight",
		false
	),
	FFlagLuaAppEdpKeepCachedDetailsOnRefetch = game:DefineFastFlag(
		"LuaAppEdpKeepCachedDetailsOnRefetch",
		false
	),
	FFlagLuaAppEdpHideSystemBarOnPeekViewMount = game:DefineFastFlag(
		"LuaAppEdpHideSystemBarOnPeekViewMount",
		false
	),
	FFlagLuaAppEdpKeepFullPageOnPortraitRotation = game:DefineFastFlag(
		"LuaAppEdpKeepFullPageOnPortraitRotation",
		false
	),
	FFlagLuaAppEdpMediaGalleryHeightJitterFix = game:DefineFastFlag(
		"LuaAppEdpMediaGalleryHeightJitterFix",
		false
	),
	FFlagLuaAppEdpDirectionalGradientMidTransparency = game:DefineFastFlag(
		"LuaAppEdpDirectionalGradientMidTransparency",
		false
	),
	FFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppMediaGalleryGamepadSupport"),
	FFlagLuaAppMediaGalleryPageIndicatorOpacity = game:DefineFastFlag(
		"LuaAppMediaGalleryPageIndicatorOpacity",
		false
	),
	FFlagLuaAppMediaGalleryHideScrollArrowsOnTouch = game:DefineFastFlag(
		"LuaAppMediaGalleryHideScrollArrowsOnTouch",
		false
	),
	FFlagLuaAppUpdateFailedStateEdpIcon = game:DefineFastFlag("LuaAppUpdateFailedStateEdpIcon", false),
	FFlagGetGameIconsFromThumbnailsDeliveryApiIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGetGameIconsFromThumbnailsDeliveryApiIxp"),
	FFlagForceGetGameIconsFromThumbnailsDeliveryApi = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagForceGetGameIconsFromThumbnailsDeliveryApi"),
	FFlagLuaAppFeatureTileHapticsFix = game:DefineFastFlag("LuaAppFeatureTileHapticsFix", false),
	FFlagLuaAppToastV2PerMessageDuration = game:DefineFastFlag("LuaAppToastV2PerMessageDuration", false),
	FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = game:DefineFastFlag(
		"LuaAppMakeDisclaimerOptInForFeedbackForm",
		false
	),
	FFlagLuaAppTextFeedbackFormModal = game:DefineFastFlag("LuaAppTextFeedbackFormModal", false),
	FFlagLuaAppNotInterestedFeedbackFormTelemetry = game:DefineFastFlag(
		"LuaAppNotInterestedFeedbackFormTelemetry",
		false
	),
	FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = game:DefineFastFlag(
		"LuaAppFixExplicitFeedbackConsoleTelemetry",
		false
	),
	FFlagLuaAppGameTileOverflowMenuFocusTransferFix = game:DefineFastFlag(
		"LuaAppGameTileOverflowMenuFocusTransferFix",
		false
	),
	FFlagLuaAppAddSessionIdToUserSignals = game:DefineFastFlag("LuaAppAddSessionIdToUserSignals", false),
	FFlagLuaAppAddSocialLinkClickTelemetryToEdp = game:DefineFastFlag(
		"LuaAppAddSocialLinkClickTelemetryToEdp",
		false
	),
	FFlagSduiCardComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiCardComponent"),
	FFlagLuaAppConfigureSduiCardImageScaleType = game:DefineFastFlag(
		"LuaAppConfigureSduiCardImageScaleType",
		false
	),
	FFlagAXVirtualizedFeedVerticalPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXVirtualizedFeedVerticalPadding"),
	FFlagVirtualizedFeedFooterWrapperProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVirtualizedFeedFooterWrapperProp"),
	FFlagSduiCatalogVirtualizedFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiCatalogVirtualizedFeed"),
	FFlagSduiCatalogCategoryMenu = game:DefineFastFlag("SduiCatalogCategoryMenu", false),
	FFlagFixSduiCardFocusNavScroll = game:DefineFastFlag("FixSduiCardFocusNavScroll", false),
	FFlagSduiChipAccessoryProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiChipAccessoryProps"),
	FFlagSduiChipSizeAndVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiChipSizeAndVariant"),
	FFlagSduiDividerThemeAwareStroke = game:DefineFastFlag("SduiDividerThemeAwareStroke", false),
	FFlagLuaAppSduiRemoveAbuseReportActionFromLegacyRegistry = game:DefineFastFlag(
		"LuaAppSduiRemoveAbuseReportActionFromLegacyRegistry",
		false
	),
	FFlagLuaAppUseOverlayInAppContainer = game:DefineFastFlag("LuaAppUseOverlayInAppContainer", false),
	FFlagLuaAppSduiPageEntryPointSnackbar = defineFastFlag26,
	FFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiVideoThumbnail"),
	FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiSuppressVideoDetectorDuringScroll"),
	FFlagLuaAppResponsiveEnginePreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppResponsiveEnginePreferredInput"),
	FFlagLuaAppPlayButtonLoadingPrimary = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppPlayButtonLoadingPrimary"),
	FFlagLuaAppEnableRelativeGuiHomeWithIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableRelativeGuiHomeWithIxp"),
	FFlagLuaAppEnableRelativeGuiHomeForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableRelativeGuiHomeForAll"),
	FFlagLuaAppHeaderButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHeaderButtonText"),
	FFlagLuaAppFriendCarouselImpressionsTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppFriendCarouselImpressionsTimestamp"),
	FFlagLuaAppPropagateFriendsCarouselHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppPropagateFriendsCarouselHeader"),
	FIntLuaAppFriendsSortHeaderMaxHiddenPosition = game:DefineFastInt(
		"LuaAppFriendsSortHeaderMaxHiddenPosition",
		1
	),
	FFlagLuaAppFriendsSortHeaderByPosition = game:DefineFastFlag("LuaAppFriendsSortHeaderByPosition", false),
	FFlagFixMediaGalleryOversized = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixMediaGalleryOversized"),
	FFlagMediaAccordionAndFullTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMediaAccordionAndFullTelemetry"),
	FFlagSduiSkipFeedAnalyticsPosition = defineFastFlag37,
	FFlagSduiPerSectionPoolSizing = defineFastFlag38,
	FFlagSduiIndividualFeedItemSpacing = defineFastFlag39,
	FFlagSduiSamePoolFeedItemSpacing = v14,
	FFlagSduiPageCanvasCollectionLayout = defineFastFlag82,
	FFlagSduiVerticalFeedScrollTelemetry = game:DefineFastFlag("SduiVerticalFeedScrollTelemetry", false),
	FFlagSduiOptionSelectorCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiOptionSelectorCollection"),
	FFlagSduiOptionImpressionsEventName = game:DefineFastFlag("SduiOptionImpressionsEventName", false),
	FFlagSduiOptionSelectorHeaderComponent = game:DefineFastFlag("SduiOptionSelectorHeaderComponent", false),
	FFlagSduiOptionSelectorAnchorTag = game:DefineFastFlag("SduiOptionSelectorAnchorTag", false),
	FFlagSduiOptionSelectorSkipSelectedRefresh = game:DefineFastFlag(
		"SduiOptionSelectorSkipSelectedRefresh",
		false
	),
	FFlagLuaAppMoveProfileIntoTopBarIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppMoveProfileIntoTopBarIXP"),
	FFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppMoveProfileIntoTopBar"),
	FFlagLuaAppEnableSduiApiStoreInFlightFix = game:DefineFastFlag(
		"LuaAppEnableSduiApiStoreInFlightFix",
		false
	),
	FFlagLuaAppEnableSduiHomePage = game:DefineFastFlag("LuaAppEnableSduiHomePage3", false) and defineFastFlag77 and engineFeature4,
	FFlagLuaAppSduiHomePageSupport = defineFastFlag77,
	FFlagLuaAppSduiHomeSortDetailPageContext = game:DefineFastFlag(
		"LuaAppSduiHomeSortDetailPageContext",
		false
	),
	FFlagSduiChartsSortDetailGenreFilter = game:DefineFastFlag("SduiChartsSortDetailGenreFilter", false) and require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiOptionSelectorCollection"),
	FFlagSduiChartsPlaceholderMergeStrategySupport = defineFastFlag33,
	FFlagSduiChartsRequestPlaceholders = game:DefineFastFlag("SduiChartsRequestPlaceholders", false) and defineFastFlag33,
	FFlagSduiStreamingRefreshReplacesInputData = game:DefineFastFlag(
		"SduiStreamingRefreshReplacesInputData",
		false
	),
	FFlagSduiRefreshFeedItemIsOmissionExpected = game:DefineFastFlag(
		"SduiRefreshFeedItemIsOmissionExpected",
		false
	),
	FFlagSduiFreshInputDataSignalOnRebuild = game:DefineFastFlag("SduiFreshInputDataSignalOnRebuild", false),
	FFlagSduiSharedLocalizedLiterals = game:DefineFastFlag("SduiSharedLocalizedLiterals", false),
	FFlagChartsHydrationStreaming = game:DefineFastFlag("ChartsHydrationStreaming2", false),
	FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = game:DefineFastInt(
		"LuaAppSduiCarouselPlaceholderHeaderHeightPx",
		30
	),
	FFlagSduiCollectionCarouselPlaceholderItem = game:DefineFastFlag(
		"SduiCollectionCarouselPlaceholderItem",
		false
	),
	FFlagLuaAppEnableChartsPageProfileLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableChartsPageProfileLink"),
	FFlagLuaAppEnableMorePageProfileLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableMorePageProfileLink"),
	FFlagSduiActionsUpdateFiresOwnTelemetry = game:DefineFastFlag(
		"SduiActionsUpdateFiresOwnTelemetry",
		false
	),
	FFlagSduiEdpPersistentActionBarPlayButton = module2,
	FFlagSduiContainerQueries = defineFastFlag83,
	FFlagInfoTableStableItemKeys = defineFastFlag84,
	FFlagSduiDevStoreSeeAllImpressionsLogging = game:DefineFastFlag(
		"SduiDevStoreSeeAllImpressionsLogging",
		false
	),
	FFlagSduiQueryImpressionsLogging = game:DefineFastFlag("SduiQueryImpressionsLogging", false),
	FFlagSduiSearchPeoplePlayerTileTelemetry = game:DefineFastFlag(
		"SduiSearchPeoplePlayerTileTelemetry",
		false
	),
	FFlagSduiSocialUpsellButtonClickTelemetry = game:DefineFastFlag(
		"SduiSocialUpsellButtonClickTelemetry",
		false
	),
	FFlagLuaAppParentUpsellPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppParentUpsellPolicy"),
	FFlagLuaAppPlayButtonAmpAgeCheckFlow = game:DefineFastFlag("LuaAppPlayButtonAmpAgeCheckFlow", false),
	FStringLuaAppPlayButtonAgeCheckAmpFeatureName = game:DefineFastString(
		"LuaAppPlayButtonAgeCheckAmpFeatureName",
		"TriggerAgeCheckUpsellIncludingVPC"
	),
	FStringLuaAppPlayButtonAgeCheckAmpNameSpace = game:DefineFastString(
		"LuaAppPlayButtonAgeCheckAmpNameSpace",
		"core_content/CoreContent"
	),
	FFlagLuaAppVpcUpsellNamespace = game:DefineFastFlag("LuaAppVpcUpsellNamespace", false),
	FStringLuaAppVpcSettingsChangeAmpNameSpace = game:DefineFastString(
		"LuaAppVpcSettingsChangeAmpNameSpace",
		"account_management/SettingsChange"
	),
	FStringLuaAppVpcAccountManagementAmpNameSpace = game:DefineFastString(
		"LuaAppVpcAccountManagementAmpNameSpace",
		"account_management/AccountManagement"
	),
	FFlagLuaAppOdpPrologueAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppOdpPrologueAnalytics"),
	FFlagLuaAppOdpRequestSentToast = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppOdpRequestSentToast"),
	FFlagLuaAppAmpWizardSendAnalyticsSessionId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppAmpWizardSendAnalyticsSessionId"),
	FFlagLuaAppParentApprovedExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppParentApprovedExperiences"),
	FFlagLuaAppDesktopFriendCarouselClicks = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppDesktopFriendCarouselClicks"),
	FFlagLuaAppDisableChevronSeeAll = game:DefineFastFlag("LuaAppDisableChevronSeeAll", false),
	FFlagLuaAppLoosenCollectionIdTypeInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLoosenCollectionIdTypeInterface"),
	FFlagLuaAppEnablePlayableStateWhenLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnablePlayableStateWhenLoading"),
	FFlagLuaAppLaunchWhenLoadingEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLaunchWhenLoadingEdp"),
	FFlagLuaAppLaunchWhenLoadingForce = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLaunchWhenLoadingForce"),
	FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce"),
	FFlagLuaAppPlayButtonCoalescePlayabilityFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppPlayButtonCoalescePlayabilityFetch"),
	FFlagLuaAppEdpFallbackPrimaryActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpFallbackPrimaryActivation"),
	FFlagLuaAppSupportDisablePlayableWhenLoading = defineFastFlag47,
	FFlagEnableSplitPane = defineFastFlag69,
	FFlagFixSplitPaneGamepadLayoutJitter = v49,
	FFlagFixDeviceInsetBackgroundSplitPaneWidth = v50,
	FFlagSplitPaneAvatarMetrics = game:DefineFastFlag("SplitPaneAvatarMetrics", false),
	FFlagEnableSplitPaneTelemetry = v38,
	FFlagLuaAppEnableDeviceInsetBackground = game:DefineFastFlag(
		"LuaAppEnableDeviceInsetBackground1",
		false
	),
	FFlagEnableSplitPaneEDPFix = v39,
	FFlagEnableSplitPaneStackFallbackFix = defineFastFlag70,
	FFlagSplitPaneIneligibleStackFallback = v40,
	FFlagEnableSplitPaneSessionL3 = v41,
	FFlagEnableOnScreenAPIIntegration = v42,
	FFlagAXPauseSceneWhenSplitPaneCollapsed = game:DefineFastFlag(
		"AXPauseSceneWhenSplitPaneCollapsed1",
		false
	),
	FFlagEnableSplitPaneAvatarOverlay = v43,
	FFlagSplitPaneEducationalTour = v45,
	FFlagSplitPaneProfileMaxWidth = v47,
	FFlagSplitPaneUnsavedDialogAlertStyle = v48,
	FFlagSocialTabsPageSplitPaneLayout = v54,
	FFlagSplitPaneExperimentVariants = defineFastFlag72,
	FFlagSplitPaneVariantDefaultCollapsed = defineFastFlag73,
	FFlagSplitPaneVariantAvatarOnHomeOnly = defineFastFlag74,
	FFlagSplitPaneVariantCollapsedAutoOpen = defineFastFlag75,
	FFlagSplitPaneDevStoreSeeAllSupportRegion = v55,
	FFlagSplitPaneBadgesSeeAllSupportRegion = v56,
	FFlagSplitPaneHostChromeYieldsInExpanded = v57,
	FFlagSplitPaneOpaqueExpandedPages = v58,
	FFlagSplitPaneFixClassicThemeHeader = v44,
	FFlagSplitPaneAvatarOnlyAlwaysExpanded = v51,
	FFlagSplitPaneProfileEditFillPane = v52,
	FFlagSplitPaneFullBleedEditProfile = v53,
	FFlagLuaAppDisablePlayableWhenLoadingForce = defineFastFlag47 and game:DefineFastFlag(
		"LuaAppDisablePlayableWhenLoadingForce",
		false
	),
	FFlagLuaAppFixDetailsPageThumbnailRenderInPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppFixDetailsPageThumbnailRenderInPhone"),
	FFlagLuaAppDesktopMediaGalleryTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppDesktopMediaGalleryTelemetry"),
	FFlagLuaAppHideEdpStoreForUnplayable = game:DefineFastFlag("LuaAppHideEdpStoreForUnplayable", false),
	FFlagLuaAppBlockedUnplayableError = game:DefineFastFlag("LuaAppBlockedUnplayableError", false),
	FFlagLuaAppEdpFixDefaultBanner = game:DefineFastFlag("LuaAppEdpFixDefaultBanner", false),
	FFlagLuaAppEdpMediaGalleryRedesign = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryRedesign"),
	FFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryRedesignIxp"),
	FFlagLuaAppPYMKSendUserSeenCollection = game:DefineFastFlag("LuaAppPYMKSendUserSeenCollection", false),
	FFlagPymkCarouselExtendProps = game:DefineFastFlag("PymkCarouselExtendProps", false),
	FFlagLuaAppUserSeenCollectionUnifiedFields = game:DefineFastFlag(
		"LuaAppUserSeenCollectionUnifiedFields",
		false
	),
	FFlagLuaAppHomeFriendsRemoveItemImpressions = game:DefineFastFlag(
		"LuaAppHomeFriendsRemoveItemImpressions",
		false
	),
	FIntUserSeenCollectionBatchTimeMs = game:DefineFastInt("UserSeenCollectionBatchTimeMs", 200),
	FFlagLuaAppSearchPeopleUnifiedSchemaFields = game:DefineFastFlag(
		"LuaAppSearchPeopleUnifiedSchemaFields",
		false
	),
	FFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryVideoPreview"),
	FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryVideoPreviewIxp"),
	FFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpConsoleMediaGalleryVideo"),
	FFlagLuaAppEdpConsoleMediaGalleryVideoMute = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpConsoleMediaGalleryVideoMute"),
	FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon"),
	FIntLuaAppEdpMediaGalleryItemVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLuaAppEdpMediaGalleryItemVisiblePercent"),
	FIntVideoPlaybackDetectorScanDebounceInMilliseconds = game:DefineFastInt(
		"VideoPlaybackDetectorScanDebounceInMilliseconds",
		1000
	),
	FIntLuaAppGameTileVideoDwellTimeInSec = game:DefineFastInt("LuaAppGameTileVideoDwellTimeInSec", 3),
	FIntLuaAppGameTileVideoVisiblePercent = game:DefineFastInt("LuaAppGameTileVideoVisiblePercent", 80),
	FIntLuaAppOneByTwoTileVideoVisiblePercent = game:DefineFastInt(
		"LuaAppOneByTwoTileVideoVisiblePercent",
		50
	),
	FFlagLuaAppGameTileNotInterestedDirectAction = game:DefineFastFlag(
		"LuaAppGameTileNotInterestedDirectAction",
		false
	),
	FFlagLuaAppGameTileDirectActionTelemetry = game:DefineFastFlag(
		"LuaAppGameTileDirectActionTelemetry2",
		false
	),
	FFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiGameTileFeedback"),
	FFlagLuaAppSduiGameTileInteractionFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiGameTileInteractionFeedback"),
	FFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiGameTileDirectAction"),
	FFlagSduiGameTileEnableHoverInVR = game:DefineFastFlag("SduiGameTileEnableHoverInVR", false),
	FFlagLuaAppGameTileSelectionVideoPlayback = game:DefineFastFlag(
		"LuaAppGameTileSelectionVideoPlayback",
		false
	),
	FFlagTraversalHistoryDiscoveryTelemetry = game:DefineFastFlag(
		"TraversalHistoryDiscoveryTelemetry",
		false
	),
	FFlagLuaAppTileVideoCandidateOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppTileVideoCandidateOnly"),
	FFlagLuaAppTileVideoKeepPlayingOnScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppTileVideoKeepPlayingOnScroll"),
	FFlagLuaAppEmphasisGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEmphasisGameTileVideo"),
	FFlagLuaAppSearchResultsPageGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSearchResultsPageGameTileVideo"),
	FFlagLuaAppVideoAutoplayFeedElection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppVideoAutoplayFeedElection"),
	FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback"),
	FFlagLuaAppSduiSponsoredOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiSponsoredOneByTwoTile"),
	FFlagLuaAppSduiSponsoredTwoByOneTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiSponsoredTwoByOneTile"),
	FFlagLuaAppVideoTileDisableActivation = game:DefineFastFlag("LuaAppVideoTileDisableActivation", false),
	FFlagLuaAppVideoTileHideCenterPlayButton = game:DefineFastFlag(
		"LuaAppVideoTileHideCenterPlayButton",
		false
	),
	FFlagLuaAppFixHiddenTileVideoCleanup = game:DefineFastFlag("LuaAppFixHiddenTileVideoCleanup", false),
	FFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHomeMomentVideoFallback"),
	FFlagLuaAppVideoLoadFailureFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppVideoLoadFailureFallback"),
	FFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppVideoPlayerTrimAndMusic"),
	FFlagLuaAppHomeMomentVideoPrecedence = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHomeMomentVideoPrecedence"),
	FFlagLuaAppEdpMomentVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMomentVideo"),
	FFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppDiscoveryMomentVideoTelemetry"),
	FFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryAutoAdvance"),
	FFlagFixNonVisibleEdpVideoPlayback = game:DefineFastFlag("FixNonVisibleEdpVideoPlayback", false),
	FFlagLuaAppEdpMediaGalleryPreloadImage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryPreloadImage"),
	FFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryFullScreen"),
	FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryRedesignTelemetry"),
	FStringLuaAppEdpAudioManufacturerDenyList = game:DefineFastString(
		"LuaAppEdpAudioManufacturerDenyList",
		"huawei,hwi"
	),
	FFlagLuaAppGameTileExtractGameDetailsCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppGameTileExtractGameDetailsCallback"),
	FFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppContinueSortInstantPlay"),
	FFlagLuaAppEnablePlayButtonThrottle = game:DefineFastFlag("LuaAppEnablePlayButtonThrottle", false),
	FFlagLuaAppFixLaunchGameSourceParam = game:DefineFastFlag("LuaAppFixLaunchGameSourceParam", false),
	FFlagSduiActiveFriendsFooterTreatment = game:DefineFastFlag("SduiActiveFriendsFooterTreatment", false),
	FFlagSduiGameTileFixFacePileZIndex = game:DefineFastFlag("SduiGameTileFixFacePileZIndex", false),
	FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch = game:DefineFastFlag(
		"SduiLaunchExperienceCheckPlayabilityBeforeLaunch",
		false
	),
	FFlagSduiUniverseItemConnectionsPlayed = game:DefineFastFlag("SduiUniverseItemConnectionsPlayed", false),
	FFlagLuaAppPlayButtonLoadingDurationTelemetry = game:DefineFastFlag(
		"LuaAppPlayButtonLoadingDurationTelemetry",
		false
	),
	FFlagLuaAppPlayLoadingClickTelemetryMobile = game:DefineFastFlag(
		"LuaAppPlayLoadingClickTelemetryMobile",
		false
	),
	FIntLuaAppPlayButtonSecondaryButtonGap = game:DefineFastInt("LuaAppPlayButtonSecondaryButtonGap", 8),
	FFlagLuaAppPlayButtonWizardCloseDelay = game:DefineFastFlag("LuaAppPlayButtonWizardCloseDelay", false) and game:GetFastFlag("LuaAppPlayButtonAmpAgeCheckFlow"),
	FIntLuaAppPlayButtonThrottleTimeSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLuaAppPlayButtonThrottleTimeSeconds"),
	FIntLuaAppPlayButtonWizardCloseDelayMs = game:DefineFastInt("LuaAppPlayButtonWizardCloseDelayMs", 4000),
	FIntSongDetailsRefreshIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntSongDetailsRefreshIntervalSeconds"),
	FIntLuaAppDelayImpressionsMaxUpdates = game:DefineFastInt("LuaAppDelayImpressionsMaxUpdates", 4),
	FIntGameGridFlexFeedItemTileNumPerFeed = game:DefineFastInt("GameGridFlexFeedItemTileNumPerFeed", 30),
	FIntLuaAppGameGridRevealMoreButtonGapPx = game:DefineFastInt("LuaAppGameGridRevealMoreButtonGapPx", 12),
	FFlagItemImpressionsAddGameMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagItemImpressionsAddGameMetadata"),
	FFlagUnifiedLoggingCoerceMetadataFieldValues = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedLoggingCoerceMetadataFieldValues"),
	FFlagLuaAppUnifyPlayButtonTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonTile"),
	FFlagLuaAppUnifyPlayButtonTileIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonTileIxp"),
	FFlagLuaAppUnifyPlayButtonMobileEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonMobileEdp"),
	FFlagLuaAppUnifyPlayButtonNonMobileEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonNonMobileEdp"),
	FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonAllSurfacesIxp"),
	FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = game:DefineFastFlag(
		"LuaAppMobileEdpPlayButtonPartialUnificationIXP",
		false
	),
	FFlagLuaAppJoinTextPlayableButton = game:DefineFastFlag("LuaAppJoinTextPlayableButton", false) or require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonAllSurfacesIxp"),
	FFlagLuaAppIconPlayButton = game:DefineFastFlag("LuaAppIconPlayButton", false) or require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonAllSurfacesIxp"),
	FFlagLuaAppPlayButtonLoadingSkeleton = game:DefineFastFlag("LuaAppPlayButtonLoadingSkeleton3", false) or require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppUnifyPlayButtonAllSurfacesIxp"),
	FFlagLuaAppDemoModePlayButtonTelemetry = game:DefineFastFlag(
		"LuaAppDemoModePlayButtonTelemetry2",
		false
	),
	FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability = game:DefineFastFlag(
		"LuaAppPlaytestTrustedFriendsRefetchPlayability",
		false
	),
	FFlagLuaAppPlayButtonPrivatePT = defineFastFlag87,
	FFlagLuaAppPlayButtonPrivatePTEnableSingleButton = v66,
	FFlagLuaAppPlayButtonPrivatePTEnableDualButton = v65,
	FFlagLuaAppPrivatePlaytestEarlyTesting = game:DefineFastFlag("LuaAppPrivatePlaytestEarlyTesting", false),
	FFlagLuaAppPrivatePlaytestWithoutBuildMode = game:DefineFastFlag(
		"LuaAppPrivatePlaytestWithoutBuildMode",
		false
	),
	FFlagLuaAppUseTokenHeightForPlayButton = game:DefineFastFlag("LuaAppUseTokenHeightForPlayButton", false),
	FFlagLuaAppTextOnlyPlayButton = game:DefineFastFlag("LuaAppTextOnlyPlayButton", false),
	FFlagLuaAppIconTextPlayButton = game:DefineFastFlag("LuaAppIconTextPlayButton", false),
	FFlagLuaAppUpdatePlayButtonText = game:DefineFastFlag("LuaAppUpdatePlayButtonText", false),
	FFlagLuaAppLogExposurePlayButtonUX = game:DefineFastFlag("LuaAppLogExposurePlayButtonUX", false),
	FFlagLuaAppPlayButtonOptOutFoundationButton = game:DefineFastFlag(
		"LuaAppPlayButtonOptOutFoundationButton",
		false
	),
	FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = game:DefineFastFlag(
		"LuaAppUnifiedPlayButtonSquadMenuDirection",
		false
	),
	FFlagLuaAppUsePrevalidatedVideoGamePlayability = game:DefineFastFlag(
		"LuaAppUsePrevalidatedVideoGamePlayability",
		false
	),
	FFlagLuaAppMigrateGameTileHoverFixes = game:DefineFastFlag("LuaAppMigrateGameTileHoverFixes", false),
	FFlagLuaAppGameViewTileBackgroundColorOverride = game:DefineFastFlag(
		"LuaAppGameViewTileBackgroundColorOverride",
		false
	),
	FFlagLuaAppScrollDetectorLifecycleHardening = game:DefineFastFlag(
		"LuaAppScrollDetectorLifecycleHardening",
		false
	),
	FStringLuaEnabledSduiTreatmentTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringLuaEnabledSduiTreatmentTypes"),
	FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = game:DefineFastFlag(
		"LuaAppMigrateGameTileActiveFriendsHydrationFix2",
		false
	),
	FFlagGameTileMigrateOffLegacyPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGameTileMigrateOffLegacyPresence"),
	FFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSongEdpCarouselIxp"),
	FFlagSongCarouselPropUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSongCarouselPropUpdate"),
	FFlagUpdateSongCarouselClipDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUpdateSongCarouselClipDefault"),
	FFlagLuaAppGenreRatingFooter = game:DefineFastFlag("LuaAppGenreRatingFooter", false),
	FFlagLuaAppEnableStratusStreamingTestOnly = game:DefineFastFlag(
		"LuaAppEnableStratusStreamingTestOnly",
		false
	),
	FFlagLuaAppStratusPassUniverseId = game:DefineFastFlag("LuaAppStratusPassUniverseId", false),
	FFlagLuaAppEnableStratusStreamingCheck = game:DefineFastFlag("LuaAppEnableStratusStreamingCheck", false) and game:GetEngineFeature("GameStreamingEnabledCheck"),
	FFlagLuaAppCloudClientPlayButtonOffer = game:DefineFastFlag("LuaAppCloudClientPlayButtonOffer", false) and game:GetEngineFeature("CloudClientOfferTypeApi"),
	FFlagInternalOnlyStratusBugReportEnabled = game:DefineFastFlag(
		"InternalOnlyStratusBugReportEnabled",
		false
	) and game:GetEngineFeature("StratusBugReport"),
	FFlagLuaAppStratusBugReportAfterConnect = game:DefineFastFlag(
		"LuaAppStratusBugReportAfterConnect",
		false
	) and game:GetEngineFeature("StratusBugReport"),
	FFlagLuaAppVideoServerDisplayWakeLock = game:DefineFastFlag("LuaAppVideoServerDisplayWakeLock", false) and game:GetEngineFeature("EnableDisplayWakeLock"),
	FFlagLuaAppWireAudioDeviceInputOnRequest = game:GetEngineFeature("RealtimeMediaRequestAudioInput"),
	FFlagUseAudioDeviceInputAddedSignal = game:DefineFastFlag("UseAudioDeviceInputAddedSignal", false) and game:GetEngineFeature("AudioDeviceInputAddedApiEnabled"),
	FFlagLuaAppUseExperienceLogoTrayInGameInfoList = game:DefineFastFlag(
		"LuaAppUseExperienceLogoTrayInGameInfoList",
		false
	),
	FFlagLuaAppSduiUpdateUserSettingsAction = game:DefineFastFlag(
		"LuaAppSduiUpdateUserSettingsAction",
		false
	),
	FFlagMoveSduiUpdateUserSettingsToAccountManagement = game:DefineFastFlag(
		"MoveSduiUpdateUserSettingsToAccountManagement",
		false
	),
	FFlagSduiOpenAccountSettingsAction = game:DefineFastFlag("SduiOpenAccountSettingsAction", false),
	FFlagLuaAppEnableHeroUnitV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableHeroUnitV2"),
	FFlagLuaAppFixSmallScreenFooterStatsOverlap = game:DefineFastFlag(
		"LuaAppFixSmallScreenFooterStatsOverlap",
		false
	),
	FFlagLuaAppNarrowTileHideRating = game:DefineFastFlag("LuaAppNarrowTileHideRating2", false),
	FFlagLuaAppNarrowTileHidePlayerCount = game:DefineFastFlag("LuaAppNarrowTileHidePlayerCount2", false),
	FFlagLuaAppPlayableUxTreatment = game:DefineFastFlag("LuaAppPlayableUxTreatment", false),
	FFlagLuaAppMigrateGameTileFixConsoleMetadataText = game:DefineFastFlag(
		"LuaAppMigrateGameTileFixConsoleMetadataText",
		false
	),
	FFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpNonSduiBuildAttribution"),
	FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpBackendV2HydrateLegacyIxp"),
	FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpBackendV2SduiInterleaveDefault"),
	FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpBackendV2SduiInterleaveIxp"),
	FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable"),
	FFlagLuaAppExtendPlayWithRewardPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppExtendPlayWithRewardPeekView"),
	FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = game:DefineFastFlag(
		"LuaAppEdpBackendV2LogFetchSuccessAndFailure2",
		false
	),
	FFlagLuaAppEdpBackendV2LogUniverseIdForEvents = game:DefineFastFlag(
		"LuaAppEdpBackendV2LogUniverseIdForEvents",
		false
	),
	FFlagLuaAppEdpBackendV2AddUserVote = game:DefineFastFlag("LuaAppEdpBackendV2AddUserVote", false),
	FFlagLuaAppUpdateContentDescriptorsTranslation = game:DefineFastFlag(
		"LuaAppUpdateContentDescriptorsTranslation",
		false
	),
	FFlagLuaAppFixGamesListSortTokenExpiringTime = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppFixGamesListSortTokenExpiringTime"),
	FFlagLuaAppSupportHomeBackToTop = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSupportHomeBackToTop"),
	FFlagLuaAppHomeGameCarouselRemount = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHomeGameCarouselRemount"),
	FFlagLuaAppLogGameAttributionError = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppLogGameAttributionError"),
	FFlagLuaAppGameDetailsAttributionFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppGameDetailsAttributionFix"),
	FFlagLuaAppFixInlineSignalsReactPattern = game:DefineFastFlag(
		"LuaAppFixInlineSignalsReactPattern",
		false
	),
	FFlagLuaAppLayoutParamsInContext = defineFastFlag19,
	FFlagLuaAppSduiSeeAllLayoutParamsFix = game:DefineFastFlag("LuaAppSduiSeeAllLayoutParamsFix", false),
	FFlagLuaAppRfySignalApportioningIxp = v8,
	FFlagLuaAppRfySignalApportioning = defineFastFlag19 and (game:DefineFastFlag("LuaAppRfySignalApportioning4", false) or v8),
	FFlagLuaAppAddRequestIdToRfySignalApportioning = game:DefineFastFlag(
		"LuaAppAddRequestIdToRfySignalApportioning",
		false
	),
	FFlagLuaAppFixHomeGridPlaceholderFlowIssues = game:DefineFastFlag(
		"LuaAppFixHomeGridPlaceholderFlowIssues",
		false
	),
	FFlagLuaAppEdpFetchLatencyTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpFetchLatencyTracking"),
	FFlagLuaAppAddUniverseIdToGameDetailsEvents = game:DefineFastFlag(
		"LuaAppAddUniverseIdToGameDetailsEvents",
		false
	),
	FFlagLuaAppGameDetailsEventsReportInvalidArgs = game:DefineFastFlag(
		"LuaAppGameDetailsEventsReportInvalidArgs",
		false
	),
	FFlagLuaAppAddUniverseIdToEngagementEvents = game:DefineFastFlag(
		"LuaAppAddUniverseIdToEngagementEvents2",
		false
	),
	FFlagLuaAppInExperienceDetailsPrompt = game:DefineFastFlag("LuaAppInExperienceDetailsPrompt3", false) and game:GetEngineFeature("ExperienceDetailsPrompt"),
	FFlagLuaAppIedpOverlayAndNavigationFix = game:DefineFastFlag("LuaAppIedpOverlayAndNavigationFix", false) and game:GetFastFlag("LuaAppInExperienceDetailsPrompt3"),
	FFlagLuaAppIedpSendPoints = game:DefineFastFlag("LuaAppIedpSendPoints", false) and game:GetFastFlag("LuaAppInExperienceDetailsPrompt3"),
	FFlagLuaAppIedpFixPlayButton = game:DefineFastFlag("LuaAppIedpFixPlayButton", false),
	FFlagLuaAppAlignHeroUnitBottomRowCtaButton = game:DefineFastFlag(
		"LuaAppAlignHeroUnitBottomRowCtaButton",
		false
	),
	FFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableReportExperience"),
	FFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSuppressVideoDetectorDuringScroll"),
	FFlagLuaAppVideoViewportTargetedWinnerSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppVideoViewportTargetedWinnerSubscription"),
	FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll"),
	FFlagLuaAppEnableNxMRoduxApportioning = module,
	FFlagLuaAppEnableNxMApportioningExtraLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableNxMApportioningExtraLogging"),
	FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableOneByTwoTileFunnelTelemetry"),
	FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui"),
	FFlagLuaAppAddHasOneByTwoField = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppAddHasOneByTwoField"),
	FFlagLuaAppAddHasOneByTwoFieldSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppAddHasOneByTwoFieldSdui"),
	FFlagLuaAppSduiHomeFeedStats = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiHomeFeedStats"),
	FFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppOneByTwoHoverIdleAutoplay"),
	FFlagLuaAppHoverIdleAutoplayDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHoverIdleAutoplayDuringScroll"),
	FFlagLuaAppSponsoredGamePreviewVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSponsoredGamePreviewVideo"),
	FFlagLuaAppAdClickoutDeeplink = game:DefineFastFlag("LuaAppAdClickoutDeeplink", false),
	FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding = game:DefineFastFlag(
		"LuaAppRemoveOmniFeedDividersAndExtraPadding",
		false
	),
	FFlagRobloxPlusUpsellRefreshOnComplete = game:DefineFastFlag("RobloxPlusUpsellRefreshOnComplete", false) and defineFastFlag34,
	FFlagSduiShowToastAction = game:DefineFastFlag("SduiShowToastAction_v2", false),
	FFlagLuaAppSduiVerificationUpsellActions = game:DefineFastFlag(
		"LuaAppSduiVerificationUpsellActions2",
		false
	),
	FFlagLuaAppDismissUnlockUpsell = game:DefineFastFlag("LuaAppDismissUnlockUpsell", false),
	FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight = game:DefineFastFlag(
		"SduiAgeCheckUpsellRaisePeekViewBriefHeight",
		false
	),
	FStringLuaAppSortsWithDividers = game:DefineFastString(
		"LuaAppSortsWithDividers",
		"200000000, 200000001"
	),
	FFlagLuaAppUseSortsWithDividersFString = game:DefineFastFlag(
		"LuaAppUseSortsWithDividersFString2",
		false
	),
	FFlagUseOmniFeedDividerOverrides = game:DefineFastFlag("UseOmniFeedDividerOverrides", false),
	FIntOmniFeedDividerHeightOverride = game:DefineFastInt("OmniFeedDividerHeightOverride", -1),
	FIntOmniFeedDividerPaddingOverride = game:DefineFastInt("OmniFeedDividerPaddingOverride", -1),
	FFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppChartsFilterOptionTextTag"),
	FFlagEnableContextFeaturesForOmniRecommendations = game:DefineFastFlag(
		"EnableContextFeaturesForOmniRecommendations",
		false
	),
	FFlagSduiAllowNoConfigsBuilt = game:DefineFastFlag("SduiAllowNoConfigsBuilt", false),
	FFlagLuaAppWizardContainerBypassNavigationLock = game:DefineFastFlag(
		"LuaAppWizardContainerBypassNavigationLock",
		false
	),
	FFlagSduiTileThumbnailPadding = game:DefineFastFlag("SduiTileThumbnailPadding", false),
	FFlagSduiBannerComponent = game:DefineFastFlag("SduiBannerComponent", false),
	FFlagSduiSheetComponent = game:DefineFastFlag("SduiSheetComponent2", false),
	FFlagSduiSystemBannerComponent = game:DefineFastFlag("SduiSystemBannerComponent", false),
	FFlagSduiBannerContextComponent = game:DefineFastFlag("SduiBannerContextComponent", false),
	FFlagSduiViewportVisibilityComponent = game:DefineFastFlag("SduiViewportVisibilityComponent", false),
	FFlagSduiReactionsComponent = game:DefineFastFlag("SduiReactionsComponent", false),
	FFlagSduiInteractableTileWrapper = game:DefineFastFlag("SduiInteractableTileWrapper", false),
	FFlagSduiSurfaceBannerScrollAwaySticky = game:DefineFastFlag("SduiSurfaceBannerScrollAwaySticky", false),
	FFlagSduiSurfaceBannerAlwaysMounted = game:DefineFastFlag("SduiSurfaceBannerAlwaysMounted", false),
	FFlagEnableHomepagePromptsForModalsAndBanners = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableHomepagePromptsForModalsAndBanners"),
	FFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsHandlerEnabled"),
	FFlagEdpGameLeavePromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEdpGameLeavePromptsHandlerEnabled"),
	FFlagEdpOpenPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEdpOpenPromptsHandlerEnabled"),
	FFlagChatPushUpsellPromptsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChatPushUpsellPromptsEnabled"),
	FStringChatPushUpsellLegacyCustomPromptName = game:DefineFastString(
		"ChatPushUpsellLegacyCustomPromptName",
		"PushNotificationsUpsellChatLegacy"
	),
	FFlagNotificationStreamPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagNotificationStreamPromptsHandlerEnabled"),
	FFlagPromptsEdpOpenReplaceOnFetch = game:DefineFastFlag("PromptsEdpOpenReplaceOnFetch", false),
	FFlagEdpGameLeavePromptsPassPinShortcutAvailable = game:DefineFastFlag(
		"EdpGameLeavePromptsPassPinShortcutAvailable",
		false
	),
	FFlagEdpGameLeavePromptsPassCustomAppEntryPointAutoJoin = game:DefineFastFlag(
		"EdpGameLeavePromptsPassCustomAppEntryPointAutoJoin",
		false
	),
	FFlagEdpGameLeavePromptsPassIsRecentInstall = game:DefineFastFlag(
		"EdpGameLeavePromptsPassIsRecentInstall",
		false
	),
	FIntEdpGameLeavePromptsRecentInstallWindowDays = game:DefineFastInt(
		"EdpGameLeavePromptsRecentInstallWindowDays",
		7
	),
	FIntEdpGameLeavePromptsFirstLaunchMaxEntries = game:DefineFastInt(
		"EdpGameLeavePromptsFirstLaunchMaxEntries",
		50
	),
	FFlagPromptsHandlerCoachmarkEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsHandlerCoachmarkEnabled"),
	FFlagPromptsCoachmarkImpressionOnShow = game:DefineFastFlag("PromptsCoachmarkImpressionOnShow", false),
	FFlagPromptsImpressionUsesTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsImpressionUsesTitle"),
	FFlagHomePagePromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHomePagePromptsHandlerEnabled"),
	FFlagHomePromptsHandlerRestrictPromptStyles = game:DefineFastFlag(
		"HomePromptsHandlerRestrictPromptStyles",
		false
	),
	FStringHomePromptsHandlerPromptStyles = game:DefineFastString(
		"HomePromptsHandlerPromptStyles",
		"Modal,Card,Banner,Tooltip,CardContainer,Coachmark,GlobalBanner,SurfaceBanner,SystemBanner,Deferred"
	),
	FFlagHomepagePromptsHandlerPassClientAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHomepagePromptsHandlerPassClientAttributes"),
	FFlagPushNotificationsUpsellPassClientAttributesToPrompts = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPushNotificationsUpsellPassClientAttributesToPrompts"),
	FFlagPromptsHandlerFetchOncePerSession = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsHandlerFetchOncePerSession"),
	FIntPromptsHandlerSessionTimeoutMs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntPromptsHandlerSessionTimeoutMs"),
	FFlagPushNotificationsUpsellHomePromptsExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPushNotificationsUpsellHomePromptsExperiment"),
	FStringPushNotificationsUpsellHomePromptsExperimentLayer = game:DefineFastString(
		"PushNotificationsUpsellHomePromptsExperimentLayer",
		"Notifications.Push.NotificationPrompt"
	),
	FStringPushNotificationsUpsellHomePromptsExperimentParameter = game:DefineFastString(
		"PushNotificationsUpsellHomePromptsExperimentParameter",
		"variantName"
	),
	FStringPushNotificationsUpsellHomePromptsControlValue = game:DefineFastString(
		"PushNotificationsUpsellHomePromptsControlValue",
		"control"
	),
	FStringPushNotificationsUpsellHomeCustomPromptName = game:DefineFastString(
		"PushNotificationsUpsellHomeCustomPromptName",
		"PushNotificationsUpsellHome"
	),
	FFlagHomepagePromptsPaddingFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHomepagePromptsPaddingFix"),
	FFlagDisableHomePageUpsellCardFeedItem = game:DefineFastFlag("DisableHomePageUpsellCardFeedItem", false),
	FFlagSduiDevStoreSeeAllSupport = game:DefineFastFlag("SduiDevStoreSeeAllSupportDev2", false),
	FFlagSduiGameItemsComponent = game:DefineFastFlag("SduiGameItemsComponent", false),
	FFlagSduiListComponents = game:DefineFastFlag("SduiListComponents", false),
	FFlagSduiAccordionComponent = game:DefineFastFlag("SduiAccordionComponent", false),
	FFlagSduiExpandableListItem = game:DefineFastFlag("SduiExpandableListItem", false),
	FFlagSduiContentRowTrailingHover = game:DefineFastFlag("SduiContentRowTrailingHover2", false),
	FFlagSduiSettingsFocusRef = game:DefineFastFlag("SduiSettingsFocusRef", false),
	FFlagLuaAppSduiSearchAutocompleteSuggestionComponent = defineFastFlag30,
	FFlagLuaAppSduiSearchAutocomplete = game:DefineFastFlag("LuaAppSduiSearchAutocomplete", false) and defineFastFlag30,
	FFlagSduiSupportRatingNoPercent = game:DefineFastFlag("SduiSupportRatingNoPercent", false),
	FFlagEnableHomeGameItemOwnershipUpdate = game:DefineFastFlag("EnableHomeGameItemOwnershipUpdate", false),
	FFlagEnableSearchGameItemOwnershipUpdate = game:DefineFastFlag(
		"EnableSearchGameItemOwnershipUpdate",
		false
	),
	FFlagEnableEdpPreviewPurchaseSurface = game:DefineFastFlag("EnableEdpPreviewPurchaseSurface2", false),
	FFlagSduiLocalFeedFilter = game:DefineFastFlag("SduiLocalFeedFilter", false),
	FFlagUserLibrary = game:DefineFastFlag("UserLibrary", false),
	FFlagLuaAppSduiHomeUserInfo = game:DefineFastFlag("LuaAppSduiHomeUserInfo", false),
	FFlagFixSduiEdpTtiPeekCategory = game:DefineFastFlag("FixSduiEdpTtiPeekCategory", false),
	FFlagLuaAppDevStoreSeeAllSduiEnabled = game:DefineFastFlag("LuaAppDevStoreSeeAllSduiEnabled", false),
	FFlagSduiDismissPromptAction = defineFastFlag34,
	FFlagSduiMilestoneCountActions = defineFastFlag35,
	FFlagLuaAppSduiMovePromptsActions = defineFastFlag36,
	FFlagSduiDismissPromptPageScope = v13,
	FFlagSduiNavigate = game:DefineFastFlag("SduiNavigate", false),
	FFlagSduiHostedDependencies = defineFastFlag2,
	FFlagInitializeSduiForInExperience = v5,
	FFlagSduiDefineUnreadRuntimeFlags = v6,
	FFlagSduiComponentsUseFoundationTokens = game:DefineFastFlag("SduiComponentsUseFoundationTokens", false),
	FFlagOptionalNavigation = game:DefineFastFlag("OptionalNavigation", false),
	FFlagInitializeSduiForApp = game:DefineFastFlag("InitializeSduiForApp", false),
	FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate = game:DefineFastFlag(
		"LuaAppDevStoreSeeAllForceRefreshOnNavigate",
		false
	),
	FFlagEnableExperienceDetailsBottomSheet = defineFastFlag27,
	FFlagEnableExperienceDetailsBottomSheetTopBar = game:DefineFastFlag(
		"EnableExperienceDetailsBottomSheetTopBar",
		false
	) and defineFastFlag27,
	FFlagEnableMotionJitterMetric = game:DefineFastFlag("EnableMotionJitterMetric2", false),
	FFlagLuaAppEdpBottomSheetPeekViewEvents = game:DefineFastFlag(
		"LuaAppEdpBottomSheetPeekViewEvents2",
		false
	),
	FFlagLuaAppDevStoreSeeAllSduiLogExposure = game:DefineFastFlag(
		"LuaAppDevStoreSeeAllSduiLogExposure",
		false
	),
	FFlagLuaAppDevStoreSeeAllAdvertiseCapabilities = game:DefineFastFlag(
		"LuaAppDevStoreSeeAllAdvertiseCapabilities",
		false
	),
	FFlagSduiGameTileUseFooterComponentAsDefault = game:DefineFastFlag(
		"SduiGameTileUseFooterComponentAsDefault",
		false
	),
	FFlagLuaAppSduiGameTileFooterTrailingComponent = game:DefineFastFlag(
		"LuaAppSduiGameTileFooterTrailingComponent",
		false
	),
	FFlagSduiBadgeShape = game:DefineFastFlag("SduiBadgeShape", false),
	FStringLuaAppDevStoreSeeAllSduiIxpLayer = game:DefineFastString(
		"LuaAppDevStoreSeeAllSduiIxpLayer",
		"PlayerApp.DevStoreSeeAllPage.Exposure"
	),
	FFlagSduiRevealTextComponentEnabled = game:DefineFastFlag("SduiRevealTextComponentEnabled", false),
	FFlagSduiTooltipComponentEnabled = game:DefineFastFlag("SduiTooltipComponentEnabled", false),
	FFlagSduiShimmerTextComponentEnabled = game:DefineFastFlag("SduiShimmerTextComponentEnabled", false),
	FFlagSduiCustomFormEnabled = game:DefineFastFlag("SduiCustomFormEnabled", false),
	FFlagSduiMarkdownTextComponentEnabled = game:DefineFastFlag("SduiMarkdownTextComponentEnabled", false),
	FFlagSduiMarkdownRobloxProfile = game:DefineFastFlag("SduiMarkdownRobloxProfile", false),
	FFlagEnableGroupsSdui = game:DefineFastFlag("EnableGroupsSdui", false),
	FFlagEnableFoundationSdui = game:DefineFastFlag("EnableFoundationSdui", false),
	GetFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableUnifiedWebViews"),
	GetFFlagEnableVRWrapperTransparency = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVRWrapperTransparency"),
	getFFlagOffNetworkAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagOffNetworkAnalytics"),
	getFFlagSoothsayerCheckForContactImporter = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagSoothsayerCheckForContactImporter"),
	getFFlagMigrateSocialNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagMigrateSocialNetworking"),
	GetFFlagShareGetPlatformTargetImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagShareGetPlatformTargetImpl"),
	isNewFriendsEndpointsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/isNewFriendsEndpointsEnabled"),
	GetFFlagHideConnectPageWebViewItemsForVR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagHideConnectPageWebViewItemsForVR"),
	GetFFlagEnableVRChartsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVRChartsTab"),
	GetFFlagPhoneVerificationWebviewShouldBeFullscreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPhoneVerificationWebviewShouldBeFullscreen"),
	getFFlagDebugLuaAppAlwaysUseGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagDebugLuaAppAlwaysUseGamepad"),
	FFlagVCWasDisabledFromMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVCWasDisabledFromMenuOpen"),
	GetFFlagDisableCDLQrCodeForMaquettes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDisableCDLQrCodeForMaquettes"),
	GetFFlagUseEnablePremiumUserFeaturesAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagUseEnablePremiumUserFeaturesAppPolicy"),
	GetFFlagInviteListRerank = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagInviteListRerank"),
	getFFlagUserProfilesDataLoaderEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagUserProfilesDataLoaderEnabled"),
	GetFFlagLuaIdentityGetPhoneNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagLuaIdentityGetPhoneNumber"),
	GetFFlagLuaIdentityGetSMSOTP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagLuaIdentityGetSMSOTP"),
	GetFFlagLuaIdentityVerifySNA = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagLuaIdentityVerifySNA"),
	GetFFlagExpDetailsUseSelectionBumpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagExpDetailsUseSelectionBumpers"),
	GetFFlagEnableNotApprovedCheckBoxTextABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableNotApprovedCheckBoxTextABTest"),
	GetFFlagUseCommunitiesTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagUseCommunitiesTranslation"),
	GetFFlagEnableNotApprovedForeshadowingConsequenceABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableNotApprovedForeshadowingConsequenceABTest"),
	GetFFlagEnablePlatformEvidence = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePlatformEvidence"),
	GetFIntPlatformEvidenceRolloutPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntPlatformEvidenceRolloutPercent"),
	GetFFlagLuaAppEnableDesktopDualLoginABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableDesktopDualLoginABTest"),
	GetFFlagEnableSocialContextToast = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSocialContextToast"),
	GetFFlagGameSettingsCameraModeFixEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGameSettingsCameraModeFixEnabled"),
	GetFFlagEnableMaquettesShortLinkCDLInstructions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableMaquettesShortLinkCDLInstructions"),
	GetFFlagHideContextualButtonBasedOnStateForVR = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagHideContextualButtonBasedOnStateForVR"),
	GetFFlagEnableAccessBlockAtAppContainerLevel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAccessBlockAtAppContainerLevel"),
	GetFFlagEnableShortLinkCodeForVRCDL = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableShortLinkCodeForVRCDL"),
	GetFFlagSelfViewVisibilityFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSelfViewVisibilityFix"),
	GetFFlagSelfViewCameraSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSelfViewCameraSettings"),
	GetFFlagSuggestedCalleeBugFixEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSuggestedCalleeBugFixEnabled"),
	GetFFlagDSAIllegalContentReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDSAIllegalContentReporting"),
	GetFFlagDSAConsequenceTransparency = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDSAConsequenceTransparency"),
	GetFFlagDSALuaGeoGateBEDUIDevMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDSALuaGeoGateBEDUIDevMode"),
	GetFFlagDSAVRSkipFrontendGeoCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDSAVRSkipFrontendGeoCheck"),
	GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds"),
	FFlagPeekViewFixBriefHeightLayoutRace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPeekViewFixBriefHeightLayoutRace"),
	GetFFlagPreventSuperBriefPeekViewClose = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPreventSuperBriefPeekViewClose"),
	FFlagCleanupTenFootUiPaddingAndAnalytics = game:DefineFastFlag(
		"CleanupTenFootUiPaddingAndAnalytics",
		false
	),
	GetFFlagTenFootUiSupportSortHeaderTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagTenFootUiSupportSortHeaderTooltip"),
	GetFFlagLuaAppFixSelectionCursor = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppFixSelectionCursor"),
	GetFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableTextFieldContentType"),
	GetFFlagEnableAuthStatefulTextInputUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAuthStatefulTextInputUpdates"),
	GetFFlagAuthBirthdayBarFoundationColors = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAuthBirthdayBarFoundationColors"),
	GetFFlagUseUpdatedVNGAgreementsWorkflow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagUseUpdatedVNGAgreementsWorkflow"),
	FFlagVngLogoutGlobalAppSessionsOnConversion = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVngLogoutGlobalAppSessionsOnConversion"),
	GetFStringVNGWebshopUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringVNGWebshopUrl"),
	FFlagPartyVoiceBlockSync = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPartyVoiceBlockSync"),
	GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty"),
	FFlagStandardizeSafetyIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagStandardizeSafetyIcon"),
	GetFFlagOpenVngTosForVngRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagOpenVngTosForVngRobuxUpsell"),
	GetFStringVNGTosUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringVNGTosUrl"),
	GetFFlagEnableCrossExpVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCrossExpVoice"),
	FIntPartyVoiceUndeafenDelayMS = game:DefineFastInt("PartyVoiceUndeafenDelayMS", 0),
	GetFFlagEnableCrossExperienceVoiceCaptureMute = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCrossExperienceVoiceCaptureMute"),
	getFFlagJoinCrossExpVoiceWithPartyId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagJoinCrossExpVoiceWithPartyId"),
	getFFlagEnableCrossExpVoiceMemoryCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/getFFlagEnableCrossExpVoiceMemoryCheck"),
	GetFFlagEnableAndroidWidgetsLuaIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAndroidWidgetsLuaIXP"),
	GetFFlagEnableIOSUIRefactorLuaIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableIOSUIRefactorLuaIXP"),
	GetFIntPeekViewTransitionDelayTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntPeekViewTransitionDelayTiming"),
	FFlagLuaAppHomeVngAppUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppHomeVngAppUpsell"),
	FFlagVngAppUpsellPcLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVngAppUpsellPcLayout"),
	FFlagEnableDeactivatedUserReactivation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableDeactivatedUserReactivation"),
	GetFFlagEnableCrossDeviceLoginUsingQRCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCrossDeviceLoginUsingQRCodes"),
	GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin"),
	GetFFlagEnableLoginAccountSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableLoginAccountSelector"),
	GetFFlagEnableContinueRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableContinueRecovery"),
	GetFFlagEnableLuafiedRecoveryFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableLuafiedRecoveryFlow"),
	GetFFlagEnableAutoLoginAfterRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAutoLoginAfterRecovery"),
	GetFFlagEnableSavePasswordAfterRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSavePasswordAfterRecovery"),
	GetFFlagEnableIosAuthServiceLuaIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableIosAuthServiceLuaIXP"),
	GetFIntAccountRecoverySecondsBetweenResends = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntAccountRecoverySecondsBetweenResends"),
	FFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLuaAccountSwitch"),
	FFlagUseGenericAccountSwitchSignOutCopy = game:DefineFastFlag(
		"UseGenericAccountSwitchSignOutCopy",
		false
	),
	GetFFlagShowInvoluntarilySignedOutAccounts = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagShowInvoluntarilySignedOutAccounts"),
	GetFIntAccountSwitcherAccountLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntAccountSwitcherAccountLimit"),
	GetFFlagEnableAccountSwitcherUncheckedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAccountSwitcherUncheckedBadge"),
	FFlagEnableAccountSwitcherExternalIdentityButtons = game:DefineFastFlag(
		"EnableAccountSwitcherExternalIdentityButtons",
		false
	),
	FFlagAddMenuNavigationToggleDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddMenuNavigationToggleDialog"),
	FFlagLuaEnableDidSwitchAccount = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaEnableDidSwitchAccount"),
	FFlagAccountSwitchRelaunchFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAccountSwitchRelaunchFallback"),
	GetFIntAccountSwitchRelaunchFallbackSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntAccountSwitchRelaunchFallbackSeconds"),
	GetFFlagEnableVoiceSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableVoiceSignal"),
	GetFFlagVoiceChatClientRewriteMasterLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagVoiceChatClientRewriteMasterLua"),
	GetFFlagEnableGenericTwoFAMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableGenericTwoFAMessage"),
	GetFStringVNGDownloadNowUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringVNGDownloadNowUrl"),
	GetFFlagEnableAuthsecImageUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAuthsecImageUpdate"),
	FFlagLuafiedWechatQQLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuafiedWechatQQLogin"),
	FFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateSaveOutfitPromptFromRoactGamepad"),
	FFlagAXMigrateAdjustAccessoryViewToFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateAdjustAccessoryViewToFocusNavigation"),
	FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation"),
	FFlagAXMigrateLookDetailsPeekViewToFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXMigrateLookDetailsPeekViewToFocusNavigation"),
	GetFFlagLuaEnableShowUpsellMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaEnableShowUpsellMethod"),
	GetFFlagLuaAppEnableAndroidPushUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableAndroidPushUpsell"),
	GetFStringVoiceUpsellLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringVoiceUpsellLayer"),
	GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints"),
	GetFFlagShowDevicePermissionsModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagShowDevicePermissionsModal"),
	GetFFlagDisplayServerChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDisplayServerChannel"),
	FFlagShowConfirmationScreenForOOAP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowConfirmationScreenForOOAP"),
	GetFFlagPackagifySettingsShowSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPackagifySettingsShowSignal"),
	GetFFlagNotificationModalSetMenuIsOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagNotificationModalSetMenuIsOpen"),
	FFlagEnableLuaLogReporterMultipleLogs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLuaLogReporterMultipleLogs"),
	FFlagLowCogsBannerExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLowCogsBannerExperiment"),
	FFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableTopSongsSort"),
	GetFStringTopSongsSortExploreApiPageType = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringTopSongsSortExploreApiPageType"),
	FFlagSquadLaunchExperienceMobileFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSquadLaunchExperienceMobileFix"),
	FFlagLuaAppGameImpressionsMobileAdsId = game:DefineFastFlag("LuaAppGameImpressionsMobileAdsId", false),
	FFlagLuaAppGameImpressionsAddUnifiedFields = game:DefineFastFlag(
		"LuaAppGameImpressionsAddUnifiedFields",
		false
	),
	FFlagLuaAppSduiGameDwell = game:DefineFastFlag("LuaAppSduiGameDwell", false),
	FFlagLuaAppAddAnalyticsDataToSeeAllImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppAddAnalyticsDataToSeeAllImpressions"),
	FFlagLuaAppGameDetailEventMobileAdsId = game:DefineFastFlag("LuaAppGameDetailEventMobileAdsId", false),
	FFlagLuaAppSduiPassSortSubId = game:DefineFastFlag("LuaAppSduiPassSortSubId", false),
	FFlagSduiForwardAnalyticsDataToGameClick = game:DefineFastFlag(
		"SduiForwardAnalyticsDataToGameClick",
		false
	),
	FFlagSduiFixSearchTelemetry = game:DefineFastFlag("SduiFixSearchTelemetry", false),
	FFlagLuaAppGamePlayIntentEventMobileAdsId = game:DefineFastFlag(
		"LuaAppGamePlayIntentEventMobileAdsId",
		false
	),
	FFlagAddAbuseReportOffsetForLandscape = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddAbuseReportOffsetForLandscape"),
	FFlagReplacePlayerIconRoduxWithSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagReplacePlayerIconRoduxWithSignal"),
	FFlagEnableInExperienceAvatarSwitcher = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInExperienceAvatarSwitcher"),
	FFlagChromeWindowSignalConstraintsToggle = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeWindowSignalConstraintsToggle"),
	FFlagRemoveAvatarSwitcherIfUnsupported = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveAvatarSwitcherIfUnsupported"),
	FFlagAvatarWorkshopReplacesAvatarSwitcher = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAvatarWorkshopReplacesAvatarSwitcher"),
	FFlagLuaAppsServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppsServerTriggeredModals"),
	FFlagEnableSduiV2HomepagePrompts = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSduiV2HomepagePrompts"),
	FFlagAXEnableHomeTryOnComplexView = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXEnableHomeTryOnComplexView"),
	FFlagAXFixPurchaseSurfaceLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixPurchaseSurfaceLogging"),
	FFlagAXOpenAppItemDetailsMountAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXOpenAppItemDetailsMountAnimation"),
	FFlagAXFixClickItemDetailsSurfaceLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixClickItemDetailsSurfaceLogging"),
	FFlagAXBackgroundsInAvatarThumbnails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXBackgroundsInAvatarThumbnails"),
	FFlagAXBackgroundsInAvatarBustThumbnails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXBackgroundsInAvatarBustThumbnails"),
	FFlagAXBackgroundsInHeadshotThumbnails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXBackgroundsInHeadshotThumbnails"),
	FFlagAXBackgroundsInOutfitThumbnails = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXBackgroundsInOutfitThumbnails"),
	GetFFlagProfileFrameThumbnailEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagProfileFrameThumbnailEnabled"),
	FFlagPlayerListFixLeaderstatsStacking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlayerListFixLeaderstatsStacking"),
	FFlagFontFacePlayerList = game:DefineFastFlag("FontFacePlayerList", false),
	FFlagRenameRespawnConfirmationPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRenameRespawnConfirmationPage"),
	FFlagRenameHelpToControls = game:DefineFastFlag("RenameHelpToControls", false),
	FFlagFixMoreSubMenuTitleFlash = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixMoreSubMenuTitleFlash"),
	FFlagEnableHeaderBarButtonsUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableHeaderBarButtonsUpdate"),
	FFlagEnableAndroidTvAppPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAndroidTvAppPolicies"),
	FFlagUsesCancelSearchAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUsesCancelSearchAppPolicy"),
	FFlagFixAppNavContainerShortcutBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixAppNavContainerShortcutBarHeight"),
	FFlagEnableStickyShortcutBarOnAllPlatforms = game:DefineFastFlag(
		"EnableStickyShortcutBarOnAllPlatforms",
		false
	),
	FFlagUnifyShortcutBarUnifiedIXPExposure = game:DefineFastFlag(
		"UnifyShortcutBarUnifiedIXPExposure",
		false
	),
	FFlagUnifyShortcutBarQA = game:DefineFastFlag("UnifyShortcutBarQA", false),
	FFlagUnifyShortcutBarFixImpressions = game:DefineFastFlag("UnifyShortcutBarFixImpressions", false),
	FFlagGamepadIconSupportCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagGamepadIconSupportCheck"),
	FFlagAllowAmpV2FeatureAccessCall = game:DefineFastFlag("AllowAmpV2FeatureAccessCall", false),
	FFlagCTAChangeMorePageFlyoutButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCTAChangeMorePageFlyoutButtonText"),
	FFlagSendLogOutClickTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSendLogOutClickTelemetry"),
	FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled"),
	GetFFlagFixUsernameValidationAlreadyInUse = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixUsernameValidationAlreadyInUse"),
	GetFFlagFixUsernameValidationBackendCriteria = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixUsernameValidationBackendCriteria"),
	FFlagAllowCurrentUsernameOnSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAllowCurrentUsernameOnSignup"),
	GetFFlagPasswordErrorSimple = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPasswordErrorSimple"),
	GetFStringAuthenticationErrorCode = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringAuthenticationErrorCode"),
	GetFStringAuthenticationErrorCodeAlternative = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringAuthenticationErrorCodeAlternative"),
	GetFFlagTriggerLogoutOnAuthErrorCode = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagTriggerLogoutOnAuthErrorCode"),
	GetFFlagEnableReferredPlayerJoinRemoteEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableReferredPlayerJoinRemoteEvent"),
	GetFFlagEnableReferredPlayerJoinRemoteEventForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableReferredPlayerJoinRemoteEventForAll"),
	GetFIntMaxReferredPlayerJoinToasts = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntMaxReferredPlayerJoinToasts"),
	GetFIntReferredPlayerJoinRemoteEventTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntReferredPlayerJoinRemoteEventTimeout"),
	FFlagLuaEnableCustomizedInviteLandingPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaEnableCustomizedInviteLandingPage"),
	FFlagLuaEnableCustomizedInviteLandingPageForTesting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaEnableCustomizedInviteLandingPageForTesting"),
	FFlagLuaEnableLandingPageTTIMeasurements = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaEnableLandingPageTTIMeasurements"),
	FStringLuaLoginRevampIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringLuaLoginRevampIxpLayer"),
	GetFFlagEnableMultiPageSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableMultiPageSignup"),
	GetFFlagEnableMultiPageSignupV2Updates = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableMultiPageSignupV2Updates"),
	FFlagEnableKoreaKISACompliance = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableKoreaKISACompliance"),
	FFlagKISAUserAgreementsRedesign = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagKISAUserAgreementsRedesign"),
	FFlagEnableKISAConsentModalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableKISAConsentModalization"),
	FFlagSignUpTrackFailedRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSignUpTrackFailedRequest"),
	FFlagSignUpPasswordCopyV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSignUpPasswordCopyV2"),
	GetFFlagLuaAppEnable10ftSignUpView = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnable10ftSignUpView"),
	FIntSignupMinimumAge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntSignupMinimumAge"),
	FFlagEnableMetaSignupMinimumAgePolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMetaSignupMinimumAgePolicy"),
	FStringLuaMultiPageSignupIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringLuaMultiPageSignupIxpLayer"),
	FFlagEnableAuthAnalyticsPrintDebuggingDev = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAuthAnalyticsPrintDebuggingDev"),
	FFlagLuaMultiPageSignupForceDeviceBoundPasskey = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaMultiPageSignupForceDeviceBoundPasskey"),
	FFlagEnableCallingLogoutOnResetIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableCallingLogoutOnResetIXP"),
	FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage"),
	GetFFlagEnableSignupFoundationText = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableSignupFoundationText"),
	GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup"),
	FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues"),
	FFlagApplyLaunchContextForNewAccountSwitches = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagApplyLaunchContextForNewAccountSwitches"),
	FFlagEnableLogoutV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLogoutV3"),
	FFlagAddReasonToEveryLogout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddReasonToEveryLogout"),
	FFlagEnableUpdatedLogoutUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUpdatedLogoutUpsellModal"),
	GetFFlagEnableConfirmSignOutV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableConfirmSignOutV2"),
	FFlagPreHomePageRoutingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPreHomePageRoutingEnabled"),
	FFlagPasskeyUpsellEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPasskeyUpsellEnabled"),
	FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAddAuthMethodPagePasskeyNudgeDirectionalExperiment"),
	FFlagEnableFaceIDTextOnAddAuthMethodPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableFaceIDTextOnAddAuthMethodPage"),
	FFlagEnableAddAuthMethodPageEmailSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAddAuthMethodPageEmailSignup"),
	FFlagEnableAddAuthMethodPageFoundationalizeHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAddAuthMethodPageFoundationalizeHeader"),
	FFlagEnableAddAuthMethodPageFoundationalizeParagraph = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAddAuthMethodPageFoundationalizeParagraph"),
	FFlagEnablePostAuthRoutingInAllCases = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePostAuthRoutingInAllCases"),
	FFlagPasskeyUpsellFilteringEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPasskeyUpsellFilteringEnabled"),
	GetFFlagLuaAppSignupPasskeyAvailabilityPreflight = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppSignupPasskeyAvailabilityPreflight"),
	FFlagTutorialUpsellEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTutorialUpsellEnabled"),
	GetFFlagEnableStorePreviousAccountData = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableStorePreviousAccountData"),
	FFlagEnablePasskeyLoginErrorLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePasskeyLoginErrorLogging"),
	FFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLastLoginMethodTracking"),
	FFlagUseIsAvailableCheckForIOSKeychainFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUseIsAvailableCheckForIOSKeychainFetch"),
	FFlagEnableMagicLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMagicLogin"),
	FFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRecordLogin"),
	FFlagFixPreviousAccountsListEntries = game:DefineFastFlag("FixPreviousAccountsListEntries", false),
	FFlagDisableMemStorageServicePasswordEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDisableMemStorageServicePasswordEvent"),
	FFlagLuaAppSkipDuplicateIosPasswordSavePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSkipDuplicateIosPasswordSavePrompt"),
	GetFFlagEnableIXPOverrideAccountPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableIXPOverrideAccountPicker"),
	GetFIntAccountPickerVariantOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntAccountPickerVariantOverride"),
	FFlagRefreshAuthSessionAfterLanguageChange = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRefreshAuthSessionAfterLanguageChange"),
	GetFFlagEnableAccountCarouselEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAccountCarouselEvents"),
	FFlagEnableConfirmSignifierOnSignUpPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableConfirmSignifierOnSignUpPage"),
	FFlagFoundationStylingOnSignUp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFoundationStylingOnSignUp"),
	GetFFlagKeystoreAutoLoginAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagKeystoreAutoLoginAvailable"),
	GetFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAuditForSinglePageSignUp"),
	GetFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAuditForSso"),
	GetFFlagAuthCollapsingValidatorFoundationInput = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAuthCollapsingValidatorFoundationInput"),
	FFlagAuthValidatorStyleOverrides = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAuthValidatorStyleOverrides"),
	FFlagAuthValidatorRebindTextBoxRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAuthValidatorRebindTextBoxRef"),
	FFlagSignupFoundationFields3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSignupFoundationFields3"),
	FFlagSignupFoundationPasswordField3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSignupFoundationPasswordField3"),
	FFlagEnableWebViewStateTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableWebViewStateTracker"),
	FIntScaleBrazilContentRatingBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntScaleBrazilContentRatingBadge"),
	FFlagEnablePWManagerSignupCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePWManagerSignupCheck"),
	FFlagEnableSilentUpgradeOnSignUp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSilentUpgradeOnSignUp"),
	GetFFlagSignUpBirthdayRefactorNestedDefinition = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSignUpBirthdayRefactorNestedDefinition"),
	GetFFlagSignUpBirthdayPickerRequireManualSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSignUpBirthdayPickerRequireManualSelection"),
	GetFFlagSignUpBirthdayPickerShowAgeCalculator = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSignUpBirthdayPickerShowAgeCalculator"),
	GetFIntSignUpBirthdayPickerManualSelectVariantOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntSignUpBirthdayPickerManualSelectVariantOverride"),
	FIntSinglePageSignupMinimumAge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntSinglePageSignupMinimumAge"),
	GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset"),
	GetFFlagEnableBirthdayOverlayAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableBirthdayOverlayAnalytics"),
	FFlagEnable2SVRecovery = game:DefineFastFlag("Enable2SVRecovery7", false),
	FFlagEmitPasskeyRegistrationSourceOnFinish = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEmitPasskeyRegistrationSourceOnFinish"),
	isAppNavEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/isAppNavEnabled"),
	GetFFlagLuaAppFixAppNavHeaderIconsAlignment = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppFixAppNavHeaderIconsAlignment"),
	FFlagAppNavLabelScaling = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppNavLabelScaling"),
	FFlagShrinkAppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShrinkAppNavBar"),
	FFlagAppNavTelemetryLogger = game:DefineFastFlag("AppNavTelemetryLogger", false),
	FFlagSubTabNavigationTTITracking = game:DefineFastFlag("SubTabNavigationTTITracking", false),
	FFlagLuaAppNavTTIMeasurementV2 = game:DefineFastFlag("LuaAppNavTTIMeasurementV2", false),
	FFlagFixNavigateToCatalogMetric = game:DefineFastFlag("FixNavigateToCatalogMetric", false),
	FFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScrollAway"),
	FFlagAppIaScrollAwayGuac = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScrollAwayGuac"),
	FFlagAppIaScrollAwayFixSocial = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScrollAwayFixSocial"),
	FFlagAppIaScrollAwayPinHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScrollAwayPinHeader"),
	FFlagAppIaScopedScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScopedScrollAway"),
	FFlagEnableSubTabForSpatial = game:DefineFastFlag("EnableSubTabForSpatial", false),
	FFlagSubTabAddDesktopTopMargin = game:DefineFastFlag("SubTabAddDesktopTopMargin", false),
	FIntLuaAppSubTabTopPadding = game:DefineFastInt("LuaAppSubTabTopPadding", 0),
	FFlagEnableScrollAwayContentScrollableFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableScrollAwayContentScrollableFix"),
	FFlagEnableSubTabOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSubTabOverride"),
	FFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeSubTab"),
	FFlagLuaAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppIaHomeSubTab"),
	FFlagAppThemeHalloween2026HomeBackground = defineFastFlag71,
	FFlagAppThemeHalloween2026FriendsBackground = v46,
	FFlagAppIaHomeSubTabAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeSubTabAnalytics"),
	FFlagAppIaHomeSubTabScrollAwayFull = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFull", false),
	FFlagAppIaHomeCampaignSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeCampaignSubTab"),
	FFlagAppIaHomeShowCampaignTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeShowCampaignTab"),
	FFlagAppIaHomeCampaignDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeCampaignDeepLink"),
	FFlagAppIaHomeCampaignTabNewBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeCampaignTabNewBadge"),
	FFlagSubTabFixMissingProfileWidget = game:DefineFastFlag("SubTabFixMissingProfileWidget", false),
	FFlagSubTabRemoveFlyoutDependency = game:DefineFastFlag("SubTabRemoveFlyoutDependency", false),
	FFlagSubTabSizeSmall = game:DefineFastFlag("SubTabSizeSmall", false),
	FFlagSubTabUseHomeContainerOnConsole = game:DefineFastFlag("SubTabUseHomeContainerOnConsole", false),
	FFlagSubTabHideChartsForNonArgo = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSubTabHideChartsForNonArgo"),
	FFlagEnableIsChartsInSubTab = game:DefineFastFlag("EnableIsChartsInSubTab", false),
	FFlagHiddenFriendsSortHeaderRemoveFlyoutDependency = game:DefineFastFlag(
		"HiddenFriendsSortHeaderRemoveFlyoutDependency",
		false
	),
	FFlagEnableDrawerFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableDrawerFocusNav"),
	FFlagEnableDrawerAnimatingHook = game:DefineFastFlag("EnableDrawerAnimatingHook", false),
	FFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableArgus"),
	FFlagArgoEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagArgoEnableMoments"),
	FFlagEnableClassicThemeHeaderBackground = game:DefineFastFlag(
		"EnableClassicThemeHeaderBackground",
		false
	),
	FFlagEnableArgusImmersiveNav = game:DefineFastFlag("EnableArgusImmersiveNav", false),
	FFlagAppChatMomentShareCardNavigation = game:DefineFastFlag("AppChatMomentShareCardNavigation", false),
	FFlagFlyoutRemoveMomentsForArgoEnabled = game:DefineFastFlag("FlyoutRemoveMomentsForArgoEnabled", false),
	FFlagAppIaStatusBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaStatusBar"),
	FFlagLuaAppUseDeviceSafeInsetsForAppContainer = game:DefineFastFlag(
		"LuaAppUseDeviceSafeInsetsForAppContainer3",
		false
	),
	FFlagFixNavigationInsetsOnHiddenTabBar = game:DefineFastFlag("FixNavigationInsetsOnHiddenTabBar", false),
	FFlagFixOverlayTopInsetForDeviceSafeInsets = game:DefineFastFlag(
		"FixOverlayTopInsetForDeviceSafeInsets2",
		false
	),
	FFlagFixHomeHeaderForDeviceSafeInsets = game:DefineFastFlag("FixHomeHeaderForDeviceSafeInsets", false),
	FFlagFixNavRailForDeviceSafeInsets = game:DefineFastFlag("FixNavRailForDeviceSafeInsets", false),
	FFlagEnableHomeRobloxLogo = game:DefineFastFlag("EnableHomeRobloxLogo", false),
	FFlagEnableConsoleRobloxLogo = game:DefineFastFlag("EnableConsoleRobloxLogo", false),
	GetFFlagGateEducationalPopupVisibilityViaGUAC = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGateEducationalPopupVisibilityViaGUAC"),
	GetFFlagGateLeaderboardPlayerDropdownViaGUAC = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagGateLeaderboardPlayerDropdownViaGUAC"),
	GetFFlagVngTOSRevisedEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagVngTOSRevisedEnabled"),
	GetFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableOpenTypeSupport"),
	GetFFlagLuaAppEnableOpenTypeSignUpPageFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableOpenTypeSignUpPageFix"),
	GetFFlagLuaAppEnableOpenTypeIGMFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableOpenTypeIGMFix"),
	FFlagChangeSocialGraphLifecycleEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChangeSocialGraphLifecycleEvent"),
	FFlagLuaAppFixSDPLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppFixSDPLayout"),
	GetFFlagAudioPlayerCanSkipTracks = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagAudioPlayerCanSkipTracks"),
	GetFFlagChromeMusicWindowTopbarReappearsOnGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagChromeMusicWindowTopbarReappearsOnGamepad"),
	GetFFlagSongDetailsPageDesignPass = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagSongDetailsPageDesignPass"),
	GetFFlagEnableAffiliateLinksQualifiedSignUpTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAffiliateLinksQualifiedSignUpTracking"),
	GetFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEdpPlayerFeedbackEnabled"),
	GetFFlagEdpPlayerFeedbackLogIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEdpPlayerFeedbackLogIXPExposure"),
	GetFFlagEdpPlayerFeedbackCommentsOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEdpPlayerFeedbackCommentsOnly"),
	GetFFlagEdpPlayerFeedbackPromptTitleOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEdpPlayerFeedbackPromptTitleOnly"),
	GetFStringEdpPlayerFeedbackServiceRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringEdpPlayerFeedbackServiceRoute"),
	FFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableShareLinksInGameDetailEvent"),
	GetFFlagDebugEnableUnibarDummyIntegrations = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDebugEnableUnibarDummyIntegrations"),
	GetFFlagUnibarLuaOcclusionMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagUnibarLuaOcclusionMetrics"),
	GetFIntIconSelectionTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntIconSelectionTimeout"),
	GetFIntLuaUIOcclusionMetricsReportingPeriodSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFIntLuaUIOcclusionMetricsReportingPeriodSeconds"),
	GetFFlagChromeCentralizedConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagChromeCentralizedConfiguration"),
	FFlagVirtualCursorInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagVirtualCursorInputSink"),
	FFlagEnableConsoleExpControls = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableConsoleExpControls"),
	FFlagUnibarMenuOpenSelectionIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnibarMenuOpenSelectionIXP"),
	FFlagEnableInExperienceHandheldControls = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInExperienceHandheldControls"),
	FFlagExperienceMenuGamepadExposureEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExperienceMenuGamepadExposureEnabled"),
	FFlagUnibarMenuOpenHamburgerGamepadIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnibarMenuOpenHamburgerGamepadIXP"),
	FFlagReduceTopBarInsetsWhileHidden = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagReduceTopBarInsetsWhileHidden"),
	FFlagChromeChatGamepadSupportFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeChatGamepadSupportFix"),
	FFlagShowUnibarOnVirtualCursor = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowUnibarOnVirtualCursor"),
	FFlagEnablePlaytestModeUnibar = game:DefineFastFlag("EnablePlaytestModeUnibar2", false),
	FFlagPlaytestModeTooltipOncePerWeek = game:DefineFastFlag("PlaytestModeTooltipOncePerWeek", false),
	FFlagPlaytestModeTooltipOnlyPrivateTesters = game:DefineFastFlag(
		"PlaytestModeTooltipOnlyPrivateTesters",
		false
	),
	FFlagEnableTeamTestLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableTeamTestLua"),
	FIntUnpublishedPlaytestModeTooltipDisplayLimit = game:DefineFastInt(
		"UnpublishedPlaytestModeTooltipDisplayLimit",
		1
	),
	FFlagAddSwitchTabHintsToIEM = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddSwitchTabHintsToIEM"),
	FFlagConsoleChatUseChromeFocusUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagConsoleChatUseChromeFocusUtils"),
	FFlagInExperienceReportClosingBugfix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInExperienceReportClosingBugfix"),
	FFlagChromeShortcutAddRespawnLeaveToIEM = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeShortcutAddRespawnLeaveToIEM"),
	FFlagChromeShortcutRemoveLeaveOnRespawnPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeShortcutRemoveLeaveOnRespawnPage"),
	FFlagChromeShortcutRemoveRespawnOnLeavePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeShortcutRemoveRespawnOnLeavePage"),
	FFlagChromeShortcutChatOpenKeyboard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagChromeShortcutChatOpenKeyboard"),
	FFlagEnableSchedulerFlagOverrides = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSchedulerFlagOverrides"),
	GetReactSchedulerIXPConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetReactSchedulerIXPConfig"),
	GetSchedulerFlagOverrides = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetSchedulerFlagOverrides"),
	GetFFlagDisableLegacyChatSimpleUnreadMessageCount = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDisableLegacyChatSimpleUnreadMessageCount"),
	FFlagIEMTabFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagIEMTabFocusNav"),
	FFlagInExperienceUseAppStyleProvider = game:DefineFastFlag("InExperienceUseAppStyleProvider", false),
	FStringReactSchedulingContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringReactSchedulingContext"),
	FFlagEnableMorePageExitButtonSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMorePageExitButtonSupport"),
	FFlagEnableMorePageDirectionalLayoutRolloutFix = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMorePageDirectionalLayoutRolloutFix"),
	FFlagEnableSideSheetWidgets = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSideSheetWidgets"),
	FFlagAddInviteFriendsIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddInviteFriendsIntegration"),
	FFlagHidePeoplePageInviteFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHidePeoplePageInviteFriends"),
	FFlagSideSheetFocusNav = game:DefineFastFlag("SideSheetFocusNav2", false),
	FFlagSideSheetUnifiedMenuOrder = game:DefineFastFlag("SideSheetUnifiedMenuOrder", false),
	FFlagDebugEnablePioneerUX = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugEnablePioneerUX"),
	FFlagEnableExpressSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableExpressSignup"),
	FFlagEnablePioneerLandingPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePioneerLandingPageLayout"),
	FFlagEnablePioneerPostAuthGameJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePioneerPostAuthGameJoin"),
	FFlagPioneerPreLaunchPlayabilityCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPioneerPreLaunchPlayabilityCheck"),
	FFlagPioneerLeaveOnInExpFaeDownAge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPioneerLeaveOnInExpFaeDownAge"),
	FFlagPioneerLeaveLogsOut = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPioneerLeaveLogsOut"),
	FFlagEnableAccountIneligibleLoginModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAccountIneligibleLoginModal"),
	FFlagSkipAccountSwitchRelaunchForPioneerLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSkipAccountSwitchRelaunchForPioneerLogin"),
	GetFStringPioneerLaunchPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFStringPioneerLaunchPlaceId"),
	FFlagIntegrateTraversalHistoryInSideSheet = game:DefineFastFlag(
		"IntegrateTraversalHistoryInSideSheet2",
		false
	),
	FFlagUseAnimateScrollViewToSelectionHelper = game:DefineFastFlag(
		"UseAnimateScrollViewToSelectionHelper",
		false
	),
	FFlagEnableWhatsNew = game:DefineFastFlag("EnableWhatsNew2", false),
	FFlagEnableInExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInExperienceShop"),
	FFlagEnableMenuTrailingBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMenuTrailingBadge"),
	FFlagEnableCustomTextInMenuTrailingBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableCustomTextInMenuTrailingBadge"),
	FFlagShowOfferBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowOfferBadge"),
	FFlagOfferNotifyOnGlobalIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagOfferNotifyOnGlobalIcon"),
	FFlagOfferNineDotActivityIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagOfferNineDotActivityIndicator"),
	FFlagHideOfferNotificationsWhenShopEmpty = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHideOfferNotificationsWhenShopEmpty"),
	FFlagEnablePurchasePayloadInExperienceShop = game:DefineFastFlag(
		"EnablePurchasePayloadInExperienceShop",
		false
	) and game:GetEngineFeature("EnablePurchasePayload"),
	FFlagPassShopPurchaseSurfaceToBuyModal = game:DefineFastFlag("PassShopPurchaseSurfaceToBuyModal", false),
	FFlagEnableRobuxInExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRobuxInExperienceShop"),
	FFlagEnableBonusJwtInShop = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBonusJwtInShop"),
	FFlagUseGetGamePassOwnershipApi = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUseGetGamePassOwnershipApi"),
	FFlagSkipBuyDelayForExperienceShop = game:DefineFastFlag("SkipBuyDelayForExperienceShop", false),
	FFlagHideHeaderForBuyRobuxInExperienceShop = game:DefineFastFlag(
		"HideHeaderForBuyRobuxInExperienceShop",
		false
	),
	FFlagEnableBuyRobuxNextJS = game:DefineFastFlag("EnableBuyRobuxNextJS", false),
	FFlagBuyRobuxLatencyIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBuyRobuxLatencyIxpEnabled"),
	FFlagEnableBuyRobuxSdui = game:DefineFastFlag("EnableBuyRobuxSdui", false),
	FFlagEnableBuyRobuxNewRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBuyRobuxNewRouting"),
	FFlagEnableBuyRobuxNewRoutingInExperience = game:DefineFastFlag(
		"EnableBuyRobuxNewRoutingInExperience",
		false
	),
	FFlagBypassBuyRobuxSduiSupportForWebRouting = game:DefineFastFlag(
		"BypassBuyRobuxSduiSupportForWebRouting",
		false
	),
	FStringPaymentsBuyRobuxLayer = game:DefineFastString("PaymentsBuyRobuxLayer", ""),
	UpsellSuggestionsAPIMaxPackages = game:DefineFastInt("UpsellSuggestionsAPIMaxPackagesV3", 1),
	FFlagEnableUpsellSuggestionsAnalyticsId = game:DefineFastFlag(
		"EnableUpsellSuggestionsAnalyticsId",
		false
	),
	FFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlayWithRewardComponent"),
	FFlagEnablePlayWithRewardNonPeekviewEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlayWithRewardNonPeekviewEdp"),
	FFlagPlayWithRewardClearOnExperienceLeave = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlayWithRewardClearOnExperienceLeave"),
	FFlagPlayWithRewardCoachmarkOverlayFix = game:DefineFastFlag("PlayWithRewardCoachmarkOverlayFix", false),
	FFlagEnableLaunchAfterPurchase = game:DefineFastFlag("EnableLaunchAfterPurchase2", false),
	FFlagEnableLargerLaunchAfterPurchasePlayIcon = game:DefineFastFlag(
		"EnableLargerLaunchAfterPurchasePlayIcon",
		false
	),
	FFlagUpdatePriceTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUpdateUnifiedPurchasePriceTelemetry"),
	FFlagEnableReportingFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableReportingFlowForDevSubs"),
	FFlagEnableReportingFlowForExperienceShop = game:DefineFastFlag(
		"EnableReportingFlowForExperienceShop2",
		false
	),
	FFlagAbuseReportAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAbuseReportAttributes"),
	FFlagEnableMomentsCommentReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMomentsCommentReporting"),
	FFlagMomentsAvatarLookTryOn = game:DefineFastFlag("MomentsAvatarLookTryOn", false),
	FFlagMomentsHideOfficialContentLabel = game:DefineFastFlag("MomentsHideOfficialContentLabel", false),
	FFlagAXEnableUnifiedLoggingAvatarMoment = game:DefineFastFlag(
		"AXEnableUnifiedLoggingAvatarMoment2",
		false
	),
	FFlagEnableMomentsCommentBlocking = game:DefineFastFlag("EnableMomentsCommentBlocking", false),
	FFlagMomentsBlockingModalInOverlay = game:DefineFastFlag("MomentsBlockingModalInOverlay", false),
	FFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableUnifiedPurchaseFlowForDevSubs"),
	FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase"),
	FFlagHideDevSubsPriceIfSubscribed = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHideDevSubsPriceIfSubscribed"),
	FFlagEnableDevSubsFastFollowFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableDevSubsFastFollowFixes"),
	FFlagAddCursorProviderToPurchasePromptApp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddCursorProviderToPurchasePromptApp"),
	FFlagAXEnableInspectAndBuyBulkPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXEnableInspectAndBuyBulkPurchase"),
	FFlagAXEnableTimedOptionsServerScript = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXEnableTimedOptionsServerScript"),
	FIntBulkPurchaseThrottleLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntBulkPurchaseThrottleLimit"),
	FIntBulkPurchaseRequestLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntBulkPurchaseRequestLimit"),
	FFlagEnableInspectAndBuyV2RootFlag = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInspectAndBuyV2RootFlag"),
	FFlagEnableSystemTrayModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSystemTrayModals"),
	FFlagDebugAlwaysShowSystemTrayModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDebugAlwaysShowSystemTrayModal"),
	FFlagFilterOutShopOnlyItemsOnBulkPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFilterOutShopOnlyItemsonBulkPurchase"),
	FFlagSkipCompletionModalForMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSkipCompletionModalForMarketplace"),
	FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell"),
	FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedPurchaseFlowMarketplaceUIImprovements"),
	FFlagLuaAppSupportDeviceSafeInsets = game:GetEngineFeature("DeviceSafeInsetsSupportLuaApp"),
	FFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedPurchaseAddSkeleton"),
	FFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableFetchCartPricingDuringInExperience"),
	FFlagAXFetchCartPricingDuringInExperienceExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFetchCartPricingDuringInExperienceExposure"),
	FStringAXFetchCartPricingDuringInExperienceLayerName = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FStringAXFetchCartPricingDuringInExperienceLayerName"),
	FFlagEnableInExperienceOfferExpiryBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInExperienceOfferExpiryBadge"),
	FFlagEnableMarketplacePurchaseDeepLinkAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMarketplacePurchaseDeepLinkAttribution"),
	GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagDiscountInfoForSubscriptionPurchaseModalLua"),
	FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveCentralOverlayScrimForUnifiedPurchaseModal"),
	FFlagEnableAvatarExperienceSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableAvatarExperienceSdui"),
	FFlagAXFixHomeAvatarsUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixHomeAvatarsUnifiedPurchase"),
	FFlagAXFixSplitPaneHomeTryOnReset = game:DefineFastFlag("AXFixSplitPaneHomeTryOnReset", false),
	FFlagAXDiscoveryItemPurchaseAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXDiscoveryItemPurchaseAttribution"),
	FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass"),
	FFlagMarketplaceOffersOptOutRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMarketplaceOffersOptOutRoot"),
	FFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPurchasePromptFetchCartPricingForLooks"),
	FFlagOffersOnlyAffordableLock = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagOffersOnlyAffordableLock"),
	FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice"),
	FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow"),
	FFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppsEnablePromptVIPServerPurchase"),
	FFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableNativePurchaseFinishedV2Signals"),
	FFlagEnableBlackbirdUpsellImpressionGating = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableBlackbirdUpsellImpressionGating"),
	FFlagBlackbirdUpsellGateResalePurchaseType = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBlackbirdUpsellGateResalePurchaseType"),
	FIntBlackbirdUpsellMinPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntBlackbirdUpsellMinPriceForDiscountInclusive"),
	FIntBlackbirdUpsellMaxPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntBlackbirdUpsellMaxPriceForDiscountInclusive"),
	FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry"),
	FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal"),
	FFlagPurchasePromptSubtitleForTimedOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPurchasePromptSubtitleForTimedOptions"),
	FFlagPurchaseModalTimedOptionExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPurchaseModalTimedOptionExtension"),
	FFlagIntegrateDiscountsWithEDP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagIntegrateDiscountsWithEDP"),
	FFlagAddPurchaseOptionForProvidingBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddPurchaseOptionForProvidingBalance"),
	FFlagUnifiedPurchasePassInProductInfoEDP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedPurchasePassInProductInfoEDP"),
	FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddPerformanceMetricsToUnifiedPurchaseModal"),
	FIntLegacyPurchaseFPSTrackingTimeout = game:DefineFastInt("FIntLegacyPurchaseFPSTrackingTimeout", 2),
	FFlagEnableNotificationsDeeplink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNotificationsDeeplink"),
	FIntTTIUnifiedPurchaseSamplingRate = game:DefineFastInt("TTIUnifiedPurchaseSamplingRate", 1),
	FFlagAddCenterDialogForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAddCenterDialogForUnifiedPurchaseModal"),
	FFlagShipUnifiedPurchaseInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShipUnifiedPurchaseInExperience"),
	FFlagAddUnifiedPurchaseFlowTTIToEDP = game:DefineFastFlag("AddUnifiedPurchaseFlowTTIToEDP", false),
	FFlagShipUnifiedPurchaseFlowToPaidAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShipUnifiedPurchaseFlowToPaidAccess"),
	FFlagFixInactiveChildStateForwarding = game:DefineFastFlag("FixInactiveChildStateForwarding", false),
	FFlagFixSelectionWithWebViews = game:DefineFastFlag("FixSelectionWithWebViews", false),
	FFlagAvatarJointUpgradeInUA = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAvatarJointUpgradeInUA"),
	FFlagLuaAppCompositionAlways = defineFastFlag25,
	FFlagLuaAppUseFrameBoundsImpressions = game:DefineFastFlag("LuaAppUseFrameBoundsImpressions", false),
	FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = game:DefineFastFlag(
		"LuaAppUseScreenFillBoundsForFrameBoundsImpressions",
		false
	),
	FFlagLuaAppCompositionAppChat = game:DefineFastFlag("LuaAppCompositionAppChat", false) or defineFastFlag25,
	FFlagLuaAppCompositionPlayerGrid = game:DefineFastFlag("LuaAppCompositionPlayerGrid", false) or defineFastFlag25,
	FFlagLuaAppCompositionLegacyLayout = game:DefineFastFlag("LuaAppCompositionLegacyLayout", false),
	FFlagLuaAppCompositionSearch = game:DefineFastFlag("LuaAppCompositionSearch", false),
	FFlagUnifiedPurchaseOptimizeTTIMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagUnifiedPurchaseOptimizeTTIMarketplace"),
	FFlagUseSignalsForAccountSecurityPrompt = defineFastFlag3,
	FFlagUseSignalsForSearchBar = defineFastFlag5,
	FFlagUseSignalsForAuthenticationStatus = defineFastFlag6,
	FFlagUseSignalsForGlobalContextMenuInset = defineFastFlag7,
	FFlagUseSignalsForCountryCode = defineFastFlag8,
	FFlagUseSignalsForSiteMessage = defineFastFlag9,
	FFlagUseSignalsForStartup = defineFastFlag14,
	FFlagUseSignalsForScreenGuiBlur = defineFastFlag10,
	FFlagUseSignalsForGameInvitesStatus = defineFastFlag11,
	FFlagUseSignalsForIsLocalUserUnder13 = defineFastFlag12,
	FFlagUseSignalsForPlatform = defineFastFlag13,
	FFlagUseSignalsForAppTopBanner = defineFastFlag15,
	FFlagUseSignalsForDeviceOrientation = defineFastFlag16,
	FFlagUseSignalsForRobuxVirtualItem = defineFastFlag17,
	FFlagUseNavigationSelectors = game:DefineFastFlag("UseNavigationSelectors", false),
	FFlagInlineRichTextUseWebViewService = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineRichTextUseWebViewService"),
	FFlagInlineRichTextSkipPlaintextEscape = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagInlineRichTextSkipPlaintextEscape"),
	FFlagFixCrossExperienceVoiceExecutePrint = game:DefineFastFlag(
		"FixCrossExperienceVoiceExecutePrint",
		false
	),
	FFlagEnableNewBackpack = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNewBackpack"),
	FFlagShowGameAgeRating = game:DefineFastFlag("ShowGameAgeRating", false),
	FFlagBackpackResponsiveUnits = game:DefineFastFlag("BackpackResponsiveUnits", false),
	FFlagStudioDeviceSimVRSwitchFixes = game:DefineFastFlag("StudioDeviceSimVRSwitchFixes", false),
	FFlagEnableShareSheet = game:DefineFastFlag("EnableShareSheetForBuild", false),
	FFlagShowSwitchServerButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagShowSwitchServerButton"),
	FFlagSideSheetOpenPeoplePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSideSheetOpenPeoplePage"),
	FFlagEnableLoginV2Modalization = game:DefineFastFlag("EnableLoginV2Modalization19", false),
	FFlagLoginV2FullFlowDevOverride = game:DefineFastFlag("LoginV2FullFlowDevOverride", false),
	FFlagLoginV2ModalFocusNavigation = game:DefineFastFlag("LoginV2ModalFocusNavigation", false),
	FFlagLoginV2SubmitOnKeyboardReturn = game:DefineFastFlag("LoginV2SubmitOnKeyboardReturn", false),
	FFlagAccountSwitcherFocusNavigation = game:DefineFastFlag("AccountSwitcherFocusNavigation", false),
	FFlagAccountSwitcherForceDarkAuthTheme = game:DefineFastFlag("AccountSwitcherForceDarkAuthTheme", false),
	FFlagEnableAccountSwitchSsoLogin = game:DefineFastFlag("EnableAccountSwitchSsoLogin", false),
	FFlagFixLoginV2AccountSwitchOverlaySoftLock = game:DefineFastFlag(
		"FixLoginV2AccountSwitchOverlaySoftLock",
		false
	),
	FFlagRemoveUnusedConnectionStateRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedConnectionStateRoduxSlice"),
	FFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedFriendCountRoduxSlice"),
	FFlagRemoveUnusedFriendStatusesRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedFriendStatusesRoduxSlice"),
	FFlagRemoveUnusedGameThumbnailsRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedGameThumbnailsRoduxSlice"),
	FFlagRemoveUnusedSignUpInfoRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedSignUpInfoRoduxSlice"),
	FFlagRemoveUnusedUsersAsyncRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedUsersAsyncRoduxSlice"),
	FFlagRemoveUnusedUserStatusesRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagRemoveUnusedUserStatusesRoduxSlice"),
	FFlagEnableRobloxSubscriptionEventListener = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableRobloxSubscriptionEventListener"),
	FFlagSduiSubscriptionCellPostPurchaseSync = game:DefineFastFlag(
		"SduiSubscriptionCellPostPurchaseSync",
		false
	),
	FFlagSubscriptionPurchaseModalLiveStatus = game:DefineFastFlag(
		"SubscriptionPurchaseModalLiveStatus",
		false
	),
	FFlagAppIconSelectionPage = engineFeature3,
	FFlagSubscriptionSheetCampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSubscriptionSheetCampaignLocalizations"),
	FFlagRobloxSubscriptionOnboardingSheet = game:DefineFastFlag(
		"RobloxSubscriptionOnboardingSheet2",
		false
	) and require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSubscriptionSheetCampaignLocalizations"),
	FFlagPlusSubscribeDeepLinkIncludeUpgrades = game:DefineFastFlag(
		"PlusSubscribeDeepLinkIncludeUpgrades2",
		false
	) and require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlusMembershipConfigChangeCheck"),
	FFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPlusMembershipConfigChangeCheck"),
	FFlagReplaceMissingDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagReplaceMissingDesignTokens"),
	FFlagEnableCoreContentAccountType = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableCoreContentAccountType"),
	FFlagEnableCoreContentBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableCoreContentBadge"),
	FFlagMomentsRespectAccountTheme = game:DefineFastFlag("MomentsRespectAccountTheme", false),
	FFlagSubscriptionPurchaseFollowsAppTheme = game:DefineFastFlag(
		"SubscriptionPurchaseFollowsAppTheme",
		false
	),
	FFlagSeedAccountThemeFromDisk = game:DefineFastFlag("SeedAccountThemeFromDisk", false) and game:GetEngineFeature("UserIdToAccountThemeMapKeyAvailable"),
	FFlagMomentsDarkAppNavBar = game:DefineFastFlag("MomentsDarkAppNavBar", false),
	FFlagAppNavBarPerItemThemeOverride = defineFastFlag68,
	FFlagAmpV2WizardParentModeNavTheme = v37,
	FFlagEnableCoreContentThemeVRScene = game:DefineFastFlag("EnableCoreContentThemeVRScene", false),
	FFlagEnableFlyoutUncheckedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableFlyoutUncheckedBadge"),
	FFlagDefaultKidsToDarkTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDefaultKidsToDarkTheme"),
	FFlagEnableNonFlyoutUncheckedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableNonFlyoutUncheckedBadge"),
	FFlagFlyoutHeaderFixPadding = game:DefineFastFlag("FlyoutHeaderFixPadding", false),
	FFlagFlyoutFilterWebViewsAndBrowserLinks = game:DefineFastFlag(
		"FlyoutFilterWebViewsAndBrowserLinks",
		false
	),
	FFlagFlyoutGateLearnPlace = game:DefineFastFlag("FlyoutGateLearnPlace", false),
	FFlagFlyoutSidePanelUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFlyoutSidePanelUseProfileFrameThumbnail"),
	FFlagEnableChartsInFlyout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableChartsInFlyout"),
	FFlagFixDefaultThemeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixDefaultThemeOverride"),
	GetFFlagKeepDarkThemeOverrideWhenLoggedOut = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagKeepDarkThemeOverrideWhenLoggedOut"),
	FFlagUseDefaultOverrideColorsFor10ftModels = game:DefineFastFlag(
		"UseDefaultOverrideColorsFor10ftModels",
		false
	),
	FFlagDeviceLevelThemeRespectForceTheme = game:DefineFastFlag("DeviceLevelThemeRespectForceTheme", false),
	FFlagMoveForceThemeToThemeChangeEventReceiver = game:DefineFastFlag(
		"MoveForceThemeToThemeChangeEventReceiver",
		false
	),
	GetFFlagEnablePlatformRestrictedEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnablePlatformRestrictedEventReceiver"),
	GetFFlagFixPlatformRestrictedHomeClobber = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagFixPlatformRestrictedHomeClobber"),
	GetFFlagLuaAppPlatformRestrictionVPC = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppPlatformRestrictionVPC"),
	FFlagLuaAppBirthdayComplianceGate = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppBirthdayComplianceGate"),
	FFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselShareQREnabled"),
	FFlagSocialCarouselShareQRBackToAddFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselShareQRBackToAddFriends"),
	FFlagPresenceLocationType = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPresenceLocationType"),
	FFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialCarouselBuildPresence"),
	FFlagBuildTabUsesCanViewBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBuildTabUsesCanViewBuild"),
	FFlagAppDebugPanel = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppDebugPanel"),
	FFlagAppDebugTagAnnotation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppDebugTagAnnotation"),
	FFlagEnableFlyoutFriendsHeaderFix = game:DefineFastFlag("EnableFlyoutFriendsHeaderFix", false),
	FFlagAppNavMyStatsTab = game:DefineFastFlag("AppNavMyStatsTab3", false),
	FFlagReplaceNavbarIconsWithFoundation = game:DefineFastFlag("ReplaceNavbarIconsWithFoundation2", false),
	FFlagEnableBuildTabOverride = game:DefineFastFlag("EnableBuildTabOverride", false),
	FFlagBuildAgentAdCampaignCard = game:DefineFastFlag("BuildAgentAdCampaignCard4", false),
	FFlagBuildAgentAdCampaignRefreshEligibility = game:DefineFastFlag(
		"BuildAgentAdCampaignRefreshEligibility",
		false
	),
	FFlagBuildAgentAdCampaignToolCallStatusFallback = game:DefineFastFlag(
		"BuildAgentAdCampaignToolCallStatusFallback",
		false
	),
	FFlagBuildExperienceLibrary = game:DefineFastFlag("BuildExperienceLibrary5", false) and game:GetEngineFeature("IsTeamCreateViewerEnabled"),
	FFlagBuildExperienceHideNavBarOnSubPages = game:DefineFastFlag(
		"BuildExperienceHideNavBarOnSubPages",
		false
	),
	FFlagConnectionRelaunchBuildPlaytest = game:DefineFastFlag("ConnectionRelaunchBuildPlaytest", false),
	FFlagEnableBuildAdPromotion = defineFastFlag,
	FFlagBuildAdUpsell = engineFeature,
	FFlagBuildAdsNotificationRouting = game:DefineFastFlag("BuildAdsNotificationRouting", false) and engineFeature,
	FFlagBuildExperienceAnalytics = game:DefineFastFlag("BuildExperienceAnalytics", false),
	FFlagBuildExperienceAdvancedPreviewSpecs = game:DefineFastFlag(
		"BuildExperienceAdvancedPreviewSpecs",
		false
	),
	FFlagBuildExperienceManageGamePass = game:DefineFastFlag("BuildExperienceManageGamePass", false),
	FFlagBuildExperienceManageSubscription = game:DefineFastFlag("BuildExperienceManageSubscription", false),
	FFlagBuildExperienceManageMonetizationTool = game:DefineFastFlag(
		"BuildExperienceManageMonetizationTool",
		false
	),
	FFlagBuildExperienceInGameCaptureToChat = game:DefineFastFlag(
		"BuildExperienceInGameCaptureToChat",
		false
	),
	FFlagBuildExperienceInGameShell = game:DefineFastFlag("BuildExperienceInGameShell", false),
	FFlagBuildExperienceInstanceSelection = game:DefineFastFlag("BuildExperienceInstanceSelection", false),
	FFlagBuildExperienceRemoveDevProductPriceCap = game:DefineFastFlag(
		"BuildExperienceRemoveDevProductPriceCap",
		false
	),
	FFlagComposerFooter = game:DefineFastFlag("ComposerFooter", false),
	FFlagBuildExperiencePromptFailureTelemetry = game:DefineFastFlag(
		"BuildExperiencePromptFailureTelemetry2",
		false
	),
	FFlagBuildExperienceHistoryPollTelemetry = game:DefineFastFlag(
		"BuildExperienceHistoryPollTelemetry",
		false
	),
	FFlagBuildWithGroups = game:DefineFastFlag("BuildWithGroups3", false),
	FFlagMyStatsMediaSelector = game:DefineFastFlag("MyStatsMediaSelector3", false),
	FFlagAndroidTVExitWithB = game:DefineFastFlag("AndroidTVExitWithB2", false) and game:GetEngineFeature("PTFBackButtonAlwaysAsButtonB"),
	FFlagEnableMeTabProfile = defineFastFlag28,
	FFlagEnableMeTabMarketplaceNav = defineFastFlag29,
	FFlagRenameAvatarToMe = game:DefineFastFlag("RenameAvatarToMe", false),
	FFlagEnableBottomNavOnMarketplace = game:DefineFastFlag("EnableBottomNavOnMarketplace_v3", false) or defineFastFlag29,
	FFlagStackedBottomNavMarketplaceCTA = game:DefineFastFlag("StackedBottomNavMarketplaceCTA", false) or defineFastFlag29,
	FFlagRemoveBottomNavOnLookDetails = game:DefineFastFlag("RemoveBottomNavOnLookDetails", false),
	FFlagAXHideBottomNavForEditProfileImage = game:DefineFastFlag(
		"AXHideBottomNavForEditProfileImage",
		false
	),
	FFlagIncreaseMarketplaceContentHeight = game:DefineFastFlag("IncreaseMarketplaceContentHeight", false) or defineFastFlag29,
	FFlagIncreaseLoadingScreenOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagIncreaseLoadingScreenOrder"),
	FFlagEnableLuaAppsFollowUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableLuaAppsFollowUserId"),
	FIntAutoJoinNewServerTimeMs = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntAutoJoinNewServerTimeMs"),
	FIntLoadingScreenQueuedStateButtonClickThrottleHundredthsPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntLoadingScreenQueuedStateButtonClickThrottleHundredthsPercent"),
	FFlagFlyoutNavigationInMarketplace = game:DefineFastFlag("FlyoutNavigationInMarketplace", false) or defineFastFlag29,
	FFlagLuaAppSduiStreamingFirstDataTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiStreamingFirstDataTiming"),
	FFlagMediaGalleryVideoVisiblePercent = game:DefineFastFlag("MediaGalleryVideoVisiblePercent", false),
	FFlagSduiApiStoreUpdateInputData = game:DefineFastFlag("SduiApiStoreUpdateInputData", false),
	FFlagSduiEdpTemplatePrewarm = v59,
	FFlagSduiLaunchTemplatePrewarm = defineFastFlag79,
	FFlagSduiAdvertiseRuntimeSupportSets = defineFastFlag76,
	FFlagSduiExtendedCapabilitiesDiscovery = v60,
	FFlagSduiExtendedCapabilitiesPrompts = v61,
	FFlagSduiUseInputData = defineFastFlag31,
	FFlagSduiPageEntryPointResolvedSlot = defineFastFlag32,
	FFlagSduiSrpShowNavOnNewSearch = game:DefineFastFlag("SduiSrpShowNavOnNewSearch", false),
	FFlagAXEnableProfileTab = game:DefineFastFlag("AXEnableProfileTab_1", false) or defineFastFlag28,
	FFlagAXSaveManagerOutsideAX = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXSaveManagerOutsideAX"),
	FFlagAXPPEReturnToEntrySurface = game:DefineFastFlag("AXPPEReturnToEntrySurface", false),
	FFlagProfileMomentsFeedRootRoute = defineFastFlag66,
	FFlagProfileMomentsFeedAboveSplitPane = game:DefineFastFlag("ProfileMomentsFeedAboveSplitPane", false) and defineFastFlag69 and defineFastFlag66 and not v35,
	FFlagAXFixTabBarOverrideForWrapperPages = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAXFixTabBarOverrideForWrapperPages"),
	FFlagCoreUiMigrateUIBloxToFoundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagCoreUiMigrateUIBloxToFoundation"),
	FFlagTiltLoadingScreenDismissOnLoaded = game:DefineFastFlag("TiltLoadingScreenDismissOnLoaded", false),
	FFlagEnableTiltLoadingScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableTiltLoadingScreen"),
	FFlagLoadingScreenMilestones = game:DefineFastFlag("LoadingScreenMilestones2", false),
	FFlagLoadingScreenControlMilestones = game:DefineFastFlag("LoadingScreenControlMilestones", false),
	FFlagTiltLoadingScreenConsoleHints = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTiltLoadingScreenConsoleHints"),
	FFlagTiltLoadingScreenEnterExitHold = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagTiltLoadingScreenEnterExitHold"),
	FFlagLuaAppEnableInExperienceDataModelStreamStarter = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEnableInExperienceDataModelStreamStarter"),
	FFlagEnablePinnedShortcutsOnHomeScreenLua = game:DefineFastFlag(
		"EnablePinnedShortcutsOnHomeScreenLua2",
		false
	),
	FFlagSduiPinShortcutAction = game:DefineFastFlag("SduiPinShortcutAction", false),
	FFlagEdpPinnedShortcutsLogExposure = game:DefineFastFlag("EdpPinnedShortcutsLogExposure", false),
	FStringEdpPinnedShortcutsIxpLayer = game:DefineFastString(
		"EdpPinnedShortcutsIxpLayer",
		"Social.ExperienceDetailsContextualMenu"
	),
	FFlagSduiOpenIncomingTransferUpsellAction = game:DefineFastFlag(
		"SduiOpenIncomingTransferUpsellAction",
		false
	),
	FFlagSduiResetHoverOnExperienceLaunch = game:DefineFastFlag("SduiResetHoverOnExperienceLaunch", false),
	FFlagResetHoverTileOnGameLeave = game:DefineFastFlag("ResetHoverTileOnGameLeave", false),
	FFlagAXFixBottomNavCTAHeight = game:DefineFastFlag("AXFixBottomNavCTAHeight", false),
	FFlagSignalsRegistryOwnedFanout = defineFastFlag45,
	FFlagUnifyConsoleSettingsPage = game:DefineFastFlag("UnifyConsoleSettingsPage9", false),
	FFlagFixDoubleBackNav = game:DefineFastFlag("FixDoubleBackNav", false),
	FFlagEnableFocusNavTelemetry = game:DefineFastFlag("EnableFocusNavTelemetry", false),
	FFlagEnableSettingsTelemetry = game:DefineFastFlag("EnableSettingsTelemetry", false),
	FFlagDeferInExperienceRbxmDownload = game:GetEngineFeature("DeferInExperienceRbxmDownload"),
	FFlagEnableDeferredAssetManagerService = game:GetEngineFeature("EnableDeferredAssetManagerService"),
	FFlagCustomTitleBarM1Enabled = game:GetEngineFeature("CustomTitleBarM1Enabled"),
	FFlagAddSDUIEditProfileFramesAction = game:DefineFastFlag("AddSDUIEditProfileFramesAction", false),
	FFlagLuaSupportMicroGamepadPreferredInput = game:DefineFastFlag(
		"LuaSupportMicroGamepadPreferredInput",
		false
	),
	FFlagPinShortcutEnableOnCompleteCallback = game:GetEngineFeature("PinShortcutEnableOnCompleteCallback"),
	FFlagAddPinExperienceTargetDestinationGUACPolicy = game:DefineFastFlag(
		"AddPinExperienceTargetDestinationGUACPolicy",
		false
	),
	FFlagEnableGameJoinEarlyAccess = game:DefineFastFlag("EnableGameJoinEarlyAccess", false),
	FFlagEnablePlusReferralDashboard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralDashboard"),
	FFlagEnablePlusReferralFlyoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralFlyoutEntry"),
	FFlagEnablePlusReferralDashboardDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralDashboardDeepLink"),
	FFlagEnableNonCollectiblePurchaseCountersLua = game:DefineFastFlag(
		"EnableNonCollectiblePurchaseCountersLua",
		false
	),
	FFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralLandingSheet"),
	FFlagEnablePlusReferralRecipientFlyoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralRecipientFlyoutEntry"),
	FIntPlusReferralRewardRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FIntPlusReferralRewardRobux"),
	FFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusReferralEntrypointTelemetry"),
	FFlagFixPlusReferralButtonLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFixPlusReferralButtonLayout"),
	FFlagEnableCommunitiesHttpDeepLink = game:DefineFastFlag("EnableCommunitiesHttpDeepLink2", false) and game:GetEngineFeature("ExternalOriginOnlyUrlRegistration"),
	FFlagEnablePlusWebviewDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnablePlusWebviewDeepLink"),
	FFlagResponsiveUnitsDeprecateTenFoot = game:DefineFastFlag("ResponsiveUnitsDeprecateTenFoot", false),
	FFlagHomeFriendNamesUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagHomeFriendNamesUseUserProfileHydration"),
	FFlagAppChatEnableReactions = game:DefineFastFlag("AppChatEnableReactions", false),
	FFlagGameInviteInExpJoinCta3 = game:DefineFastFlag("GameInviteInExpJoinCta3", false),
	FFlagNavigationCallbackParam = game:DefineFastFlag("NavigationCallbackParam", false),
	FFlagUseUIOverlayForCloudPlay = game:DefineFastFlag("UseUIOverlayForCloudPlay", false),
	FFlagFriendsDeepLinkInitialFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagFriendsDeepLinkInitialFilter"),
	FFlagAppCompositionContainerWidth = game:DefineFastFlag("AppCompositionContainerWidth", false)
}
