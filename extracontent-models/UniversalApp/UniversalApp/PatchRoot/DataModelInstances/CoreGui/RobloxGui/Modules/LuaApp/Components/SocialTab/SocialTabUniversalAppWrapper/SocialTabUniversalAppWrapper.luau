local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy
local withStyle = UIBlox.Style.withStyle
local Contexts = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Contexts
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = script:FindFirstAncestor("Modules")
local AppPage = require(Modules.LuaApp.AppPage)
local User = require(Modules.LuaApp.Models.User)
local joinGame = require(Modules.LuaApp.Util.joinGame)
local Config = require(Modules.LuaApp.Config)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local PerformanceTesting = require(Modules.LuaApp.PerformanceTesting)
local RobloxEventReceiver = require(CorePackages.Workspace.Packages.RealtimeDelivery).RobloxEventReceiver
local SetAppLoaded = require(CorePackages.Workspace.Packages.AppChat.SetAppLoaded)
local SquadAppChatEventReceiver = require(CorePackages.Workspace.Packages.SquadsCore.Components).SquadAppChatEventReceiver
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local llama = require(CorePackages.Packages.LuaSocialLibrariesDeps).llama
local formatUser = require(script.Parent.Parent.utils.formatUser)
local ChatEventReceiver = require(CorePackages.Workspace.Packages.AppChat.ChatEventReceiver)
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local Signal = require(Modules.Common.Signal)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local AndroidBackButtonConnection = require(CorePackages.Workspace.Packages.SocialTab).AndroidBackButtonConnection
local EnumScreens = require(CorePackages.Workspace.Packages.SocialTab).EnumScreens
local Container = require(Modules.LuaApp.Components.SocialTab.SocialTabLoader.Container)
local Context = require(Modules.LuaApp.Components.SocialTab.SocialTab).Context
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local PlayerSearch = require(Modules.LuaApp.Components.UserSearch.Players.PlayerSearch)
local OffPlatformFriendRequestsIXP = require(CorePackages.Workspace.Packages.ContactImporter).Flags.OffPlatformFriendRequestsIXP
local NotificationsUpsell = require(CorePackages.Workspace.Packages.NotificationsUpsell)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local EntryPoint = require(CorePackages.Workspace.Packages.AppChat.EntryPoint)
local Container2 = require(Modules.LuaApp.Components.Chat.ExternalNavigationHandler.Container)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useIsStickyShortcutBarEnabled = require(CorePackages.Workspace.Packages.AppShortcutBar).Hooks.useIsStickyShortcutBarEnabled
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local ConvertUniverseIdToString = SharedFlags.ConvertUniverseIdToString
local CommunityListExperimentation = require(CorePackages.Workspace.Packages.Groups).Experiments.CommunityListExperimentation
local GetFFlagEnableCommunityListExperimentation = SharedFlags.GetFFlagEnableCommunityListExperimentation
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local withThrottleFramerateGivenPolicy = require(Modules.LuaApp.Common.withThrottleFramerateGivenPolicy)
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local default2 = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local v59 = game:DefineFastFlag("SocialTabShouldRequestPushPermissions", false)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local GetFFlagEnablePushNotificationsUpsellModal = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnablePushNotificationsUpsellModal
local v62 = game:DefineFastFlag("PushUpsellExposureLogFix", false)
local GetFStringPushUpsellVariantName = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringPushUpsellVariantName
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local FFlagLuaAppEnableStickyShortcutBar = SharedFlags.FFlagLuaAppEnableStickyShortcutBar
local FFlagContactImporterIXPCleanup = SharedFlags.FFlagContactImporterIXPCleanup
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagFixSocialTabBottomBarCutOff = require(Modules.LuaApp.Flags.FFlagFixSocialTabBottomBarCutOff)
local FFlagGuacStickyShortcutBarEnabled = SharedFlags.FFlagGuacStickyShortcutBarEnabled
local v71 = Roact.PureComponent:extend("SocialTabUniversalAppWrapper")

v71.defaultProps = {
	renderSocialTab = function() -- line: 105
		-- upvalues: Roact (copy), Container (copy)
		return Roact.createElement(Container)
	end,
	renderRoactChat = function() -- line: 108
		-- upvalues: Context (copy), Roact (copy), EntryPoint (copy)
		return Context.with(function(p1) -- line: 109
			-- upvalues: Roact (copy), EntryPoint (copy)
			return p1.wasEverVisible and Roact.createElement(EntryPoint, p1) or nil
		end)
	end,
	runService = RunService
}

