local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local withLocalization = require(Modules.LuaApp.withLocalization)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Cryo = require(CorePackages.Packages.Cryo)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local SetStatusBarHeight = require(Modules.LuaApp.Actions.SetStatusBarHeight)
local LogoWithContentsLayout = require(Modules.LuaApp.Components.Authentication.LogoWithContentsLayout)
local TenFootLogoWithContentsLayout = require(Modules.LuaApp.Components.Authentication.TenFootLogoWithContentsLayout)
local DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FetchSignUpBundles = require(Modules.LuaApp.Thunks.Authentication.FetchSignUpBundles)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local LuobuLandingPage = require(Modules.Luobu.Components.Authentication.LuobuLandingPage)
local WechatQQLoginPage = require(CorePackages.Workspace.Packages.WechatQQAuth).Components.WechatQQLoginPage
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local VideoWithContentsLayout = require(Modules.LuaApp.Components.Authentication.VideoWithContentsLayout)
local CustomizedInviteLandingPageLayout = require(Modules.LuaApp.Components.Authentication.CustomizedInviteLandingPageLayout)
local GetFFlagEnableVideoLanding = require(Modules.LuaApp.Flags.GetFFlagEnableVideoLanding)
local v32 = game:DefineFastFlag("ShowCustomizedLandingPageWithoutInviter1", false)
local AppAppLifecycleObserverService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppAppLifecycleObserverService
local EngineFeature = game:GetEngineFeature("LandingPageMountSignalEnabled")
local GetFStringLandingVideoAsset = require(Modules.LuaApp.Flags.GetFStringLandingVideoAsset)
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local UIConstants = AuthCommon.Common.UIConstants
local ThirdPartySwitchAccountComponent = AuthCommon.Components.ThirdPartySwitchAccountComponent
local authTimingUtil = require(CorePackages.Workspace.Packages.AuthAnalytics).authTimingUtil
local LandingPageConstants = require(CorePackages.Workspace.Packages.LandingPage).Constants.LandingPageConstants
local useLandingPageNavigationBindings = require(Modules.LuaApp.Components.Authentication.useLandingPageNavigationBindings)
local Alignment = require(Modules.LuaApp.Enum.Alignment)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local OpenAccountSwitcher = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSwitcher)
local CredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local FFlagShouldLinkBrowserTrackerToDevice = require(Modules.LuaApp.Flags.FFlagShouldLinkBrowserTrackerToDevice)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local GetFFlagAddLandingPageAccountSwitcherIxpGating = require(Modules.LuaApp.Flags.GetFFlagAddLandingPageAccountSwitcherIxpGating)
local FFlagEnableKoreaKISACompliance = require(Modules.LuaApp.Flags.FFlagEnableKoreaKISACompliance)
local FFlagBypassIXPBrazilCompliance = require(Modules.LuaApp.Flags.FFlagBypassIXPBrazilCompliance)
local FFlagBypassIXPKoreaCompliance = require(Modules.LuaApp.Flags.FFlagBypassIXPKoreaCompliance)
local FFlagBypassGUACKoreaCompliance = require(Modules.LuaApp.Flags.FFlagBypassGUACKoreaCompliance)
local PostAssociateBrowserTrackerToDevice = require(Modules.LuaApp.Http.Requests.PostAssociateBrowserTrackerToDevice)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local getDeepLinkData = require(Modules.LuaApp.Thunks.Authentication.Util.getDeepLinkData)
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local FFlagEnableLuaLoginRevamp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLuaLoginRevamp
local FFlagLuafiedWechatQQLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuafiedWechatQQLogin
local FStringLuaLoginRevampIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaLoginRevampIxpLayer
local GetFFlagEnableMultiPageSignup = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableMultiPageSignup
local FFlagLuaEnableCustomizedInviteLandingPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableCustomizedInviteLandingPage
local FFlagLuaEnableCustomizedInviteLandingPageForTesting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableCustomizedInviteLandingPageForTesting
local FFlagEnableLoginV1ForcedUsernameOverride = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLoginV1ForcedUsernameOverride
local FFlagEnableLoginV2ForcedUsernameOverride = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLoginV2ForcedUsernameOverride
local FFlagEnableAuthButtonShownEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAuthButtonShownEvent
local v77 = game:DefineFastFlag("CustomizedLandingEDP", false)
local v78 = game:DefineFastFlag("CustomizedLandingLaunchGame", false)
local v79 = game:DefineFastFlag("EnablePrewarmChallengeWebView", false)
local v80 = game:DefineFastString("CustomizedLandingExperienceSort", "")

local function parseStringToSet(p1) -- line: 111
	local t1 = {}

	for match in string.gmatch(p1, "([^,]+)") do
		local v127 = match:gsub("^%s*(.-)%s*$", "%1")

		if v127 ~= "" then
			t1[v127] = true
		end
	end

	return t1
end

local v82 = parseStringToSet(v80)
local InvoluntaryLogoutAnalyticsEvents = AuthCommon.Analytics.InvoluntaryLogoutAnalyticsEvents
local authPageload = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authPageload
local v85 = Roact.PureComponent:extend("LandingPage")

local function reportLandingSwitchAccountsButtonShown(p2, s1: string) -- line: 133
	-- upvalues: FFlagEnableAuthButtonShownEvent (copy), EventStreamConstants (copy)
	if not FFlagEnableAuthButtonShownEvent then
		return
	end

	p2.reportAuthButtonShown(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.SwitchAccounts, s1, EventStreamConstants.Origin.LandingScreen)
