local UserInputService, GuiService, MemStorageService, HttpService, LocalizationService, Cryo, Selectors, BackDisableStore, FFlagUseNavigationSelectors, FFlagUseBackDisableSignalStore, Roact, RoactRodux, RoactNetworking, RoactServices, RoactAnalyticsAuthEvents, RoactAppExperiment, RoactAppPolicy, RoactAnalytics, ReactFocusNavigation, LinkingProtocol, AppLinking, AppPage, Login, LoginByCode, LoginByPasskey, LoginByOtp, LaunchApp, StartPasskeyAuthentication, NavigateDown, OpenCentralOverlayForLoginPasswordResetPrompt, SetLoginResult, SetBackNavigationDisabled, SetCentralOverlay, CrossDeviceLogin, DisclaimerLinks, OpenAccountSelector, Logout, OpenEmailOtp, CloseCentralOverlay, NavigateBack, FFlagSignalsNavP3Dispatch, v50, GetIXPLayerParameters, LogoWithContentsLayout, DualLoginWithContentsLayout, CredentialLoginContainer, LoginCodePrompt, Alignment, MemStorageKeys, OverlayType, withStyle, withLocalization, AppBtidLayers, EventStreamConstants, Constants, AccountSwitcherConstants, LaunchContext, LinkButton, FlagSettings, FFlagSignalsNavP3eAuth, useSignalState, v85, RenderChallenge, LogoutAllLoggedInUsers, ResetAppState, GetFFlagLuaAppEnableDesktopDualLoginABTest, GetFIntLuaAppCredentialsProtocolAvailableTimeout, GetFFlagEnableOtpEmailLogin, GetFFlagShouldUsePeekViewForLoginDisambiguation, GetFFlagEnableCredentialsProtocolPasswords, FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues, default, AppLogging, useUiModeInfo, UiMode, Logger, AppStorageUtilities, OpenAccountSwitchingErrorOverlay, FFlagEnableLuaAccountSwitch, FFlagEnableKoreaKISACompliance, FFlagLuaEnableDidSwitchAccount, FFlagAuthSecExclusions, FFlagEnableAuthDeepLinkReceiver, PreAuthDeepLinkUrlStore, User, NotificationType, Promise, GetFFlagEnableVNGNewAppAvailableModal, v133, FFlagEnableVNGDUARSignupCompliance, GetFFlagEnableAccountSwitcherFoundationDesign, GetFFlagEnableAccountSwitcherRedesignIXP, GetFFlagEnableAccountSwitcherIXPTextGatingFix, FFlagEnableIosKeychainLoginLua, withNavigationProps, KeystoreAnalyticsEvents, KeystoreEventConstants, v147, v149, GetFFlagKeystoreAutoLoginAvailable, SystemThemeFeature, TelemetryConfigs, v163, v164

