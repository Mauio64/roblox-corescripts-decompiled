local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local AccessResponseEnum = require(CorePackages.Workspace.Packages.AmpUpsell).AmpEnums.AccessResponseEnum
local AppBrowserService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppBrowserService
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local AmpApiProvider = require(CorePackages.Workspace.Packages.AmpUpsell).AmpApiProvider
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local Cryo = require(CorePackages.Packages.Cryo)
local DeepLink = require(CorePackages.Workspace.Packages.DeepLink)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local NavigateIntoAvatarExperience = require(Modules.AvatarExperience.Common.Thunks.NavigateIntoAvatarExperience)
local NavigateIntoChatThunk = require(CorePackages.Workspace.Packages.AppChat.NavigateIntoChatThunk)
local ShowFAESocialUpsellOverlay = require(CorePackages.Workspace.Packages.SocialUpsell).Thunks.ShowFAESocialUpsellOverlay
local startFacialAgeEstimation = require(CorePackages.Workspace.Packages.SocialUpsell).Thunks.startFacialAgeEstimation
local NavigateIntoSquadLobbyIfExists = require(CorePackages.Workspace.Packages.AppChat.NavigateIntoSquadLobbyIfExists)
local Promise = require(Modules.LuaApp.Promise)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsShareLinks = require(Modules.LuaApp.Services.RoactAnalyticsShareLinks)
local RoactAnalyticsSocialProfileShare = require(Modules.LuaApp.Services.RoactAnalyticsSocialProfileShare)
local EnteredChatFromEntryPoint = require(CorePackages.Workspace.Packages.AppChat.EnteredChatFromEntryPoint)
local QualifiedSignUpAttribution = require(CorePackages.Workspace.Packages.AffiliateLinks).QualifiedSignUpAttribution
local AuthenticatedVisitAttribution = require(CorePackages.Workspace.Packages.AffiliateLinks).AuthenticatedVisitAttribution
local SocialUpsellType = require(CorePackages.Workspace.Packages.SocialUpsell).Enums.SocialUpsellType
local UpsellComponent = require(CorePackages.Workspace.Packages.SocialUpsell).Analytics.Enum.UpsellComponent
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local DeepLinkMap = require(Modules.LuaApp.DeepLinks.DeepLinkMap)
local DeepLinkParser = require(Modules.LuaApp.DeepLinks.DeepLinkParser)
local EventNetworking = require(script.Parent.EventNetworking)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local LaunchGame = require(CorePackages.Workspace.Packages.GameLaunch).LaunchGame
local ShareLinkTypes = require(Modules.LuaApp.DeepLinks.ShareLinks.ShareLinkTypes)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy
local GetFFlagEnableAffiliateLinksQualifiedSignUpTracking = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAffiliateLinksQualifiedSignUpTracking
local FFlagSignalsNavP3cEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3cEvents
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v55 = if not FFlagSignalsNavP3cEvents then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v56 = if not FFlagSignalsNavP3cEvents then nil else require(Modules.LuaApp.Navigation.AppNavigation)
local v57 = game:DefineFastFlag("DeeplinkNavDurationLog", false)
local GetFFlagEnableUnifiedWebViews = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableUnifiedWebViews
local FFlagTCUpdateProfileCTAButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCUpdateProfileCTAButton
local refreshProfilePlatformActionInfo = require(CorePackages.Workspace.Packages.ProfilePlatform.refreshProfilePlatformActionInfo)
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(CorePackages.Workspace.Packages.ProfilePlatform.FFlagProfilePlatformRefreshActionsRespectPolicies)
local buildUserActionsComponent = require(CorePackages.Workspace.Packages.ProfilePlatform.buildUserActionsComponent)
local v63 = game:DefineFastFlag("DeeplinkTelemetryCounters", false)
local v64 = game:DefineFastFlag("CloseModalsWhenDeeplinking", false)
local v65 = game:DefineFastFlag("EnableExperienceInviteLinkTypeAttribution", false)
local v66 = game:DefineFastString("JoinCodePattern", ".*/join/([%w]+)")
local FFlagEnableSquadDeeplinkWithChatId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSquadDeeplinkWithChatId
local FFlagEnableAmpWizardDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAmpWizardDeepLink
local OpenAmpWizardContainer = nil

if FFlagEnableAmpWizardDeepLink then
	OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer
end

local FFlagEnableAuthDeepLinkReceiver = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAuthDeepLinkReceiver
local FFlagEnableDeepLinkHistoryWithModalAPI = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableDeepLinkHistoryWithModalAPI
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagStreamNotificationDropdownSingleOwner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStreamNotificationDropdownSingleOwner
local StreamNotificationStore = require(CorePackages.Workspace.Packages.StreamNotifications).StreamNotificationStore
local v75 = game:DefineFastFlag("EnableJoinLinkAttribution", false)
local simpleUrlDecode = require(CorePackages.Workspace.Packages.SocialCommon).Utils.simpleUrlDecode
local v77 = DeepLinkParser.new(DeepLinkMap)
local ParseQuery = require(CorePackages.Packages.StringUtilities).ParseQuery
local v79 = game:DefineFastString("SocialCommsRestrictionsNamespace", "social/CommunicationRestrictions")
local v80 = game:DefineFastString("EligibleForCommsAgeVerificationUpsellFeatureName", "EligibleForCommsAgeVerificationUpsell")
local v81 = game:DefineFastFlag("EnableDeepLinkWaitForNavigationUnlock2", false)
local FFlagEnableSearchDeepLink = require(Modules.LuaApp.Flags.FFlagEnableSearchDeepLink)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local useSetDrawerVisible = nil

if FFlagEnableFlyoutSidePanel then
	useSetDrawerVisible = require(CorePackages.Workspace.Packages.Drawer).Hooks.useSetDrawerVisible
end

local PostAuthDeepLinkAvailableSignal = require(CorePackages.Workspace.Packages.AuthCommon).EventReceivers.PostAuthDeepLinkAvailableSignal
local PostAuthPendingLuaUrlAvailableSignal = require(CorePackages.Workspace.Packages.AuthCommon).EventReceivers.PostAuthPendingLuaUrlAvailableSignal

local function getQueryParams(s1: string) -- line: 140
	-- upvalues: simpleUrlDecode (copy), ParseQuery (copy)
	local _, v99 = unpack(string.split(simpleUrlDecode(s1), "?"))

	return (ParseQuery(v99))
end
local function getFirstKeyValue(t1: {[any]: any}?, s2: string) -- line: 147
	if t1 and t1[s2] then
		return t1[s2][1]
	end

	return nil
end

function getJoinCode(p1) -- line: 151
	-- upvalues: v66 (copy)
	return (p1:match(v66))
end

local function getShareLinkType(p2) -- line: 156
	-- upvalues: ShareLinkTypes (copy), HttpService (copy)
	local v104 = string.lower(p2)

	for k, v in pairs(ShareLinkTypes) do
		if v104:find("&type=" .. string.lower(v)) then
			return k
		end

		local v107 = HttpService:UrlEncode("&type=" .. v)
		local v108 = string.gsub(v107, "%%", "%%%%")

		if v104:find((string.lower(v108))) then
			return k
		end
	end

	return nil