end

local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableAccountSwitcherIxpExposureGating = SharedFlags.FFlagEnableAccountSwitcherIxpExposureGating
local FFlagUseStandardFoundationButtonVariant = require(Modules.LuaApp.Flags.FFlagUseStandardFoundationButtonVariant)
local GetFFlagEnableLuaAccountPicker = SharedFlags.GetFFlagEnableLuaAccountPicker
local GetFFlagEnableAccountSwitcherRedesignIXP = SharedFlags.GetFFlagEnableAccountSwitcherRedesignIXP
local SessionCheck = require(Modules.LuaApp.Thunks.Authentication.SessionCheck)
local AccountCarouselContainer = require(CorePackages.Workspace.Packages.LandingPage).Components.AccountCarouselContainer
local SwitchToAccount = require(Modules.LuaApp.Thunks.Authentication.AccountSwitcher.SwitchToAccount)
local GetAccountsListWithSignedOutAccounts = require(CorePackages.Workspace.Packages.AccountSwitching).GetAccountsListWithSignedOutAccounts
local PrewarmWebView = require(Modules.LuaApp.Thunks.Challenge.PrewarmWebView)
local FFlagAuthSecExclusions = SharedFlags.FFlagAuthSecExclusions
local GetFFlagSetStatusBarHeight = SharedFlags.GetFFlagSetStatusBarHeight
local FFlagEnableAuthDeepLinkReceiver = SharedFlags.FFlagEnableAuthDeepLinkReceiver
local FFlagLuaEnableGenreLandingDeeplink = SharedFlags.FFlagLuaEnableGenreLandingDeeplink
local PreAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
local GetUniverseIdFromPlaceId = AuthCommon.Thunks.GetUniverseIdFromPlaceId
local AccountPickerListView = require(CorePackages.Workspace.Packages.LandingPage).Components.AccountPickerListView
local GetFIntAccountPickerVariantOverride = SharedFlags.GetFIntAccountPickerVariantOverride
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local EngineFeature2 = game:GetEngineFeature("ThirdPartyUserServiceIsAccountSwitchingSupported")
local v114 = game:DefineFastFlag("ShowLandingPageThirdPartySwitchAccountButton", false)
local v115 = game:DefineFastFlag("ShowBrazilContentRatingBadge4", false)
local BrazilContentRatingBadge = require(CorePackages.Workspace.Packages.LandingPage).Components.BrazilContentRatingBadge