function v71.init(p2) -- line: 117
	-- upvalues: Roact (copy), AndroidBackButtonConnection (copy), NotificationType (copy), Signal (copy), PerformanceTesting (copy), RobloxEventReceiver (copy), Container2 (copy), Logger (copy), RoactNavigation (copy), EnumScreens (copy), llama (copy), AppPage (copy), GetFFlagEnableCommunityListExperimentation (copy), CommunityListExperimentation (copy), formatUser (copy), FFlagCreateConnectionsHub (copy), Contexts (copy), SearchTypes (copy), GetFFlagIsSquadEnabled (copy), PlayerSearch (copy), RunService (copy), GetDefaultQualityLevel (copy), FFlagShareTargetGameCleanup (copy), v59 (copy), GetFFlagEnablePushNotificationsUpsellModal (copy), v62 (copy), NotificationsUpsell (copy), default2 (copy), default (copy), memoize (copy), UserInputService (copy), EntryPoint (copy), useRoactService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), joinGame (copy), OpenGameDetails (copy), NavigateDown (copy), User (copy), ConvertUniverseIdToString (copy), SetAppLoaded (copy), Config (copy), FFlagContactImporterIXPCleanup (copy)
	p2.state = {
		wasChatEverTapped = p2.props.isVisible,
		externalNavigationByScreen = {}
	}
	p2.chatToastRef = Roact.createRef()
	p2.androidBackButtonConnection = AndroidBackButtonConnection(p2.props.guiService, NotificationType)
	p2.androidBackButtonConnectionSocialTab = AndroidBackButtonConnection(p2.props.guiService, NotificationType)
	p2._rnBypassActionSignal = Signal.new()
	p2._rnBypassActionSignalSocialTab = Signal.new()
	p2.backButtonEnabled = false
	p2._performanceTesting = PerformanceTesting
	p2._robloxEventReceiver = RobloxEventReceiver.new(p2.props.notificationService)

	function p2.renderOnLoaded() -- line: 144
		-- upvalues: p2 (copy), Roact (copy), Container2 (copy)
		if not p2.state.wasChatEverTapped then
			return nil
		end

		return Roact.createFragment({
			screen = p2.props.renderSocialTab(),
			externalNavigation = Roact.createElement(Container2, {
				navigationByScreen = p2.state.externalNavigationByScreen
			})
		})
	end
	function p2.setBackButtonEnabled(p3) -- line: 157
		-- upvalues: p2 (copy)
		p2.backButtonEnabled = p3
	end
	function p2.setTabBarVisibleFromChat(p4) -- line: 161
		-- upvalues: p2 (copy)
		local v107 = not not p2.props.shouldSystemBarUsuallyBePresent or p4

		p2.props.setTabBarVisibleFromChat(v107)
	end
	function p2.setActiveConversationId(p5) -- line: 166
		-- upvalues: Logger (copy), p2 (copy), Roact (copy)
		Logger:debug("{} setting activeConversationId as {}", script.Name, p5)
		p2:setState({
			activeConversationId = p5 or Roact.None
		})
	end
	function p2.getActiveConversationId() -- line: 173
		-- upvalues: p2 (copy)
		return p2.state.activeConversationId
	end
	function p2.initRoactChatNavigation() -- line: 178
		-- upvalues: p2 (copy), RoactNavigation (copy), EnumScreens (copy)
		p2._rnBypassActionSignalSocialTab:fire(RoactNavigation.Actions.navigate({
			routeName = EnumScreens.RoactChat
		}))
	end
	function p2.updateExternalNavigationForScreen(p6, p7) -- line: 184
		-- upvalues: p2 (copy), llama (copy)
		p2:setState(function(p8, _) -- line: 185
			-- upvalues: p6 (copy), llama (copy), p7 (copy)
			if p6 then
				return {
					externalNavigationByScreen = llama.Dictionary.join(p8.externalNavigationByScreen, {
						[p7] = p6
					})
				}
			end

			local v145 = llama.Dictionary.copy(p8.externalNavigationByScreen)

			v145[p7] = nil

			return {
				externalNavigationByScreen = v145
			}
		end)
	end
	function p2.navigateDownToNotifications(p10) -- line: 202
		-- upvalues: p2 (copy)
		local u112 = p10 or false

		p2.props.navigateDownToNotifications(function() -- line: 205
			-- upvalues: u112 (ref), p2 (copy)
			if u112 then
				p2.setTabBarVisibleFromChat(true)
			end
		end)
	end
	function p2.navigateToCoHubAddConnections() -- line: 212
		-- upvalues: p2 (copy), AppPage (copy)
		p2.props.navigation.navigate(AppPage.CoHubAddConnections)
	end
	function p2.openProfileWebView(p11) -- line: 216
		-- upvalues: p2 (copy)
		p2.props.navigateDownToViewUserProfile(p11, function() -- line: 217
			-- upvalues: p2 (copy)
			if p2.props.wideMode then
				p2.setTabBarVisibleFromChat(p2.props.wideMode)
			end
		end)
	end
	function p2.openProfilePeekView(p12, p13) -- line: 224
		-- upvalues: p2 (copy)
		p2.props.openProfilePeekView(p12, {
			resetPeekView = true,
			onClose = function() -- line: 226
				-- upvalues: p2 (copy), p13 (copy)
				if p2.state.getIsTabBarEnabled then
					p2.setTabBarVisibleFromChat(p2.state.getIsTabBarEnabled())
				end

				if p13 and p13.onClose then
					p13.onClose()
				end
			end,
			onOpen = function() -- line: 235
				-- upvalues: p2 (copy), p13 (copy)
				p2.setTabBarVisibleFromChat(false)

				if p13 and p13.onOpen then
					p13.onOpen()
				end
			end
		})
	end
	function p2.navigateDownToReportAbuse(p14, p15) -- line: 245
		-- upvalues: p2 (copy)
		if p2.props.useLuafiedReportFlow then
			p2.props.openReportDialog(p14, p15)

			return
		end

		p2.props.navigateDownToReportAbuse(p14, p15)
	end
	function p2.navigateDownToPrivacySettings() -- line: 253
		-- upvalues: p2 (copy)
		p2.props.navigateDownToPrivacySettings()
	end
	function p2.navigateDownToGroups() -- line: 257
		-- upvalues: p2 (copy), GetFFlagEnableCommunityListExperimentation (copy), CommunityListExperimentation (copy)
		local function v118() -- line: 258
			-- upvalues: p2 (copy)
			p2.setTabBarVisibleFromChat(true)
		end

		if GetFFlagEnableCommunityListExperimentation() then
			CommunityListExperimentation.logExposure()
		end

		if GetFFlagEnableCommunityListExperimentation() and CommunityListExperimentation.getCommunityListEnabled() then
			p2.props.openGroupsListPage(v118)

			return
		end

		p2.props.navigateDownToGroups(v118)
	end
	function p2.navigateDownToAddFriends() -- line: 275
		-- upvalues: p2 (copy)
		p2.props.navigateDownToAddFriends(function() -- line: 276
			-- upvalues: p2 (copy)
			p2.setTabBarVisibleFromChat(true)
		end)
	end
	function p2.navigateToHomePage() -- line: 281
		-- upvalues: p2 (copy), AppPage (copy)
		p2.props.navigation.navigate(AppPage.Home)
	end
	function p2.FriendFinder() -- line: 285
		-- upvalues: p2 (copy)
		p2.props.navigateDownToFriendFinder(function() -- line: 286
			-- upvalues: p2 (copy)
			p2.setTabBarVisibleFromChat(true)
		end)
	end
	function p2.AddFriendsAccountProvider(p16) -- line: 291
		-- upvalues: p2 (copy)
		p2.props.navigateDownToAddFriendsAccountProvider(p16)
	end
	function p2.setIsTabBarEnabled(p17) -- line: 295
		-- upvalues: p2 (copy)
		p2:setState({
			getIsTabBarEnabled = p17
		})
	end
	function p2.openUserContextualMenu(p18) -- line: 301
		-- upvalues: llama (copy), p2 (copy), formatUser (copy)
		local onClose = p18.onClose
		local v123 = llama.Dictionary.join(p18, {
			onCloseGameDetails = function() -- line: 305
				-- upvalues: p2 (copy)
				p2.setTabBarVisibleFromChat(true)
			end,
			onClose = function() -- line: 308
				-- upvalues: onClose (copy)
				if onClose then
					onClose()
				end
			end,
			onCloseProfileWebview = function() -- line: 313
				-- upvalues: p2 (copy)
				p2.setTabBarVisibleFromChat(true)
			end,
			user = formatUser(p18.user)
		})

		p2.props.openContextualMenu(v123)
	end
	function p2.navigateToUserInfo(p19, p20) -- line: 322
		-- upvalues: p2 (copy), llama (copy), formatUser (copy)
		if not p20 then
			p2.openProfileWebView(p19)

			return
		end

		local v126 = p20.contextualMenuProps or {}

		if p20.contextualMenuProps then
			v126 = llama.Dictionary.join(v126, {
				onCloseGameDetails = function() -- line: 331
					-- upvalues: p2 (copy)
					p2.setTabBarVisibleFromChat(true)
				end,
				onClose = function() -- line: 334
					-- upvalues: p20 (copy)
					if p20.contextualMenuProps.onClose then
						p20.contextualMenuProps.onClose()
					end
				end,
				onCloseProfileWebview = function() -- line: 339
					-- upvalues: p2 (copy)
					p2.setTabBarVisibleFromChat(true)
				end,
				user = formatUser(p20.contextualMenuProps.user)
			})
		end

		local v127 = llama.Dictionary.join(p20.profilePeekViewProps or {}, {
			resetPeekView = true,
			onClose = function() -- line: 348
				-- upvalues: p2 (copy), p20 (copy)
				if p2.state.getIsTabBarEnabled then
					p2.setTabBarVisibleFromChat(p2.state.getIsTabBarEnabled())
				end

				if p20.profilePeekViewProps and p20.profilePeekViewProps.onClose then
					p20.profilePeekViewProps.onClose()
				end
			end,
			onOpen = function() -- line: 356
				-- upvalues: p2 (copy), p20 (copy)
				p2.setTabBarVisibleFromChat(false)

				if p20.profilePeekViewProps and p20.profilePeekViewProps.onOpen then
					p20.profilePeekViewProps.onOpen()
				end
			end,
			source = p20.source
		})

		p2.props.navigateToUserInfo(p19, {
			contextualMenuProps = v126,
			profilePeekViewProps = v127,
			openJoinable = p20.openJoinable,
			entryPoint = p20.entryPoint
		})
	end

	p2.navigateToLuaAppPages = {
		[EnumScreens.GameDetail] = p2.props.navigateToGameDetails,
		[EnumScreens.ViewUserProfile] = p2.navigateToUserInfo,
		[EnumScreens.Notifications] = p2.navigateDownToNotifications,
		[EnumScreens.LearnMore] = p2.props.openLearnMoreLink,
		[EnumScreens.ReportAbuse] = p2.navigateDownToReportAbuse,
		[EnumScreens.PrivacySettings] = p2.navigateDownToPrivacySettings,
		[EnumScreens.CoHubAddConnections] = if not FFlagCreateConnectionsHub then nil else p2.navigateToCoHubAddConnections,
		[EnumScreens.AddFriends] = p2.navigateDownToAddFriends,
		[EnumScreens.Groups] = p2.navigateDownToGroups,
		[EnumScreens.FriendFinder] = p2.FriendFinder,
		[EnumScreens.AddFriendsAccountProvider] = p2.AddFriendsAccountProvider,
		[EnumScreens.ViewUser] = p2.openUserContextualMenu,
		[EnumScreens.VerifiedBadgeModal] = p2.props.openVerifiedBadgeModal,
		[EnumScreens.DiscoverabilityModal] = p2.props.openDiscoverabilityModal,
		[EnumScreens.ProfileQRCode] = function() -- line: 400
			-- upvalues: p2 (copy), Contexts (copy)
			p2.props.navigateTo3DQRCodePage({
				source = Contexts.AddFriends
			})
		end,
		[EnumScreens.SearchPage] = function() -- line: 405
			-- upvalues: p2 (copy), AppPage (copy), SearchTypes (copy)
			p2.props.navigation.navigate(AppPage.SearchPage, {
				defaultSearchType = SearchTypes.Players
			})
		end,
		[EnumScreens.AmpWizardContainer] = p2.props.openAmpWizardContainer,
		[EnumScreens.Home] = if not GetFFlagIsSquadEnabled() then nil else p2.navigateToHomePage
	}
	p2.luaAppPages = {
		playerSearchPage = PlayerSearch
	}

	local connection = nil

	connection = RunService.RenderStepped:Connect(function() -- line: 422
		-- upvalues: connection (ref), GetDefaultQualityLevel (copy)
		if connection then
			connection:Disconnect()
		end

		settings().Rendering.QualityLevel = GetDefaultQualityLevel()
	end)

	function p2.onBackButtonPressed() -- line: 433
		-- upvalues: p2 (copy), RoactNavigation (copy)
		if p2.props.canGoBack then
			p2.props.navigateBack()

			return
		end

		if p2.backButtonEnabled then
			p2._rnBypassActionSignal:fire(RoactNavigation.Actions.back())

			return
		end

		p2.androidBackButtonConnection.showExitDialog()
	end
	function p2.isAndroidBackButtonHandlerDisabled(p21) -- line: 443
		-- upvalues: AppPage (copy), FFlagShareTargetGameCleanup (copy)
		return p21 == AppPage.GameDetail or (((if not FFlagShareTargetGameCleanup then p21 == AppPage.ShareGameToChat else nil)) or (p21 == AppPage.AvatarExperienceWrapperTransparent or (p21 == AppPage.AvatarExperienceWrapper or p21 == AppPage.ProfilePlatform)))
	end

	p2._navigatingFromSocialTabEvent = nil

	function p2.setNavigatingFromSocialTabEvent(p22) -- line: 453
		-- upvalues: p2 (copy), EnumScreens (copy)
		p2._navigatingFromSocialTabEvent = {
			startTime = os.clock(),
			startPage = EnumScreens.SocialTab,
			endPage = p22
		}
	end
	function p2.getNavigatingFromSocialTabEvent() -- line: 461
		-- upvalues: p2 (copy)
		return p2._navigatingFromSocialTabEvent
	end

	if v59 then
		local v77 = p2.props.shouldShowPushUpsell and p2.props.notificationsCanReceivePush

		if GetFFlagEnablePushNotificationsUpsellModal and v77 then
			if p2.props.pushUpsellVariant ~= nil then
				if if not v62 then p2.props.pushUpsellVariant > -1 else p2.props.pushUpsellVariant == 0 then
					local PushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
					local ModalEventConstants = NotificationsUpsell.ModalEventConstants

					default2:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
						[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
						[ModalEventConstants.EntryPoint] = AppPage.Chat
					})
				end

				if p2.props.pushUpsellVariant <= 0 then
					local t1 = { default.Permissions.POST_NOTIFICATIONS }

					default:requestPermissions(t1)
				end
			end
		elseif v77 then
			local t2 = { default.Permissions.POST_NOTIFICATIONS }

			default:requestPermissions(t2)
		end
	end

	p2.generateContext = memoize(function(p23, p24, p25, p26, p27, p28, p29, p30, p31, p32) -- line: 501
		-- upvalues: p2 (copy), Logger (copy), UserInputService (copy), EntryPoint (copy), Signal (copy), useRoactService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), joinGame (copy), OpenGameDetails (copy), NavigateDown (copy), User (copy), AppPage (copy), ConvertUniverseIdToString (copy), SetAppLoaded (copy), Config (copy), PerformanceTesting (copy), NotificationType (copy), FFlagContactImporterIXPCleanup (copy)
		return {
			wasEverVisible = p2.state.wasEverVisible,
			localUserId = p24,
			isVisible = p23,
			pageType = p27,
			parameters = p28,
			navigationProps = p25,
			logger = Logger,
			navigateToLuaAppPages = p2.navigateToLuaAppPages,
			rnBypassActionSignal = p2._rnBypassActionSignal,
			rnBypassActionSignalSocialTab = p2._rnBypassActionSignalSocialTab,
			getActiveConversationId = p2.getActiveConversationId,
			setActiveConversationId = p2.setActiveConversationId,
			setBackButtonEnabled = p2.setBackButtonEnabled,
			setTabBarVisible = p2.setTabBarVisibleFromChat,
			luaAppPages = p2.luaAppPages,
			wideMode = p29,
			notificationCount = p26,
			robloxEventReceiver = p2._robloxEventReceiver,
			userInputService = UserInputService,
			roactChatEntryPoint = EntryPoint,
			androidBackButtonConnection = p2.androidBackButtonConnectionSocialTab,
			signal = Signal,
			androidBackButtonHandlerDisabled = p2.isAndroidBackButtonHandlerDisabled(p30),
			setIsTabBarEnabled = p31 and p2.setIsTabBarEnabled or nil,
			isLuaProfilePageEnabled = p31,
			useRoactService = useRoactService,
			roactAnalytics = RoactAnalytics,
			roactAnalyticsCommonGameEvents = RoactAnalyticsCommonGameEvents,
			joinGame = joinGame,
			openGameDetails = OpenGameDetails,
			navigateDown = NavigateDown,
			presenceType = User.PresenceType,
			appPage = AppPage,
			convertUniverseIdToString = ConvertUniverseIdToString,
			setNavigatingFromSocialTabEvent = p2.setNavigatingFromSocialTabEvent,
			getNavigatingFromSocialTabEvent = p2.getNavigatingFromSocialTabEvent,
			luaAddFriendsPageEnabled = p32,
			setAppLoaded = SetAppLoaded,
			fetchUnreadConversationCount = p2.props.fetchUnreadConversationCount,
			notificationService = p2.props.notificationService,
			config = Config,
			toggleChatPaused = p2.props.toggleChatPaused,
			performanceTesting = PerformanceTesting,
			notificationType = NotificationType,
			contactImporterAndPYMKEnabled = if not FFlagContactImporterIXPCleanup then p2.props.contactImporterAndPYMKEnabled and p2.props.isContactImporterPolicyEnabled or nil else nil,
			diagService = p2.props.roactAnalytics.Diag,
			eventIngestService = p2.props.eventIngestService,
			openProfilePeekView = p2.props.openProfilePeekView,
			closeCentralOverlay = p2.props.closeCentralOverlay,
			openLearnMoreLink = p2.props.openLearnMoreLink,
			showToast = p2.props.showToast,
			updateExternalNavigationForScreen = p2.updateExternalNavigationForScreen,
			initialRouteName = p2.props.initialRouteName,
			openPlayerContextualMenu = p2.props.openPlayerContextualMenu
		}
	end)