do
	local ContentProvider, AppStorageService, AuthCommon, GetPasswordManagerUsageStore, LoginResult, AuthCanVerifyCredentials, isStringEmail, isStringPhone, enrolledInLuafiedRecoveryExperiment, Base64, TransitionAnimation, LoginErrorCodes, LocalStorageKey, CredentialType, StatusCodes, reportEphemeralCounter, AppLoginCounterNames, SharedFlags, FFlagRemoveUnusedLoginResultRoduxSlice, Type, GetFFlagLuaAppWaitBeforeTwoStepRenderDev, GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev, GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin, TwoStepRequests, ActionType, GetFFlagEnableLoginAccountSelector, GetFIntLoginViewBottomPaddingPx, GetFFlagEnableLoginDisambiguationFoundationSwitcher, GetFFlagReportCrossAppLoginAttempt, v105, Constants2, CredentialsProtocolErrorCodes, DeleteAllCredentialsFromKeystore, v120, FFlagEnablePasskeyLoginErrorLogging, FFlagEnablePWManagerSignupCheck, FFlagEnableNavigateToLoginAfterLogoutAll, RbxAnalyticsService, GetFStringVNGDownloadNowUrl, GetUserByUsername, KeystoreConstants, AccountLinkingAlertType, TwoStepErrorCodes, getTwoStepLoginErrorKey, v148, GetFFlagBypassKeystoreLoginIxpV2, GetFFlagRemoveKeystoreIxpLogic, GetFFlagEnableLuafiedRecoveryFlow, FFlagDisableMemStorageServicePasswordEvent, FFlagEnableLoginV1ForcedUsernameOverride, GetFFlagEnable2SVRecovery

	do
		local Modules = game:GetService("CoreGui").RobloxGui.Modules
		local CorePackages = game:GetService("CorePackages")

		ContentProvider = game:GetService("ContentProvider")
		UserInputService = game:GetService("UserInputService")
		GuiService = game:GetService("GuiService")
		AppStorageService = game:GetService("AppStorageService")
		MemStorageService = game:GetService("MemStorageService")
		HttpService = game:GetService("HttpService")
		LocalizationService = game:GetService("LocalizationService")
		Cryo = require(CorePackages.Packages.Cryo)
		Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
		BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
		FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
		FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore

		do
			local Common = Modules.Common

			Roact = require(Common.Roact)
			RoactRodux = require(Common.RoactRodux)
		end

		RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
		RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
		RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
		RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
		RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
		RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
		ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
		AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
		GetPasswordManagerUsageStore = AuthCommon.Stores.GetPasswordManagerUsageStore
		LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
		AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
		AppPage = require(Modules.LuaApp.AppPage)
		Login = require(Modules.LuaApp.Thunks.Authentication.Login)
		LoginByCode = require(Modules.LuaApp.Thunks.Authentication.LoginByCode)
		LoginByPasskey = require(Modules.LuaApp.Thunks.Authentication.LoginByPasskey)
		LoginByOtp = require(Modules.LuaApp.Thunks.Authentication.LoginByOtp)
		LoginResult = require(Modules.LuaApp.Models.Authentication.LoginResult)
		LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
		StartPasskeyAuthentication = require(Modules.LuaApp.Thunks.Authentication.StartPasskeyAuthentication)
		NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
		OpenCentralOverlayForLoginPasswordResetPrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLoginPasswordResetPrompt)
		SetLoginResult = require(Modules.LuaApp.Actions.Authentication.SetLoginResult)
		SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
		SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
		CrossDeviceLogin = require(Modules.LuaApp.Thunks.Authentication.CrossDeviceLogin)
		DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
		OpenAccountSelector = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSelector)
		Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
		OpenEmailOtp = require(Modules.LuaApp.Thunks.Authentication.OpenEmailOtp)
		CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
		NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
		FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
		v50 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
		AuthCanVerifyCredentials = require(Modules.LuaApp.Http.Requests.AuthCanVerifyCredentials)
		GetIXPLayerParameters = require(Modules.LuaApp.Http.Requests.GetIXPLayerParameters)
		LogoWithContentsLayout = require(Modules.LuaApp.Components.Authentication.LogoWithContentsLayout)
		DualLoginWithContentsLayout = require(Modules.LuaApp.Components.Authentication.DualLoginWithContentsLayout)
		isStringEmail = AuthCommon.Utils.isStringEmail
		isStringPhone = AuthCommon.Utils.isStringPhone
		enrolledInLuafiedRecoveryExperiment = AuthCommon.Experiments.enrolledInLuafiedRecoveryExperiment
		Base64 = require(Modules.LuaApp.Util.Base64)
		CredentialLoginContainer = require(Modules.LuaApp.Components.Authentication.CredentialLoginContainer)
		LoginCodePrompt = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginCodePrompt)
		TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
		LoginErrorCodes = require(Modules.LuaApp.Enum.LoginErrorCodes)
		Alignment = require(Modules.LuaApp.Enum.Alignment)
		LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
		MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
		OverlayType = require(Modules.LuaApp.Enum.OverlayType)
		CredentialType = require(Modules.LuaApp.Enum.CredentialType)

		do
			local UIBlox = require(CorePackages.Packages.UIBlox)

			withStyle = UIBlox.Style.withStyle
			withLocalization = require(Modules.LuaApp.withLocalization)
			StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
			reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
			AppLoginCounterNames = require(Modules.LuaApp.Analytics.Events.AppLoginCounterNames)
			AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
			EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
			Constants = require(Modules.LuaApp.Constants)
			AccountSwitcherConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.AccountSwitcherConstants
			LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
			LinkButton = UIBlox.App.Button.LinkButton
		end

		FlagSettings = require(Modules.LuaApp.FlagSettings)
		SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
		FFlagSignalsNavP3eAuth = SharedFlags.FFlagSignalsNavP3eAuth
		FFlagRemoveUnusedLoginResultRoduxSlice = SharedFlags.FFlagRemoveUnusedLoginResultRoduxSlice
		useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
		v85 = if not FFlagSignalsNavP3eAuth then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
		Type = require(Modules.LuaApp.Enum.Challenge.Type)
		GetFFlagLuaAppWaitBeforeTwoStepRenderDev = require(Modules.LuaApp.Flags.GetFFlagLuaAppWaitBeforeTwoStepRenderDev)
		GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev = require(Modules.LuaApp.Flags.GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev)
		GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(Modules.LuaApp.Flags.GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin)
		RenderChallenge = require(Modules.LuaApp.Thunks.Challenge.RenderChallenge)
		TwoStepRequests = require(Modules.LuaApp.Http.Requests.TwoStepRequests)
		LogoutAllLoggedInUsers = require(Modules.LuaApp.Thunks.Authentication.AccountSwitcher.LogoutAllLoggedInUsers)
		ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
		ActionType = require(Modules.LuaApp.Enum.Challenge.TwoStepVerification.ActionType)
		GetFFlagLuaAppEnableDesktopDualLoginABTest = SharedFlags.GetFFlagLuaAppEnableDesktopDualLoginABTest
		GetFFlagEnableLoginAccountSelector = require(Modules.LuaApp.Flags.GetFFlagEnableLoginAccountSelector)
		GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
		GetFIntLoginViewBottomPaddingPx = require(Modules.LuaApp.Flags.GetFIntLoginViewBottomPaddingPx)
		GetFFlagEnableOtpEmailLogin = require(Modules.LuaApp.Flags.GetFFlagEnableOtpEmailLogin)
		GetFFlagShouldUsePeekViewForLoginDisambiguation = require(Modules.LuaApp.Flags.GetFFlagShouldUsePeekViewForLoginDisambiguation)
		GetFFlagEnableLoginDisambiguationFoundationSwitcher = SharedFlags.GetFFlagEnableLoginDisambiguationFoundationSwitcher
		GetFFlagEnableCredentialsProtocolPasswords = require(Modules.LuaApp.Flags.GetFFlagEnableCredentialsProtocolPasswords)
		GetFFlagReportCrossAppLoginAttempt = require(Modules.LuaApp.Flags.GetFFlagReportCrossAppLoginAttempt)
		FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
		v105 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOn2SVLoginV1", false)

		local CredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol)

		Constants2 = CredentialsProtocol.Constants
		default = CredentialsProtocol.CredentialsProtocol.default
		CredentialsProtocolErrorCodes = CredentialsProtocol.CredentialsProtocolErrorCodes
		AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
		useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
		UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
		Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
		AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
		DeleteAllCredentialsFromKeystore = require(Modules.LuaApp.Thunks.Authentication.DeleteAllCredentialsFromKeystore)
		OpenAccountSwitchingErrorOverlay = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSwitchingErrorOverlay)
		FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
		FFlagEnableKoreaKISACompliance = require(Modules.LuaApp.Flags.FFlagEnableKoreaKISACompliance)
		FFlagLuaEnableDidSwitchAccount = require(Modules.LuaApp.Flags.FFlagLuaEnableDidSwitchAccount)
		v120 = game:DefineFastFlag("AwaitLoginCompletionForDisambiguationFlow", false)
		game:DefineFastFlag("LuaLoginManualCredentialValidation", false)
		FFlagEnablePasskeyLoginErrorLogging = SharedFlags.FFlagEnablePasskeyLoginErrorLogging
		FFlagAuthSecExclusions = SharedFlags.FFlagAuthSecExclusions
		FFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
		FFlagEnableAuthDeepLinkReceiver = SharedFlags.FFlagEnableAuthDeepLinkReceiver
		FFlagEnableNavigateToLoginAfterLogoutAll = SharedFlags.FFlagEnableNavigateToLoginAfterLogoutAll
		PreAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
		User = require(script.Parent.Parent.Parent.Thunks.Authentication.User)
		NotificationType = require(Modules.LuaApp.Enum.NotificationType)
		RbxAnalyticsService = game:GetService("RbxAnalyticsService")
		Promise = require(CorePackages.Packages.Promise)
		GetFFlagEnableVNGNewAppAvailableModal = require(Modules.LuaApp.Flags.GetFFlagEnableVNGNewAppAvailableModal)
		GetFStringVNGDownloadNowUrl = require(Modules.LuaApp.Flags.GetFStringVNGDownloadNowUrl)
		v133 = game:DefineFastFlag("FixLoginSelection", false)
		FFlagEnableVNGDUARSignupCompliance = require(Modules.LuaApp.Flags.FFlagEnableVNGDUARSignupCompliance)
		GetFFlagEnableAccountSwitcherFoundationDesign = SharedFlags.GetFFlagEnableAccountSwitcherFoundationDesign
		GetFFlagEnableAccountSwitcherRedesignIXP = SharedFlags.GetFFlagEnableAccountSwitcherRedesignIXP
		GetFFlagEnableAccountSwitcherIXPTextGatingFix = SharedFlags.GetFFlagEnableAccountSwitcherIXPTextGatingFix
		FFlagEnableIosKeychainLoginLua = require(Modules.LuaApp.Flags.FFlagEnableIosKeychainLoginLua)
		GetUserByUsername = AuthCommon.Thunks.GetUserByUsername
		withNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).withNavigationProps
		KeystoreConstants = AuthCommon.Common.KeystoreConstants
		KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
		KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
		AccountLinkingAlertType = AuthCommon.Enums.AccountLinkingAlertType
		TwoStepErrorCodes = AuthCommon.Enums.TwoStepErrorCodes
		getTwoStepLoginErrorKey = AuthCommon.Utils.getTwoStepLoginErrorKey
		v147 = game:DefineFastFlag("LoginButtonAutoDisabled", false)
		v148 = game:DefineFastFlag("EnableTwoStepLoginChallengeAnalytics", false)
		v149 = game:DefineFastFlag("DebugOTPBypass", false)
		GetFFlagBypassKeystoreLoginIxpV2 = SharedFlags.GetFFlagBypassKeystoreLoginIxpV2
		GetFFlagRemoveKeystoreIxpLogic = SharedFlags.GetFFlagRemoveKeystoreIxpLogic
		GetFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow
		FFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
		FFlagEnableLoginV1ForcedUsernameOverride = SharedFlags.FFlagEnableLoginV1ForcedUsernameOverride
		GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
		GetFFlagEnable2SVRecovery = require(CorePackages.Workspace.Packages.AccountRecovery).Flags.GetFFlagEnable2SVRecovery
		SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
		TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
	end

	local KeystoreSaveCredentialsTelemetryConfig = TelemetryConfigs.KeystoreSaveCredentialsTelemetryConfig
	local TelemetryService = game:GetService("TelemetryService")
	local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
	local PasskeyConstants = AuthCommon.Common.PasskeyConstants

	v163 = Roact.PureComponent:extend("LoginView")
	v164 = GetFIntLoginViewBottomPaddingPx()

	local _ = {
		CValue = 1,
		Password = 2
	}

	function v163.init(p1) -- line: 227
		-- upvalues: Roact (copy), v133 (copy), AppStorageService (copy), LocalStorageKey (copy), FFlagEnableLuaAccountSwitch (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), GetPasswordManagerUsageStore (copy), FFlagEnablePWManagerSignupCheck (copy), LoginErrorCodes (copy), User (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), UserInputService (copy), AuthCanVerifyCredentials (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), HttpService (copy), Base64 (copy), default (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), EventStreamConstants (copy), PasskeyConstants (copy), FFlagEnablePasskeyLoginErrorLogging (copy), GetFFlagEnableOtpEmailLogin (copy), Type (copy), GetFFlagLuaAppWaitBeforeTwoStepRenderDev (copy), GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev (copy), v148 (copy), ActionType (copy), GetFFlagEnable2SVRecovery (copy), TwoStepRequests (copy), FFlagDisableMemStorageServicePasswordEvent (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), v105 (copy), TwoStepErrorCodes (copy), getTwoStepLoginErrorKey (copy), AccountLinkingAlertType (copy), isStringEmail (copy), isStringPhone (copy), v120 (copy), GetFFlagEnableLoginDisambiguationFoundationSwitcher (copy), GetFFlagShouldUsePeekViewForLoginDisambiguation (copy), Promise (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), ContentProvider (copy), GetUserByUsername (copy), DeleteAllCredentialsFromKeystore (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), GetFFlagEnableLoginAccountSelector (copy), Constants2 (copy), LogoutAllLoggedInUsers (copy), AccountSwitcherConstants (copy), GuiService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), StatusCodes (copy), Constants (copy), CredentialType (copy), GetFFlagEnableVNGNewAppAvailableModal (copy), GetFStringVNGDownloadNowUrl (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), AppPage (copy), TransitionAnimation (copy), GetFFlagReportCrossAppLoginAttempt (copy), RbxAnalyticsService (copy)
		local u173 = false

		p1.cvalueRef = Roact.createRef()
		p1.passwordRef = Roact.createRef()
		p1.loginButtonRef = Roact.createRef()
		p1.forgotLinkRef = Roact.createRef()
		p1.crossDeviceButtonRef = Roact.createRef()
		p1.emailOtpRef = Roact.createRef()

		if v133 then
			p1.focusRef = Roact.createRef()
		end

		local Item = AppStorageService:GetItem(LocalStorageKey.CredentialValue)

		if FFlagEnableLuaAccountSwitch then
			local Item2 = AppStorageService:GetItem(LocalStorageKey.AccountBlob)

			if Item2 and Item2 ~= "" then
				Item = ""
			end
		end

		if FFlagEnableLoginV1ForcedUsernameOverride and p1.props.forcedUsernameOverride then
			Item = p1.props.forcedUsernameOverride
		end

		local v176, v177 = Roact.createBinding(Item)

		p1.cvalueText = v176
		p1.updateCValueText = v177

		local v178, v179 = Roact.createBinding("")

		p1.passwordText = v178
		p1.updatePasswordText = v179
		p1.state = {
			errorKey = "",
			localizedErrorMessage = nil,
			errorCode = -1,
			loginButtonDisabled = true,
			isLoginInProgress = false,
			forceLoginByUsername = false,
			forgotLinkFocused = false,
			quickLoginButtonTextOverride = "",
			isDesktopDualLoginEnabled = false,
			isLoginByOtp = false,
			otpSessionToken = "",
			otpCode = "",
			isCredentialsProtocolRegisterPasswordAvailable = false
		}
		p1.passwordManagerUsageStore = GetPasswordManagerUsageStore(false)

		if FFlagEnablePWManagerSignupCheck and p1.passwordManagerUsageStore then
			p1.passwordManagerUsageStore.resetAll()
		elseif p1.passwordManagerUsageStore then
			p1.passwordManagerUsageStore.setLoggedinUsingSavedPassword(false)
			p1.passwordManagerUsageStore.setSavedPasswordAfterLogin(false)
		end

		p1.errorHandlingInfoList = {
			[LoginErrorCodes.IncorrectCValueOrPassword] = {
				newFocusedTextBox = 2,
				textBoxesToClear = { 2 }
			},
			[LoginErrorCodes.CValueAndPasswordRequired] = {
				newFocusedTextBox = 2,
				textBoxesToClear = { 2 }
			},
			[LoginErrorCodes.AccountLocked] = {
				textBoxesToClear = { 2 }
			},
			[LoginErrorCodes.MoreThanOneUsername] = {
				newFocusedTextBox = 1,
				forceLoginByUsername = true,
				textBoxesToClear = {
					1,
					2
				}
			},
			[LoginErrorCodes.AccountNotVerified] = {
				forceLoginByUsername = true,
				textBoxesToClear = {
					1,
					2
				}
			},
			[LoginErrorCodes.MultipleUsersPerCredential] = if not p1.props.appPolicy.getAccountDisambiguationDisabled() then nil else {
				newFocusedTextBox = 1,
				forceLoginByUsername = true,
				textBoxesToClear = {
					1,
					2
				}
			}
		}
		p1.isAlreadyAuthenticated = User.fromLocalStorage().userId ~= -1

		function resetDefaultTheme() -- line: 315
			-- upvalues: AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy)
			local v231 = AppStorageUtilities.getAuthenticatedTheme()

			if v231 ~= "" then
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v231)
			end

			SystemThemeFeature.ClearThemeOverride()
		end
		function p1.updateIsLoginInProgress(p2) -- line: 323
			-- upvalues: p1 (copy)
			spawn(function() -- line: 324
				-- upvalues: p1 (copy), p2 (copy)
				local isLoginInProgress = p1.state.isLoginInProgress

				if p1.isMounted and isLoginInProgress ~= p2 then
					p1:setState({
						isLoginInProgress = p2
					})
				end
			end)
		end
		function p1.onTextBoxesChanged(p3) -- line: 334
			-- upvalues: p1 (copy)
			if not p1.cvalueRef.current or (not p1.passwordRef.current or not p1.isMounted) then
				return
			end

			local v234 = p3.Text:gsub("\t", "")

			if v234 ~= p3.Text then
				p3.Text = v234
			end

			p1:setState({
				errorCode = -1,
				loginButtonDisabled = #p1.cvalueRef.current.Text == 0 or #p1.passwordRef.current.Text == 0,
				errorKey = #p3.Text == 0 and p1.state.errorKey or ""
			})
		end
		function p1.unfocusTextBoxes() -- line: 352
			-- upvalues: UserInputService (copy), p1 (copy)
			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox and (FocusedTextBox == p1.cvalueRef.current or FocusedTextBox == p1.passwordRef.current) then
				FocusedTextBox:ReleaseFocus()
			end
		end
		function p1.handleCaptchaResult(p4, p5) -- line: 361
			-- upvalues: p1 (copy)
			if p4 then
				p1.handleLoginWithFormData(p5)

				return
			end

			p1.updateIsLoginInProgress(false)
		end
		function p1.getCaptchaResultHandlerWithCode(p6, p7) -- line: 369
			-- upvalues: p1 (copy)
			return function(p8, p9) -- line: 370
				-- upvalues: p1 (copy), p6 (copy), p7 (copy)
				if p8 then
					p1.handleLoginWithCode(p6, p7, p9)

					return
				end

				p1.updateIsLoginInProgress(false)
			end
		end
		function p1.getSecurityQuestionsLoginWithCodeCallback(p10, p11) -- line: 379
			-- upvalues: p1 (copy)
			return function(p12) -- line: 380
				-- upvalues: p1 (copy), p10 (copy), p11 (copy)
				p1.handleLoginWithCode(p10, p11, nil, p12)
			end
		end
		function p1.getSecurityQuestionsLoginWithOtpCallback() -- line: 385
			-- upvalues: p1 (copy)
			return function(p13) -- line: 386
				-- upvalues: p1 (copy)
				p1.handleLoginWithOtp(p13, nil)
			end
		end
		function p1.getSecurityQuestionsLoginWithFormDataCallback() -- line: 391
			-- upvalues: p1 (copy)
			return function(p14) -- line: 392
				-- upvalues: p1 (copy)
				p1.handleLoginWithFormData(nil, p14)
			end
		end
		function p1.canVerifyCredentials(p15, p16, p17) -- line: 397
			-- upvalues: AuthCanVerifyCredentials (copy), p1 (copy)
			return AuthCanVerifyCredentials(p1.props.networking, p15, p16, p17):andThen(function(p18) -- line: 399
				return p18 and (p18.responseBody and p18.responseBody.canSend)
			end, function() -- line: 402
				return false
			end)
		end
		function p1.handleLoginWithCode(p19, p20, p21, p22) -- line: 408
			-- upvalues: p1 (copy), LoginErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy)
			p1.updateIsLoginInProgress(true)

			local setBackNavigationDisabled = p1.props.setBackNavigationDisabled

			p1.unfocusTextBoxes()
			setBackNavigationDisabled(true)

			local loginByCode = p1.props.loginByCode
			local v251 = p1.getCaptchaResultHandlerWithCode(p19, p20)
			local v252 = p1.getSecurityQuestionsLoginWithCodeCallback(p19, p20)

			return loginByCode(p1.props.networking, p19, p20, v251, p21, v252, p22):andThen(function(p23) -- line: 429
				-- upvalues: p1 (copy)
				p1.handleLoginResult(p23, nil)
			end, function(p24) -- line: 431
				-- upvalues: LoginErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), p1 (copy), p19 (copy), p20 (copy)
				if p24.errorCode ~= LoginErrorCodes.Captcha then
					reportEphemeralCounter(AppLoginCounterNames.FailureAuthCode, 1)
				end

				p1.handleLoginError(p24, p19, p20)
			end)
		end
		function p1.handleLoginWithPasskey(p25, p26) -- line: 439
			-- upvalues: FFlagEnableNavigateToLoginAfterLogoutAll (copy), u173 (ref), p1 (copy)
			if FFlagEnableNavigateToLoginAfterLogoutAll then
				u173 = false
			end

			p1.updateIsLoginInProgress(true)

			local setBackNavigationDisabled = p1.props.setBackNavigationDisabled

			p1.unfocusTextBoxes()
			setBackNavigationDisabled(true)

			return p1.props.loginByPasskey(p1.props.networking, p25, p26):andThen(function(p27) -- line: 450
				-- upvalues: p1 (copy)
				p1.handleLoginResult(p27, nil)
			end, function(p28) -- line: 452
				-- upvalues: p1 (copy), p25 (copy)
				p1.handleLoginError(p28, p25)
			end)
		end
		function p1.showPasskeyLoginPopup() -- line: 457
			-- upvalues: p1 (copy), HttpService (copy), UserInputService (copy), Base64 (copy), default (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), EventStreamConstants (copy), PasskeyConstants (copy)
			local networking = p1.props.networking

			return p1.props.startPasskeyAuthentication(networking):andThen(function(p29) -- line: 460
				-- upvalues: HttpService (copy), UserInputService (copy), Base64 (copy), default (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), p1 (copy), EventStreamConstants (copy), PasskeyConstants (copy)
				local data = HttpService:JSONDecode(p29.authenticationOptions)
				local sessionId = p29.sessionId
				local num = tonumber(data.publicKey.timeout)

				data.keyType = "platform"
				data.deviceBoundOnly = true

				if UserInputService:GetPlatform() ~= Enum.Platform.Android then
					data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)
				end

				local json = HttpService:JSONEncode(data)

				default:getCredentials(default.CredentialsTypes.FIDO2, json, num):andThen(function(p30) -- line: 477
					-- upvalues: HttpService (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), p1 (copy), EventStreamConstants (copy), PasskeyConstants (copy), Base64 (copy), sessionId (copy)
					local data2 = HttpService:JSONDecode(p30)

					if data2 == nil or next(data2) == nil then
						Logger:info("Passkey credential signing failed. No result returned.")

						return
					end

					if data2.errorCode ~= nil then
						Logger:info("Passkey credential signing failed. Error {} (msg: {}) returned.", data2.errorCode, data2.errorMsg)

						local num2 = tonumber(data2.errorCode)
						local v474 = CredentialsProtocolErrorCodes.GetCredentialsErrorCodes[num2 or -1] or string.format(CredentialsProtocolErrorCodes.UNMAPPED_ERROR_CODE, (tostring(data2.errorCode)))

						p1.props.authAnalytics.reportAuthClientError(EventStreamConstants.Context.PasskeyLoginAttempt, v474, PasskeyConstants.PASSKEY_FETCH_LOGIN_V1)

						return
					end

					Logger:info("Passkey credential signing completed. Attempting login.")
					data2.id = Base64.ToUrlSafeBase64(data2.id)
					data2.rawId = Base64.ToUrlSafeBase64(data2.rawId)
					data2.response.signature = Base64.ToUrlSafeBase64(data2.response.signature)
					data2.response.userHandle = Base64.ToUrlSafeBase64(data2.response.userHandle)
					data2.response.authenticatorData = Base64.ToUrlSafeBase64(data2.response.authenticatorData)
					data2.response.clientDataJSON = Base64.ToUrlSafeBase64(data2.response.clientDataJSON)
					p1.handleLoginWithPasskey(data2, sessionId)
				end, function(p31) -- line: 515
					-- upvalues: Logger (copy)
					Logger:warning("Passkey credential signing failed. Error: {}", p31)
				end)
			end, function(p32) -- line: 519
				-- upvalues: Logger (copy)
				Logger:warning("Fetching passkey login options failed with error code: {}", p32.errorCode)
			end)
		end
		function p1.showGenericCredentialLoginPopup(p33, p34) -- line: 524
			-- upvalues: p1 (copy), HttpService (copy), UserInputService (copy), Base64 (copy), Logger (copy), default (copy), FFlagEnablePasskeyLoginErrorLogging (copy), EventStreamConstants (copy), PasskeyConstants (copy)
			if not p33 and not p34 then
				return
			end

			local networking = p1.props.networking
			local startPasskeyAuthentication = p1.props.startPasskeyAuthentication
			local data = nil
			local sessionId = nil
			local num = nil
			local t1 = {}

			if p33 then
				startPasskeyAuthentication(networking):andThen(function(p35) -- line: 536
					-- upvalues: data (ref), HttpService (copy), sessionId (ref), num (ref), UserInputService (copy), Base64 (copy)
					data = HttpService:JSONDecode(p35.authenticationOptions)
					sessionId = p35.sessionId
					num = tonumber(data.publicKey.timeout)
					data.keyType = "platform"
					data.deviceBoundOnly = true

					if UserInputService:GetPlatform() ~= Enum.Platform.Android then
						data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)
					end
				end, function(p36) -- line: 550
					-- upvalues: Logger (copy)
					Logger:warning("Fetching passkey login options failed with error code: {}", p36.errorCode)
				end):await()

				if data ~= nil then
					t1.FIDO2 = data
				end
			end

			if p34 then
				t1.password = {}
			end

			local json = HttpService:JSONEncode(t1)

			return default:getCredentials(default.CredentialsTypes.all, json, num / 1000):andThen(function(p37) -- line: 567
				-- upvalues: HttpService (copy), Logger (copy), FFlagEnablePasskeyLoginErrorLogging (copy), p1 (copy), EventStreamConstants (copy), PasskeyConstants (copy), default (copy), Base64 (copy), sessionId (ref)
				local data3 = HttpService:JSONDecode(p37)

				if data3 == nil or not data3.response and not data3.errorCode then
					Logger:info("Generic credential fetch failed. No result returned.")

					return
				end

				if data3.errorCode ~= nil then
					Logger:info("Generic credential fetch failed. Error {} (msg: {}) returned.", data3.errorCode, data3.errorMsg)

					if FFlagEnablePasskeyLoginErrorLogging and type(data3.errorMsg) == "string" then
						p1.props.authAnalytics.reportAuthClientError(EventStreamConstants.Context.PasskeyLoginAttempt, data3.errorMsg, PasskeyConstants.GENERIC_CREDENTIAL_FETCH_LOGIN_V1)

						return
					end
				else
					if data3.credentialType == default.CredentialsTypes.password then
						local username = data3.response.username
						local password = data3.response.password

						p1.updateCValueText(username)
						p1.updatePasswordText(password)
						p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.CMPasswordLogin, EventStreamConstants.Button.SelectPassword)
						p1.updateIsLoginInProgress(true)
						p1.handleLoginWithFormData(nil, nil, nil, true)

						return
					end

					if data3.credentialType == default.CredentialsTypes.FIDO2 then
						data3.response.id = Base64.ToUrlSafeBase64(data3.response.id)
						data3.response.rawId = Base64.ToUrlSafeBase64(data3.response.rawId)
						data3.response.response.signature = Base64.ToUrlSafeBase64(data3.response.response.signature)
						data3.response.response.userHandle = Base64.ToUrlSafeBase64(data3.response.response.userHandle)
						data3.response.response.authenticatorData = Base64.ToUrlSafeBase64(data3.response.response.authenticatorData)
						data3.response.response.clientDataJSON = Base64.ToUrlSafeBase64(data3.response.response.clientDataJSON)
						p1.handleLoginWithPasskey(data3.response, sessionId)
					end
				end
			end, function(p38) -- line: 615
				-- upvalues: Logger (copy)
				Logger:warning("Generic credential signing failed. Error: {}", p38)
			end)
		end
		function p1.handleLoginWithOtp(p39, p40) -- line: 620
			-- upvalues: GetFFlagEnableOtpEmailLogin (copy), p1 (copy)
			if not GetFFlagEnableOtpEmailLogin() and p1.props.isLoginWithOtpEnabled then
				return
			end

			p1.updateIsLoginInProgress(true)

			local setBackNavigationDisabled = p1.props.setBackNavigationDisabled

			p1.unfocusTextBoxes()
			setBackNavigationDisabled(true)

			local loginByOtp = p1.props.loginByOtp
			local v270 = p1.getSecurityQuestionsLoginWithOtpCallback()

			return loginByOtp(p1.props.networking, p1.state.otpSessionToken, p1.state.otpCode, v270, p39, p40):andThen(function(p41) -- line: 643
				-- upvalues: p1 (copy)
				p1.handleLoginResult(p41, nil)
			end, function(p42) -- line: 645
				-- upvalues: p1 (copy)
				p1.handleLoginError(p42, p1.state.otpSessionToken, p1.state.otpCode)

				return p42.errorKey
			end)
		end
		function p1.validateFormCredentials(p43) -- line: 651
			return #p43:gsub("%s+", "") > 0
		end
		function p1.handleLoginWithFormData(p44, p45, p46, p47) -- line: 655
			-- upvalues: p1 (copy), LoginErrorCodes (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), u173 (ref), AppStorageService (copy), LocalStorageKey (copy), EventStreamConstants (copy), HttpService (copy)
			if not p1.cvalueRef.current or not p1.passwordRef.current then
				return
			end

			local currentText = p1.cvalueRef.current.Text
			local currentText2 = p1.passwordRef.current.Text

			if game:GetFastFlag("LuaLoginManualCredentialValidation") and not p1.validateFormCredentials(currentText) then
				p1.handleLoginError({
					errorKey = "Authentication.Login.Response.IncorrectUsernamePassword",
					errorCode = LoginErrorCodes.IncorrectCValueOrPassword
				}, currentText, currentText2)
				p1.updateCValueText("")

				return
			end

			local setBackNavigationDisabled = p1.props.setBackNavigationDisabled

			p1.unfocusTextBoxes()
			setBackNavigationDisabled(true)

			local login = p1.props.login
			local handleCaptchaResult = p1.handleCaptchaResult
			local networking = p1.props.networking
			local v282 = p1.getSecurityQuestionsLoginWithFormDataCallback()
			local forceLoginByUsername = p1.state.forceLoginByUsername

			if FFlagEnableNavigateToLoginAfterLogoutAll then
				u173 = true
			end

			return login(networking, currentText, currentText2, handleCaptchaResult, p44, v282, p45, p46, forceLoginByUsername):andThen(function(p48) -- line: 698
				-- upvalues: AppStorageService (copy), LocalStorageKey (copy), currentText (copy), p47 (copy), p1 (copy), EventStreamConstants (copy), HttpService (copy), currentText2 (copy)
				AppStorageService:SetItem(LocalStorageKey.CredentialValue, currentText)
				AppStorageService:flush()

				if p47 then
					p1.props.authAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.CMPasswordLogin, nil, "success")

					if p1.passwordManagerUsageStore then
						p1.passwordManagerUsageStore.setLoggedinUsingSavedPassword(true)
					end
				end

				local v448 = if p47 then nil else HttpService:JSONEncode({
					authType = "login",
					cvalue = currentText,
					password = currentText2
				})

				p1.handleLoginResult(p48, v448)
			end, function(p49) -- line: 723
				-- upvalues: p47 (copy), p1 (copy), EventStreamConstants (copy), currentText (copy), currentText2 (copy)
				if p47 then
					p1.props.authAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.CMPasswordLogin, nil, "error")
				end

				p1.handleLoginError(p49, currentText, currentText2)
			end)
		end
		function p1.renderSecurityQuestions(_, _, p52, p53) -- line: 736
			-- upvalues: p1 (copy), Type (copy)
			p1.props.renderChallenge({
				forceWebViewVisible = true,
				challengeType = Type.SecurityQuestions,
				challengeParameters = {
					sessionId = p53.sessionId,
					userId = p53.userId,
					onChallengeCompleted = function(p54) -- line: 742
						-- upvalues: p53 (copy), p52 (copy)
						local t2 = {
							sessionId = p53.sessionId,
							redemptionToken = p54.redemptionToken
						}

						p52(t2)
					end,
					onChallengeInvalidated = function(p55) -- line: 749
						-- upvalues: p1 (copy)
						p1.updateIsLoginInProgress(false)

						if p1.isMounted then
							if p55.errorCode ~= 0 then
								p1:setState({
									errorKey = false,
									localizedErrorMessage = p55.errorMessage
								})

								return
							end

							p1:setState({
								errorKey = "Authentication.Login.Response.SomethingWentWrong"
							})
						end
					end
				},
				onChallengeAbandoned = function() -- line: 767
					-- upvalues: p1 (copy)
					p1.updateIsLoginInProgress(false)
				end,
				onChallengeLoadFailed = function() -- line: 770
					-- upvalues: p1 (copy)
					p1.updateIsLoginInProgress(false)

					if p1.isMounted then
						p1:setState({
							errorKey = "Authentication.Login.Response.SomethingWentWrong"
						})
					end
				end
			})
		end
		function p1.renderTwoStepChallenge(p56, p57) -- line: 783
			-- upvalues: p1 (copy), GetFFlagLuaAppWaitBeforeTwoStepRenderDev (copy), GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev (copy), v148 (copy), EventStreamConstants (copy), Type (copy), ActionType (copy), GetFFlagEnable2SVRecovery (copy), TwoStepRequests (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagEnableLuaAccountSwitch (copy), v105 (copy), HttpService (copy), TwoStepErrorCodes (copy), getTwoStepLoginErrorKey (copy), AccountLinkingAlertType (copy)
			local launchApp = p1.props.launchApp
			local networking = p1.props.networking
			local appPolicy = p1.props.appPolicy
			local analytics = p1.props.analytics
			local omniRecommendationsRequest = p1.props.omniRecommendationsRequest
			local ticket = p56.twoStepVerificationData.ticket
			local id = p56.user.id
			local handleLoginCompletionWithAccountSwitching = p1.props.handleLoginCompletionWithAccountSwitching
			local clearApp = p1.props.clearApp

			if GetFFlagLuaAppWaitBeforeTwoStepRenderDev() then
				wait(GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev())
			end

			if v148 then
				p1.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.TwoStepLoginChallengeRenderInitiated, ticket)
			end

			p1.props.renderChallenge({
				forceWebViewVisible = true,
				challengeType = Type.TwoStepVerification,
				challengeParameters = {
					allowRememberDevice = true,
					actionType = ActionType.Login,
					challengeId = ticket,
					userId = id,
					clientSupports2svRecovery = not not GetFFlagEnable2SVRecovery(),
					onChallengeCompleted = function(p58) -- line: 813
						-- upvalues: v148 (copy), p1 (copy), EventStreamConstants (copy), ticket (copy), TwoStepRequests (copy), networking (copy), id (copy), p57 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagEnableLuaAccountSwitch (copy), handleLoginCompletionWithAccountSwitching (copy), omniRecommendationsRequest (copy), analytics (copy), appPolicy (copy), clearApp (copy), launchApp (copy), v105 (copy), HttpService (copy), TwoStepErrorCodes (copy), getTwoStepLoginErrorKey (copy), AccountLinkingAlertType (copy)
						if v148 then
							p1.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.TwoStepLoginChallengeCompleted, ticket)
						end

						TwoStepRequests.login(networking, id, ticket, p58.verificationToken, p58.rememberDevice):andThen(function(p59) -- line: 821
							-- upvalues: p57 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), p1 (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagEnableLuaAccountSwitch (copy), handleLoginCompletionWithAccountSwitching (copy), networking (copy), omniRecommendationsRequest (copy), analytics (copy), appPolicy (copy), clearApp (copy), launchApp (copy)
							if p57 then
								if not FFlagDisableMemStorageServicePasswordEvent then
									MemStorageService:Fire(MemStorageKeys.AuthenticatedCredentials, p57)
								end

								if GetFFlagEnableCredentialsProtocolPasswords() and p1.state.isCredentialsProtocolRegisterPasswordAvailable then
									p1.credentialsProtocolRegisterPassword(p57):await()
								end
							end

							reportEphemeralCounter(AppLoginCounterNames.Success, 1)

							if FFlagEnableLuaAccountSwitch then
								handleLoginCompletionWithAccountSwitching(networking, omniRecommendationsRequest, analytics, appPolicy, p59.responseBody.accountBlob, clearApp, launchApp)

								return
							end

							launchApp(networking, omniRecommendationsRequest, analytics, appPolicy)
						end, function(p60) -- line: 852
							-- upvalues: reportEphemeralCounter (copy), AppLoginCounterNames (copy), v105 (copy), HttpService (copy), TwoStepErrorCodes (copy), getTwoStepLoginErrorKey (copy), p1 (copy), AccountLinkingAlertType (copy)
							reportEphemeralCounter(AppLoginCounterNames.Failure, 1)

							local s1 = "Authentication.Login.Response.SomethingWentWrong"

							if v105 then
								local _, result = pcall(function() -- line: 859
									-- upvalues: HttpService (copy), p60 (copy)
									return HttpService:JSONDecode(p60.Body).errors[1].code
								end)

								if result == TwoStepErrorCodes.IllegalChildAccountLinking then
									reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
								else
									reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
								end

								s1 = getTwoStepLoginErrorKey(result)
							else
								reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
							end

							p1.updateIsLoginInProgress(false)

							if p1.isMounted then
								p1:setState({
									errorKey = s1
								})
							end

							if p60 and p60.Body then
								local data = HttpService:JSONDecode(p60.Body)
								local v482 = data and (data.errors and (data.errors[1] and data.errors[1].code))
								local v483 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

								if v482 == TwoStepErrorCodes.AccountLinkingRequired then
									p1.props.showAccountLinkingAlert(AccountLinkingAlertType.IncompatibleAccounts, v483)
								end

								if v482 == TwoStepErrorCodes.AccountLinkingFailed then
									p1.props.showAccountLinkingAlert(AccountLinkingAlertType.RetryLogInConnectionFailure)
								end
							end
						end)
					end,
					onChallengeInvalidated = function(p61) -- line: 902
						-- upvalues: v148 (copy), p1 (copy), EventStreamConstants (copy), ticket (copy)
						if v148 then
							p1.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.TwoStepLoginChallengeInvalidated, ticket)
						end

						p1.updateIsLoginInProgress(false)

						if p1.isMounted then
							if p61.errorCode ~= 0 then
								p1:setState({
									errorKey = false,
									localizedErrorMessage = p61.errorMessage
								})

								return
							end

							p1:setState({
								errorKey = "Authentication.Login.Response.SomethingWentWrong"
							})
						end
					end
				},
				onChallengeAbandoned = function() -- line: 926
					-- upvalues: v148 (copy), p1 (copy), EventStreamConstants (copy), ticket (copy)
					if v148 then
						p1.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.TwoStepLoginChallengeAbandoned, ticket)
					end

					p1.updateIsLoginInProgress(false)
				end,
				onChallengeLoadFailed = function() -- line: 935
					-- upvalues: v148 (copy), p1 (copy), EventStreamConstants (copy), ticket (copy)
					if v148 then
						p1.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.TwoStepLoginChallengeLoadFailed, ticket)
					end

					p1.updateIsLoginInProgress(false)

					if p1.isMounted then
						p1:setState({
							errorKey = "Authentication.Login.Response.SomethingWentWrong"
						})
					end
				end
			})
		end
		function p1.handleMultipleUsersPerCredentialError(p62) -- line: 955
			-- upvalues: p1 (copy), EventStreamConstants (copy), isStringEmail (copy), isStringPhone (copy), v120 (copy), GetFFlagEnableLoginDisambiguationFoundationSwitcher (copy), GetFFlagShouldUsePeekViewForLoginDisambiguation (copy)
			local s2 = ""

			if p1.state.isLoginByOtp then
				s2 = EventStreamConstants.Context.DisambiguationOTP
			elseif isStringEmail(p1.props.cvalue) then
				s2 = EventStreamConstants.Context.DisambiguationEmail
			elseif isStringPhone(p1.props.cvalue) then
				s2 = EventStreamConstants.Context.DisambiguationPhone
			end

			local t3 = {
				titleTextKey = "Authentication.Login.Label.AccountSelectorTitle",
				helpTextKey = "Authentication.Login.Description.AccountSelectorHelp",
				origin = EventStreamConstants.Context.Login,
				context = s2,
				users = p62,
				onAccountSelection = function(p63) -- line: 969
					-- upvalues: p1 (copy), v120 (copy)
					if p1.state.isLoginByOtp then
						if v120 then
							p1.handleLoginWithOtp(nil, p63):await()

							return
						end

						p1.handleLoginWithOtp(nil, p63)

						return
					end

					if v120 then
						p1.handleLoginWithFormData(nil, nil, p63):await()

						return
					end

					p1.handleLoginWithFormData(nil, nil, p63)
				end,
				onAccountSelectionAbandoned = function() -- line: 984
					-- upvalues: p1 (copy)
					p1.updateIsLoginInProgress(false)
					p1.state.otpSessionToken = ""
					p1.state.otpCode = ""
					p1.state.isLoginByOtp = false
					p1.props.closeCentralOverlay()
				end,
				screenSize = p1.props.screenSize
			}
			local v302 = p1.props.showFoundationDisambiguationSelector and GetFFlagEnableLoginDisambiguationFoundationSwitcher()

			if v302 then
				t3.hideActions = true
				t3.showFoundationDisambiguationSelector = true
			end

			if GetFFlagShouldUsePeekViewForLoginDisambiguation() then
				p1.props.closeCentralOverlay()
			end

			p1.props.openAccountSelector(t3, v302)
		end
		function p1.performKeystoreOperations(p64, p65) -- line: 1009
			-- upvalues: Promise (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), p1 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
			return Promise.new(function(resolve, reject) -- line: 1013
				-- upvalues: FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), p65 (ref), GetFFlagRemoveKeystoreIxpLogic (copy), p1 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), p64 (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), Promise (copy)
				if (FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable()) == false or p65 == nil then
					resolve()

					return
				end

				local v458 = not not GetFFlagRemoveKeystoreIxpLogic() or (p1.props.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				p65 = HttpService:JSONDecode(p65)
				GetUserByUsername(p64, p65.cvalue)():andThen(function(p66) -- line: 1035
					-- upvalues: reject (copy), GetFFlagKeystoreAutoLoginAvailable (copy), DeleteAllCredentialsFromKeystore (copy), json (copy), default (copy), KeystoreConstants (copy)
					if not p66 or not p66.id then
						return reject("Invalid usernameInfo")
					end

					if GetFFlagKeystoreAutoLoginAvailable() then
						return DeleteAllCredentialsFromKeystore(json):andThen(function() -- line: 1041
							-- upvalues: p66 (copy)
							return p66
						end)
					end

					return default:deleteAllCredentialsFromiOSKeychain(default.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout):andThen(function() -- line: 1049
						-- upvalues: p66 (copy)
						return p66
					end)
				end):andThen(function(p67) -- line: 1054
					-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), p65 (ref), v458 (copy), KeystoreConstants (copy), GetFFlagKeystoreAutoLoginAvailable (copy), default (copy), Promise (copy)
					local json2

					if GetFFlagRemoveKeystoreIxpLogic() then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p67.id)))

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
								customFields = {
									result = "attempt"
								}
							}, 1)
						end

						json2 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(p65.cvalue),
							userId = tostring(p67.id),
							password = tostring(p65.password)
						})
					else
						local Experiment

						if v458 == true then
							Experiment = KeystoreConstants.Experiment
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p67.id)))
						else
							Experiment = KeystoreConstants.Control
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p67.id)))
						end

						json2 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(p65.cvalue),
							userId = tostring(p67.id),
							password = tostring(p65.password),
							experimentGroup = tostring(Experiment)
						})
					end

					if GetFFlagKeystoreAutoLoginAvailable() then
						return (default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p68) -- line: 1105
							-- upvalues: default (copy), json2 (ref), KeystoreConstants (copy), Promise (copy)
							if p68 and (p68.keystore and p68.keystore.isAvailable) then
								return default:registerCredentials(default.CredentialsTypes.keystore, json2, KeystoreConstants.KeystoreTimeout)
							end

							return Promise.resolve(nil)
						end))
					end

					return default:registerCredentials(default.CredentialsTypes.iosKeychainPassword, json2, KeystoreConstants.KeystoreTimeout)
				end):andThen(function(_) -- line: 1129
					-- upvalues: resolve (copy)
					resolve()
				end):catch(function(p70) -- line: 1132
					-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
							customFields = {
								result = "error"
							}
						}, 1)
					end

					reject(p70)
				end)
			end)
		end
		function p1.handleLoginResult(p71, p72) -- line: 1145
			-- upvalues: p1 (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), FFlagEnableLuaAccountSwitch (copy), SystemThemeFeature (copy), GetFFlagEnableLoginAccountSelector (copy)
			p1.props.setBackNavigationDisabled(false)

			local setLoginResult = p1.props.setLoginResult
			local launchApp = p1.props.launchApp
			local networking = p1.props.networking
			local appPolicy = p1.props.appPolicy
			local analytics = p1.props.analytics
			local omniRecommendationsRequest = p1.props.omniRecommendationsRequest

			if p1.passwordRef.current then
				p1.passwordRef.current.Text = ""
			end

			local clearApp = p1.props.clearApp
			local handleLoginCompletionWithAccountSwitching = p1.props.handleLoginCompletionWithAccountSwitching

			p1.performKeystoreOperations(networking, p72):finally(function() -- line: 1163
				-- upvalues: LoginResult (copy), p71 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), setLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), p1 (copy), p72 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), MemStorageKeys (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), FFlagEnableLuaAccountSwitch (copy), handleLoginCompletionWithAccountSwitching (copy), networking (copy), omniRecommendationsRequest (copy), analytics (copy), appPolicy (copy), clearApp (copy), launchApp (copy), SystemThemeFeature (copy), GetFFlagEnableLoginAccountSelector (copy)
				if LoginResult.hasTwoStepData(p71) then
					if not FFlagRemoveUnusedLoginResultRoduxSlice then
						setLoginResult(p71)
					end

					reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
					spawn(function() -- line: 1172
						-- upvalues: p1 (copy), p71 (copy), p72 (copy)
						p1.renderTwoStepChallenge(p71, p72)
					end)
				else
					if p72 then
						if not FFlagDisableMemStorageServicePasswordEvent then
							MemStorageService:Fire(MemStorageKeys.AuthenticatedCredentials, p72)
						end

						if GetFFlagEnableCredentialsProtocolPasswords() and p1.state.isCredentialsProtocolRegisterPasswordAvailable then
							p1.credentialsProtocolRegisterPassword(p72):await()
						end
					end

					reportEphemeralCounter(AppLoginCounterNames.Success, 1)

					if FFlagEnableLuaAccountSwitch then
						handleLoginCompletionWithAccountSwitching(networking, omniRecommendationsRequest, analytics, appPolicy, p71.accountBlob, clearApp, launchApp)
					else
						launchApp(networking, omniRecommendationsRequest, analytics, appPolicy)
						SystemThemeFeature.ClearThemeOverride()
					end
				end

				if GetFFlagEnableLoginAccountSelector() then
					p1.props.closeCentralOverlay()
				end
			end)
		end
		function p1.credentialsProtocolRegisterPassword(p73) -- line: 1216
			-- upvalues: HttpService (copy), default (copy), Constants2 (copy), p1 (copy), EventStreamConstants (copy), Logger (copy)
			local data = HttpService:JSONDecode(p73)

			if data.cvalue == nil or data.password == nil then
				return
			end

			local t4 = {
				username = data.cvalue,
				password = data.password
			}
			local json = HttpService:JSONEncode(t4)

			return default:registerCredentials(default.CredentialsTypes.password, json, Constants2.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p74) -- line: 1233
				-- upvalues: HttpService (copy), p1 (copy), EventStreamConstants (copy), Logger (copy)
				if p74 then
					local data4 = HttpService:JSONDecode(p74)

					if data4.errorCode == nil then
						if p1.passwordManagerUsageStore then
							p1.passwordManagerUsageStore.setSavedPasswordAfterLogin(true)
						end

						p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.CMPasswordLogin, EventStreamConstants.Button.SavePassword)
						Logger:info("Successfully registered password.")

						return
					end

					Logger:warning("Error registering password: " .. tostring(data4.errorMsg))
				end
			end, function(p75) -- line: 1251
				-- upvalues: Logger (copy)
				Logger:warning("Error registering password: " .. tostring(p75))
			end)
		end
		function p1.logoutAllLoggedInUsersCallback() -- line: 1257
			-- upvalues: p1 (copy), AppStorageUtilities (copy), User (copy), LogoutAllLoggedInUsers (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), LoginResult (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageService (copy), LocalStorageKey (copy), AccountSwitcherConstants (copy), GuiService (copy)
			local networking = p1.props.networking
			local v321 = AppStorageUtilities.getAccountBlob()
			local v322 = User.fromLocalStorage().userId ~= -1

			p1:setState({
				errorKey = false,
				loginButtonDisabled = true,
				isLoginInProgress = false
			})
			LogoutAllLoggedInUsers(networking, v321):await()

			local v323 = false

			if FFlagEnableNavigateToLoginAfterLogoutAll and p1.pendingLoginRetryCredentials then
				local pendingLoginRetryCredentials = p1.pendingLoginRetryCredentials

				p1.pendingLoginRetryCredentials = nil

				if pendingLoginRetryCredentials.isPasswordLogin then
					local ok, result = pcall(function() -- line: 1277
						-- upvalues: p1 (copy), networking (copy), pendingLoginRetryCredentials (copy)
						return p1.props.login(networking, pendingLoginRetryCredentials.cvalue, pendingLoginRetryCredentials.password):expect()
					end)

					if ok and result and not LoginResult.hasTwoStepData(result) then
						if FFlagEnableLuaAccountSwitch then
							p1.props.handleLoginCompletionWithAccountSwitching(networking, p1.props.omniRecommendationsRequest, p1.props.analytics, p1.props.appPolicy, result.accountBlob, p1.props.clearApp, p1.props.launchApp)

							return
						end

						p1.props.launchApp(networking, p1.props.omniRecommendationsRequest, p1.props.analytics, p1.props.appPolicy)

						return
					end
				elseif type(pendingLoginRetryCredentials.cvalue) == "table" then
					v323 = true
				end
			end

			if v322 == true then
				p1.props.resetAppState()
				AppStorageService:SetItem(LocalStorageKey.CredentialValue, "")
				AppStorageService:flush()

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					local v327 = if not v323 then AccountSwitcherConstants.AccountSwitcherPendingLoginAfterLogoutAll else AccountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV1AfterLogoutAll

					AppStorageUtilities.setAccountSwitchStatus(v327)
					AppStorageUtilities.flush()
				end

				p1.props.logoutWithoutShowConfirmation(networking, GuiService)
			end

			p1:setState({
				loginButtonDisabled = false
			})
			p1.props.closeCentralOverlay()
		end
		function p1.handleLoginError(p76, p77, p78) -- line: 1329
			-- upvalues: FFlagEnableNavigateToLoginAfterLogoutAll (copy), u173 (ref), p1 (copy), GetFFlagEnableLoginAccountSelector (copy), LoginErrorCodes (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), StatusCodes (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), Constants (copy), isStringEmail (copy), CredentialType (copy), GetFFlagEnableVNGNewAppAvailableModal (copy), GetFStringVNGDownloadNowUrl (copy), AccountLinkingAlertType (copy)
			local v331 = false

			if FFlagEnableNavigateToLoginAfterLogoutAll then
				v331 = u173
				u173 = false
			end

			local v332 = if not v331 then (not p1.cvalueRef or not p1.cvalueRef.current) and "" or p1.cvalueRef.current.Text or "" else type(p77) ~= "string" and "" or p77

			p1.props.setBackNavigationDisabled(false)

			local forceLoginByUsername = p1.state.forceLoginByUsername
			local v334 = p1.errorHandlingInfoList[p76.errorCode]

			if v334 then
				forceLoginByUsername = v334.forceLoginByUsername or forceLoginByUsername
			end

			local v335 = false
			local v336 = GetFFlagEnableLoginAccountSelector() and (p76.errorCode == LoginErrorCodes.MultipleUsersPerCredential and not p1.props.appPolicy.getAccountDisambiguationDisabled())
			local v337 = p1.props.appPolicy.getLinkedAuthEndpointsEnabled() and (p76.errorCode == LoginErrorCodes.AccountLinkingRequired or p76.errorCode == LoginErrorCodes.AccountLinkingFailed)
			local v338 = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p76.errorCode == LoginErrorCodes.SecurityQuestions

			if v336 or v338 or p76.errorCode == LoginErrorCodes.Captcha then
				v335 = true
			end

			reportEphemeralCounter(AppLoginCounterNames.Failure, 1)

			if p76.errorCode == LoginErrorCodes.Captcha then
				reportEphemeralCounter(AppLoginCounterNames.FailureCaptcha, 1)
			elseif p76.errorCode == LoginErrorCodes.IncorrectCValueOrPassword then
				reportEphemeralCounter(AppLoginCounterNames.FailureCredentials, 1)
			elseif p76.errorCode == LoginErrorCodes.AccountLocked then
				reportEphemeralCounter(AppLoginCounterNames.FailurePasswordReset, 1)
			elseif p76.errorCode == LoginErrorCodes.CTypeNotSupported then
				reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)
			elseif p76.errorCode == LoginErrorCodes.CValueAndPasswordRequired then
				reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)
			elseif v338 then
				reportEphemeralCounter(AppLoginCounterNames.FailureSecurityQuestions, 1)
			elseif p76.errorCode == LoginErrorCodes.MultipleUsersPerCredential then
				reportEphemeralCounter(AppLoginCounterNames.FailureMultipleUsersPerCredential, 1)
			elseif p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.TOO_MANY_REQUESTS then
				reportEphemeralCounter(AppLoginCounterNames.FailureThrottled, 1)
			elseif p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.REQUEST_TIMEOUT then
				reportEphemeralCounter(AppLoginCounterNames.FailureTimeout, 1)
			elseif p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.BAD_REQUEST then
				reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)
			elseif p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.NOT_FOUND then
				reportEphemeralCounter(AppLoginCounterNames.FailureNotFound, 1)
			elseif p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.INTERNAL_SERVER_ERROR then
				reportEphemeralCounter(AppLoginCounterNames.FailureInternalServerError, 1)
			else
				reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
			end

			if FFlagEnableLuaAccountSwitch == true and p76.errorCode == LoginErrorCodes.EmptyAccountSwitchBlobRequired then
				p1:setState({
					errorKey = false
				})

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					p1.pendingLoginRetryCredentials = {
						cvalue = p77,
						password = p78,
						isPasswordLogin = v331
					}
					AppStorageUtilities.setAccountSwitchTargetUsername(v332)
				end

				p1.props.openAccountSwitchingErrorOverlay(not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts", not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Description.LogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers", not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue", "Authentication.CrossDevice.Action.CancelLogin", p1.logoutAllLoggedInUsersCallback, p1.props.closeCentralOverlay, Constants.Auth.AccountSwitcherLoginEmptyBlobRequiredError, p77 or nil)
			end

			if FFlagEnableLuaAccountSwitch == true and p76.errorCode == LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired then
				p1:setState({
					errorKey = false
				})

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					p1.pendingLoginRetryCredentials = {
						cvalue = p77,
						password = p78,
						isPasswordLogin = v331
					}
					AppStorageUtilities.setAccountSwitchTargetUsername(v332)
				end

				p1.props.openAccountSwitchingErrorOverlay(not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts", not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Description.ParentLogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers", not p1.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue", "Authentication.CrossDevice.Action.CancelLogin", p1.logoutAllLoggedInUsersCallback, p1.props.closeCentralOverlay, Constants.Auth.AccountSwitcherParentLoginEmptyBlobRequiredError, p77 or nil)
			end

			if p76.errorCode == LoginErrorCodes.AccountLocked then
				p1.props.openPasswordResetPrompt()
			end

			if p76.errorCode == LoginErrorCodes.AccountNotVerified and isStringEmail(p77) and p1.canVerifyCredentials(CredentialType.Email, p77, p78) then
				p1.props.openEmailVerificationPrompt(p77, p78, p1.closeVerificationEmailModal)
			end

			if GetFFlagEnableVNGNewAppAvailableModal() and p76.errorCode == LoginErrorCodes.GlobalAppAccessDeniedVNG and p1.isMounted then
				p1.props.openNewAppAvailableModal(function() -- line: 1475
					-- upvalues: GetFStringVNGDownloadNowUrl (copy), p1 (copy)
					local v463 = GetFStringVNGDownloadNowUrl()

					p1.props.linking:openURL(v463)
				end)
			end

			if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p76.errorCode == LoginErrorCodes.SecurityQuestions and p76.securityQuestionsData and p76.securityQuestionsCallback then
				task.spawn(function() -- line: 1484
					-- upvalues: p1 (copy), p77 (copy), p78 (copy), p76 (copy)
					if p1.isMounted then
						p1.renderSecurityQuestions(p77, p78, p76.securityQuestionsCallback, p76.securityQuestionsData)
					end
				end)
			end

			if v336 then
				if p76.usersData then
					p1.handleMultipleUsersPerCredentialError(p76.usersData)
				end
			elseif p76.errorCode == LoginErrorCodes.MultipleUsersPerCredential then
				p76.errorKey = "Authentication.Login.Response.MoreThanOneUsername"
			end

			if p76.errorCode == LoginErrorCodes.PlatformNotSupported then
				p76.errorKey = "Authentication.Login.Error.PlatformAccountConnectionFailure"
			end

			if v337 then
				if p76.errorCode == LoginErrorCodes.AccountLinkingRequired then
					p1.props.showAccountLinkingAlert(AccountLinkingAlertType.IncompatibleAccounts, p76.userFacingMessage)
				elseif p76.errorCode == LoginErrorCodes.AccountLinkingFailed then
					p1.props.showAccountLinkingAlert(AccountLinkingAlertType.RetryLogInConnectionFailure)
				end
			end

			spawn(function() -- line: 1517
				-- upvalues: p1 (copy), p76 (copy), forceLoginByUsername (ref)
				if p1.isMounted then
					p1:setState({
						errorKey = p76.errorKey,
						errorCode = p76.errorCode,
						forceLoginByUsername = forceLoginByUsername
					})
				end
			end)
			p1.updateIsLoginInProgress(v335)
		end
		function p1.onLoginButtonActivated() -- line: 1530
			-- upvalues: p1 (copy), EventStreamConstants (copy)
			if p1.state.loginButtonDisabled then
				return
			end

			if p1.state.isLoginInProgress then
				return
			end

			p1.updateIsLoginInProgress(true)
			p1.props.authAnalytics.reportLogInButtonClicked(EventStreamConstants.Context.LoginScreen)
			p1.handleLoginWithFormData()
		end
		function p1.onForgetButtonActivated() -- line: 1544
			-- upvalues: p1 (copy), EventStreamConstants (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), AppPage (copy), ContentProvider (copy), TransitionAnimation (copy)
			if p1.state.isLoginInProgress then
				return
			end

			p1.unfocusTextBoxes()
			p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.LoginForm, EventStreamConstants.Button.ForgotPassword)
			p1.props.authAnalytics.reportForgotPasswordButtonClicked(EventStreamConstants.Context.LoginScreen)

			if GetFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
				p1.props.navigateToPage({
					name = AppPage.AccountRecovery,
					extraProps = {
						recoverPassword = true,
						identifier = p1.cvalueRef and (not not p1.cvalueRef.current and p1.cvalueRef.current.Text) or (p1.cvalueText and p1.cvalueText:getValue() or "")
					}
				})

				return
			end

			if p1.props.appPolicy.shouldUseExternalBrowserForDisclaimerLinks() then
				p1.props.linking:openURL(ContentProvider.BaseUrl .. "login/forgot-password-or-username")

				return
			end

			p1.props.navigateToPage({
				name = AppPage.GenericWebPage,
				detail = ContentProvider.BaseUrl .. "login/forgot-password-or-username",
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.SlideInFromRight
				}
			})
		end
		function p1.onCrossDeviceLoginActivated() -- line: 1582
			-- upvalues: p1 (copy), EventStreamConstants (copy), GetFFlagReportCrossAppLoginAttempt (copy), RbxAnalyticsService (copy)
			if p1.state.isLoginInProgress then
				return
			end

			p1.unfocusTextBoxes()
			p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.LoginForm, EventStreamConstants.Button.QuickLogin)
			p1.props.authAnalytics.reportButtonClicked(EventStreamConstants.Context.Login, EventStreamConstants.Button.LoginOtherDevice)

			if p1.props.appPolicy.getShowVNGLoginWithExistingAccountQuickLoginButton() then
				if GetFFlagReportCrossAppLoginAttempt() then
					RbxAnalyticsService:ReportCounter("CrossAppLoginAttempt", 1)
				end

				p1.props.openCrossAppLoginPrompt(p1.handleLoginWithCode)

				return
			end

			p1.props.openCrossDeviceLoginPrompt(p1.handleLoginWithCode)
		end
		function p1.topButtonActivatedTracking() -- line: 1607
			-- upvalues: FFlagEnableLuaAccountSwitch (copy), p1 (copy), EventStreamConstants (copy)
			if FFlagEnableLuaAccountSwitch == true and p1.isAlreadyAuthenticated == true then
				resetDefaultTheme()
			end

			p1.props.authAnalytics.reportDismissCornerXButtonClicked(EventStreamConstants.Context.LoginScreen)
		end
		function p1.onEmailOtpLoginAbandoned() -- line: 1614
			-- upvalues: p1 (copy)
			p1.state.isLoginByOtp = false
		end
		function p1.onEmailOtpLoginCompleted(p79, p80) -- line: 1618
			-- upvalues: p1 (copy)
			p1.state.otpSessionToken = p79
			p1.state.otpCode = p80

			return p1.handleLoginWithOtp(nil, nil)
		end
		function p1.onEmailOtpLoginActivated() -- line: 1624
			-- upvalues: p1 (copy), EventStreamConstants (copy)
			if p1.state.isLoginInProgress then
				return
			end

			p1.unfocusTextBoxes()

			local t5 = {
				origin = "login",
				codeLength = 6,
				enterEmailTitleKey = "Authentication.Login.Label.GetOneTimeCode",
				enterEmailDescriptionKey = "Authentication.Login.Description.GetOneTimeCodeHelp",
				enterCodeTitleKey = "Authentication.Login.Label.EnterOneTimeCode",
				enterCodeDescriptionKey = "Authentication.Login.Description.EnterOneTimeCodeHelpV2",
				onSubmitCode = p1.onEmailOtpLoginCompleted,
				onModalAbandoned = p1.onEmailOtpLoginAbandoned,
				screenSize = p1.props.screenSize
			}

			p1.props.openEmailOtp(t5)
			p1.state.isLoginByOtp = true
			p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.LoginForm, EventStreamConstants.Button.EmailOtp)
			p1.props.authAnalytics.reportButtonClicked(EventStreamConstants.Context.Login, EventStreamConstants.Button.OneTimePasscode)
		end
		function p1.closeVerificationEmailModal(p81) -- line: 1652
			-- upvalues: p1 (copy)
			if p1.isMounted then
				p1.updateCValueText(p81)

				if p81 ~= "" and p1.passwordRef.current then
					p1.passwordRef.current:CaptureFocus()
				end

				p1:setState({
					errorCode = -1,
					errorKey = "",
					forceLoginByUsername = false
				})
			end
		end

		p1.events = {}
		p1.props.authAnalytics.reportScreenLoaded(EventStreamConstants.Context.LoginScreen)
	end
