local UserInputService, AppGuiService, AppLogging, RoactAnalyticsAuthEvents, RoactAnalytics, RoactNetworking, Roact, React, RoactRodux, ReactFocusNavigation, RoactServices, RoactAppPolicy, RoactAppExperiment, Responsive, usePreferredInput, useBreakpointXOrSmaller, useDispatch, withLocalization, withNavigationProps, Button, ButtonType, Constants, withStyle, ImageSetLabel, GetImageData, ImageSetButton, Foundation, Checkbox, InputSize, View, FoundationText, useTokens, UnderAgeInteractiveAlert, FitChildren, FitTextLabel, FullscreenPageWithSafeArea, AuthBirthdayBar, CollapsingTextInputValidator, SignUpGenderSelector, TitleAndParagraph, DisclaimerLinks, ContactInfoField, BirthdayField, SuggestionsFrame, SignUpPageView, DisplayNameField, UiModeStyleProvider, DisclaimerLinksVariant, parseCredentialsProtocolIsAvailableResponse, AuditContentContext, BackgroundFill, AuthBackgroundContainer, AuthBackgroundGate, useSignUpPageNavigationBindings, AnalyticsEvents, EventConstants, TelemetryConfigs, PreAuthDeepLinkUrlStore, RobloxLocaleIdKey, DisplayNameCounters, FormFactor, OverlayType, ToastType, DateHelper, UsernameValidationContext, EventStreamConstants, AppBtidLayers, InputValidity, default, LinkingProtocol, UserAgreementsCounterNames, Cryo, FFlagSignalsNavP3Dispatch, FFlagUseBackDisableSignalStore, FFlagEnableLuaAccountSwitch, GetFFlagEnableTextFieldContentType, GetFFlagMinimalSignupAuthEnabled, GetFFlagPasswordlessSignupAuthEnabled, GetFFlagPasskeySignupEnabled, FFlagFoundationStylingOnSignUp, GetFIntLuaLoginGenderSelector, GetFIntLuaAppCredentialsProtocolAvailableTimeout, EngineFeature, v121, v122, v123, v124, v126, FFlagEnableAuthDeepLinkReceiver, GetFFlagEnablePreferredInputForSignUp, FFlagEnableSignUpExitModal, FFlagHideBackButtonOnSignUpPage, v133, v134, GetFFlagEnableAccountSwitcherFoundationDesign, GetFFlagEnableAccountSwitcherRedesignIXP, GetFFlagEnableAccountSwitcherIXPTextGatingFix, GetFFlagAuthCollapsingValidatorFoundationInput, GetFFlagEnableAuditForSinglePageSignUp, FFlagEnableSignupFoundationalizeBackgroundAndText, GetFFlagLuaAppSignupPasskeyAvailabilityPreflight, v142, GetFFlagLuaAppSignUpPageRefactor, BackDisableStore, NavigateBack, v146, SetBackNavigationDisabled, SetCentralOverlay, UsernameValidator, PasswordValidator, ApiFetchAuthMetaData, SignUpV2, OpenAccountSwitchingErrorOverlay, CloseCentralOverlay, ResetAppState, Logout, OpenKISAPopUpAgreements, OpenEmailOtp, UsernameSuggestor, OpenCentralOverlayForAgreeToPhoneNumberVerification, OpenCentralOverlayForPhoneNumberVerification, SetNetworkingErrorToast, SetCurrentToastMessage, v170, reportEphemeralCounter, uDim2, v174, vector2, v177