function v85.init(p3) -- line: 186
	-- upvalues: User (copy), authTimingUtil (copy), GetFFlagEnableVideoLanding (copy), GetFStringLandingVideoAsset (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), FFlagLuaEnableCustomizedInviteLandingPage (copy), FFlagLuaEnableCustomizedInviteLandingPageForTesting (copy), v77 (copy), getDeepLinkData (copy), v32 (copy), v78 (copy), ExperienceService (copy), GetUniverseIdFromPlaceId (copy), v80 (copy), v82 (copy), FFlagLuaEnableGenreLandingDeeplink (copy), LandingPageConstants (copy), EventStreamConstants (copy), GetFFlagEnableMultiPageSignup (copy), FlagSettings (copy), FFlagEnableLuaLoginRevamp (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), GetFFlagEnableLuaAccountPicker (copy), FFlagAuthSecExclusions (copy), FFlagEnableAuthButtonShownEvent (copy), FFlagEnableLuaAccountSwitch (copy), GetFFlagAddLandingPageAccountSwitcherIxpGating (copy), AppStorageUtilities (copy), FFlagEnableKoreaKISACompliance (copy), FFlagBypassGUACKoreaCompliance (copy), FFlagBypassIXPKoreaCompliance (copy), FFlagShouldLinkBrowserTrackerToDevice (copy), PostAssociateBrowserTrackerToDevice (copy)
	if p3.props.shouldDoSessionCheck then
		local v131 = User.fromLocalStorage()

		p3.props.sessionCheck(p3.props.networking, v131, p3.props.analytics, p3.props.appPolicy, p3.props.loggingProtocol)
	end

	authTimingUtil.landingPageLoadStart()
	p3.state = {
		shouldShowAccountSwitcherButton = false,
		landingVideoAsset = "",
		credProtocolIsAvailableResponse = nil,
		shouldShowCustomizedLandingPage = false,
		deepLinkData = nil,
		accountPickerAccounts = {}
	}

	if GetFFlagEnableVideoLanding() then
		if p3.props.landingVideoAsset and type(p3.props.landingVideoAsset) == "string" and string.len(p3.props.landingVideoAsset) > 0 then
			p3:setState({
				landingVideoAsset = p3.props.landingVideoAsset
			})
		else
			p3:setState({
				landingVideoAsset = GetFStringLandingVideoAsset()
			})
		end
	end

	function p3.maybeShowCustomizedLandingPage() -- line: 224
		-- upvalues: FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), FFlagLuaEnableCustomizedInviteLandingPage (copy), p3 (copy), FFlagLuaEnableCustomizedInviteLandingPageForTesting (copy), v77 (copy), getDeepLinkData (copy), v32 (copy), v78 (copy), ExperienceService (copy), GetUniverseIdFromPlaceId (copy), v80 (copy), v82 (copy), FFlagLuaEnableGenreLandingDeeplink (copy), LandingPageConstants (copy)
		local v176 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()

		if FFlagLuaEnableCustomizedInviteLandingPage and (p3.props.isCustomizedLandingPageEnabled or FFlagLuaEnableCustomizedInviteLandingPageForTesting) then
			if v77 and v176 and string.find(v176, "game_details") then
				local v177 = v176:match("gameId=(%d+)")

				if v177 then
					p3:setState({
						shouldShowCustomizedLandingPage = true,
						deepLinkData = {
							universeId = v177
						}
					})
				end
			end

			if v176 and string.find(v176, "share") then
				local v178 = getDeepLinkData(p3.props.networking, v176)

				if v178 then
					local universeId = v178.universeId
					local inviterId = v178.inviterId

					if v32 and universeId or universeId and inviterId then
						p3:setState({
							shouldShowCustomizedLandingPage = true,
							deepLinkData = v178
						})
					end
				end
			end

			if v78 then
				local PendingJoinAttempt = ExperienceService:GetPendingJoinAttempt()

				if PendingJoinAttempt then
					local placeId = PendingJoinAttempt.placeId

					if placeId then
						GetUniverseIdFromPlaceId(p3.props.networking, placeId):andThen(function(p4) -- line: 263
							-- upvalues: p3 (copy)
							if p4 then
								p3:setState({
									shouldShowCustomizedLandingPage = true,
									deepLinkData = {
										universeId = p4
									}
								})
							end
						end):catch(function(_) -- line: 272
						end)
					end
				end
			end

			if v80 and v176 and string.find(v176, "navigation/experience_sort") then
				local v183 = v176:match("sortId=([^&]+)")

				if v183 and v82[v183] then
					p3:setState({
						shouldShowCustomizedLandingPage = true,
						deepLinkData = {
							genre = v183
						}
					})
				end
			end
		end

		if FFlagLuaEnableGenreLandingDeeplink and v176 and string.find(v176, "navigation/genre") then
			local v184 = v176:match("genre=([^&]+)")

			if LandingPageConstants.Common.GetGenreBackgroundAssetId(v184) then
				p3:setState({
					shouldShowCustomizedLandingPage = true,
					deepLinkData = {
						genre = v184
					}
				})
			end
		end
	end
	function p3.navigateToSignUp(p6) -- line: 310
		-- upvalues: p3 (copy), EventStreamConstants (copy), GetFFlagEnableMultiPageSignup (copy), FlagSettings (copy)
		local networking = p3.props.networking
		local analytics = p3.props.analytics
		local fetchSignUpBundles = p3.props.fetchSignUpBundles
		local navigateToSinglePageSignUp = p3.props.navigateToSinglePageSignUp
		local navigateToMultiPageSignUp = p3.props.navigateToMultiPageSignUp
		local navigateToBirthdayPage = p3.props.navigateToBirthdayPage

		analytics.reportSignUpButtonClicked(EventStreamConstants.Context.LandingScreen)

		if GetFFlagEnableMultiPageSignup() and p3.props.shouldEnableMultiPageSignup then
			navigateToMultiPageSignUp(p6)

			return
		end

		if p3.props.shouldShowMultipageSignupDirectionalTest then
			navigateToBirthdayPage()

			return
		end

		if FlagSettings.SinglePageSignUpEnabled() then
			navigateToSinglePageSignUp()

			return
		end

		fetchSignUpBundles(networking)
		navigateToBirthdayPage()
	end
	function p3.navigateToLogin(p7, s2: string?) -- line: 340
		-- upvalues: FFlagEnableLuaLoginRevamp (copy), p3 (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy)
		if FFlagEnableLuaLoginRevamp and p3.props.showLoginRevamp then
			if FFlagEnableLoginV2ForcedUsernameOverride then
				p3.props.gotoLoginV2(p7, s2)

				return
			end

			p3.props.gotoLoginV2(p7)

			return
		end

		if FFlagEnableLoginV1ForcedUsernameOverride then
			p3.props.gotoLogin(s2)

			return
		end

		p3.props.gotoLogin()
	end
	function p3.openAccountSwitcher() -- line: 356
		-- upvalues: GetFFlagEnableLuaAccountPicker (copy), p3 (copy), FFlagAuthSecExclusions (copy), FFlagEnableAuthButtonShownEvent (copy), EventStreamConstants (copy), FFlagEnableLuaAccountSwitch (copy), GetFFlagAddLandingPageAccountSwitcherIxpGating (copy), AppStorageUtilities (copy)
		if GetFFlagEnableLuaAccountPicker() and (p3.props.accountPickerVariantEnabled ~= 0 and p3.props.accountPickerVariantEnabled ~= nil) then
			return
		end

		if FFlagAuthSecExclusions and p3.props.excludeAccountSwitcher then
			if FFlagEnableAuthButtonShownEvent then
				local analytics = p3.props.analytics
				local SwitchAccountsExclusionsHidden = EventStreamConstants.State.SwitchAccountsExclusionsHidden

				if not FFlagEnableAuthButtonShownEvent then
					return
				end

				analytics.reportAuthButtonShown(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.SwitchAccounts, SwitchAccountsExclusionsHidden, EventStreamConstants.Origin.LandingScreen)
			end

			return
		end

		if FFlagEnableLuaAccountSwitch == true and (not GetFFlagAddLandingPageAccountSwitcherIxpGating() or p3.props.isAccountSwitcherEnabled == true) then
			local v196 = AppStorageUtilities.getAccountBlob()

			if v196 and v196 ~= "" then
				p3.props.showAccountSwitcher(p3.props.networking, function(n1: number?) -- line: 380
					-- upvalues: p3 (copy), FFlagEnableAuthButtonShownEvent (copy), EventStreamConstants (copy)
					local v248 = n1 ~= nil and n1 > 0

					p3:setState({
						shouldShowAccountSwitcherButton = v248
					})

					if FFlagEnableAuthButtonShownEvent then
						local analytics = p3.props.analytics
						local v250 = if not v248 then EventStreamConstants.State.SwitchAccountsBlobEmpty else EventStreamConstants.State.SwitchAccountsShown

						if not FFlagEnableAuthButtonShownEvent then
							return
						end

						analytics.reportAuthButtonShown(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.SwitchAccounts, v250, EventStreamConstants.Origin.LandingScreen)
					end
				end, p3.props.analytics, p3.props.appPolicy, p3.props.omniRecommendationsRequest, p3.props.enableFoundationDesign, p3.props.enableSignedOutAccounts, p3.props.showLoginRevamp)

				return
			end

			if FFlagEnableAuthButtonShownEvent then
				local analytics = p3.props.analytics
				local SwitchAccountsBlobEmpty = EventStreamConstants.State.SwitchAccountsBlobEmpty

				if not FFlagEnableAuthButtonShownEvent then
					return
				end

				analytics.reportAuthButtonShown(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.SwitchAccounts, SwitchAccountsBlobEmpty, EventStreamConstants.Origin.LandingScreen)

				return
			end
		elseif FFlagEnableAuthButtonShownEvent then
			local analytics = p3.props.analytics
			local SwitchAccountsIxpHidden = EventStreamConstants.State.SwitchAccountsIxpHidden

			if not FFlagEnableAuthButtonShownEvent then
				return
			end

			analytics.reportAuthButtonShown(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.SwitchAccounts, SwitchAccountsIxpHidden, EventStreamConstants.Origin.LandingScreen)
		end
	end
	function p3.getShouldShowKISAAgreements() -- line: 424
		-- upvalues: FFlagEnableKoreaKISACompliance (copy), p3 (copy), FFlagBypassGUACKoreaCompliance (copy), FFlagBypassIXPKoreaCompliance (copy)
		return FFlagEnableKoreaKISACompliance and ((p3.props.useKoreaKISAUserAgreementPopup or FFlagBypassGUACKoreaCompliance) and (p3.props.shouldShowKoreanKISASignUpFlow or FFlagBypassIXPKoreaCompliance))
	end

	if FFlagShouldLinkBrowserTrackerToDevice() then
		local networking = p3.props.networking

		PostAssociateBrowserTrackerToDevice(networking):catch(function() -- line: 432
		end)
	end

	if FFlagLuaEnableCustomizedInviteLandingPage and (p3.props.isCustomizedLandingPageEnabled or FFlagLuaEnableCustomizedInviteLandingPageForTesting) or FFlagLuaEnableGenreLandingDeeplink then
		p3.maybeShowCustomizedLandingPage()
	end
