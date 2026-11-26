local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/bundled/ecq")
local module5 = require("@luauforge/bundled/grb")

local appOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppOmniRecommendationsRequest
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module6 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module7 = require("@luauforge/bundled/dzC")
local module8 = require("@luauforge/bundled/grv")

local tenFootLogoWithContentsLayout = require("@luauforge/bundled/gru").Components.TenFootLogoWithContentsLayout
local module9 = require("@luauforge/bundled/grz")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module11 = require("@luauforge/bundled/grA")
local module12 = require("@luauforge/bundled/grJ")
local module13 = require("@luauforge/bundled/egt")
local appStorageUtilities = require("@game/CorePackages/Workspace/Packages/AuthCommon").Utils.AppStorageUtilities
local module14 = require("@luauforge/bundled/grW")
local wechatQQLoginPage = require("@luauforge/bundled/gtn").Components.WechatQQLoginPage
local user = require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.User

local module15 = require("@luauforge/bundled/gty")

local defineFastFlag = game:DefineFastFlag("ShowCustomizedLandingPageWithoutInviter1", false)

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService
local engineFeature = game:GetEngineFeature("LandingPageMountSignalEnabled")

local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local uiConstants = AuthCommon.Common.UIConstants
local thirdPartySwitchAccountComponent = AuthCommon.Components.ThirdPartySwitchAccountComponent
local isLoggedOutUserId = AuthCommon.Utils.isLoggedOutUserId

local module17 = require("@luauforge/bundled/fzT")
local authTimingUtil = module17.authTimingUtil
local authButtonClick = module17.Events.authButtonClick
local authButtonShown = module17.Events.authButtonShown
local authClientError = module17.Events.authClientError
local authOperationTiming = module17.Events.authOperationTiming
local authPageload = module17.Events.authPageload
local telemetryConfigs = module17.TelemetryConfigs
local eventStreamConstants = module17.EventStreamConstants

local landingPageConstants = require("@luauforge/bundled/gru").Constants.LandingPageConstants

local module18 = require("@luauforge/bundled/gtB")

local alignment = AuthCommon.Enums.Alignment
local module19 = require("@luauforge/bundled/dFt")
local module20 = require("@luauforge/bundled/gtC")

local module21 = require("@luauforge/bundled/ggu")
local default = module21.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module21.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local fFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableLuaAccountSwitch
local module22 = require("@luauforge/bundled/guB")
local module23 = require("@luauforge/bundled/guC")
local module24 = require("@luauforge/bundled/guD")

local module25 = require("@luauforge/bundled/guE")

local module26 = require("@luauforge/bundled/guF")
local module27 = require("@luauforge/bundled/guG")

local module28 = require("@luauforge/bundled/guH")
local module29 = require("@luauforge/bundled/guI")
local module30 = require("@luauforge/bundled/guJ")
local FFlagEnableDesktopSsoSignupDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagEnableDesktopSsoSignupDialog")
local module32 = require("@luauforge/bundled/guL")
local module33 = require("@luauforge/bundled/guM")
local module34 = require("@luauforge/bundled/ghS")
local module35 = require("@luauforge/bundled/guN")

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)

local module37 = require("@luauforge/bundled/guO")

local module38 = require("@luauforge/bundled/ghT")
local fFlagLuafiedWechatQQLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuafiedWechatQQLogin
local fStringLuaLoginRevampIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaLoginRevampIxpLayer
local getFFlagEnableMultiPageSignup = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableMultiPageSignup

local fFlagLuaEnableCustomizedInviteLandingPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableCustomizedInviteLandingPage

local fFlagLuaEnableCustomizedInviteLandingPageForTesting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableCustomizedInviteLandingPageForTesting

local getFFlagKeepDarkThemeOverrideWhenLoggedOut = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagKeepDarkThemeOverrideWhenLoggedOut

local fFlagEnablePioneerPostAuthGameJoin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePioneerPostAuthGameJoin

local module39 = require("@luauforge/bundled/guR")

local defineFastFlag2 = game:DefineFastFlag("CustomizedLandingLaunchGame", false)
local defineFastFlag3 = game:DefineFastFlag("EnablePrewarmChallengeWebView", false)
local defineFastFlag4 = game:DefineFastFlag("DesktopSsoCenterAuthGroup", false)
local defineFastFlag5 = game:DefineFastFlag("DesktopSsoCardInnerStroke", false)
local defineFastFlag6 = game:DefineFastFlag("AccountSwitcherDesktopAuthDialogs", false)

game:DefineFastFlag("LuaVerifiedSignup2", false)
game:DefineFastFlag("LuaVerifiedSignupExperiment2", false)
local defineFastString = game:DefineFastString("CustomizedLandingExperienceSort", "")

local stringToSet = require("@luauforge/bundled/gru").Utils.parseStringToSet(defineFastString)

local involuntaryLogoutAnalyticsEvents = AuthCommon.Analytics.InvoluntaryLogoutAnalyticsEvents

local authEntryVariant = AuthCommon.Experiments.AuthEntryVariant

local extended = module.PureComponent:extend("LandingPage")

local function generatePioneerUsername()
	return "Pioneer" .. HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 13)
end

local function getRequiredAgreementIds(items)
	local ids = {}

	for k, item in items do
		local agreementType = item.agreementType

		if not (agreementType == nil or not string.find(agreementType:lower(), "optional")) then
			continue
		end

		table.insert(ids, item.id)
	end

	return ids
end

local function isDesktopPlatform(p2): boolean
	return p2 == Enum.Platform.Windows or p2 == Enum.Platform.OSX
end

local function isDesktopSsoEnabled(p2)
	local v5 = module30

	if v5 then
		local platform = p2.platform
		v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
	end

	return v5
end

local function reportLandingSwitchAccountsButtonShown(p2, p3)
	p2.reportAuthButtonShown(
		eventStreamConstants.Context.LandingScreen,
		eventStreamConstants.Button.SwitchAccounts,
		p3,
		eventStreamConstants.Origin.LandingScreen
	)
end

local module40 = require("@luauforge/bundled/fGL")

local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagLoginV2FullFlowDevOverride = SharedFlags.FFlagLoginV2FullFlowDevOverride
local module42 = require("@luauforge/bundled/fGg")
local module43 = require("@luauforge/bundled/gry")
local module44 = require("@luauforge/bundled/guT")
local module45 = require("@luauforge/bundled/guz")
local module46 = require("@luauforge/bundled/guu")

local getAccountsListWithSignedOutAccounts = require("@luauforge/bundled/ghc").GetAccountsListWithSignedOutAccounts
local module47 = require("@luauforge/bundled/gvf")
require("@luauforge/bundled/guy")

local fFlagLuaEnableGenreLandingDeeplink = SharedFlags.FFlagLuaEnableGenreLandingDeeplink
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
local experienceService = require("@luauforge/bundled/bZg").ExperienceService
local getUniverseIdFromPlaceId = AuthCommon.Thunks.GetUniverseIdFromPlaceId
local accountPickerListView = require("@luauforge/bundled/gru").Components.AccountPickerListView

local externalIdentitySignInOptions = require("@luauforge/bundled/gru").Components.ExternalIdentitySignInOptions

local fFlagEnableExternalIdentityAccountPickerButtons = require("@luauforge/bundled/gru").Flags.FFlagEnableExternalIdentityAccountPickerButtons
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local engineFeature2 = game:GetEngineFeature("ThirdPartyUserServiceIsAccountSwitchingSupported")
local defineFastFlag7 = game:DefineFastFlag("LogLandingPagePlatformAccountSwitch", false)

local defineFastFlag8 = game:DefineFastFlag("LandingPageKeepDeviceSafeStatusBarHeight", false)
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets

local brazilContentRatingBadge = require("@luauforge/bundled/gru").Components.BrazilContentRatingBadge

local landingPageEligibility = require("@luauforge/bundled/gru").Utils.landingPageEligibility
local isAccountPickerEnabled = landingPageEligibility.isAccountPickerEnabled
local isAccountSwitcherEnabled = landingPageEligibility.isAccountSwitcherEnabled

local isCustomizedInviteLandingPage = require("@luauforge/bundled/gru").Utils.isCustomizedInviteLandingPage