do
	local Modules = game:GetService("CoreGui").RobloxGui.Modules
	local GuiService, AppStorageService, HttpService, MemStorageService, Images, AccountLinkingAlertType, GetCredentialsAvailabilityStore, KISAComplianceUtils, Events, EventStreamConstants2, LocalStorageKey, MemStorageKeys, Birthday, Constants2, CredentialType, UserGender, SignUpV2ErrorCodes, VerifiedSignupErrorCodes, UsernameIssue, IssueCondition, ExperienceService, Constants3, ArgCheck, Promise, FFlagEnableKoreaKISACompliance, FFlagBypassIXPKoreaCompliance, FFlagBypassGUACKoreaCompliance, v107, v108, FFlagKoreaKISAUnderAgeNumber, GetFFlagCredProtocolRegisterPasswordOnSignup, GetFFlagEnableSignupBirthdayExperiments, FFlagSignupDisplayNameLogging, FFlagEnableVNGDUARSignupCompliance, FFlagUseBirthdayDropdownForGamepad, GetMetaDataFromShareLink, User, AppStorageUtilities, LogoutAllLoggedInUsers, ValidateCode, GetVerifiedSignupChallenge

	do
		local CorePackages = game:GetService("CorePackages")

		UserInputService = game:GetService("UserInputService")
		GuiService = game:GetService("GuiService")
		AppStorageService = game:GetService("AppStorageService")
		HttpService = game:GetService("HttpService")
		MemStorageService = game:GetService("MemStorageService")
		AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
		AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
		RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
		RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
		RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
		Roact = require(CorePackages.Packages.Roact)
		React = require(CorePackages.Packages.React)
		RoactRodux = require(CorePackages.Packages.RoactRodux)
		ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
		RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
		RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
		RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
		Responsive = require(CorePackages.Workspace.Packages.Responsive)
		usePreferredInput = Responsive.usePreferredInput
		useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
		useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
		withLocalization = require(Modules.LuaApp.withLocalization)
		withNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).withNavigationProps

		do
			local UIBlox = require(CorePackages.Packages.UIBlox)

			Button = UIBlox.App.Button.Button
			ButtonType = UIBlox.App.Button.Enum.ButtonType
			Constants = UIBlox.App.Style.Constants
			withStyle = UIBlox.Style.withStyle
			ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
			GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
			Images = UIBlox.App.ImageSet.Images
			ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
		end

		Foundation = require(CorePackages.Packages.Foundation)
		Checkbox = Foundation.Checkbox
		InputSize = Foundation.Enums.InputSize
		View = Foundation.View
		FoundationText = Foundation.Text
		useTokens = Foundation.Hooks.useTokens
		UnderAgeInteractiveAlert = require(Modules.LuaApp.Components.Authentication.UnderAgeInteractiveAlert)
		FitChildren = require(Modules.LuaApp.FitChildren)
		FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
		FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
		AuthBirthdayBar = require(Modules.LuaApp.Components.Authentication.AuthBirthdayBar)
		CollapsingTextInputValidator = require(Modules.LuaApp.Components.Authentication.CollapsingTextInputValidator)
		SignUpGenderSelector = require(Modules.LuaApp.Components.Authentication.SignUpGenderSelector)
		TitleAndParagraph = require(Modules.LuaApp.Components.Authentication.TitleAndParagraph)
		DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
		ContactInfoField = require(Modules.LuaApp.Components.Authentication.ContactInfoField)
		BirthdayField = require(Modules.LuaApp.Components.Authentication.Birthday.BirthdayField)
		SuggestionsFrame = require(Modules.LuaApp.Components.Authentication.SuggestionsFrame)
		SignUpPageView = require(Modules.LuaApp.Components.Authentication.SignUpPageView)
		DisplayNameField = require(Modules.LuaApp.Components.Authentication.DisplayNameField)
		UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider

		do
			local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)

			DisclaimerLinksVariant = AuthCommon.Enums.DisclaimerLinksVariant
			parseCredentialsProtocolIsAvailableResponse = AuthCommon.Utils.parseCredentialsProtocolIsAvailableResponse
			AuditContentContext = AuthCommon.Stores.AuditContentContext.AuditContentContext
			BackgroundFill = AuthCommon.Components.BackgroundFill
			AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
			AuthBackgroundGate = AuthCommon.Components.AuthBackgroundGate
			AccountLinkingAlertType = AuthCommon.Enums.AccountLinkingAlertType
			GetCredentialsAvailabilityStore = AuthCommon.Stores.GetCredentialsAvailabilityStore
			useSignUpPageNavigationBindings = AuthCommon.Hooks.useSignUpPageNavigationBindings
			KISAComplianceUtils = require(CorePackages.Workspace.Packages.AuthCompliance).KISAComplianceUtils
			AnalyticsEvents = require(CorePackages.Workspace.Packages.AuthCompliance).Analytics.AnalyticsEvents
			EventConstants = require(CorePackages.Workspace.Packages.AuthCompliance).Analytics.EventConstants
			TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
			Events = require(CorePackages.Workspace.Packages.AuthAnalytics).Events
			EventStreamConstants2 = require(CorePackages.Workspace.Packages.AuthAnalytics).EventStreamConstants
			PreAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
		end

		LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
		RobloxLocaleIdKey = require(CorePackages.Workspace.Packages.Localization).RobloxLocaleIdKey
		DisplayNameCounters = require(script.Parent.Enum.DisplayNameCounters)
		FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
		OverlayType = require(Modules.LuaApp.Enum.OverlayType)
		MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
		ToastType = require(Modules.LuaApp.Enum.ToastType)
		Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
		DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
		UsernameValidationContext = require(Modules.LuaApp.Enum.UsernameValidationContext)
		EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
		Constants2 = require(Modules.LuaApp.Constants)
		AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
		CredentialType = require(Modules.LuaApp.Components.Authentication.Enum.CredentialType)
		UserGender = require(Modules.LuaApp.Components.Authentication.Enum.UserGender)
		SignUpV2ErrorCodes = require(Modules.LuaApp.Components.Authentication.Enum.SignUpV2ErrorCodes)
		InputValidity = require(Modules.LuaApp.Components.Authentication.Enum.InputValidity)
		VerifiedSignupErrorCodes = require(Modules.LuaApp.Components.Authentication.Enum.VerifiedSignupErrorCodes)
		UsernameIssue = require(Modules.LuaApp.Components.Authentication.Enum.UsernameIssue)
		IssueCondition = require(Modules.LuaApp.Components.Authentication.Enum.IssueCondition)
		default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
		LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
		ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
		Constants3 = require(CorePackages.Workspace.Packages.OtpLogin).Constants
		UserAgreementsCounterNames = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementsCounterNames
		Cryo = require(CorePackages.Packages.Cryo)
		ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
		Promise = require(CorePackages.Packages.Promise)
		FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
		FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore
		FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
		FFlagEnableKoreaKISACompliance = require(Modules.LuaApp.Flags.FFlagEnableKoreaKISACompliance)
		FFlagBypassIXPKoreaCompliance = require(Modules.LuaApp.Flags.FFlagBypassIXPKoreaCompliance)
		FFlagBypassGUACKoreaCompliance = require(Modules.LuaApp.Flags.FFlagBypassGUACKoreaCompliance)
		v107 = game:DefineFastFlag("EnableSkipVPCSignupFlow2", false)
		v108 = game:DefineFastFlag("BypassIXPSkipVPCSignup", false)
		GetFFlagEnableTextFieldContentType = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableTextFieldContentType
		GetFFlagMinimalSignupAuthEnabled = require(Modules.LuaApp.Flags.GetFFlagMinimalSignupAuthEnabled)
		GetFFlagPasswordlessSignupAuthEnabled = require(Modules.LuaApp.Flags.GetFFlagPasswordlessSignupAuthEnabled)
		GetFFlagPasskeySignupEnabled = require(Modules.LuaApp.Flags.GetFFlagPasskeySignupEnabled)
		FFlagFoundationStylingOnSignUp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFoundationStylingOnSignUp
		GetFIntLuaLoginGenderSelector = require(Modules.LuaApp.Flags.GetFIntLuaLoginGenderSelector)
		FFlagKoreaKISAUnderAgeNumber = require(Modules.LuaApp.Flags.FFlagKoreaKISAUnderAgeNumber)
		GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
		GetFFlagCredProtocolRegisterPasswordOnSignup = require(Modules.LuaApp.Flags.GetFFlagCredProtocolRegisterPasswordOnSignup)

		local v118 = game:DefineFastFlag("UsePackageFetchSignupUserAgreements", false)

		EngineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
		GetFFlagEnableSignupBirthdayExperiments = require(Modules.LuaApp.Flags.GetFFlagEnableSignupBirthdayExperiments)
		v121 = game:DefineFastFlag("DisplayNamesOnSignupExperiment_v3", false)
		v122 = game:DefineFastFlag("EnableDisplayNamesOnSignupExperimentv1_Dev", false)
		v123 = game:DefineFastInt("DisplayNameEligabilityAgeYears", 17)
		v124 = game:DefineFastFlag("DisplayNamesDiagLogging", false)
		FFlagSignupDisplayNameLogging = require(Modules.LuaApp.Components.Authentication.Flags.FFlagSignupDisplayNameLogging)
		v126 = game:DefineFastFlag("DisablePasskeySignupForLuaDeepLinks", false)
		FFlagEnableAuthDeepLinkReceiver = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAuthDeepLinkReceiver
		FFlagEnableVNGDUARSignupCompliance = require(Modules.LuaApp.Flags.FFlagEnableVNGDUARSignupCompliance)
		GetFFlagEnablePreferredInputForSignUp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnablePreferredInputForSignUp
		FFlagEnableSignUpExitModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSignUpExitModal
		FFlagHideBackButtonOnSignUpPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagHideBackButtonOnSignUpPage
		FFlagUseBirthdayDropdownForGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBirthdayDropdownForGamepad
		v133 = game:DefineFastFlag("UseBreakpointOnSignUp", false)
		v134 = game:DefineFastFlag("FixSinglePageSignUpScrollPinning", false)
		GetFFlagEnableAccountSwitcherFoundationDesign = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign
		GetFFlagEnableAccountSwitcherRedesignIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherRedesignIXP
		GetFFlagEnableAccountSwitcherIXPTextGatingFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherIXPTextGatingFix
		GetFFlagAuthCollapsingValidatorFoundationInput = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAuthCollapsingValidatorFoundationInput
		GetFFlagEnableAuditForSinglePageSignUp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuditForSinglePageSignUp
		FFlagEnableSignupFoundationalizeBackgroundAndText = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSignupFoundationalizeBackgroundAndText
		GetFFlagLuaAppSignupPasskeyAvailabilityPreflight = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppSignupPasskeyAvailabilityPreflight
		v142 = game:DefineFastFlag("UseLongFormSignupComplianceTextByDefault", false)
		game:DefineFastFlag("LuaVerifiedSignup2", false)
		game:DefineFastFlag("LuaVerifiedSignupExperiment2", false)
		GetFFlagLuaAppSignUpPageRefactor = require(Modules.LuaApp.Flags.GetFFlagLuaAppSignUpPageRefactor)
		BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
		NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
		v146 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
		SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
		SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
		UsernameValidator = require(Modules.LuaApp.Thunks.Authentication.UsernameValidator)
		PasswordValidator = require(Modules.LuaApp.Thunks.Authentication.PasswordValidator)
		GetMetaDataFromShareLink = require(Modules.LuaApp.Thunks.Authentication.AuthIntent.GetMetaDataFromShareLink)
		ApiFetchAuthMetaData = require(Modules.LuaApp.Thunks.Authentication.AuthIntent.ApiFetchAuthMetaData)
		SignUpV2 = require(Modules.LuaApp.Thunks.Authentication.SignUpV2)
		User = require(script.Parent.Parent.Parent.Thunks.Authentication.User)
		AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
		OpenAccountSwitchingErrorOverlay = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSwitchingErrorOverlay)
		CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
		LogoutAllLoggedInUsers = require(Modules.LuaApp.Thunks.Authentication.AccountSwitcher.LogoutAllLoggedInUsers)
		ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
		Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
		OpenKISAPopUpAgreements = require(Modules.LuaApp.Thunks.Authentication.OpenKISAPopUpAgreements)
		OpenEmailOtp = require(Modules.LuaApp.Thunks.Authentication.OpenEmailOtp)
		ValidateCode = require(CorePackages.Workspace.Packages.OtpLogin).Thunks.ValidateCode
		UsernameSuggestor = require(Modules.LuaApp.Thunks.Authentication.UsernameSuggestor)
		OpenCentralOverlayForAgreeToPhoneNumberVerification = require(Modules.LuaApp.Thunks.Authentication.OpenCentralOverlayForAgreeToPhoneNumberVerification)
		OpenCentralOverlayForPhoneNumberVerification = require(Modules.LuaApp.Thunks.Authentication.OpenCentralOverlayForPhoneNumberVerification)
		GetVerifiedSignupChallenge = require(Modules.LuaApp.Thunks.Authentication.GetVerifiedSignupChallenge)
		SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
		SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
		v170 = if not v118 then require(Modules.LuaApp.Http.Requests.FetchSignupUserAgreements) else require(CorePackages.Workspace.Packages.UserAgreements).FetchSignupUserAgreements
	end

	reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)

	local _ = {
		suggestionsShown = "usernameSuggestionsShown",
		suggestableInput = "suggestableUsernameInput",
		refreshButton = "usernameSuggestionRefreshButton"
	}

	uDim2 = UDim2.new(0, 36, 0, 36)
	v174 = Images["icons/navigation/close"]
	vector2 = Vector2.new(540, 1080)

	local function getPasskeysAvailableFromCredentialsProtocolResult(p1) -- line: 243
		-- upvalues: parseCredentialsProtocolIsAvailableResponse (copy)
		local v185 = parseCredentialsProtocolIsAvailableResponse(p1)

		return v185.fido2Available and (v185.fido2SupportsDeviceBoundOnly and v185.fido2SupportsPasskeyCreationOnDevice)
	end

	v177 = Roact.PureComponent:extend("SinglePageSignUp")

	function v177.init(p2) -- line: 368
		-- upvalues: Modules (copy), GetCredentialsAvailabilityStore (copy), InputValidity (copy), UserGender (copy), Roact (copy), FFlagEnableLuaAccountSwitch (copy), User (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), LogoutAllLoggedInUsers (copy), AppStorageService (copy), LocalStorageKey (copy), GuiService (copy), FFlagEnableVNGDUARSignupCompliance (copy), FFlagEnableKoreaKISACompliance (copy), FFlagBypassGUACKoreaCompliance (copy), FFlagBypassIXPKoreaCompliance (copy), v107 (copy), v108 (copy), AnalyticsEvents (copy), EventConstants (copy), KISAComplianceUtils (copy), Cryo (copy), GetFFlagMinimalSignupAuthEnabled (copy), GetFFlagPasswordlessSignupAuthEnabled (copy), GetFFlagEnableSignupBirthdayExperiments (copy), v121 (copy), FFlagUseBirthdayDropdownForGamepad (copy), GetFFlagPasskeySignupEnabled (copy), EventStreamConstants (copy), ArgCheck (copy), Birthday (copy), DateHelper (copy), UsernameIssue (copy), IssueCondition (copy), FFlagSignupDisplayNameLogging (copy), GetVerifiedSignupChallenge (copy), CredentialType (copy), v134 (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), v126 (copy), GetFFlagCredProtocolRegisterPasswordOnSignup (copy), VerifiedSignupErrorCodes (copy), SignUpV2ErrorCodes (copy), Constants2 (copy), AccountLinkingAlertType (copy), GetMetaDataFromShareLink (copy), HttpService (copy), ExperienceService (copy), v124 (copy), reportEphemeralCounter (copy), DisplayNameCounters (copy), UserAgreementsCounterNames (copy), FFlagKoreaKISAUnderAgeNumber (copy), Events (copy), EventStreamConstants2 (copy), v123 (copy), Constants3 (copy), ValidateCode (copy), Promise (copy)
		local GetFFlagLuaAppSignUpRefactorPureLogic = require(Modules.LuaApp.Flags.GetFFlagLuaAppSignUpRefactorPureLogic)
		local buildSignupBirthdayHelpers = require(Modules.LuaApp.Components.Authentication.buildSignupBirthdayHelpers)
		local v189 = GetCredentialsAvailabilityStore(false)
		local v190 = v189.getFido2Available(false)
		local v191 = v189.getPasswordsAvailable(false)

		p2.state = {
			birthday = nil,
			shouldHideBirthdayEntry = false,
			username = "",
			displayName = "",
			password = "",
			birthdayValid = InputValidity.Unvalidated,
			usernameValid = InputValidity.Unvalidated,
			passwordValid = InputValidity.Unvalidated,
			displayNameValid = InputValidity.Unvalidated,
			isSignUpButtonEnabled = false,
			isSignUpInProgress = false,
			gender = UserGender.Unknown,
			onScreenKeyboardHeight = 0,
			isUsernameAnimating = false,
			isPasswordAnimating = false,
			birthdayFocused = false,
			contactMethod = "",
			emailInput = "",
			emailValid = false,
			phoneCountryCode = {},
			phoneInput = "",
			phoneValid = false,
			verifiedSignupVoucher = "",
			isCountryCodeSearchVisible = false,
			hidePassword = nil,
			agreements = {},
			passkeysAvailable = v190,
			isCredentialsProtocolRegisterPasswordAvailable = v191,
			pillClicked = false,
			issueCondition = nil,
			suggestionControlState = nil,
			loadingSuggestions = false,
			signUpError = false,
			shouldShowUnderAgeAlert = false,
			shouldShowVngTosAlert = false,
			showU13AccountSwitcherAlert = false,
			showParentAccountSwitcherAlert = false,
			hasSetIneligibleAgeAtLeastOnce = false,
			recommendedUsername = nil,
			hasEditedUsername = false,
			bypassDisplayNameField = false,
			isUsernameFocused = false,
			otpSessionToken = "",
			otpCode = "",
			signupAgreementsChecked = false
		}
		p2.backButtonRef = Roact.createRef()
		p2.isAlreadyAuthenticated = false

		if FFlagEnableLuaAccountSwitch == true then
			p2.isAlreadyAuthenticated = User.fromLocalStorage().userId ~= -1
		end

		function p2.resetDefaultTheme() -- line: 438
			-- upvalues: AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy)
			local v289 = AppStorageUtilities.getAuthenticatedTheme()

			if v289 ~= "" then
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v289)
			end
		end
		function p2.logoutAllLoggedInUsersCallback() -- line: 446
			-- upvalues: p2 (copy), AppStorageUtilities (copy), User (copy), LogoutAllLoggedInUsers (copy), AppStorageService (copy), LocalStorageKey (copy), GuiService (copy)
			local networking = p2.props.networking
			local v291 = AppStorageUtilities.getAccountBlob()
			local v292 = User.fromLocalStorage().userId ~= -1

			p2:setState({
				signUpError = false,
				isSignUpButtonEnabled = false,
				isSignUpInProgress = false
			})
			LogoutAllLoggedInUsers(networking, v291):await()

			if v292 == true then
				p2.props.resetAppState()
				AppStorageService:SetItem(LocalStorageKey.CredentialValue, "")
				AppStorageService:Flush()
				p2.props.logoutWithoutShowConfirmation(networking, GuiService)
			end

			p2:setState({
				signUpError = false
			})
			p2.props.closeCentralOverlay()
		end
		function p2.closeOverlayAndDisableSwitcherErrors() -- line: 474
			-- upvalues: p2 (copy)
			p2.props.closeCentralOverlay()
		end
		function p2.onCloseButtonClicked() -- line: 478
			-- upvalues: p2 (copy)
			p2.props.navigateBack()
		end
		function p2.getShouldShowVNGAgreements() -- line: 483
			-- upvalues: p2 (copy)
			return p2.props.appPolicy.getUseVNGUserAgreementPopup()
		end
		function p2.getShouldBlockVNGU12SignUpOnClientSide() -- line: 487
			-- upvalues: p2 (copy)
			return p2.props.appPolicy.getBlockVNGU12SignUpOnClientSide()
		end
		function p2.getShouldUseAgeInput() -- line: 491
			-- upvalues: p2 (copy), FFlagEnableVNGDUARSignupCompliance (copy)
			return p2.props.appPolicy.getUseAgeInput() and FFlagEnableVNGDUARSignupCompliance
		end
		function p2.getShouldShowKISAAgreements() -- line: 495
			-- upvalues: FFlagEnableKoreaKISACompliance (copy), p2 (copy), FFlagBypassGUACKoreaCompliance (copy), FFlagBypassIXPKoreaCompliance (copy)
			return FFlagEnableKoreaKISACompliance and ((p2.props.appPolicy.getUseKoreaKISAUserAgreementPopup() or FFlagBypassGUACKoreaCompliance) and (p2.props.shouldShowKoreanKISASignUpFlow or FFlagBypassIXPKoreaCompliance))
		end
		function p2.enableSkipVPCSignupFlow() -- line: 502
			-- upvalues: v107 (copy), p2 (copy), v108 (copy)
			return v107 and (p2.props.shouldSkipVPCSignupFlow or v108)
		end
		function p2.getShouldAddParentalConsentAgreementId() -- line: 506
			-- upvalues: p2 (copy)
			return p2.props.appPolicy.getParentalConsentAgreementId()
		end
		function p2.getSignupCheckboxDisabled() -- line: 510
			-- upvalues: p2 (copy)
			return p2.props.appPolicy.getSignupCheckboxDisabled()
		end
		function p2.launchKISATermsOfService(p3, p4) -- line: 514
			-- upvalues: p2 (copy), AnalyticsEvents (copy), EventConstants (copy), KISAComplianceUtils (copy), Cryo (copy)
			local t1 = {
				agreements = p2.state.agreements,
				onAgreeFunction = function(p5) -- line: 518
					-- upvalues: AnalyticsEvents (copy), EventConstants (copy), KISAComplianceUtils (copy), Cryo (copy), p3 (copy), p2 (copy), p4 (copy)
					AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.kisaAgreements, EventConstants.origin.signup, EventConstants.btn.agree)

					local v488 = KISAComplianceUtils.getAgreedUserAgreements(p5)
					local v489 = Cryo.Dictionary.join(p3, {
						agreementIds = v488
					})
					local v490 = p2.getShouldAddParentalConsentAgreementId()

					if p4 and (v490 and v490 ~= "") then
						table.insert(v489.agreementIds, v490)
					end

					p2.requestSignUp(v489)
				end,
				onAbandonFunction = p2.onAbandonKISASignUpFlow,
				isUnderAgeFlow = p4
			}

			p2.props.openKISAUserAgreements(t1)
		end
		function p2.getIsSignUpButtonEnabled() -- line: 544
			-- upvalues: p2 (copy), GetFFlagMinimalSignupAuthEnabled (copy), GetFFlagPasswordlessSignupAuthEnabled (copy), GetFFlagLuaAppSignUpRefactorPureLogic (copy), Modules (copy), GetFFlagEnableSignupBirthdayExperiments (copy), v121 (copy), FFlagUseBirthdayDropdownForGamepad (copy), GetFFlagPasskeySignupEnabled (copy), InputValidity (copy)
			local birthday = p2.state.birthday
			local username = p2.state.username
			local password = p2.state.password
			local displayName = p2.state.displayName
			local birthdayValid = p2.state.birthdayValid
			local usernameValid = p2.state.usernameValid
			local passwordValid = p2.state.passwordValid
			local displayNameValid = p2.state.displayNameValid
			local validBirthday = p2.state.validBirthday
			local v305 = p2.props.shouldUseMinimalSignup and GetFFlagMinimalSignupAuthEnabled()
			local v306 = p2.props.shouldUsePasswordlessSignup and GetFFlagPasswordlessSignupAuthEnabled()

			if GetFFlagLuaAppSignUpRefactorPureLogic() then
				return require(Modules.LuaApp.Components.Authentication.computeIsSignUpButtonEnabled)({
					birthday = birthday,
					username = username,
					password = password,
					displayName = displayName,
					birthdayValid = birthdayValid,
					usernameValid = usernameValid,
					passwordValid = passwordValid,
					displayNameValid = displayNameValid,
					validBirthday = validBirthday,
					shouldUseMinimalSignup = v305,
					shouldUsePasswordlessSignup = v306,
					shouldUsePasskeySignup = p2.props.shouldUsePasskeySignup,
					passkeysAvailable = p2.state.passkeysAvailable,
					shouldUseAlternateBirthday = GetFFlagEnableSignupBirthdayExperiments() and (p2.props.birthdayPickerVariant and p2.props.birthdayPickerVariant > 0),
					shouldRequireSignupCheckbox = p2.props.shouldRequireSignupCheckbox,
					signupAgreementsChecked = p2.state.signupAgreementsChecked,
					signupCheckboxDisabled = p2.getSignupCheckboxDisabled(),
					displayNamesOnSignupExperimentEnabled = v121,
					isDisplayNameFieldRequired = v121 and p2.isDisplayNameFieldRequired(),
					useBirthdayDropdownForGamepadEnabled = FFlagUseBirthdayDropdownForGamepad,
					passkeySignupEnabled = GetFFlagPasskeySignupEnabled()
				})
			end

			if GetFFlagPasskeySignupEnabled() and p2.props.shouldUsePasskeySignup and not p2.state.passkeysAvailable then
				v306 = false
			end

			local v307 = GetFFlagEnableSignupBirthdayExperiments() and (p2.props.birthdayPickerVariant and p2.props.birthdayPickerVariant > 0)

			if not p2.getSignupCheckboxDisabled() and p2.props.shouldRequireSignupCheckbox and not p2.state.signupAgreementsChecked then
				return false
			end

			local v308 = usernameValid ~= InputValidity.Valid or (passwordValid ~= InputValidity.Valid or not not v307 and birthdayValid ~= InputValidity.Valid) or if not v121 or not p2.isDisplayNameFieldRequired() then nil else displayNameValid ~= InputValidity.Valid

			if FFlagUseBirthdayDropdownForGamepad and birthday and validBirthday == false then
				return false
			end

			if v305 and birthday then
				if v307 and birthdayValid ~= InputValidity.Valid then
					return false
				end

				return true
			end

			if v306 and birthday and username ~= "" and usernameValid == InputValidity.Valid then
				if v307 and birthdayValid ~= InputValidity.Valid then
					return false
				end

				return true
			end

			if not birthday or v308 or username == "" or password == "" or (v121 and (p2.isDisplayNameFieldRequired() and displayName == "") or nil) then
				return false
			end

			if validBirthday == false then
				return false
			end

			return true
		end
		function p2.updateState(p6) -- line: 657
			-- upvalues: p2 (copy)
			spawn(function() -- line: 658
				-- upvalues: p2 (copy), p6 (copy)
				if p2.isMounted then
					p2:setState(p6)
				end
			end)
		end
		function p2.getHidePassword() -- line: 668
			-- upvalues: p2 (copy)
			if p2.state.hidePassword == nil then
				return not p2.props.arePasswordFieldsPlaintext
			end

			return p2.state.hidePassword
		end
		function p2.passwordVisibilityToggleCallback() -- line: 675
			-- upvalues: p2 (copy), EventStreamConstants (copy)
			local v310 = p2.getHidePassword()

			if v310 then
				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.ShowPassword)
			else
				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.HidePassword)
			end

			p2:setState({
				hidePassword = not v310
			})
		end
		function p2.onBirthdaySelected(p7, p8) -- line: 694
			-- upvalues: ArgCheck (copy), Birthday (copy), p2 (copy), EventStreamConstants (copy)
			ArgCheck.assert(Birthday.is(p7), "CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing.")
			p2.updateState({
				birthday = p7,
				validBirthday = p8
			})

			if p2.useVerifiedSignup() then
				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.ConfirmBirthday)
			end

			p2.updateSignUpFieldFilled()
		end
		function p2.onAgeChanged(p9) -- line: 715
			-- upvalues: GetFFlagLuaAppSignUpRefactorPureLogic (copy), p2 (copy), buildSignupBirthdayHelpers (copy), InputValidity (copy), Birthday (copy), DateHelper (copy)
			local num = tonumber(p9)
			local v315 = DateTime.now():ToLocalTime()

			if GetFFlagLuaAppSignUpRefactorPureLogic() then
				p2.updateState(buildSignupBirthdayHelpers.buildBirthdayFromAge(num, v315))

				return
			end

			if num == nil or num < 1 or num > 99 then
				p2.updateState({
					birthday = nil,
					birthdayValid = InputValidity.Invalid
				})

				return
			end

			local v316 = Birthday.new({
				Year = v315.Year - num,
				Month = v315.Month,
				Day = v315.Day
			})

			if v316.Month == 2 and v316.Day == 29 and not DateHelper:isLeapYear(v316.Year) then
				v316.Day = 28
			end

			if DateHelper:isValidDate(v316.Month, v316.Day, v316.Year) then
				p2.updateState({
					birthday = v316,
					birthdayValid = InputValidity.Valid
				})

				return
			end

			p2.updateState({
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			})
		end
		function p2.onAgeAndMonthChanged(p10, p11) -- line: 751
			-- upvalues: GetFFlagLuaAppSignUpRefactorPureLogic (copy), p2 (copy), buildSignupBirthdayHelpers (copy), InputValidity (copy), Birthday (copy), DateHelper (copy)
			local v319 = DateTime.now():ToLocalTime()

			if GetFFlagLuaAppSignUpRefactorPureLogic() then
				p2.updateState(buildSignupBirthdayHelpers.buildBirthdayFromAgeMonth(p10, p11, v319))

				return
			end

			if p10 == nil or p10 < 1 or p10 > 99 then
				p2.updateState({
					birthday = nil,
					birthdayValid = InputValidity.Invalid
				})

				return
			end

			local v320 = v319.Year - p10
			local v321 = Birthday.new({
				Year = v320,
				Month = p11,
				Day = DateHelper:getLastDayOfTheMonthInYear(p11, v320)
			})

			if DateHelper:isValidDate(v321.Month, v321.Day, v321.Year) then
				p2.updateState({
					birthday = v321,
					birthdayValid = InputValidity.Valid
				})

				return
			end

			p2.updateState({
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			})
		end
		function p2.onMonthAndYearChanged(p12, p13) -- line: 784
			-- upvalues: GetFFlagLuaAppSignUpRefactorPureLogic (copy), p2 (copy), buildSignupBirthdayHelpers (copy), InputValidity (copy), Birthday (copy), DateHelper (copy)
			local v324 = DateTime.now():ToLocalTime()

			if GetFFlagLuaAppSignUpRefactorPureLogic() then
				p2.updateState(buildSignupBirthdayHelpers.buildBirthdayFromMonthYear(p12, p13, v324))

				return
			end

			if p13 == nil or p13 < v324.Year - 100 or p13 > v324.Year then
				p2.updateState({
					birthday = nil,
					birthdayValid = InputValidity.Invalid
				})

				return
			end

			local v325 = Birthday.new({
				Year = p13,
				Month = p12,
				Day = DateHelper:getLastDayOfTheMonthInYear(p12, p13)
			})

			if DateHelper:isValidDate(v325.Month, v325.Day, v325.Year) then
				p2.updateState({
					birthday = v325,
					birthdayValid = InputValidity.Valid
				})

				return
			end

			p2.updateState({
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			})
		end

		if GetFFlagLuaAppSignUpRefactorPureLogic() then
			local v192 = require(Modules.LuaApp.Components.Authentication.createUsernameSuggestionHandlers)({
				updateState = p2.updateState,
				getIssueCondition = function() -- line: 820
					-- upvalues: p2 (copy)
					return p2.state.issueCondition
				end,
				getAuthEventAnalytics = function() -- line: 823
					-- upvalues: p2 (copy)
					return p2.props.authEventAnalytics
				end
			})

			p2.usernameSuggestionClicked = v192.usernameSuggestionClicked
			p2.logRefreshButtonClicked = v192.logRefreshButtonClicked
			p2.usernameSuggestionsShown = v192.usernameSuggestionsShown
			p2.logSuggestableUsername = v192.logSuggestableUsername
			p2.shouldSuggest = v192.shouldSuggest
			p2.updatePillClicked = v192.updatePillClicked
			p2.resetPillClicked = v192.resetPillClicked
			p2.updateIssueCondition = v192.updateIssueCondition
			p2.updateSuggestionControlState = v192.updateSuggestionControlState
			p2.loadSuggestions = v192.loadSuggestions
			p2.finishSuggestions = v192.finishSuggestions
		else
			function p2.usernameSuggestionClicked(p14, p15) -- line: 842
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				p2.props.authEventAnalytics.reportUsernameSuggestionClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.UsernameSuggestion, p14, p15)
			end
			function p2.logRefreshButtonClicked() -- line: 851
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, "usernameSuggestionRefreshButton")
			end
			function p2.usernameSuggestionsShown(p16, p17) -- line: 859
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				p2.props.authEventAnalytics.reportInteractWithActionAndSection(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Shown, "usernameSuggestionsShown", p16, p17)
			end
			function p2.logSuggestableUsername(p18) -- line: 870
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				p2.props.authEventAnalytics.reportInteractWithAction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Shown, "suggestableUsernameInput", p18)
			end
			function p2.shouldSuggest() -- line: 880
				-- upvalues: p2 (copy), UsernameIssue (copy), IssueCondition (copy)
				local v331 = false
				local issueCondition = p2.state.issueCondition

				if issueCondition then
					v331 = issueCondition[UsernameIssue.AlreadyInUse] == IssueCondition.Problematic

					for k, v in pairs(issueCondition) do
						if k ~= UsernameIssue.AlreadyInUse and v == IssueCondition.Problematic then
							return false
						end
					end
				end

				return v331
			end
			function p2.updatePillClicked() -- line: 896
				-- upvalues: p2 (copy)
				p2.updateState({
					pillClicked = true
				})
			end
			function p2.resetPillClicked() -- line: 902
				-- upvalues: p2 (copy)
				p2.updateState({
					pillClicked = false
				})
			end
			function p2.updateIssueCondition(p19) -- line: 908
				-- upvalues: p2 (copy)
				p2.updateState({
					issueCondition = p19
				})
			end
			function p2.updateSuggestionControlState(_, p21) -- line: 914
				-- upvalues: p2 (copy)
				p2.updateState({
					suggestionControlState = p21
				})
			end
			function p2.loadSuggestions() -- line: 920
				-- upvalues: p2 (copy)
				p2.updateState({
					loadingSuggestions = true
				})
			end
			function p2.finishSuggestions() -- line: 924
				-- upvalues: p2 (copy)
				p2.updateState({
					loadingSuggestions = false
				})
			end
		end

		function p2.onBirthdayFocused(p22) -- line: 930
			-- upvalues: p2 (copy)
			if p2.isMounted then
				p2:setState({
					birthdayFocused = p22
				})
			end
		end
		function p2.onUsernameTextChanged(p23, p24) -- line: 938
			-- upvalues: v121 (copy), p2 (copy)
			local v341 = nil

			if v121 and (p2.shouldShowDisplayNameField() and not p2.state.hasEditedUsername) then
				v341 = p23 ~= p2.state.recommendedUsername
			end

			p2.updateState({
				username = p23,
				usernameValid = p24,
				hasEditedUsername = if not v121 then nil else v341
			})

			if p2.shouldSuggest() then
				p2.logSuggestableUsername(p23)
			end

			p2.updateSignUpFieldFilled()
		end
		function p2.updateSignUpFieldFilled() -- line: 960
			-- upvalues: p2 (copy)
			if p2.props.signUpStarted == nil then
				return
			end

			local v342 = false

			if p2.state.username ~= "" or p2.state.password ~= "" or p2.state.birthday ~= nil then
				v342 = true
			end

			if v342 ~= p2.state.signUpStarted then
				p2.props.setSignUpStarted(v342)
			end
		end
		function p2.onDisplayNameTextChanged(p25, p26) -- line: 975
			-- upvalues: p2 (copy)
			p2.updateState({
				displayName = p25,
				displayNameValid = p26
			})
		end
		function p2.updateBypassDisplayNameField(b1: boolean) -- line: 982
			-- upvalues: p2 (copy)
			p2:setState({
				bypassDisplayNameField = b1
			})
		end
		function p2.onUsernameTextValidated(p27, p28) -- line: 988
			-- upvalues: p2 (copy), InputValidity (copy), EventStreamConstants (copy)
			p2.onUsernameTextChanged(p27, p28)

			if p28 == InputValidity.Valid then
				p2.props.authEventAnalytics.reportInteractWithAction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Submit, p28, p27)
			end
		end
		function p2.onPasswordTextChanged(p29, p30) -- line: 1001
			-- upvalues: p2 (copy)
			p2.updateState({
				password = p29,
				passwordValid = p30
			})
			p2.updateSignUpFieldFilled()
		end

		p2.cachedScrollCanvasPositionY = 0
		p2.cachedScrollCanvasInitialSizeY = 0

		local v193, v194 = Roact.createBinding(0)

		p2.scrollCanvasTargetPositionY = v193
		p2.updateScrollCanvasTargetPositionY = v194
		p2.scrollingFrameRef = Roact.createRef()
		p2.ageTextFieldRef = Roact.createRef()
		p2.usernameTextFieldRef = Roact.createRef()
		p2.displayNameTextFieldRef = if not v121 then nil else Roact.createRef()
		p2.passwordTextFieldRef = Roact.createRef()
		p2.passwordFrameRef = Roact.createRef()

		function p2.onDisplayNameTextChangeCompletedFromKeyboard() -- line: 1022
			-- upvalues: p2 (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy)
			task.spawn(function() -- line: 1023
				-- upvalues: p2 (copy), FFlagSignupDisplayNameLogging (copy), EventStreamConstants (copy)
				if p2.displayNameTextFieldRef.current then
					p2.displayNameTextFieldRef.current:ReleaseFocus()
				end

				task.defer(function() -- line: 1028
					-- upvalues: p2 (copy)
					if p2.usernameTextFieldRef.current then
						p2.usernameTextFieldRef.current:CaptureFocus()
					end
				end)

				if FFlagSignupDisplayNameLogging then
					p2.props.authEventAnalytics.reportAuthButtonClick(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.DisplayNameNext, EventStreamConstants.State.KeyboardInput)
				end
			end)
		end
		function p2.onUsernameTextChangeCompletedFromKeyboard() -- line: 1044
			-- upvalues: p2 (copy), EventStreamConstants (copy)
			spawn(function() -- line: 1045
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				if p2.usernameTextFieldRef.current then
					p2.usernameTextFieldRef.current:ReleaseFocus()
				end

				if p2.passwordTextFieldRef.current then
					p2.passwordTextFieldRef.current:CaptureFocus()
				end

				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.UsernameNext)
			end)
		end
		function p2.onPasswordTextChangeCompletedFromKeyboard() -- line: 1060
			-- upvalues: p2 (copy), EventStreamConstants (copy)
			spawn(function() -- line: 1061
				-- upvalues: p2 (copy), EventStreamConstants (copy)
				if p2.passwordTextFieldRef.current then
					p2.passwordTextFieldRef.current:ReleaseFocus()
				end

				p2.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.PasswordNext)
			end)
		end
		function p2.cacheScrollCanvasInitialSizeIfNecessary() -- line: 1076
			-- upvalues: p2 (copy)
			if p2.cachedScrollCanvasInitialSizeY == 0 then
				local currentParent = p2.scrollingFrameRef.current.Parent
				local CanvasSize = p2.scrollingFrameRef.current.CanvasSize
				local v352 = currentParent and currentParent.AbsoluteSize or Vector2.new(0, 0)

				p2.cachedScrollCanvasInitialSizeY = CanvasSize.Y.Scale * v352.Y + CanvasSize.Y.Offset
			end
		end
		function p2.agreeToPhoneNumberVerification() -- line: 1086
			-- upvalues: p2 (copy), GetVerifiedSignupChallenge (copy)
			local agreeToPhoneNumberVerification = p2.props.agreeToPhoneNumberVerification
			local networking = p2.props.networking
			local v355 = p2.state.phoneCountryCode.prefix .. "," .. p2.state.phoneInput .. "," .. p2.state.phoneCountryCode.code

			agreeToPhoneNumberVerification(networking, function() -- line: 1095
				-- upvalues: GetVerifiedSignupChallenge (copy), networking (copy), v355 (copy), p2 (copy)
				GetVerifiedSignupChallenge(networking, v355):andThen(function(p31) -- line: 1096
					-- upvalues: p2 (copy), v355 (copy)
					local challenge = p31.challenge

					p2.verifyPhoneNumber(challenge, p2.state.phoneInput, v355)
				end, function(p32) -- line: 1099
					-- upvalues: p2 (copy)
					if p32 == "Authentication.TwoStepVerification.Response.TooManyAttempts" or (p32 == "Authentication.SignUp.Response.PhoneNumberAlreadyLinked" or p32 == "Authentication.SignUp.Response.InvalidPhoneNumber") then
						p2.props.showErrorMessageToast(p32)

						return
					end

					p2.props.showErrorToast()
				end)
			end, p2.state.phoneInput)
		end
		function p2.onSignUpClick() -- line: 1115
			-- upvalues: p2 (copy), CredentialType (copy)
			if p2.useVerifiedSignup() and p2.state.contactMethod == CredentialType.PhoneNumber then
				p2.agreeToPhoneNumberVerification()

				return
			end

			p2.onSignUpButtonActivated()
		end
		function p2.verifyPhoneNumber(p33, p34, p35) -- line: 1123
			-- upvalues: p2 (copy)
			p2.props.verifyPhoneNumber(p2.props.networking, p2.verifyPhoneNumberCallback, p33, p34, p35, p2.useEmailOptionClickedCallback)
		end
		function p2.verifyPhoneNumberCallback(p36) -- line: 1138
			-- upvalues: p2 (copy)
			p2.verifiedSignupVoucher = p36
			p2.onSignUpButtonActivated()
		end
		function p2.useEmailOptionClickedCallback() -- line: 1143
			-- upvalues: p2 (copy), CredentialType (copy)
			p2:setState({
				contactMethod = CredentialType.Email
			})
		end
		function p2.phoneCountryCodeSelectorCallback(p37) -- line: 1149
			-- upvalues: p2 (copy)
			p2:setState({
				isCountryCodeSearchVisible = p37
			})
		end
		function p2.onTextBoxFocused(vector2_2: Vector2) -- line: 1158
			-- upvalues: p2 (copy), v134 (copy)
			p2.cacheScrollCanvasInitialSizeIfNecessary()

			local v362 = math.clamp(p2.scrollingFrameRef.current.CanvasPosition.Y, 0, p2.cachedScrollCanvasInitialSizeY)

			if p2.isMounted then
				local v363 = vector2_2.Y - p2.scrollingFrameRef.current.absolutePosition.Y + v362

				p2.updateScrollCanvasTargetPositionY(v363)

				if v134 then
					task.defer(function() -- line: 1167
						-- upvalues: p2 (copy)
						if p2.isMounted then
							p2.updateScrollCanvasTargetPositionY(0)
						end
					end)
				end
			end
		end
		function p2.onTextBoxFocusLost() -- line: 1176
			-- upvalues: p2 (copy)
			if p2.isMounted then
				p2.updateScrollCanvasTargetPositionY(0)
			end
		end
		function p2.onUsernameTextBoxFocusLost() -- line: 1182
			-- upvalues: p2 (copy)
			p2.onTextBoxFocusLost()
			p2.updateState({
				isUsernameFocused = false
			})
		end
		function p2.onAnimationStateChangeCallback(p38, p39) -- line: 1192
			-- upvalues: p2 (copy)
			if p38 == Enum.TextInputType.Password then
				p2:setState({
					isPasswordAnimating = p39
				})

				return
			end

			p2:setState({
				isUsernameAnimating = p39
			})
		end
		function p2.onFocusedTextBoxPositionChanged(p40) -- line: 1206
			-- upvalues: p2 (copy)
			if p2.state.isUsernameAnimating or p2.state.isPasswordAnimating then
				p2.onTextBoxFocused(p40)
			end
		end
		function p2.getScrollingFrameCanvasPosition(p41) -- line: 1215
			-- upvalues: p2 (copy)
			if p41 > 0 then
				return Vector2.new(0, p41)
			end

			if p2.scrollingFrameRef and p2.scrollingFrameRef.current then
				return p2.scrollingFrameRef.current.CanvasPosition
			end

			return Vector2.new(0, 0)
		end
		function p2.onUsernameTextBoxFocused(p42) -- line: 1227
			-- upvalues: p2 (copy), EventStreamConstants (copy)
			p2:setState({
				isUsernameFocused = true
			})
			p2.props.authEventAnalytics.reportUsernameFocus(EventStreamConstants.Context.SinglePageSignUpScreen)
			p2.onTextBoxFocused(p42)
		end
		function p2.onDisplayNameTextBoxFocused(p43) -- line: 1237
			-- upvalues: FFlagSignupDisplayNameLogging (copy), p2 (copy), EventStreamConstants (copy)
			if FFlagSignupDisplayNameLogging then
				p2.props.authEventAnalytics.reportDisplayNameFocus(EventStreamConstants.Context.SinglePageSignUpScreen)
			end

			p2.onTextBoxFocused(p43)
		end
		function p2.onPasswordTextBoxFocused(p44) -- line: 1245
			-- upvalues: p2 (copy), EventStreamConstants (copy)
			p2.props.authEventAnalytics.reportPasswordFocus(EventStreamConstants.Context.SinglePageSignUpScreen)
			p2.onTextBoxFocused(p44)
		end
		function p2.updateIsSignUpInProgress(p45) -- line: 1251
			-- upvalues: p2 (copy)
			spawn(function() -- line: 1252
				-- upvalues: p2 (copy), p45 (copy)
				if p2.isMounted then
					p2:setState({
						isSignUpInProgress = p45
					})
				end
			end)
		end
		function p2.requestSignUp(p46, p47) -- line: 1261
			-- upvalues: p2 (copy), CredentialType (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), v126 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagCredProtocolRegisterPasswordOnSignup (copy), VerifiedSignupErrorCodes (copy), SignUpV2ErrorCodes (copy), FFlagEnableLuaAccountSwitch (copy), Constants2 (copy), AccountLinkingAlertType (copy)
			local networking = p2.props.networking
			local guiService = p2.props.guiService
			local analytics = p2.props.analytics
			local appPolicy = p2.props.appPolicy
			local omniRecommendationsRequest = p2.props.omniRecommendationsRequest
			local authEventAnalytics = p2.props.authEventAnalytics
			local signUp = p2.props.signUp
			local setBackNavigationDisabled = p2.props.setBackNavigationDisabled
			local v382 = p2.useVerifiedSignup() and p2.state.contactMethod == CredentialType.PhoneNumber
			local v383 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()
			local v384 = v126 and (v383 ~= nil and v383 ~= "")
			local v385 = not p2.state.passkeysAvailable or v384
			local v386 = GetFFlagPasskeySignupEnabled()

			signUp(networking, omniRecommendationsRequest, guiService, function(p48, p49) -- line: 1272
				-- upvalues: setBackNavigationDisabled (copy), p2 (copy), p46 (copy)
				if p48 then
					setBackNavigationDisabled(true)
					p2.requestSignUp(p46, p49)

					return
				end

				p2.updateIsSignUpInProgress(false)
			end, p47, analytics, appPolicy, p46, v382, p2.props.shouldUsePasskeySignup and (v386 and (game:GetEngineFeature("SignupActionRequiredKeyAvailable") and not v385)), p2.props.shouldAutomaticallyPromptForPasskey, GetFFlagCredProtocolRegisterPasswordOnSignup() and p2.state.isCredentialsProtocolRegisterPasswordAvailable, authEventAnalytics, p2.props.isIosAuthServiceEnabled):andThen(function() -- line: 1326
				-- upvalues: setBackNavigationDisabled (copy)
				setBackNavigationDisabled(false)
			end, function(p50) -- line: 1330
				-- upvalues: setBackNavigationDisabled (copy), v382 (copy), VerifiedSignupErrorCodes (copy), p2 (copy), SignUpV2ErrorCodes (copy), FFlagEnableLuaAccountSwitch (copy), Constants2 (copy), AccountLinkingAlertType (copy)
				setBackNavigationDisabled(false)

				if v382 then
					if p50 ~= VerifiedSignupErrorCodes.Captcha then
						p2.updateIsSignUpInProgress(false)
						p2:setState({
							signUpError = true
						})
					end
				else
					if p50 ~= SignUpV2ErrorCodes.Captcha then
						p2.updateIsSignUpInProgress(false)
						p2:setState({
							signUpError = true
						})
					end

					if p50 == SignUpV2ErrorCodes.VNGAgeUnder12 then
						p2:setState({
							shouldShowUnderAgeAlert = true
						})
					end

					if FFlagEnableLuaAccountSwitch == true and p50 == SignUpV2ErrorCodes.EmptyAccountSwitchBlobRequired then
						p2.props.openAccountSwitchingErrorOverlay(not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts", not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Description.LogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers", not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue", "Authentication.CrossDevice.Action.CancelLogin", p2.logoutAllLoggedInUsersCallback, p2.props.closeCentralOverlay, Constants2.Auth.AccountSwitcherSignupEmptyBlobRequiredError, p2.state.username)
						p2:setState({
							signUpError = false
						})
					end

					if FFlagEnableLuaAccountSwitch == true and p50 == SignUpV2ErrorCodes.ParentEmptyAccountSwitchBlobRequired then
						p2.props.openAccountSwitchingErrorOverlay(not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts", not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Description.ParentLogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers", not p2.props.showAccountSwitcherFoundationDesign and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue", "Authentication.CrossDevice.Action.CancelLogin", p2.logoutAllLoggedInUsersCallback, p2.props.closeCentralOverlay, Constants2.Auth.AccountSwitcherParentSignupEmptyBlobRequiredError, p2.state.username)
						p2:setState({
							signUpError = false
						})
					end
				end

				if p50 == SignUpV2ErrorCodes.AccountLinkingRequired then
					p2.props.showAccountLinkingAlert(AccountLinkingAlertType.RetryLogInAlreadyLinked)

					return
				end

				if p50 == SignUpV2ErrorCodes.AccountLinkingFailed then
					p2.props.showAccountLinkingAlert(AccountLinkingAlertType.RetryLogInGenericError)
				end
			end)
		end
		function p2.onSignUpButtonActivated() -- line: 1416
			-- upvalues: p2 (copy), EventStreamConstants (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), GetMetaDataFromShareLink (copy), HttpService (copy), ExperienceService (copy), v124 (copy), reportEphemeralCounter (copy), DisplayNameCounters (copy), v121 (copy), CredentialType (copy), UserAgreementsCounterNames (copy), FFlagKoreaKISAUnderAgeNumber (copy), Events (copy), EventStreamConstants2 (copy)
			local setBackNavigationDisabled = p2.props.setBackNavigationDisabled
			local birthday = p2.state.birthday
			local username = p2.state.username
			local password = p2.state.password
			local gender = p2.state.gender
			local v392 = p2.getIsSignUpButtonEnabled()
			local locale = p2.locale
			local emailInput = p2.state.emailInput

			if v392 then
				p2.props.authEventAnalytics.reportSignUpButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen)

				if p2.getShouldBlockVNGU12SignUpOnClientSide() then
					local v395 = p2.getUserAge()

					if v395 == nil or v395 < 12 then
						p2:setState({
							shouldShowUnderAgeAlert = true
						})

						return
					end
				end

				local v396 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()
				local s1 = ""

				if v396 and string.find(v396, "share") then
					local v398, v399, v400 = v396:match("code=(.-)&type=(.-)&stamp=(.*)")

					if not v400 then
						v398, v399 = v396:match("code=(.-)&type=(.*)")
					end

					if v398 and v399 then
						GetMetaDataFromShareLink(p2.props.networking, v398, v399):andThen(function(p51) -- line: 1462
							-- upvalues: s1 (ref), HttpService (copy)
							if p51 and p51 ~= nil then
								s1 = HttpService:JSONEncode(p51)
							end
						end, function(p52) -- line: 1466
							warn("Error fetching share link metadata: ", p52)
						end):await()
					end
				else
					local PendingJoinAttempt = ExperienceService:GetPendingJoinAttempt()

					if PendingJoinAttempt and PendingJoinAttempt ~= nil then
						s1 = HttpService:JSONEncode(PendingJoinAttempt)
					end
				end

				p2.props.authEventAnalytics.reportAuthButtonClick(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.SignUp, s1, v396, p2.isAltAttempt)

				if v124 and p2.props.shouldSeeDisplayNamesOnSignup then
					if username == p2.state.recommendedUsername then
						reportEphemeralCounter(DisplayNameCounters.SignUpWithRecommendedUsernames, 1)
					elseif p2.state.hasEditedUsername then
						reportEphemeralCounter(DisplayNameCounters.SignUpWithEditedUsernames, 1)
					end

					if p2.state.bypassDisplayNameField then
						reportEphemeralCounter(DisplayNameCounters.SignupBypassingDisplayNames, 1)
					end
				end

				p2.updateIsSignUpInProgress(true)
				setBackNavigationDisabled(true)
				p2:setState({
					signUpError = false
				})

				local t2 = {
					birthday = birthday and birthday:FormatForEndpoint() or "",
					username = username,
					password = password,
					displayName = if not v121 or not p2.isDisplayNameFieldRequired() then nil else p2.state.displayName,
					gender = gender,
					locale = locale,
					capturedAuditContent = p2.props.capturedAuditContent,
					additionalAuditContent = p2.props.additionalAuditContent
				}
				local v403 = p2.useVerifiedSignup()

				if v403 and p2.state.contactMethod == CredentialType.Email then
					t2.email = emailInput
				elseif v403 and p2.state.contactMethod == CredentialType.PhoneNumber then
					t2.verifiedSignupVoucher = p2.verifiedSignupVoucher
				end

				if p2.props.appPolicy.getAddUserAgreementIdsToSignupRequest() then
					local agreements = p2.state.agreements

					if #agreements > 0 then
						local t3 = {}

						for _, v in ipairs(agreements) do
							table.insert(t3, v.id)
						end

						t2.agreementIds = t3
					else
						reportEphemeralCounter(UserAgreementsCounterNames.AgreementsIdsEmptyOnSignup, 1)
					end
				end

				if p2.getShouldShowVNGAgreements() then
					p2.props.showVNGUserAgreementsPopup(p2.state.agreements, function(p53) -- line: 1536
						-- upvalues: t2 (copy), p2 (copy)
						local v501 = t2
						local t4 = {}

						for _, v in ipairs(p53) do
							table.insert(t4, v.id)
						end

						v501.agreementIds = t4
						p2.requestSignUp(t2)
					end, function() -- line: 1539
						-- upvalues: p2 (copy), setBackNavigationDisabled (copy)
						p2.updateIsSignUpInProgress(false)
						setBackNavigationDisabled(false)
					end)
				elseif p2.getShouldShowKISAAgreements() then
					local v408 = p2.getUserAge()

					if v408 and v408 < FFlagKoreaKISAUnderAgeNumber then
						if p2.enableSkipVPCSignupFlow() then
							Events.authPageload(EventStreamConstants2.Context.KISAU14Signup, EventStreamConstants2.State.SkipVPC)
							p2.requestSignUp(t2)
						else
							Events.authPageload(EventStreamConstants2.Context.KISAU14Signup, EventStreamConstants2.State.LaunchParentSignUpOtp)
							p2.launchParentSignUpOtp(t2)
						end
					else
						p2.launchKISATermsOfService(t2, false)
					end
				else
					p2.requestSignUp(t2)
				end
			end
		end
		function p2.onGenderChanged(p54) -- line: 1571
			-- upvalues: p2 (copy)
			if p2.isMounted then
				p2.updateState({
					gender = p54
				})
			end
		end
		function p2.validUsernameEntered(_) -- line: 1579
			-- upvalues: p2 (copy), InputValidity (copy)
			return p2.state.username ~= "" and p2.state.usernameValid ~= InputValidity.Invalid
		end
		function p2.validPasswordEntered() -- line: 1583
			-- upvalues: p2 (copy), InputValidity (copy)
			return p2.state.password ~= "" and p2.state.passwordValid ~= InputValidity.Invalid
		end
		function p2.useVerifiedSignup() -- line: 1587
			-- upvalues: p2 (copy), GuiService (copy)
			return game:GetFastFlag("LuaVerifiedSignup2") or game:GetFastFlag("LuaVerifiedSignupExperiment2") and (p2.props.useVerifiedSignupPage and not GuiService:IsTenFootInterface())
		end
		function p2.useUsernameSuggestions() -- line: 1594
			-- upvalues: p2 (copy)
			return p2.props.shouldUseUsernameSuggestions
		end
		function p2.useRefreshButton() -- line: 1598
			-- upvalues: p2 (copy)
			return p2.props.enableRefreshButton
		end
		function p2.getBirthdayVariant() -- line: 1602
			-- upvalues: p2 (copy), GetFFlagEnableSignupBirthdayExperiments (copy)
			if p2.getShouldUseAgeInput() then
				return 1
			end

			if GetFFlagEnableSignupBirthdayExperiments() and p2.props.birthdayPickerVariant ~= nil then
				return p2.props.birthdayPickerVariant
			end

			return 0
		end
		function p2.SetContactMethod(p56) -- line: 1612
			-- upvalues: p2 (copy)
			p2.updateState({
				contactMethod = p56
			})
		end
		function p2.SetPhoneNumber(p57, p58, p59) -- line: 1618
			-- upvalues: p2 (copy)
			p2.updateState({
				phoneCountryCode = p57,
				phoneInput = p58,
				phoneValid = p59
			})
		end
		function p2.SetEmail(p60, p61) -- line: 1626
			-- upvalues: p2 (copy)
			p2.updateState({
				emailInput = p60,
				emailValid = p61
			})
		end
		function p2.onSignUpContentFrameCanvasSizeChange(_) -- line: 1633
			-- upvalues: p2 (copy)
			local v418 = p2.scrollCanvasTargetPositionY:getValue()

			p2.scrollingFrameRef.current.CanvasPosition = p2.getScrollingFrameCanvasPosition(v418)
		end
		function p2.getUserAge() -- line: 1639
			-- upvalues: p2 (copy)
			if p2.state.birthday then
				return p2.state.birthday:GetAgeInYears()
			end

			return nil
		end
		function p2.getUsernamePlaceholder(t5: {[any]: any}) -- line: 1647
			-- upvalues: p2 (copy), v123 (copy)
			if p2.props.shouldSeeDisplayNamesOnSignup then
				if not p2.state.birthday then
					return ""
				end

				if p2.getUserAge() >= v123 and not p2.state.hasSetIneligibleAgeAtLeastOnce then
					return t5.agedUpUsernamePlaceholder
				end

				return t5.usernamePlaceholder
			end

			return t5.usernamePlaceholder
		end
		function p2.shouldShowUsernameField() -- line: 1671
			-- upvalues: p2 (copy), v123 (copy)
			if p2.props.shouldSeeDisplayNamesOnSignup then
				if not p2.state.birthday or p2.getUserAge() < v123 or p2.state.hasSetIneligibleAgeAtLeastOnce then
					return true
				end

				return p2.state.recommendedUsername ~= nil
			end

			return true
		end
		function p2.shouldShowDisplayNameField() -- line: 1687
			-- upvalues: p2 (copy), v123 (copy)
			return p2.props.shouldSeeDisplayNamesOnSignup and (p2.state.birthday and (p2.getUserAge() >= v123 and not p2.state.hasSetIneligibleAgeAtLeastOnce))
		end
		function p2.isDisplayNameFieldRequired() -- line: 1694
			-- upvalues: p2 (copy)
			return p2.shouldShowDisplayNameField() and not p2.state.bypassDisplayNameField
		end
		function p2.isValidDisplayNameEntered() -- line: 1698
			-- upvalues: p2 (copy), InputValidity (copy)
			return p2.state.displayName ~= "" and p2.state.displayNameValid ~= InputValidity.Invalid
		end
		function p2.setUsernameRecommendation(s2: string) -- line: 1702
			-- upvalues: p2 (copy)
			p2:setState(function(p63) -- line: 1703
				-- upvalues: s2 (copy)
				return {
					recommendedUsername = if p63.recommendedUsername == nil or s2 ~= "" then s2 else nil
				}
			end)
		end
		function p2.getUsernameGuidanceText(t6: {[any]: any}) -- line: 1713
			-- upvalues: p2 (copy)
			if p2.shouldShowDisplayNameField() and (p2.state.recommendedUsername ~= "" and p2.state.recommendedUsername ~= nil and not p2.state.hasEditedUsername and not p2.state.isUsernameFocused) then
				return t6.autogeneratedUsernameGuidance
			end

			return nil
		end
		function p2.validateOtpCode(p64, p65, p66) -- line: 1726
			-- upvalues: p2 (copy), Constants3 (copy), ValidateCode (copy), Promise (copy)
			p2.state.otpSessionToken = p64
			p2.state.otpCode = p65

			local networking = p2.props.networking
			local t7 = {
				origin = Constants3.otpServiceOriginSignup,
				contactType = Constants3.otpServiceContactType,
				passCode = p2.state.otpCode,
				otpSessionToken = p2.state.otpSessionToken
			}
			local t8 = {
				otpSessionToken = tostring(p2.state.otpSessionToken),
				otpContactType = Constants3.otpServiceContactType
			}

			return ValidateCode(networking, t7)():andThen(function(_) -- line: 1746
				-- upvalues: p2 (copy), p66 (copy), t8 (copy)
				p2.props.closeCentralOverlay()
				p66.otpSession = t8
				p2.launchKISATermsOfService(p66, true)
			end):catch(function(p68) -- line: 1751
				-- upvalues: Promise (copy)
				return Promise.reject(p68)
			end)
		end
		function p2.onAbandonKISASignUpFlow() -- line: 1756
			-- upvalues: AnalyticsEvents (copy), EventConstants (copy), p2 (copy)
			AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.kisaAgreements, EventConstants.origin.signup, EventConstants.btn.cancel)
			p2.updateIsSignUpInProgress(false)
		end
		function p2.launchParentSignUpOtp(p69) -- line: 1766
			-- upvalues: Constants3 (copy), p2 (copy)
			local t9 = {
				codeLength = 6,
				origin = Constants3.otpServiceOriginSignup,
				enterEmailTitleKey = Constants3.translationKeys.parentEmailTitleKey,
				enterEmailDescriptionKey = Constants3.translationKeys.sendParentVerificationCodeKey,
				enterCodeTitleKey = Constants3.translationKeys.oneTimeCodeTitleKey,
				enterCodeDescriptionKey = Constants3.translationKeys.oneTimeCodeHelpDescriptionKey,
				complianceCheckboxMessageKey = Constants3.translationKeys.parentalConsentModalDescriptionKey,
				onSubmitCode = function(p70, p71) -- line: 1777
					-- upvalues: p2 (copy), p69 (copy)
					return p2.validateOtpCode(p70, p71, p69)
				end,
				onModalAbandoned = p2.onAbandonKISASignUpFlow,
				screenSize = p2.props.screenSize
			}

			p2.props.openEmailOtp(t9)
		end

		p2.isMounted = false
	end