end
function v85.didUpdate(p8, _) -- line: 443
	-- upvalues: GetFFlagSetStatusBarHeight (copy), UIConstants (copy)
	if GetFFlagSetStatusBarHeight() and p8.props.isCompact then
		p8.props.setStatusBarHeight(UIConstants.STATUS_BAR_HEIGHT)
	end
end
function v85.render(p10) -- line: 451
	-- upvalues: GetFFlagEnableLuaAccountPicker (copy), AccountCarouselContainer (copy), AccountPickerListView (copy), Roact (copy), AppStorageUtilities (copy), withLocalization (copy), UiMode (copy), TenFootLogoWithContentsLayout (copy), LogoWithContentsLayout (copy), FFlagLuaEnableGenreLandingDeeplink (copy), LandingPageConstants (copy), FFlagLuaEnableCustomizedInviteLandingPage (copy), GetFFlagEnableVideoLanding (copy), VideoWithContentsLayout (copy), CustomizedInviteLandingPageLayout (copy), v115 (copy), FFlagBypassIXPBrazilCompliance (copy), FormFactor (copy), Alignment (copy), BrazilContentRatingBadge (copy), FitChildren (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), TelemetryConfigs (copy), FFlagEnableLuaAccountSwitch (copy), FFlagUseStandardFoundationButtonVariant (copy), EventStreamConstants (copy), ThirdPartyUserService (copy), EngineFeature2 (copy), v114 (copy), ThirdPartySwitchAccountComponent (copy), DisclaimerLinks (copy)
	if GetFFlagEnableLuaAccountPicker() and (p10.props.accountPickerVariantEnabled ~= 0 and p10.props.accountPickerVariantEnabled ~= nil and #p10.state.accountPickerAccounts > 0) then
		local t2 = {
			[1] = AccountCarouselContainer,
			[2] = AccountPickerListView
		}

		return Roact.createElement(t2[p10.props.accountPickerVariantEnabled], {
			accounts = p10.state.accountPickerAccounts,
			avatarSize = UDim2.new(0, 160, 0, 240),
			onAvatarActivated = function(p11, p12, p13) -- line: 466
				-- upvalues: AppStorageUtilities (copy), p10 (copy)
				if p13 then
					AppStorageUtilities.setAccountSwitchTargetUsername(p12)
					AppStorageUtilities.flush()
					p10.props.navigateSwitchToAccount(p10.props.networking, p11, p10.props.appPolicy, p10.props.omniRecommendationsRequest, p10.props.analytics)

					return
				end

				p10.navigateToLogin(p10.state.credProtocolIsAvailableResponse, p12)
			end,
			setAccountPickerAccounts = function(p14) -- line: 481
				-- upvalues: p10 (copy)
				p10:setState({
					accountPickerAccounts = p14
				})
			end,
			navigateToSignup = function() -- line: 486
				-- upvalues: p10 (copy)
				p10.navigateToSignUp(p10.state.credProtocolIsAvailableResponse)
			end,
			navigateToLogin = function() -- line: 489
				-- upvalues: p10 (copy)
				p10.navigateToLogin(p10.state.credProtocolIsAvailableResponse, "")
			end
		})
	end

	return withLocalization({
		signUpText = "Authentication.SignUp.Action.CreateAccount",
		signInText = "Authentication.Login.Action.SignIn",
		switchAccountsText = "Authentication.AccountSwitch.Action.SwitchAccount"
	})(function(p15) -- line: 499
		-- upvalues: p10 (copy), UiMode (copy), TenFootLogoWithContentsLayout (copy), LogoWithContentsLayout (copy), FFlagLuaEnableGenreLandingDeeplink (copy), LandingPageConstants (copy), FFlagLuaEnableCustomizedInviteLandingPage (copy), GetFFlagEnableVideoLanding (copy), VideoWithContentsLayout (copy), CustomizedInviteLandingPageLayout (copy), v115 (copy), FFlagBypassIXPBrazilCompliance (copy), Roact (copy), FormFactor (copy), Alignment (copy), BrazilContentRatingBadge (copy), FitChildren (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), TelemetryConfigs (copy), FFlagEnableLuaAccountSwitch (copy), FFlagUseStandardFoundationButtonVariant (copy), EventStreamConstants (copy), ThirdPartyUserService (copy), EngineFeature2 (copy), v114 (copy), ThirdPartySwitchAccountComponent (copy), DisclaimerLinks (copy)
		local LandingPage = p10.props.tokens.LuaApps.LandingPage
		local v207 = p10.props.uiModeInfo.uiMode == UiMode.TenFoot
		local v208 = if not v207 then LogoWithContentsLayout else TenFootLogoWithContentsLayout
		local v209 = false

		if FFlagLuaEnableGenreLandingDeeplink and p10.state.shouldShowCustomizedLandingPage then
			local deepLinkData = p10.state.deepLinkData

			if deepLinkData and deepLinkData.genre then
				v209 = LandingPageConstants.Common.GetGenreBackgroundAssetId(deepLinkData.genre) ~= nil
			end
		end

		local v211 = FFlagLuaEnableCustomizedInviteLandingPage and p10.state.shouldShowCustomizedLandingPage or v209
		local v212 = GetFFlagEnableVideoLanding() and (p10.props.landingVideoEnabled and not v211)

		if v212 then
			v208 = VideoWithContentsLayout
		elseif v211 then
			v208 = CustomizedInviteLandingPageLayout
		end

		local signUpText = p15.signUpText
		local v214 = v115 and (p10.props.showBrazilContentRatingLogo and (p10.props.shouldDisplayBrazilAgeRatingIXP or FFlagBypassIXPBrazilCompliance))

		return Roact.createElement(v208, {
			ContentAlign = if v207 or p10.props.formFactor ~= FormFactor.COMPACT then Alignment.Top else Alignment.Bottom,
			ref = p10.props.containerRef,
			VNAgeBadgeEnabled = p10.props.showVNGAge12Badge,
			screenSize = if not GetFFlagEnableVideoLanding() and not v211 then nil else p10.props.screenSize,
			statusBarHeight = if not GetFFlagEnableVideoLanding() and not v211 then nil else p10.props.statusBarHeight,
			globalGuiInset = if not GetFFlagEnableVideoLanding() and not v211 then nil else p10.props.globalGuiInset,
			formFactor = if not GetFFlagEnableVideoLanding() then nil else p10.props.formFactor,
			landingVideoAsset = if not GetFFlagEnableVideoLanding() then nil else p10.state.landingVideoAsset,
			deepLinkData = if not v211 then nil else p10.state.deepLinkData,
			containerRef = p10.props.containerRef,
			FooterElement = if not v214 then nil else Roact.createElement(BrazilContentRatingBadge),
			FooterHeight = not v214 and 0 or LandingPage.brazilBadgeHeight
		}, {
			LandingPageContents = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -40, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				ref = p10.props.ref
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, LandingPage.contentPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 36)
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, 0),
					MaxSize = Vector2.new(LandingPage.buttonWidth, 1e999)
				}),
				SignUpButton = if v212 then Roact.createElement(Button, {
					LayoutOrder = 1,
					variant = ButtonVariant.Emphasis,
					size = ButtonSize.Large,
					width = UDim.new(1, 0),
					text = signUpText,
					onActivated = function() -- line: 599
						-- upvalues: p10 (copy), TelemetryConfigs (copy)
						p10.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.LandingSignupButtonClickedConfig, 1)
						p10.navigateToSignUp(p10.state.credProtocolIsAvailableResponse)
					end,
					[Roact.Ref] = p10.props.defaultRef
				}) else Roact.createElement(Button, {
					LayoutOrder = 1,
					variant = ButtonVariant.SubEmphasis,
					size = ButtonSize.Large,
					text = signUpText,
					onActivated = function() -- line: 580
						-- upvalues: p10 (copy), TelemetryConfigs (copy)
						p10.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.LandingSignupButtonClickedConfig, 1)
						p10.navigateToSignUp(p10.state.credProtocolIsAvailableResponse)
					end,
					width = UDim.new(1, 0),
					[Roact.Ref] = p10.props.defaultRef
				}),
				AccountSwitchButton = FFlagEnableLuaAccountSwitch == true and (p10.state.shouldShowAccountSwitcherButton and Roact.createElement(Button, {
					LayoutOrder = 2,
					variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
					size = ButtonSize.Large,
					width = UDim.new(1, 0),
					text = p15.switchAccountsText,
					onActivated = function() -- line: 620
						-- upvalues: p10 (copy), EventStreamConstants (copy)
						p10.props.analytics.reportSwitchAccountButtonClicked(EventStreamConstants.Context.LandingScreen)
						p10.openAccountSwitcher()
					end
				})),
				LoginButton = Roact.createElement(Button, {
					LayoutOrder = 3,
					variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
					size = ButtonSize.Large,
					width = UDim.new(1, 0),
					text = p15.signInText,
					onActivated = function() -- line: 636
						-- upvalues: p10 (copy), TelemetryConfigs (copy), EventStreamConstants (copy)
						p10.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.LandingLoginButtonClickedConfig, 1)
						p10.props.analytics.reportLogInButtonClicked(EventStreamConstants.Context.LandingScreen)
						p10.props.analytics.reportAuthButtonClick(EventStreamConstants.Context.LandingScreen, EventStreamConstants.Button.LogIn)
						p10.navigateToLogin(p10.state.credProtocolIsAvailableResponse)
					end
				}),
				ThirdPartySwitchAccountComponent = if not ThirdPartyUserService or (not EngineFeature2 or (not ThirdPartyUserService:IsAccountSwitchingSupported() or not v114)) then nil else Roact.createElement(ThirdPartySwitchAccountComponent, {
					layoutOrder = 4,
					dividerTextKey = "CommonUI.Features.Labels.ConnectTo",
					thirdPartyUserName = ThirdPartyUserService:GetUserPlatformName()
				}),
				DisclaimerLinks = if p10.props.useVNGUserAgreementPopup or (p10.getShouldShowKISAAgreements() or v207) then nil else Roact.createElement(DisclaimerLinks, {
					LayoutOrder = not v114 and 4 or 5
				})
			})
		})
	end)