local fFlagEnablePioneerLandingPageLayout = SharedFlags.FFlagEnablePioneerLandingPageLayout
local fFlagEnableExpressSignup = SharedFlags.FFlagEnableExpressSignup
local fFlagEnableKISAConsentModalization = SharedFlags.FFlagEnableKISAConsentModalization
local gameLandingPageLayout = require("@luauforge/bundled/gru").Components.GameLandingPageLayout

local fFlagGameLandingPageAuthLayout = require("@luauforge/bundled/gru").Flags.FFlagGameLandingPageAuthLayout

local fFlagEnablePioneerLandingPageSso = require("@luauforge/bundled/gru").Flags.FFlagEnablePioneerLandingPageSso
local isPioneerLaunch = require("@luauforge/bundled/gid").isPioneerLaunch
local fFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut

local module48 = require("@luauforge/bundled/gvi")

local module49 = require("@luauforge/bundled/gvl")
local kisaComplianceUtils = module49.KISAComplianceUtils
local analyticsEvents = module49.Analytics.AnalyticsEvents
local eventConstants = module49.Analytics.EventConstants
local module50 = require("@luauforge/bundled/gvP")
local module51 = require("@luauforge/bundled/gvQ")

function extended:init()
	if self.props.shouldDoSessionCheck then
		local v5 = user.fromLocalStorage()
		self.props.sessionCheck(
			self.props.networking,
			v5,
			self.props.analytics,
			self.props.appPolicy,
			self.props.loggingProtocol
		)
	end

	authTimingUtil.landingPageLoadStart()
	function self.renderCrossDeviceCodePanel(p2)
		local module52 = require("@luauforge/bundled/gvR")
		return module.createElement(module52, {
			deviceCode = p2.deviceCode,
			qrCodeUrl = p2.qrCodeUrl
		})
	end

	self.state = {
		shouldShowAccountSwitcherButton = false,
		credProtocolIsAvailableResponse = nil,
		shouldShowCustomizedLandingPage = false,
		accountPickerAccounts = {},
		accountPickerResolved = not isAccountPickerEnabled(self.props),
		deepLinkData = nil,
		isExpressSignupInProgress = false,
		kisaAgreements = {},
		userAgreements = {},
		externalIdentityCapabilities = { google = false, apple = false },
		activeExternalIdentityProvider = nil,
		isDesktopSignupDialogOpen = false
	}

	function self.acquireExternalIdentityClient()
		return module45.acquire({
			getNetworking = function()
				return self.props.networking
			end,
			isBrowserSignInEnabled = function()
				local props = self.props
				local v5 = module30

				if v5 then
					local platform = props.platform
					v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
				end

				return v5
			end,
			completeSession = function()
				return self.props.sessionCheck(
					self.props.networking,
					user.fromLocalStorage(),
					self.props.analytics,
					self.props.appPolicy,
					self.props.loggingProtocol
				)
			end
		})
	end

	if module28 or fFlagEnableExternalIdentityAccountPickerButtons then
		self.externalIdentityClient = self.acquireExternalIdentityClient()
	else
		local props = self.props
		local v5 = module30

		if v5 then
			local platform = props.platform
			v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
		end

		if
			v5
			or fFlagEnablePioneerLandingPageSso
			and fFlagEnablePioneerLandingPageLayout
			and isPioneerLaunch()
		then
			self.externalIdentityClient = self.acquireExternalIdentityClient()
		end
	end

	self.activeExternalIdentityOperation = nil
	self.externalIdentityCapabilitiesRequested = false

	function self.refreshExternalIdentityCapabilities()
		if self.externalIdentityClient == nil then
			return
		end

		local capabilitiesAsync = self.externalIdentityClient.getCapabilitiesAsync()

		if self.isMounted then
			self:setState({ externalIdentityCapabilities = capabilitiesAsync })
		end
	end

	function self.maybeRefreshExternalIdentityCapabilities()
		if
			self.externalIdentityClient == nil
			or self.externalIdentityCapabilitiesRequested
			or not self.isExternalIdentityEligible()
		then
			return
		end

		self.externalIdentityCapabilitiesRequested = true
		task.spawn(self.refreshExternalIdentityCapabilities)
	end

	function self.isExternalIdentityExperimentEligible(): boolean
		return not (self.props.excludeExternalIdentityLogin or self.props.useVNGUserAgreementPopup or fFlagEnablePioneerLandingPageLayout and isPioneerLaunch())
			and not self.state.shouldShowCustomizedLandingPage
			and self.props.uiModeInfo.uiMode ~= uiMode.TenFoot
	end

	function self.getExternalIdentityLoginVariant()
		return AuthCommon.Experiments.resolveAuthEntryVariant(
			self.props.authEntryVariant,
			self.isExternalIdentityExperimentEligible()
		)
	end

	function self.isExternalIdentityEligible()
		local v5

		if not (fFlagEnablePioneerLandingPageSso and fFlagEnablePioneerLandingPageLayout and isPioneerLaunch()) then
			v5 = self.getExternalIdentityLoginVariant() == authEntryVariant.FoundationSso
			return v5
		end

		v5 = fFlagGameLandingPageAuthLayout
			and not (self.props.excludeExternalIdentityLogin or self.props.useVNGUserAgreementPopup)

		if v5 then
			return self.props.uiModeInfo.uiMode ~= uiMode.TenFoot
		end

		return v5
	end

	function self.isDesktopSsoRedesignArm()
		local props = self.props
		local v5 = module30

		if v5 then
			local platform = props.platform
			v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
		end

		return v5 and self.getExternalIdentityLoginVariant() ~= authEntryVariant.Control
	end

	function self.isAuthenticationCardArm()
		if self.getExternalIdentityLoginVariant() == authEntryVariant.Control then
			return false
		end

		local props = self.props
		local v5 = module30

		if v5 then
			local platform = props.platform
			v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
		end

		return v5 or module43 and self.props.formFactor == formFactor.WIDE
	end

	function self.getLandingTelemetryState(): string
		local v5 = self.props.uiModeInfo.uiMode == uiMode.TenFoot
		local customizedInviteLandingPage = isCustomizedInviteLandingPage({
			shouldShowCustomizedLandingPage = self.state.shouldShowCustomizedLandingPage,
			deepLinkData = self.state.deepLinkData
		})

		if self.isAuthenticationCardArm() and not (v5 or customizedInviteLandingPage) then
			return "authCard"
		end

		if not module43 or self.getExternalIdentityLoginVariant() == authEntryVariant.Control then
			return "control"
		end

		local props = self.props
		local v6 = module30

		if v6 then
			local platform = props.platform
			v6 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
		end

		if
			not v6
			and not v5
			and not customizedInviteLandingPage
			and self.props.formFactor == formFactor.COMPACT
		then
			return "ssoRedesign"
		end

		return "control"
	end

	function self.getExternalIdentityTelemetryState(p2)
		if p2 ~= eventStreamConstants.Context.AccountPickerLandingScreenListView then
			return self.getLandingTelemetryState()
		end

		if fFlagEnableExternalIdentityAccountPickerButtons and self.isExternalIdentityEligible() then
			return "ssoRedesign"
		end

		return "default"
	end

	function self.getExternalIdentityProviders()
		if not self.isExternalIdentityEligible() then
			return {}
		end

		local v5 = {}

		if self.state.externalIdentityCapabilities.google then
			table.insert(v5, "google")
		end

		if self.state.externalIdentityCapabilities.apple then
			table.insert(v5, "apple")
		end

		return v5
	end

	self.externalIdentityLandingImpressions = {}

	function self.cancelActiveExternalIdentityOperation()
		local activeExternalIdentityOperation = self.activeExternalIdentityOperation

		if activeExternalIdentityOperation ~= nil then
			activeExternalIdentityOperation.cancel()
		end
	end
	function self.reportLandingExternalIdentityImpressions()
		local v5

		if fFlagEnablePioneerLandingPageSso then
			v5 = fFlagEnablePioneerLandingPageLayout
				and fFlagGameLandingPageAuthLayout
				and isPioneerLaunch()
		end

		if not module28 then
			local props = self.props
			local v6 = module30

			if v6 then
				local platform = props.platform
				v6 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
			end

			if not (v6 or v5) then
				return
			end
		end

		if
			not (self.state.accountPickerResolved or v5)
			or #self.state.accountPickerAccounts > 0 and not v5
		then
			return
		end

		for k, v6 in self.getExternalIdentityProviders() do
			if self.externalIdentityLandingImpressions[v6] then
				continue
			end

			self.externalIdentityLandingImpressions[v6] = true

			local landingScreen = eventStreamConstants.Context.LandingScreen
			local v8 = if v6 == "google" then eventStreamConstants.Button.GoogleSso else eventStreamConstants.Button.AppleSso
			authButtonShown(landingScreen, v8, "visible", eventStreamConstants.Origin.LandingScreen)
		end
	end

	function self.startExternalIdentityFlow(p2, p3, p4)
		if self.externalIdentityClient == nil then
			return
		end

		local fFlagLandingAndAccountPickerSsoTelemetry = require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry
		local v5

		if p2 == "google" then
			v5 = eventStreamConstants.Button.GoogleSso
		else
			v5 = eventStreamConstants.Button.AppleSso
		end

		if fFlagLandingAndAccountPickerSsoTelemetry and not p4 then
			authButtonClick(p3, v5, self.getExternalIdentityTelemetryState(p3), nil, nil, p3)
		end

		local activeExternalIdentityOperation = self.activeExternalIdentityOperation

		if activeExternalIdentityOperation == nil then
			if not fFlagLandingAndAccountPickerSsoTelemetry then
				authButtonClick(p3, v5, nil, nil, nil, p3)
			end

			self:setState({ activeExternalIdentityProvider = p2 })

			local lastTime = os.clock()
			local v6

			if SharedFlags.FFlagEnableAccountSwitcherExternalIdentityButtons then
				v6 = self.acquireExternalIdentityClient()
			else
				v6 = self.externalIdentityClient
			end

			local authenticate = v6.authenticate(p2)
			self.activeExternalIdentityOperation = authenticate
			authenticate.promise:andThen(function(p5)
				authOperationTiming(p3, os.clock() - lastTime, `externalIdentity.{p2}.{p5.status}`)

				if p5.status == "failed" then
					authClientError(p3, `externalIdentity.{p2}.{p5.errorClass or "unknown"}`, nil, p3)

					if self.isMounted then
						self.props.showErrorToast()
					end
				elseif fFlagLandingAndAccountPickerSsoTelemetry and p5.status == "unavailable" then
					authClientError(p3, `externalIdentity.{p2}.unavailable`, nil, p3)
				end

				if self.isMounted and self.activeExternalIdentityOperation == authenticate then
					self.activeExternalIdentityOperation = nil

					local v9 = if module29 or fFlagEnablePioneerLandingPageSso and fFlagEnablePioneerLandingPageLayout and isPioneerLaunch() then module.None else nil
					self:setState({ activeExternalIdentityProvider = v9 })
				end
			end)
		else
			self.cancelActiveExternalIdentityOperation()
			activeExternalIdentityOperation.promise:andThen(function(p5)
				if
					self.isMounted
					and p5.status ~= "success"
					and self.activeExternalIdentityOperation == nil
				then
					self.startExternalIdentityFlow(p2, p3, true)
				end
			end)
		end
	end

	function self.maybeShowCustomizedLandingPage()
		local url = preAuthDeepLinkUrlStore.getUrl()

		if
			fFlagLuaEnableCustomizedInviteLandingPage
			and (self.props.isCustomizedLandingPageEnabled or fFlagLuaEnableCustomizedInviteLandingPageForTesting)
		then
			local v5 = url and string.find(url, "game_details") and url:match("gameId=(%d+)")

			if v5 then
				self:setState({
					shouldShowCustomizedLandingPage = true,
					deepLinkData = { universeId = v5 }
				})
			end

			local v6 = url and string.find(url, "share") and module37(self.props.networking, url)

			if v6 then
				local universeId = v6.universeId
				local inviterId = v6.inviterId

				if defineFastFlag and universeId or universeId and inviterId then
					self:setState({
						shouldShowCustomizedLandingPage = true,
						deepLinkData = v6
					})
				end
			end

			if defineFastFlag2 then
				local pendingJoinAttempt = experienceService:GetPendingJoinAttempt()

				local placeId = pendingJoinAttempt and pendingJoinAttempt.placeId

				if placeId then
					getUniverseIdFromPlaceId(self.props.networking, placeId):andThen(function(p2)
						if p2 then
							self:setState({
								shouldShowCustomizedLandingPage = true,
								deepLinkData = { universeId = p2 }
							})
						end
					end):catch(function(p2) end)
				end
			end

			if defineFastString and url and string.find(url, "navigation/experience_sort") then
				local match = url:match("sortId=([^&]+)")

				if match and stringToSet[match] then
					self:setState({
						shouldShowCustomizedLandingPage = true,
						deepLinkData = { genre = match }
					})
				end
			end
		end

		if fFlagLuaEnableGenreLandingDeeplink and url and string.find(url, "navigation/genre") then
			local match = url:match("genre=([^&]+)")

			if landingPageConstants.Common.GetGenreBackgroundAssetId(match) then
				self:setState({
					shouldShowCustomizedLandingPage = true,
					deepLinkData = { genre = match }
				})
			end
		end
	end

	function self.usesDesktopSignupDialog()
		if FFlagEnableDesktopSsoSignupDialog and self.isDesktopSsoRedesignArm() then
			local fastFlag = game:GetFastFlag("LuaVerifiedSignup2")
				or game:GetFastFlag("LuaVerifiedSignupExperiment2")
				and self.props.useVerifiedSignupPage == true
			local v5 = module34() and self.props.shouldUsePasskeySignup == true
			return ((not self.getShouldShowKISAAgreements() or module32) and true or false)
				and not fastFlag
				and not v5
		end

		return false
	end

	function self.closeDesktopSignupDialog()
		if self.isMounted then
			self:setState({ isDesktopSignupDialogOpen = false })
		end
	end

	function self.navigateToSignUp(p2)
		self.cancelActiveExternalIdentityOperation()
		local networking = self.props.networking
		local analytics = self.props.analytics

		local fetchSignUpBundles = self.props.fetchSignUpBundles
		local navigateToSinglePageSignUp = self.props.navigateToSinglePageSignUp
		local navigateToMultiPageSignUp = self.props.navigateToMultiPageSignUp
		local navigateToBirthdayPage = self.props.navigateToBirthdayPage

		analytics.reportSignUpButtonClicked(eventStreamConstants.Context.LandingScreen)

		if getFFlagEnableMultiPageSignup() and self.props.shouldEnableMultiPageSignup then
			navigateToMultiPageSignUp(p2)
			return
		end

		if self.props.shouldShowMultipageSignupDirectionalTest then
			navigateToBirthdayPage()
			return
		end

		if self.usesDesktopSignupDialog() then
			self:setState({ isDesktopSignupDialogOpen = true })

			return
		end

		if module19.SinglePageSignUpEnabled() then
			navigateToSinglePageSignUp()
			return
		end

		fetchSignUpBundles(networking)
		navigateToBirthdayPage()
	end

	function self.openDesktopSignupDialogFromAccountSwitcher(): boolean
		if
			self.isMounted
			and not self.props.shouldShowMultipageSignupDirectionalTest
			and self.usesDesktopSignupDialog()
		then
			self.cancelActiveExternalIdentityOperation()
			self:setState({ isDesktopSignupDialogOpen = true })

			return true
		end

		return false
	end

	function self.openDesktopLoginDialogFromAccountSwitcher(): boolean
		if self.isMounted and self.isDesktopSsoRedesignArm() then
			self.cancelActiveExternalIdentityOperation()
			self.props.gotoLoginV2(self.state.credProtocolIsAvailableResponse, nil, true)
			return true
		end

		return false
	end

	function self.navigateToLogin(p2, p3)
		self.cancelActiveExternalIdentityOperation()

		local v5 = module43 and self.getExternalIdentityLoginVariant() ~= authEntryVariant.Control
		local v6 = isAccountPickerEnabled(self.props) and #self.state.accountPickerAccounts > 0

		if self.isDesktopSsoRedesignArm() or self.isAuthenticationCardArm() and not v6 then
			self.props.gotoLoginV2(p2, p3, true)
		elseif self.props.showLoginRevamp or v5 then
			self.props.gotoLoginV2(p2, p3)
		else
			self.props.gotoLogin(p3)
		end
	end

	function self.openAccountSwitcher()
		if isAccountPickerEnabled(self.props) then
			return
		end

		if self.props.excludeAccountSwitcher then
			local analytics = self.props.analytics
			local switchAccountsExclusionsHidden = eventStreamConstants.State.SwitchAccountsExclusionsHidden
			analytics.reportAuthButtonShown(
				eventStreamConstants.Context.LandingScreen,
				eventStreamConstants.Button.SwitchAccounts,
				switchAccountsExclusionsHidden,
				eventStreamConstants.Origin.LandingScreen
			)
		elseif isAccountSwitcherEnabled(self.props) then
			local accountBlob = appStorageUtilities.getAccountBlob()
			local function fn(p2)
				local v5 = not (p2 == nil) and p2 > 0
				self:setState({ shouldShowAccountSwitcherButton = v5 })

				local analytics = self.props.analytics

				local v6 = if v5 then eventStreamConstants.State.SwitchAccountsShown else eventStreamConstants.State.SwitchAccountsBlobEmpty
				analytics.reportAuthButtonShown(
					eventStreamConstants.Context.LandingScreen,
					eventStreamConstants.Button.SwitchAccounts,
					v6,
					eventStreamConstants.Origin.LandingScreen
				)
			end

			if accountBlob and accountBlob ~= "" then
				local showAccountSwitcher = self.props.showAccountSwitcher
				local networking = self.props.networking

				local analytics = self.props.analytics
				local appPolicy = self.props.appPolicy
				local omniRecommendationsRequest = self.props.omniRecommendationsRequest
				local enableSignedOutAccounts = self.props.enableSignedOutAccounts
				local showLoginRevamp = self.props.showLoginRevamp

				local openDesktopSignupDialogFromAccountSwitcher = if defineFastFlag6 then self.openDesktopSignupDialogFromAccountSwitcher else nil

				local v5 = if defineFastFlag6 then self.openDesktopLoginDialogFromAccountSwitcher else nil
				showAccountSwitcher(
					networking,
					fn,
					analytics,
					appPolicy,
					omniRecommendationsRequest,
					enableSignedOutAccounts,
					showLoginRevamp,
					openDesktopSignupDialogFromAccountSwitcher,
					v5
				)
			else
				local analytics = self.props.analytics
				local switchAccountsBlobEmpty = eventStreamConstants.State.SwitchAccountsBlobEmpty
				analytics.reportAuthButtonShown(
					eventStreamConstants.Context.LandingScreen,
					eventStreamConstants.Button.SwitchAccounts,
					switchAccountsBlobEmpty,
					eventStreamConstants.Origin.LandingScreen
				)
			end
		else
			local analytics = self.props.analytics
			local switchAccountsAmpHidden = eventStreamConstants.State.SwitchAccountsAmpHidden
			analytics.reportAuthButtonShown(
				eventStreamConstants.Context.LandingScreen,
				eventStreamConstants.Button.SwitchAccounts,
				switchAccountsAmpHidden,
				eventStreamConstants.Origin.LandingScreen
			)
		end
	end

	function self.getShouldShowKISAAgreements()
		return module22 and (self.props.useKoreaKISAUserAgreementPopup or module24)
	end

	function self.requestPioneerExpressSignup(p2, p3)
		self:setState({ isExpressSignupInProgress = true })

		local function fn(p4, p5)
			if p4 then
				self.requestPioneerExpressSignup(p2, p5)
			elseif self.isMounted then
				self:setState({ isExpressSignupInProgress = false })
			end
		end

		self.props.signUp(
			self.props.networking,
			self.props.omniRecommendationsRequest,
			self.props.guiService,
			fn,
			p3,
			self.props.appAnalytics,
			self.props.appPolicy,
			p2,
			false,
			false,
			false,
			false,
			self.props.analytics,
			false
		):catch(function()
			if self.isMounted then
				self:setState({ isExpressSignupInProgress = false })
			end
		end)
	end

	function self.startPioneerExpressSignup(p2)
		if fFlagEnableExpressSignup then
			self.requestPioneerExpressSignup({
				signupType = "Express",
				agreementIds = p2
			}, nil)
		else
			self.requestPioneerExpressSignup({
				username = "Pioneer" .. HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 13),
				isExpressSignup = true,
				agreementIds = p2
			}, nil)
		end
	end

	function self.openPioneerKISAUserAgreements(p2)
		self.props.openKISAUserAgreements({
			agreements = p2,
			useFoundationSheet = fFlagEnableKISAConsentModalization,
			onAgreeFunction = function(p3)
				analyticsEvents.sendButtonClickEvent(
					eventConstants.ctx.kisaAgreements,
					eventConstants.origin.signup,
					eventConstants.btn.agree
				)

				self.startPioneerExpressSignup(kisaComplianceUtils.getAgreedUserAgreements(p3))
			end,
			onAbandonFunction = function()
				analyticsEvents.sendButtonClickEvent(
					eventConstants.ctx.kisaAgreements,
					eventConstants.origin.signup,
					eventConstants.btn.cancel
				)
			end,
			isUnderAgeFlow = false
		})
	end

	function self.fetchPioneerKISAAgreements()
		return module50(self.props.networking, self.props.analytics):andThen(function(list)
			if list and #list > 0 and self.isMounted then
				self:setState({ kisaAgreements = list })
			end

			return list
		end)
	end

	function self.fetchPioneerUserAgreements()
		local v5 = module50(self.props.networking, self.props.analytics):andThen(function(list)
			if list and #list > 0 and self.isMounted then
				self:setState({ userAgreements = list })
			end

			return list
		end)

		self.userAgreementsPrefetch = v5
		return v5
	end

	function self.startPioneerExpressSignupWithFetchedAgreements()
		local userAgreements = self.state.userAgreements

		if userAgreements and #userAgreements > 0 then
			self.startPioneerExpressSignup(getRequiredAgreementIds(userAgreements))
			return
		end

		self:setState({ isExpressSignupInProgress = true })

		local v5 = self.userAgreementsPrefetch

		if not v5 or v5:getStatus() ~= Promise.Status.Started then
			v5 = module50(self.props.networking, self.props.analytics)
		end

		v5:andThen(function(list)
			if not self.isMounted then
				return
			end

			if list and #list > 0 then
				self.startPioneerExpressSignup(getRequiredAgreementIds(list))
				return
			end

			self:setState({ isExpressSignupInProgress = false })

			self.props.showErrorToast()
		end, function()
			if self.isMounted then
				self:setState({ isExpressSignupInProgress = false })

				self.props.showErrorToast()
			end
		end)
	end

	function self.onPlayNowActivated()
		if self.state.isExpressSignupInProgress then
			return
		end

		self.props.analytics.reportAuthButtonClick(
			eventStreamConstants.Context.LandingScreen,
			eventStreamConstants.Button.PlayNow
		)

		if module25 and self.getShouldShowKISAAgreements() then
			if #self.state.kisaAgreements ~= 0 then
				self.openPioneerKISAUserAgreements(self.state.kisaAgreements)
				return
			end

			self:setState({ isExpressSignupInProgress = true })

			self.fetchPioneerKISAAgreements():andThen(function(list)
				if not self.isMounted then
					return
				end

				self:setState({ isExpressSignupInProgress = false })

				if list and #list > 0 then
					self.openPioneerKISAUserAgreements(list)
				else
					self.props.showErrorToast()
				end
			end, function()
				if self.isMounted then
					self:setState({ isExpressSignupInProgress = false })

					self.props.showErrorToast()
				end
			end)
		elseif module26 then
			self.startPioneerExpressSignupWithFetchedAgreements()
		else
			self.startPioneerExpressSignup(nil)
		end
	end

	module35(self.props.networking):catch(function() end)

	if
		fFlagLuaEnableCustomizedInviteLandingPage
		and (self.props.isCustomizedLandingPageEnabled or fFlagLuaEnableCustomizedInviteLandingPageForTesting)
		or fFlagLuaEnableGenreLandingDeeplink
	then
		self.maybeShowCustomizedLandingPage()
	end
