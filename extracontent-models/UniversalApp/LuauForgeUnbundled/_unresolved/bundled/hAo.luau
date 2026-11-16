local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local module = require("@luauforge/bundled/fMG")
local module2 = require("@luauforge/bundled/dYT")
local module3 = require("@luauforge/bundled/eda")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module5 = require("@luauforge/bundled/edC")
local withNavigationProps = require("@luauforge/bundled/dCu").withNavigationProps

local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local constants = UIBlox.App.Style.Constants
local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Foundation = require(CorePackages.Packages.Foundation)
local colorMode = Foundation.Enums.ColorMode
local checkbox = Foundation.Checkbox
local inputSize = Foundation.Enums.InputSize
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local module6 = require("@luauforge/bundled/hAp")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local module8 = require("@luauforge/bundled/dYW")
local module9 = require("@luauforge/bundled/fTO")
local module10 = require("@luauforge/bundled/fTR")
local module11 = require("@luauforge/bundled/fTS")
local module12 = require("@luauforge/bundled/fTK")
local module13 = require("@luauforge/bundled/fNe")
local module14 = require("@luauforge/bundled/hAq")
local module15 = require("@luauforge/bundled/hAs")
local module16 = require("@luauforge/bundled/hAw")
local module17 = require("@luauforge/bundled/hAz")
local module18 = require("@luauforge/bundled/hAL")
local uiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/Style").UiModeStyleProvider

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local disclaimerLinksVariant = AuthCommon.Enums.DisclaimerLinksVariant
local getLinkedPlatformAccountName = AuthCommon.Utils.getLinkedPlatformAccountName
local parseCredentialsProtocolIsAvailableResponse = AuthCommon.Utils.parseCredentialsProtocolIsAvailableResponse
local auditContentContext = AuthCommon.Stores.AuditContentContext.AuditContentContext
local authBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local accountLinkingAlertType = AuthCommon.Enums.AccountLinkingAlertType
local getCredentialsAvailabilityStore = AuthCommon.Stores.GetCredentialsAvailabilityStore
local useSignUpPageNavigationBindings = AuthCommon.Hooks.useSignUpPageNavigationBindings
local kisaComplianceUtils = require("@luauforge/bundled/fQJ").KISAComplianceUtils
local analyticsEvents = require("@luauforge/bundled/fQJ").Analytics.AnalyticsEvents
local eventConstants = require("@luauforge/bundled/fQJ").Analytics.EventConstants
local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local events = require("@luauforge/bundled/fsz").Events
local eventStreamConstants = require("@luauforge/bundled/fsz").EventStreamConstants
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore

local localStorageKey = require("@luauforge/bundled/dCq").Enums.LocalStorageKey
local robloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/Localization").RobloxLocaleIdKey
local module20 = require("@luauforge/bundled/hAP")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module21 = require("@luauforge/bundled/edO")
local module22 = require("@luauforge/bundled/fBr")
local module23 = require("@luauforge/bundled/dwB")
local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local dateHelper = require("@luauforge/bundled/fAu").DateHelper
local module24 = require("@luauforge/bundled/hAA")
local module25 = require("@luauforge/bundled/fsy")
local module26 = require("@luauforge/bundled/dwA")
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local module27 = require("@luauforge/bundled/hAQ")
local module28 = require("@luauforge/bundled/hAR")
local module29 = require("@luauforge/bundled/fTk")
local LinkStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")
local module31 = require("@luauforge/bundled/hAS")
local default = require("@luauforge/bundled/fCb").CredentialsProtocol.default
local constants2 = require("@luauforge/bundled/fTp").Constants
local userAgreementsCounterNames = require("@luauforge/bundled/fOd").UserAgreementsCounterNames
local Cryo = require(CorePackages.Packages.Cryo)
local module32 = require("@luauforge/bundled/dwM")
local Promise = require(CorePackages.Packages.Promise)

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local module33 = require("@luauforge/bundled/fDx")
local module34 = require("@luauforge/bundled/fQp")
local module35 = require("@luauforge/bundled/fQe")
local module36 = require("@luauforge/bundled/fQg")
local defineFastFlag = game:DefineFastFlag("EnableSkipVPCSignupFlow2", false)
local defineFastFlag2 = game:DefineFastFlag("BypassIXPSkipVPCSignup", false)

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTextFieldContentType
local module37 = require("@luauforge/bundled/hAT")
local module38 = require("@luauforge/bundled/fDy")

local fFlagFoundationStylingOnSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFoundationStylingOnSignUp
local module39 = require("@luauforge/bundled/fTT")
local module40 = require("@luauforge/bundled/fTr")

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/fCb").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local module41 = require("@luauforge/bundled/hAU")
local defineFastFlag3 = game:DefineFastFlag("UsePackageFetchSignupUserAgreements", false)
local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local module42 = require("@luauforge/bundled/hAV")
local defineFastFlag4 = game:DefineFastFlag("DisplayNamesOnSignupExperiment_v3", false)

local defineFastFlag5 = game:DefineFastFlag("EnableDisplayNamesOnSignupExperimentv1_Dev", false)
local defineFastInt = game:DefineFastInt("DisplayNameEligabilityAgeYears", 17)
local defineFastFlag6 = game:DefineFastFlag("DisplayNamesDiagLogging", false)

local module43 = require("@luauforge/bundled/fMR")
local defineFastFlag7 = game:DefineFastFlag("DisablePasskeySignupForLuaDeepLinks", false)
local defineFastFlag8 = game:DefineFastFlag("UseBreakpointOnSignUp", false)

local getFFlagAuthCollapsingValidatorFoundationInput = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagAuthCollapsingValidatorFoundationInput

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp

local getFFlagLuaAppSignupPasskeyAvailabilityPreflight = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppSignupPasskeyAvailabilityPreflight

local defineFastFlag9 = game:DefineFastFlag("UseLongFormSignupComplianceTextByDefault", false)
game:DefineFastFlag("LuaVerifiedSignup2", false)
game:DefineFastFlag("LuaVerifiedSignupExperiment2", false)
local module44 = require("@luauforge/bundled/hAW")

local module45 = require("@luauforge/bundled/fuu")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module47 = require("@luauforge/bundled/edP")
local module48 = require("@luauforge/bundled/hAX")
local module49 = require("@luauforge/bundled/fUb")
local module50 = require("@luauforge/bundled/fTn")
local module51 = require("@luauforge/bundled/fTs")
local module52 = require("@luauforge/bundled/fTm")
local module53 = require("@luauforge/bundled/fNo")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module55 = require("@luauforge/bundled/fBn")
local module56 = require("@luauforge/bundled/fPY")
local module57 = require("@luauforge/bundled/fvl")
local module58 = require("@luauforge/bundled/fTl")
local module59 = require("@luauforge/bundled/fBZ")
local module60 = require("@luauforge/bundled/fBP")
local module61 = require("@luauforge/bundled/fRo")
local module62 = require("@luauforge/bundled/fTq")
local validateCode = require("@luauforge/bundled/fTp").Thunks.ValidateCode
local module63 = require("@luauforge/bundled/hAG")

local module64 = require("@luauforge/bundled/hAY")

local module65 = require("@luauforge/bundled/hAZ")
local module66 = require("@luauforge/bundled/hBa")
local module67 = require("@luauforge/bundled/ecW")
local module68 = require("@luauforge/bundled/dCh")
local v6

if defineFastFlag3 then
	v6 = require("@luauforge/bundled/fOd").FetchSignupUserAgreements
else
	v6 = require("@luauforge/bundled/fRn")
end

local module69 = require("@luauforge/bundled/fDL")

local udim = UDim2.new(0, 36, 0, 36)

local iconsnavigationclose = images["icons/navigation/close"]

local vector2 = Vector2.new(540, 1080)

local function getPasskeysAvailableFromCredentialsProtocolResult(p2)
	local v7 = parseCredentialsProtocolIsAvailableResponse(p2)
	return v7.fido2Available and v7.fido2SupportsDeviceBoundOnly and v7.fido2SupportsPasskeyCreationOnDevice
end

local extended = Roact.PureComponent:extend("SinglePageSignUp")