end
function v85.didMount(p16) -- line: 671
	-- upvalues: GetFFlagEnableLuaAccountPicker (copy), GetAccountsListWithSignedOutAccounts (copy), InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), FFlagEnableAccountSwitcherIxpExposureGating (copy), IXPService (copy), AppBtidLayers (copy), GetFFlagEnableVideoLanding (copy), v79 (copy), PrewarmWebView (copy), TelemetryConfigs (copy), EngineFeature (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), SystemThemeFeature (copy)
	if GetFFlagEnableLuaAccountPicker() and (p16.props.accountPickerVariantEnabled ~= 0 and p16.props.accountPickerVariantEnabled ~= nil) then
		pcall(function() -- line: 677
			-- upvalues: GetAccountsListWithSignedOutAccounts (copy), p16 (copy)
			GetAccountsListWithSignedOutAccounts(p16.props.networking, {
				isAuthenticated = false,
				filterUnauthenticatedSessionsForAccountPicker = true
			}):andThen(function(p17) -- line: 681
				-- upvalues: p16 (copy)
				p16:setState({
					accountPickerAccounts = p17
				})
			end):catch(function(p18) -- line: 685
				warn(p18)
			end)
		end)
	end

	InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, "")

	if FFlagEnableAccountSwitcherIxpExposureGating then
		IXPService:LogBrowserTrackerLayerExposure(AppBtidLayers.AccountSwitcherLayer)
	end

	p16.openAccountSwitcher()

	if GetFFlagEnableVideoLanding() then
		p16.props.analytics.reportAuthPageload(EventStreamConstants.Context.LandingScreenVideo, (tostring(true)))
	else
		p16.props.analytics.reportAuthPageload(EventStreamConstants.Context.LandingScreenVideo, (tostring(false)))
	end

	p16.props.loggingProtocol:logEventOnce("landing_page_did_mount")

	if v79 then
		local ok, result = pcall(function() -- line: 705
			-- upvalues: PrewarmWebView (copy)
			PrewarmWebView.init()
		end)

		if not ok or not result then
			p16.props.analytics.reportAuthClientError(EventStreamConstants.Context.LandingScreen, "prewarm_challenge_webview_error")
		end
	end

	p16.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.LandingPageMountTelemetryConfig, 1)

	if EngineFeature then
		p16.props.appLifecycleObserverService:TriggerOnLandingPageMount()
	end

	local v140 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()

	p16.props.analytics.reportAuthPageload(EventStreamConstants.Context.LandingScreen, v140)

	local elapsed = os.clock()

	default:isAvailable(default.CredentialsTypes.all, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p19) -- line: 733
		-- upvalues: p16 (copy), EventStreamConstants (copy), elapsed (copy)
		p16.props.analytics.reportAuthPageload(EventStreamConstants.Context.LandingPageIsAvailablePrefetch, (tostring(os.clock() - elapsed)))
		p16:setState({
			credProtocolIsAvailableResponse = p19
		})
	end)
	SystemThemeFeature.SetDarkThemeOverride()