end

function extended.didUpdate(data, p2)
	if data.props.isCompact and not (defineFastFlag8 and shouldUseDeviceSafeInsets) then
		data.props.setStatusBarHeight(uiConstants.STATUS_BAR_HEIGHT)
	end

	data.maybeRefreshExternalIdentityCapabilities()
	data.reportLandingExternalIdentityImpressions()
end

function extended:render()
	local page = self:renderPage()

	if not FFlagEnableDesktopSsoSignupDialog then
		return page
	end

	local createFragment = module.createFragment

	local v6 = if self.state.isDesktopSignupDialogOpen then module.createElement(require("@luauforge/bundled/gvT"), {
		onClose = self.closeDesktopSignupDialog,
		usesKoreaKISAAgreements = module32 and self.getShouldShowKISAAgreements(),
		shouldSkipVPCSignupFlow = self.props.shouldSkipVPCSignupFlow
	}) else nil
	return createFragment({ Page = page, DesktopSignupDialog = v6 })
end

function extended:renderPage()
	local v5 = fFlagEnablePioneerLandingPageLayout and isPioneerLaunch()
	local shouldDisplayBrazilAgeRatingIXP = self.props.showBrazilContentRatingLogo
		and (self.props.shouldDisplayBrazilAgeRatingIXP or module23)
	local thirdPartyUserService = self.props.thirdPartyUserService or ThirdPartyUserService
	local v6

	if self.props.thirdPartyUserServiceAccountSwitchingSupported == nil then
		v6 = engineFeature2
	else
		v6 = self.props.thirdPartyUserServiceAccountSwitchingSupported
	end

	if not v5 and isAccountPickerEnabled(self.props) and #self.state.accountPickerAccounts > 0 then
		return module.createElement(accountPickerListView, {
			accounts = self.state.accountPickerAccounts,
			externalIdentityProviders = self.getExternalIdentityProviders(),
			activeExternalIdentityProvider = self.state.activeExternalIdentityProvider,
			isRedesign = self.isExternalIdentityEligible(),
			onExternalIdentityActivated = function(p2)
				self.startExternalIdentityFlow(
					p2,
					eventStreamConstants.Context.AccountPickerLandingScreenListView
				)
			end,
			onAvatarActivated = function(p2, p3, p4)
				local function signIn()
					self.navigateToLogin(self.state.credProtocolIsAvailableResponse, p3)
				end

				if not p4 then
					self.navigateToLogin(self.state.credProtocolIsAvailableResponse, p3)

					return
				end

				appStorageUtilities.setAccountSwitchTargetUsername(p3)
				appStorageUtilities.flush()
				self.props.navigateSwitchToAccount(
					self.props.networking,
					p2,
					self.props.appPolicy,
					self.props.omniRecommendationsRequest,
					self.props.analytics,
					signIn
				)
			end,
			setAccountPickerAccounts = function(p2)
				self:setState({ accountPickerAccounts = p2 })
			end,
			navigateToSignup = function()
				self.navigateToSignUp(self.state.credProtocolIsAvailableResponse)
			end,
			navigateToLogin = function()
				self.navigateToLogin(self.state.credProtocolIsAvailableResponse, "")
			end
		})
	end

	if not v5 then
		return withLocalization({
			signUpText = "Authentication.SignUp.Action.CreateAccount",
			signInText = "Authentication.Login.Action.SignIn",
			signUpSentenceCaseText = "Authentication.SignUp.Action.CreateAccountSentenceCase",
			signInSentenceCaseText = "Authentication.Login.Action.SignInSentenceCase",
			switchAccountsText = "Authentication.AccountSwitch.Action.SwitchAccount"
		})(function(props2)
			local landingPage = self.props.tokens.LuaApps.LandingPage
			local v7 = self.props.uiModeInfo.uiMode == uiMode.TenFoot
			local v8 = if v7 then tenFootLogoWithContentsLayout else module8
			local customizedInviteLandingPage = isCustomizedInviteLandingPage({
				shouldShowCustomizedLandingPage = self.state.shouldShowCustomizedLandingPage,
				deepLinkData = self.state.deepLinkData
			})

			if customizedInviteLandingPage then
				v8 = module15
			end

			local externalIdentityProviders = self.getExternalIdentityProviders()
			local v9 = self.isAuthenticationCardArm() and not (v7 or customizedInviteLandingPage)

			local v10 = module43

			if v10 then
				if self.getExternalIdentityLoginVariant() == authEntryVariant.Control then
					v10 = false
				else
					local props3 = self.props
					local v11 = module30

					if v11 then
						local platform = props3.platform
						v11 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
					end

					v10 = not (v11 or v7)
						and not customizedInviteLandingPage
						and self.props.formFactor == formFactor.COMPACT
				end
			end

			local v11 = module28
				and self.getExternalIdentityLoginVariant() ~= authEntryVariant.Control
				and 32
				or 40
			local v12 = v10 or v9 or module42
			local v13 = if v9 then buttonSize.Medium else buttonSize.Large

			local v14 = if v10 then props2.signUpSentenceCaseText else props2.signUpText

			local v15 = if v10 then props2.signInSentenceCaseText else props2.signInText

			local fFlagLandingAndAccountPickerSsoTelemetry = require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry
			local v16 = if fFlagLandingAndAccountPickerSsoTelemetry then self.getLandingTelemetryState() else nil

			local createElement = module.createElement

			local v18 = if v10 or v9 then buttonVariant.Emphasis else buttonVariant.SubEmphasis
			local element = createElement(button, {
				LayoutOrder = 1,
				testId = "--auth-landing-button-signup",
				variant = v18,
				size = v13,
				text = v14,
				onActivated = function()
					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.LandingSignupButtonClickedConfig,
						1
					)

					if fFlagLandingAndAccountPickerSsoTelemetry then
						self.props.analytics.reportAuthButtonClick(
							eventStreamConstants.Context.LandingScreen,
							eventStreamConstants.Button.SignUp,
							v16,
							nil,
							nil,
							eventStreamConstants.Origin.LandingScreen
						)
					elseif module33 then
						self.props.analytics.reportAuthButtonClick(
							eventStreamConstants.Context.LandingScreen,
							eventStreamConstants.Button.SignUp
						)
					end

					self.navigateToSignUp(self.state.credProtocolIsAvailableResponse)
				end,
				width = UDim.new(1, 0),
				[module.Ref] = self.props.defaultRef
			})
			local v19

			if fFlagEnableLuaAccountSwitch == true then
				v19 = self.state.shouldShowAccountSwitcherButton

				if v19 then
					local createElement2 = module.createElement

					local v22 = if v12 then buttonVariant.Standard else buttonVariant.Subtle
					v19 = createElement2(button, {
						LayoutOrder = 2,
						testId = "--auth-landing-button-switch-account",
						variant = v22,
						size = v13,
						isDisabled = self.state.activeExternalIdentityProvider ~= nil,
						width = UDim.new(1, 0),
						text = props2.switchAccountsText,
						onActivated = function()
							if fFlagLandingAndAccountPickerSsoTelemetry then
								self.props.analytics.reportAuthButtonClick(
									eventStreamConstants.Context.LandingScreen,
									eventStreamConstants.Button.SwitchAccounts,
									v16,
									nil,
									nil,
									eventStreamConstants.Origin.LandingScreen
								)
							else
								self.props.analytics.reportSwitchAccountButtonClicked(eventStreamConstants.Context.LandingScreen)
							end

							self.openAccountSwitcher()
						end
					})
				end
			else
				v19 = false
			end

			local createElement2 = module.createElement

			local v22 = if v12 then buttonVariant.Standard else buttonVariant.Subtle
			local element2 = createElement2(button, {
				LayoutOrder = 3,
				testId = "--auth-landing-button-login",
				variant = v22,
				size = v13,
				width = UDim.new(1, 0),
				text = v15,
				onActivated = function()
					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.LandingLoginButtonClickedConfig,
						1
					)

					self.props.analytics.reportLogInButtonClicked(eventStreamConstants.Context.LandingScreen)

					if fFlagLandingAndAccountPickerSsoTelemetry then
						self.props.analytics.reportAuthButtonClick(
							eventStreamConstants.Context.LandingScreen,
							eventStreamConstants.Button.LogIn,
							v16,
							nil,
							nil,
							eventStreamConstants.Origin.LandingScreen
						)
					else
						self.props.analytics.reportAuthButtonClick(
							eventStreamConstants.Context.LandingScreen,
							eventStreamConstants.Button.LogIn
						)
					end

					self.navigateToLogin(self.state.credProtocolIsAvailableResponse)
				end
			})
			local v23

			if module28 and self.state.accountPickerResolved and #externalIdentityProviders > 0 then
				v23 = module.createElement(externalIdentitySignInOptions, {
					layoutOrder = 4,
					providers = externalIdentityProviders,
					size = buttonSize.Large,
					onActivated = function(p2)
						self.startExternalIdentityFlow(p2, eventStreamConstants.Context.LandingScreen)
					end
				})
			end

			local v24 = module39 and v7 and not customizedInviteLandingPage
			local v25

			if thirdPartyUserService and v6 and thirdPartyUserService:IsAccountSwitchingSupported() then
				v25 = module.createElement(thirdPartySwitchAccountComponent, {
					layoutOrder = v9 and 2 or module28 and 5 or 4,
					dividerTextKey = "CommonUI.Features.Labels.ConnectTo",
					labelTextKey = v24 and "Authentication.Login.Button.XboxAccountSwitcher" or nil,
					thirdPartyUserName = thirdPartyUserService:GetUserPlatformName(),
					onActivated = defineFastFlag7 and function()
						self.props.analytics.reportAuthButtonClick(
							eventStreamConstants.Context.LandingScreen,
							eventStreamConstants.Button.SwitchPlatformAccount
						)
					end or nil
				})
			end

			if v24 then
				local module52 = require("@luauforge/bundled/gxY")
				local module53 = require("@luauforge/bundled/gyg")
				local createFragment = module.createFragment
				local v26 = {
					CrossDeviceMagicSignIn = module.createElement(module52, {
						containerRef = self.props.containerRef,
						defaultRef = self.props.defaultRef,
						renderQrPane = function(p2)
							return module.createElement(module53, {
								loginCallback = p2,
								isOverlay = false,
								isDualLayout = true,
								refreshCodeAfterHandoff = true,
								renderCodePanel = self.renderCrossDeviceCodePanel
							})
						end,
						switchAccount = v25
					}),
					BrazilContentRatingBadge = 0
				}

				local v27 = if shouldDisplayBrazilAgeRatingIXP then module.createElement(
					Foundation.View,
					{
						Position = UDim2.new(0.5, 0, 1, -36),
						ZIndex = 2,
						tag = "anchor-bottom-center auto-xy"
					},
					{
						Badge = module.createElement(brazilContentRatingBadge)
					}
				) else nil
				v26.BrazilContentRatingBadge = v27
				return createFragment(v26)
			else
				local v26

				if not (self.props.useVNGUserAgreementPopup or self.getShouldShowKISAAgreements() or v7) then
					local createElement3 = module.createElement
					local v28 = {
						LayoutOrder = v9 and 3 or module28 and 6 or 5,
						variant = 0,
						underlineLinks = 0,
						underlinedLinkTextTag = 0,
						ctx = 0,
						state = 0
					}

					local v29 = if v10 or v9 then AuthCommon.Enums.DisclaimerLinksVariant.Foundation else nil
					v28.variant = v29

					v28.underlineLinks = v10 or v9
					v28.underlinedLinkTextTag = v9 and "text-title-medium" or nil

					local v30 = if fFlagLandingAndAccountPickerSsoTelemetry then eventStreamConstants.Context.LandingScreen else nil
					v28.ctx = v30

					v28.state = if fFlagLandingAndAccountPickerSsoTelemetry then v16 else nil
					v26 = createElement3(module9, v28)
				end

				local v27 = {
					UIListLayout = module.createElement("UIListLayout", {
						Padding = UDim.new(0, v10 and 8 or landingPage.contentPadding),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Bottom
					}),
					UIPadding = module.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v10 and 24 or 36)
					}),
					UISizeConstraint = module.createElement("UISizeConstraint", {
						MinSize = Vector2.new(0, 0),
						MaxSize = Vector2.new(landingPage.buttonWidth, 1e999)
					})
				}
				local v28

				if v9 then
					local join = Cryo.Dictionary.join
					local v29 = {
						UISizeConstraint = Cryo.None,
						AuthenticationActionCardSizeConstraint = module.createElement("UISizeConstraint", {
							MinSize = Vector2.new(0, 0),
							MaxSize = Vector2.new(429, 1e999)
						}),
						AuthenticationActionCard = 0,
						ThirdPartySwitchAccountComponent = 0
					}

					local createElement3 = module.createElement
					local view = Foundation.View

					local v31 = {
						PrimaryActions = module.createElement(
							Foundation.View,
							{
								LayoutOrder = 1,
								tag = "col gap-small size-full-0 auto-y"
							},
							{
								SignUpButton = element,
								AccountSwitchButton = v19,
								LoginButton = element2
							}
						),
						SsoActions = 0
					}

					local props3 = self.props
					local v32 = module30

					if v32 then
						local platform = props3.platform
						v32 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
					end

					local v33

					if
						(v32 or module28)
						and self.state.accountPickerResolved
						and #externalIdentityProviders > 0
					then
						v33 = module.createElement(externalIdentitySignInOptions, {
							layoutOrder = 2,
							providers = externalIdentityProviders,
							size = buttonSize.Medium,
							onActivated = function(p2)
								self.startExternalIdentityFlow(
									p2,
									eventStreamConstants.Context.LandingScreen
								)
							end
						})
					end

					v31.SsoActions = v33
					v29.AuthenticationActionCard = createElement3(view, {
						LayoutOrder = 1,
						tag = {
							["col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0"] = true,
							["stroke-position-inner"] = defineFastFlag5
						},
						testId = "landing-page-authentication-action-card"
					}, v31)

					v29.ThirdPartySwitchAccountComponent = v25
					v28 = join(v27, v29)
				elseif v10 then
					v28 = Cryo.Dictionary.join(v27, {
						CallsToAction = module.createElement(
							Foundation.View,
							{
								LayoutOrder = 1,
								tag = "col gap-medium size-full-0 auto-y"
							},
							{
								PrimaryActions = module.createElement(
									Foundation.View,
									{
										LayoutOrder = 1,
										tag = "col gap-small size-full-0 auto-y"
									},
									{
										SignUpButton = element,
										AccountSwitchButton = v19,
										LoginButton = element2
									}
								),
								ExternalIdentitySignInOptions = v23
							}
						),
						ThirdPartySwitchAccountComponent = v25,
						DisclaimerLinks = v26
					})
				else
					v28 = Cryo.Dictionary.join(v27, {
						SignUpButton = element,
						AccountSwitchButton = v19,
						LoginButton = element2,
						ExternalIdentitySignInOptions = v23,
						ThirdPartySwitchAccountComponent = v25,
						DisclaimerLinks = v26
					})
				end

				local createElement3 = module.createElement
				local v30 = if v7 or self.props.formFactor ~= formFactor.COMPACT then alignment.Top else alignment.Bottom

				local v31 = if module27 or v9 then appPage.Landing else nil
				local v29 = {
					ContentAlign = v30,
					appPage = v31,
					ref = self.props.containerRef,
					VNAgeBadgeEnabled = self.props.showVNGAge12Badge,
					screenSize = 0,
					statusBarHeight = 0,
					globalGuiInset = 0,
					deepLinkData = 0,
					containerRef = 0,
					FooterElement = 0,
					FooterHeight = 0,
					mobileBackgroundFade = 0,
					logoMaxWidth = 0,
					logoPositionYScale = 0,
					bodyPositionYScale = 0,
					minLogoBodyGap = 0,
					centerLogoAndContents = 0
				}
				local v32 = if customizedInviteLandingPage then self.props.screenSize else nil
				v29.screenSize = v32
				local v33 = if customizedInviteLandingPage then self.props.statusBarHeight else nil
				v29.statusBarHeight = v33
				local v34 = if customizedInviteLandingPage then self.props.globalGuiInset else nil
				v29.globalGuiInset = v34
				local v35 = if customizedInviteLandingPage then self.state.deepLinkData else nil
				v29.deepLinkData = v35
				v29.containerRef = self.props.containerRef

				if shouldDisplayBrazilAgeRatingIXP and v9 then
					v26 = module.createElement(
						Foundation.View,
						{ tag = "col align-x-center gap-small auto-xy" },
						{
							BrazilContentRatingBadge = module.createElement(brazilContentRatingBadge, {
								LayoutOrder = 1
							}),
							DisclaimerLinks = v26
						}
					)
				elseif shouldDisplayBrazilAgeRatingIXP then
					v26 = module.createElement(brazilContentRatingBadge)
				elseif not v9 then
					v26 = nil
				end

				v29.FooterElement = v26

				local v36 = if shouldDisplayBrazilAgeRatingIXP and v9 then landingPage.brazilBadgeHeight + 36 else not shouldDisplayBrazilAgeRatingIXP and (v9 and 36 or 0) or landingPage.brazilBadgeHeight
				v29.FooterHeight = v36

				v29.mobileBackgroundFade = v10
				v29.logoMaxWidth = v9 and 300 or nil
				v29.logoPositionYScale = v9 and 0.34 or nil
				v29.bodyPositionYScale = v9 and 0.42 or nil
				v29.minLogoBodyGap = v9 and 32 or nil

				if defineFastFlag4 then
					if v9 then
						local props3 = self.props
						v9 = module30

						if v9 then
							local platform = props3.platform
							v9 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
						end
					end
				else
					v9 = nil
				end

				v29.centerLogoAndContents = v9
				return createElement3(v8, v29, {
					LandingPageContents = module.createElement(FitChildren.FitFrame, {
						Size = UDim2.new(1, -v11, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						ref = self.props.ref
					}, v28)
				})
			end
		end)
	end

	local createElement = module.createElement
	local v8 = {
		onPlayNow = self.onPlayNowActivated,
		onSignIn = function()
			if fFlagEnablePioneerLandingPageSso and self.state.activeExternalIdentityProvider ~= nil then
				return
			end

			self.props.loggingProtocol:logRobloxTelemetryCounter(
				telemetryConfigs.LandingLoginButtonClickedConfig,
				1
			)

			self.props.analytics.reportLogInButtonClicked(eventStreamConstants.Context.LandingScreen)
			self.props.analytics.reportAuthButtonClick(
				eventStreamConstants.Context.LandingScreen,
				eventStreamConstants.Button.LogIn
			)

			self.navigateToLogin(self.state.credProtocolIsAvailableResponse)
		end,
		onCreateAccount = fFlagGameLandingPageAuthLayout and function()
			if fFlagEnablePioneerLandingPageSso and self.state.activeExternalIdentityProvider ~= nil then
				return
			end

			self.props.loggingProtocol:logRobloxTelemetryCounter(
				telemetryConfigs.LandingSignupButtonClickedConfig,
				1
			)

			if require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry then
				self.props.analytics.reportAuthButtonClick(
					eventStreamConstants.Context.LandingScreen,
					eventStreamConstants.Button.SignUp,
					self.getLandingTelemetryState(),
					nil,
					nil,
					eventStreamConstants.Origin.LandingScreen
				)
			elseif module33 then
				self.props.analytics.reportAuthButtonClick(
					eventStreamConstants.Context.LandingScreen,
					eventStreamConstants.Button.SignUp
				)
			end

			self.navigateToSignUp(self.state.credProtocolIsAvailableResponse)
		end or nil,
		defaultRef = self.props.defaultRef,
		containerRef = self.props.containerRef,
		showBrazilContentRatingBadge = shouldDisplayBrazilAgeRatingIXP,
		isSignUpInProgress = self.state.isExpressSignupInProgress,
		externalIdentityProviders = 0,
		activeExternalIdentityProvider = 0,
		onExternalIdentityActivated = 0
	}

	local v9 = if fFlagEnablePioneerLandingPageSso then self.getExternalIdentityProviders() else nil
	v8.externalIdentityProviders = v9

	local v10 = if fFlagEnablePioneerLandingPageSso then self.state.activeExternalIdentityProvider else nil
	v8.activeExternalIdentityProvider = v10

	v8.onExternalIdentityActivated = fFlagEnablePioneerLandingPageSso and function(p2)
		self.startExternalIdentityFlow(p2, eventStreamConstants.Context.LandingScreen)
	end or nil
	return createElement(gameLandingPageLayout, v8)