function extended:init()
	local module70 = require("@luauforge/bundled/hBd")
	local module71 = require("@luauforge/bundled/hBe")

	local credentialsAvailabilityStore = getCredentialsAvailabilityStore(false)
	local fido2Available = credentialsAvailabilityStore.getFido2Available(false)
	local passwordsAvailable = credentialsAvailabilityStore.getPasswordsAvailable(false)

	self.state = {
		birthday = nil,
		shouldHideBirthdayEntry = false,
		username = "",
		displayName = "",
		password = "",
		birthdayValid = LinkStatus.Unvalidated,
		usernameValid = LinkStatus.Unvalidated,
		passwordValid = LinkStatus.Unvalidated,
		displayNameValid = LinkStatus.Unvalidated,
		isSignUpButtonEnabled = false,
		isSignUpInProgress = false,
		gender = module28.Unknown,
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
		passkeysAvailable = fido2Available,
		isCredentialsProtocolRegisterPasswordAvailable = passwordsAvailable,
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

	self.backButtonRef = Roact.createRef()
	self.isAlreadyAuthenticated = false

	if module33 == true then
		self.isAlreadyAuthenticated = Models.fromLocalStorage().userId ~= -1
	end

	function self.resetDefaultTheme()
		local authenticatedTheme = module55.getAuthenticatedTheme()

		if authenticatedTheme ~= "" then
			MemStorageService:Fire(module22.ThemeUpdate, authenticatedTheme)
		end
	end

	function self.logoutAllLoggedInUsersCallback()
		local networking = self.props.networking
		local accountBlob = module55.getAccountBlob()
		local v7 = Models.fromLocalStorage().userId ~= -1

		self:setState({
			signUpError = false,
			isSignUpButtonEnabled = false,
			isSignUpInProgress = false
		})

		module58(networking, accountBlob):await()

		if v7 == true then
			self.props.resetAppState()
			AppStorageService:SetItem(localStorageKey.CredentialValue, "")
			AppStorageService:Flush()
			self.props.logoutWithoutShowConfirmation(networking, GuiService)
		end

		self:setState({ signUpError = false })

		self.props.closeCentralOverlay()
	end

	function self.closeOverlayAndDisableSwitcherErrors()
		self.props.closeCentralOverlay()
	end

	function self.getIsAltAttempt()
		return self.isAltAttempt
	end

	function self.getSignupTelemetryStateAndOrigin()
		local v7 = self:shouldUseFoundationFields() and "foundationSignup" or "legacySignup"
		return preAuthDeepLinkUrlStore.getUrl() or v7, v7
	end

	function self.onCloseButtonClicked()
		local module72 = require("@luauforge/bundled/fTt")

		if module34 or module72 then
			local v7, v8

			if module72 then
				v7, v8 = self.getSignupTelemetryStateAndOrigin()
			end

			self.props.authEventAnalytics.reportAuthButtonClick(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.DismissCornerX,
				v7,
				nil,
				self.isAltAttempt,
				v8
			)
		end

		self.props.navigateBack()
	end

	function self.getShouldShowVNGAgreements()
		return self.props.appPolicy.getUseVNGUserAgreementPopup()
	end

	function self.getShouldBlockVNGU12SignUpOnClientSide()
		return self.props.appPolicy.getBlockVNGU12SignUpOnClientSide()
	end

	function self.getShouldUseAgeInput()
		return self.props.appPolicy.getUseAgeInput()
	end

	function self.getShouldShowKISAAgreements()
		return module35 and (self.props.appPolicy.getUseKoreaKISAUserAgreementPopup() or module36)
	end

	function self.enableSkipVPCSignupFlow()
		return defineFastFlag and (self.props.shouldSkipVPCSignupFlow or defineFastFlag2)
	end

	function self.getShouldAddParentalConsentAgreementId()
		return self.props.appPolicy.getParentalConsentAgreementId()
	end

	function self.getSignupCheckboxDisabled()
		return self.props.appPolicy.getSignupCheckboxDisabled()
	end

	function self.launchKISATermsOfService(p2, p3)
		local v7 = {
			agreements = self.state.agreements,
			onAgreeFunction = function(p4)
				analyticsEvents.sendButtonClickEvent(
					eventConstants.ctx.kisaAgreements,
					eventConstants.origin.signup,
					eventConstants.btn.agree
				)

				local agreedUserAgreements = kisaComplianceUtils.getAgreedUserAgreements(p4)
				local joined = Cryo.Dictionary.join(p2, {
					agreementIds = agreedUserAgreements
				})

				local shouldAddParentalConsentAgreementId = self.getShouldAddParentalConsentAgreementId()

				if
					p3
					and shouldAddParentalConsentAgreementId
					and shouldAddParentalConsentAgreementId ~= ""
				then
					table.insert(joined.agreementIds, shouldAddParentalConsentAgreementId)
				end

				self.requestSignUp(joined)
			end,
			onAbandonFunction = self.onAbandonKISASignUpFlow,
			isUnderAgeFlow = p3
		}

		self.props.openKISAUserAgreements(v7)
	end

	function self.getIsSignUpButtonEnabled()
		local v7 = self.props.shouldUseMinimalSignup and module37()

		return module71({
			birthday = self.state.birthday,
			username = self.state.username,
			password = self.state.password,
			displayName = self.state.displayName,
			birthdayValid = self.state.birthdayValid,
			usernameValid = self.state.usernameValid,
			passwordValid = self.state.passwordValid,
			displayNameValid = self.state.displayNameValid,
			validBirthday = self.state.validBirthday,
			shouldUseMinimalSignup = v7,
			shouldUsePasswordlessSignup = self.props.shouldUsePasswordlessSignup,
			shouldUsePasskeySignup = self.props.shouldUsePasskeySignup,
			passkeysAvailable = self.state.passkeysAvailable,
			shouldUseAlternateBirthday = module42() and self.props.birthdayPickerVariant and self.props.birthdayPickerVariant > 0,
			shouldRequireSignupCheckbox = self.props.shouldRequireSignupCheckbox,
			signupAgreementsChecked = self.state.signupAgreementsChecked,
			signupCheckboxDisabled = self.getSignupCheckboxDisabled(),
			displayNamesOnSignupExperimentEnabled = defineFastFlag4,
			isDisplayNameFieldRequired = defineFastFlag4 and self.isDisplayNameFieldRequired(),
			passkeySignupEnabled = module38()
		})
	end

	function self.updateState(p2)
		spawn(function()
			if self.isMounted then
				self:setState(p2)
			end
		end)
	end

	function self.getHidePassword()
		if self.state.hidePassword == nil then
			return not self.props.arePasswordFieldsPlaintext
		end

		return self.state.hidePassword
	end

	function self.passwordVisibilityToggleCallback()
		local hidePassword = self.getHidePassword()

		if hidePassword then
			self.props.authEventAnalytics.reportButtonClicked(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.ShowPassword
			)
		else
			self.props.authEventAnalytics.reportButtonClicked(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.HidePassword
			)
		end

		self:setState({
			hidePassword = not hidePassword
		})
	end

	function self.onBirthdaySelected(p2, p3)
		module32.assert(
			birthday.is(p2),
			"CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing."
		)

		self.updateState({ birthday = p2, validBirthday = p3 })

		if self.useVerifiedSignup() then
			self.props.authEventAnalytics.reportButtonClicked(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.ConfirmBirthday
			)
		end

		self.updateSignUpFieldFilled()
	end

	function self.onAgeChanged(p2)
		local v7 = tonumber(p2)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module70.buildBirthdayFromAge(v7, localTime))
	end

	function self.onAgeAndMonthChanged(p2, p3)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module70.buildBirthdayFromAgeMonth(p2, p3, localTime))
	end

	function self.onMonthAndYearChanged(p2, p3)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module70.buildBirthdayFromMonthYear(p2, p3, localTime))
	end

	local v7 = require("@luauforge/bundled/hBf")({
		updateState = self.updateState,
		getIssueCondition = function()
			return self.state.issueCondition
		end,
		getAuthEventAnalytics = function()
			return self.props.authEventAnalytics
		end
	})

	self.usernameSuggestionClicked = v7.usernameSuggestionClicked
	self.logRefreshButtonClicked = v7.logRefreshButtonClicked
	self.usernameSuggestionsShown = v7.usernameSuggestionsShown
	self.logSuggestableUsername = v7.logSuggestableUsername
	self.shouldSuggest = v7.shouldSuggest
	self.updatePillClicked = v7.updatePillClicked
	self.resetPillClicked = v7.resetPillClicked
	self.updateIssueCondition = v7.updateIssueCondition
	self.updateSuggestionControlState = v7.updateSuggestionControlState
	self.loadSuggestions = v7.loadSuggestions
	self.finishSuggestions = v7.finishSuggestions

	function self.onBirthdayFocused(p2)
		if self.isMounted then
			self:setState({ birthdayFocused = p2 })
		end
	end

	function self.onUsernameTextChanged(p2, p3)
		local v8

		if defineFastFlag4 and self.shouldShowDisplayNameField() and not self.state.hasEditedUsername then
			v8 = self.state.recommendedUsername ~= p2
		end

		local updateState = self.updateState

		if not defineFastFlag4 then
			v8 = nil
		end

		updateState({ username = p2, usernameValid = p3, hasEditedUsername = v8 })

		if self.shouldSuggest() then
			self.logSuggestableUsername(p2)
		end

		self.updateSignUpFieldFilled()
	end

	function self.updateSignUpFieldFilled()
		if self.props.signUpStarted == nil then
			return
		end

		local v8 = self.state.username ~= "" or self.state.password ~= "" or self.state.birthday ~= nil

		if v8 ~= self.state.signUpStarted then
			self.props.setSignUpStarted(v8)
		end
	end

	function self.onDisplayNameTextChanged(p2, p3)
		self.updateState({ displayName = p2, displayNameValid = p3 })
	end

	function self.updateBypassDisplayNameField(p2)
		self:setState({ bypassDisplayNameField = p2 })
	end

	function self.onUsernameTextValidated(p2, p3)
		self.onUsernameTextChanged(p2, p3)

		if p3 == LinkStatus.Valid then
			self.props.authEventAnalytics.reportInteractWithAction(
				module25.Context.SinglePageSignUpScreen,
				module25.Field.Username,
				module25.ActionType.Submit,
				p3,
				p2
			)
		end
	end

	function self.onPasswordTextChanged(p2, p3)
		self.updateState({ password = p2, passwordValid = p3 })

		self.updateSignUpFieldFilled()
	end

	self.cachedScrollCanvasPositionY = 0
	self.cachedScrollCanvasInitialSizeY = 0
	local binding, v8 = Roact.createBinding(0)
	self.scrollCanvasTargetPositionY = binding
	self.updateScrollCanvasTargetPositionY = v8

	self.scrollingFrameRef = Roact.createRef()
	self.ageTextFieldRef = Roact.createRef()
	self.usernameTextFieldRef = Roact.createRef()
	local ref = if defineFastFlag4 then Roact.createRef() else nil
	self.displayNameTextFieldRef = ref
	self.passwordTextFieldRef = Roact.createRef()
	self.passwordFrameRef = Roact.createRef()

	function self.onDisplayNameTextChangeCompletedFromKeyboard()
		task.spawn(function()
			if self.displayNameTextFieldRef.current then
				self.displayNameTextFieldRef.current:ReleaseFocus()
			end

			task.defer(function()
				if self.usernameTextFieldRef.current then
					self.usernameTextFieldRef.current:CaptureFocus()
				end
			end)

			if module43 then
				self.props.authEventAnalytics.reportAuthButtonClick(
					module25.Context.SinglePageSignUpScreen,
					module25.Button.DisplayNameNext,
					module25.State.KeyboardInput
				)
			end
		end)
	end

	function self.onUsernameTextChangeCompletedFromKeyboard()
		spawn(function()
			if self.usernameTextFieldRef.current then
				self.usernameTextFieldRef.current:ReleaseFocus()
			end

			if self.passwordTextFieldRef.current then
				self.passwordTextFieldRef.current:CaptureFocus()
			end

			self.props.authEventAnalytics.reportButtonClicked(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.UsernameNext
			)
		end)
	end

	function self.onPasswordTextChangeCompletedFromKeyboard()
		spawn(function()
			if self.passwordTextFieldRef.current then
				self.passwordTextFieldRef.current:ReleaseFocus()
			end

			self.props.authEventAnalytics.reportButtonClicked(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.PasswordNext
			)
		end)
	end

	function self.cacheScrollCanvasInitialSizeIfNecessary()
		if self.cachedScrollCanvasInitialSizeY == 0 then
			local parent = self.scrollingFrameRef.current.Parent
			local canvasSize = self.scrollingFrameRef.current.CanvasSize

			local absoluteSize = parent and parent.AbsoluteSize or Vector2.new(0, 0)
			self.cachedScrollCanvasInitialSizeY = canvasSize.Y.Scale * absoluteSize.Y + canvasSize.Y.Offset
		end
	end

	function self.agreeToPhoneNumberVerification()
		local agreeToPhoneNumberVerification = self.props.agreeToPhoneNumberVerification
		local networking = self.props.networking
		local v9 = self.state.phoneCountryCode.prefix .. "," .. self.state.phoneInput .. "," .. self.state.phoneCountryCode.code

		agreeToPhoneNumberVerification(networking, function()
			module66(networking, v9):andThen(function(p2)
				local challenge = p2.challenge
				self.verifyPhoneNumber(challenge, self.state.phoneInput, v9)
			end, function(p2)
				if
					p2 == "Authentication.TwoStepVerification.Response.TooManyAttempts"
					or p2 == "Authentication.SignUp.Response.PhoneNumberAlreadyLinked"
					or p2 == "Authentication.SignUp.Response.InvalidPhoneNumber"
				then
					self.props.showErrorMessageToast(p2)
				else
					self.props.showErrorToast()
				end
			end)
		end, self.state.phoneInput)
	end

	function self.onSignUpClick()
		if self.useVerifiedSignup() and self.state.contactMethod == module27.PhoneNumber then
			self.agreeToPhoneNumberVerification()
		else
			self.onSignUpButtonActivated()
		end
	end

	function self.verifyPhoneNumber(p2, p3, p4)
		self.props.verifyPhoneNumber(
			self.props.networking,
			self.verifyPhoneNumberCallback,
			p2,
			p3,
			p4,
			self.useEmailOptionClickedCallback
		)
	end

	function self.verifyPhoneNumberCallback(verifiedSignupVoucher)
		self.verifiedSignupVoucher = verifiedSignupVoucher
		self.onSignUpButtonActivated()
	end

	function self.useEmailOptionClickedCallback()
		self:setState({ contactMethod = module27.Email })
	end

	function self.phoneCountryCodeSelectorCallback(p2)
		self:setState({ isCountryCodeSearchVisible = p2 })
	end

	function self.onTextBoxFocused(p2)
		self.cacheScrollCanvasInitialSizeIfNecessary()

		local v9 = math.clamp(
			self.scrollingFrameRef.current.CanvasPosition.Y,
			0,
			self.cachedScrollCanvasInitialSizeY
		)

		if self.isMounted then
			local v10 = p2.Y - self.scrollingFrameRef.current.absolutePosition.Y + v9
			self.updateScrollCanvasTargetPositionY(v10)
			task.defer(function()
				if self.isMounted then
					self.updateScrollCanvasTargetPositionY(0)
				end
			end)
		end
	end

	function self.onTextBoxFocusLost()
		if self.isMounted then
			self.updateScrollCanvasTargetPositionY(0)
		end
	end

	function self.onUsernameTextBoxFocusLost()
		self.onTextBoxFocusLost()

		self.updateState({ isUsernameFocused = false })
	end

	function self.onAnimationStateChangeCallback(p2, p3)
		local v9 = p2 == Enum.TextInputType.Password

		if require("@luauforge/bundled/hBi") then
			v9 = require("@luauforge/bundled/hBj")(p2)
		end

		if v9 then
			self:setState({ isPasswordAnimating = p3 })
		else
			self:setState({ isUsernameAnimating = p3 })
		end
	end

	function self.onFocusedTextBoxPositionChanged(p2)
		if self.state.isUsernameAnimating or self.state.isPasswordAnimating then
			self.onTextBoxFocused(p2)
		end
	end

	function self.getScrollingFrameCanvasPosition(p2)
		if p2 > 0 then
			return Vector2.new(0, p2)
		end

		if self.scrollingFrameRef and self.scrollingFrameRef.current then
			return self.scrollingFrameRef.current.CanvasPosition
		end

		return Vector2.new(0, 0)
	end

	function self.onUsernameTextBoxFocused(p2)
		self:setState({ isUsernameFocused = true })

		self.props.authEventAnalytics.reportUsernameFocus(module25.Context.SinglePageSignUpScreen)

		if require("@luauforge/bundled/fTt") and self:shouldUseFoundationFields() then
			self.props.authEventAnalytics.reportAuthFormInteraction(
				module25.Context.SinglePageSignUpScreen,
				module25.Field.Username,
				module25.ActionType.Focus,
				"foundationSignup"
			)
		end

		self.onTextBoxFocused(p2)
	end

	function self.onDisplayNameTextBoxFocused(p2)
		if module43 then
			self.props.authEventAnalytics.reportDisplayNameFocus(module25.Context.SinglePageSignUpScreen)
		end

		self.onTextBoxFocused(p2)
	end

	function self.onPasswordTextBoxFocused(p2)
		self.props.authEventAnalytics.reportPasswordFocus(module25.Context.SinglePageSignUpScreen)
		self.onTextBoxFocused(p2)
	end

	function self.updateIsSignUpInProgress(p2)
		spawn(function()
			if self.isMounted then
				self:setState({ isSignUpInProgress = p2 })
			end
		end)
	end

	function self.requestSignUp(p2, p3)
		local networking = self.props.networking
		local guiService = self.props.guiService
		local analytics = self.props.analytics
		local appPolicy = self.props.appPolicy
		local omniRecommendationsRequest = self.props.omniRecommendationsRequest
		local authEventAnalytics = self.props.authEventAnalytics

		local signUp = self.props.signUp
		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		local function fn(p4, p5)
			if not p4 then
				self.updateIsSignUpInProgress(false)

				return
			end

			setBackNavigationDisabled(true)

			self.requestSignUp(p2, p5)
		end

		local v9 = self.useVerifiedSignup() and self.state.contactMethod == module27.PhoneNumber

		local url = preAuthDeepLinkUrlStore.getUrl()
		local v10 = defineFastFlag7

		if v10 then
			v10 = not (url == nil) and url ~= ""
		end

		local v11 = not self.state.passkeysAvailable or v10
		local v12 = module38()
		signUp(
			networking,
			omniRecommendationsRequest,
			guiService,
			fn,
			p3,
			analytics,
			appPolicy,
			p2,
			v9,
			self.props.shouldUsePasskeySignup and v12 and game:GetEngineFeature("SignupActionRequiredKeyAvailable") and not v11,
			self.props.shouldAutomaticallyPromptForPasskey,
			module41() and self.state.isCredentialsProtocolRegisterPasswordAvailable,
			authEventAnalytics,
			self.props.isIosAuthServiceEnabled
		):andThen(
			function()
				setBackNavigationDisabled(false)
			end,
			function(p4)
				setBackNavigationDisabled(false)

				if v9 then
					if p4 ~= module31.Captcha then
						self.updateIsSignUpInProgress(false)
						self:setState({ signUpError = true })
					end
				else
					if p4 ~= module29.Captcha then
						self.updateIsSignUpInProgress(false)
						self:setState({ signUpError = true })
					end

					if module34 and p4 ~= module29.Captcha then
						module51(authEventAnalytics, p4)
					end

					if p4 == module29.VNGAgeUnder12 then
						self:setState({ shouldShowUnderAgeAlert = true })
					end

					if module33 == true and p4 == module29.EmptyAccountSwitchBlobRequired then
						self.props.openAccountSwitchingErrorOverlay(
							"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
							"Authentication.AccountSwitch.Description.ContinueSignOutOthers",
							"Authentication.AccountSwitch.Action.Continue",
							"Authentication.CrossDevice.Action.CancelLogin",
							self.logoutAllLoggedInUsersCallback,
							self.props.closeCentralOverlay,
							module26.Auth.AccountSwitcherSignupEmptyBlobRequiredError,
							self.state.username
						)

						self:setState({ signUpError = false })
					end

					if module33 == true and p4 == module29.ParentEmptyAccountSwitchBlobRequired then
						self.props.openAccountSwitchingErrorOverlay(
							"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
							"Authentication.AccountSwitch.Description.ContinueSignOutOthers",
							"Authentication.AccountSwitch.Action.Continue",
							"Authentication.CrossDevice.Action.CancelLogin",
							self.logoutAllLoggedInUsersCallback,
							self.props.closeCentralOverlay,
							module26.Auth.AccountSwitcherParentSignupEmptyBlobRequiredError,
							self.state.username
						)

						self:setState({ signUpError = false })
					end
				end

				if p4 == module29.AccountLinkingRequired then
					self.props.showAccountLinkingAlert(accountLinkingAlertType.RetryLogInAlreadyLinked)
				elseif p4 == module29.AccountLinkingFailed then
					self.props.showAccountLinkingAlert(accountLinkingAlertType.RetryLogInGenericError)
				end
			end
		)
	end

	function self.onSignUpButtonActivated()
		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		local birthday2 = self.state.birthday
		local username = self.state.username
		local password = self.state.password
		local gender = self.state.gender
		local isSignUpButtonEnabled = self.getIsSignUpButtonEnabled()
		local locale = self.locale
		local emailInput = self.state.emailInput

		if isSignUpButtonEnabled then
			self.props.authEventAnalytics.reportSignUpButtonClicked(module25.Context.SinglePageSignUpScreen)

			if self.getShouldBlockVNGU12SignUpOnClientSide() then
				local userAge = self.getUserAge()

				if userAge == nil or userAge < 12 then
					self:setState({ shouldShowUnderAgeAlert = true })

					return
				end
			end

			local url = preAuthDeepLinkUrlStore.getUrl()
			local v9, v10 = module50(self.props.networking, url):await()

			self.props.authEventAnalytics.reportAuthButtonClick(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.SignUp,
				v10,
				url,
				self.isAltAttempt
			)

			if defineFastFlag6 and self.props.shouldSeeDisplayNamesOnSignup then
				if self.state.recommendedUsername == username then
					module69(module20.SignUpWithRecommendedUsernames, 1)
				elseif self.state.hasEditedUsername then
					module69(module20.SignUpWithEditedUsernames, 1)
				end

				if self.state.bypassDisplayNameField then
					module69(module20.SignupBypassingDisplayNames, 1)
				end
			end

			self.updateIsSignUpInProgress(true)
			setBackNavigationDisabled(true)

			self:setState({ signUpError = false })

			local v11 = {
				birthday = birthday2 and birthday2:FormatForEndpoint() or "",
				username = username,
				password = password,
				displayName = 0,
				gender = 0,
				locale = 0,
				capturedAuditContent = 0,
				additionalAuditContent = 0
			}

			local v12 = if defineFastFlag4 and self.isDisplayNameFieldRequired() then self.state.displayName else nil
			v11.displayName = v12

			v11.gender = gender
			v11.locale = locale
			v11.capturedAuditContent = self.props.capturedAuditContent
			v11.additionalAuditContent = self.props.additionalAuditContent

			local v13 = self.useVerifiedSignup()

			if v13 and self.state.contactMethod == module27.Email then
				v11.email = emailInput
			elseif v13 and self.state.contactMethod == module27.PhoneNumber then
				v11.verifiedSignupVoucher = self.verifiedSignupVoucher
			end

			if self.props.appPolicy.getAddUserAgreementIdsToSignupRequest() then
				local agreements = self.state.agreements

				if #agreements > 0 then
					local ids = {}

					for i, agreement in ipairs(agreements) do
						table.insert(ids, agreement.id)
					end

					v11.agreementIds = ids
				else
					module69(userAgreementsCounterNames.AgreementsIdsEmptyOnSignup, 1)
				end
			end

			if self.getShouldShowVNGAgreements() then
				self.props.showVNGUserAgreementsPopup(self.state.agreements, function(list)
					local v14 = v11
					local ids = {}

					for i, item in ipairs(list) do
						table.insert(ids, item.id)
					end

					v14.agreementIds = ids
					self.requestSignUp(v11)
				end, function()
					self.updateIsSignUpInProgress(false)
					setBackNavigationDisabled(false)
				end)
			elseif self.getShouldShowKISAAgreements() then
				local userAge = self.getUserAge()

				if not (userAge and userAge < module40) then
					self.launchKISATermsOfService(v11, false)
				elseif self.enableSkipVPCSignupFlow() then
					events.authPageload(
						eventStreamConstants.Context.KISAU14Signup,
						eventStreamConstants.State.SkipVPC
					)

					self.requestSignUp(v11)
				else
					events.authPageload(
						eventStreamConstants.Context.KISAU14Signup,
						eventStreamConstants.State.LaunchParentSignUpOtp
					)

					self.launchParentSignUpOtp(v11)
				end
			else
				self.requestSignUp(v11)
			end
		end
	end

	function self.onGenderChanged(p2)
		if self.isMounted then
			self.updateState({ gender = p2 })
		end
	end

	function self.validUsernameEntered(p2): boolean
		return self.state.username ~= "" and self.state.usernameValid ~= LinkStatus.Invalid
	end

	function self.validPasswordEntered(): boolean
		return self.state.password ~= "" and self.state.passwordValid ~= LinkStatus.Invalid
	end

	function self.useVerifiedSignup()
		return game:GetFastFlag("LuaVerifiedSignup2")
			or game:GetFastFlag("LuaVerifiedSignupExperiment2")
			and self.props.useVerifiedSignupPage
			and not isTenFootInterface()
	end

	function self.useUsernameSuggestions()
		return self.props.shouldUseUsernameSuggestions
	end

	function self.useRefreshButton()
		return self.props.enableRefreshButton
	end

	function self.getBirthdayVariant()
		if self.getShouldUseAgeInput() then
			return 1
		end

		if module42() and self.props.birthdayPickerVariant ~= nil then
			return self.props.birthdayPickerVariant
		end

		return 0
	end

	function self.SetContactMethod(p2)
		self.updateState({ contactMethod = p2 })
	end

	function self.SetPhoneNumber(p2, p3, p4)
		self.updateState({ phoneCountryCode = p2, phoneInput = p3, phoneValid = p4 })
	end

	function self.SetEmail(p2, p3)
		self.updateState({ emailInput = p2, emailValid = p3 })
	end

	function self.onSignUpContentFrameCanvasSizeChange(p2)
		local value = self.scrollCanvasTargetPositionY:getValue()
		self.scrollingFrameRef.current.CanvasPosition = self.getScrollingFrameCanvasPosition(value)
	end

	function self.getUserAge()
		if self.state.birthday then
			return self.state.birthday:GetAgeInYears()
		end

		return nil
	end

	function self.getUsernamePlaceholder(p2)
		if not self.props.shouldSeeDisplayNamesOnSignup then
			return p2.usernamePlaceholder
		end

		if not self.state.birthday then
			return ""
		end

		if defineFastInt <= self.getUserAge() and not self.state.hasSetIneligibleAgeAtLeastOnce then
			return p2.agedUpUsernamePlaceholder
		end

		return p2.usernamePlaceholder
	end

	function self.shouldShowUsernameField(): boolean
		if not self.props.shouldSeeDisplayNamesOnSignup then
			return true
		end

		if
			self.state.birthday
			and not (self.getUserAge() < defineFastInt or self.state.hasSetIneligibleAgeAtLeastOnce)
		then
			return self.state.recommendedUsername ~= nil
		end

		return true
	end

	function self.shouldShowDisplayNameField()
		local v9 = self.props.shouldSeeDisplayNamesOnSignup and self.state.birthday

		if not v9 then
			return v9
		end

		v9 = defineFastInt <= self.getUserAge() and not self.state.hasSetIneligibleAgeAtLeastOnce
		return v9
	end

	function self.isDisplayNameFieldRequired()
		return self.shouldShowDisplayNameField() and not self.state.bypassDisplayNameField
	end

	function self.isValidDisplayNameEntered(): boolean
		return self.state.displayName ~= "" and self.state.displayNameValid ~= LinkStatus.Invalid
	end

	function self.setUsernameRecommendation(p2)
		self:setState(function(p3)
			local v10 = if p3.recommendedUsername == nil or p2 ~= "" then p2 else nil
			return { recommendedUsername = v10 }
		end)
	end

	function self.getUsernameGuidanceText(p2)
		if
			self.shouldShowDisplayNameField()
			and self.state.recommendedUsername ~= ""
			and self.state.recommendedUsername ~= nil
			and not (self.state.hasEditedUsername or self.state.isUsernameFocused)
		then
			return p2.autogeneratedUsernameGuidance
		end

		return nil
	end

	function self.validateOtpCode(otpSessionToken, otpCode, p2)
		self.state.otpSessionToken = otpSessionToken
		self.state.otpCode = otpCode

		local networking = self.props.networking

		local v9 = {
			origin = constants2.otpServiceOriginSignup,
			contactType = constants2.otpServiceContactType,
			passCode = self.state.otpCode,
			otpSessionToken = self.state.otpSessionToken
		}

		local v10 = {
			otpSessionToken = tostring(self.state.otpSessionToken),
			otpContactType = constants2.otpServiceContactType
		}

		return validateCode(networking, v9)():andThen(function(p3)
			self.props.closeCentralOverlay()
			p2.otpSession = v10
			self.launchKISATermsOfService(p2, true)
		end):catch(function(p3)
			return Promise.reject(p3)
		end)
	end

	function self.onAbandonKISASignUpFlow()
		analyticsEvents.sendButtonClickEvent(
			eventConstants.ctx.kisaAgreements,
			eventConstants.origin.signup,
			eventConstants.btn.cancel
		)

		self.updateIsSignUpInProgress(false)
	end

	function self.launchParentSignUpOtp(p2)
		local v9 = {
			origin = constants2.otpServiceOriginSignup,
			codeLength = 6,
			enterEmailTitleKey = constants2.translationKeys.parentEmailTitleKey,
			enterEmailDescriptionKey = constants2.translationKeys.sendParentVerificationCodeKey,
			enterCodeTitleKey = constants2.translationKeys.oneTimeCodeTitleKey,
			enterCodeDescriptionKey = constants2.translationKeys.oneTimeCodeHelpDescriptionKey,
			complianceCheckboxMessageKey = constants2.translationKeys.parentalConsentModalDescriptionKey,
			onSubmitCode = function(p3, p4)
				return self.validateOtpCode(p3, p4, p2)
			end,
			onModalAbandoned = self.onAbandonKISASignUpFlow,
			screenSize = self.props.screenSize
		}

		self.props.openEmailOtp(v9)
	end

	self.isMounted = false