end

function v163.didMount(p82) -- line: 1670
	-- upvalues: EventStreamConstants (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), FFlagEnableLuaAccountSwitch (copy), MemStorageService (copy), MemStorageKeys (copy), SystemThemeFeature (copy), FFlagEnableVNGDUARSignupCompliance (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), v147 (copy), UiMode (copy), UserInputService (copy), v133 (copy), GuiService (copy), AppPage (copy), HttpService (copy), GetFFlagLuaAppEnableDesktopDualLoginABTest (copy), GetIXPLayerParameters (copy), GetFFlagEnableCredentialsProtocolPasswords (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), Logger (copy), LocalizationService (copy), TelemetryConfigs (copy)
	p82.isMounted = true
	p82.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.LoginForm)

	local v181 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()

	p82.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.LoginScreen, v181)

	if FFlagEnableLuaAccountSwitch == true and p82.isAlreadyAuthenticated == true then
		MemStorageService:Fire(MemStorageKeys.ThemeUpdate, "dark")
	end

	SystemThemeFeature.SetDarkThemeOverride()

	if FFlagEnableVNGDUARSignupCompliance and p82.props.appPolicy.getLoginUsernameOnly() then
		p82:setState({
			forceLoginByUsername = true
		})
	end

	if FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable() then
		if p82.props.usernameFromIosKeychain then
			KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.autoPopulatedUsername)
			p82.updateCValueText(p82.props.usernameFromIosKeychain)
		end

		if p82.props.passwordFromIosKeychain then
			KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.autoPopulatedPassword)
			p82.updatePasswordText(p82.props.passwordFromIosKeychain)
		end

		if v147 then
			p82:setState({
				loginButtonDisabled = not (p82.props.usernameFromIosKeychain and p82.props.passwordFromIosKeychain)
			})
		else
			p82:setState({
				loginButtonDisabled = false
			})
		end
	end

	local function isWithinBounds(p83, p84) -- line: 1721
		-- upvalues: p82 (copy), UiMode (copy)
		if p82.props.uiModeInfo.uiMode == UiMode.VR then
			error("Input position is not supported in VR")
		end

		local AbsolutePosition = p84.AbsolutePosition
		local AbsoluteSize = p84.AbsoluteSize

		return p83.X > AbsolutePosition.X and (p83.X < AbsolutePosition.X + AbsoluteSize.X and (p83.Y > AbsolutePosition.Y and p83.Y < AbsolutePosition.Y + AbsoluteSize.Y))
	end
	local function getNextSelectedObject(p85) -- line: 1734
		-- upvalues: UserInputService (copy), v133 (copy), p82 (copy)
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
			if v133 then
				return p82.focusRef and (p82.focusRef.current and p82.focusRef.current.NextSelectionUp)
			end

			return p85.NextSelectionUp
		end

		if v133 then
			return p82.focusRef and (p82.focusRef.current and p82.focusRef.current.NextSelectionDown)
		end

		return p85.NextSelectionDown
	end
	local function getNewSelectedObject() -- line: 1752
		-- upvalues: v133 (copy), p82 (copy), GuiService (copy), getNextSelectedObject (copy)
		local v348 = if not v133 then GuiService.SelectedObject else p82.focusRef and p82.focusRef.current
		local v349 = getNextSelectedObject(v348)

		if v349 == p82.loginButtonRef.current and p82.state.loginButtonDisabled then
			v349 = getNextSelectedObject(v349)
		end

		if p82.isMounted then
			p82:setState({
				forgotLinkFocused = v349 == p82.forgotLinkRef.current
			})
		end

		return v349
	end

	table.insert(p82.events, UserInputService.InputBegan:connect(function(p86, _) -- line: 1773
		-- upvalues: p82 (copy), AppPage (copy), v133 (copy), GuiService (copy), getNewSelectedObject (copy)
		if p82.props.currentPageName ~= AppPage.Login then
			return
		end

		if p86.UserInputType == Enum.UserInputType.Keyboard then
			if p86.KeyCode == Enum.KeyCode.Return then
				if p82.state.forgotLinkFocused then
					p82.onForgetButtonActivated()

					return
				end

				p82.onLoginButtonActivated()

				return
			end

			if p86.KeyCode == Enum.KeyCode.Tab then
				local v352 = if not v133 then GuiService.SelectedObject else p82.focusRef and p82.focusRef.current

				if not v352 then
					return
				end

				local v353 = getNewSelectedObject()

				if not v353 then
					return
				end

				if v352:IsA("TextBox") and v352.ManualFocusRelease then
					v352:ReleaseFocus()
				end

				if v133 then
					p82.focusRef.current = v353
				else
					GuiService.SelectedObject = v353
				end

				if v353:IsA("TextBox") then
					v353:CaptureFocus()
				end
			end
		end
	end))
	table.insert(p82.events, UserInputService.InputEnded:connect(function(p88, _) -- line: 1818
		-- upvalues: p82 (copy), AppPage (copy), UiMode (copy), UserInputService (copy), isWithinBounds (copy)
		if p82.props.currentPageName ~= AppPage.Login then
			return
		end

		if p82.props.uiModeInfo.uiMode == UiMode.VR then
			return
		end

		if p88.UserInputType == Enum.UserInputType.MouseButton1 or p88.UserInputType == Enum.UserInputType.Touch then
			local p88Position = p88.Position
			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if not p82.cvalueRef.current or not p82.passwordRef.current then
				return
			end

			if not FocusedTextBox then
				return
			end

			local v358 = isWithinBounds(p88Position, p82.cvalueRef.current)
			local v359 = isWithinBounds(p88Position, p82.passwordRef.current)

			if FocusedTextBox == p82.cvalueRef.current and v359 then
				p82.cvalueRef.current:ReleaseFocus()
				p82.passwordRef.current:CaptureFocus()

				return
			end

			if FocusedTextBox == p82.passwordRef.current and v358 then
				p82.passwordRef.current:ReleaseFocus()
				p82.cvalueRef.current:CaptureFocus()

				return
			end

			if not v358 and not v359 and (FocusedTextBox == p82.cvalueRef.current or FocusedTextBox == p82.passwordRef.current) then
				FocusedTextBox:ReleaseFocus()
			end
		end
	end))
	table.insert(p82.events, UserInputService.TextBoxFocused:connect(function(p90) -- line: 1860
		-- upvalues: p82 (copy), AppPage (copy), v133 (copy), GuiService (copy)
		if p82.props.currentPageName ~= AppPage.Login then
			return
		end

		if p82.state.isLoginInProgress then
			p90:ReleaseFocus()

			return
		end

		if v133 then
			p82.focusRef.current = p90

			return
		end

		GuiService.SelectedObject = p90
	end))
	table.insert(p82.events, UserInputService.TextBoxFocusReleased:connect(function(_) -- line: 1879
		-- upvalues: p82 (copy), AppPage (copy), v133 (copy), GuiService (copy)
		if p82.props.currentPageName ~= AppPage.Login then
			return
		end

		if v133 then
			p82.focusRef.current = nil

			return
		end

		GuiService.SelectedObject = nil
	end))
	table.insert(p82.events, MemStorageService:bind(MemStorageKeys.AutoFillCredentials, function(p92) -- line: 1894
		-- upvalues: p82 (copy), AppPage (copy), HttpService (copy)
		if p82.props.currentPageName ~= AppPage.Login then
			return
		end

		if p82.state.isLoginInProgress then
			return
		end

		local data = HttpService:JSONDecode(p92)

		if data then
			p82.updateCValueText(data.cvalue)
			p82.updatePasswordText(data.password)
		end
	end))

	if GetFFlagLuaAppEnableDesktopDualLoginABTest() then
		GetIXPLayerParameters(p82.props.networking, "PlayerApp.Login", { "isDesktopDualLoginEnabled" }):andThen(function(p93) -- line: 1911
			-- upvalues: p82 (copy)
			local v365 = p93 and p93.responseBody

			if v365 and p82.isMounted then
				local isDesktopDualLoginEnabled = v365.isDesktopDualLoginEnabled

				if isDesktopDualLoginEnabled then
					p82:setState({
						isDesktopDualLoginEnabled = isDesktopDualLoginEnabled
					})
				end
			end
		end, function() -- line: 1922
		end)
	end

	if GetFFlagEnableCredentialsProtocolPasswords() then
		local u185 = false
		local u186 = false
		local u187 = false

		default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p94) -- line: 1935
			-- upvalues: u185 (ref), u186 (ref), u187 (ref), p82 (copy)
			if p94.FIDO2 ~= nil then
				u185 = p94.FIDO2.isAvailable and p94.FIDO2.supportsDeviceBoundOnly
				u186 = p94.password and p94.password.isAvailable
				u187 = p94.password ~= nil

				if p82.isMounted then
					p82:setState({
						isCredentialsProtocolRegisterPasswordAvailable = u186
					})
				end
			else
				u185 = p94.isAvailable and p94.supportsDeviceBoundOnly
			end

			if u187 then
				p82.showGenericCredentialLoginPopup(u185, u186)

				return
			end

			if u185 then
				p82.showPasskeyLoginPopup()
			end
		end):catch(function(p95) -- line: 1960
			-- upvalues: Logger (copy)
			Logger:warning("Error checking for available credential types. Error: {}", p95)
		end):finally(function() -- line: 1963
			-- upvalues: p82 (copy), EventStreamConstants (copy), u186 (ref), u185 (ref)
			p82.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.CMPasswordLogin, (tostring(u186)))
			p82.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.PasskeyLogin, u185 == nil and "timeout" or tostring(u185))
		end)
	else
		local u188 = false

		default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p96) -- line: 1977
			-- upvalues: u188 (ref), p82 (copy)
			u188 = p96.isAvailable and p96.supportsDeviceBoundOnly

			if u188 then
				p82.showPasskeyLoginPopup()
			end
		end):catch(function(p97) -- line: 1983
			warn("Error checking if FIDO2 passkeys is available. Error: ", p97)
		end):finally(function() -- line: 1986
			-- upvalues: p82 (copy), EventStreamConstants (copy), u188 (ref)
			p82.props.authAnalytics.reportAuthPageload(EventStreamConstants.Context.PasskeyLogin, u188 == nil and "timeout" or tostring(u188))
		end)
	end

	if LocalizationService.RobloxLocaleId:match("^en") then
		GetIXPLayerParameters(p82.props.networking, "PlayerApp.Login", { "CrossDeviceButtonText" }):andThen(function(p98) -- line: 1997
			-- upvalues: p82 (copy)
			local v372 = p98 and p98.responseBody

			if v372 and p82.isMounted then
				local CrossDeviceButtonText = v372.CrossDeviceButtonText

				if CrossDeviceButtonText then
					p82:setState({
						quickLoginButtonTextOverride = CrossDeviceButtonText
					})
				end
			end
		end, function() -- line: 2008
		end)
	end

	p82.props.loggingProtocol:logEventOnce("login_view_did_mount")
	p82.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.LoginPageMountTelemetryConfig, 1, {
		version = 1
	})