end

function extended:didMount()
	self.isMounted = true
	self.maybeRefreshExternalIdentityCapabilities()

	if fFlagPioneerLeaveLogsOut then
		module48.onLandingPageShown()
	end

	if isAccountPickerEnabled(self.props) and not module28 then
		local props = self.props
		local v5 = module30

		if v5 then
			local platform = props.platform
			v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX
		end

		if v5 then
			if isAccountPickerEnabled(self.props) and not pcall(function()
				getAccountsListWithSignedOutAccounts(self.props.networking, {
					isAuthenticated = false,
					filterUnauthenticatedSessionsForAccountPicker = true
				}):andThen(function(p2)
					if self.isMounted then
						self:setState({
							accountPickerAccounts = p2,
							accountPickerResolved = true
						})
					end
				end):catch(function(p2)
					warn(p2)

					if self.isMounted then
						self:setState({ accountPickerResolved = true })
					end
				end)
			end) then
				self:setState({ accountPickerResolved = true })
			end
		else
			pcall(function()
				getAccountsListWithSignedOutAccounts(self.props.networking, {
					isAuthenticated = false,
					filterUnauthenticatedSessionsForAccountPicker = true
				}):andThen(function(p2)
					self:setState({ accountPickerAccounts = p2 })
				end):catch(function(p2)
					warn(p2)
				end)
			end)
		end
	elseif isAccountPickerEnabled(self.props) and not pcall(function()
		getAccountsListWithSignedOutAccounts(self.props.networking, {
			isAuthenticated = false,
			filterUnauthenticatedSessionsForAccountPicker = true
		}):andThen(function(p2)
			if self.isMounted then
				self:setState({
					accountPickerAccounts = p2,
					accountPickerResolved = true
				})
			end
		end):catch(function(p2)
			warn(p2)

			if self.isMounted then
				self:setState({ accountPickerResolved = true })
			end
		end)
	end) then
		self:setState({ accountPickerResolved = true })
	end

	involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
		eventStreamConstants.Origin.LandingScreen,
		""
	)

	if not (fFlagEnablePioneerLandingPageLayout and isPioneerLaunch()) then
		IXPService:LogBrowserTrackerLayerExposure(appBtidLayers.AccountSwitcherLayer)
		self.openAccountSwitcher()
	end

	if
		module25
		and fFlagEnablePioneerLandingPageLayout
		and isPioneerLaunch()
		and module22
		and (self.props.useKoreaKISAUserAgreementPopup or module24)
	then
		self.fetchPioneerKISAAgreements():catch(function() end)
	end

	if
		module26
		and fFlagEnablePioneerLandingPageLayout
		and isPioneerLaunch()
		and not (module25 and self.getShouldShowKISAAgreements())
	then
		self.fetchPioneerUserAgreements():catch(function() end)
	end

	self.props.loggingProtocol:logEventOnce("landing_page_did_mount")

	if defineFastFlag3 then
		local success, result = pcall(function()
			module47.init()
		end)

		if not (success and result) then
			self.props.analytics.reportAuthClientError(
				eventStreamConstants.Context.LandingScreen,
				"prewarm_challenge_webview_error"
			)
		end
	end

	self.props.loggingProtocol:logRobloxTelemetryCounter(
		telemetryConfigs.LandingPageMountTelemetryConfig,
		1
	)

	if engineFeature then
		self.props.appLifecycleObserverService:TriggerOnLandingPageMount()
	end

	local url = preAuthDeepLinkUrlStore.getUrl()

	if require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry then
		local landingTelemetryState = self.getLandingTelemetryState()
		local reportAuthPageload = self.props.analytics.reportAuthPageload
		local landingScreen = eventStreamConstants.Context.LandingScreen

		if url and url ~= "" then
			landingTelemetryState = `{landingTelemetryState}:{url}`
		end

		reportAuthPageload(
			landingScreen,
			landingTelemetryState,
			nil,
			eventStreamConstants.Origin.LandingScreen
		)
	else
		self.props.analytics.reportAuthPageload(eventStreamConstants.Context.LandingScreen, url)
	end

	local lastTime = os.clock()

	default:isAvailable(default.CredentialsTypes.all, getFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p2)
		self.props.analytics.reportAuthPageload(
			eventStreamConstants.Context.LandingPageIsAvailablePrefetch,
			(tostring(os.clock() - lastTime))
		)

		self:setState({ credProtocolIsAvailableResponse = p2 })
	end)

	module40.SetDarkThemeOverride()