end

function extended:didMount()
	self.isMounted = true
	self.isAltAttempt = nil

	default:isAvailable(default.CredentialsTypes.FIDO2, getFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(data)
		local v7

		if
			getFFlagLuaAppSignupPasskeyAvailabilityPreflight()
			and self.props.shouldTightenPasskeyEligibility
			and data.FIDO2 ~= nil
		then
			local v8 = parseCredentialsProtocolIsAvailableResponse(data)
			v7 = v8.fido2Available
				and v8.fido2SupportsDeviceBoundOnly
				and v8.fido2SupportsPasskeyCreationOnDevice
		else
			v7 = data.isAvailable or false
		end

		local v8 = data.password and data.password.isAvailable and true or false

		if self.isMounted then
			self:setState({
				passkeysAvailable = v7,
				isCredentialsProtocolRegisterPasswordAvailable = v8
			})
		end

		self.props.authEventAnalytics.reportAuthPageload(module25.Context.PasskeySignup, (tostring(v7)))

		self.props.authEventAnalytics.reportAuthPageload(module25.Context.CMPasswordSignup, (tostring(v8)))
	end):catch(function(p2)
		warn("Error checking for available credential types. Error: ", p2)
	end)

	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
		local y = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		self:setState({ onScreenKeyboardHeight = y })
	end)

	local addUserAgreementIdsToSignupRequest = self.props.appPolicy.getAddUserAgreementIdsToSignupRequest()
	local shouldShowVNGAgreements = self.getShouldShowVNGAgreements()
	local shouldShowKISAAgreements = self.getShouldShowKISAAgreements()

	if addUserAgreementIdsToSignupRequest or shouldShowVNGAgreements or shouldShowKISAAgreements then
		local function fn(list)
			if not list then
				module69(userAgreementsCounterNames.FetchAgreementsHttpRequestFailureOnSignup, 1)
			elseif #list > 0 then
				self.updateState({ agreements = list })
			else
				module69(userAgreementsCounterNames.FetchAgreementsEmptyResponseOnSignup, 1)
			end
		end
		v6(self.props.networking, self.props.analytics):andThen(fn, function() end)
	end

	self.props.authEventAnalytics.reportScreenLoaded(module25.Context.SinglePageSignUpScreen)
	self.props.loggingProtocol:logEventOnce("signup_page_did_mount")
	self.props.loggingProtocol:logRobloxTelemetryCounter(
		telemetryConfigs.SignupPageMountTelemetryConfig,
		1,
		{ version = 1 }
	)

	local module70 = require("@luauforge/bundled/fTt")
	local v7 = preAuthDeepLinkUrlStore.getUrl()
	local v8

	if module70 then
		v7, v8 = self.getSignupTelemetryStateAndOrigin()
	else
		v8 = nil
	end

	module52(self.props.networking):andThen(function(p2)
		if p2 and p2.IsAltBrowserTracker ~= nil then
			self.isAltAttempt = p2.IsAltBrowserTracker
			self.props.authEventAnalytics.reportAuthPageload(
				module25.Context.SinglePageSignUpScreen,
				v7,
				self.isAltAttempt,
				v8
			)
		elseif module70 then
			self.isAltAttempt = false
			self.props.authEventAnalytics.reportAuthPageload(
				module25.Context.SinglePageSignUpScreen,
				v7,
				self.isAltAttempt,
				v8
			)
		end
	end, function(p2)
		warn("Error auth metadata: ", error)
		self.props.authEventAnalytics.reportAuthPageload(
			module25.Context.SinglePageSignUpScreen,
			v7,
			self.isAltAttempt,
			v8
		)
	end)

	if self.props.focusedGuiObject and self.backButtonRef and self.backButtonRef.current then
		self.props.focusGuiObject(self.backButtonRef.current)
	end