end

function v177.didMount(p72) -- line: 1791
	-- upvalues: default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), GetFFlagLuaAppSignupPasskeyAvailabilityPreflight (copy), parseCredentialsProtocolIsAvailableResponse (copy), EventStreamConstants (copy), UserInputService (copy), reportEphemeralCounter (copy), UserAgreementsCounterNames (copy), v170 (copy), TelemetryConfigs (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), ApiFetchAuthMetaData (copy)
	p72.isMounted = true
	p72.isAltAttempt = nil
	default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p73) -- line: 1797
		-- upvalues: GetFFlagLuaAppSignupPasskeyAvailabilityPreflight (copy), p72 (copy), parseCredentialsProtocolIsAvailableResponse (copy), EventStreamConstants (copy)
		local v432

		if GetFFlagLuaAppSignupPasskeyAvailabilityPreflight() and p72.props.shouldTightenPasskeyEligibility and p73.FIDO2 ~= nil then
			local v431 = parseCredentialsProtocolIsAvailableResponse(p73)

			v432 = v431.fido2Available and (v431.fido2SupportsDeviceBoundOnly and v431.fido2SupportsPasskeyCreationOnDevice)
		else
			v432 = p73.isAvailable or false
		end

		local v433 = false

		if p73.password and p73.password.isAvailable then
			v433 = true
		end

		if p72.isMounted then
			p72:setState({
				passkeysAvailable = v432,
				isCredentialsProtocolRegisterPasswordAvailable = v433
			})
		end

		p72.props.authEventAnalytics.reportAuthPageload(EventStreamConstants.Context.PasskeySignup, (tostring(v432)))
		p72.props.authEventAnalytics.reportAuthPageload(EventStreamConstants.Context.CMPasswordSignup, (tostring(v433)))
	end):catch(function(p74) -- line: 1826
		warn("Error checking for available credential types. Error: ", p74)
	end)
	p72.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 1831
		-- upvalues: UserInputService (copy), p72 (copy)
		local v435 = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		p72:setState({
			onScreenKeyboardHeight = v435
		})
	end)

	local v196 = p72.props.appPolicy.getAddUserAgreementIdsToSignupRequest()
	local v197 = p72.getShouldShowVNGAgreements()
	local v198 = p72.getShouldShowKISAAgreements()

	if v196 or (v197 or v198) then
		v170(p72.props.networking, p72.props.analytics):andThen(function(p75) -- line: 1844
			-- upvalues: reportEphemeralCounter (copy), UserAgreementsCounterNames (copy), p72 (copy)
			if not p75 then
				reportEphemeralCounter(UserAgreementsCounterNames.FetchAgreementsHttpRequestFailureOnSignup, 1)

				return
			end

			if #p75 > 0 then
				p72.updateState({
					agreements = p75
				})

				return
			end

			reportEphemeralCounter(UserAgreementsCounterNames.FetchAgreementsEmptyResponseOnSignup, 1)
		end, function() -- line: 1861
		end)
	end

	p72.props.authEventAnalytics.reportScreenLoaded(EventStreamConstants.Context.SinglePageSignUpScreen)
	p72.props.loggingProtocol:logEventOnce("signup_page_did_mount")
	p72.props.loggingProtocol:logRobloxTelemetryCounter(TelemetryConfigs.SignupPageMountTelemetryConfig, 1, {
		version = 1
	})

	local v199 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()

	ApiFetchAuthMetaData(p72.props.networking):andThen(function(p76) -- line: 1877
		-- upvalues: p72 (copy), EventStreamConstants (copy), v199 (copy)
		if p76 and p76.IsAltBrowserTracker ~= nil then
			p72.isAltAttempt = p76.IsAltBrowserTracker
			p72.props.authEventAnalytics.reportAuthPageload(EventStreamConstants.Context.SinglePageSignUpScreen, v199, p72.isAltAttempt)
		end
	end, function(_) -- line: 1886
		-- upvalues: p72 (copy), EventStreamConstants (copy), v199 (copy)
		warn("Error auth metadata: ", error)
		p72.props.authEventAnalytics.reportAuthPageload(EventStreamConstants.Context.SinglePageSignUpScreen, v199, p72.isAltAttempt)
	end)

	if p72.props.focusedGuiObject and p72.backButtonRef and p72.backButtonRef.current then
		p72.props.focusGuiObject(p72.backButtonRef.current)
	end
