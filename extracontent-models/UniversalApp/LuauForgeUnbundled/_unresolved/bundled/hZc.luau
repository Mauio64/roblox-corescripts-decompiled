local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local accessResponseEnum = require("@luauforge/bundled/eeI").AmpEnums.AccessResponseEnum
local appBrowserService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppBrowserService
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local ampApiProvider = require("@luauforge/bundled/eeI").AmpApiProvider
local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/hZd")
local module2 = require("@luauforge/bundled/guY")
local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module3 = require("@luauforge/bundled/fvl")
local module4 = require("@luauforge/bundled/fBQ")
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module5 = require("@luauforge/bundled/gkk")
local module6 = require("@luauforge/bundled/hYN")

local showFAESocialUpsellOverlay = require("@luauforge/bundled/fvY").Thunks.ShowFAESocialUpsellOverlay
local startFacialAgeEstimation = require("@luauforge/bundled/fvY").Thunks.startFacialAgeEstimation
local module7 = require("@luauforge/bundled/hZe")
local module8 = require("@luauforge/bundled/ecV")
local module9 = require("@luauforge/bundled/dHq")
local module10 = require("@luauforge/bundled/fpx")
local module11 = require("@luauforge/bundled/fpw")
local module12 = require("@luauforge/bundled/dYT")
local module13 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module14 = require("@luauforge/bundled/hZf")
local module15 = require("@luauforge/bundled/hZj")
local module16 = require("@luauforge/bundled/hMc")
local qualifiedSignUpAttribution = require("@luauforge/bundled/hZk").QualifiedSignUpAttribution

local authenticatedVisitAttribution = require("@luauforge/bundled/hZk").AuthenticatedVisitAttribution
local socialUpsellType = require("@luauforge/bundled/fvY").Enums.SocialUpsellType
local upsellComponent = require("@luauforge/bundled/fvY").Analytics.Enum.UpsellComponent
local module17 = require("@luauforge/bundled/dCp")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module18 = require("@luauforge/bundled/hZx")
local module19 = require("@luauforge/bundled/iaP")
local module20 = require("@luauforge/bundled/cga")
local module21 = require("@luauforge/bundled/fBo")
local launchGame = require("@luauforge/bundled/hYT").LaunchGame
local module22 = require("@luauforge/bundled/hMx")

local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy

local getFFlagEnableAffiliateLinksQualifiedSignUpTracking = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAffiliateLinksQualifiedSignUpTracking

local fFlagSignalsNavP3cEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3cEvents

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3cEvents then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local v5 = if fFlagSignalsNavP3cEvents then require("@luauforge/bundled/dCt") else nil

local defineFastFlag = game:DefineFastFlag("DeeplinkNavDurationLog", false)
local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableUnifiedWebViews
local fFlagTCUpdateProfileCTAButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCUpdateProfileCTAButton

local module23 = require("@luauforge/bundled/iaS")

local module24 = require("@luauforge/bundled/iaT")
local module25 = require("@luauforge/bundled/iaU")
local defineFastFlag2 = game:DefineFastFlag("DeeplinkTelemetryCounters", false)
local defineFastFlag3 = game:DefineFastFlag("CloseModalsWhenDeeplinking", false)

local defineFastFlag4 = game:DefineFastFlag("EnableExperienceInviteLinkTypeAttribution", false)
local defineFastString = game:DefineFastString("JoinCodePattern", ".*/join/([%w]+)")

local fFlagEnableSquadDeeplinkWithChatId = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSquadDeeplinkWithChatId
local fFlagEnableAmpWizardDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpWizardDeepLink

local openAmpWizardContainer = if fFlagEnableAmpWizardDeepLink then require("@luauforge/bundled/eeI").OpenAmpWizardContainer else nil

local fFlagEnableDeepLinkHistoryWithModalAPI = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableDeepLinkHistoryWithModalAPI
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagStreamNotificationDropdownSingleOwner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStreamNotificationDropdownSingleOwner

local streamNotificationStore = require("@luauforge/bundled/ftT").StreamNotificationStore

local defineFastFlag5 = game:DefineFastFlag("EnableJoinLinkAttribution", false)
local simpleUrlDecode = require("@luauforge/bundled/elx").Utils.simpleUrlDecode
local v6 = module19.new(module18)
local StringUtilities = require(CorePackages.Packages.StringUtilities)
local parseQuery = StringUtilities.ParseQuery