end

function extended:willUnmount()
	self.isMounted = false
	self.isAltAttempt = nil

	if module33 == true and self.isAlreadyAuthenticated == true then
		self.resetDefaultTheme()
	end

	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.didUpdate(object, p2, data)
	local focusedGuiObject = object.props.focusedGuiObject
	local birthdayContainerRef = object.props.birthdayContainerRef

	local v7 = focusedGuiObject
		and birthdayContainerRef
		and birthdayContainerRef.current
		and focusedGuiObject:IsDescendantOf(birthdayContainerRef.current)

	local focusedGuiObject2 = p2.focusedGuiObject
	local birthdayContainerRef2 = p2.birthdayContainerRef

	local v8 = focusedGuiObject2
		and birthdayContainerRef2
		and birthdayContainerRef2.current
		and focusedGuiObject2:IsDescendantOf(birthdayContainerRef2.current)

	if v7 and not v8 then
		object.updateScrollCanvasTargetPositionY(10)
		task.defer(function()
			if object.isMounted then
				object.updateScrollCanvasTargetPositionY(0)
			end
		end)
	end

	if
		defineFastFlag4
		and object.state.birthday ~= nil
		and not object.state.hasSetIneligibleAgeAtLeastOnce
		and object.getUserAge() < defineFastInt
	then
		object:setState({ hasSetIneligibleAgeAtLeastOnce = true })
	end

	if defineFastFlag6 and object.props.shouldSeeDisplayNamesOnSignup then
		if
			object.state.recommendedUsername ~= ""
			and object.state.hasEditedUsername
			and object.state.hasEditedUsername ~= data.hasEditedUsername
		then
			module69(module20.ReccomendedNameEdited, 1)
		end

		if
			object.state.recommendedUsername ~= nil
			and object.state.recommendedUsername ~= ""
			and object.state.hasEditedUsername == true
			and object.state.username == ""
			and data.username ~= ""
			and object.props.shouldSeeDisplayNamesOnSignup
		then
			module69(module20.ReccomendedNameManuallyCleared, 1)
		end

		if
			object.state.birthday ~= nil
			and data.birthday ~= nil
			and object.state.birthday ~= data.birthday
		then
			if defineFastInt <= object.getUserAge() and data.birthday:GetAgeInYears() < defineFastInt then
				module69(module20.BirthdayChangedToAboveDisplayAge, 1)
			end

			if object.getUserAge() < defineFastInt and defineFastInt <= data.birthday:GetAgeInYears() then
				module69(module20.BirthdayChangedToAboveDisplayAge, 1)
			end
		end
	end
end

function extended:shouldUseFoundationFields()
	local module70 = require("@luauforge/bundled/hBi")
	local v7 = self.props.shouldUseMinimalSignup and module37()
	local url = preAuthDeepLinkUrlStore.getUrl()
	local v8 = defineFastFlag7

	if v8 then
		v8 = not (url == nil) and url ~= ""
	end

	local v9 = not self.state.passkeysAvailable or v8
	local v10 = self.props.shouldUsePasswordlessSignup

	if module38() and self.props.shouldUsePasskeySignup and v9 then
		v10 = false
	end

	local v11 = not module44()

	if v11 then
		if self.props.shouldUseFoundationSignupFields == true and self.getBirthdayVariant() == 0 then
			v11 = not (self.useVerifiedSignup() or self.props.shouldSeeDisplayNamesOnSignup)
				and (module70 or v7 == true or v10 == true)
		else
			v11 = false
		end
	end

	return v11
end

function extended:render()
	if module33 and self.isAlreadyAuthenticated then
		local createElement = Roact.createElement
		local v8 = {
			style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
		}

		local v10 = if module44() then self:renderWithView() else self:renderDeprecated()
		return createElement(uiModeStyleProvider, v8, { Child = v10 })
	elseif module44() then
		return self:renderWithView()
	else
		return self:renderDeprecated()
	end
end