end
function v177.willUnmount(p78) -- line: 1900
	-- upvalues: FFlagEnableLuaAccountSwitch (copy)
	p78.isMounted = false
	p78.isAltAttempt = nil

	if FFlagEnableLuaAccountSwitch == true and p78.isAlreadyAuthenticated == true then
		p78.resetDefaultTheme()
	end

	if p78.keyboardVisibleChanged then
		p78.keyboardVisibleChanged:disconnect()
		p78.keyboardVisibleChanged = nil
	end
end
function v177.didUpdate(p79, p80, p81) -- line: 1914
	-- upvalues: v134 (copy), v121 (copy), v123 (copy), v124 (copy), reportEphemeralCounter (copy), DisplayNameCounters (copy)
	if v134 then
		local focusedGuiObject = p79.props.focusedGuiObject
		local birthdayContainerRef = p79.props.birthdayContainerRef
		local v206 = focusedGuiObject and (birthdayContainerRef and (birthdayContainerRef.current and focusedGuiObject:IsDescendantOf(birthdayContainerRef.current)))
		local focusedGuiObject2 = p80.focusedGuiObject
		local birthdayContainerRef2 = p80.birthdayContainerRef
		local v209 = focusedGuiObject2 and (birthdayContainerRef2 and (birthdayContainerRef2.current and focusedGuiObject2:IsDescendantOf(birthdayContainerRef2.current)))

		if v206 and not v209 then
			p79.updateScrollCanvasTargetPositionY(10)
			task.defer(function() -- line: 1936
				-- upvalues: p79 (copy)
				if p79.isMounted then
					p79.updateScrollCanvasTargetPositionY(0)
				end
			end)
		end
	elseif p79.props.focusedGuiObject and p79.props.birthdayContainerRef.current and p79.props.focusedGuiObject:IsDescendantOf(p79.props.birthdayContainerRef.current) then
		p79.updateScrollCanvasTargetPositionY(10)
	else
		p79.updateScrollCanvasTargetPositionY(0)
	end

	if v121 and p79.state.birthday ~= nil and not p79.state.hasSetIneligibleAgeAtLeastOnce and p79.getUserAge() < v123 then
		p79:setState({
			hasSetIneligibleAgeAtLeastOnce = true
		})
	end

	if v124 and p79.props.shouldSeeDisplayNamesOnSignup then
		if p79.state.recommendedUsername ~= "" and p79.state.hasEditedUsername and p79.state.hasEditedUsername ~= p81.hasEditedUsername then
			reportEphemeralCounter(DisplayNameCounters.ReccomendedNameEdited, 1)
		end

		if p79.state.recommendedUsername ~= nil and p79.state.recommendedUsername ~= "" and p79.state.hasEditedUsername == true and p79.state.username == "" and p81.username ~= "" and p79.props.shouldSeeDisplayNamesOnSignup then
			reportEphemeralCounter(DisplayNameCounters.ReccomendedNameManuallyCleared, 1)
		end

		if p79.state.birthday ~= nil and p81.birthday ~= nil and p79.state.birthday ~= p81.birthday then
			if p79.getUserAge() >= v123 and p81.birthday:GetAgeInYears() < v123 then
				reportEphemeralCounter(DisplayNameCounters.BirthdayChangedToAboveDisplayAge, 1)
			end

			if p79.getUserAge() < v123 and p81.birthday:GetAgeInYears() >= v123 then
				reportEphemeralCounter(DisplayNameCounters.BirthdayChangedToAboveDisplayAge, 1)
			end
		end
	end