local defineFastString2 = game:DefineFastString(
	"SocialCommsRestrictionsNamespace",
	"social/CommunicationRestrictions"
)

local defineFastString3 = game:DefineFastString(
	"EligibleForCommsAgeVerificationUpsellFeatureName",
	"EligibleForCommsAgeVerificationUpsell"
)
local defineFastFlag6 = game:DefineFastFlag("EnableDeepLinkWaitForNavigationUnlock2", false)
local module26 = require("@luauforge/bundled/dHC")

local fFlagEnableConnectionsDeepLinkSkipFilterCheck = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableConnectionsDeepLinkSkipFilterCheck

local useSetDrawerVisible = if module26 then require("@luauforge/bundled/hRk").Hooks.useSetDrawerVisible else nil

local postAuthDeepLinkAvailableSignal = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.PostAuthDeepLinkAvailableSignal

local postAuthPendingLuaUrlAvailableSignal = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.PostAuthPendingLuaUrlAvailableSignal

local function getQueryParams(p2)
	local v7, v8 = unpack(string.split(simpleUrlDecode(p2), "?"))
	return (parseQuery(v8))
end

local function getFirstKeyValue(p2, p3)
	if p2 and p2[p3] then
		return p2[p3][1]
	end

	return nil
end

function LUAUFORGE_MODULE_GLOBALS_hZc_getJoinCode(value)
	return (value:match(defineFastString))
end

local function getShareLinkType(value)
	local v7 = string.lower(value)

	for k, v8 in pairs(module22) do
		if v7:find("&type=" .. string.lower(v8)) then
			return k
		end

		local urlEncode = HttpService:UrlEncode("&type=" .. v8)

		local v9 = string.gsub(urlEncode, "%%", "%%%%")

		if v7:find((string.lower(v9))) then
			return k
		end
	end

	return nil
end

