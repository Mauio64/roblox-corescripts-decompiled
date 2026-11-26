local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local module = require("@luauforge/bundled/grb")
local module2 = require("@luauforge/bundled/ecq")
local module3 = require("@luauforge/bundled/egx")

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
local module5 = require("@luauforge/bundled/egZ")
local withNavigationProps = require("@luauforge/bundled/dFz").withNavigationProps

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
local module6 = require("@luauforge/bundled/hLE")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local module8 = require("@luauforge/bundled/ect")
local module9 = require("@luauforge/bundled/gyM")
local module10 = require("@luauforge/bundled/gyP")
local module11 = require("@luauforge/bundled/gyQ")
local module12 = require("@luauforge/bundled/gyI")
local module13 = require("@luauforge/bundled/grz")
local module14 = require("@luauforge/bundled/hLF")
local module15 = require("@luauforge/bundled/hLH")
local module16 = require("@luauforge/bundled/hLL")
local module17 = require("@luauforge/bundled/hLO")
local module18 = require("@luauforge/bundled/hMc")
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
local kisaComplianceUtils = require("@luauforge/bundled/gvl").KISAComplianceUtils
local analyticsEvents = require("@luauforge/bundled/gvl").Analytics.AnalyticsEvents
local eventConstants = require("@luauforge/bundled/gvl").Analytics.EventConstants
local telemetryConfigs = require("@luauforge/bundled/fzT").TelemetryConfigs
local events = require("@luauforge/bundled/fzT").Events
local eventStreamConstants = require("@luauforge/bundled/fzT").EventStreamConstants
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore

local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local robloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/Localization").RobloxLocaleIdKey
local module20 = require("@luauforge/bundled/hMg")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module21 = require("@luauforge/bundled/ehl")
local module22 = require("@luauforge/bundled/gfK")
local module23 = require("@luauforge/bundled/dzE")
local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local dateHelper = require("@luauforge/bundled/geM").DateHelper
local module24 = require("@luauforge/bundled/hLP")
local module25 = require("@luauforge/bundled/fzS")
local module26 = require("@luauforge/bundled/dzD")
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local module27 = require("@luauforge/bundled/hMh")
local module28 = require("@luauforge/bundled/hMi")
local module29 = require("@luauforge/bundled/gxO")
local LinkStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")
local module31 = require("@luauforge/bundled/hMj")
local default = require("@luauforge/bundled/ggu").CredentialsProtocol.default
local constants2 = require("@luauforge/bundled/gxT").Constants
local userAgreementsCounterNames = require("@luauforge/bundled/gsy").UserAgreementsCounterNames
local Cryo = require(CorePackages.Packages.Cryo)
local module32 = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local module33 = require("@luauforge/bundled/ghR")
local module34 = require("@luauforge/bundled/hMb")
local module35 = require("@luauforge/bundled/guM")
local module36 = require("@luauforge/bundled/guB")
local module37 = require("@luauforge/bundled/guD")
local defineFastFlag = game:DefineFastFlag("EnableSkipVPCSignupFlow2", false)
local defineFastFlag2 = game:DefineFastFlag("BypassIXPSkipVPCSignup", false)

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTextFieldContentType
local module38 = require("@luauforge/bundled/hMk")
local module39 = require("@luauforge/bundled/ghS")

local fFlagFoundationStylingOnSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFoundationStylingOnSignUp
local module40 = require("@luauforge/bundled/gyR")
local module41 = require("@luauforge/bundled/gxV")

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/ggu").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local module42 = require("@luauforge/bundled/hMl")
local defineFastFlag3 = game:DefineFastFlag("UsePackageFetchSignupUserAgreements", false)
local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local module43 = require("@luauforge/bundled/hMm")
local defineFastFlag4 = game:DefineFastFlag("DisplayNamesOnSignupExperiment_v3", false)

local defineFastFlag5 = game:DefineFastFlag("EnableDisplayNamesOnSignupExperimentv1_Dev", false)
local defineFastInt = game:DefineFastInt("DisplayNameEligabilityAgeYears", 17)
local defineFastFlag6 = game:DefineFastFlag("DisplayNamesDiagLogging", false)

local module44 = require("@luauforge/bundled/grm")
local defineFastFlag7 = game:DefineFastFlag("DisablePasskeySignupForLuaDeepLinks", false)
local defineFastFlag8 = game:DefineFastFlag("UseBreakpointOnSignUp", false)

local getFFlagAuthCollapsingValidatorFoundationInput = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagAuthCollapsingValidatorFoundationInput

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp

local getFFlagLuaAppSignupPasskeyAvailabilityPreflight = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppSignupPasskeyAvailabilityPreflight

local defineFastFlag9 = game:DefineFastFlag("UseLongFormSignupComplianceTextByDefault", false)
game:DefineFastFlag("LuaVerifiedSignup2", false)
game:DefineFastFlag("LuaVerifiedSignupExperiment2", false)
local module45 = require("@luauforge/bundled/hMn")

local module46 = require("@luauforge/bundled/fBV")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module48 = require("@luauforge/bundled/ehm")
local module49 = require("@luauforge/bundled/hMo")
local module50 = require("@luauforge/bundled/gyZ")
local module51 = require("@luauforge/bundled/gxR")
local module52 = require("@luauforge/bundled/gxW")
local module53 = require("@luauforge/bundled/gxQ")
local module54 = require("@luauforge/bundled/grJ")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module56 = require("@luauforge/bundled/gfG")
local module57 = require("@luauforge/bundled/gut")
local module58 = require("@luauforge/bundled/fCM")
local module59 = require("@luauforge/bundled/gxP")
local module60 = require("@luauforge/bundled/ggs")
local module61 = require("@luauforge/bundled/ggi")
local module62 = require("@luauforge/bundled/gvQ")
local module63 = require("@luauforge/bundled/gxU")
local validateCode = require("@luauforge/bundled/gxT").Thunks.ValidateCode
local module64 = require("@luauforge/bundled/hLW")

local module65 = require("@luauforge/bundled/hMp")

local module66 = require("@luauforge/bundled/hMq")
local module67 = require("@luauforge/bundled/hMr")
local module68 = require("@luauforge/bundled/egt")
local module69 = require("@luauforge/bundled/dFm")
local v5

if defineFastFlag3 then
	v5 = require("@luauforge/bundled/gsy").FetchSignupUserAgreements
else
	v5 = require("@luauforge/bundled/gvP")
end

local module70 = require("@luauforge/bundled/gif")

local udim = UDim2.new(0, 36, 0, 36)

local iconsnavigationclose = images["icons/navigation/close"]

local vector2 = Vector2.new(540, 1080)

local function getPasskeysAvailableFromCredentialsProtocolResult(p2)
	local v6 = parseCredentialsProtocolIsAvailableResponse(p2)
	return v6.fido2Available and v6.fido2SupportsDeviceBoundOnly and v6.fido2SupportsPasskeyCreationOnDevice
end

local extended = Roact.PureComponent:extend("SinglePageSignUp")