end
function v177.render(p82) -- line: 2003
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), Roact (copy), UiModeStyleProvider (copy), Constants (copy), GetFFlagLuaAppSignUpPageRefactor (copy)
	if FFlagEnableLuaAccountSwitch and p82.isAlreadyAuthenticated then
		return Roact.createElement(UiModeStyleProvider, {
			style = {
				themeName = Constants.ThemeName.Dark,
				fontName = Constants.FontName.Gotham
			}
		}, {
			Child = if not GetFFlagLuaAppSignUpPageRefactor() then p82:renderDeprecated() else p82:renderWithView()
		})
	end

	if GetFFlagLuaAppSignUpPageRefactor() then
		return p82:renderWithView()
	end

	return p82:renderDeprecated()
end
function v177.renderWithView(p83) -- line: 2022
	-- upvalues: withLocalization (copy), RobloxLocaleIdKey (copy), Roact (copy), SignUpPageView (copy), UsernameValidator (copy), PasswordValidator (copy)
	local v212 = p83.getIsSignUpButtonEnabled()

	return withLocalization({})(function(p84) -- line: 2025
		-- upvalues: p83 (copy), RobloxLocaleIdKey (copy), Roact (copy), SignUpPageView (copy), v212 (copy), UsernameValidator (copy), PasswordValidator (copy)
		p83.locale = p84[RobloxLocaleIdKey]

		return Roact.createElement(SignUpPageView, {
			navigateBack = p83.props.navigateBack,
			useVerifiedSignup = p83.useVerifiedSignup,
			useUsernameSuggestions = p83.useUsernameSuggestions,
			useRefreshButton = p83.useRefreshButton,
			onGenderChanged = p83.onGenderChanged,
			getHidePassword = p83.getHidePassword,
			passwordVisibilityToggleCallback = p83.passwordVisibilityToggleCallback,
			onBirthdaySelected = p83.onBirthdaySelected,
			onBirthdayFocused = p83.onBirthdayFocused,
			onSignUpClick = p83.onSignUpClick,
			usernameSuggestionClicked = p83.usernameSuggestionClicked,
			usernameSuggestionsShown = p83.usernameSuggestionsShown,
			shouldSuggest = p83.shouldSuggest,
			updateIssueCondition = p83.updateIssueCondition,
			updateSuggestionControlState = p83.updateSuggestionControlState,
			logRefreshButtonClicked = p83.logRefreshButtonClicked,
			loadSuggestions = p83.loadSuggestions,
			finishSuggestions = p83.finishSuggestions,
			validUsernameEntered = p83.validUsernameEntered,
			validPasswordEntered = p83.validPasswordEntered,
			onUsernameTextBoxFocused = p83.onUsernameTextBoxFocused,
			onPasswordTextBoxFocused = p83.onPasswordTextBoxFocused,
			onUsernameTextChanged = p83.onUsernameTextChanged,
			onUsernameTextValidated = p83.onUsernameTextValidated,
			onPasswordTextChanged = p83.onPasswordTextChanged,
			onTextBoxFocusLost = p83.onTextBoxFocusLost,
			onFocusedTextBoxPositionChanged = p83.onFocusedTextBoxPositionChanged,
			onAnimationStateChangeCallback = p83.onAnimationStateChangeCallback,
			onUsernameTextChangeCompletedFromKeyboard = p83.onUsernameTextChangeCompletedFromKeyboard,
			onPasswordTextChangeCompletedFromKeyboard = p83.onPasswordTextChangeCompletedFromKeyboard,
			phoneCountryCodeSelectorCallback = p83.phoneCountryCodeSelectorCallback,
			SetContactMethod = p83.SetContactMethod,
			SetPhoneNumber = p83.SetPhoneNumber,
			SetEmail = p83.SetEmail,
			isUsernameAnimating = p83.state.isUsernameAnimating,
			isPasswordAnimating = p83.state.isPasswordAnimating,
			birthday = p83.state.birthday,
			username = p83.state.username,
			isSignUpInProgress = p83.state.isSignUpInProgress,
			onScreenKeyboardHeight = p83.state.onScreenKeyboardHeight,
			usernameValid = p83.state.usernameValid,
			passwordValid = p83.state.passwordValid,
			issueCondition = p83.state.issueCondition,
			loadingSuggestions = p83.state.loadingSuggestions,
			isSignUpButtonEnabled = v212,
			birthdayFocused = p83.state.birthdayFocused,
			isCountryCodeSearchVisible = p83.state.isCountryCodeSearchVisible,
			contactMethod = p83.state.contactMethod,
			signUpError = p83.state.signUpError,
			UsernameValidator = UsernameValidator,
			PasswordValidator = PasswordValidator,
			signUpContentFrameRef = p83.scrollingFrameRef,
			ageTextFieldRef = p83.ageTextFieldRef,
			usernameTextFieldRef = p83.usernameTextFieldRef,
			passwordTextFieldRef = p83.passwordTextFieldRef,
			passwordFrameRef = p83.passwordFrameRef,
			onSignUpContentFrameCanvasSizeChange = p83.onSignUpContentFrameCanvasSizeChange,
			scrollCanvasTargetPositionY = p83.scrollCanvasTargetPositionY,
			updateScrollCanvasTargetPositionY = p83.updateScrollCanvasTargetPositionY,
			getScrollingFrameCanvasPosition = p83.getScrollingFrameCanvasPosition
		})
	end)