function extended:renderWithView()
	local isSignUpButtonEnabled = self.getIsSignUpButtonEnabled()

	return module5({})(function(p2)
		self.locale = p2[robloxLocaleIdKey]

		local createElement = Roact.createElement

		local v9 = if module34 or require("@luauforge/bundled/fTt") then self.onCloseButtonClicked else self.props.navigateBack
		return createElement(module17, {
			navigateBack = v9,
			useVerifiedSignup = self.useVerifiedSignup,
			useUsernameSuggestions = self.useUsernameSuggestions,
			useRefreshButton = self.useRefreshButton,
			onGenderChanged = self.onGenderChanged,
			getHidePassword = self.getHidePassword,
			passwordVisibilityToggleCallback = self.passwordVisibilityToggleCallback,
			onBirthdaySelected = self.onBirthdaySelected,
			onBirthdayFocused = self.onBirthdayFocused,
			onSignUpClick = self.onSignUpClick,
			usernameSuggestionClicked = self.usernameSuggestionClicked,
			usernameSuggestionsShown = self.usernameSuggestionsShown,
			shouldSuggest = self.shouldSuggest,
			updateIssueCondition = self.updateIssueCondition,
			updateSuggestionControlState = self.updateSuggestionControlState,
			logRefreshButtonClicked = self.logRefreshButtonClicked,
			loadSuggestions = self.loadSuggestions,
			finishSuggestions = self.finishSuggestions,
			validUsernameEntered = self.validUsernameEntered,
			validPasswordEntered = self.validPasswordEntered,
			onUsernameTextBoxFocused = self.onUsernameTextBoxFocused,
			onPasswordTextBoxFocused = self.onPasswordTextBoxFocused,
			onUsernameTextChanged = self.onUsernameTextChanged,
			onUsernameTextValidated = self.onUsernameTextValidated,
			onPasswordTextChanged = self.onPasswordTextChanged,
			onTextBoxFocusLost = self.onTextBoxFocusLost,
			onFocusedTextBoxPositionChanged = self.onFocusedTextBoxPositionChanged,
			onAnimationStateChangeCallback = self.onAnimationStateChangeCallback,
			onUsernameTextChangeCompletedFromKeyboard = self.onUsernameTextChangeCompletedFromKeyboard,
			onPasswordTextChangeCompletedFromKeyboard = self.onPasswordTextChangeCompletedFromKeyboard,
			phoneCountryCodeSelectorCallback = self.phoneCountryCodeSelectorCallback,
			SetContactMethod = self.SetContactMethod,
			SetPhoneNumber = self.SetPhoneNumber,
			SetEmail = self.SetEmail,
			isUsernameAnimating = self.state.isUsernameAnimating,
			isPasswordAnimating = self.state.isPasswordAnimating,
			birthday = self.state.birthday,
			username = self.state.username,
			isSignUpInProgress = self.state.isSignUpInProgress,
			onScreenKeyboardHeight = self.state.onScreenKeyboardHeight,
			usernameValid = self.state.usernameValid,
			passwordValid = self.state.passwordValid,
			issueCondition = self.state.issueCondition,
			loadingSuggestions = self.state.loadingSuggestions,
			isSignUpButtonEnabled = isSignUpButtonEnabled,
			birthdayFocused = self.state.birthdayFocused,
			isCountryCodeSearchVisible = self.state.isCountryCodeSearchVisible,
			contactMethod = self.state.contactMethod,
			signUpError = self.state.signUpError,
			UsernameValidator = module48,
			PasswordValidator = module49,
			signUpContentFrameRef = self.scrollingFrameRef,
			ageTextFieldRef = self.ageTextFieldRef,
			usernameTextFieldRef = self.usernameTextFieldRef,
			passwordTextFieldRef = self.passwordTextFieldRef,
			passwordFrameRef = self.passwordFrameRef,
			onSignUpContentFrameCanvasSizeChange = self.onSignUpContentFrameCanvasSizeChange,
			scrollCanvasTargetPositionY = self.scrollCanvasTargetPositionY,
			updateScrollCanvasTargetPositionY = self.updateScrollCanvasTargetPositionY,
			getScrollingFrameCanvasPosition = self.getScrollingFrameCanvasPosition
		})
	end)
end