end
local function getScreenAndParams(p3) -- line: 176
	-- upvalues: Cryo (copy)
	local v110 = p3[#p3]

	return v110.name, (Cryo.Dictionary.join(v110.extraProps or {}, {
		detail = v110.detail
	}))
end
local function isRouteMatchByName(p4, p5) -- line: 185
	return p4 and (#p4 > 0 and (p5 and p5 == p4[1].name))
end

local v92 = Roact.Component:extend("DeepLinkEventReceiver")

function v92.UpdateConnection(p6) -- line: 192
	-- upvalues: FFlagEnableAuthDeepLinkReceiver (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), v81 (copy), default (copy), TelemetryConfigs (copy), v57 (copy)
	if not FFlagEnableAuthDeepLinkReceiver then
		if p6.props.userLoggedOut or not p6.props.appLoadingStarted then
			p6.props.linking:stopListeningForLuaURLs()

			if FFlagEnableDeepLinkHistoryWithModalAPI then
				p6.deepLinkLuaHandlerStatusStore.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Disconnected, nil)
			end
		else
			if FFlagEnableDeepLinkHistoryWithModalAPI then
				local v114 = p6.props.linking:getLastLuaURL()

				p6.deepLinkLuaHandlerStatusStore.setDeepLinkLuaPostAuthReceiverStatus(DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready, v114)
			end

			p6.props.linking:getAndClearLastPendingURL():andThen(function(p7) -- line: 212
				-- upvalues: p6 (copy)
				if not p7.hasPendingUrl then
					return
				end

				local url = p7.url
				local attributionUrl = p7.attributionUrl

				p6:logPendingLink(url, attributionUrl)
			end)
			p6.props.linking:listenForLuaURLs(function(p8, p9) -- line: 222
				-- upvalues: FFlagEnableDeepLinkHistoryWithModalAPI (copy), p6 (copy), v81 (copy), default (copy), TelemetryConfigs (copy), v57 (copy)
				if FFlagEnableDeepLinkHistoryWithModalAPI then
					p6.deepLinkLuaHandlerStatusStore.setLastDetectedPostAuthUrl(p8)
				end

				p6:logProcessedLink(p8, p9)

				if v81 and p6.props.navigationLocked then
					p6.pendingDeepLinkUrl = p8
					default:logRobloxTelemetryCounter(TelemetryConfigs.DeepLinkPendingDueToNavigationLockConfig, 1)
				else
					p6:navigate(p8)
				end

				if v57 then
					p6.props.loggingProtocol:logEvent("deeplink_navigation_begin")
				end
			end)
		end
	end

	if p6.props.userLoggedOut then
		local v115 = p6.props.linking:getLastLuaURL()

		if v115 then
			local t2 = {}

			for match, v118 in v115:gmatch("([^&=?]-)=([^&=?]+)") do
				t2[match] = v118:gsub("+", " "):gsub("%%(%x%x)", function(p10) -- line: 251
					return (string.char((tonumber(p10, 16))))
				end)
			end

			if t2.friendshipSourceType == "profileshare" then
				p6.props.socialProfileShareAnalytics.inviteePageLoad(t2.userId, "appSignIn")
			end
		end
	end
end
function v92.navigate(p11, p12) -- line: 263
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), v64 (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), FFlagTCUpdateProfileCTAButton (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), buildUserActionsComponent (copy), v77 (copy), LaunchGame (copy), Promise (copy), GetFFlagEnableUnifiedWebViews (copy), AvatarScreen (copy), getScreenAndParams (copy), AppPage (copy), FFlagEnableAmpWizardDeepLink (copy), FFlagEnableSearchDeepLink (copy)
	if FFlagEnableFlyoutSidePanel then
		p11.props.setDrawerVisible(false)
	end

	if v64 then
		if FFlagStreamNotificationDropdownSingleOwner then
			StreamNotificationStore.setActiveBellId(nil)
		end

		StreamNotificationStore.setStreamPresented(false)
		p11.props.CloseCentralOverlay()
	end

	local currentHistory = p11.props.currentHistory
	local networking = p11.props.networking
	local t3 = {
		socialProfileShareAnalytics = p11.props.socialProfileShareAnalytics,
		shareLinksAnalytics = p11.props.shareLinksAnalytics
	}
	local ResolveLinkFromLinkId = p11.props.ResolveLinkFromLinkId
	local ResolveLinkFromLinkIdV2 = p11.props.ResolveLinkFromLinkIdV2
	local CloseCentralOverlay2 = p11.props.CloseCentralOverlay
	local RefreshProfilePlatformActionInfo = p11.props.RefreshProfilePlatformActionInfo

	if FFlagTCUpdateProfileCTAButton and FFlagProfilePlatformRefreshActionsRespectPolicies and RefreshProfilePlatformActionInfo then
		local props = p11.props
		local v129 = RefreshProfilePlatformActionInfo

		function RefreshProfilePlatformActionInfo(s3: string) -- line: 295
			-- upvalues: buildUserActionsComponent (copy), props (copy), v129 (copy)
			local v195 = buildUserActionsComponent(nil, {
				areWebViewsSupported = if not props.getWebViewSupport then nil else props.getWebViewSupport(),
				isProfileQrCodeEnabled = if not props.getEnableProfileQrCode then nil else props.getEnableProfileQrCode(),
				canRenderTransferInProfile = if not props.getCanRenderTransferOnProfile then nil else props.getCanRenderTransferOnProfile(),
				canSeeChatTab = if not props.getCanSeeChatTab then nil else props.getCanSeeChatTab(),
				isSelfView = props.localUserId ~= nil and tostring(s3) == tostring(props.localUserId) or nil
			})

			return v129(s3, v195)
		end
	end

	local v130 = v77:resolve(p12, {
		history = currentHistory,
		network = networking,
		analyticsImpls = t3,
		resolveLinkFromLinkId = ResolveLinkFromLinkId,
		resolveLinkFromLinkIdV2 = ResolveLinkFromLinkIdV2,
		launchGame = LaunchGame,
		closeCentralOverlay = CloseCentralOverlay2,
		RefreshProfilePlatformActionInfo = if not FFlagTCUpdateProfileCTAButton then nil else RefreshProfilePlatformActionInfo
	})

	return Promise.resolve(v130):andThen(function(p13) -- line: 329
		-- upvalues: GetFFlagEnableUnifiedWebViews (copy), p11 (copy), AvatarScreen (copy), getScreenAndParams (copy), AppPage (copy), FFlagEnableAmpWizardDeepLink (copy), FFlagEnableSearchDeepLink (copy)
		if type(p13) == "table" and next(p13) then
			local v197 = p13[#p13]

			if not GetFFlagEnableUnifiedWebViews() and p11.props.browserService then
				p11.props.browserService:CloseBrowserWindow()
			end

			local AvatarExperienceLandingPage = AvatarScreen.AvatarExperienceLandingPage

			if v197 and (#v197 > 0 and (AvatarExperienceLandingPage and AvatarExperienceLandingPage == v197[1].name)) then
				local v199, v200 = getScreenAndParams(v197)

				p11.props.NavigateIntoAvatarExperience(v199, v200, true)

				return
			end

			local Chat = AppPage.Chat

			if v197 and (#v197 > 0 and (Chat and Chat == v197[1].name)) then
				p11.navigateIntoChat(getScreenAndParams(v197))

				return
			end

			local SquadLobby = AppPage.SquadLobby

			if v197 and (#v197 > 0 and (SquadLobby and SquadLobby == v197[1].name)) then
				p11.navigateIntoSquadLobbyIfExists(getScreenAndParams(v197))

				return
			end

			local FAE = AppPage.FAE

			if v197 and (#v197 > 0 and (FAE and FAE == v197[1].name)) then
				p11.navigateIntoFAE(getScreenAndParams(v197))

				return
			end

			local FAEUpsellOverlay = AppPage.FAEUpsellOverlay

			if v197 and (#v197 > 0 and (FAEUpsellOverlay and FAEUpsellOverlay == v197[1].name)) then
				p11.showFAEUpsellOverlay(getScreenAndParams(v197))

				return
			end

			if FFlagEnableAmpWizardDeepLink then
				local AmpWizardContainer = AppPage.AmpWizardContainer

				if v197 and (#v197 > 0 and (AmpWizardContainer and AmpWizardContainer == v197[1].name)) then
					p11.navigateIntoAmpWizard(getScreenAndParams(v197))

					return
				end
			end

			if FFlagEnableSearchDeepLink then
				local v206 = v197[#v197]
				local v207 = v206 and v206.extraProps

				if v206 and v206.name == AppPage.SearchPage and v207 then
					p11.props.SetSearchType(v206.detail, v207.searchType)
					p11.props.SetSearchParameters(v206.detail, {
						isKeywordSuggestionEnabled = true,
						searchKeyword = v207.searchKeyword
					})
				end
			end

			p11.props.ResetNavigationHistory(p13)
		end
	end)
end
function v92.logPendingLink(p14, p15, p16) -- line: 373
	-- upvalues: simpleUrlDecode (copy), ParseQuery (copy), getShareLinkType (copy), v75 (copy), v65 (copy), ShareLinkTypes (copy), GetFFlagEnableAffiliateLinksQualifiedSignUpTracking (copy), QualifiedSignUpAttribution (copy)
	local appAnalytics = p14.props.appAnalytics
	local _, v136 = unpack(string.split(simpleUrlDecode(p15), "?"))
	local v137 = ParseQuery(v136)
	local v138 = if not v137 or not v137.stamp then nil else v137.stamp[1]
	local v139 = getShareLinkType(p15)
	local v140 = nil

	if v75 then
		v140 = getJoinCode(p15)
	end

	appAnalytics.EventStream:setRBXEventStream("deepLinkEventReceiver", "PendingDeepLinkProcessed", {
		attributionUrl = p16,
		shareLinkType = v139,
		stamp = v138,
		url = p15,
		userDidLogIn = p14.loginTracking.userDidLogIn,
		userDidSignUp = p14.loginTracking.userDidSignUp
	})

	local s4 = "PendingLink"

	if p14.loginTracking.userDidLogIn then
		s4 = "PendingLinkAfterLogin"
	elseif p14.loginTracking.userDidSignUp then
		s4 = "PendingLinkAfterSignUp"
	end

	local v142 = v65 and v139 == "ExperienceInviteLinkType"

	if v139 ~= nil and s4 == "PendingLinkAfterSignUp" and ((v139 == ShareLinkTypes.ExperienceAffiliate or v142) and GetFFlagEnableAffiliateLinksQualifiedSignUpTracking()) then
		local networking = p14.props.networking
		local v144 = if not v137 or not v137.code then nil else v137.code[1]
		local ExperienceAffiliate = ShareLinkTypes.ExperienceAffiliate

		if v139 == "ExperienceInviteLinkType" then
			ExperienceAffiliate = ShareLinkTypes.ExperienceInviteLinkType
		end

		QualifiedSignUpAttribution.attribute(networking, v144, p15, ExperienceAffiliate)
	end

	if v140 ~= nil and s4 == "PendingLinkAfterSignUp" and v75 then
		local networking = p14.props.networking

		QualifiedSignUpAttribution.attributeJoinLink(networking, p15, v140)
	end

	appAnalytics.Diag:reportCounter(s4, 1)

	if v139 ~= nil then
		local v147 = s4 .. v139

		appAnalytics.Diag:reportCounter(v147, 1)
	end
end
function v92.logProcessedLink(p17, p18, p19) -- line: 431
	-- upvalues: simpleUrlDecode (copy), ParseQuery (copy), getShareLinkType (copy), ShareLinkTypes (copy), AuthenticatedVisitAttribution (copy), v63 (copy), default (copy)
	local appAnalytics = p17.props.appAnalytics
	local sessionService = p17.props.sessionService
	local userDidLogIn = p17.loginTracking.userDidLogIn
	local userDidSignUp = p17.loginTracking.userDidSignUp
	local _, v156 = unpack(string.split(simpleUrlDecode(p18), "?"))
	local v157 = ParseQuery(v156)
	local v158 = getShareLinkType(p18)
	local v159 = if not v157 or not v157.stamp then nil else v157.stamp[1]
	local v160 = if not v157 or not v157.utm then nil else v157.utm[1]
	local v161 = getJoinCode(p18)
	local RootSID = sessionService:GetRootSID()

	appAnalytics.EventStream:setRBXEventStream("deepLinkEventReceiver", "DeepLinkProcessed", {
		attributionUrl = p19,
		sessionId = RootSID,
		shareLinkType = v158,
		stamp = v159,
		url = p18,
		utm = v160,
		userDidLogIn = p17.loginTracking.userDidLogIn,
		userDidSignUp = p17.loginTracking.userDidSignUp
	})

	if v158 == ShareLinkTypes.ExperienceAffiliate and not userDidSignUp then
		local networking = p17.props.networking
		local v164 = if not v157 or not v157.code then nil else v157.code[1]
		local ExperienceAffiliate = ShareLinkTypes.ExperienceAffiliate

		AuthenticatedVisitAttribution.attribute(networking, v164, p18, ExperienceAffiliate, userDidLogIn)
	end

	if v161 ~= nil and not userDidSignUp then
		local networking = p17.props.networking

		AuthenticatedVisitAttribution.attributeJoinLink(networking, p18, v161, userDidLogIn)
	end

	if v63 then
		local t4 = {
			url = p18,
			attributionUrl = p19,
			shareLinkType = v158
		}
		local t5 = {
			eventName = "DeeplinkProcessed",
			backends = { default.TelemetryBackends.RobloxTelemetryCounter }
		}

		default:logRobloxTelemetryCounter(t5, 1, t4)
	end
end
function v92.init(p20) -- line: 483
	-- upvalues: FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), FFlagEnableAuthDeepLinkReceiver (copy), PostAuthDeepLinkAvailableSignal (copy), v81 (copy), default (copy), TelemetryConfigs (copy), v57 (copy), PostAuthPendingLuaUrlAvailableSignal (copy), FFlagEnableSquadDeeplinkWithChatId (copy), FFlagEnableAmpWizardDeepLink (copy)
	p20.loginTracking = {
		userDidLogIn = false,
		userDidSignUp = false
	}

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		p20.deepLinkLuaHandlerStatusStore = DeepLink.DeepLinkLuaReceiverStatusStore(false)
	end

	p20:UpdateConnection()

	if FFlagEnableAuthDeepLinkReceiver then
		PostAuthDeepLinkAvailableSignal:connect(function(p21) -- line: 496
			-- upvalues: FFlagEnableDeepLinkHistoryWithModalAPI (copy), p20 (copy), v81 (copy), default (copy), TelemetryConfigs (copy), v57 (copy)
			if FFlagEnableDeepLinkHistoryWithModalAPI then
				p20.deepLinkLuaHandlerStatusStore.setLastDetectedPostAuthUrl(p21.url)
			end

			p20:logProcessedLink(p21.url, p21.attributionUrl)

			if v81 and p20.props.navigationLocked then
				p20.pendingDeepLinkUrl = p21.url
				default:logRobloxTelemetryCounter(TelemetryConfigs.DeepLinkPendingDueToNavigationLockConfig, 1)
			else
				p20:navigate(p21.url)
			end

			if v57 then
				p20.props.loggingProtocol:logEvent("deeplink_navigation_begin")
			end
		end)
		PostAuthPendingLuaUrlAvailableSignal:connect(function(p22) -- line: 521
			-- upvalues: p20 (copy)
			local url = p22.url
			local attributionUrl = p22.attributionUrl

			p20:logPendingLink(url, attributionUrl)
		end)
	end

	function p20.navigateIntoChat(_, p24) -- line: 528
		-- upvalues: p20 (copy)
		if not (p20.props.getCanSeeChatTab and p20.props.getCanSeeChatTab()) then
			return
		end

		local v214 = p24 and p24.entryPoint

		p20.props.EnteredChatFromEntryPoint(v214)

		local v215 = p24 and p24.detail

		p20.props.NavigateIntoChat({
			conversationId = v215
		}, true)
	end
	function p20.navigateIntoSquadLobbyIfExists(_, p26) -- line: 543
		-- upvalues: p20 (copy), FFlagEnableSquadDeeplinkWithChatId (copy)
		if not (p20.props.getCanSeeChatTab and p20.props.getCanSeeChatTab()) then
			return
		end

		local v218 = p26 and p26.detail
		local v219 = if not FFlagEnableSquadDeeplinkWithChatId then nil else p26 and p26.conversationId

		p20.props.NavigateIntoSquadLobbyIfExists({
			partyId = v218,
			conversationId = v219
		}, true)
	end
	function p20.navigateIntoFAE(_, p28) -- line: 556
		-- upvalues: p20 (copy)
		p20.props.NavigateIntoFAE(p28.source)
	end
	function p20.showFAEUpsellOverlay(_, p30) -- line: 560
		-- upvalues: p20 (copy)
		p20.props.ShowFAEUpsellOverlay(p30.source, p30.isPhase2)
	end

	if FFlagEnableAmpWizardDeepLink then
		function p20.navigateIntoAmpWizard(_, p32) -- line: 565
			-- upvalues: p20 (copy)
			p20.props.NavigateIntoAmpWizard(p32)
		end
	end
end
function v92.render(_) -- line: 571
end
function v92.didUpdate(p34, p35) -- line: 573
	-- upvalues: LaunchContext (copy), v81 (copy), default (copy), TelemetryConfigs (copy)
	if p35.userLoggedOut ~= p34.props.userLoggedOut and not p34.props.userLoggedOut then
		p34.loginTracking.userDidLogIn = p34.props.launchContext == LaunchContext.Login
		p34.loginTracking.userDidSignUp = p34.props.launchContext == LaunchContext.SignUp
	end

	p34:UpdateConnection()

	if v81 and (p35.navigationLocked and not p34.props.navigationLocked) and p34.pendingDeepLinkUrl then
		local pendingDeepLinkUrl = p34.pendingDeepLinkUrl

		p34.pendingDeepLinkUrl = nil
		default:logRobloxTelemetryCounter(TelemetryConfigs.DeepLinkProcessedAfterNavigationUnlockConfig, 1)
		p34:navigate(pendingDeepLinkUrl)
	end
end
function v92.willUnmount(p36) -- line: 599
	p36.props.linking:stopListeningForLuaURLs()
end

local v93 = RoactRodux.connect(function(p37, _) -- line: 603
	-- upvalues: RetrievalStatus (copy), FFlagSignalsNavP3cEvents (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), LoginStatus (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy)
	local v177 = p37.Startup.AppDataStatus ~= RetrievalStatus.NotStarted
	local v178 = if not p37.Users[p37.LocalUserId] then nil else p37.Users[p37.LocalUserId].name

	return {
		currentHistory = if not FFlagSignalsNavP3cEvents then if not FFlagUseNavigationSelectors then p37.Navigation.history else Selectors.selectLegacyHistory(p37) else nil,
		launchContext = p37.LaunchContext,
		userLoggedOut = p37.AuthenticationStatus.status == LoginStatus.LOGGED_OUT,
		username = v178,
		appLoadingStarted = v177,
		navigationLocked = if not FFlagSignalsNavP3cEvents then if not FFlagUseNavigationSelectors then p37.Navigation.lockNavigationActions else Selectors.selectNavigationLocked(p37) else nil,
		localUserId = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else p37.LocalUserId
	}
end, function(p39) -- line: 622
	-- upvalues: FFlagTCUpdateProfileCTAButton (copy), refreshProfilePlatformActionInfo (copy), CloseCentralOverlay (copy), EnteredChatFromEntryPoint (copy), NavigateIntoAvatarExperience (copy), NavigateIntoChatThunk (copy), NavigateIntoSquadLobbyIfExists (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateBack (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy), AmpApiProvider (copy), v80 (copy), v79 (copy), AccessResponseEnum (copy), ShowFAESocialUpsellOverlay (copy), UpsellComponent (copy), FFlagEnableAmpWizardDeepLink (copy), OpenAmpWizardContainer (ref), FFlagEnableSearchDeepLink (copy), SetSearchParameters (copy), SetSearchType (copy), ResetNavigationHistory (copy), EventNetworking (copy)
	return {
		RefreshProfilePlatformActionInfo = if not FFlagTCUpdateProfileCTAButton then nil else function(s5: string, p40) -- line: 625
			-- upvalues: p39 (copy), refreshProfilePlatformActionInfo (copy)
			return p39(refreshProfilePlatformActionInfo(s5, p40))
		end,
		CloseCentralOverlay = function() -- line: 629
			-- upvalues: p39 (copy), CloseCentralOverlay (copy)
			return p39(CloseCentralOverlay())
		end,
		EnteredChatFromEntryPoint = function(p41) -- line: 632
			-- upvalues: p39 (copy), EnteredChatFromEntryPoint (copy)
			return p39(EnteredChatFromEntryPoint(p41))
		end,
		NavigateIntoAvatarExperience = function(p42, p43, p44) -- line: 635
			-- upvalues: p39 (copy), NavigateIntoAvatarExperience (copy)
			return p39(NavigateIntoAvatarExperience(p42, p43, p44))
		end,
		NavigateIntoChat = function(p45, p46) -- line: 640
			-- upvalues: p39 (copy), NavigateIntoChatThunk (copy)
			return p39(NavigateIntoChatThunk(p45, p46))
		end,
		NavigateIntoSquadLobbyIfExists = function(p47, p48) -- line: 643
			-- upvalues: p39 (copy), NavigateIntoSquadLobbyIfExists (copy)
			return p39(NavigateIntoSquadLobbyIfExists(p47, p48))
		end,
		NavigateIntoFAE = function(s6: string?) -- line: 646
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), p39 (copy), NavigateBack (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy)
			local function v237() -- line: 647
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), p39 (copy), NavigateBack (copy)
				if FFlagSignalsNavP3Dispatch then
					v21.back()

					return
				end

				p39(NavigateBack())
			end

			return p39(startFacialAgeEstimation(SocialUpsellType.FacialAgeEstimation .. (s6 or ""), v237, v237, s6))
		end,
		ShowFAEUpsellOverlay = function(s7: string?, b1: boolean?) -- line: 658
			-- upvalues: AmpApiProvider (copy), v80 (copy), v79 (copy), AccessResponseEnum (copy), p39 (copy), ShowFAESocialUpsellOverlay (copy), SocialUpsellType (copy), UpsellComponent (copy)
			if AmpApiProvider.upsellFeatureAccess(v80, {}, v79).access == AccessResponseEnum.Granted then
				p39(ShowFAESocialUpsellOverlay({
					entryPointEventCtx = SocialUpsellType.FacialAgeEstimation .. (s7 or ""),
					upsellEntrySurface = s7 or "",
					upsellEntryComponent = UpsellComponent.PushNotifUI,
					b1
				}))
			end
		end,
		NavigateIntoAmpWizard = if not FFlagEnableAmpWizardDeepLink then nil else function(p49) -- line: 674
			-- upvalues: p39 (copy), OpenAmpWizardContainer (ref)
			return p39(OpenAmpWizardContainer(p49.featureName, function() -- line: 678
			end, nil, p49.entryPointEventCtx, nil, p49.nameSpace, nil, {
				returnPage = p49.returnPage,
				targetUserId = p49.targetUserId
			}))
		end,
		SetSearchParameters = if not FFlagEnableSearchDeepLink then nil else function(p50, p51) -- line: 690
			-- upvalues: p39 (copy), SetSearchParameters (copy)
			return p39(SetSearchParameters(p50, p51))
		end,
		SetSearchType = if not FFlagEnableSearchDeepLink then nil else function(p52, p53) -- line: 695
			-- upvalues: p39 (copy), SetSearchType (copy)
			return p39(SetSearchType(p52, p53))
		end,
		ResetNavigationHistory = function(p54) -- line: 699
			-- upvalues: p39 (copy), ResetNavigationHistory (copy)
			return p39(ResetNavigationHistory(nil, p54))
		end,
		ResolveLinkFromLinkId = function(p55, p56) -- line: 702
			-- upvalues: p39 (copy), EventNetworking (copy)
			return p39(EventNetworking.ShareLinksNetworking.ResolveLinkFromLinkId.API({
				linkId = p55,
				linkType = p56
			}))
		end,
		ResolveLinkFromLinkIdV2 = function(p57) -- line: 708
			-- upvalues: p39 (copy), EventNetworking (copy)
			return p39(EventNetworking.ShareLinksNetworking.ResolveLinkFromLinkIdV2.API({
				linkId = p57
			}))
		end
	}
end)(v92)

if FFlagSignalsNavP3cEvents then
	local v94 = v93

	function v93(p58) -- line: 718
		-- upvalues: v55 (copy), useSignalState (copy), v56 (copy), Roact (copy), v94 (copy), Cryo (copy)
		local v181 = v55(false)
		local v182 = useSignalState(v181.getHistory)
		local v183 = useSignalState(v56.getIsNavigating)

		return Roact.createElement(v94, Cryo.Dictionary.union(p58, {
			currentHistory = v182,
			navigationLocked = v183
		}))
	end
end

local v95 = UniversalAppPolicy.connect(function(p59) -- line: 732
	-- upvalues: FFlagProfilePlatformRefreshActionsRespectPolicies (copy)
	return {
		getCanSeeChatTab = p59.getCanSeeChatTab,
		getWebViewSupport = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else p59.getWebViewSupport,
		getEnableProfileQrCode = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else p59.getEnableProfileQrCode,
		getCanRenderTransferOnProfile = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else p59.getCanRenderTransferOnProfile
	}
end)(v93)
local u96 = RoactServices.connect({
	appAnalytics = RoactAnalytics,
	browserService = if not GetFFlagEnableUnifiedWebViews() then AppBrowserService else nil,
	linking = AppLinking,
	loggingProtocol = AppLogging,
	networking = RoactNetworking,
	sessionService = AppSessionService,
	shareLinksAnalytics = RoactAnalyticsShareLinks,
	socialProfileShareAnalytics = RoactAnalyticsSocialProfileShare
})(v95)

if FFlagEnableFlyoutSidePanel then
	return function(p60) -- line: 758
		-- upvalues: useSetDrawerVisible (ref), Cryo (copy), Roact (copy), u96 (ref)
		local v186 = useSetDrawerVisible()
		local v187 = Cryo.Dictionary.join(p60, {
			setDrawerVisible = v186
		})

		return Roact.createElement(u96, v187)
	end
end

return u96