end
function v177.renderDeprecated(p85) -- line: 2111
	-- upvalues: FormFactor (copy), GetFFlagEnableTextFieldContentType (copy), FFlagFoundationStylingOnSignUp (copy), v121 (copy), DisclaimerLinksVariant (copy), GetFFlagMinimalSignupAuthEnabled (copy), GetFFlagPasswordlessSignupAuthEnabled (copy), FFlagEnableAuthDeepLinkReceiver (copy), PreAuthDeepLinkUrlStore (copy), LinkingProtocol (copy), v126 (copy), GetFFlagPasskeySignupEnabled (copy), v174 (copy), withStyle (copy), withLocalization (copy), RobloxLocaleIdKey (copy), v142 (copy), Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), UnderAgeInteractiveAlert (copy), ImageSetLabel (copy), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), FoundationText (copy), FitTextLabel (copy), FitChildren (copy), v134 (copy), AuthBirthdayBar (copy), FFlagEnableLuaAccountSwitch (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), BirthdayField (copy), InputValidity (copy), ContactInfoField (copy), DateHelper (copy), React (copy), DisplayNameField (copy), CollapsingTextInputValidator (copy), UsernameValidator (copy), UsernameValidationContext (copy), SuggestionsFrame (copy), UsernameSuggestor (copy), EngineFeature (copy), PasswordValidator (copy), GetFIntLuaLoginGenderSelector (copy), SignUpGenderSelector (copy), Foundation (copy), Button (copy), ButtonType (copy), View (copy), Checkbox (copy), EventStreamConstants (copy), InputSize (copy), TitleAndParagraph (copy), DisclaimerLinks (copy)
	local birthday = p85.state.birthday
	local username = p85.state.username
	local v216 = p85.getIsSignUpButtonEnabled()
	local isSignUpInProgress = p85.state.isSignUpInProgress
	local gender = p85.state.gender
	local v219 = p85.props.formFactor == FormFactor.WIDE
	local isCompactView = p85.props.isCompactView
	local n1 = 0
	local n2 = 0
	local v223 = p85.state.onScreenKeyboardHeight > 0
	local contactMethod = p85.state.contactMethod
	local foundationTokens = p85.props.foundationTokens
	local shouldUseFoundationBackgroundColor = p85.props.shouldUseFoundationBackgroundColor
	local shouldUseFoundationUsernameTextInput = p85.props.shouldUseFoundationUsernameTextInput
	local v228 = GetFFlagEnableTextFieldContentType() and Enum.TextInputType.Username or Enum.TextInputType.NoSuggestions
	local u229 = not p85.validUsernameEntered()
	local v230 = p85.useVerifiedSignup()
	local v231 = (not v219 or not v230) and 0 or 12
	local s3 = "Authentication.SignUp.Label.ErrorsWithUsername"
	local s4 = "Authentication.SignUp.Label.ErrorsWithPassword"
	local v234 = p85.useUsernameSuggestions()
	local v235 = p85.useRefreshButton()
	local v236 = FFlagFoundationStylingOnSignUp and isCompactView

	if not birthday then
		s3 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
		s4 = s3
		u229 = true
	elseif v121 and p85.isDisplayNameFieldRequired() and not p85.isValidDisplayNameEntered() then
		u229 = true
		s4 = "Authentication.SignUp.Response.AgedUpDisplayNameSetFirst"
	elseif u229 then
		s4 = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
	end

	if v219 then
		if v223 then
			n1 = p85.state.onScreenKeyboardHeight + 10
		else
			n1 = 48
			n2 = 24
		end
	end

	local Default = nil

	if v236 then
		Default = DisclaimerLinksVariant.Default
	end

	local v238 = GetFFlagMinimalSignupAuthEnabled()
	local v239 = p85.props.shouldUseMinimalSignup and v238
	local v240 = p85.props.shouldHideGenderOption and v238
	local v241 = p85.props.shouldAutofocusOnBirthday and v238
	local v242 = GetFFlagPasswordlessSignupAuthEnabled()
	local u243 = p85.props.shouldUsePasswordlessSignup and v242
	local v244 = p85.getShouldShowVNGAgreements()
	local v245 = p85.getShouldShowKISAAgreements()
	local v246 = if not FFlagEnableAuthDeepLinkReceiver then LinkingProtocol:getLastLuaURL() else PreAuthDeepLinkUrlStore.getUrl()
	local v247 = v126 and (v246 ~= nil and v246 ~= "")
	local v248 = not p85.state.passkeysAvailable or v247

	if GetFFlagPasskeySignupEnabled() and p85.props.shouldUsePasskeySignup and v248 then
		u243 = false
	end

	local shouldDisableUsernameAutofill = p85.props.shouldDisableUsernameAutofill
	local v250 = GetFFlagPasskeySignupEnabled()
	local v251 = p85.props.shouldUsePasskeySignup and (v250 and (game:GetEngineFeature("SignupActionRequiredKeyAvailable") and not v248))
	local v252 = v174

	local function getVerificationLinkingText(p86) -- line: 2209
		-- upvalues: p85 (copy)
		local t10 = nil
		local v442 = p85.props.appPolicy.getPlatformAccountName()

		if v442 and p85.props.appPolicy.getUseSingleSignOn() then
			t10 = {
				"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
				platform = v442,
				ctaButton = p86
			}
		end

		return t10
	end

	return withStyle(function(t11: {[any]: any}) -- line: 2222
		-- upvalues: withLocalization (copy), v121 (copy), p85 (copy), RobloxLocaleIdKey (copy), v239 (copy), v219 (copy), v236 (copy), foundationTokens (copy), v142 (copy), v251 (copy), Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), shouldUseFoundationBackgroundColor (copy), BackgroundFill (copy), isSignUpInProgress (copy), UnderAgeInteractiveAlert (copy), ImageSetLabel (copy), n1 (ref), n2 (ref), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v252 (copy), FoundationText (copy), FitTextLabel (copy), FitChildren (copy), v231 (copy), v134 (copy), AuthBirthdayBar (copy), v230 (copy), v241 (copy), FFlagEnableLuaAccountSwitch (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), BirthdayField (copy), InputValidity (copy), ContactInfoField (copy), birthday (copy), DateHelper (copy), contactMethod (copy), React (copy), DisplayNameField (copy), CollapsingTextInputValidator (copy), s3 (ref), shouldDisableUsernameAutofill (copy), v228 (copy), v234 (copy), UsernameValidator (copy), UsernameValidationContext (copy), shouldUseFoundationUsernameTextInput (copy), SuggestionsFrame (copy), UsernameSuggestor (copy), v235 (copy), u243 (ref), s4 (ref), u229 (ref), EngineFeature (copy), PasswordValidator (copy), username (copy), v240 (copy), GetFIntLuaLoginGenderSelector (copy), SignUpGenderSelector (copy), gender (copy), Foundation (copy), v216 (copy), Button (copy), ButtonType (copy), View (copy), Checkbox (copy), EventStreamConstants (copy), InputSize (copy), v244 (copy), v245 (copy), TitleAndParagraph (copy), DisclaimerLinks (copy), FFlagFoundationStylingOnSignUp (copy), Default (ref), v223 (copy)
		return withLocalization({
			signUpText = "Authentication.SignUp.Action.CreateAccount",
			continueText = "Authentication.SignUp.Action.Continue",
			usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
			agedUpUsernamePlaceholder = "Authentication.Login.Label.AgedUpUsername",
			passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
			usernameHelperTitleText = "Authentication.SignUp.Heading.PickAUsername",
			usernameHelperDescriptionText = "Authentication.SignUp.Description.UsernameHelp",
			signUpAgreementFullCopyCheckboxText = "Authentication.SignUp.Description.AgreeToTermsWithGuardian.NoParameters",
			signUpAgreementShortCopyCheckboxText = "Authentication.SignUp.Description.SignUpAgreement.ShortCopy",
			autogeneratedUsernameGuidance = if not v121 then nil else "Feature.DisplayName.Label.GeneratedUserName"
		})(function(p87) -- line: 2236
			-- upvalues: p85 (copy), RobloxLocaleIdKey (copy), v239 (copy), v219 (copy), v236 (copy), foundationTokens (copy), v121 (copy), v142 (copy), v251 (copy), Roact (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), shouldUseFoundationBackgroundColor (copy), t11 (copy), BackgroundFill (copy), isSignUpInProgress (copy), UnderAgeInteractiveAlert (copy), ImageSetLabel (copy), n1 (ref), n2 (ref), GetImageData (copy), vector2 (copy), ImageSetButton (copy), uDim2 (copy), v252 (copy), FoundationText (copy), FitTextLabel (copy), FitChildren (copy), v231 (copy), v134 (copy), AuthBirthdayBar (copy), v230 (copy), v241 (copy), FFlagEnableLuaAccountSwitch (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), BirthdayField (copy), InputValidity (copy), ContactInfoField (copy), birthday (copy), DateHelper (copy), contactMethod (copy), React (copy), DisplayNameField (copy), CollapsingTextInputValidator (copy), s3 (ref), shouldDisableUsernameAutofill (copy), v228 (copy), v234 (copy), UsernameValidator (copy), UsernameValidationContext (copy), shouldUseFoundationUsernameTextInput (copy), SuggestionsFrame (copy), UsernameSuggestor (copy), v235 (copy), u243 (ref), s4 (ref), u229 (ref), EngineFeature (copy), PasswordValidator (copy), username (copy), v240 (copy), GetFIntLuaLoginGenderSelector (copy), SignUpGenderSelector (copy), gender (copy), Foundation (copy), v216 (copy), Button (copy), ButtonType (copy), View (copy), Checkbox (copy), EventStreamConstants (copy), InputSize (copy), v244 (copy), v245 (copy), TitleAndParagraph (copy), DisclaimerLinks (copy), FFlagFoundationStylingOnSignUp (copy), Default (ref), v223 (copy)
			p85.locale = p87[RobloxLocaleIdKey]

			local v511 = not v239
			local v512 = not v219 and 48 or 25
			local uDim2_2 = UDim2.new(0.5, 0, 0, 49)

			if v236 then
				v512 += foundationTokens.Padding.Medium
				uDim2_2 = UDim2.new(0.5, 0, 0, 1 + foundationTokens.Padding.Medium)
			end

			if v121 then
				v511 = p85.shouldShowUsernameField() and not v239
			end

			local v514 = not p85.getSignupCheckboxDisabled() and p85.props.shouldRequireSignupCheckbox
			local v515 = not v142 and "Authentication.SignUp.Description.VerificationPage.CreateAccount" or "Authentication.SignUp.Description.SignUpAgreement.FullCopy.CreateAccount"

			if v251 then
				v515 = "Authentication.SignUp.Description.VerificationPageMultiStep"
			else
				local signUpText = p87.signUpText
				local t12 = nil
				local v518 = p85.props.appPolicy.getPlatformAccountName()

				if v518 and p85.props.appPolicy.getUseSingleSignOn() then
					t12 = {
						"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
						platform = v518,
						ctaButton = signUpText
					}
				end

				if t12 then
					local signUpText2 = p87.signUpText

					v515 = nil

					local v520 = p85.props.appPolicy.getPlatformAccountName()

					if v520 and p85.props.appPolicy.getUseSingleSignOn() then
						v515 = {
							"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
							platform = v520,
							ctaButton = signUpText2
						}
					end
				end
			end

			local s5 = ""

			if not p85.getSignupCheckboxDisabled() then
				if p85.props.signupLegalDisclaimerTextVariant == 1 then
					if v514 then
						s5 = p87.signUpAgreementFullCopyCheckboxText
					else
						v515 = not v251 and "Authentication.SignUp.Description.SignupAgreement.FullCopy.CreateAccount" or "Authentication.SignUp.Description.SignUpAgreement.FullCopy.Continue"
					end
				elseif p85.props.signupLegalDisclaimerTextVariant == 2 and v514 then
					s5 = p87.signUpAgreementShortCopyCheckboxText
				end
			end

			local v522 = p85.props.shouldShowBackButton == nil or p85.props.shouldShowBackButton

			return Roact.createElement(FullscreenPageWithSafeArea, {
				BackgroundTransparency = 1,
				includeStatusBar = true,
				buttonRef = p85.props.containerRef,
				renderFullscreenBackground = function() -- line: 2296
					-- upvalues: Roact (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), v219 (copy), shouldUseFoundationBackgroundColor (copy), foundationTokens (copy), t11 (copy), BackgroundFill (copy)
					return Roact.createElement(AuthBackgroundGate, {
						renderTreatment = function() -- line: 2298
							-- upvalues: Roact (copy), AuthBackgroundContainer (copy), v219 (copy), shouldUseFoundationBackgroundColor (copy), foundationTokens (copy), t11 (copy)
							return Roact.createElement(AuthBackgroundContainer, {
								showImage = v219,
								fallbackBackgroundColor = if not shouldUseFoundationBackgroundColor then t11.Theme.BackgroundUIDefault.Color else foundationTokens.Color.Surface.Surface_0.Color3
							})
						end,
						renderLegacy = function() -- line: 2306
							-- upvalues: Roact (copy), v219 (copy), shouldUseFoundationBackgroundColor (copy), foundationTokens (copy), t11 (copy), BackgroundFill (copy)
							return Roact.createElement("Frame", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = not v219 and 0 or 1,
								BackgroundColor3 = if not shouldUseFoundationBackgroundColor then t11.Theme.BackgroundUIDefault.Color else foundationTokens.Color.Surface.Surface_0.Color3
							}, {
								Background = v219 and Roact.createElement(BackgroundFill, {
									Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg"
								}),
								Mask = v219 and Roact.createElement("ImageLabel", {
									ZIndex = 2,
									BackgroundTransparency = 0.5,
									Size = UDim2.new(1, 0, 1, 0),
									BackgroundColor3 = Color3.new(0, 0, 0)
								})
							})
						end
					})
				end
			}, {
				UserInputSink = isSignUpInProgress and Roact.createElement("ImageButton", {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Image = "",
					Size = UDim2.new(1, 0, 1, 0)
				}),
				UnderAgeAlert = p85.state.shouldShowUnderAgeAlert and Roact.createElement(UnderAgeInteractiveAlert, {
					ZIndex = 3,
					onDismiss = function() -- line: 2337
						-- upvalues: p85 (copy)
						p85:setState({
							shouldShowUnderAgeAlert = false
						})
					end
				}),
				Container = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 1, -n1),
					Position = UDim2.new(0.5, 0, 0, n2),
					AnchorPoint = Vector2.new(0.5, 0),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = if not shouldUseFoundationBackgroundColor then t11.Theme.BackgroundUIDefault.Color else foundationTokens.Color.Surface.Surface_0.Color3
				}, {
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = vector2
					}),
					HeaderFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 48),
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0)
					}, {
						BackButton = v522 and Roact.createElement(ImageSetButton, {
							Size = uDim2,
							AutoButtonColor = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 12, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ScaleType = Enum.ScaleType.Fit,
							Image = v252,
							ImageColor3 = t11.Theme.UIEmphasis.Color,
							ImageTransparency = 0,
							[Roact.Event.Activated] = p85.onCloseButtonClicked,
							[Roact.Ref] = p85.backButtonRef
						}),
						Title = p87.signUpText and if not v236 then Roact.createElement(FitTextLabel, {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							fitAxis = FitChildren.FitAxis.Height,
							Text = p87.signUpText or "",
							Font = t11.Font.CaptionHeader.Font,
							TextSize = t11.Font.BaseSize * t11.Font.Header1.RelativeSize,
							TextColor3 = t11.Theme.TextEmphasis.Color,
							TextTransparency = t11.Theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Center
						}) else Roact.createElement(FoundationText, {
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Text = p87.signUpText or "",
							fontStyle = foundationTokens.Typography.HeadingSmall,
							TextXAlignment = Enum.TextXAlignment.Center
						})
					}),
					Divider = not v236 and Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0.5, 0, 0, 48),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = not shouldUseFoundationBackgroundColor and 0 or 1,
						BackgroundColor3 = t11.Theme.UIEmphasis.Color
					}),
					SignUpContentFrame = Roact.createElement(FitChildren.FitScrollingFrame, {
						Size = UDim2.new(1, 0, 1, -(49 + v231)),
						Position = uDim2_2,
						AnchorPoint = Vector2.new(0.5, 0),
						fitFields = {
							CanvasSize = FitChildren.FitAxis.Height
						},
						ScrollBarThickness = 0,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Selectable = false,
						ScrollingEnabled = not not v134 or not (p85.state.isUsernameAnimating or p85.state.isPasswordAnimating),
						CanvasPosition = p85.scrollCanvasTargetPositionY:map(function(p88) -- line: 2429
							-- upvalues: p85 (copy)
							return p85.getScrollingFrameCanvasPosition(p88)
						end),
						[Roact.Ref] = p85.scrollingFrameRef,
						[Roact.Change.CanvasSize] = function(_) -- line: 2433
							-- upvalues: p85 (copy)
							local v528 = p85.scrollCanvasTargetPositionY:getValue()

							p85.scrollingFrameRef.current.CanvasPosition = p85.getScrollingFrameCanvasPosition(v528)
						end
					}, {
						ContentPadding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 24),
							PaddingRight = UDim.new(0, 24),
							PaddingTop = UDim.new(0, v512)
						}),
						ListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 5)
						}),
						BirthdayBar = p85.getBirthdayVariant() == 0 and Roact.createElement(AuthBirthdayBar, {
							layoutOrder = 1,
							onBirthdaySelected = p85.onBirthdaySelected,
							onBirthdayFocused = p85.onBirthdayFocused,
							autoFocusOnMount = v230 or v241,
							buttonRef = p85.props.defaultRef,
							preferredInput = p85.props.preferredInput,
							birthdayContainerRef = p85.props.birthdayContainerRef,
							forceDarkTheme = FFlagEnableLuaAccountSwitch and p85.isAlreadyAuthenticated,
							enableAuditContentCapture = GetFFlagEnableAuditForSinglePageSignUp()
						}),
						AgeInput = p85.getBirthdayVariant() ~= 0 and Roact.createElement(BirthdayField, {
							layoutOrder = 1,
							textInputHeight = 36,
							variant = p85.getBirthdayVariant(),
							hasBirthdayError = p85.state.birthdayValid == InputValidity.Invalid,
							onAgeChange = p85.onAgeChanged,
							onAgeAndMonthChange = p85.onAgeAndMonthChanged,
							onMonthAndYearChange = p85.onMonthAndYearChanged,
							ageTextFieldRef = p85.ageTextFieldRef,
							screenSize = p85.props.screenSize
						}),
						ContactInfoField = v230 and Roact.createElement(ContactInfoField, {
							layoutOrder = 2,
							Under13 = birthday and DateHelper:isRecentOrFutureDate(birthday.Month, birthday.Day, birthday.Year + 13),
							SetContactMethod = p85.SetContactMethod,
							SetPhoneNumber = p85.SetPhoneNumber,
							SetEmail = p85.SetEmail,
							contactMethod = contactMethod,
							phoneCountryCodeSelectorCallback = p85.phoneCountryCodeSelectorCallback
						}),
						BackgroundPanel = v230 and Roact.createElement("Frame", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 0, 0, 6)
						}, {
							LightPanel = Roact.createElement("Frame", {
								BorderSizePixel = 0,
								Size = UDim2.new(0, 100000, 0, 100000),
								Position = UDim2.new(0, 0, 1, 0),
								BackgroundColor3 = t11.Theme.UIDefault.Color,
								AnchorPoint = Vector2.new(0.5, 0)
							})
						}),
						DisplayName = if not v121 or not p85.shouldShowDisplayNameField() then nil else React.createElement(DisplayNameField, {
							layoutOrder = 4,
							authEventAnalytics = p85.props.authEventAnalytics,
							birthday = not birthday and "" or birthday:FormatForEndpoint(),
							bypassDisplayNameField = p85.state.bypassDisplayNameField,
							focusedTextBoxPositionChangedCallback = p85.onFocusedTextBoxPositionChanged,
							onAnimationStateChangeCallback = p85.onAnimationStateChangeCallback,
							onDisplayNameTextChanged = p85.onDisplayNameTextChanged,
							onReturnPressedFromOnScreenKeyboard = p85.onDisplayNameTextChangeCompletedFromKeyboard,
							pillClicked = p85.state.pillClicked,
							resetPillClicked = p85.resetPillClicked,
							returnKeyType = Enum.ReturnKeyType.Next,
							setUsernameRecommendation = p85.setUsernameRecommendation,
							shouldDisableRecommendation = p85.state.hasEditedUsername,
							textBoxFocusedCallback = p85.onDisplayNameTextBoxFocused,
							textBoxFocusLostCallback = p85.onTextBoxFocusLost,
							textBoxRef = p85.displayNameTextFieldRef,
							updateBypassDisplayNameField = p85.updateBypassDisplayNameField,
							updatePillClicked = p85.updatePillClicked
						}),
						UsernameValidator = v511 and Roact.createElement(CollapsingTextInputValidator, {
							titleTextKey = "Authentication.Login.Label.Username",
							layoutOrder = not v121 and 4 or 5,
							summaryErrorTextKey = s3,
							prerequisiteMet = not not birthday,
							textInputType = if not shouldDisableUsernameAutofill then v228 else nil,
							onInputTextChanged = p85.onUsernameTextChanged,
							onInputTextValidated = v234 and p85.onUsernameTextValidated or p85.onUsernameTextChanged,
							validator = UsernameValidator,
							prefilledText = if not v121 then nil else p85.state.recommendedUsername,
							placeholderText = if not v121 then p87.usernamePlaceholder else p85.getUsernamePlaceholder(p87),
							validatorAdditionalProps = {
								birthday = birthday and birthday:FormatForEndpoint() or "",
								context = UsernameValidationContext.Signup
							},
							textBoxFocusedCallback = p85.onUsernameTextBoxFocused,
							textBoxFocusLostCallback = if not v121 then p85.onTextBoxFocusLost else p85.onUsernameTextBoxFocusLost,
							focusedTextBoxPositionChangedCallback = p85.onFocusedTextBoxPositionChanged,
							returnKeyType = Enum.ReturnKeyType.Next,
							onReturnPressedFromOnScreenKeyboard = p85.onUsernameTextChangeCompletedFromKeyboard,
							onAnimationStateChangeCallback = p85.onAnimationStateChangeCallback,
							textBoxRef = p85.usernameTextFieldRef,
							pillClicked = p85.state.pillClicked,
							updatePillClicked = p85.updatePillClicked,
							resetPillClicked = p85.resetPillClicked,
							issueCondition = p85.state.issueCondition,
							updateIssueCondition = p85.updateIssueCondition,
							loadingSuggestions = p85.state.loadingSuggestions,
							paddingBottomOverride = if not v121 or (not p85.props.shouldSeeDisplayNamesOnSignup or not p85.getUsernameGuidanceText(p87)) then nil else -5,
							enableAuditContentCapture = GetFFlagEnableAuditForSinglePageSignUp(),
							useFoundationTextInput = not not shouldUseFoundationUsernameTextInput or nil
						}),
						UsernameGuidanceText = if not v121 or (not p85.props.shouldSeeDisplayNamesOnSignup or not p85.getUsernameGuidanceText(p87)) then nil else Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 5,
							Size = UDim2.new(1, 0, 0, 1),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							Padding = Roact.createElement("UIPadding", {
								PaddingBottom = UDim.new(0, 5)
							}),
							Label = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								AutomaticSize = Enum.AutomaticSize.Y,
								Font = t11.Font.CaptionBody.Font,
								Size = UDim2.new(1, 0, 0, 0),
								Text = p85.getUsernameGuidanceText(p87),
								TextColor3 = t11.Theme.TextDefault.Color,
								TextSize = t11.Font.BaseSize * t11.Font.CaptionBody.RelativeSize,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top
							})
						}),
						SuggestionsFrame = v511 and (v234 and Roact.createElement(SuggestionsFrame, {
							layoutOrder = not v121 and 4 or 5,
							textBoxRef = p85.usernameTextFieldRef,
							usernameValid = p85.state.usernameValid,
							birthday = birthday and birthday:FormatForEndpoint() or "",
							suggest = UsernameSuggestor,
							context = UsernameValidationContext.Signup,
							pillClicked = p85.state.pillClicked,
							updatePillClicked = p85.updatePillClicked,
							resetPillClicked = p85.resetPillClicked,
							issueCondition = p85.state.issueCondition,
							usernameSuggestionClicked = p85.usernameSuggestionClicked,
							usernameSuggestionsShown = p85.usernameSuggestionsShown,
							shouldSuggest = p85.shouldSuggest,
							updateSuggestionControlState = p85.updateSuggestionControlState,
							useRefreshButton = v235,
							logRefreshButtonClicked = p85.logRefreshButtonClicked,
							loadSuggestions = p85.loadSuggestions,
							finishSuggestions = p85.finishSuggestions,
							loadingSuggestions = p85.state.loadingSuggestions,
							padding = {
								PaddingLeft = UDim.new(0, 24),
								PaddingRight = UDim.new(0, 24)
							}
						})),
						PasswordValidator = not v239 and (not u243 and Roact.createElement(CollapsingTextInputValidator, {
							titleTextKey = "CommonUI.Messages.Label.Password",
							disabled = p85.state.birthdayFocused,
							layoutOrder = not v121 and 5 or 6,
							summaryErrorTextKey = s4,
							prerequisiteMet = not u229,
							textInputType = EngineFeature and Enum.TextInputType.NewPassword or Enum.TextInputType.Password,
							onInputTextChanged = p85.onPasswordTextChanged,
							onInputTextValidated = p85.onPasswordTextChanged,
							validator = PasswordValidator,
							placeholderText = p87.passwordPlaceholder,
							validatorAdditionalProps = {
								username = username
							},
							returnKeyType = Enum.ReturnKeyType.Next,
							textBoxFocusedCallback = p85.onPasswordTextBoxFocused,
							textBoxFocusLostCallback = p85.onTextBoxFocusLost,
							focusedTextBoxPositionChangedCallback = p85.onFocusedTextBoxPositionChanged,
							onReturnPressedFromOnScreenKeyboard = p85.onPasswordTextChangeCompletedFromKeyboard,
							onAnimationStateChangeCallback = p85.onAnimationStateChangeCallback,
							textBoxRef = p85.passwordTextFieldRef,
							centralOverlayBlocksInput = v230,
							captureFocusOnTapStart = not p85.state.isCountryCodeSearchVisible
						})),
						GenderSelector = not v240 and (GetFIntLuaLoginGenderSelector() ~= 2 and Roact.createElement(SignUpGenderSelector, {
							layoutOrder = not v121 and 7 or 8,
							gender = gender,
							onGenderChanged = p85.onGenderChanged,
							enableAuditContentCapture = GetFFlagEnableAuditForSinglePageSignUp()
						})),
						Spacing = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = not v121 and 8 or 9,
							Size = UDim2.new(1, 0, 0, 38)
						}),
						SignUpButton = if not v236 then Roact.createElement(Button, {
							buttonType = ButtonType.PrimaryContextual,
							layoutOrder = not v121 and 9 or 10,
							size = UDim2.new(1, 0, 0, 36),
							text = if not v251 then p87.signUpText else p87.continueText,
							isDisabled = not v216,
							isLoading = isSignUpInProgress,
							onActivated = p85.onSignUpClick
						}) else Roact.createElement(Foundation.Button, {
							variant = Foundation.Enums.ButtonVariant.Emphasis,
							LayoutOrder = not v121 and 9 or 10,
							text = if not v251 then p87.signUpText else p87.continueText,
							size = Foundation.Enums.InputSize.Medium,
							width = UDim.new(1, 0),
							isDisabled = not v216,
							isLoading = isSignUpInProgress,
							onActivated = p85.onSignUpClick
						}),
						CheckboxContainer = v514 and React.createElement(View, {
							tag = "auto-xy padding-x-xxlarge padding-y-large row gap-medium",
							LayoutOrder = not v121 and 10 or 11
						}, {
							SignUpAgreementCheckbox = React.createElement(Checkbox, {
								isDisabled = false,
								LayoutOrder = 1,
								label = "",
								isChecked = p85.state.signupAgreementsChecked,
								onActivated = function() -- line: 2689
									-- upvalues: p85 (copy), EventStreamConstants (copy)
									p85.props.authEventAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.TosCheckbox, (tostring(not p85.state.signupAgreementsChecked)))
									p85:setState({
										signupAgreementsChecked = not p85.state.signupAgreementsChecked
									})
								end,
								size = InputSize.Small
							}),
							Text = React.createElement(FoundationText, {
								tag = "text-body-small text-align-x-left text-wrap auto-xy shrink",
								LayoutOrder = 2,
								Text = s5
							})
						}),
						DisclaimerText = not (v244 or (v245 or v514)) and Roact.createElement(TitleAndParagraph, {
							layoutOrder = not v121 and 10 or 11,
							textXAlignment = Enum.TextXAlignment.Center,
							paragraphTextKeys = { v515 },
							enableAuditContentCapture = GetFFlagEnableAuditForSinglePageSignUp()
						}),
						DisclaimerLinks = not (v244 or v245) and Roact.createElement(DisclaimerLinks, {
							LayoutOrder = not v121 and 11 or 12,
							variant = if not FFlagFoundationStylingOnSignUp then nil else Default,
							enableAuditContentCapture = GetFFlagEnableAuditForSinglePageSignUp()
						}),
						ScrollPadding = v223 and Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = not v121 and 12 or 13,
							Size = UDim2.new(1, 0, 0, p85.state.onScreenKeyboardHeight * 2)
						})
					}),
					Footer = v230 and (v219 and Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Size = UDim2.new(1, 0, 0, 12),
						Position = UDim2.new(0, 0, 1, -12)
					}, {
						Rounding = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 2, 0),
							Position = UDim2.new(0, 0, -1, 0),
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(9, 9, 9, 9),
							Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
							ImageColor3 = t11.Theme.UIDefault.Color
						})
					}))
				})
			})
		end)
	end)