end

function extended:willUnmount()
	self.isMounted = false
	authPageload(eventStreamConstants.Context.LandingPageUnmount)

	if defineFastFlag3 then
		pcall(function()
			module47.cleanup()
		end)
	end

	if not (getFFlagKeepDarkThemeOverrideWhenLoggedOut() and isLoggedOutUserId(self.props.localUserId) or fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()) then
		module40.ClearThemeOverride()
	end
end

local v5 = useSheetNavigation.connect(function(data, p2)
	local v6 = {
		formFactor = data.FormFactor,
		screenSize = data.ScreenSize,
		statusBarHeight = data.TopBar.statusBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		localUserId = 0
	}

	local v7 = if getFFlagKeepDarkThemeOverrideWhenLoggedOut() then data.LocalUserId else nil
	v6.localUserId = v7
	return v6
end, function(callback)
	return {
		fetchSignUpBundles = function(p2)
			return callback(module11.Fetch(p2))
		end,
		signUp = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
			return callback(module12(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
		end,
		openKISAUserAgreements = function(p2)
			analyticsEvents.sendPageLoadEvent(
				eventConstants.ctx.kisaAgreements,
				eventConstants.origin.signup
			)
			return callback(module51(p2))
		end,
		showErrorToast = function()
			return callback(module13({ HttpError = Enum.HttpError.OK }))
		end,
		navigateToSinglePageSignUp = function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage({
					name = appPage.SinglePageSignUp
				}))
			else
				callback(module6({ name = appPage.SinglePageSignUp }))
			end
		end,
		navigateToMultiPageSignUp = function(p2)
			local v6 = {
				name = appPage.MultiPageSignup,
				extraProps = {
					enforceResetState = true,
					credProtocolIsAvailableResponse = p2
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module6(v6))
			end
		end,
		navigateSwitchToAccount = function(p2, p3, p4, p5, p6, p7)
			callback(module46(p2, p3, p4, p5, p6, p7))
		end,
		navigateToBirthdayPage = function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage({
					name = appPage.Birthday
				}))
			else
				callback(module6({ name = appPage.Birthday }))
			end
		end,
		gotoLogin = function(p2)
			local v6 = {
				name = appPage.Login,
				extraProps = { forcedUsernameOverride = p2 }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module6(v6))
			end
		end,
		gotoLoginV2 = function(p2, p3, p4)
			local v6 = {
				name = appPage.LoginV2,
				extraProps = {
					credProtocolIsAvailableResponse = p2,
					forcedUsernameOverride = p3,
					forceDialogLayout = p4
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module6(v6))
			end
		end,
		showAccountSwitcher = function(p2, callback2, p3, p4, p5, p6, p7, p8, p9)
			callback(module20(
				true,
				p2,
				eventStreamConstants.Origin.LandingScreen,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9
			)):andThen(function(p10)
				if p10 ~= nil and callback2 then
					callback2(p10)
				end
			end)
		end,
		sessionCheck = function(p2, p3, p4, p5, p6)
			return callback(module44(p2, p3, p4, p5, p6))
		end,
		setStatusBarHeight = function(p2)
			return callback(module7(p2))
		end
	}
end)(extended)

local v6 = roactAppPolicy.connect(function(data)
	return {
		showVNGAge12Badge = data.getShowVNGAge12Badge(),
		useVNGUserAgreementPopup = data.getUseVNGUserAgreementPopup(),
		useKoreaKISAUserAgreementPopup = data.getUseKoreaKISAUserAgreementPopup(),
		excludeAccountSwitcher = data.getExcludeAccountSwitcher(),
		isAccountPickerEnabled = data.getAccountPickerEnabled(),
		isAccountSwitcherEnabled = data.getAccountSwitcherEnabled(),
		excludeExternalIdentityLogin = data.getExcludeExternalIdentityLogin(),
		showBrazilContentRatingLogo = data.getShowBrazilContentRatingLogo(),
		appPolicy = data
	}
end)(v5)

local v7 = (function(p2)
	return function(p3)
		local v8 = useUiModeInfo()
		local v9 = useDesignTokens()
		local v10 = module18()
		local v11 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Medium)
		local platform = p3.platform or UserInputService:GetPlatform()
		local v12 = AuthCommon.Experiments.useAuthEntryVariant(platform)

		local v13, v14 = ReactFocusNavigation.useDefaultFocusBehavior(v10)

		return module.createElement(p2, Cryo.Dictionary.join({
			uiModeInfo = v8,
			tokens = v9,
			eventHandlerRef = nil,
			defaultRef = v13,
			containerRef = v14,
			isCompact = v11,
			authEntryVariant = v12,
			platform = platform
		}, p3))
	end
end)((roactServices.connect({
	networking = module3,
	guiService = appGuiService,
	analytics = module5,
	appAnalytics = module4,
	omniRecommendationsRequest = appOmniRecommendationsRequest,
	loggingProtocol = appLogging,
	appLifecycleObserverService = appAppLifecycleObserverService
})(v6)))

if fFlagLuaEnableCustomizedInviteLandingPage then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.LandingLayer }, function(p2, p3)
		return {
			isCustomizedLandingPageEnabled = (p2[appBtidLayers.LandingLayer] or {}).isCustomizedLandingPageEnabled
		}
	end)(v7)