function extended:init()
	local module71 = require("@luauforge/bundled/hMu")
	local module72 = require("@luauforge/bundled/hMv")

	local credentialsAvailabilityStore = getCredentialsAvailabilityStore(false)
	local fido2Available = credentialsAvailabilityStore.getFido2Available(false)
	local passwordsAvailable = credentialsAvailabilityStore.getPasswordsAvailable(false)

	self.state = {
		birthday = nil,
		shouldHideBirthdayEntry = false,
		suggestionsShowing = false,
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
		local authenticatedTheme = module56.getAuthenticatedTheme()

		if authenticatedTheme ~= "" then
			MemStorageService:Fire(module22.ThemeUpdate, authenticatedTheme)
		end
	end

	function self.logoutAllLoggedInUsersCallback()
		local networking = self.props.networking
		local accountBlob = module56.getAccountBlob()
		local v6 = Models.fromLocalStorage().userId ~= -1

		self:setState({
			signUpError = false,
			isSignUpButtonEnabled = false,
			isSignUpInProgress = false
		})

		module59(networking, accountBlob):await()

		if v6 == true then
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
		local v6 = self:shouldUseFoundationFields() and "foundationSignup" or "legacySignup"
		return preAuthDeepLinkUrlStore.getUrl() or v6, v6
	end

	function self.onCloseButtonClicked()
		local module73 = require("@luauforge/bundled/gxX")

		if module35 or module73 then
			local v6, v7

			if module73 then
				v6, v7 = self.getSignupTelemetryStateAndOrigin()
			end

			self.props.authEventAnalytics.reportAuthButtonClick(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.DismissCornerX,
				v6,
				nil,
				self.isAltAttempt,
				v7
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
		return module36 and (self.props.appPolicy.getUseKoreaKISAUserAgreementPopup() or module37)
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
		local v6 = {
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

		self.props.openKISAUserAgreements(v6)
	end

	function self.getIsSignUpButtonEnabled()
		local v6 = self.props.shouldUseMinimalSignup and module38()

		return module72({
			birthday = self.state.birthday,
			username = self.state.username,
			password = self.state.password,
			displayName = self.state.displayName,
			birthdayValid = self.state.birthdayValid,
			usernameValid = self.state.usernameValid,
			passwordValid = self.state.passwordValid,
			displayNameValid = self.state.displayNameValid,
			validBirthday = self.state.validBirthday,
			shouldUseMinimalSignup = v6,
			shouldUsePasswordlessSignup = self.props.shouldUsePasswordlessSignup,
			shouldUsePasskeySignup = self.props.shouldUsePasskeySignup,
			passkeysAvailable = self.state.passkeysAvailable,
			shouldUseAlternateBirthday = module43() and self.props.birthdayPickerVariant and self.props.birthdayPickerVariant > 0,
			shouldRequireSignupCheckbox = self.props.shouldRequireSignupCheckbox,
			signupAgreementsChecked = self.state.signupAgreementsChecked,
			signupCheckboxDisabled = self.getSignupCheckboxDisabled(),
			displayNamesOnSignupExperimentEnabled = defineFastFlag4,
			isDisplayNameFieldRequired = defineFastFlag4 and self.isDisplayNameFieldRequired(),
			passkeySignupEnabled = module39()
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
		local v6 = tonumber(p2)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module71.buildBirthdayFromAge(v6, localTime))
	end

	function self.onAgeAndMonthChanged(p2, p3)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module71.buildBirthdayFromAgeMonth(p2, p3, localTime))
	end

	function self.onMonthAndYearChanged(p2, p3)
		local localTime = DateTime.now():ToLocalTime()
		self.updateState(module71.buildBirthdayFromMonthYear(p2, p3, localTime))
	end

	local v6 = require("@luauforge/bundled/hMw")({
		updateState = self.updateState,
		getIssueCondition = function()
			return self.state.issueCondition
		end,
		getAuthEventAnalytics = function()
			return self.props.authEventAnalytics
		end
	})

	self.usernameSuggestionClicked = v6.usernameSuggestionClicked
	self.logRefreshButtonClicked = v6.logRefreshButtonClicked
	self.usernameSuggestionsShown = v6.usernameSuggestionsShown
	self.logSuggestableUsername = v6.logSuggestableUsername
	self.shouldSuggest = v6.shouldSuggest
	self.updatePillClicked = v6.updatePillClicked
	self.resetPillClicked = v6.resetPillClicked
	self.updateIssueCondition = v6.updateIssueCondition
	self.updateSuggestionControlState = v6.updateSuggestionControlState

	function self.onSuggestionsVisibilityChanged(p2)
		if self.isMounted and self.state.suggestionsShowing ~= p2 then
			self:setState({ suggestionsShowing = p2 })
		end
	end
	self.loadSuggestions = v6.loadSuggestions
	self.finishSuggestions = v6.finishSuggestions

	function self.onBirthdayFocused(p2)
		if self.isMounted then
			self:setState({ birthdayFocused = p2 })
		end
	end

	function self.onUsernameTextChanged(p2, p3)
		local v7

		if defineFastFlag4 and self.shouldShowDisplayNameField() and not self.state.hasEditedUsername then
			v7 = self.state.recommendedUsername ~= p2
		end

		local updateState = self.updateState

		if not defineFastFlag4 then
			v7 = nil
		end

		updateState({ username = p2, usernameValid = p3, hasEditedUsername = v7 })

		if self.shouldSuggest() then
			self.logSuggestableUsername(p2)
		end

		self.updateSignUpFieldFilled()
	end

	function self.updateSignUpFieldFilled()
		if self.props.signUpStarted == nil then
			return
		end

		local v7 = self.state.username ~= "" or self.state.password ~= "" or self.state.birthday ~= nil

		if v7 ~= self.state.signUpStarted then
			self.props.setSignUpStarted(v7)
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
	local binding, v7 = Roact.createBinding(0)
	self.scrollCanvasTargetPositionY = binding
	self.updateScrollCanvasTargetPositionY = v7

	self.scrollingFrameRef = Roact.createRef()
	self.ageTextFieldRef = Roact.createRef()
	self.usernameTextFieldRef = Roact.createRef()
	local ref = if defineFastFlag4 then Roact.createRef() else nil
	self.displayNameTextFieldRef = ref
	self.passwordTextFieldRef = Roact.createRef()

	self.passwordFoundationInputRef = Roact.createRef()
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

			if module44 then
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
		local v8 = self.state.phoneCountryCode.prefix .. "," .. self.state.phoneInput .. "," .. self.state.phoneCountryCode.code

		agreeToPhoneNumberVerification(networking, function()
			module67(networking, v8):andThen(function(p2)
				local challenge = p2.challenge
				self.verifyPhoneNumber(challenge, self.state.phoneInput, v8)
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

		local v8 = math.clamp(
			self.scrollingFrameRef.current.CanvasPosition.Y,
			0,
			self.cachedScrollCanvasInitialSizeY
		)

		if self.isMounted then
			local v9 = p2.Y - self.scrollingFrameRef.current.absolutePosition.Y + v8
			self.updateScrollCanvasTargetPositionY(v9)
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
		local v8 = p2 == Enum.TextInputType.Password

		if require("@luauforge/bundled/hMz") then
			v8 = require("@luauforge/bundled/hMA")(p2)
		end

		if v8 then
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

		if require("@luauforge/bundled/gxX") and self:shouldUseFoundationFields() then
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
		if module44 then
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

		local v8 = self.useVerifiedSignup() and self.state.contactMethod == module27.PhoneNumber

		local url = preAuthDeepLinkUrlStore.getUrl()
		local v9 = defineFastFlag7

		if v9 then
			v9 = not (url == nil) and url ~= ""
		end

		local v10 = not self.state.passkeysAvailable or v9
		local v11 = module39()
		signUp(
			networking,
			omniRecommendationsRequest,
			guiService,
			fn,
			p3,
			analytics,
			appPolicy,
			p2,
			v8,
			self.props.shouldUsePasskeySignup and v11 and game:GetEngineFeature("SignupActionRequiredKeyAvailable") and not v10,
			self.props.shouldAutomaticallyPromptForPasskey,
			module42() and self.state.isCredentialsProtocolRegisterPasswordAvailable,
			authEventAnalytics,
			self.props.isIosAuthServiceEnabled
		):andThen(
			function()
				setBackNavigationDisabled(false)
			end,
			function(p4)
				setBackNavigationDisabled(false)

				if v8 then
					if p4 ~= module31.Captcha then
						self.updateIsSignUpInProgress(false)
						self:setState({ signUpError = true })
					end
				else
					if p4 ~= module29.Captcha then
						self.updateIsSignUpInProgress(false)
						self:setState({ signUpError = true })
					end

					if module35 and p4 ~= module29.Captcha then
						module52(authEventAnalytics, p4)
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
			local v8, v9 = module51(self.props.networking, url):await()

			self.props.authEventAnalytics.reportAuthButtonClick(
				module25.Context.SinglePageSignUpScreen,
				module25.Button.SignUp,
				v9,
				url,
				self.isAltAttempt
			)

			if defineFastFlag6 and self.props.shouldSeeDisplayNamesOnSignup then
				if self.state.recommendedUsername == username then
					module70(module20.SignUpWithRecommendedUsernames, 1)
				elseif self.state.hasEditedUsername then
					module70(module20.SignUpWithEditedUsernames, 1)
				end

				if self.state.bypassDisplayNameField then
					module70(module20.SignupBypassingDisplayNames, 1)
				end
			end

			self.updateIsSignUpInProgress(true)
			setBackNavigationDisabled(true)

			self:setState({ signUpError = false })

			local v10 = {
				birthday = birthday2 and birthday2:FormatForEndpoint() or "",
				username = username,
				password = password,
				displayName = 0,
				gender = 0,
				locale = 0,
				capturedAuditContent = 0,
				additionalAuditContent = 0
			}

			local v11 = if defineFastFlag4 and self.isDisplayNameFieldRequired() then self.state.displayName else nil
			v10.displayName = v11

			v10.gender = gender
			v10.locale = locale
			v10.capturedAuditContent = self.props.capturedAuditContent
			v10.additionalAuditContent = self.props.additionalAuditContent

			local v12 = self.useVerifiedSignup()

			if v12 and self.state.contactMethod == module27.Email then
				v10.email = emailInput
			elseif v12 and self.state.contactMethod == module27.PhoneNumber then
				v10.verifiedSignupVoucher = self.verifiedSignupVoucher
			end

			if self.props.appPolicy.getAddUserAgreementIdsToSignupRequest() then
				local agreements = self.state.agreements

				if #agreements > 0 then
					local ids = {}

					for i, agreement in ipairs(agreements) do
						table.insert(ids, agreement.id)
					end

					v10.agreementIds = ids
				else
					module70(userAgreementsCounterNames.AgreementsIdsEmptyOnSignup, 1)
				end
			end

			if self.getShouldShowVNGAgreements() then
				self.props.showVNGUserAgreementsPopup(self.state.agreements, function(list)
					local v13 = v10
					local ids = {}

					for i, item in ipairs(list) do
						table.insert(ids, item.id)
					end

					v13.agreementIds = ids
					self.requestSignUp(v10)
				end, function()
					self.updateIsSignUpInProgress(false)
					setBackNavigationDisabled(false)
				end)
			elseif self.getShouldShowKISAAgreements() then
				local userAge = self.getUserAge()

				if not (userAge and userAge < module41) then
					self.launchKISATermsOfService(v10, false)
				elseif self.enableSkipVPCSignupFlow() then
					events.authPageload(
						eventStreamConstants.Context.KISAU14Signup,
						eventStreamConstants.State.SkipVPC
					)

					self.requestSignUp(v10)
				else
					events.authPageload(
						eventStreamConstants.Context.KISAU14Signup,
						eventStreamConstants.State.LaunchParentSignUpOtp
					)

					self.launchParentSignUpOtp(v10)
				end
			else
				self.requestSignUp(v10)
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

		if module43() and self.props.birthdayPickerVariant ~= nil then
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
		local v8 = self.props.shouldSeeDisplayNamesOnSignup and self.state.birthday

		if not v8 then
			return v8
		end

		v8 = defineFastInt <= self.getUserAge() and not self.state.hasSetIneligibleAgeAtLeastOnce
		return v8
	end

	function self.isDisplayNameFieldRequired()
		return self.shouldShowDisplayNameField() and not self.state.bypassDisplayNameField
	end

	function self.isValidDisplayNameEntered(): boolean
		return self.state.displayName ~= "" and self.state.displayNameValid ~= LinkStatus.Invalid
	end

	function self.setUsernameRecommendation(p2)
		self:setState(function(p3)
			local v9 = if p3.recommendedUsername == nil or p2 ~= "" then p2 else nil
			return { recommendedUsername = v9 }
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

		local v8 = {
			origin = constants2.otpServiceOriginSignup,
			contactType = constants2.otpServiceContactType,
			passCode = self.state.otpCode,
			otpSessionToken = self.state.otpSessionToken
		}

		local v9 = {
			otpSessionToken = tostring(self.state.otpSessionToken),
			otpContactType = constants2.otpServiceContactType
		}

		return validateCode(networking, v8)():andThen(function(p3)
			self.props.closeCentralOverlay()
			p2.otpSession = v9
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
		local v8 = {
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

		self.props.openEmailOtp(v8)
	end

	self.isMounted = false
end

function extended:didMount()
	self.isMounted = true
	self.isAltAttempt = nil

	default:isAvailable(default.CredentialsTypes.FIDO2, getFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(data)
		local v6

		if
			getFFlagLuaAppSignupPasskeyAvailabilityPreflight()
			and self.props.shouldTightenPasskeyEligibility
			and data.FIDO2 ~= nil
		then
			local v7 = parseCredentialsProtocolIsAvailableResponse(data)
			v6 = v7.fido2Available
				and v7.fido2SupportsDeviceBoundOnly
				and v7.fido2SupportsPasskeyCreationOnDevice
		else
			v6 = data.isAvailable or false
		end

		local v7 = data.password and data.password.isAvailable and true or false

		if self.isMounted then
			self:setState({
				passkeysAvailable = v6,
				isCredentialsProtocolRegisterPasswordAvailable = v7
			})
		end

		self.props.authEventAnalytics.reportAuthPageload(module25.Context.PasskeySignup, (tostring(v6)))

		self.props.authEventAnalytics.reportAuthPageload(module25.Context.CMPasswordSignup, (tostring(v7)))
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
				module70(userAgreementsCounterNames.FetchAgreementsHttpRequestFailureOnSignup, 1)
			elseif #list > 0 then
				self.updateState({ agreements = list })
			else
				module70(userAgreementsCounterNames.FetchAgreementsEmptyResponseOnSignup, 1)
			end
		end
		v5(self.props.networking, self.props.analytics):andThen(fn, function() end)
	end

	self.props.authEventAnalytics.reportScreenLoaded(module25.Context.SinglePageSignUpScreen)
	self.props.loggingProtocol:logEventOnce("signup_page_did_mount")
	self.props.loggingProtocol:logRobloxTelemetryCounter(
		telemetryConfigs.SignupPageMountTelemetryConfig,
		1,
		{ version = 1 }
	)

	local module71 = require("@luauforge/bundled/gxX")
	local v6 = preAuthDeepLinkUrlStore.getUrl()
	local v7

	if module71 then
		v6, v7 = self.getSignupTelemetryStateAndOrigin()
	else
		v7 = nil
	end

	module53(self.props.networking):andThen(function(p2)
		if p2 and p2.IsAltBrowserTracker ~= nil then
			self.isAltAttempt = p2.IsAltBrowserTracker
			self.props.authEventAnalytics.reportAuthPageload(
				module25.Context.SinglePageSignUpScreen,
				v6,
				self.isAltAttempt,
				v7
			)
		elseif module71 then
			self.isAltAttempt = false
			self.props.authEventAnalytics.reportAuthPageload(
				module25.Context.SinglePageSignUpScreen,
				v6,
				self.isAltAttempt,
				v7
			)
		end
	end, function(p2)
		warn("Error auth metadata: ", error)
		self.props.authEventAnalytics.reportAuthPageload(
			module25.Context.SinglePageSignUpScreen,
			v6,
			self.isAltAttempt,
			v7
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

	local v6 = focusedGuiObject
		and birthdayContainerRef
		and birthdayContainerRef.current
		and focusedGuiObject:IsDescendantOf(birthdayContainerRef.current)

	local focusedGuiObject2 = p2.focusedGuiObject
	local birthdayContainerRef2 = p2.birthdayContainerRef

	local v7 = focusedGuiObject2
		and birthdayContainerRef2
		and birthdayContainerRef2.current
		and focusedGuiObject2:IsDescendantOf(birthdayContainerRef2.current)

	if v6 and not v7 then
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
			module70(module20.ReccomendedNameEdited, 1)
		end

		if
			object.state.recommendedUsername ~= nil
			and object.state.recommendedUsername ~= ""
			and object.state.hasEditedUsername == true
			and object.state.username == ""
			and data.username ~= ""
			and object.props.shouldSeeDisplayNamesOnSignup
		then
			module70(module20.ReccomendedNameManuallyCleared, 1)
		end

		if
			object.state.birthday ~= nil
			and data.birthday ~= nil
			and object.state.birthday ~= data.birthday
		then
			if defineFastInt <= object.getUserAge() and data.birthday:GetAgeInYears() < defineFastInt then
				module70(module20.BirthdayChangedToAboveDisplayAge, 1)
			end

			if object.getUserAge() < defineFastInt and defineFastInt <= data.birthday:GetAgeInYears() then
				module70(module20.BirthdayChangedToAboveDisplayAge, 1)
			end
		end
	end
end

function extended:shouldUseFoundationFields()
	local module71 = require("@luauforge/bundled/hMz")
	local v6 = self.props.shouldUseMinimalSignup and module38()
	local url = preAuthDeepLinkUrlStore.getUrl()
	local v7 = defineFastFlag7

	if v7 then
		v7 = not (url == nil) and url ~= ""
	end

	local v8 = not self.state.passkeysAvailable or v7
	local v9 = self.props.shouldUsePasswordlessSignup

	if module39() and self.props.shouldUsePasskeySignup and v8 then
		v9 = false
	end

	local v10 = not module45()

	if v10 then
		if self.props.shouldUseFoundationSignupFields == true and self.getBirthdayVariant() == 0 then
			v10 = not (self.useVerifiedSignup() or self.props.shouldSeeDisplayNamesOnSignup)
				and (module71 or v6 == true or v9 == true)
		else
			v10 = false
		end
	end

	return v10
end

function extended:render()
	if module33 and self.isAlreadyAuthenticated then
		local createElement = Roact.createElement
		local v7 = {
			style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
		}

		local v9 = if module45() then self:renderWithView() else self:renderDeprecated()
		return createElement(uiModeStyleProvider, v7, { Child = v9 })
	elseif module45() then
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

		local v8 = if module35 or require("@luauforge/bundled/gxX") then self.onCloseButtonClicked else self.props.navigateBack
		return createElement(module17, {
			navigateBack = v8,
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
			UsernameValidator = module49,
			PasswordValidator = module50,
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
	local module71 = require("@luauforge/bundled/hLX")

	local birthday2 = self.state.birthday
	local username = self.state.username
	local isSignUpButtonEnabled = self.getIsSignUpButtonEnabled()
	local isSignUpInProgress = self.state.isSignUpInProgress
	local gender = self.state.gender
	local v6 = self.props.formFactor == formFactor.WIDE
	local isCompactView = self.props.isCompactView
	local v7 = 0
	local v8 = 0
	local v9 = self.state.onScreenKeyboardHeight > 0
	local contactMethod = self.state.contactMethod
	local foundationTokens = self.props.foundationTokens
	local shouldUseFoundationBackgroundColor = self.props.shouldUseFoundationBackgroundColor
	local shouldUseFoundationUsernameTextInput = self.props.shouldUseFoundationUsernameTextInput

	local username2 = getFFlagEnableTextFieldContentType() and Enum.TextInputType.Username
		or Enum.TextInputType.NoSuggestions
	local v10 = not self.validUsernameEntered()

	local v11 = self.useVerifiedSignup()
	local v12 = v6 and v11 and 12 or 0
	local v13 = "Authentication.SignUp.Label.ErrorsWithUsername"
	local v14 = "Authentication.SignUp.Label.ErrorsWithPassword"

	local v15 = self.useUsernameSuggestions()
	local v16 = self.useRefreshButton()

	local v17 = fFlagFoundationStylingOnSignUp and isCompactView

	if birthday2 then
		if
			defineFastFlag4
			and self.isDisplayNameFieldRequired()
			and not self.isValidDisplayNameEntered()
		then
			v14 = "Authentication.SignUp.Response.AgedUpDisplayNameSetFirst"
			v10 = true
		elseif v10 then
			v14 = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
		end
	else
		v13 = "Authentication.SignUp.Response.BirthdayMustBeSetFirst"
		v14 = v13
		v10 = true
	end

	if v6 then
		if v9 then
			v7 = self.state.onScreenKeyboardHeight + 10
		else
			v7 = 48
			v8 = 24
		end
	end

	local default2 = if v17 then disclaimerLinksVariant.Default else nil

	local v18 = module38()
	local v19 = self.props.shouldUseMinimalSignup and v18
	local v20 = self.props.shouldHideGenderOption and v18
	local v21 = self.props.shouldAutofocusOnBirthday and v18

	local v22 = self.props.shouldUsePasswordlessSignup and true
	local shouldShowVNGAgreements = self.getShouldShowVNGAgreements()
	local shouldShowKISAAgreements = self.getShouldShowKISAAgreements()

	local url = preAuthDeepLinkUrlStore.getUrl()
	local v23 = defineFastFlag7

	if v23 then
		v23 = not (url == nil) and url ~= ""
	end

	local v24 = not self.state.passkeysAvailable or v23

	if module39() and self.props.shouldUsePasskeySignup and v24 then
		v22 = false
	end

	local shouldDisableUsernameAutofill = self.props.shouldDisableUsernameAutofill

	local v25 = module39()
	local v26 = self.props.shouldUsePasskeySignup
		and v25
		and game:GetEngineFeature("SignupActionRequiredKeyAvailable")
		and not v24

	local module72 = require("@luauforge/bundled/gxX")

	local module73 = require("@luauforge/bundled/hMz")
	local v27

	if module72 then
		v27 = self:shouldUseFoundationFields()
	else
		v27 = self.props.shouldUseFoundationSignupFields

		if v27 then
			if self.getBirthdayVariant() == 0 then
				v27 = not v11 and not self.props.shouldSeeDisplayNamesOnSignup and (module73 or v19 or v22)
			else
				v27 = false
			end
		end
	end

	local v28 = v17 or v27
	local v29 = shouldUseFoundationBackgroundColor or v27
	local v30 = require("@luauforge/bundled/hMB")() and v27
	local v31 = module73 and v27

	local v32 = if v27 then images["icons/navigation/pushBack"] else iconsnavigationclose

	local function getVerificationLinkingText(p2)
		local linkedPlatformAccountName = getLinkedPlatformAccountName(self.props.appPolicy)

		return linkedPlatformAccountName and {
			"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
			platform = linkedPlatformAccountName,
			ctaButton = p2
		} or nil
	end

	local v33 = module71(nil, v30)

	return withStyle(function(data)
		return module5({
			signUpHeadingText = v33.signUpHeading,
			signUpText = v33.signUpButton,
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

			local module74 = require("@luauforge/bundled/gxX")
			local v34, v35

			if module74 and v27 then
				v34, v35 = self.getSignupTelemetryStateAndOrigin()
			end

			local v36 = not v19
			local v37 = 38
			local v38 = 24
			local v39 = 5
			local v40 = v6 and 25 or 48
			local udim2 = UDim2.new(0.5, 0, 0, 49)

			if v27 then
				v38 = foundationTokens.Padding.XLarge
				v39 = foundationTokens.Gap.Small
				v37 = foundationTokens.Gap.Small
				v40 = foundationTokens.Padding.Medium
			elseif v17 then
				v40 += foundationTokens.Padding.Medium
				udim2 = UDim2.new(0.5, 0, 0, 1 + foundationTokens.Padding.Medium)
			end

			if defineFastFlag4 then
				v36 = self.shouldShowUsernameField() and not v19
			end

			local shouldRequireSignupCheckbox = not self.getSignupCheckboxDisabled()
				and self.props.shouldRequireSignupCheckbox
			local v41 = defineFastFlag9
				and "Authentication.SignUp.Description.SignUpAgreement.FullCopy.CreateAccount"
				or "Authentication.SignUp.Description.VerificationPage.CreateAccount"

			if v26 then
				v41 = "Authentication.SignUp.Description.VerificationPageMultiStep"
			else
				local signUpText = data2.signUpText
				local linkedPlatformAccountName = getLinkedPlatformAccountName(self.props.appPolicy)

				if linkedPlatformAccountName then
					local signUpText2 = data2.signUpText
					local linkedPlatformAccountName2 = getLinkedPlatformAccountName(self.props.appPolicy)

					v41 = linkedPlatformAccountName2 and {
						"Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
						platform = linkedPlatformAccountName2,
						ctaButton = signUpText2
					} or nil
				end
			end

			local v42 = ""

			if not self.getSignupCheckboxDisabled() then
				if self.props.signupLegalDisclaimerTextVariant == 1 then
					if shouldRequireSignupCheckbox then
						v42 = data2.signUpAgreementFullCopyCheckboxText
					elseif v26 then
						v41 = "Authentication.SignUp.Description.SignUpAgreement.FullCopy.Continue"
					else
						v41 = "Authentication.SignUp.Description.SignupAgreement.FullCopy.CreateAccount"
					end
				elseif self.props.signupLegalDisclaimerTextVariant == 2 and shouldRequireSignupCheckbox then
					v42 = data2.signUpAgreementShortCopyCheckboxText
				end
			end

			local v43 = self.props.shouldShowBackButton == nil or self.props.shouldShowBackButton
			local v44

			if v30 then
				v44 = v43
				v43 = false
			else
				v44 = false
			end

			local createElement = Roact.createElement
			local v46 = {
				BackgroundTransparency = 1,
				includeStatusBar = true,
				buttonRef = self.props.containerRef,
				renderFullscreenBackground = function()
					local createElement2 = Roact.createElement
					local v48 = { showImage = v6, fallbackBackgroundColor = 0 }

					local v49 = if v29 then foundationTokens.Color.Surface.Surface_0.Color3 else data.Theme.BackgroundUIDefault.Color
					v48.fallbackBackgroundColor = v49
					return createElement2(authBackgroundContainer, v48)
				end
			}

			local v47 = {
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
			local v49 = {
				Size = UDim2.new(1, 0, 1, -v7),
				Position = UDim2.new(0.5, 0, 0, v8),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = 0,
				ClipsDescendants = true
			}

			local v50 = if v29 then foundationTokens.Color.Surface.Surface_0.Color3 else data.Theme.BackgroundUIDefault.Color
			v49.ImageColor3 = v50

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
			local v52 = {
				Size = UDim2.new(1, 0, 0, 48),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1
			}

			if v43 then
				v43 = Roact.createElement(imageSetButton, {
					Size = udim,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Image = v32,
					ImageColor3 = data.Theme.UIEmphasis.Color,
					ImageTransparency = 0,
					[Roact.Event.Activated] = self.onCloseButtonClicked,
					[Roact.Ref] = self.backButtonRef
				})
			end

			local v53 = {
				BackButton = v43,
				FoundationBackButton = v44 and Roact.createElement(Foundation.IconButton, {
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

			local v54 = data2.signUpHeadingText

			if v54 then
				if v28 then
					v54 = Roact.createElement(text, {
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Text = data2.signUpHeadingText or "",
						fontStyle = foundationTokens.Typography.HeadingSmall,
						TextXAlignment = Enum.TextXAlignment.Center
					})
				else
					v54 = Roact.createElement(fitTextLabel, {
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						width = UDim.new(1, 0),
						BackgroundTransparency = 1,
						Text = data2.signUpHeadingText or "",
						TextWrapped = true,
						Font = normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font),
						TextSize = data.Font.BaseSize * data.Font.Header1.RelativeSize,
						TextColor3 = data.Theme.TextEmphasis.Color,
						TextTransparency = data.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Center
					})
				end
			end

			v53.Title = v54
			children.HeaderFrame = createElement3("Frame", v52, v53)

			children.Divider = not v28 and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 48),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = v29 and 1 or 0,
				BackgroundColor3 = data.Theme.UIEmphasis.Color
			})

			local createElement4 = Roact.createElement
			local fitScrollingFrame = FitChildren.FitScrollingFrame
			local v55 = {
				Size = UDim2.new(1, 0, 1, -(49 + v12)),
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
			local v56 = {
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v38),
					PaddingRight = UDim.new(0, v38),
					PaddingTop = UDim.new(0, v40)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v39)
				}),
				BirthdayBar = self.getBirthdayVariant() == 0 and Roact.createElement(module9, {
					layoutOrder = 1,
					onBirthdaySelected = self.onBirthdaySelected,
					onBirthdayFocused = self.onBirthdayFocused,
					autoFocusOnMount = v11 or v21,
					buttonRef = self.props.defaultRef,
					preferredInput = self.props.preferredInput,
					birthdayContainerRef = self.props.birthdayContainerRef,
					forceDarkTheme = module33 and self.isAlreadyAuthenticated,
					enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
					useFoundationField = v27,
					boldFoundationLabel = v30 and true or nil,
					hideAgeInLabel = v30 and true or nil
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
				ContactInfoField = v11 and Roact.createElement(module14, {
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
				BackgroundPanel = v11 and Roact.createElement(
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

			local v59 = if defineFastFlag4 and self.shouldShowDisplayNameField() then React.createElement(module18, {
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
			v56.DisplayName = v59
			local v60

			if v36 then
				local createElement5 = Roact.createElement
				local v62 = {}
				v62.layoutOrder = defineFastFlag4 and 5 or 4
				v62.titleTextKey = "Authentication.Login.Label.Username"
				v62.summaryErrorTextKey = v13
				v62.prerequisiteMet = birthday2 and true or false
				v62.textInputType = if not shouldDisableUsernameAutofill then username2 else nil
				v62.onInputTextChanged = self.onUsernameTextChanged
				v62.onInputTextValidated = v15 and self.onUsernameTextValidated
					or self.onUsernameTextChanged
				v62.validator = module49
				local v64 = if defineFastFlag4 then self.state.recommendedUsername else nil
				v62.prefilledText = v64

				local v65 = if defineFastFlag4 then self.getUsernamePlaceholder(data2) else data2.usernamePlaceholder
				v62.placeholderText = v65

				v62.validatorAdditionalProps = {
					birthday = birthday2 and birthday2:FormatForEndpoint() or "",
					context = module24.Signup
				}
				local v66

				if module34 and not self.state.suggestionsShowing then
					v66 = if v31 then self.passwordFoundationInputRef else self.passwordTextFieldRef
				end

				v62.NextSelectionDown = v66

				v62.textBoxFocusedCallback = self.onUsernameTextBoxFocused

				local v67 = if defineFastFlag4 then self.onUsernameTextBoxFocusLost else self.onTextBoxFocusLost
				v62.textBoxFocusLostCallback = v67

				v62.focusedTextBoxPositionChangedCallback = self.onFocusedTextBoxPositionChanged
				v62.returnKeyType = Enum.ReturnKeyType.Next
				v62.onReturnPressedFromOnScreenKeyboard = self.onUsernameTextChangeCompletedFromKeyboard
				v62.onAnimationStateChangeCallback = self.onAnimationStateChangeCallback
				v62.textBoxRef = self.usernameTextFieldRef
				v62.pillClicked = self.state.pillClicked
				v62.updatePillClicked = self.updatePillClicked
				v62.resetPillClicked = self.resetPillClicked
				v62.issueCondition = self.state.issueCondition
				v62.updateIssueCondition = self.updateIssueCondition
				v62.loadingSuggestions = self.state.loadingSuggestions

				v62.paddingBottomOverride = v27 and 0
					or defineFastFlag4
					and self.props.shouldSeeDisplayNamesOnSignup
					and self.getUsernameGuidanceText(data2)
					and -5
					or nil

				v62.enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
				v62.useFoundationTextInput = (shouldUseFoundationUsernameTextInput or v27) and true or nil

				v62.useFoundationTitle = v27
				v62.foundationTitleIsRequired = v27
				v62.foundationTitleIsBold = v30 and true or nil
				local v68 = if v27 then inputSize.Large else nil
				v62.foundationInputSize = v68
				local v69 = if v27 then foundationTokens.Gap.Small else nil
				v62.paddingTopOverride = v69
				local v70 = if v27 then foundationTokens.Gap.Small else nil
				v62.contentGapOverride = v70
				v60 = createElement5(module10, v62)
			else
				v60 = v36
			end

			v56.UsernameValidator = v60

			local v61 = if defineFastFlag4 and self.props.shouldSeeDisplayNamesOnSignup and self.getUsernameGuidanceText(data2) then Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 1),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 5
				},
				{
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 5)
					}),
					Label = Roact.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(foundationTokens.Typography.BodySmall.Font),
						Size = UDim2.new(1, 0, 0, 0),
						Text = self.getUsernameGuidanceText(data2),
						TextColor3 = data.Theme.TextDefault.Color,
						TextSize = data.Font.BaseSize * data.Font.CaptionBody.RelativeSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				}
			) else nil
			v56.UsernameGuidanceText = v61

			local v62 = v36 and v15

			if v62 then
				local createElement5 = Roact.createElement
				local v64 = {
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
					onShowSuggestionsChanged = 0,
					padding = 0
				}
				local v65 = if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAuthValidatorRebindTextBoxRef then username else nil
				v64.usernameText = v65

				v64.usernameValid = self.state.usernameValid
				v64.birthday = birthday2 and birthday2:FormatForEndpoint() or ""
				v64.suggest = module64
				v64.context = module24.Signup
				v64.pillClicked = self.state.pillClicked
				v64.updatePillClicked = self.updatePillClicked
				v64.resetPillClicked = self.resetPillClicked
				v64.issueCondition = self.state.issueCondition
				v64.usernameSuggestionClicked = self.usernameSuggestionClicked
				v64.usernameSuggestionsShown = self.usernameSuggestionsShown
				v64.shouldSuggest = self.shouldSuggest
				v64.updateSuggestionControlState = self.updateSuggestionControlState
				v64.useRefreshButton = v16
				v64.logRefreshButtonClicked = self.logRefreshButtonClicked
				v64.loadSuggestions = self.loadSuggestions
				v64.finishSuggestions = self.finishSuggestions
				v64.loadingSuggestions = self.state.loadingSuggestions

				local v66 = if module34 then self.onSuggestionsVisibilityChanged else nil
				v64.onShowSuggestionsChanged = v66

				v64.padding = {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}
				v62 = createElement5(module16, v64)
			end

			v56.SuggestionsFrame = v62

			local v63 = not (v19 or v22)

			if v63 then
				local createElement5 = Roact.createElement
				local v65 = {
					disabled = self.state.birthdayFocused,
					layoutOrder = defineFastFlag4 and 6 or 5,
					titleTextKey = "CommonUI.Messages.Label.Password",
					summaryErrorTextKey = v14,
					prerequisiteMet = not v10,
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
					foundationInputRef = 0,
					centralOverlayBlocksInput = 0,
					captureFocusOnTapStart = 0
				}

				local v66 = if v31 and not self.getHidePassword() then engineFeature and Enum.TextInputType.NewPasswordShown or Enum.TextInputType.PasswordShown else engineFeature and Enum.TextInputType.NewPassword or Enum.TextInputType.Password
				v65.textInputType = v66

				v65.useFoundationTextInput = v31 and true or nil
				v65.useFoundationTitle = v31 and true or nil
				v65.foundationTitleIsRequired = v31 and true or nil
				v65.foundationTitleIsBold = v31 and v30 and true or nil

				local v67 = if v31 then inputSize.Large else nil
				v65.foundationInputSize = v67
				local v68

				if v31 then
					v68 = { name = 0, onActivated = 0 }
					local v69 = if self.getHidePassword() then AuthCommon.Common.UIConstants.HIDE_PASSWORD_ICON else AuthCommon.Common.UIConstants.SHOW_PASSWORD_ICON
					v68.name = v69

					v68.onActivated = self.passwordVisibilityToggleCallback
				end

				v65.foundationIconTrailing = v68

				local v69 = if v31 then foundationTokens.Gap.Small else nil
				v65.paddingTopOverride = v69

				v65.paddingBottomOverride = v31 and 0 or nil

				local v70 = if v31 then foundationTokens.Gap.Small else nil
				v65.contentGapOverride = v70

				v65.onInputTextChanged = self.onPasswordTextChanged
				v65.onInputTextValidated = self.onPasswordTextChanged
				v65.validator = module50
				v65.placeholderText = data2.passwordPlaceholder
				v65.validatorAdditionalProps = { username = username }

				v65.returnKeyType = Enum.ReturnKeyType.Next
				v65.textBoxFocusedCallback = self.onPasswordTextBoxFocused
				v65.textBoxFocusLostCallback = self.onTextBoxFocusLost
				v65.focusedTextBoxPositionChangedCallback = self.onFocusedTextBoxPositionChanged
				v65.onReturnPressedFromOnScreenKeyboard = self.onPasswordTextChangeCompletedFromKeyboard
				v65.onAnimationStateChangeCallback = self.onAnimationStateChangeCallback
				v65.textBoxRef = self.passwordTextFieldRef

				local v71 = if module34 then self.passwordFoundationInputRef else nil
				v65.foundationInputRef = v71

				v65.centralOverlayBlocksInput = v11
				v65.captureFocusOnTapStart = not self.state.isCountryCodeSearchVisible
				v63 = createElement5(module10, v65)
			end

			v56.PasswordValidator = v63

			local v64 = not v20

			if v64 then
				if module40() == 2 then
					v64 = false
				else
					local createElement5 = Roact.createElement
					local v66 = {
						layoutOrder = defineFastFlag4 and 8 or 7,
						gender = gender,
						onGenderChanged = self.onGenderChanged,
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
						useFoundationChips = v27,
						boldFoundationLabel = v30 and true or nil,
						getIsAltAttempt = 0
					}

					local v67 = if module74 then self.getIsAltAttempt else nil
					v66.getIsAltAttempt = v67
					v64 = createElement5(module11, v66)
				end
			end

			v56.GenderSelector = v64

			v56.Spacing = Roact.createElement("Frame", {
				LayoutOrder = defineFastFlag4 and 9 or 8,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v37)
			})
			local v65

			if v28 then
				local createElement5 = Roact.createElement
				local button2 = Foundation.Button
				local v66 = {
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

				local v67 = if v26 then data2.continueText else data2.signUpText
				v66.text = v67

				local v68 = if v27 then inputSize.Large else inputSize.Medium
				v66.size = v68
				v66.width = UDim.new(1, 0)
				v66.isDisabled = not isSignUpButtonEnabled
				v66.isLoading = isSignUpInProgress
				v66.onActivated = self.onSignUpClick
				v65 = createElement5(button2, v66)
			else
				local createElement5 = Roact.createElement
				local v67 = {
					buttonType = buttonType.PrimaryContextual,
					layoutOrder = defineFastFlag4 and 10 or 9,
					size = UDim2.new(1, 0, 0, 36),
					text = 0,
					isDisabled = 0,
					isLoading = 0,
					onActivated = 0
				}

				local v68 = if v26 then data2.continueText else data2.signUpText
				v67.text = v68

				v67.isDisabled = not isSignUpButtonEnabled
				v67.isLoading = isSignUpInProgress
				v67.onActivated = self.onSignUpClick
				v65 = createElement5(button, v67)
			end

			v56.SignUpButton = v65

			v56.CheckboxContainer = shouldRequireSignupCheckbox and React.createElement(view, {
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
					Text = v42
				})
			})

			local v66 = not (shouldShowVNGAgreements or shouldShowKISAAgreements or shouldRequireSignupCheckbox)

			if v66 then
				if v27 then
					local createElement5 = Roact.createElement
					local disclaimerTextWithLinks = AuthCommon.Components.DisclaimerTextWithLinks
					local v67 = {
						LayoutOrder = defineFastFlag4 and 11 or 10,
						textKey = "Authentication.SignUp.Description.SignUpAgreement.CreateAnAccount",
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp(),
						ctx = 0,
						state = 0,
						origin = 0
					}

					local v68 = if module74 then module25.Context.SinglePageSignUpScreen else nil
					v67.ctx = v68

					v67.state = v34
					v67.origin = v35
					v66 = createElement5(disclaimerTextWithLinks, v67)
				else
					v66 = Roact.createElement(module12, {
						layoutOrder = defineFastFlag4 and 11 or 10,
						textXAlignment = Enum.TextXAlignment.Center,
						paragraphTextKeys = { v41 },
						enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
					})
				end
			end

			v56.DisclaimerText = v66

			local v67 = not (shouldShowVNGAgreements or shouldShowKISAAgreements)
				and ((not v27 or shouldRequireSignupCheckbox) and true or false)

			if v67 then
				v67 = Roact.createElement(module13, {
					LayoutOrder = defineFastFlag4 and 12 or 11,
					variant = if fFlagFoundationStylingOnSignUp then default2 else nil,
					enableAuditContentCapture = getFFlagEnableAuditForSinglePageSignUp()
				})
			end

			v56.DisclaimerLinks = v67

			v56.ScrollPadding = v9 and Roact.createElement("Frame", {
				LayoutOrder = defineFastFlag4 and 13 or 12,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, self.state.onScreenKeyboardHeight * 2)
			})
			children.SignUpContentFrame = createElement4(fitScrollingFrame, v55, v56)

			children.Footer = v11
				and v6
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
			v47.Container = createElement2(imageSetLabel, v49, children)
			return createElement(module8, v46, v47)
		end)
	end)
end

local v6 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end, function(callback)
	return {
		signUp = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
			return callback(module54(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
		end,
		agreeToPhoneNumberVerification = function(p2, p3, p4)
			return callback(module65({
				verificationChallengeCallback = p3,
				phoneNumber = p4
			}))
		end,
		openKISAUserAgreements = function(p2)
			analyticsEvents.sendPageLoadEvent(
				eventConstants.ctx.kisaAgreements,
				eventConstants.origin.signup
			)
			return callback(module62(p2))
		end,
		setBackNavigationDisabled = function(p2)
			return module46.setDisabled(p2)
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end,
		showErrorToast = function()
			return callback(module68({ HttpError = Enum.HttpError.OK }))
		end,
		verifyPhoneNumber = function(p2, p3, p4, p5, p6, p7)
			return callback(module66({
				verifyPhoneNumberCallback = p3,
				phoneNumber = p5,
				deliveryTarget = p6,
				challenge = p4,
				useEmailOptionClickedCallback = p7
			}))
		end,
		showErrorMessageToast = function(p2)
			return callback(module69({
				toastType = module23.NetworkingError,
				toastMessage = p2
			}))
		end,
		showVNGUserAgreementsPopup = function(p2, p3, p4)
			return callback(module48(
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
			callback(module48(module21.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end,
		closeCentralOverlay = function()
			return callback(module58())
		end,
		openAccountSwitchingErrorOverlay = function(p2, p3, p4, p5, p6, p7, p8, p9)
			return callback(module57(p2, p3, p4, p5, p6, p7, p8, p9, true))
		end,
		resetAppState = function()
			return callback(module60())
		end,
		logoutWithoutShowConfirmation = function(p2, p3)
			return callback(module61(p2, p3))
		end,
		openEmailOtp = function(p2)
			callback(module63(p2))
		end,
		showAccountLinkingAlert = function(p2)
			return callback(module48(module21.AccountLinkingAlert, { alertType = p2 }))
		end
	}
end)(extended)

local v7 = roactServices.connect({
	networking = module3,
	guiService = appGuiService,
	authEventAnalytics = module,
	analytics = module2,
	loggingProtocol = appLogging
})(v6)

local v8 = roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v7)

local v9 = RoactAppExperiment.connectBrowserTrackerLayer(
	{ appBtidLayers.SignupLayer, appBtidLayers.IosPasswordSavingLayer },
	function(p2, p3)
		local v10 = p2[appBtidLayers.SignupLayer] or {}
		local v11 = p2[appBtidLayers.IosPasswordSavingLayer] or {}

		local v12 = if defineFastFlag4 then v10.shouldSeeDisplayNamesOnSignup else nil

		return {
			useVerifiedSignupPage = v10.contactMethodRequired,
			arePasswordFieldsPlaintext = v10.ArePasswordFieldsPlaintext,
			shouldUseUsernameSuggestions = v10.usernameSuggestionsEnabled,
			enableRefreshButton = v10.suggestionRefreshButtonEnabled,
			shouldUseMinimalSignup = v10.shouldUseMinimalSignup,
			shouldHideGenderOption = v10.shouldHideGenderOption,
			shouldAutofocusOnBirthday = v10.shouldAutofocusOnBirthday,
			shouldUsePasswordlessSignup = v10.shouldUsePasswordlessSignup,
			shouldUsePasskeySignup = v10.shouldUsePasskeySignup,
			shouldAutomaticallyPromptForPasskey = v10.shouldAutomaticallyPromptForPasskey,
			shouldTightenPasskeyEligibility = v10.shouldTightenPasskeyEligibility,
			birthdayPickerVariant = v10.birthdayPickerVariant,
			shouldSeeDisplayNamesOnSignup = defineFastFlag5 and true or v12,
			shouldShowKoreanKISASignUpFlow = v10.shouldShowKoreanKISASignUpFlow,
			shouldSkipVPCSignupFlow = v10.shouldSkipVPCSignupFlow,
			shouldDisableUsernameAutofill = v10.shouldDisableUsernameAutofill,
			shouldRequireSignupCheckbox = v10.shouldRequireSignupCheckbox,
			signupLegalDisclaimerTextVariant = v10.signupLegalDisclaimerTextVariant,
			isIosAuthServiceEnabled = v11.enableNewIosPasswordSaving or false
		}
	end
)(v8)

local v10 = withNavigationProps(function(p2, p3)
	return p3
end)(v9)

local function SinglePageSignUpWithAuditContent(p2)
	local v11 = auditContentContext.useAuditContentContext()

	return Roact.createElement(
		v10,
		Cryo.Dictionary.join(p2, {
			capturedAuditContent = v11.capturedAuditContent,
			additionalAuditContent = v11.additionalAuditContent
		})
	)
end

return function(p2)
	local v11 = ReactFocusNavigation.useFocusedGuiObject()
	local v12 = ReactFocusNavigation.useFocusGuiObject()
	local v13 = if defineFastFlag8 then useBreakpointXOrSmaller(Responsive.Keys.Medium) else nil
	local joined = useTokens()
	local v14

	if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAccountSwitcherForceDarkAuthTheme then
		v14 = React.useState(function()
			return module33 and Models.fromLocalStorage().userId ~= -1
		end)
	else
		v14 = false
	end

	if joined and (game:DefineFastFlag("SignupFoundationBackgroundDarkFix", false) or v14) then
		joined = Cryo.Dictionary.join(joined, {
			Color = Foundation.Utility.getTokens(Foundation.Enums.ColorMode.Dark).Color
		})
	end

	local v15 = RoactAppExperiment.useBrowserTrackerExperiment(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p3)
			local v16 = p3[appBtidLayers.AuthenticationStylingLayer] or {}
			return {
				shouldUseFoundationBackgroundColor = v16.shouldUseFoundationBackgroundColor,
				shouldUseFoundationUsernameTextInput = v16.shouldUseFoundationUsernameTextInput
			}
		end
	)

	local shouldUseFoundationBackgroundColor = v15.shouldUseFoundationBackgroundColor
	local shouldUseFoundationUsernameTextInput = getFFlagAuthCollapsingValidatorFoundationInput()
		and v15.shouldUseFoundationUsernameTextInput

	local module71 = require("@luauforge/bundled/gzh")
	local module72 = require("@luauforge/bundled/hMB")
	local v16

	if module71 then
		local platform = if module72() and p2.platform then p2.platform else UserInputService:GetPlatform()
		v16 = AuthCommon.Experiments.useAuthEntryVariant(platform) ~= AuthCommon.Experiments.AuthEntryVariant.Control
			and (platform == Enum.Platform.IOS or platform == Enum.Platform.Android)
	else
		v16 = false
	end

	local state, setState = React.useState(false)

	local v17 = usePreferredInput()
	local v18 = v17 == Responsive.Input.Directional

	local v19 = useDispatch()
	local v20 = React.useCallback(function()
		if not v18 then
			return
		end

		if state then
			v19(module48(module21.SignUpExitModal, {
				onClose = function()
					v19(module58())
					v19(function()
						v12(v11)
					end)
				end,
				onConfirm = function()
					v19(module58())

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back()
					else
						v19(RobloxAppToastsRodux())
					end
				end
			}))
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v19(RobloxAppToastsRodux())
		end
	end, { state, v18, v11, v12, v19 })

	if not v18 then
		v20 = nil
	end

	local v22 = useSignUpPageNavigationBindings(v20)

	local v23, v24 = ReactFocusNavigation.useDefaultFocusBehavior(v22)

	local ref = React.useRef(nil)

	if getFFlagEnableAuditForSinglePageSignUp() then
		local createElement = Roact.createElement
		local provider = auditContentContext.Provider
		local createElement2 = Roact.createElement

		local join = Cryo.Dictionary.join
		local v28 = {
			signUpStarted = if v18 then state else nil,
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

		if not v18 then
			setState = nil
		end

		v28.setSignUpStarted = setState
		v28.shouldShowBackButton = not v18
		v28.preferredInput = v17
		v28.focusedGuiObject = v11
		v28.focusGuiObject = v12
		v28.defaultRef = v23
		v28.containerRef = v24
		v28.birthdayContainerRef = ref
		v28.isCompactView = v13
		v28.foundationTokens = joined
		v28.shouldUseFoundationBackgroundColor = shouldUseFoundationBackgroundColor
		v28.shouldUseFoundationSignupFields = v16
		v28.shouldUseFoundationUsernameTextInput = shouldUseFoundationUsernameTextInput
		return createElement(provider, nil, {
			SignUpPage = createElement2(SinglePageSignUpWithAuditContent, join(p2, v28))
		})
	else
		local createElement = Roact.createElement

		local join = Cryo.Dictionary.join
		local v26 = {
			signUpStarted = if v18 then state else nil,
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

		if not v18 then
			setState = nil
		end

		v26.setSignUpStarted = setState
		v26.shouldShowBackButton = not v18
		v26.preferredInput = v17
		v26.focusedGuiObject = v11
		v26.focusGuiObject = v12
		v26.defaultRef = v23
		v26.containerRef = v24
		v26.birthdayContainerRef = ref
		v26.isCompactView = v13
		v26.foundationTokens = joined
		v26.shouldUseFoundationBackgroundColor = shouldUseFoundationBackgroundColor
		v26.shouldUseFoundationSignupFields = v16
		v26.shouldUseFoundationUsernameTextInput = shouldUseFoundationUsernameTextInput
		return createElement(v10, join(p2, v26))
	end
end