end
function v71.render(p33) -- line: 587
	-- upvalues: withStyle (copy), Roact (copy), Context (copy), FullscreenPageWithSafeArea (copy), FFlagFixSocialTabBottomBarCutOff (copy), AppNavBar (copy), ChatEventReceiver (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
	return withStyle(function(_) -- line: 590
		-- upvalues: p33 (copy), Roact (copy), Context (copy), FullscreenPageWithSafeArea (copy), FFlagFixSocialTabBottomBarCutOff (copy), AppNavBar (copy), ChatEventReceiver (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
		local initRoactChatNavigation = p33.initRoactChatNavigation

		return Roact.createElement(Context.Provider, {
			value = p33.generateContext(p33.props.isVisible, p33.props.localUserId, p33.props.navigationProps, p33.props.notificationCount, p33.props.pageType, p33.props.parameters, p33.props.wideMode, p33.props.currentAppPage, true, p33.props.luaAddFriendsPageEnabled)
		}, {
			SocialTab = Roact.createElement(FullscreenPageWithSafeArea, {
				BorderSizePixel = 0,
				includeStatusBar = true,
				BackgroundColor3 = p33.props.BackgroundColor,
				BackgroundTransparency = p33.props.BackgroundTransparency,
				useFullScalePage = p33.props.useFullScalePage,
				includeBottomBar = if not FFlagFixSocialTabBottomBarCutOff then p33.props.wideMode and p33.props.navBarPlacement == AppNavBar.Placement.Bottom else p33.props.navBarPlacement == AppNavBar.Placement.Bottom and p33.props.bottomBarVisible ~= false
			}, {
				ChatEventReceiver = Roact.createElement(ChatEventReceiver, {
					robloxEventReceiver = p33._robloxEventReceiver,
					rnBypassActionSignal = p33._rnBypassActionSignal,
					initRoactChatNavigation = initRoactChatNavigation,
					activeConversationId = p33.state.activeConversationId
				}),
				SocialTab = p33.renderOnLoaded(),
				SquadAppChatEventReceiver = if not FFlagSquadAppChatRTNFix then nil else Roact.createElement(SquadAppChatEventReceiver)
			})
		})
	end)
end
function v71.didMount(p35) -- line: 633
	-- upvalues: Logger (copy)
	Logger:info("Initializing SocialTabUniversalAppWrapper")

	if p35.props.isVisible and p35.props.toggleChatPaused ~= nil then
		p35.props.toggleChatPaused(false)
	end
end
function v71.didUpdate(p36, p37, _) -- line: 643
	-- upvalues: Config (copy)
	if p37.isVisible ~= p36.props.isVisible then
		p36.androidBackButtonConnection.disconnect()

		if not p37.isVisible then
			p36._performanceTesting:Initialize()
			p36.props.setThrottleFramerateEnabled(Config.General.PerformanceTestingMode == Enum.VirtualInputMode.None)
			p36.props.toggleChatPaused(false)

			return
		end

		p36._performanceTesting:Stop()
		p36.props.setThrottleFramerateEnabled(false)
		p36.props.toggleChatPaused(true)
	end
end
function v71.getDerivedStateFromProps(p39, p40) -- line: 659
	-- upvalues: RetrievalStatus (copy)
	local v89 = nil
	local v90 = nil
	local v91 = nil

	if p39.isVisible then
		v89 = true
	end

	if p39.retrievalStatus == RetrievalStatus.Done then
		v90 = true
	end

	if p40.wasChatEverTapped == false and p39.isVisible == true then
		v91 = true
	end

	return {
		wasChatEverTapped = v91,
		wasEverVisible = v89,
		wasEverDoneRetrieving = v90
	}
end
function v71.willUnmount(p41) -- line: 683
	p41.androidBackButtonConnection.disconnect()
end

local v72 = withThrottleFramerateGivenPolicy((UniversalAppPolicy.connect(function(p42) -- line: 688
	-- upvalues: GetFFlagLuafiedReportEntryPoints (copy)
	return {
		isContactImporterPolicyEnabled = p42.getContactImporterEnabled(),
		shouldSystemBarUsuallyBePresent = p42.getShouldSystemBarUsuallyBePresent(),
		useLuafiedReportFlow = if not GetFFlagLuafiedReportEntryPoints() then nil else p42.getUseLuafiedReportFlow(),
		shouldShowPushUpsell = p42.getPushNotificationsUpsell(),
		notificationsCanReceivePush = p42.getNotificationsCanReceivePush()
	}
end)(v71)))
local u73 = RoactAppExperiment.connectUserLayer({
	AppUserLayers.SocialFriendsLayer,
	AppUserLayers.PushNotificationPrompt
}, function(p43, _) -- line: 703
	-- upvalues: AppUserLayers (copy), FFlagContactImporterIXPCleanup (copy), OffPlatformFriendRequestsIXP (copy), GetFStringPushUpsellVariantName (copy), GetFFlagEnablePushNotificationsUpsellModal (copy)
	local v96 = p43[AppUserLayers.SocialFriendsLayer] or {}
	local v97 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.getExperimentVariant(p43) else nil
	local v98 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.experimentOrRolloutEnabled(p43) else nil
	local v99 = p43[AppUserLayers.PushNotificationPrompt] or {}
	local v100 = GetFStringPushUpsellVariantName()

	return {
		luaAddFriendsPageEnabled = v96.show_lua_add_friends_page == "True",
		contactImporterAndPYMKEnabled = if not FFlagContactImporterIXPCleanup then v98 else nil,
		contactImporterExperimentVariant = if not FFlagContactImporterIXPCleanup then v97 else nil,
		pushUpsellVariant = if not GetFFlagEnablePushNotificationsUpsellModal() then nil else v99[v100] or -1
	}
end)(v72)

local function SocialTabUniversalAppWrapperContainer(p45) -- line: 725
	-- upvalues: useNavBarPlacement (copy), FFlagGuacStickyShortcutBarEnabled (copy), useAppPolicy (copy), FFlagLuaAppEnableStickyShortcutBar (copy), useIsStickyShortcutBarEnabled (copy), Roact (copy), u73 (ref), Cryo (copy)
	local v102 = useNavBarPlacement()
	local v103 = if not FFlagGuacStickyShortcutBarEnabled then if not FFlagLuaAppEnableStickyShortcutBar then nil else useIsStickyShortcutBarEnabled() else useAppPolicy(function(p46) -- line: 730
		return p46.getStickyShortcutBarEnabled()
	end)

	return Roact.createElement(u73, Cryo.Dictionary.join(p45, {
		navBarPlacement = v102,
		useFullScalePage = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else v103
	}))
end

return SocialTabUniversalAppWrapperContainer