function extended:renderDeprecated()
	local module70 = require("@luauforge/bundled/hAH")

	local birthday2 = self.state.birthday
	local username = self.state.username
	local isSignUpButtonEnabled = self.getIsSignUpButtonEnabled()
	local isSignUpInProgress = self.state.isSignUpInProgress
	local gender = self.state.gender
	local v7 = self.props.formFactor == formFactor.WIDE
	local isCompactView = self.props.isCompactView
	local v8 = 0
	local v9 = 0
	local v10 = self.state.onScreenKeyboardHeight > 0
	local contactMethod = self.state.contactMethod
	local foundationTokens = self.props.foundationTokens
	local shouldUseFoundationBackgroundColor = self.props.shouldUseFoundationBackgroundColor
	local shouldUseFoundationUsernameTextInput = self.props.shouldUseFoundationUsernameTextInput

	local username2 = getFFlagEnableTextFieldContentType() and Enum.TextInputType.Username
		or Enum.TextInputType.NoSuggestions
	local v11 = not self.validUsernameEntered()

	local v12 = self.useVerifiedSignup()
	local v13 = v7 and v12 and 12 or 0
	local v14 = "Authentication.SignUp.Label.ErrorsWithUsername"
	local v15 = "Authentication.SignUp.Label.ErrorsWithPassword"

	local v16 = self.useUsernameSuggestions()
	local v17 = self.useRefreshButton()

	local v18 = fFlagFoundationStylingOnSignUp and isCompactView

	if birthday2 then
		if
			defineFastFlag4
			and self.isDisplayNameFieldRequired()
			and not self.isValidDisplayNameEntered()
		then
			v15 = "Authentication.SignUp.Response.AgedUpDisplayNameSetFirst"
			v11 = true
		elseif v11 then
			v15 = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
		end
	else
		v14 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
		v15 = v14
		v11 = true
	end

	if v7 then
		if v10 then
			v8 = self.state.onScreenKeyboardHeight + 10
		else
			v8 = 48
			v9 = 24
		end
	end

	local default2 = if v18 then disclaimerLinksVariant.Default else nil

	local v19 = module37()
	local v20 = self.props.shouldUseMinimalSignup and v19
	local v21 = self.props.shouldHideGenderOption and v19
	local v22 = self.props.shouldAutofocusOnBirthday and v19

	local v23 = self.props.shouldUsePasswordlessSignup and true
	local shouldShowVNGAgreements = self.getShouldShowVNGAgreements()
	local shouldShowKISAAgreements = self.getShouldShowKISAAgreements()

	local url = preAuthDeepLinkUrlStore.getUrl()
	local v24 = defineFastFlag7

	if v24 then
		v24 = not (url == nil) and url ~= ""
	end

	local v25 = not self.state.passkeysAvailable or v24

	if module38() and self.props.shouldUsePasskeySignup and v25 then
		v23 = false
	end

	local shouldDisableUsernameAutofill = self.props.shouldDisableUsernameAutofill

	local v26 = module38()
	local v27 = self.props.shouldUsePasskeySignup
		and v26
		and game:GetEngineFeature("SignupActionRequiredKeyAvailable")
		and not v25

	local module71 = require("@luauforge/bundled/fTt")

	local module72 = require("@luauforge/bundled/hBi")
	local v28

	if module71 then
		v28 = self:shouldUseFoundationFields()
	else
		v28 = self.props.shouldUseFoundationSignupFields

		if v28 then
			if self.getBirthdayVariant() == 0 then
				v28 = not v12 and not self.props.shouldSeeDisplayNamesOnSignup and (module72 or v20 or v23)
			else
				v28 = false
			end
		end
	end

	local v29 = v18 or v28
	local v30 = shouldUseFoundationBackgroundColor or v28
	local v31 = require("@luauforge/bundled/hBk")() and v28
	local v32 = module72 and v28

	local v33 = if v28 then images["icons/navigation/pushBack"] else iconsnavigationclose

	local function getVerificationLinkingText(p2)
		local linkedPlatformAccountName = getLinkedPlatformAccountName(self.props.appPolicy)

		return linkedPlatformAccountName and {
			"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
			platform = linkedPlatformAccountName,
			ctaButton = p2
		} or nil
	end

	local v34 = module70(nil, v31)

	return withStyle(function(data)
		return module5({
			signUpHeadingText = v34.signUpHeading,
			signUpText = v34.signUpButton,
			continueText = "Authentication.SignUp.Action.Continue",
			usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
			agedUpUsernamePlaceholder = "Authentication.Login.Label.AgedUpUsername",
			passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
			autogeneratedUsernameGuidance = defineFastFlag4 and "Feature.DisplayName.Label.GeneratedUserName" or nil,
			usernameHelperTitleText = "Authentication.SignUp.Heading.PickAUsername",
			usernameHelperDescriptionText = "Authentication.SignUp.Description.UsernameHelp",
			signUpAgreementFullCopyCheckboxText = "Authentication.SignUp.Description.AgreeToTermsWithGuardian.NoParameters",
			signUpAgreementShortCopyCheckboxText = "Authentication.SignUp.Description.SignUpAgreement.ShortCopy"
		})(function(data2)
			self.locale = data2[robloxLocaleIdKey]

			local module73 = require("@luauforge/bundled/fTt")
			local v35, v36

			if module73 and v28 then
				v35, v36 = self.getSignupTelemetryStateAndOrigin()
			end

			local v37 = not v20
			local v38 = 38
			local v39 = 24
			local v40 = 5
			local v41 = v7 and 25 or 48
			local udim2 = UDim2.new(0.5, 0, 0, 49)

			if v28 then
				v39 = foundationTokens.Padding.XLarge
				v40 = foundationTokens.Gap.Small
				v38 = foundationTokens.Gap.Small
				v41 = foundationTokens.Padding.Medium
			elseif v18 then
				v41 += foundationTokens.Padding.Medium
				udim2 = UDim2.new(0.5, 0, 0, 1 + foundationTokens.Padding.Medium)
			end

			if defineFastFlag4 then
				v37 = self.shouldShowUsernameField() and not v20
			end

			local shouldRequireSignupCheckbox = not self.getSignupCheckboxDisabled()
				and self.props.shouldRequireSignupCheckbox
			local v42 = defineFastFlag9
				and "Authentication.SignUp.Description.SignUpAgreement.FullCopy.CreateAccount"
				or "Authentication.SignUp.Description.VerificationPage.CreateAccount"

			if v27 then
				v42 = "Authentication.SignUp.Description.VerificationPageMultiStep"
			else
				local signUpText = data2.signUpText
				local linkedPlatformAccountName = getLinkedPlatformAccountName(self.props.appPolicy)

				if linkedPlatformAccountName then
					local signUpText2 = data2.signUpText
					local linkedPlatformAccountName2 = getLinkedPlatformAccountName(self.props.appPolicy)

					v42 = linkedPlatformAccountName2 and {
						"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
						platform = linkedPlatformAccountName2,
						ctaButton = signUpText2
					} or nil
				end
			end

			local v43 = ""

			if not self.getSignupCheckboxDisabled() then
				if self.props.signupLegalDisclaimerTextVariant == 1 then
					if shouldRequireSignupCheckbox then
						v43 = data2.signUpAgreementFullCopyCheckboxText
					elseif v27 then
						v42 = "Authentication.SignUp.Description.SignUpAgreement.FullCopy.Continue"
					else
						v42 = "Authentication.SignUp.Description.SignupAgreement.FullCopy.CreateAccount"
					end
				elseif self.props.signupLegalDisclaimerTextVariant == 2 and shouldRequireSignupCheckbox then
					v43 = data2.signUpAgreementShortCopyCheckboxText
				end
			end

			local v44 = self.props.shouldShowBackButton == nil or self.props.shouldShowBackButton
			local v45

			if v31 then
				v45 = v44
				v44 = false
			else
				v45 = false
			end

			local createElement = Roact.createElement
			local v47 = {
				BackgroundTransparency = 1,
				includeStatusBar = true,
				buttonRef = self.props.containerRef,
				renderFullscreenBackground = function()
					local createElement2 = Roact.createElement
					local v49 = { showImage = v7, fallbackBackgroundColor = 0 }

					local v50 = if v30 then foundationTokens.Color.Surface.Surface_0.Color3 else data.Theme.BackgroundUIDefault.Color
					v49.fallbackBackgroundColor = v50
					return createElement2(authBackgroundContainer, v49)
				end
			}

			local v48 = {
				UserInputSink = isSignUpInProgress and Roact.createElement("ImageButton", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = ""
				}),
				UnderAgeAlert = self.state.shouldShowUnderAgeAlert and Roact.createElement(module6, {
					ZIndex = 3,
					onDismiss = function()
						self:setState({ shouldShowUnderAgeAlert = false })
					end
				}),
				Container = 0
			}

			local createElement2 = Roact.createElement
			local v50 = {
				Size = UDim2.new(1, 0, 1, -v8),
				Position = UDim2.new(0.5, 0, 0, v9),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = 0,
				ClipsDescendants = true
			}

			local v51 = if v30 then foundationTokens.Color.Surface.Surface_0.Color3 else data.Theme.BackgroundUIDefault.Color
			v50.ImageColor3 = v51

			local children = {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = vector2
				}),
				HeaderFrame = 0,
				Divider = 0,
				SignUpContentFrame = 0,
				Footer = 0
			}

			local createElement3 = Roact.createElement
			local v53 = {
				Size = UDim2.new(1, 0, 0, 48),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1
			}

			if v44 then
				v44 = Roact.createElement(imageSetButton, {
					Size = udim,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Image = v33,
					ImageColor3 = data.Theme.UIEmphasis.Color,
					ImageTransparency = 0,
					[Roact.Event.Activated] = self.onCloseButtonClicked,
					[Roact.Ref] = self.backButtonRef
				})
			end

			local v54 = {
				BackButton = v44,
				FoundationBackButton = v45 and Roact.createElement(Foundation.IconButton, {
					icon = Foundation.Enums.IconName.ChevronLargeLeft,
					variant = Foundation.Enums.ButtonVariant.Utility,
					size = inputSize.Medium,
					isCircular = true,
					onActivated = self.onCloseButtonClicked,
					Position = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					testId = "--auth-signup-back-button",
					ref = self.backButtonRef
				}),
				Title = 0
			}

			local v55 = data2.signUpHeadingText

			if v55 then
				if v29 then
					v55 = Roact.createElement(text, {
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Text = data2.signUpHeadingText or "",
						fontStyle = foundationTokens.Typography.HeadingSmall,
						TextXAlignment = Enum.TextXAlignment.Center
					})
				else
					local createElement4 = Roact.createElement
					local v57 = {
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						fitAxis = 0,
						width = 0,
						BackgroundTransparency = 1,
						Text = 0,
						TextWrapped = true,
						Font = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextXAlignment = 0
					}
					local v58 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
					v57.fitAxis = v58
					local v59 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
					v57.width = v59

					v57.Text = data2.signUpHeadingText or ""

					local v60 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font) else data.Font.CaptionHeader.Font
					v57.Font = v60

					v57.TextSize = data.Font.BaseSize * data.Font.Header1.RelativeSize
					v57.TextColor3 = data.Theme.TextEmphasis.Color
					v57.TextTransparency = data.Theme.TextEmphasis.Transparency
					v57.TextXAlignment = Enum.TextXAlignment.Center
					v55 = createElement4(v5, v57)
				end
			end

			v54.Title = v55
			children.HeaderFrame = createElement3("Frame", v53, v54)

			children.Divider = not v29 and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 48),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = v30 and 1 or 0,
				BackgroundColor3 = data.Theme.UIEmphasis.Color
			})

			local createElement4 = Roact.createElement
			local fitScrollingFrame = FitChildren.FitScrollingFrame
			local v56 = {
				Size = UDim2.new(1, 0, 1, -(49 + v13)),
				Position = udim2,
				AnchorPoint = Vector2.new(0.5, 0),
				fitFields = { CanvasSize = FitChildren.FitAxis.Height },
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				ScrollingEnabled = true,
				CanvasPosition = self.scrollCanvasTargetPositionY:map(function(p2)
					return self.getScrollingFrameCanvasPosition(p2)
				end),
				[Roact.Ref] = self.scrollingFrameRef,
				[Roact.Change.CanvasSize] = function(p2)
					local value = self.scrollCanvasTargetPositionY:getValue()
					self.scrollingFrameRef.current.CanvasPosition = self.getScrollingFrameCanvasPosition(value)
				end
			}
			local v57 = {
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v39),
					PaddingRight = UDim.new(0, v39),
					PaddingTop = UDim.new(0, v41)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v40)
				}),
				BirthdayBar = self.getBirthdayVariant() == 0 and Roact.createElement(module9, {
					layoutOrder = 1,
					onBirthdaySelected = self.onBirthdaySelected,
					onBirthdayFocused = self.onBirthdayFocused,
					autoFocusOnMount = v12 or v22,
					buttonRef = self.props.defaultRef,
					preferredInput = self.props.preferredInput,
					birthdayContainerRef = self.props.birthdayContainerRef,
					forceDarkTheme = module33 and self.isAlreadyAuthenticated,
					enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
					useFoundationField = v28,
					boldFoundationLabel = v31 and true or nil,
					hideAgeInLabel = v31 and true or nil
				}),
				AgeInput = self.getBirthdayVariant() ~= 0 and Roact.createElement(module15, {
					layoutOrder = 1,
					variant = self.getBirthdayVariant(),
					textInputHeight = 36,
					hasBirthdayError = self.state.birthdayValid == LinkStatus.Invalid,
					onAgeChange = self.onAgeChanged,
					onAgeAndMonthChange = self.onAgeAndMonthChanged,
					onMonthAndYearChange = self.onMonthAndYearChanged,
					ageTextFieldRef = self.ageTextFieldRef,
					screenSize = self.props.screenSize
				}),
				ContactInfoField = v12 and Roact.createElement(module14, {
					layoutOrder = 2,
					Under13 = birthday2 and dateHelper:isRecentOrFutureDate(
						birthday2.Month,
						birthday2.Day,
						birthday2.Year + 13
					),
					SetContactMethod = self.SetContactMethod,
					SetPhoneNumber = self.SetPhoneNumber,
					SetEmail = self.SetEmail,
					contactMethod = contactMethod,
					phoneCountryCodeSelectorCallback = self.phoneCountryCodeSelectorCallback
				}),
				BackgroundPanel = v12 and Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 6),
						LayoutOrder = 3,
						BackgroundTransparency = 1
					},
					{
						LightPanel = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(0, 100000, 0, 100000),
							Position = UDim2.new(0, 0, 1, 0),
							BackgroundColor3 = data.Theme.UIDefault.Color,
							AnchorPoint = Vector2.new(0.5, 0)
						})
					}
				),
				DisplayName = 0,
				UsernameValidator = 0,
				UsernameGuidanceText = 0,
				SuggestionsFrame = 0,
				PasswordValidator = 0,
				GenderSelector = 0,
				Spacing = 0,
				SignUpButton = 0,
				CheckboxContainer = 0,
				DisclaimerText = 0,
				DisclaimerLinks = 0,
				ScrollPadding = 0
			}

			local v60 = if defineFastFlag4 and self.shouldShowDisplayNameField() then React.createElement(module18, {
				authEventAnalytics = self.props.authEventAnalytics,
				birthday = not birthday2 and "" or birthday2:FormatForEndpoint(),
				bypassDisplayNameField = self.state.bypassDisplayNameField,
				focusedTextBoxPositionChangedCallback = self.onFocusedTextBoxPositionChanged,
				layoutOrder = 4,
				onAnimationStateChangeCallback = self.onAnimationStateChangeCallback,
				onDisplayNameTextChanged = self.onDisplayNameTextChanged,
				onReturnPressedFromOnScreenKeyboard = self.onDisplayNameTextChangeCompletedFromKeyboard,
				pillClicked = self.state.pillClicked,
				resetPillClicked = self.resetPillClicked,
				returnKeyType = Enum.ReturnKeyType.Next,
				setUsernameRecommendation = self.setUsernameRecommendation,
				shouldDisableRecommendation = self.state.hasEditedUsername,
				textBoxFocusedCallback = self.onDisplayNameTextBoxFocused,
				textBoxFocusLostCallback = self.onTextBoxFocusLost,
				textBoxRef = self.displayNameTextFieldRef,
				updateBypassDisplayNameField = self.updateBypassDisplayNameField,
				updatePillClicked = self.updatePillClicked
			}) else nil
			v57.DisplayName = v60
			local v61

			if v37 then
				local createElement5 = Roact.createElement
				local v63 = {}
				v63.layoutOrder = defineFastFlag4 and 5 or 4
				v63.titleTextKey = "Authentication.Login.Label.Username"
				v63.summaryErrorTextKey = v14
				v63.prerequisiteMet = birthday2 and true or false
				v63.textInputType = if not shouldDisableUsernameAutofill then username2 else nil
				v63.onInputTextChanged = self.onUsernameTextChanged
				v63.onInputTextValidated = v16 and self.onUsernameTextValidated
					or self.onUsernameTextChanged
				v63.validator = module48
				local v65 = if defineFastFlag4 then self.state.recommendedUsername else nil
				v63.prefilledText = v65

				local v66 = if defineFastFlag4 then self.getUsernamePlaceholder(data2) else data2.usernamePlaceholder
				v63.placeholderText = v66

				v63.validatorAdditionalProps = {
					birthday = birthday2 and birthday2:FormatForEndpoint() or "",
					context = module24.Signup
				}

				v63.textBoxFocusedCallback = self.onUsernameTextBoxFocused

				local v67 = if defineFastFlag4 then self.onUsernameTextBoxFocusLost else self.onTextBoxFocusLost
				v63.textBoxFocusLostCallback = v67

				v63.focusedTextBoxPositionChangedCallback = self.onFocusedTextBoxPositionChanged
				v63.returnKeyType = Enum.ReturnKeyType.Next
				v63.onReturnPressedFromOnScreenKeyboard = self.onUsernameTextChangeCompletedFromKeyboard
				v63.onAnimationStateChangeCallback = self.onAnimationStateChangeCallback
				v63.textBoxRef = self.usernameTextFieldRef
				v63.pillClicked = self.state.pillClicked
				v63.updatePillClicked = self.updatePillClicked
				v63.resetPillClicked = self.resetPillClicked
				v63.issueCondition = self.state.issueCondition
				v63.updateIssueCondition = self.updateIssueCondition
				v63.loadingSuggestions = self.state.loadingSuggestions

				v63.paddingBottomOverride = v28 and 0
					or defineFastFlag4
					and self.props.shouldSeeDisplayNamesOnSignup
					and self.getUsernameGuidanceText(data2)
					and -5
					or nil

				v63.enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
				v63.useFoundationTextInput = (shouldUseFoundationUsernameTextInput or v28) and true or nil

				v63.useFoundationTitle = v28
				v63.foundationTitleIsRequired = v28
				v63.foundationTitleIsBold = v31 and true or nil
				local v68 = if v28 then inputSize.Large else nil
				v63.foundationInputSize = v68
				local v69 = if v28 then foundationTokens.Gap.Small else nil
				v63.paddingTopOverride = v69
				local v70 = if v28 then foundationTokens.Gap.Small else nil
				v63.contentGapOverride = v70
				v61 = createElement5(module10, v63)
			else
				v61 = v37
			end

			v57.UsernameValidator = v61
			local v62

			if
				defineFastFlag4
				and self.props.shouldSeeDisplayNamesOnSignup
				and self.getUsernameGuidanceText(data2)
			then
				local createElement5 = Roact.createElement
				local v64 = {
					Size = UDim2.new(1, 0, 0, 1),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 5
				}

				local v65 = {
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 5)
					}),
					Label = 0
				}

				local createElement6 = Roact.createElement
				local v67 = {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Font = 0,
					FontFace = 0,
					Size = 0,
					Text = 0,
					TextColor3 = 0,
					TextSize = 0,
					TextWrapped = true,
					TextXAlignment = 0,
					TextYAlignment = 0
				}

				local v68 = if not foundationFontFaceMigration then data.Font.CaptionBody.Font else nil
				v67.Font = v68

				local v69 = if foundationFontFaceMigration then normalizeFontFace(foundationTokens.Typography.BodySmall.Font) else nil
				v67.FontFace = v69

				v67.Size = UDim2.new(1, 0, 0, 0)
				v67.Text = self.getUsernameGuidanceText(data2)
				v67.TextColor3 = data.Theme.TextDefault.Color
				v67.TextSize = data.Font.BaseSize * data.Font.CaptionBody.RelativeSize

				v67.TextXAlignment = Enum.TextXAlignment.Left
				v67.TextYAlignment = Enum.TextYAlignment.Top
				v65.Label = createElement6("TextLabel", v67)
				v62 = createElement5("Frame", v64, v65)
			end

			v57.UsernameGuidanceText = v62

			local v63 = v37 and v16

			if v63 then
				local createElement5 = Roact.createElement
				local v65 = {
					layoutOrder = defineFastFlag4 and 5 or 4,
					textBoxRef = self.usernameTextFieldRef,
					usernameText = 0,
					usernameValid = 0,
					birthday = 0,
					suggest = 0,
					context = 0,
					pillClicked = 0,
					updatePillClicked = 0,
					resetPillClicked = 0,
					issueCondition = 0,
					usernameSuggestionClicked = 0,
					usernameSuggestionsShown = 0,
					shouldSuggest = 0,
					updateSuggestionControlState = 0,
					useRefreshButton = 0,
					logRefreshButtonClicked = 0,
					loadSuggestions = 0,
					finishSuggestions = 0,
					loadingSuggestions = 0,
					padding = 0
				}
				local v66 = if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAuthValidatorRebindTextBoxRef then username else nil
				v65.usernameText = v66

				v65.usernameValid = self.state.usernameValid
				v65.birthday = birthday2 and birthday2:FormatForEndpoint() or ""
				v65.suggest = module63
				v65.context = module24.Signup
				v65.pillClicked = self.state.pillClicked
				v65.updatePillClicked = self.updatePillClicked
				v65.resetPillClicked = self.resetPillClicked
				v65.issueCondition = self.state.issueCondition
				v65.usernameSuggestionClicked = self.usernameSuggestionClicked
				v65.usernameSuggestionsShown = self.usernameSuggestionsShown
				v65.shouldSuggest = self.shouldSuggest
				v65.updateSuggestionControlState = self.updateSuggestionControlState
				v65.useRefreshButton = v17
				v65.logRefreshButtonClicked = self.logRefreshButtonClicked
				v65.loadSuggestions = self.loadSuggestions
				v65.finishSuggestions = self.finishSuggestions
				v65.loadingSuggestions = self.state.loadingSuggestions
				v65.padding = {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}
				v63 = createElement5(module16, v65)
			end

			v57.SuggestionsFrame = v63

			local v64 = not (v20 or v23)

			if v64 then
				local createElement5 = Roact.createElement
				local v66 = {
					disabled = self.state.birthdayFocused,
					layoutOrder = defineFastFlag4 and 6 or 5,
					titleTextKey = "CommonUI.Messages.Label.Password",
					summaryErrorTextKey = v15,
					prerequisiteMet = not v11,
					textInputType = 0,
					useFoundationTextInput = 0,
					useFoundationTitle = 0,
					foundationTitleIsRequired = 0,
					foundationTitleIsBold = 0,
					foundationInputSize = 0,
					foundationIconTrailing = 0,
					paddingTopOverride = 0,
					paddingBottomOverride = 0,
					contentGapOverride = 0,
					onInputTextChanged = 0,
					onInputTextValidated = 0,
					validator = 0,
					placeholderText = 0,
					validatorAdditionalProps = 0,
					returnKeyType = 0,
					textBoxFocusedCallback = 0,
					textBoxFocusLostCallback = 0,
					focusedTextBoxPositionChangedCallback = 0,
					onReturnPressedFromOnScreenKeyboard = 0,
					onAnimationStateChangeCallback = 0,
					textBoxRef = 0,
					centralOverlayBlocksInput = 0,
					captureFocusOnTapStart = 0
				}

				local v67 = if v32 and not self.getHidePassword() then engineFeature and Enum.TextInputType.NewPasswordShown or Enum.TextInputType.PasswordShown else engineFeature and Enum.TextInputType.NewPassword or Enum.TextInputType.Password
				v66.textInputType = v67

				v66.useFoundationTextInput = v32 and true or nil
				v66.useFoundationTitle = v32 and true or nil
				v66.foundationTitleIsRequired = v32 and true or nil
				v66.foundationTitleIsBold = v32 and v31 and true or nil

				local v68 = if v32 then inputSize.Large else nil
				v66.foundationInputSize = v68
				local v69

				if v32 then
					v69 = { name = 0, onActivated = 0 }
					local v70 = if self.getHidePassword() then AuthCommon.Common.UIConstants.HIDE_PASSWORD_ICON else AuthCommon.Common.UIConstants.SHOW_PASSWORD_ICON
					v69.name = v70

					v69.onActivated = self.passwordVisibilityToggleCallback
				end

				v66.foundationIconTrailing = v69

				local v70 = if v32 then foundationTokens.Gap.Small else nil
				v66.paddingTopOverride = v70

				v66.paddingBottomOverride = v32 and 0 or nil

				local v71 = if v32 then foundationTokens.Gap.Small else nil
				v66.contentGapOverride = v71

				v66.onInputTextChanged = self.onPasswordTextChanged
				v66.onInputTextValidated = self.onPasswordTextChanged
				v66.validator = module49
				v66.placeholderText = data2.passwordPlaceholder
				v66.validatorAdditionalProps = { username = username }

				v66.returnKeyType = Enum.ReturnKeyType.Next
				v66.textBoxFocusedCallback = self.onPasswordTextBoxFocused
				v66.textBoxFocusLostCallback = self.onTextBoxFocusLost
				v66.focusedTextBoxPositionChangedCallback = self.onFocusedTextBoxPositionChanged
				v66.onReturnPressedFromOnScreenKeyboard = self.onPasswordTextChangeCompletedFromKeyboard
				v66.onAnimationStateChangeCallback = self.onAnimationStateChangeCallback
				v66.textBoxRef = self.passwordTextFieldRef
				v66.centralOverlayBlocksInput = v12
				v66.captureFocusOnTapStart = not self.state.isCountryCodeSearchVisible
				v64 = createElement5(module10, v66)
			end

			v57.PasswordValidator = v64

			local v65 = not v21

			if v65 then
				if module39() == 2 then
					v65 = false
				else
					local createElement5 = Roact.createElement
					local v67 = {
						layoutOrder = defineFastFlag4 and 8 or 7,
						gender = gender,
						onGenderChanged = self.onGenderChanged,
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
						useFoundationChips = v28,
						boldFoundationLabel = v31 and true or nil,
						getIsAltAttempt = 0
					}

					local v68 = if module73 then self.getIsAltAttempt else nil
					v67.getIsAltAttempt = v68
					v65 = createElement5(module11, v67)
				end
			end

			v57.GenderSelector = v65

			v57.Spacing = Roact.createElement("Frame", {
				LayoutOrder = defineFastFlag4 and 9 or 8,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v38)
			})
			local v66

			if v29 then
				local createElement5 = Roact.createElement
				local button2 = Foundation.Button
				local v67 = {
					testId = "--auth-signup-button-sign-up",
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					LayoutOrder = defineFastFlag4 and 10 or 9,
					text = 0,
					size = 0,
					width = 0,
					isDisabled = 0,
					isLoading = 0,
					onActivated = 0
				}

				local v68 = if v27 then data2.continueText else data2.signUpText
				v67.text = v68

				local v69 = if v28 then inputSize.Large else inputSize.Medium
				v67.size = v69
				v67.width = UDim.new(1, 0)
				v67.isDisabled = not isSignUpButtonEnabled
				v67.isLoading = isSignUpInProgress
				v67.onActivated = self.onSignUpClick
				v66 = createElement5(button2, v67)
			else
				local createElement5 = Roact.createElement
				local v68 = {
					buttonType = buttonType.PrimaryContextual,
					layoutOrder = defineFastFlag4 and 10 or 9,
					size = UDim2.new(1, 0, 0, 36),
					text = 0,
					isDisabled = 0,
					isLoading = 0,
					onActivated = 0
				}

				local v69 = if v27 then data2.continueText else data2.signUpText
				v68.text = v69

				v68.isDisabled = not isSignUpButtonEnabled
				v68.isLoading = isSignUpInProgress
				v68.onActivated = self.onSignUpClick
				v66 = createElement5(button, v68)
			end

			v57.SignUpButton = v66

			v57.CheckboxContainer = shouldRequireSignupCheckbox and React.createElement(view, {
				tag = "auto-xy padding-x-xxlarge padding-y-large row gap-medium",
				LayoutOrder = defineFastFlag4 and 11 or 10
			}, {
				SignUpAgreementCheckbox = React.createElement(checkbox, {
					testId = "--auth-signup-checkbox-agreement",
					isChecked = self.state.signupAgreementsChecked,
					isDisabled = false,
					onActivated = function()
						self.props.authEventAnalytics.reportAuthFormInteraction(
							module25.Context.SinglePageSignUpScreen,
							module25.Field.TosCheckbox,
							(tostring(not self.state.signupAgreementsChecked))
						)

						self:setState({
							signupAgreementsChecked = not self.state.signupAgreementsChecked
						})
					end,
					size = inputSize.Small,
					LayoutOrder = 1,
					label = ""
				}),
				Text = React.createElement(text, {
					tag = "text-body-small text-align-x-left text-wrap auto-xy shrink",
					LayoutOrder = 2,
					Text = v43
				})
			})

			local v67 = not (shouldShowVNGAgreements or shouldShowKISAAgreements or shouldRequireSignupCheckbox)

			if v67 then
				if v28 then
					local createElement5 = Roact.createElement
					local disclaimerTextWithLinks = AuthCommon.Components.DisclaimerTextWithLinks
					local v68 = {
						LayoutOrder = defineFastFlag4 and 11 or 10,
						textKey = "Authentication.SignUp.Description.SignUpAgreement.CreateAnAccount",
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
						ctx = 0,
						state = 0,
						origin = 0
					}

					local v69 = if module73 then module25.Context.SinglePageSignUpScreen else nil
					v68.ctx = v69

					v68.state = v35
					v68.origin = v36
					v67 = createElement5(disclaimerTextWithLinks, v68)
				else
					v67 = Roact.createElement(module12, {
						layoutOrder = defineFastFlag4 and 11 or 10,
						textXAlignment = Enum.TextXAlignment.Center,
						paragraphTextKeys = { v42 },
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
					})
				end
			end

			v57.DisclaimerText = v67

			local v68 = not (shouldShowVNGAgreements or shouldShowKISAAgreements)
				and ((not v28 or shouldRequireSignupCheckbox) and true or false)

			if v68 then
				v68 = Roact.createElement(module13, {
					LayoutOrder = defineFastFlag4 and 12 or 11,
					variant = if fFlagFoundationStylingOnSignUp then default2 else nil,
					enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
				})
			end

			v57.DisclaimerLinks = v68

			v57.ScrollPadding = v10 and Roact.createElement("Frame", {
				LayoutOrder = defineFastFlag4 and 13 or 12,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, self.state.onScreenKeyboardHeight * 2)
			})
			children.SignUpContentFrame = createElement4(fitScrollingFrame, v56, v57)

			children.Footer = v12
				and v7
				and Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 12),
						Position = UDim2.new(0, 0, 1, -12),
						BackgroundTransparency = 1,
						ClipsDescendants = true
					},
					{
						Rounding = Roact.createElement(imageSetLabel, {
							Size = UDim2.new(1, 0, 2, 0),
							Position = UDim2.new(0, 0, -1, 0),
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(9, 9, 9, 9),
							Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
							ImageColor3 = data.Theme.UIDefault.Color
						})
					}
				)
			v48.Container = createElement2(imageSetLabel, v50, children)
			return createElement(module8, v47, v48)
		end)
	end)