end

local function getSignupLayerVariables()
	return module38() or getFFlagEnableMultiPageSignup() or module22 or FFlagEnableDesktopSsoSignupDialog
end

if getSignupLayerVariables() then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2, p3)
		local v8 = p2[appBtidLayers.SignupLayer] or {}
		local v9 = {
			shouldShowMultipageSignupDirectionalTest = v8.shouldShowMultipageSignupDirectionalTest,
			shouldShowKoreanKISASignUpFlow = v8.shouldShowKoreanKISASignUpFlow,
			shouldEnableMultiPageSignup = v8.shouldEnableMultiPageSignup,
			useVerifiedSignupPage = 0,
			shouldUsePasskeySignup = 0,
			shouldSkipVPCSignupFlow = 0
		}

		local v10 = if FFlagEnableDesktopSsoSignupDialog then v8.contactMethodRequired else nil
		v9.useVerifiedSignupPage = v10

		local v11 = if FFlagEnableDesktopSsoSignupDialog then v8.shouldUsePasskeySignup else nil
		v9.shouldUsePasskeySignup = v11

		local v12 = if FFlagEnableDesktopSsoSignupDialog and module32 then v8.shouldSkipVPCSignupFlow else nil
		v9.shouldSkipVPCSignupFlow = v12
		return v9
	end)(v7)