end
function v163.willUnmount(p99) -- line: 2021
	-- upvalues: FFlagEnableLuaAccountSwitch (copy)
	if FFlagEnableLuaAccountSwitch == true and p99.isAlreadyAuthenticated == true then
		resetDefaultTheme()
	end

	p99.unfocusTextBoxes()

	for _, v in ipairs(p99.events) do
		v:Disconnect()
	end

	p99.events = {}
	p99.isMounted = false
end
function v163.didUpdate(p100, _, p102) -- line: 2036
	if p100.state.errorCode == -1 then
		return
	end

	local isLoginInProgress = p100.state.isLoginInProgress

	if p102.isLoginInProgress and not isLoginInProgress then
		local v196 = p100.errorHandlingInfoList[p100.state.errorCode]

		if not v196 then
			return
		end

		if v196.textBoxesToClear then
			for _, v in pairs(v196.textBoxesToClear) do
				if v == 1 then
					p100.updateCValueText("")
				elseif v == 2 then
					p100.updatePasswordText("")
				end
			end
		end

		if v196.newFocusedTextBox == 1 and p100.cvalueRef.current then
			p100.cvalueRef.current:CaptureFocus()

			return
		end

		if v196.newFocusedTextBox == 2 and p100.passwordRef.current then
			p100.passwordRef.current:CaptureFocus()
		end
	end