end
function v85.willUnmount(_) -- line: 746
	-- upvalues: authPageload (copy), EventStreamConstants (copy), v79 (copy), PrewarmWebView (copy), SystemThemeFeature (copy)
	authPageload(EventStreamConstants.Context.LandingPageUnmount)

	if v79 then
		pcall(function() -- line: 750
			-- upvalues: PrewarmWebView (copy)
			PrewarmWebView.cleanup()
		end)
	end

	SystemThemeFeature.ClearThemeOverride()
end

local v117 = RoactRodux.connect(function(p21, _) -- line: 758
	return {
		formFactor = p21.FormFactor,
		screenSize = p21.ScreenSize,
		statusBarHeight = p21.TopBar.statusBarHeight,
		globalGuiInset = p21.GlobalGuiInset
	}
end, function(p23) -- line: 765
	-- upvalues: FetchSignUpBundles (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), AppPage (copy), NavigateDown (copy), GetFFlagEnableLuaAccountPicker (copy), SwitchToAccount (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), OpenAccountSwitcher (copy), EventStreamConstants (copy), SessionCheck (copy), SetStatusBarHeight (copy)
	return {
		fetchSignUpBundles = function(p24) -- line: 767
			-- upvalues: p23 (copy), FetchSignUpBundles (copy)
			return p23(FetchSignUpBundles.Fetch(p24))
		end,
		navigateToSinglePageSignUp = function() -- line: 770
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), AppPage (copy), p23 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v18.down(v18.fromLegacyPage({
					name = AppPage.SinglePageSignUp
				}))

				return
			end

			p23(NavigateDown({
				name = AppPage.SinglePageSignUp
			}))
		end,
		navigateToMultiPageSignUp = function(p25) -- line: 777
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), p23 (copy), NavigateDown (copy)
			local t3 = {
				name = AppPage.MultiPageSignup,
				extraProps = {
					enforceResetState = true,
					credProtocolIsAvailableResponse = p25
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v18.down(v18.fromLegacyPage(t3))

				return
			end

			p23(NavigateDown(t3))
		end,
		navigateSwitchToAccount = function(p26, p27, p28, p29, p30) -- line: 791
			-- upvalues: GetFFlagEnableLuaAccountPicker (copy), p23 (copy), SwitchToAccount (copy)
			if not GetFFlagEnableLuaAccountPicker() then
				return
			end

			p23(SwitchToAccount(p26, p27, p28, p29, p30))
		end,
		navigateToBirthdayPage = function() -- line: 797
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), AppPage (copy), p23 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v18.down(v18.fromLegacyPage({
					name = AppPage.Birthday
				}))

				return
			end

			p23(NavigateDown({
				name = AppPage.Birthday
			}))
		end,
		gotoLogin = function(s3: string?) -- line: 804
			-- upvalues: AppPage (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), p23 (copy), NavigateDown (copy)
			local t4 = {
				name = AppPage.Login,
				extraProps = {
					forcedUsernameOverride = if not FFlagEnableLoginV1ForcedUsernameOverride then nil else s3
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v18.down(v18.fromLegacyPage(t4))

				return
			end

			p23(NavigateDown(t4))
		end,
		gotoLoginV2 = function(p31, s4: string?) -- line: 819
			-- upvalues: AppPage (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), p23 (copy), NavigateDown (copy)
			local t5 = {
				name = AppPage.LoginV2,
				extraProps = {
					credProtocolIsAvailableResponse = p31,
					forcedUsernameOverride = if not FFlagEnableLoginV2ForcedUsernameOverride then nil else s4
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v18.down(v18.fromLegacyPage(t5))

				return
			end

			p23(NavigateDown(t5))
		end,
		showAccountSwitcher = function(p32, p33, p34, p35, p36, p37, p38, p39) -- line: 835
			-- upvalues: p23 (copy), OpenAccountSwitcher (copy), EventStreamConstants (copy)
			p23(OpenAccountSwitcher(true, p32, EventStreamConstants.Origin.LandingScreen, p34, p35, p36, p37, p38, p39)):andThen(function(n2: number?) -- line: 857
				-- upvalues: p33 (copy)
				if n2 ~= nil and p33 then
					p33(n2)
				end
			end)
		end,
		sessionCheck = function(p40, p41, p42, p43, p44) -- line: 864
			-- upvalues: p23 (copy), SessionCheck (copy)
			return p23(SessionCheck(p40, p41, p42, p43, p44))
		end,
		setStatusBarHeight = function(p45) -- line: 867
			-- upvalues: p23 (copy), SetStatusBarHeight (copy)
			return p23(SetStatusBarHeight(p45))
		end
	}
end)(v85)
local v118 = RoactAppPolicy.connect(function(p46, _) -- line: 873
	return {
		showVNGAge12Badge = p46.getShowVNGAge12Badge(),
		useVNGUserAgreementPopup = p46.getUseVNGUserAgreementPopup(),
		useKoreaKISAUserAgreementPopup = p46.getUseKoreaKISAUserAgreementPopup(),
		excludeAccountSwitcher = p46.getExcludeAccountSwitcher(),
		showBrazilContentRatingLogo = p46.getShowBrazilContentRatingLogo(),
		appPolicy = p46
	}
end)(v117)
local v119 = RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService,
	analytics = RoactAnalyticsAuthEvents,
	loggingProtocol = AppLogging,
	appLifecycleObserverService = AppAppLifecycleObserverService
})(v118)

local function v120(p48) -- line: 893
	-- upvalues: useUiModeInfo (copy), useDesignTokens (copy), useLandingPageNavigationBindings (copy), GetFFlagSetStatusBarHeight (copy), Responsive (copy), ReactFocusNavigation (copy), Roact (copy), v119 (copy), Cryo (copy)
	local v149 = useUiModeInfo()
	local v150 = useDesignTokens()
	local v151 = useLandingPageNavigationBindings()
	local v152 = false

	if GetFFlagSetStatusBarHeight() then
		v152 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Medium)
	end

	local v153, v154 = ReactFocusNavigation.useDefaultFocusBehavior(v151)

	return Roact.createElement(v119, Cryo.Dictionary.join({
		eventHandlerRef = nil,
		uiModeInfo = v149,
		tokens = v150,
		defaultRef = v153,
		containerRef = v154,
		isCompact = v152
	}, p48))