local function getScreenAndParams(list)
	local item = list[#list]
	return item.name, (Cryo.Dictionary.join(item.extraProps or {}, {
		detail = item.detail
	}))
end

local function isRouteMatchByName(list, p2)
	if list then
		list = #list > 0 and (p2 and list[1].name == p2)
	end

	return list
end

local extended = Roact.Component:extend("DeepLinkEventReceiver")

function extended:UpdateConnection()
	local v7 = self.props.userLoggedOut and self.props.linking:getLastLuaURL()

	if v7 then
		local v8 = {}

		for k, v9 in v7:gmatch("([^&=?]-)=([^&=?]+)") do
			v8[k] = v9:gsub("+", " "):gsub("%%(%x%x)", function(p3)
				return (string.char((tonumber(p3, 16))))
			end)
		end

		if v8.friendshipSourceType == "profileshare" then
			self.props.socialProfileShareAnalytics.inviteePageLoad(v8.userId, "appSignIn")
		end
	end
end

function extended.navigate(data, p2)
	if module26 then
		data.props.setDrawerVisible(false)
	end

	if defineFastFlag3 then
		if fFlagStreamNotificationDropdownSingleOwner then
			streamNotificationStore.setActiveBellId(nil)
		end

		streamNotificationStore.setStreamPresented(false)
		data.props.CloseCentralOverlay()
	end

	local v7

	if fFlagSignalsNavP3cEvents then
		v7 = getLegacyNavigationStore(false).getHistory(false)
	else
		v7 = data.props.currentHistory
	end

	local networking = data.props.networking
	local v8 = {
		socialProfileShareAnalytics = data.props.socialProfileShareAnalytics,
		shareLinksAnalytics = data.props.shareLinksAnalytics
	}

	local resolveLinkFromLinkId = data.props.ResolveLinkFromLinkId
	local resolveLinkFromLinkIdV2 = data.props.ResolveLinkFromLinkIdV2
	local closeCentralOverlay = data.props.CloseCentralOverlay

	local refreshProfilePlatformActionInfo = data.props.RefreshProfilePlatformActionInfo
	local v9

	if fFlagTCUpdateProfileCTAButton and module24 and refreshProfilePlatformActionInfo then
		local props = data.props

		v9 = function(p3)
			local v13 = if props.getWebViewSupport then props.getWebViewSupport() else nil
			local v14 = if props.getEnableProfileQrCode then props.getEnableProfileQrCode() else nil
			local v15 = if props.getCanRenderTransferOnProfile then props.getCanRenderTransferOnProfile() else nil

			local v16 = if props.getCanSeeChatTab then props.getCanSeeChatTab() else nil
			return refreshProfilePlatformActionInfo(p3, (module25(nil, {
				areWebViewsSupported = v13,
				isProfileQrCodeEnabled = v14,
				canRenderTransferInProfile = v15,
				canSeeChatTab = v16,
				isSelfView = props.localUserId ~= nil and tostring(p3) == tostring(props.localUserId) or nil
			})))
		end
	else
		v9 = refreshProfilePlatformActionInfo
	end

	local v11 = {
		history = v7,
		network = networking,
		analyticsImpls = v8,
		resolveLinkFromLinkId = resolveLinkFromLinkId,
		resolveLinkFromLinkIdV2 = resolveLinkFromLinkIdV2,
		launchGame = launchGame,
		closeCentralOverlay = closeCentralOverlay,
		RefreshProfilePlatformActionInfo = nil
	}

	if not fFlagTCUpdateProfileCTAButton then
		v9 = nil
	end

	v11.RefreshProfilePlatformActionInfo = v9
	local resolved = v6:resolve(p2, v11)

	return module8.resolve(resolved):andThen(function(list)
		if type(list) == "table" and next(list) then
			local item = list[#list]

			if not getFFlagEnableUnifiedWebViews() and data.props.browserService then
				data.props.browserService:CloseBrowserWindow()
			end

			local avatarExperienceLandingPage = avatarScreen.AvatarExperienceLandingPage
			local v12

			if item then
				if #item > 0 then
					v12 = avatarExperienceLandingPage and item[1].name == avatarExperienceLandingPage
				else
					v12 = false
				end
			else
				v12 = item
			end

			if v12 then
				local screenAndParams, v13 = getScreenAndParams(item)
				data.props.NavigateIntoAvatarExperience(screenAndParams, v13, true)
			else
				local chat = module17.Chat
				local v13 = if item then #item > 0 and (chat and item[1].name == chat) else item

				if v13 then
					data.navigateIntoChat(getScreenAndParams(item))
					return
				end

				local squadLobby = module17.SquadLobby
				local v14 = if item then #item > 0 and (squadLobby and item[1].name == squadLobby) else item

				if v14 then
					data.navigateIntoSquadLobbyIfExists(getScreenAndParams(item))
					return
				end

				local fae = module17.FAE
				local v15 = if item then #item > 0 and (fae and item[1].name == fae) else item

				if v15 then
					data.navigateIntoFAE(getScreenAndParams(item))
					return
				end

				local faeUpsellOverlay = module17.FAEUpsellOverlay
				local v16

				if item then
					v16 = #item > 0 and (faeUpsellOverlay and item[1].name == faeUpsellOverlay)
				else
					v16 = item
				end

				if v16 then
					data.showFAEUpsellOverlay(getScreenAndParams(item))
					return
				end

				if fFlagEnableAmpWizardDeepLink then
					local ampWizardContainer = module17.AmpWizardContainer
					local v17

					if item then
						v17 = #item > 0 and (ampWizardContainer and item[1].name == ampWizardContainer)
					else
						v17 = item
					end

					if v17 then
						data.navigateIntoAmpWizard(getScreenAndParams(item))
						return
					end
				end

				if fFlagEnableAmpV2Wizard then
					local ampV2Wizard = module17.AmpV2Wizard
					local v17 = if item then #item > 0 and (ampV2Wizard and item[1].name == ampV2Wizard) else item

					if v17 then
						local screenAndParams, v18 = getScreenAndParams(item)
						data.props.NavigateIntoOdpFlow(v18)
						return
					end
				end

				local v17 = item[#item]

				local extraProps = v17 and v17.extraProps

				if v17 and v17.name == module17.SearchPage and extraProps then
					data.props.SetSearchType(v17.detail, extraProps.searchType)
					data.props.SetSearchParameters(v17.detail, {
						searchKeyword = extraProps.searchKeyword,
						isKeywordSuggestionEnabled = true
					})
				end

				data.props.ResetNavigationHistory(list)
			end
		end
	end)
end

function extended:logPendingLink(p3, p4)
	local appAnalytics = self.props.appAnalytics
	local v7, v8 = unpack(string.split(simpleUrlDecode(p3), "?"))
	local v9 = parseQuery(v8)

	local v10 = if v9 and v9.stamp then v9.stamp[1] else nil

	local shareLinkType = getShareLinkType(p3)

	local v11 = if defineFastFlag5 then LUAUFORGE_MODULE_GLOBALS_hZc_getJoinCode(p3) else nil

	appAnalytics.EventStream:setRBXEventStream("deepLinkEventReceiver", "PendingDeepLinkProcessed", {
		attributionUrl = p4,
		shareLinkType = shareLinkType,
		stamp = v10,
		url = p3,
		userDidLogIn = self.loginTracking.userDidLogIn,
		userDidSignUp = self.loginTracking.userDidSignUp
	})

	local v12 = self.loginTracking.userDidLogIn and "PendingLinkAfterLogin"
		or self.loginTracking.userDidSignUp and "PendingLinkAfterSignUp"
		or "PendingLink"
	local v13 = defineFastFlag4 and shareLinkType == "ExperienceInviteLinkType"

	if
		shareLinkType ~= nil
		and v12 == "PendingLinkAfterSignUp"
		and (shareLinkType == module22.ExperienceAffiliate or v13)
		and getFFlagEnableAffiliateLinksQualifiedSignUpTracking()
	then
		local networking = self.props.networking
		local v14 = if v9 and v9.code then v9.code[1] else nil

		local v15 = module22.ExperienceAffiliate

		if shareLinkType == "ExperienceInviteLinkType" then
			v15 = module22.ExperienceInviteLinkType
		end

		qualifiedSignUpAttribution.attribute(networking, v14, p3, v15)
	end

	if v11 ~= nil and v12 == "PendingLinkAfterSignUp" and defineFastFlag5 then
		local networking = self.props.networking
		qualifiedSignUpAttribution.attributeJoinLink(networking, p3, v11)
	end

	appAnalytics.Diag:reportCounter(v12, 1)

	if shareLinkType ~= nil then
		local v14 = v12 .. shareLinkType
		appAnalytics.Diag:reportCounter(v14, 1)
	end
end

function extended:logProcessedLink(p3, p4)
	local appAnalytics = self.props.appAnalytics
	local sessionService = self.props.sessionService

	local userDidLogIn = self.loginTracking.userDidLogIn
	local userDidSignUp = self.loginTracking.userDidSignUp
	local v7, v8 = unpack(string.split(simpleUrlDecode(p3), "?"))
	local v9 = parseQuery(v8)

	local shareLinkType = getShareLinkType(p3)
	local v10 = if v9 and v9.stamp then v9.stamp[1] else nil
	local v11 = if v9 and v9.utm then v9.utm[1] else nil

	local v12 = LUAUFORGE_MODULE_GLOBALS_hZc_getJoinCode(p3)

	local rootSID = sessionService:GetRootSID()

	appAnalytics.EventStream:setRBXEventStream("deepLinkEventReceiver", "DeepLinkProcessed", {
		attributionUrl = p4,
		sessionId = rootSID,
		shareLinkType = shareLinkType,
		stamp = v10,
		url = p3,
		utm = v11,
		userDidLogIn = self.loginTracking.userDidLogIn,
		userDidSignUp = self.loginTracking.userDidSignUp
	})

	if shareLinkType == module22.ExperienceAffiliate and not userDidSignUp then
		local networking = self.props.networking
		local v13 = if v9 and v9.code then v9.code[1] else nil

		local experienceAffiliate = module22.ExperienceAffiliate
		authenticatedVisitAttribution.attribute(networking, v13, p3, experienceAffiliate, userDidLogIn)
	end

	if v12 ~= nil and not userDidSignUp then
		local networking = self.props.networking
		authenticatedVisitAttribution.attributeJoinLink(networking, p3, v12, userDidLogIn)
	end

	if defineFastFlag2 then
		default:logRobloxTelemetryCounter({
			eventName = "DeeplinkProcessed",
			backends = { default.TelemetryBackends.RobloxTelemetryCounter }
		}, 1, { url = p3, attributionUrl = p4, shareLinkType = shareLinkType })
	end
end

function extended:init()
	self.loginTracking = { userDidLogIn = false, userDidSignUp = false }

	if fFlagEnableDeepLinkHistoryWithModalAPI then
		self.deepLinkLuaHandlerStatusStore = module.DeepLinkLuaReceiverStatusStore(false)
	end

	self:UpdateConnection()

	postAuthDeepLinkAvailableSignal:connect(function(p2)
		if fFlagEnableDeepLinkHistoryWithModalAPI then
			self.deepLinkLuaHandlerStatusStore.setLastDetectedPostAuthUrl(p2.url)
		end

		self:logProcessedLink(p2.url, p2.attributionUrl)

		if defineFastFlag6 and self.props.navigationLocked then
			self.pendingDeepLinkUrl = p2.url

			default:logRobloxTelemetryCounter(telemetryConfigs.DeepLinkPendingDueToNavigationLockConfig, 1)
		else
			self:navigate(p2.url)
		end

		if defineFastFlag then
			self.props.loggingProtocol:logEvent("deeplink_navigation_begin")
		end
	end)

	postAuthPendingLuaUrlAvailableSignal:connect(function(p2)
		self:logPendingLink(p2.url, p2.attributionUrl)
	end)

	function self.navigateIntoChat(p2, p3)
		if not (self.props.getCanSeeChatTab and self.props.getCanSeeChatTab()) then
			return
		end

		local entryPoint = p3 and p3.entryPoint
		self.props.EnteredChatFromEntryPoint(entryPoint)

		local detail = p3 and p3.detail
		self.props.NavigateIntoChat({ conversationId = detail }, true)
	end

	function self.navigateIntoSquadLobbyIfExists(p2, p3)
		if not (self.props.getCanSeeChatTab and self.props.getCanSeeChatTab()) then
			return
		end

		local detail = p3 and p3.detail
		local v7 = if fFlagEnableSquadDeeplinkWithChatId then p3 and p3.conversationId else nil
		self.props.NavigateIntoSquadLobbyIfExists({
			partyId = detail,
			conversationId = v7
		}, true)
	end
	function self.navigateIntoFAE(p2, p3)
		self.props.NavigateIntoFAE(p3.source)
	end

	function self.showFAEUpsellOverlay(p2, p3)
		self.props.ShowFAEUpsellOverlay(p3.source, p3.isPhase2)
	end

	if fFlagEnableAmpWizardDeepLink then
		function self.navigateIntoAmpWizard(p2, p3)
			self.props.NavigateIntoAmpWizard(p3)
		end
	end
end

function extended.render(p2) end

function extended:didUpdate(p2)
	if p2.userLoggedOut ~= self.props.userLoggedOut and not self.props.userLoggedOut then
		self.loginTracking.userDidLogIn = self.props.launchContext == module21.Login
		self.loginTracking.userDidSignUp = self.props.launchContext == module21.SignUp
	end

	self:UpdateConnection()

	if
		defineFastFlag6
		and p2.navigationLocked
		and not self.props.navigationLocked
		and self.pendingDeepLinkUrl
	then
		local pendingDeepLinkUrl = self.pendingDeepLinkUrl
		self.pendingDeepLinkUrl = nil

		default:logRobloxTelemetryCounter(telemetryConfigs.DeepLinkProcessedAfterNavigationUnlockConfig, 1)

		self:navigate(pendingDeepLinkUrl)
	end
end

function extended.willUnmount(p2)
	p2.props.linking:stopListeningForLuaURLs()
end

local v7 = RoactRodux.connect(function(data, p2)
	local name = if data.Users[data.LocalUserId] then data.Users[data.LocalUserId].name else nil
	local v9

	if not fFlagSignalsNavP3cEvents then
		if fFlagUseNavigationSelectors then
			v9 = selectors.selectLegacyHistory(data)
		else
			v9 = data.Navigation.history
		end
	end

	local v8 = {
		currentHistory = v9,
		launchContext = data.LaunchContext,
		userLoggedOut = 0,
		username = 0,
		navigationLocked = 0,
		localUserId = 0
	}

	local v10 = if not fFlagUseSignalsForAuthenticationStatus then data.AuthenticationStatus.status == module4.LOGGED_OUT else nil
	v8.userLoggedOut = v10

	v8.username = name
	local v11

	if not fFlagSignalsNavP3cEvents then
		if fFlagUseNavigationSelectors then
			v11 = selectors.selectNavigationLocked(data)
		else
			v11 = data.Navigation.lockNavigationActions
		end
	end

	v8.navigationLocked = v11

	local v12 = if module24 then data.LocalUserId else nil
	v8.localUserId = v12
	return v8
end, function(callback)
	return {
		RefreshProfilePlatformActionInfo = fFlagTCUpdateProfileCTAButton and function(p2, p3)
			return callback(module23(p2, p3))
		end or nil,
		CloseCentralOverlay = function()
			return callback(module3())
		end,
		EnteredChatFromEntryPoint = function(p2)
			return callback(module16(p2))
		end,
		NavigateIntoAvatarExperience = function(p2, p3, p4)
			return callback(module5(p2, p3, p4))
		end,
		NavigateIntoChat = function(p2, p3)
			return callback(module6(p2, p3))
		end,
		NavigateIntoSquadLobbyIfExists = function(p2, p3)
			return callback(module7(p2, p3))
		end,
		NavigateIntoFAE = function(value)
			local function fn()
				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back()
				else
					callback(navigateBack())
				end
			end
			return callback(startFacialAgeEstimation(
				socialUpsellType.FacialAgeEstimation .. (value or ""),
				fn,
				fn,
				value
			))
		end,
		NavigateIntoOdpFlow = function(p2)
			return callback(module2.openOdpFlowHandoff(p2))
		end,
		ShowFAEUpsellOverlay = function(value, p2)
			if ampApiProvider.upsellFeatureAccess(defineFastString3, {}, defineFastString2).access == accessResponseEnum.Granted then
				callback(showFAESocialUpsellOverlay({
					entryPointEventCtx = socialUpsellType.FacialAgeEstimation .. (value or ""),
					upsellEntrySurface = value or "",
					upsellEntryComponent = upsellComponent.PushNotifUI,
					p2
				}))
			end
		end,
		NavigateIntoAmpWizard = fFlagEnableAmpWizardDeepLink and function(data)
			return callback(openAmpWizardContainer(
				data.featureName,
				function() end,
				nil,
				data.entryPointEventCtx,
				nil,
				data.nameSpace,
				nil,
				{ returnPage = data.returnPage, targetUserId = data.targetUserId }
			))
		end or nil,
		SetSearchParameters = function(p2, p3)
			return callback(module10(p2, p3))
		end,
		SetSearchType = function(p2, p3)
			return callback(module11(p2, p3))
		end,
		ResetNavigationHistory = function(p2)
			return callback(module9(nil, p2))
		end,
		ResolveLinkFromLinkId = function(p2, p3)
			return callback(module20.ShareLinksNetworking.ResolveLinkFromLinkId.API({
				linkId = p2,
				linkType = p3
			}))
		end,
		ResolveLinkFromLinkIdV2 = function(p2, p3)
			if fFlagEnableConnectionsDeepLinkSkipFilterCheck then
				return callback(module20.ShareLinksNetworking.ResolveLinkFromLinkIdV2.API({
					linkId = p2,
					skipFilterCheck = p3
				}))
			end

			return callback(module20.ShareLinksNetworking.ResolveLinkFromLinkIdV2.API({
				linkId = p2
			}))
		end
	}
end)(extended)

if fFlagSignalsNavP3cEvents or fFlagUseSignalsForAuthenticationStatus then
	local React = require(CorePackages.Packages.React)

	local v8 = v7
	v7 = React.memo(function(p2)
		local v9 = {}

		if fFlagSignalsNavP3cEvents then
			v9.navigationLocked = useSignalState(v5.getIsNavigating)
		end

		local v10 = if fFlagUseSignalsForAuthenticationStatus then useSignalState(getAuthenticationStatusStore(false).getStatus) == module4.LOGGED_OUT else nil
		v9.userLoggedOut = v10

		return Roact.createElement(v8, Cryo.Dictionary.union(p2, v9))
	end)
end

local v8 = universalAppPolicy.connect(function(data)
	local v9 = {
		getCanSeeChatTab = data.getCanSeeChatTab,
		getWebViewSupport = 0,
		getEnableProfileQrCode = 0,
		getCanRenderTransferOnProfile = 0
	}

	local v10 = if module24 then data.getWebViewSupport else nil
	v9.getWebViewSupport = v10

	local v11 = if module24 then data.getEnableProfileQrCode else nil
	v9.getEnableProfileQrCode = v11

	local v12 = if module24 then data.getCanRenderTransferOnProfile else nil
	v9.getCanRenderTransferOnProfile = v12
	return v9
end)(v7)

local connect = roactServices.connect

if getFFlagEnableUnifiedWebViews() then
	appBrowserService = nil
end

local v10 = connect({
	appAnalytics = module12,
	browserService = appBrowserService,
	linking = appLinking,
	loggingProtocol = appLogging,
	networking = module13,
	sessionService = appSessionService,
	shareLinksAnalytics = module14,
	socialProfileShareAnalytics = module15
})(v8)

local function fn(p2)
	local v11 = useSetDrawerVisible()
	local joined = Cryo.Dictionary.join(p2, { setDrawerVisible = v11 })

	return Roact.createElement(v10, joined)
end

if module26 then
	return fn
end

return v10