end
function v163.render(p103) -- line: 2068
	-- upvalues: UiMode (copy), GetFFlagLuaAppEnableDesktopDualLoginABTest (copy), FFlagEnableVNGDUARSignupCompliance (copy), FFlagAuthSecExclusions (copy), GetFFlagEnableOtpEmailLogin (copy), FFlagEnableKoreaKISACompliance (copy), withStyle (copy), FlagSettings (copy), withLocalization (copy), DualLoginWithContentsLayout (copy), LogoWithContentsLayout (copy), Roact (copy), Alignment (copy), CredentialLoginContainer (copy), LoginCodePrompt (copy), LinkButton (copy), DisclaimerLinks (copy), v164 (copy)
	local v200 = p103.state.errorKey ~= "" and p103.state.errorKey or nil
	local v201 = p103.state.errorKey == false and p103.state.localizedErrorMessage or nil
	local u202 = not p103.props.appPolicy.getWebViewSupport() and p103.props.uiModeInfo.uiMode ~= UiMode.VR
	local v203 = p103.props.uiModeInfo.uiMode == UiMode.TenFoot or p103.props.uiModeInfo.uiMode == UiMode.VR
	local v204 = GetFFlagLuaAppEnableDesktopDualLoginABTest() and p103.state.isDesktopDualLoginEnabled
	local v205 = v203 or p103.props.appPolicy.getEnableDualLogin() and v204
	local v206 = p103.props.appPolicy.getDisableEmailOTPLogin() and (FFlagEnableVNGDUARSignupCompliance or FFlagAuthSecExclusions)
	local v207 = GetFFlagEnableOtpEmailLogin() and (p103.props.isLoginWithOtpEnabled and not v206)
	local v208 = p103.props.appPolicy.getUseVNGUserAgreementPopup()
	local v209 = FFlagEnableKoreaKISACompliance and p103.props.appPolicy.getUseKoreaKISAUserAgreementPopup()
	local v210 = FFlagEnableVNGDUARSignupCompliance and p103.props.appPolicy.getDisableLoginForgotButton()

	return withStyle(function(p104) -- line: 2095
		-- upvalues: FlagSettings (copy), v205 (copy), FFlagAuthSecExclusions (copy), p103 (copy), u202 (ref), withLocalization (copy), v200 (copy), v203 (copy), DualLoginWithContentsLayout (copy), LogoWithContentsLayout (copy), UiMode (copy), Roact (copy), Alignment (copy), CredentialLoginContainer (copy), v201 (copy), v208 (copy), v209 (copy), v207 (copy), LoginCodePrompt (copy), v210 (copy), LinkButton (copy), DisclaimerLinks (copy), v164 (copy)
		local u375 = FlagSettings.CrossDeviceLoginRolloutEnabledForDevice() and not v205

		if FFlagAuthSecExclusions and p103.props.appPolicy.getExcludeCrossDeviceSignIn() then
			u375 = false
		end

		local v376 = p103.props.appPolicy.getShowVNGLoginWithExistingAccountQuickLoginButton()

		if p103.props.appPolicy.getDisableRegularLogin() == false then
			u202 = false
		end

		return withLocalization({
			logInText = "Authentication.Login.Action.SignIn",
			forgotText = "Authentication.Login.Action.ForgotPasswordOrUsernameQuestionCapitalized",
			passwordPlaceholder = "CommonUI.Messages.Label.Password",
			twoStepHeader = "Authentication.TwoStepVerification.Label.TwoStepVerification",
			crossDeviceLoginHeader = "Authentication.CrossDevice.Heading.QuickLogin",
			loginWithExistingAccountButtonText = "Authentication.CrossDevice.Heading.QuickLogin",
			orText = "CommonUI.Messages.Label.OR",
			localizedError = v200,
			cvaluePlaceholder = not p103.state.forceLoginByUsername and "Authentication.Login.Label.UsernameEmailPhone" or "Authentication.Login.Label.Username"
		})(function(p105) -- line: 2122
			-- upvalues: p103 (copy), v376 (copy), v203 (copy), DualLoginWithContentsLayout (copy), LogoWithContentsLayout (copy), UiMode (copy), Roact (copy), Alignment (copy), v205 (copy), CredentialLoginContainer (copy), u375 (ref), v201 (copy), u202 (ref), v208 (copy), v209 (copy), v207 (copy), p104 (copy), LoginCodePrompt (copy), v210 (copy), LinkButton (copy), DisclaimerLinks (copy), v164 (copy)
			local v465 = p103.state.quickLoginButtonTextOverride ~= "" and p103.state.quickLoginButtonTextOverride or p105.crossDeviceLoginHeader

			if v376 then
				v465 = p105.loginWithExistingAccountButtonText
			end

			local v466 = if not v203 then LogoWithContentsLayout else DualLoginWithContentsLayout
			local v467 = v203 and p103.props.uiModeInfo.uiMode ~= UiMode.VR

			return Roact.createElement(v466, {
				ContentAlign = Alignment.Top,
				topButtonActivatedTracking = p103.topButtonActivatedTracking,
				topButtonEnabled = not p103.state.isLoginInProgress,
				statusBarHeight = p103.props.statusBarHeight,
				globalGuiInset = p103.props.globalGuiInset,
				screenSize = p103.props.screenSize,
				isDualLayout = v205,
				navigateBack = if not v203 then nil else p103.props.navigateBack,
				buttonRef = p103.props.containerRef
			}, {
				UIListLayout = v205 and Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}) or Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15)
				}),
				Form = if not v205 then Roact.createElement(CredentialLoginContainer, {
					crossDeviceLoginEnabled = u375,
					quickLoginButtonText = v465,
					loginWithExistingAccountVariantEnabled = v376,
					handleLoginWithFormDataCallback = p103.handleLoginWithFormData,
					updateIsLoginInProgress = p103.updateIsLoginInProgress,
					cvalueText = p103.cvalueText,
					passwordText = p103.passwordText,
					onTextBoxesChanged = p103.onTextBoxesChanged,
					buttonRef = p103.props.defaultRef,
					cvalueRef = p103.cvalueRef,
					passwordRef = p103.passwordRef,
					loginButtonRef = p103.loginButtonRef,
					forgotLinkRef = p103.forgotLinkRef,
					crossDeviceButtonRef = p103.crossDeviceButtonRef,
					emailOtpRef = p103.emailOtpRef,
					localizedError = p105.localizedError,
					localizedErrorMessage = v201,
					forceLoginByUsername = p103.state.forceLoginByUsername or v203,
					onCrossDeviceLoginActivated = p103.onCrossDeviceLoginActivated,
					onEmailOtpActivated = p103.onEmailOtpLoginActivated,
					loginButtonDisabled = p103.state.loginButtonDisabled,
					isLoginInProgress = p103.state.isLoginInProgress,
					authAnalytics = p103.props.authAnalytics,
					disableRegularLogin = u202,
					showLinkAccountText = p103.props.appPolicy.getUseSingleSignOn(),
					showForgotButton = not u202 and (v205 and not v203),
					onForgetButtonActivated = p103.onForgetButtonActivated,
					maxSizeX = not v205 and 360 or 1e999,
					showDisclaimerLinks = v205 and (not v203 and not (v208 or v209)),
					showDisclaimerButtons = v205 and (v203 and not v208),
					showCredentialHeader = v205 and not v203,
					isDualLayout = v205,
					isTenFootUiMode = v203,
					emailOtpEnabled = v207
				}) else Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 1, 0)
				}, {
					FormContent = Roact.createElement(CredentialLoginContainer, {
						Size = UDim2.new(0, 0, 1, 0),
						crossDeviceLoginEnabled = u375,
						quickLoginButtonText = v465,
						loginWithExistingAccountVariantEnabled = v376,
						handleLoginWithFormDataCallback = p103.handleLoginWithFormData,
						updateIsLoginInProgress = p103.updateIsLoginInProgress,
						cvalueText = p103.cvalueText,
						passwordText = p103.passwordText,
						onTextBoxesChanged = p103.onTextBoxesChanged,
						buttonRef = p103.props.defaultRef,
						cvalueRef = p103.cvalueRef,
						passwordRef = p103.passwordRef,
						loginButtonRef = p103.loginButtonRef,
						forgotLinkRef = p103.forgotLinkRef,
						crossDeviceButtonRef = p103.crossDeviceButtonRef,
						emailOtpRef = p103.emailOtpRef,
						localizedError = p105.localizedError,
						localizedErrorMessage = v201,
						forceLoginByUsername = p103.state.forceLoginByUsername or v203,
						onCrossDeviceLoginActivated = p103.onCrossDeviceLoginActivated,
						onEmailOtpActivated = p103.onEmailOtpLoginActivated,
						loginButtonDisabled = p103.state.loginButtonDisabled,
						isLoginInProgress = p103.state.isLoginInProgress,
						authAnalytics = p103.props.authAnalytics,
						disableRegularLogin = u202,
						showLinkAccountText = v467,
						showForgotButton = not u202 and not v203,
						onForgetButtonActivated = p103.onForgetButtonActivated,
						maxSizeX = 1e999,
						showDisclaimerLinks = not v203 and not (v208 or v209),
						showDisclaimerButtons = v203 and not v208,
						showCredentialHeader = not v203,
						isDualLayout = true,
						isTenFootUiMode = v203,
						emailOtpEnabled = v207,
						LayoutOrder = 2
					})
				}),
				Divider = v205 and Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, p104.Tokens.Size.Size_1000, 1, 0)
				}, {
					Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, p104.Tokens.Size.Size_300)
					}),
					Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						LayoutOrder = 1,
						Size = UDim2.new(0, p104.Tokens.Size.Size_50, 0.5, 0),
						BackgroundColor3 = p104.Tokens.Color.Extended.Gray.Gray_800.Color3
					}),
					Roact.createElement("TextLabel", {
						TextTransparency = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Text = p105.orText,
						TextSize = p104.Tokens.Size.Size_400,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = p104.Tokens.Color.Extended.Gray.Gray_800.Color3
					}),
					Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						LayoutOrder = 3,
						Size = UDim2.new(0, p104.Tokens.Size.Size_50, 0.5, 0),
						BackgroundColor3 = p104.Tokens.Color.Extended.Gray.Gray_800.Color3
					})
				}) or nil,
				LoginCode = v205 and Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 1, 0)
				}, { Roact.createElement(LoginCodePrompt, {
					isOverlay = false,
					isDualLayout = true,
					loginCallback = p103.handleLoginWithCode,
					hideDeviceCode = not v203,
					showLockIcon = not v203
				}) }),
				Forgot = if u202 or (v205 or v210) then nil else Roact.createElement(LinkButton, {
					fontStyle = "Footer",
					colorStyleDefault = "TextDefault",
					colorStyleHover = "TextDefault",
					text = p105.forgotText,
					size = UDim2.new(0, 0, 0, 30),
					onActivated = p103.onForgetButtonActivated
				}),
				DisclaimerLinks = if v205 or (v208 or v209) then nil else Roact.createElement(DisclaimerLinks, {
					LayoutOrder = 60,
					fillDirection = Enum.FillDirection.Vertical
				}),
				Padding = not v205 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 61,
					Size = UDim2.new(1, 0, 0, v164)
				}) or nil
			})
		end)
	end)