end

if GetFFlagEnableVideoLanding() then
	v120 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.LandingLayer }, function(p49, _) -- line: 921
		-- upvalues: AppBtidLayers (copy)
		local v157 = p49[AppBtidLayers.LandingLayer] or {}

		return {
			landingVideoEnabled = v157.landingVideoEnabled,
			landingVideoAsset = v157.landingVideoAsset
		}
	end)(v120)
end

if FFlagLuaEnableCustomizedInviteLandingPage then
	v120 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.LandingLayer }, function(p51, _) -- line: 933
		-- upvalues: AppBtidLayers (copy)
		return {
			isCustomizedLandingPageEnabled = (p51[AppBtidLayers.LandingLayer] or {}).isCustomizedLandingPageEnabled
		}
	end)(v120)
end

if GetFFlagEnableLuaAccountPicker() then
	v120 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.LandingLayer }, function(p53, _) -- line: 944
		-- upvalues: AppBtidLayers (copy), GetFIntAccountPickerVariantOverride (copy)
		local v162 = p53[AppBtidLayers.LandingLayer] or {}

		return {
			accountPickerVariantEnabled = v162.accountPickerVariantEnabled and tonumber(v162.accountPickerVariantEnabled) or GetFIntAccountPickerVariantOverride()
		}
	end)(v120)