end

local v178 = RoactRodux.connect(function(p90, _) -- line: 2760
	return {
		formFactor = p90.FormFactor,
		screenSize = p90.ScreenSize
	}
end, function(p92) -- line: 2765
	-- upvalues: SignUpV2 (copy), OpenCentralOverlayForAgreeToPhoneNumberVerification (copy), AnalyticsEvents (copy), EventConstants (copy), OpenKISAPopUpAgreements (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy), FFlagSignalsNavP3Dispatch (copy), v146 (copy), NavigateBack (copy), SetNetworkingErrorToast (copy), OpenCentralOverlayForPhoneNumberVerification (copy), SetCurrentToastMessage (copy), ToastType (copy), SetCentralOverlay (copy), OverlayType (copy), CloseCentralOverlay (copy), OpenAccountSwitchingErrorOverlay (copy), ResetAppState (copy), Logout (copy), OpenEmailOtp (copy)
	return {
		signUp = function(p93, p94, p95, p96, p97, p98, p99, p100, p101, p102, p103, p104, p105, p106) -- line: 2767
			-- upvalues: p92 (copy), SignUpV2 (copy)
			return p92(SignUpV2(p93, p94, p95, p96, p97, p98, p99, p100, p101, p102, p103, p104, p105, p106))
		end,
		agreeToPhoneNumberVerification = function(_, p108, p109) -- line: 2802
			-- upvalues: p92 (copy), OpenCentralOverlayForAgreeToPhoneNumberVerification (copy)
			return p92(OpenCentralOverlayForAgreeToPhoneNumberVerification({
				verificationChallengeCallback = p108,
				phoneNumber = p109
			}))
		end,
		openKISAUserAgreements = function(p110) -- line: 2809
			-- upvalues: AnalyticsEvents (copy), EventConstants (copy), p92 (copy), OpenKISAPopUpAgreements (copy)
			AnalyticsEvents.sendPageLoadEvent(EventConstants.ctx.kisaAgreements, EventConstants.origin.signup)

			return p92(OpenKISAPopUpAgreements(p110))
		end,
		setBackNavigationDisabled = function(p111) -- line: 2814
			-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), p92 (copy), SetBackNavigationDisabled (copy)
			if FFlagUseBackDisableSignalStore then
				return (BackDisableStore.setDisabled(p111))
			end

			return (p92(SetBackNavigationDisabled(p111)))
		end,
		navigateBack = function() -- line: 2819
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v146 (copy), p92 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v146.back()
			end

			return p92(NavigateBack())
		end,
		showErrorToast = function() -- line: 2826
			-- upvalues: p92 (copy), SetNetworkingErrorToast (copy)
			return p92(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))
		end,
		verifyPhoneNumber = function(_, p113, p114, p115, p116, p117) -- line: 2829
			-- upvalues: p92 (copy), OpenCentralOverlayForPhoneNumberVerification (copy)
			return p92(OpenCentralOverlayForPhoneNumberVerification({
				verifyPhoneNumberCallback = p113,
				phoneNumber = p115,
				deliveryTarget = p116,
				challenge = p114,
				useEmailOptionClickedCallback = p117
			}))
		end,
		showErrorMessageToast = function(p118) -- line: 2845
			-- upvalues: p92 (copy), SetCurrentToastMessage (copy), ToastType (copy)
			return p92(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = p118
			}))
		end,
		showVNGUserAgreementsPopup = function(p119, p120, p121) -- line: 2851
			-- upvalues: p92 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p92(SetCentralOverlay(OverlayType.VNGUserAgreementsPopup, {
				isSignup = true,
				agreements = p119,
				agreementAccepted = p120,
				agreementDeclined = p121
			}, {
				DisableBackButtonClose = true
			}))
		end,
		showVNGDCForm = function() -- line: 2861
			-- upvalues: p92 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p92(SetCentralOverlay(OverlayType.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end,
		closeCentralOverlay = function() -- line: 2866
			-- upvalues: p92 (copy), CloseCentralOverlay (copy)
			return p92(CloseCentralOverlay())
		end,
		openAccountSwitchingErrorOverlay = function(p122, p123, p124, p125, p126, p127, p128, p129) -- line: 2869
			-- upvalues: p92 (copy), OpenAccountSwitchingErrorOverlay (copy)
			return p92(OpenAccountSwitchingErrorOverlay(p122, p123, p124, p125, p126, p127, p128, p129, true))
		end,
		resetAppState = function() -- line: 2891
			-- upvalues: p92 (copy), ResetAppState (copy)
			return p92(ResetAppState())
		end,
		logoutWithoutShowConfirmation = function(p130, p131) -- line: 2894
			-- upvalues: p92 (copy), Logout (copy)
			return p92(Logout(p130, p131))
		end,
		openEmailOtp = function(p132) -- line: 2898
			-- upvalues: p92 (copy), OpenEmailOtp (copy)
			p92(OpenEmailOtp(p132))
		end,
		showAccountLinkingAlert = function(p133) -- line: 2901
			-- upvalues: p92 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p92(SetCentralOverlay(OverlayType.AccountLinkingAlert, {
				alertType = p133
			}))
		end
	}
end)(v177)
local v179 = RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService,
	authEventAnalytics = RoactAnalyticsAuthEvents,
	analytics = RoactAnalytics,
	loggingProtocol = AppLogging
})(v178)
local v180 = RoactAppPolicy.connect(function(p134, _) -- line: 2917
	return {
		appPolicy = p134
	}
end)(v179)
local v181 = RoactAppExperiment.connectBrowserTrackerLayer({
	AppBtidLayers.SignupLayer,
	AppBtidLayers.IosPasswordSavingLayer,
	AppBtidLayers.AccountSwitcherLayer
}, function(p136, _) -- line: 2927
	-- upvalues: AppBtidLayers (copy), v121 (copy), v122 (copy), GetFFlagEnableAccountSwitcherIXPTextGatingFix (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy)
	local v261 = p136[AppBtidLayers.SignupLayer] or {}
	local v262 = p136[AppBtidLayers.IosPasswordSavingLayer] or {}
	local v263 = if not v121 then nil else v261.shouldSeeDisplayNamesOnSignup

	if v122 then
		v263 = true
	end

	local v266

	if GetFFlagEnableAccountSwitcherIXPTextGatingFix() then
		local v264 = p136[AppBtidLayers.AccountSwitcherLayer] or {}
		local v265 = not GetFFlagEnableAccountSwitcherRedesignIXP() or v264.enableAccountSwitcherFoundationDesign == true

		v266 = GetFFlagEnableAccountSwitcherFoundationDesign() and v265
	else
		v266 = GetFFlagEnableAccountSwitcherFoundationDesign()
	end

	return {
		useVerifiedSignupPage = v261.contactMethodRequired,
		arePasswordFieldsPlaintext = v261.ArePasswordFieldsPlaintext,
		shouldUseUsernameSuggestions = v261.usernameSuggestionsEnabled,
		enableRefreshButton = v261.suggestionRefreshButtonEnabled,
		shouldUseMinimalSignup = v261.shouldUseMinimalSignup,
		shouldHideGenderOption = v261.shouldHideGenderOption,
		shouldAutofocusOnBirthday = v261.shouldAutofocusOnBirthday,
		shouldUsePasswordlessSignup = v261.shouldUsePasswordlessSignup,
		shouldUsePasskeySignup = v261.shouldUsePasskeySignup,
		shouldAutomaticallyPromptForPasskey = v261.shouldAutomaticallyPromptForPasskey,
		shouldTightenPasskeyEligibility = v261.shouldTightenPasskeyEligibility,
		birthdayPickerVariant = v261.birthdayPickerVariant,
		shouldSeeDisplayNamesOnSignup = v263,
		shouldShowKoreanKISASignUpFlow = v261.shouldShowKoreanKISASignUpFlow,
		shouldSkipVPCSignupFlow = v261.shouldSkipVPCSignupFlow,
		shouldDisableUsernameAutofill = v261.shouldDisableUsernameAutofill,
		shouldRequireSignupCheckbox = v261.shouldRequireSignupCheckbox,
		signupLegalDisclaimerTextVariant = v261.signupLegalDisclaimerTextVariant,
		isIosAuthServiceEnabled = v262.enableNewIosPasswordSaving or false,
		showAccountSwitcherFoundationDesign = v266
	}
end)(v180)
local u182 = withNavigationProps(function(_, p139) -- line: 2973
	return p139
end)(v181)