end

local v166 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	authAnalytics = RoactAnalyticsAuthEvents,
	loggingProtocol = AppLogging,
	linking = AppLinking
})(v163)
local v167 = RoactRodux.connect(function(p106, _) -- line: 2326
	-- upvalues: FFlagSignalsNavP3eAuth (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v213 = nil

	if not FFlagSignalsNavP3eAuth then
		if FFlagUseNavigationSelectors then
			v213 = Selectors.selectCurrentPageName(p106)
		else
			local v214 = p106.Navigation.history[#p106.Navigation.history]

			v213 = v214[#v214].name
		end
	end

	return {
		currentPageName = if not FFlagSignalsNavP3eAuth then v213 else nil,
		screenSize = p106.ScreenSize,
		statusBarHeight = p106.TopBar.statusBarHeight,
		globalGuiInset = p106.GlobalGuiInset
	}
end, function(p108) -- line: 2342
	-- upvalues: Login (copy), LoginByCode (copy), LoginByPasskey (copy), LoginByOtp (copy), LaunchApp (copy), LaunchContext (copy), ResetAppState (copy), Promise (copy), User (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants (copy), AppStorageUtilities (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy), FFlagSignalsNavP3Dispatch (copy), v50 (copy), NavigateDown (copy), SetLoginResult (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy), SetCentralOverlay (copy), OverlayType (copy), GetFFlagEnableVNGNewAppAvailableModal (copy), CrossDeviceLogin (copy), OpenAccountSelector (copy), GetFFlagShouldUsePeekViewForLoginDisambiguation (copy), OpenEmailOtp (copy), CloseCentralOverlay (copy), RenderChallenge (copy), StartPasskeyAuthentication (copy), LogoutAllLoggedInUsers (copy), Logout (copy), OpenAccountSwitchingErrorOverlay (copy), NavigateBack (copy)
	return {
		login = function(...) -- line: 2344
			-- upvalues: p108 (copy), Login (copy)
			return p108(Login(...))
		end,
		loginByCode = function(...) -- line: 2347
			-- upvalues: p108 (copy), LoginByCode (copy)
			return p108(LoginByCode(...))
		end,
		loginByPasskey = function(...) -- line: 2350
			-- upvalues: p108 (copy), LoginByPasskey (copy)
			return p108(LoginByPasskey(...))
		end,
		loginByOtp = function(...) -- line: 2353
			-- upvalues: p108 (copy), LoginByOtp (copy)
			return p108(LoginByOtp(...))
		end,
		launchApp = function(p109, p110, p111, p112) -- line: 2356
			-- upvalues: p108 (copy), LaunchApp (copy), LaunchContext (copy)
			return p108(LaunchApp(p109, p110, p111, p112, LaunchContext.Login))
		end,
		clearApp = function() -- line: 2362
			-- upvalues: p108 (copy), ResetAppState (copy), Promise (copy)
			p108(ResetAppState())

			return Promise.resolve(true)
		end,
		handleLoginCompletionWithAccountSwitching = function(p113, p114, p115, p116, p117, p118, p119) -- line: 2367
			-- upvalues: User (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants (copy), AppStorageUtilities (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy)
			if User.fromLocalStorage().userId ~= -1 then
				p118():andThen(function(_) -- line: 2378
					-- upvalues: FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), Constants (copy), AppStorageUtilities (copy), p117 (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy)
					local v469 = if not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then Constants.Auth.AccountSwitcherSwitchedStatus else AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus

					AppStorageUtilities.setAccountSwitchStatus(v469)
					AppStorageUtilities.setAccountBlob(p117)
					AppStorageUtilities.flush()

					if FFlagLuaEnableDidSwitchAccount then
						GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)

						return
					end

					GuiService:BroadcastNotification("", NotificationType.DID_LOG_OUT)
				end, function(_) -- line: 2390
					-- upvalues: AppStorageUtilities (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), p117 (copy), p119 (copy), p113 (copy), p114 (copy), p115 (copy), p116 (copy)
					AppStorageUtilities.setAccountSwitchStatus(not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues and "switched" or AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus)
					AppStorageUtilities.setAccountBlob(p117)
					AppStorageUtilities.flush()
					p119(p113, p114, p115, p116)
				end)

				return
			end

			AppStorageUtilities.setAccountBlob(p117)
			AppStorageUtilities.flush()
			p119(p113, p114, p115, p116)
		end,
		setBackNavigationDisabled = function(p122) -- line: 2407
			-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), p108 (copy), SetBackNavigationDisabled (copy)
			if FFlagUseBackDisableSignalStore then
				return (BackDisableStore.setDisabled(p122))
			end

			return (p108(SetBackNavigationDisabled(p122)))
		end,
		navigateToPage = function(p123) -- line: 2412
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v50 (copy), p108 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v50.down(v50.fromLegacyPage(p123))
			end

			return p108(NavigateDown(p123))
		end,
		setLoginResult = function(p124) -- line: 2419
			-- upvalues: p108 (copy), SetLoginResult (copy)
			p108(SetLoginResult(p124))
		end,
		openPasswordResetPrompt = function() -- line: 2422
			-- upvalues: p108 (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy)
			p108(OpenCentralOverlayForLoginPasswordResetPrompt())
		end,
		openEmailVerificationPrompt = function(p125, p126, p127) -- line: 2425
			-- upvalues: p108 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p108(SetCentralOverlay(OverlayType.LoginEmailVerificationPrompt, {
				credentialValue = p125,
				password = p126,
				onClose = p127
			}))
		end,
		openNewAppAvailableModal = function(p128) -- line: 2432
			-- upvalues: GetFFlagEnableVNGNewAppAvailableModal (copy), p108 (copy), SetCentralOverlay (copy), OverlayType (copy)
			if GetFFlagEnableVNGNewAppAvailableModal() then
				p108(SetCentralOverlay(OverlayType.NewAppAvailableModal, {
					onButtonActivated = p128
				}))
			end
		end,
		openCrossDeviceLoginPrompt = function(p129) -- line: 2439
			-- upvalues: p108 (copy), CrossDeviceLogin (copy)
			p108(CrossDeviceLogin.OpenLoginCodePrompt({
				isOverlay = true,
				loginCallback = p129
			}))
		end,
		openCrossAppLoginPrompt = function(p130) -- line: 2445
			-- upvalues: p108 (copy), CrossDeviceLogin (copy)
			p108(CrossDeviceLogin.OpenLoginCodePrompt({
				isOverlay = true,
				isCrossApp = true,
				loginCallback = p130
			}))
		end,
		openAccountSelector = function(p131, p132) -- line: 2452
			-- upvalues: p108 (copy), OpenAccountSelector (copy), GetFFlagShouldUsePeekViewForLoginDisambiguation (copy)
			if p132 then
				p108(OpenAccountSelector(p131, true, true))

				return
			end

			p108(OpenAccountSelector(p131, GetFFlagShouldUsePeekViewForLoginDisambiguation(), false))
		end,
		openEmailOtp = function(p133) -- line: 2461
			-- upvalues: p108 (copy), OpenEmailOtp (copy)
			p108(OpenEmailOtp(p133))
		end,
		closeCentralOverlay = function() -- line: 2464
			-- upvalues: p108 (copy), CloseCentralOverlay (copy)
			return p108(CloseCentralOverlay())
		end,
		resetAppState = function() -- line: 2467
			-- upvalues: p108 (copy), ResetAppState (copy)
			return p108(ResetAppState())
		end,
		renderChallenge = function(p134, p135) -- line: 2470
			-- upvalues: p108 (copy), RenderChallenge (copy)
			return p108(RenderChallenge(p134, p135))
		end,
		startPasskeyAuthentication = function(p136) -- line: 2473
			-- upvalues: p108 (copy), StartPasskeyAuthentication (copy)
			return p108(StartPasskeyAuthentication(p136))
		end,
		logoutAllLoggedInUsers = function(p137, p138) -- line: 2476
			-- upvalues: p108 (copy), LogoutAllLoggedInUsers (copy)
			return p108(LogoutAllLoggedInUsers(p137, p138))
		end,
		logoutWithoutShowConfirmation = function(p139, p140) -- line: 2479
			-- upvalues: p108 (copy), Logout (copy)
			return p108(Logout(p139, p140))
		end,
		openAccountSwitchingErrorOverlay = function(p141, p142, p143, p144, p145, p146, p147, p148) -- line: 2482
			-- upvalues: p108 (copy), OpenAccountSwitchingErrorOverlay (copy)
			return p108(OpenAccountSwitchingErrorOverlay(p141, p142, p143, p144, p145, p146, p147, p148))
		end,
		navigateBack = function() -- line: 2505
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v50 (copy), p108 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v50.back()
			end

			return p108(NavigateBack())
		end,
		showAccountLinkingAlert = function(p149, p150) -- line: 2512
			-- upvalues: p108 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p108(SetCentralOverlay(OverlayType.AccountLinkingAlert, {
				alertType = p149,
				userFacingMessage = p150
			}))
		end
	}
end)(v166)

if FFlagSignalsNavP3eAuth then
	v167 = (function(p151) -- line: 2522
		-- upvalues: v85 (copy), useSignalState (copy), Roact (copy), Cryo (copy)
		return function(p152) -- line: 2523
			-- upvalues: v85 (copy), useSignalState (copy), Roact (copy), p151 (copy), Cryo (copy)
			local v418 = v85(false)
			local v419 = useSignalState(v418.getCurrentPage)
			local v420 = v419 and v419.name

			return Roact.createElement(p151, Cryo.Dictionary.union(p152, {
				currentPageName = v420
			}))
		end
	end)(v167)
end

local v168 = RoactAppPolicy.connect(function(p153, _) -- line: 2537
	return {
		appPolicy = p153
	}
end)(v167)
local v169 = RoactAppExperiment.connectBrowserTrackerLayer({
	AppBtidLayers.LoginLayer,
	AppBtidLayers.AccountSwitcherLayer
}, function(p155, _) -- line: 2546
	-- upvalues: AppBtidLayers (copy), GetFFlagEnableAccountSwitcherIXPTextGatingFix (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), v149 (copy)
	local v221 = p155[AppBtidLayers.LoginLayer] or {}
	local v224

	if GetFFlagEnableAccountSwitcherIXPTextGatingFix() then
		local v222 = p155[AppBtidLayers.AccountSwitcherLayer] or {}
		local v223 = not GetFFlagEnableAccountSwitcherRedesignIXP() or v222.enableAccountSwitcherFoundationDesign == true

		v224 = GetFFlagEnableAccountSwitcherFoundationDesign() and v223
	else
		v224 = GetFFlagEnableAccountSwitcherFoundationDesign()
	end

	return {
		isLoginWithOtpEnabled = v149 or v221.IsLoginWithOtpEnabled,
		shouldLoginWithKeystoreCredentials = v221.shouldLoginWithKeystoreCredentials,
		showAccountSwitcherFoundationDesign = v224,
		showFoundationDisambiguationSelector = v221.showFoundationDisambiguationSelector or false
	}
end)(v168)
local u170 = withNavigationProps(function(_, p158) -- line: 2568
	return p158
end)(v169)

local function LoginViewFn(p159) -- line: 2572
	-- upvalues: useUiModeInfo (copy), ReactFocusNavigation (copy), Roact (copy), u170 (ref), Cryo (copy)
	local v228 = useUiModeInfo()
	local v229, v230 = ReactFocusNavigation.useDefaultFocusBehavior()

	return Roact.createElement(u170, Cryo.Dictionary.join({
		uiModeInfo = v228,
		defaultRef = v229,
		containerRef = v230
	}, p159))
end

return LoginViewFn