end

local function getSignupLayerVariables() -- line: 954
	-- upvalues: GetFFlagEnableMultiPageSignupExperiment (copy), GetFFlagEnableMultiPageSignup (copy), FFlagEnableKoreaKISACompliance (copy)
	return GetFFlagEnableMultiPageSignupExperiment() or (GetFFlagEnableMultiPageSignup() or FFlagEnableKoreaKISACompliance)
end

if GetFFlagEnableMultiPageSignupExperiment() or (GetFFlagEnableMultiPageSignup() or FFlagEnableKoreaKISACompliance) then
	v120 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.SignupLayer }, function(p55, _) -- line: 963
		-- upvalues: AppBtidLayers (copy)
		local v165 = p55[AppBtidLayers.SignupLayer] or {}

		return {
			shouldShowMultipageSignupDirectionalTest = v165.shouldShowMultipageSignupDirectionalTest,
			shouldShowKoreanKISASignUpFlow = v165.shouldShowKoreanKISASignUpFlow,
			shouldEnableMultiPageSignup = v165.shouldEnableMultiPageSignup
		}
	end)(v120)
end

if FFlagEnableLuaLoginRevamp then
	v120 = RoactAppExperiment.connectBrowserTrackerLayer({ FStringLuaLoginRevampIxpLayer }, function(p57, _) -- line: 976
		-- upvalues: FStringLuaLoginRevampIxpLayer (copy)
		return {
			showLoginRevamp = (p57[FStringLuaLoginRevampIxpLayer] or {}).showLoginRevamp
		}
	end)(v120)
end

local v122 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.LandingLayer }, function(p59, _) -- line: 986
	-- upvalues: AppBtidLayers (copy)
	return {
		shouldDoSessionCheck = (p59[AppBtidLayers.LandingLayer] or {}).shouldDoSessionCheck
	}
end)(v120)

if v115 then
	v122 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.LandingLayer }, function(p61, _) -- line: 996
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldDisplayBrazilAgeRatingIXP = (p61[AppBtidLayers.LandingLayer] or {}).shouldDisplayBrazilAgeRating
		}
	end)(v122)
end

local u123 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.AccountSwitcherLayer }, function(p63, _) -- line: 1006
	-- upvalues: AppBtidLayers (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy)
	local v174 = p63[AppBtidLayers.AccountSwitcherLayer] or {}

	if GetFFlagEnableAccountSwitcherRedesignIXP() then
		return {
			isAccountSwitcherEnabled = v174.isAccountSwitcherEnabled,
			enableFoundationDesign = v174.enableAccountSwitcherFoundationDesign == true,
			enableSignedOutAccounts = v174.enableAccountSwitcherSignedOutAccounts == true
		}
	end

	return {
		enableFoundationDesign = true,
		enableSignedOutAccounts = true,
		isAccountSwitcherEnabled = v174.isAccountSwitcherEnabled
	}
end)(v122)

return function(p65) -- line: 1023
	-- upvalues: FlagSettings (copy), useAppPolicy (copy), Roact (copy), LuobuLandingPage (copy), FFlagLuafiedWechatQQLogin (copy), WechatQQLoginPage (copy), u123 (ref)
	if not not FlagSettings.LuaAuthEnabledForLuobu() and useAppPolicy(function(p66) -- line: 1026
		return p66.useLuobuAuthentication()
	end) then
		return Roact.createElement(LuobuLandingPage, p65)
	end

	if not not FFlagLuafiedWechatQQLogin and useAppPolicy(function(p67) -- line: 1036
		return p67.useWechatQQAuthentication()
	end) then
		return Roact.createElement(WechatQQLoginPage, p65)
	end

	return Roact.createElement(u123, p65)
end