end

local v7 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end, function(callback)
	return {
		signUp = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
			return callback(module53(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
		end,
		agreeToPhoneNumberVerification = function(p2, p3, p4)
			return callback(module64({
				verificationChallengeCallback = p3,
				phoneNumber = p4
			}))
		end,
		openKISAUserAgreements = function(p2)
			analyticsEvents.sendPageLoadEvent(
				eventConstants.ctx.kisaAgreements,
				eventConstants.origin.signup
			)
			return callback(module61(p2))
		end,
		setBackNavigationDisabled = function(p2)
			return module45.setDisabled(p2)
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end,
		showErrorToast = function()
			return callback(module67({ HttpError = Enum.HttpError.OK }))
		end,
		verifyPhoneNumber = function(p2, p3, p4, p5, p6, p7)
			return callback(module65({
				verifyPhoneNumberCallback = p3,
				phoneNumber = p5,
				deliveryTarget = p6,
				challenge = p4,
				useEmailOptionClickedCallback = p7
			}))
		end,
		showErrorMessageToast = function(p2)
			return callback(module68({
				toastType = module23.NetworkingError,
				toastMessage = p2
			}))
		end,
		showVNGUserAgreementsPopup = function(p2, p3, p4)
			return callback(module47(
				module21.VNGUserAgreementsPopup,
				{
					agreements = p2,
					isSignup = true,
					agreementAccepted = p3,
					agreementDeclined = p4
				},
				{ DisableBackButtonClose = true }
			))
		end,
		showVNGDCForm = function()
			callback(module47(module21.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end,
		closeCentralOverlay = function()
			return callback(module57())
		end,
		openAccountSwitchingErrorOverlay = function(p2, p3, p4, p5, p6, p7, p8, p9)
			return callback(module56(p2, p3, p4, p5, p6, p7, p8, p9, true))
		end,
		resetAppState = function()
			return callback(module59())
		end,
		logoutWithoutShowConfirmation = function(p2, p3)
			return callback(module60(p2, p3))
		end,
		openEmailOtp = function(p2)
			callback(module62(p2))
		end,
		showAccountLinkingAlert = function(p2)
			return callback(module47(module21.AccountLinkingAlert, { alertType = p2 }))
		end
	}
end)(extended)

local v8 = roactServices.connect({
	networking = module3,
	guiService = appGuiService,
	authEventAnalytics = module,
	analytics = module2,
	loggingProtocol = appLogging
})(v7)

local v9 = roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v8)

local v10 = RoactAppExperiment.connectBrowserTrackerLayer(
	{ appBtidLayers.SignupLayer, appBtidLayers.IosPasswordSavingLayer },
	function(p2, p3)
		local v11 = p2[appBtidLayers.SignupLayer] or {}
		local v12 = p2[appBtidLayers.IosPasswordSavingLayer] or {}

		local v13 = if defineFastFlag4 then v11.shouldSeeDisplayNamesOnSignup else nil

		return {
			useVerifiedSignupPage = v11.contactMethodRequired,
			arePasswordFieldsPlaintext = v11.ArePasswordFieldsPlaintext,
			shouldUseUsernameSuggestions = v11.usernameSuggestionsEnabled,
			enableRefreshButton = v11.suggestionRefreshButtonEnabled,
			shouldUseMinimalSignup = v11.shouldUseMinimalSignup,
			shouldHideGenderOption = v11.shouldHideGenderOption,
			shouldAutofocusOnBirthday = v11.shouldAutofocusOnBirthday,
			shouldUsePasswordlessSignup = v11.shouldUsePasswordlessSignup,
			shouldUsePasskeySignup = v11.shouldUsePasskeySignup,
			shouldAutomaticallyPromptForPasskey = v11.shouldAutomaticallyPromptForPasskey,
			shouldTightenPasskeyEligibility = v11.shouldTightenPasskeyEligibility,
			birthdayPickerVariant = v11.birthdayPickerVariant,
			shouldSeeDisplayNamesOnSignup = defineFastFlag5 and true or v13,
			shouldShowKoreanKISASignUpFlow = v11.shouldShowKoreanKISASignUpFlow,
			shouldSkipVPCSignupFlow = v11.shouldSkipVPCSignupFlow,
			shouldDisableUsernameAutofill = v11.shouldDisableUsernameAutofill,
			shouldRequireSignupCheckbox = v11.shouldRequireSignupCheckbox,
			signupLegalDisclaimerTextVariant = v11.signupLegalDisclaimerTextVariant,
			isIosAuthServiceEnabled = v12.enableNewIosPasswordSaving or false
		}
	end
)(v9)

local v11 = withNavigationProps(function(p2, p3)
	return p3
end)(v10)

local function SinglePageSignUpWithAuditContent(p2)
	local v12 = auditContentContext.useAuditContentContext()

	return Roact.createElement(
		v11,
		Cryo.Dictionary.join(p2, {
			capturedAuditContent = v12.capturedAuditContent,
			additionalAuditContent = v12.additionalAuditContent
		})
	)
end

return function(p2)
	local v12 = ReactFocusNavigation.useFocusedGuiObject()
	local v13 = ReactFocusNavigation.useFocusGuiObject()
	local v14 = if defineFastFlag8 then useBreakpointXOrSmaller(Responsive.Keys.Medium) else nil
	local joined = useTokens()
	local v15

	if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAccountSwitcherForceDarkAuthTheme then
		v15 = React.useState(function()
			return module33 and Models.fromLocalStorage().userId ~= -1
		end)
	else
		v15 = false
	end

	if joined and (game:DefineFastFlag("SignupFoundationBackgroundDarkFix", false) or v15) then
		joined = Cryo.Dictionary.join(joined, {
			Color = Foundation.Utility.getTokens(Foundation.Enums.ColorMode.Dark).Color
		})
	end

	local v16 = RoactAppExperiment.useBrowserTrackerExperiment(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p3)
			local v17 = p3[appBtidLayers.AuthenticationStylingLayer] or {}
			return {
				shouldUseFoundationBackgroundColor = v17.shouldUseFoundationBackgroundColor,
				shouldUseFoundationUsernameTextInput = v17.shouldUseFoundationUsernameTextInput
			}
		end
	)

	local shouldUseFoundationBackgroundColor = v16.shouldUseFoundationBackgroundColor
	local shouldUseFoundationUsernameTextInput = getFFlagAuthCollapsingValidatorFoundationInput()
		and v16.shouldUseFoundationUsernameTextInput

	local module70 = require("@luauforge/bundled/fUj")
	local module71 = require("@luauforge/bundled/hBk")
	local v17

	if module70 then
		local platform = if module71() and p2.platform then p2.platform else UserInputService:GetPlatform()
		v17 = AuthCommon.Experiments.useAuthEntryVariant(platform) ~= AuthCommon.Experiments.AuthEntryVariant.Control
			and (platform == Enum.Platform.IOS or platform == Enum.Platform.Android)
	else
		v17 = false
	end

	local state, setState = React.useState(false)

	local v18 = usePreferredInput()
	local v19 = v18 == Responsive.Input.Directional

	local v20 = useDispatch()
	local v21 = React.useCallback(function()
		if not v19 then
			return
		end

		if state then
			v20(module47(module21.SignUpExitModal, {
				onClose = function()
					v20(module57())
					v20(function()
						v13(v12)
					end)
				end,
				onConfirm = function()
					v20(module57())

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back()
					else
						v20(RobloxAppToastsRodux())
					end
				end
			}))
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v20(RobloxAppToastsRodux())
		end
	end, { state, v19, v12, v13, v20 })

	if not v19 then
		v21 = nil
	end

	local v23 = useSignUpPageNavigationBindings(v21)

	local v24, v25 = ReactFocusNavigation.useDefaultFocusBehavior(v23)

	local ref = React.useRef(nil)

	if getFFlagEnableAuditForSinglePageSignUp() then
		local createElement = Roact.createElement
		local provider = auditContentContext.Provider
		local createElement2 = Roact.createElement

		local join = Cryo.Dictionary.join
		local v29 = {
			signUpStarted = if v19 then state else nil,
			setSignUpStarted = nil,
			shouldShowBackButton = nil,
			preferredInput = nil,
			focusedGuiObject = nil,
			focusGuiObject = nil,
			defaultRef = nil,
			containerRef = nil,
			birthdayContainerRef = nil,
			isCompactView = nil,
			foundationTokens = nil,
			shouldUseFoundationBackgroundColor = nil,
			shouldUseFoundationSignupFields = nil,
			shouldUseFoundationUsernameTextInput = nil
		}

		if not v19 then
			setState = nil
		end

		v29.setSignUpStarted = setState
		v29.shouldShowBackButton = not v19
		v29.preferredInput = v18
		v29.focusedGuiObject = v12
		v29.focusGuiObject = v13
		v29.defaultRef = v24
		v29.containerRef = v25
		v29.birthdayContainerRef = ref
		v29.isCompactView = v14
		v29.foundationTokens = joined
		v29.shouldUseFoundationBackgroundColor = shouldUseFoundationBackgroundColor
		v29.shouldUseFoundationSignupFields = v17
		v29.shouldUseFoundationUsernameTextInput = shouldUseFoundationUsernameTextInput
		return createElement(provider, nil, {
			SignUpPage = createElement2(SinglePageSignUpWithAuditContent, join(p2, v29))
		})
	else
		local createElement = Roact.createElement

		local join = Cryo.Dictionary.join
		local v27 = {
			signUpStarted = if v19 then state else nil,
			setSignUpStarted = nil,
			shouldShowBackButton = nil,
			preferredInput = nil,
			focusedGuiObject = nil,
			focusGuiObject = nil,
			defaultRef = nil,
			containerRef = nil,
			birthdayContainerRef = nil,
			isCompactView = nil,
			foundationTokens = nil,
			shouldUseFoundationBackgroundColor = nil,
			shouldUseFoundationSignupFields = nil,
			shouldUseFoundationUsernameTextInput = nil
		}

		if not v19 then
			setState = nil
		end

		v27.setSignUpStarted = setState
		v27.shouldShowBackButton = not v19
		v27.preferredInput = v18
		v27.focusedGuiObject = v12
		v27.focusGuiObject = v13
		v27.defaultRef = v24
		v27.containerRef = v25
		v27.birthdayContainerRef = ref
		v27.isCompactView = v14
		v27.foundationTokens = joined
		v27.shouldUseFoundationBackgroundColor = shouldUseFoundationBackgroundColor
		v27.shouldUseFoundationSignupFields = v17
		v27.shouldUseFoundationUsernameTextInput = shouldUseFoundationUsernameTextInput
		return createElement(v11, join(p2, v27))
	end
end