local function SinglePageSignUpWithAuditContent(p140) -- line: 2978
	-- upvalues: AuditContentContext (copy), Roact (copy), u182 (ref), Cryo (copy)
	local v270 = AuditContentContext.useAuditContentContext()

	return Roact.createElement(u182, Cryo.Dictionary.join(p140, {
		capturedAuditContent = v270.capturedAuditContent,
		additionalAuditContent = v270.additionalAuditContent
	}))
end

return function(p141) -- line: 2990
	-- upvalues: ReactFocusNavigation (copy), v133 (copy), useBreakpointXOrSmaller (copy), Responsive (copy), FFlagFoundationStylingOnSignUp (copy), FFlagEnableSignupFoundationalizeBackgroundAndText (copy), useTokens (copy), Cryo (copy), Foundation (copy), RoactAppExperiment (copy), AppBtidLayers (copy), GetFFlagAuthCollapsingValidatorFoundationInput (copy), React (copy), GetFFlagEnablePreferredInputForSignUp (copy), usePreferredInput (copy), FFlagEnableSignUpExitModal (copy), useDispatch (copy), FFlagSignalsNavP3Dispatch (copy), v146 (copy), NavigateBack (copy), SetCentralOverlay (copy), OverlayType (copy), CloseCentralOverlay (copy), useSignUpPageNavigationBindings (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), Roact (copy), AuditContentContext (copy), SinglePageSignUpWithAuditContent (copy), FFlagHideBackButtonOnSignUpPage (copy), u182 (ref)
	local v272 = ReactFocusNavigation.useFocusedGuiObject()
	local v273 = ReactFocusNavigation.useFocusGuiObject()
	local v274 = if not v133 then nil else useBreakpointXOrSmaller(Responsive.Keys.Medium)
	local v275 = if not FFlagFoundationStylingOnSignUp and not FFlagEnableSignupFoundationalizeBackgroundAndText then nil else useTokens()

	if v275 and game:DefineFastFlag("SignupFoundationBackgroundDarkFix", false) then
		v275 = Cryo.Dictionary.join(v275, {
			Color = Foundation.Utility.getTokens(Foundation.Enums.Theme.Dark).Color
		})
	end

	local v276 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AuthenticationStylingLayer }, function(p142) -- line: 3007
		-- upvalues: AppBtidLayers (copy)
		local v486 = p142[AppBtidLayers.AuthenticationStylingLayer] or {}

		return {
			shouldUseFoundationBackgroundColor = v486.shouldUseFoundationBackgroundColor,
			shouldUseFoundationUsernameTextInput = v486.shouldUseFoundationUsernameTextInput
		}
	end)
	local v277 = FFlagEnableSignupFoundationalizeBackgroundAndText and v276.shouldUseFoundationBackgroundColor
	local v278 = GetFFlagAuthCollapsingValidatorFoundationInput() and v276.shouldUseFoundationUsernameTextInput
	local v279, v280 = React.useState(false)
	local v281 = if not GetFFlagEnablePreferredInputForSignUp() then nil else usePreferredInput()
	local v282 = FFlagEnableSignUpExitModal and v281 == Responsive.Input.Directional
	local v283 = useDispatch()
	local v284 = React.useCallback(function() -- line: 3026
		-- upvalues: v282 (copy), v279 (copy), FFlagSignalsNavP3Dispatch (copy), v146 (copy), v283 (copy), NavigateBack (copy), SetCentralOverlay (copy), OverlayType (copy), CloseCentralOverlay (copy), v273 (copy), v272 (copy)
		if not v282 then
			return
		end

		if not v279 then
			if FFlagSignalsNavP3Dispatch then
				v146.back()

				return
			end

			v283(NavigateBack())

			return
		end

		v283(SetCentralOverlay(OverlayType.SignUpExitModal, {
			onClose = function() -- line: 3039
				-- upvalues: v283 (copy), CloseCentralOverlay (copy), v273 (copy), v272 (copy)
				v283(CloseCentralOverlay())
				v283(function() -- line: 3041
					-- upvalues: v273 (copy), v272 (copy)
					v273(v272)
				end)
			end,
			onConfirm = function() -- line: 3045
				-- upvalues: v283 (copy), CloseCentralOverlay (copy), FFlagSignalsNavP3Dispatch (copy), v146 (copy), NavigateBack (copy)
				v283(CloseCentralOverlay())

				if FFlagSignalsNavP3Dispatch then
					v146.back()

					return
				end

				v283(NavigateBack())
			end
		}))
	end, {
		v279,
		v282,
		v272,
		v273,
		v283
	})
	local v285 = useSignUpPageNavigationBindings(if not v282 then nil else v284)
	local v286, v287 = ReactFocusNavigation.useDefaultFocusBehavior(v285)
	local v288 = React.useRef(nil)

	if GetFFlagEnableAuditForSinglePageSignUp() then
		return Roact.createElement(AuditContentContext.Provider, nil, {
			SignUpPage = Roact.createElement(SinglePageSignUpWithAuditContent, Cryo.Dictionary.join(p141, {
				signUpStarted = if not v282 then nil else v279,
				setSignUpStarted = if not v282 then nil else v280,
				shouldShowBackButton = if not FFlagHideBackButtonOnSignUpPage then nil else not v282,
				preferredInput = v281,
				focusedGuiObject = v272,
				focusGuiObject = v273,
				defaultRef = v286,
				containerRef = v287,
				birthdayContainerRef = v288,
				isCompactView = v274,
				foundationTokens = v275,
				shouldUseFoundationBackgroundColor = v277,
				shouldUseFoundationUsernameTextInput = v278
			}))
		})
	end

	return Roact.createElement(u182, Cryo.Dictionary.join(p141, {
		signUpStarted = if not v282 then nil else v279,
		setSignUpStarted = if not v282 then nil else v280,
		shouldShowBackButton = if not FFlagHideBackButtonOnSignUpPage then nil else not v282,
		preferredInput = v281,
		focusedGuiObject = v272,
		focusGuiObject = v273,
		defaultRef = v286,
		containerRef = v287,
		birthdayContainerRef = v288,
		isCompactView = v274,
		foundationTokens = v275,
		shouldUseFoundationBackgroundColor = v277,
		shouldUseFoundationUsernameTextInput = v278
	}))
end