end

local v8 = RoactAppExperiment.connectBrowserTrackerLayer({ fStringLuaLoginRevampIxpLayer }, function(p2, p3)
	local v9 = p2[fStringLuaLoginRevampIxpLayer] or {}
	return {
		showLoginRevamp = fFlagLoginV2FullFlowDevOverride or v9.showLoginRevamp
	}
end)(v7)

local v9 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.LandingLayer }, function(p2, p3)
	return {
		shouldDoSessionCheck = (p2[appBtidLayers.LandingLayer] or {}).shouldDoSessionCheck
	}
end)(v8)

local v10 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.LandingLayer }, function(p2, p3)
	return {
		shouldDisplayBrazilAgeRatingIXP = (p2[appBtidLayers.LandingLayer] or {}).shouldDisplayBrazilAgeRating
	}
end)(v9)

local v11 = RoactAppExperiment.connectBrowserTrackerLayer(
	{ appBtidLayers.AccountSwitcherLayer },
	function(p2, p3)
		return {
			enableSignedOutAccounts = (p2[appBtidLayers.AccountSwitcherLayer] or {}).enableAccountSwitcherSignedOutAccounts == true
		}
	end
)(v10)

return function(p2)
	local v12

	if module19.LuaAuthEnabledForLuobu() then
		v12 = useAppPolicy(function(p3)
			return p3.useLuobuAuthentication()
		end)
	else
		v12 = false
	end

	if v12 then
		return module.createElement(module14, p2)
	end

	local v13

	if fFlagLuafiedWechatQQLogin then
		v13 = useAppPolicy(function(p3)
			return p3.useWechatQQAuthentication()
		end)
	else
		v13 = false
	end

	if v13 then
		return module.createElement(wechatQQLoginPage, p2)
	end

	return module.createElement(v11, p2)
end
