local CorePackages = game:GetService("CorePackages")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(CorePackages.Packages.Cryo)

local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module = require("@luauforge/bundled/fBV")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local module2 = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module4 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/grb")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module6 = require("@luauforge/bundled/ecq")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local getPasswordManagerUsageStore = AuthCommon.Stores.GetPasswordManagerUsageStore

local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module8 = require("@luauforge/bundled/dFu")
local module9 = require("@luauforge/bundled/ghZ")
local module10 = require("@luauforge/bundled/hOw")
local module11 = require("@luauforge/bundled/hOx")
local module12 = require("@luauforge/bundled/hOy")
local module13 = require("@luauforge/bundled/ghV")
local module14 = require("@luauforge/bundled/geZ")
local module15 = require("@luauforge/bundled/hOz")
local module16 = require("@luauforge/bundled/ehB")

local module17 = require("@luauforge/bundled/hOA")
local module18 = require("@luauforge/bundled/ehm")
local module19 = require("@luauforge/bundled/gyh")
local module20 = require("@luauforge/bundled/grz")
local module21 = require("@luauforge/bundled/gtF")
local module22 = require("@luauforge/bundled/ggi")
local module23 = require("@luauforge/bundled/gxU")
local module24 = require("@luauforge/bundled/fCM")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module26 = require("@luauforge/bundled/hOB")
local module27 = require("@luauforge/bundled/gyj")

local module28 = require("@luauforge/bundled/grv")
local module29 = require("@luauforge/bundled/hOC")
local isStringEmail = AuthCommon.Utils.isStringEmail
local isStringPhone = AuthCommon.Utils.isStringPhone
local scheduleAccountSwitchRelaunchFallback = AuthCommon.Utils.scheduleAccountSwitchRelaunchFallback
local enrolledInLuafiedRecoveryExperiment = AuthCommon.Experiments.enrolledInLuafiedRecoveryExperiment

local module30 = require("@luauforge/bundled/hOE")
local module31 = require("@luauforge/bundled/hOF")
local module32 = require("@luauforge/bundled/gyg")
local module33 = require("@luauforge/bundled/hOL")

local module34 = require("@luauforge/bundled/fBF")
local module35 = require("@luauforge/bundled/hOM")
local alignment = AuthCommon.Enums.Alignment
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local module36 = require("@luauforge/bundled/gfK")
local module37 = require("@luauforge/bundled/ehl")
local module38 = require("@luauforge/bundled/hLG")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module39 = require("@luauforge/bundled/egZ")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local module40 = require("@luauforge/bundled/gif")
local module41 = require("@luauforge/bundled/hOt")
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local module42 = require("@luauforge/bundled/fzS")
local module43 = require("@luauforge/bundled/dzD")
local accountSwitcherConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.AccountSwitcherConstants
local module44 = require("@luauforge/bundled/gfH")
local linkButton = UIBlox.App.Button.LinkButton

local module45 = require("@luauforge/bundled/dFt")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3eAuth = SharedFlags.FFlagSignalsNavP3eAuth

local getLegacyNavigationStore = if fFlagSignalsNavP3eAuth then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local module47 = require("@luauforge/bundled/gJi")
local module48 = require("@luauforge/bundled/hON")

local module49 = require("@luauforge/bundled/hOO")

local module50 = require("@luauforge/bundled/hOP")
local module51 = require("@luauforge/bundled/hOQ")
local module52 = require("@luauforge/bundled/hOS")
local module53 = require("@luauforge/bundled/gxP")
local module54 = require("@luauforge/bundled/ggs")
local module55 = require("@luauforge/bundled/gJp")
local getFFlagLuaAppEnableDesktopDualLoginABTest = SharedFlags.GetFFlagLuaAppEnableDesktopDualLoginABTest
local module56 = require("@luauforge/bundled/hOT")

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/ggu").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local module57 = require("@luauforge/bundled/hOU")
local module58 = require("@luauforge/bundled/hOV")

local module59 = require("@luauforge/bundled/hOW")

local module60 = require("@luauforge/bundled/hOX")

local module61 = require("@luauforge/bundled/hOY")

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local defineFastFlag = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOn2SVLoginV1",
	false
)

local module62 = require("@luauforge/bundled/ggu")
local constants = module62.Constants
local default = module62.CredentialsProtocol.default
local credentialsProtocolErrorCodes = module62.CredentialsProtocolErrorCodes
local getCredentialsTimeoutSeconds = module62.getCredentialsTimeoutSeconds

local defineFastFlag2 = game:DefineFastFlag("LuaAppFixLoginV1UnifiedCredentialTimeout", false)
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module63 = require("@luauforge/bundled/gfG")
local module64 = require("@luauforge/bundled/ggt")
local module65 = require("@luauforge/bundled/gut")
local module66 = require("@luauforge/bundled/ghR")
local module67 = require("@luauforge/bundled/guB")
local module68 = require("@luauforge/bundled/grR")
local fFlagAccountSwitchRelaunchFallback = SharedFlags.FFlagAccountSwitchRelaunchFallback

local defineFastFlag3 = game:DefineFastFlag("AwaitLoginCompletionForDisambiguationFlow", false)

game:DefineFastFlag("LuaLoginManualCredentialValidation", false)
local fFlagEnablePasskeyLoginErrorLogging = SharedFlags.FFlagEnablePasskeyLoginErrorLogging
local fFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
local fFlagUseGenericAccountSwitchSignOutCopy = SharedFlags.FFlagUseGenericAccountSwitchSignOutCopy
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore

local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module70 = require("@luauforge/bundled/fvN")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Promise = require(CorePackages.Packages.Promise)

local module71 = require("@luauforge/bundled/hOZ")
local module72 = require("@luauforge/bundled/hPa")
local defineFastFlag4 = game:DefineFastFlag("FixLoginButtonSpamClickRace", false)
local module73 = require("@luauforge/bundled/hPb")

local module74 = require("@luauforge/bundled/ggv")
local getUserByUsername = AuthCommon.Thunks.GetUserByUsername
local withNavigationProps = require("@luauforge/bundled/dFz").withNavigationProps
local keystoreConstants = AuthCommon.Common.KeystoreConstants
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local accountLinkingAlertType = AuthCommon.Enums.AccountLinkingAlertType
local twoStepErrorCodes = AuthCommon.Enums.TwoStepErrorCodes
local getTwoStepLoginErrorKey = AuthCommon.Utils.getTwoStepLoginErrorKey

local defineFastFlag5 = game:DefineFastFlag("LoginButtonAutoDisabled", false)
local defineFastFlag6 = game:DefineFastFlag("UseCrossDeviceLoginByDefault1", false)

local fFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose = SharedFlags.FFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose
local defineFastFlag7 = game:DefineFastFlag("EnableTwoStepLoginChallengeAnalytics", false)
local defineFastFlag8 = game:DefineFastFlag("DebugOTPBypass", false)
local defineFastFlag9 = game:DefineFastFlag("EnableGenericQuickSignInLoginError", false)

local getFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow
local fFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local fFlagLuaAppSkipDuplicateIosPasswordSavePrompt = SharedFlags.FFlagLuaAppSkipDuplicateIosPasswordSavePrompt
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable

local getFFlagEnable2SVRecovery = require("@luauforge/bundled/gnt").Flags.GetFFlagEnable2SVRecovery

local module75 = require("@luauforge/bundled/fGL")

local module76 = require("@luauforge/bundled/fzT")
local telemetryConfigs = module76.TelemetryConfigs
local iosAuthServiceHealthCounters = module76.RobloxTelemetry.IosAuthServiceHealthCounters
local fFlagEnableTimeToLoginMetrics = module76.Flags.FFlagEnableTimeToLoginMetrics

local fFlagRestartTimeToLoginOnHumanInteractionRetry = module76.Flags.FFlagRestartTimeToLoginOnHumanInteractionRetry
local default2 = module76.RobloxTelemetry.TimeToLoginTracker.default
local loginType = module76.LoginType
local keystoreSaveCredentialsTelemetryConfig = telemetryConfigs.KeystoreSaveCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")

local passkeyConstants = AuthCommon.Common.PasskeyConstants

local isIosAuthServiceEnabled = AuthCommon.Utils.isIosAuthServiceEnabled
local coarseLoginErrorBucket = AuthCommon.Utils.coarseLoginErrorBucket
local isNonTerminalLoginError = AuthCommon.Utils.isNonTerminalLoginError
local fillGenericLoginErrorKey = AuthCommon.Utils.fillGenericLoginErrorKey
local shouldSkipLegacyPasswordSaveEvent = AuthCommon.Utils.shouldSkipLegacyPasswordSaveEvent

local extended = module2.PureComponent:extend("LoginView")

local v5 = module57()

local v6 = { CValue = 1, Password = 2 }

local function isLoginPageCurrent()
	return getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false)
end

function extended:init()
	local v7 = false

	self.cvalueRef = module2.createRef()
	self.passwordRef = module2.createRef()
	self.loginButtonRef = module2.createRef()
	self.forgotLinkRef = module2.createRef()
	self.crossDeviceButtonRef = module2.createRef()
	self.emailOtpRef = module2.createRef()
	self.focusRef = module2.createRef()

	local v8 = AppStorageService:GetItem(localStorageKey.CredentialValue)

	if module66 then
		local item = AppStorageService:GetItem(localStorageKey.AccountBlob)
		v8 = item and item ~= "" and "" or v8
	end

	if self.props.forcedUsernameOverride then
		v8 = self.props.forcedUsernameOverride
	end

	local binding, v9 = module2.createBinding(v8)
	self.cvalueText = binding
	self.updateCValueText = v9
	local binding2, v10 = module2.createBinding("")
	self.passwordText = binding2
	self.updatePasswordText = v10

	self.state = {
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

	self.loginSubmitGuard = module73.new()

	self.passwordManagerUsageStore = getPasswordManagerUsageStore(false)

	if fFlagEnablePWManagerSignupCheck and self.passwordManagerUsageStore then
		self.passwordManagerUsageStore.resetAll()
	elseif self.passwordManagerUsageStore then
		self.passwordManagerUsageStore.setLoggedinUsingSavedPassword(false)
		self.passwordManagerUsageStore.setSavedPasswordAfterLogin(false)
	end

	self.errorHandlingInfoList = {
		[module35.IncorrectCValueOrPassword] = {
			textBoxesToClear = { 2 },
			newFocusedTextBox = 2
		},
		[module35.CValueAndPasswordRequired] = {
			textBoxesToClear = { 2 },
			newFocusedTextBox = 2
		},
		[module35.AccountLocked] = {
			textBoxesToClear = { 2 }
		},
		[module35.MoreThanOneUsername] = {
			textBoxesToClear = { 1, 2 },
			newFocusedTextBox = 1,
			forceLoginByUsername = true
		},
		[module35.AccountNotVerified] = {
			textBoxesToClear = { 1, 2 },
			forceLoginByUsername = true
		},
		[module35.MultipleUsersPerCredential] = self.props.appPolicy.getAccountDisambiguationDisabled() and {
			textBoxesToClear = { 1, 2 },
			newFocusedTextBox = 1,
			forceLoginByUsername = true
		} or nil
	}

	self.isAlreadyAuthenticated = Models.fromLocalStorage().userId ~= -1

	function LUAUFORGE_MODULE_GLOBALS_hOv_resetDefaultTheme()
		local authenticatedTheme = module63.getAuthenticatedTheme()

		if authenticatedTheme ~= "" then
			MemStorageService:Fire(module36.ThemeUpdate, authenticatedTheme)
		end

		module75.ClearThemeOverride()
	end

	function self.cancelTimeToLoginAttempt()
		if fFlagEnableTimeToLoginMetrics then
			default2.cancel()
		end
	end

	function self.updateIsLoginInProgress(p2)
		if defineFastFlag4 then
			self.loginSubmitGuard:setInProgress(p2)
		end

		spawn(function()
			if defineFastFlag4 then
				if self.isMounted then
					self:setState({ isLoginInProgress = p2 })
				end
			else
				local isLoginInProgress = self.state.isLoginInProgress

				if self.isMounted and isLoginInProgress ~= p2 then
					self:setState({ isLoginInProgress = p2 })
				end
			end
		end)
	end

	function self.isLoginSubmitBlocked()
		if defineFastFlag4 then
			return self.loginSubmitGuard:isBlocked()
		end

		return self.state.isLoginInProgress
	end

	function self.onTextBoxesChanged(p2)
		if not (self.cvalueRef.current and self.passwordRef.current and self.isMounted) then
			return
		end

		local v12 = p2.Text:gsub("\t", "")

		if p2.Text ~= v12 then
			p2.Text = v12
		end

		self:setState({
			loginButtonDisabled = #self.cvalueRef.current.Text == 0 or #self.passwordRef.current.Text == 0,
			errorKey = #p2.Text == 0 and self.state.errorKey or "",
			errorCode = -1
		})
	end

	function self.unfocusTextBoxes()
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if
			focusedTextBox
			and (focusedTextBox == self.cvalueRef.current or focusedTextBox == self.passwordRef.current)
		then
			focusedTextBox:ReleaseFocus()
		end
	end

	function self.handleCaptchaResult(p2, p3)
		if p2 then
			self.handleLoginWithFormData(p3)
			return
		end

		self.cancelTimeToLoginAttempt()
		self.updateIsLoginInProgress(false)
	end

	function self.getCaptchaResultHandlerWithCode(p2, p3)
		return function(p4, p5)
			if p4 then
				self.handleLoginWithCode(p2, p3, p5)
				return
			end

			self.cancelTimeToLoginAttempt()
			self.updateIsLoginInProgress(false)
		end
	end

	function self.cancelAccountSwitchLogin()
		self.cancelTimeToLoginAttempt()
		self.props.closeCentralOverlay()
	end

	function self.getSecurityQuestionsLoginWithCodeCallback(p2, p3)
		return function(p4)
			self.handleLoginWithCode(p2, p3, nil, p4)
		end
	end

	function self.getSecurityQuestionsLoginWithOtpCallback()
		return function(p2)
			self.handleLoginWithOtp(p2, nil)
		end
	end

	function self.getSecurityQuestionsLoginWithFormDataCallback()
		return function(p2)
			self.handleLoginWithFormData(nil, p2)
		end
	end

	function self.canVerifyCredentials(p2, p3, p4)
		return module26(self.props.networking, p2, p3, p4):andThen(function(p5)
			return p5 and p5.responseBody and p5.responseBody.canSend
		end, function(): boolean
			return false
		end)
	end

	function self.handleLoginWithCode(p2, p3, p4, p5)
		self.updateIsLoginInProgress(true)

		if
			fFlagEnableTimeToLoginMetrics
			and module33(fFlagRestartTimeToLoginOnHumanInteractionRetry, p4, p5, nil)
		then
			default2.start(loginType.AuthCode)
		end

		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		self.unfocusTextBoxes()
		setBackNavigationDisabled(true)

		local loginByCode = self.props.loginByCode
		local captchaResultHandlerWithCode = self.getCaptchaResultHandlerWithCode(p2, p3)
		local securityQuestionsLoginWithCodeCallback = self.getSecurityQuestionsLoginWithCodeCallback(p2, p3)
		return loginByCode(
			self.props.networking,
			p2,
			p3,
			captchaResultHandlerWithCode,
			p4,
			securityQuestionsLoginWithCodeCallback,
			p5
		):andThen(
			function(p6)
				self.handleLoginResult(p6, nil)
			end,
			function(p6)
				local v12 = {
					accountSelectorEnabled = module56() and not self.props.appPolicy.getAccountDisambiguationDisabled(),
					securityQuestionsEnabled = module50(),
					accountSwitchEnabled = module66
				}

				if fFlagEnableTimeToLoginMetrics and not isNonTerminalLoginError(p6, v12) then
					default2.cancel()
				end

				if defineFastFlag9 then
					fillGenericLoginErrorKey(p6, v12)
				end

				if p6.errorCode ~= module35.Captcha then
					module40(module41.FailureAuthCode, 1)
				end

				self.handleLoginError(p6, p2, p3)
			end
		)
	end

	function self.handleLoginWithPasskey(p2, p3, p4)
		v7 = false
		self.updateIsLoginInProgress(true)

		if fFlagEnableTimeToLoginMetrics then
			default2.start(loginType.Passkey)
		end

		local setBackNavigationDisabled = self.props.setBackNavigationDisabled
		self.unfocusTextBoxes()
		setBackNavigationDisabled(true)
		return self.props.loginByPasskey(self.props.networking, p2, p3):andThen(function(p5)
			if module13.hasTwoStepData(p5) then
				iosAuthServiceHealthCounters.reportLoginTwoStepRequired({
					credentialType = "passkey",
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})
			else
				iosAuthServiceHealthCounters.reportLoginSuccess({
					credentialType = "passkey",
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})

				if p4 and isIosAuthServiceEnabled() then
					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessConfig,
						1,
						{ credentialType = "passkey" }
					)
				end
			end

			self.handleLoginResult(p5, nil, "passkey")
		end, function(p5)
			if not isNonTerminalLoginError(p5, {
				accountSelectorEnabled = module56() and not self.props.appPolicy.getAccountDisambiguationDisabled(),
				securityQuestionsEnabled = module50(),
				accountSwitchEnabled = module66
			}) then
				if fFlagEnableTimeToLoginMetrics then
					default2.cancel()
				end

				iosAuthServiceHealthCounters.reportLoginFailure({
					credentialType = "passkey",
					errorCode = coarseLoginErrorBucket(p5),
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})

				if p4 and isIosAuthServiceEnabled() then
					local v12 = { credentialType = "passkey" }

					if p5 and p5.errorCode ~= nil then
						v12.errorCode = tostring(p5.errorCode)
					end

					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureConfig,
						1,
						v12
					)
				end
			end

			self.handleLoginError(p5, p2)
		end)
	end

	function self.showPasskeyLoginPopup()
		local networking = self.props.networking
		return self.props.startPasskeyAuthentication(networking):andThen(function(p2)
			local jsonDecode = HttpService:JSONDecode(p2.authenticationOptions)
			local sessionId = p2.sessionId
			local timeout = tonumber(jsonDecode.publicKey.timeout)
			jsonDecode.keyType = "platform"
			jsonDecode.deviceBoundOnly = true

			if UserInputService:GetPlatform() ~= Enum.Platform.Android then
				jsonDecode.publicKey.challenge = module30.FromUrlSafeBase64(jsonDecode.publicKey.challenge)
			end

			local jsonEncode = HttpService:JSONEncode(jsonDecode)
			default:getCredentials(default.CredentialsTypes.FIDO2, jsonEncode, timeout):andThen(
				function(json)
					local jsonDecode2 = HttpService:JSONDecode(json)

					if jsonDecode2 == nil or next(jsonDecode2) == nil then
						logger:info("Passkey credential signing failed. No result returned.")
					elseif jsonDecode2.errorCode == nil then
						logger:info("Passkey credential signing completed. Attempting login.")

						jsonDecode2.id = module30.ToUrlSafeBase64(jsonDecode2.id)
						jsonDecode2.rawId = module30.ToUrlSafeBase64(jsonDecode2.rawId)
						jsonDecode2.response.signature = module30.ToUrlSafeBase64(jsonDecode2.response.signature)
						jsonDecode2.response.userHandle = module30.ToUrlSafeBase64(jsonDecode2.response.userHandle)
						jsonDecode2.response.authenticatorData = module30.ToUrlSafeBase64(jsonDecode2.response.authenticatorData)
						jsonDecode2.response.clientDataJSON = module30.ToUrlSafeBase64(jsonDecode2.response.clientDataJSON)
						self.handleLoginWithPasskey(jsonDecode2, sessionId)
					else
						logger:info(
							"Passkey credential signing failed. Error {} (msg: {}) returned.",
							jsonDecode2.errorCode,
							jsonDecode2.errorMsg
						)

						local errorCode = tonumber(jsonDecode2.errorCode)
						local v12 = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[errorCode or -1]
							or string.format(
								credentialsProtocolErrorCodes.UNMAPPED_ERROR_CODE,
								(tostring(jsonDecode2.errorCode))
							)

						self.props.authAnalytics.reportAuthClientError(
							module42.Context.PasskeyLoginAttempt,
							v12,
							passkeyConstants.PASSKEY_FETCH_LOGIN_V1
						)
					end
				end,
				function(p3)
					logger:warning("Passkey credential signing failed. Error: {}", p3)
				end
			)
		end, function(p2)
			logger:warning("Fetching passkey login options failed with error code: {}", p2.errorCode)
		end)
	end

	function self.showGenericCredentialLoginPopup(p2, p3)
		if p2 or p3 then
			local networking = self.props.networking
			local startPasskeyAuthentication = self.props.startPasskeyAuthentication
			local v12 = nil
			local sessionId = nil
			local timeout = nil

			local v13 = {}

			if p2 then
				startPasskeyAuthentication(networking):andThen(function(p4)
					v12 = HttpService:JSONDecode(p4.authenticationOptions)
					sessionId = p4.sessionId
					timeout = tonumber(v12.publicKey.timeout)
					v12.keyType = "platform"
					v12.deviceBoundOnly = true

					if UserInputService:GetPlatform() ~= Enum.Platform.Android then
						v12.publicKey.challenge = module30.FromUrlSafeBase64(v12.publicKey.challenge)
					end
				end, function(p4)
					logger:warning(
						"Fetching passkey login options failed with error code: {}",
						p4.errorCode
					)

					if defineFastFlag2 then
						self.props.authAnalytics.reportAuthClientError(
							module42.Context.PasskeyLoginAttempt,
							tostring(p4.errorCode),
							passkeyConstants.GENERIC_CREDENTIAL_FETCH_LOGIN_V1
						)
					end
				end):await()

				if v12 ~= nil then
					v13.FIDO2 = v12
				end
			end

			if p3 then
				v13.password = {}
			end

			local jsonEncode = HttpService:JSONEncode(v13)

			if isIosAuthServiceEnabled() then
				self.props.loggingProtocol:logRobloxTelemetryCounter(
					telemetryConfigs.IosAuthServiceLoginCredentialSheetShownConfig,
					1
				)
			end

			local v14 = if defineFastFlag2 then getCredentialsTimeoutSeconds(timeout) else timeout / 1000

			return default:getCredentials(default.CredentialsTypes.all, jsonEncode, v14):andThen(
				function(json)
					local jsonDecode = HttpService:JSONDecode(json)

					if jsonDecode == nil or not (jsonDecode.response or jsonDecode.errorCode) then
						logger:info("Generic credential fetch failed. No result returned.")

						if isIosAuthServiceEnabled() then
							self.props.loggingProtocol:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig,
								1
							)
						end
					elseif jsonDecode.errorCode == nil then
						if jsonDecode.credentialType == default.CredentialsTypes.password then
							local username = jsonDecode.response.username
							local password = jsonDecode.response.password

							self.updateCValueText(username)
							self.updatePasswordText(password)

							if isIosAuthServiceEnabled() then
								self.props.loggingProtocol:logRobloxTelemetryCounter(
									telemetryConfigs.IosAuthServiceLoginCredentialSheetPasswordSelectedConfig,
									1
								)
							end

							self.props.authAnalytics.reportAuthButtonClick(
								module42.Context.CMPasswordLogin,
								module42.Button.SelectPassword
							)

							self.updateIsLoginInProgress(true)
							self.handleLoginWithFormData(nil, nil, nil, true)
						elseif jsonDecode.credentialType == default.CredentialsTypes.FIDO2 then
							if isIosAuthServiceEnabled() then
								self.props.loggingProtocol:logRobloxTelemetryCounter(
									telemetryConfigs.IosAuthServiceLoginCredentialSheetPasskeySelectedConfig,
									1
								)
							end

							jsonDecode.response.id = module30.ToUrlSafeBase64(jsonDecode.response.id)
							jsonDecode.response.rawId = module30.ToUrlSafeBase64(jsonDecode.response.rawId)
							jsonDecode.response.response.signature = module30.ToUrlSafeBase64(jsonDecode.response.response.signature)
							jsonDecode.response.response.userHandle = module30.ToUrlSafeBase64(jsonDecode.response.response.userHandle)
							jsonDecode.response.response.authenticatorData = module30.ToUrlSafeBase64(jsonDecode.response.response.authenticatorData)
							jsonDecode.response.response.clientDataJSON = module30.ToUrlSafeBase64(jsonDecode.response.response.clientDataJSON)
							self.handleLoginWithPasskey(jsonDecode.response, sessionId, true)
						end
					else
						logger:info(
							"Generic credential fetch failed. Error {} (msg: {}) returned.",
							jsonDecode.errorCode,
							jsonDecode.errorMsg
						)

						if isIosAuthServiceEnabled() then
							local getCredentialsErrorCode = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[tonumber(jsonDecode.errorCode) or -1]

							if getCredentialsErrorCode == "CANCELLATION_ERROR" then
								self.props.loggingProtocol:logRobloxTelemetryCounter(
									telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig,
									1
								)
							else
								self.props.loggingProtocol:logRobloxTelemetryCounter(
									telemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig,
									1,
									{
										errorCode = getCredentialsErrorCode or tostring(jsonDecode.errorCode)
									}
								)
							end
						end

						if
							fFlagEnablePasskeyLoginErrorLogging
							and type(jsonDecode.errorMsg) == "string"
						then
							self.props.authAnalytics.reportAuthClientError(
								module42.Context.PasskeyLoginAttempt,
								jsonDecode.errorMsg,
								passkeyConstants.GENERIC_CREDENTIAL_FETCH_LOGIN_V1
							)
						end
					end
				end,
				function(p4)
					logger:warning("Generic credential signing failed. Error: {}", p4)

					if isIosAuthServiceEnabled() then
						local v15 = if typeof(p4) == "table" then tonumber(p4.errorCode) else tonumber(p4)
						local getCredentialsErrorCode = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[v15 or -1]

						if getCredentialsErrorCode == "CANCELLATION_ERROR" then
							self.props.loggingProtocol:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig,
								1
							)
						else
							self.props.loggingProtocol:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig,
								1,
								{
									errorCode = getCredentialsErrorCode or "rejected"
								}
							)
						end
					end
				end
			)
		elseif isIosAuthServiceEnabled() then
			self.props.loggingProtocol:logRobloxTelemetryCounter(
				telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
				1,
				{ errorCode = "noSupportedCredentials" }
			)
		end
	end

	function self.showSavedCredentialsPrompt()
		if module60() then
			local v12 = false
			local v13 = false
			local v14 = false

			default:isAvailable(
				default.CredentialsTypes.FIDO2,
				getFIntLuaAppCredentialsProtocolAvailableTimeout()
			):andThen(function(data)
				if data.FIDO2 == nil then
					v12 = data.isAvailable and data.supportsDeviceBoundOnly
				else
					v12 = data.FIDO2.isAvailable and data.FIDO2.supportsDeviceBoundOnly
					v13 = data.password and data.password.isAvailable

					v14 = data.password ~= nil

					if self.isMounted then
						self:setState({
							isCredentialsProtocolRegisterPasswordAvailable = v13
						})
					end
				end

				if v14 then
					self.showGenericCredentialLoginPopup(v12, v13)
				elseif v12 then
					self.showPasskeyLoginPopup()
				elseif isIosAuthServiceEnabled() then
					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
						1,
						{ errorCode = "protocolNotSupported" }
					)
				end
			end):catch(function(p2)
				logger:warning("Error checking for available credential types. Error: {}", p2)

				if isIosAuthServiceEnabled() then
					self.props.loggingProtocol:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
						1,
						{ errorCode = "protocolUnavailable" }
					)
				end
			end):finally(function()
				self.props.authAnalytics.reportAuthPageload(
					module42.Context.CMPasswordLogin,
					(tostring(v13))
				)

				self.props.authAnalytics.reportAuthPageload(
					module42.Context.PasskeyLogin,
					v12 == nil and "timeout" or tostring(v12)
				)
			end)
		else
			local v12 = false

			default:isAvailable(
				default.CredentialsTypes.FIDO2,
				getFIntLuaAppCredentialsProtocolAvailableTimeout()
			):andThen(function(p2)
				v12 = p2.isAvailable and p2.supportsDeviceBoundOnly

				if v12 then
					self.showPasskeyLoginPopup()
				end
			end):catch(function(p2)
				warn("Error checking if FIDO2 passkeys is available. Error: ", p2)
			end):finally(function()
				self.props.authAnalytics.reportAuthPageload(
					module42.Context.PasskeyLogin,
					v12 == nil and "timeout" or tostring(v12)
				)
			end)
		end
	end

	function self.handleLoginWithOtp(p2, p3)
		if not module58() and self.props.isLoginWithOtpEnabled then
			return
		end

		self.updateIsLoginInProgress(true)

		if
			fFlagEnableTimeToLoginMetrics
			and module33(fFlagRestartTimeToLoginOnHumanInteractionRetry, nil, p2, p3)
		then
			default2.start(loginType.EmailOtp, "Email")
		end

		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		self.unfocusTextBoxes()
		setBackNavigationDisabled(true)

		local loginByOtp = self.props.loginByOtp
		local securityQuestionsLoginWithOtpCallback = self.getSecurityQuestionsLoginWithOtpCallback()
		return loginByOtp(
			self.props.networking,
			self.state.otpSessionToken,
			self.state.otpCode,
			securityQuestionsLoginWithOtpCallback,
			p2,
			p3
		):andThen(
			function(p4)
				self.handleLoginResult(p4, nil)
			end,
			function(p4)
				if fFlagEnableTimeToLoginMetrics and not isNonTerminalLoginError(p4, {
					accountSelectorEnabled = module56() and not self.props.appPolicy.getAccountDisambiguationDisabled(),
					securityQuestionsEnabled = module50(),
					accountSwitchEnabled = module66
				}) then
					default2.cancel()
				end

				self.handleLoginError(p4, self.state.otpSessionToken, self.state.otpCode)
				return p4.errorKey
			end
		)
	end

	function self.validateFormCredentials(value): boolean
		return #value:gsub("%s+", "") > 0
	end

	function self.handleLoginWithFormData(p2, p3, p4, p5)
		if not (self.cvalueRef.current and self.passwordRef.current) then
			return
		end

		local text = self.cvalueRef.current.Text
		local text2 = self.passwordRef.current.Text

		if
			game:GetFastFlag("LuaLoginManualCredentialValidation")
			and not self.validateFormCredentials(text)
		then
			self.handleLoginError(
				{
					errorKey = "Authentication.Login.Response.IncorrectUsernamePassword",
					errorCode = module35.IncorrectCValueOrPassword
				},
				text,
				text2
			)

			self.updateCValueText("")
		else
			if
				fFlagEnableTimeToLoginMetrics
				and module33(fFlagRestartTimeToLoginOnHumanInteractionRetry, p2, p3, p4)
			then
				local v12

				if self.state.forceLoginByUsername then
					v12 = "Username"
				elseif isStringEmail(text) then
					v12 = "Email"
				else
					v12 = if isStringPhone(text) then "PhoneNumber" else "Username"
				end

				default2.start(loginType.Password, v12)
			end

			local setBackNavigationDisabled = self.props.setBackNavigationDisabled

			self.unfocusTextBoxes()
			setBackNavigationDisabled(true)

			local login = self.props.login
			local handleCaptchaResult = self.handleCaptchaResult
			local networking = self.props.networking
			local securityQuestionsLoginWithFormDataCallback = self.getSecurityQuestionsLoginWithFormDataCallback()
			local forceLoginByUsername = self.state.forceLoginByUsername
			v7 = true

			return login(
				networking,
				text,
				text2,
				handleCaptchaResult,
				p2,
				securityQuestionsLoginWithFormDataCallback,
				p3,
				p4,
				forceLoginByUsername
			):andThen(
				function(p6)
					AppStorageService:SetItem(localStorageKey.CredentialValue, text)
					AppStorageService:flush()

					if module13.hasTwoStepData(p6) then
						iosAuthServiceHealthCounters.reportLoginTwoStepRequired({
							credentialType = "password",
							iosAuthServiceEnabled = isIosAuthServiceEnabled()
						})
					else
						iosAuthServiceHealthCounters.reportLoginSuccess({
							credentialType = "password",
							iosAuthServiceEnabled = isIosAuthServiceEnabled()
						})
					end

					if p5 then
						self.props.authAnalytics.reportAuthFormInteraction(
							module42.Context.CMPasswordLogin,
							nil,
							"success"
						)

						if isIosAuthServiceEnabled() and not module13.hasTwoStepData(p6) then
							self.props.loggingProtocol:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessConfig,
								1,
								{ credentialType = "password" }
							)
						end

						if self.passwordManagerUsageStore then
							self.passwordManagerUsageStore.setLoggedinUsingSavedPassword(true)
						end
					end

					local v12 = if not p5 then HttpService:JSONEncode({
						cvalue = text,
						password = text2,
						authType = "login"
					}) else nil

					self.handleLoginResult(p6, v12, "password")
				end,
				function(p6)
					local v12 = not isNonTerminalLoginError(p6, {
						accountSelectorEnabled = module56() and not self.props.appPolicy.getAccountDisambiguationDisabled(),
						securityQuestionsEnabled = module50(),
						accountSwitchEnabled = module66
					})

					if v12 then
						if fFlagEnableTimeToLoginMetrics then
							default2.cancel()
						end

						iosAuthServiceHealthCounters.reportLoginFailure({
							credentialType = "password",
							errorCode = coarseLoginErrorBucket(p6),
							iosAuthServiceEnabled = isIosAuthServiceEnabled()
						})
					end

					if p5 then
						self.props.authAnalytics.reportAuthFormInteraction(
							module42.Context.CMPasswordLogin,
							nil,
							"error"
						)

						if isIosAuthServiceEnabled() and v12 then
							local v13 = { credentialType = "password" }

							if p6 and p6.errorCode ~= nil then
								v13.errorCode = tostring(p6.errorCode)
							end

							self.props.loggingProtocol:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureConfig,
								1,
								v13
							)
						end
					end

					self.handleLoginError(p6, text, text2)
				end
			)
		end
	end

	function self.renderSecurityQuestions(p2, p3, callback, p4)
		self.props.renderChallenge({
			challengeType = module47.SecurityQuestions,
			challengeParameters = {
				sessionId = p4.sessionId,
				userId = p4.userId,
				onChallengeCompleted = function(p5)
					callback({
						sessionId = p4.sessionId,
						redemptionToken = p5.redemptionToken
					})
				end,
				onChallengeInvalidated = function(p5)
					self.cancelTimeToLoginAttempt()
					self.updateIsLoginInProgress(false)

					if self.isMounted then
						if p5.errorCode == 0 then
							self:setState({
								errorKey = "Authentication.Login.Response.SomethingWentWrong"
							})
						else
							self:setState({
								errorKey = false,
								localizedErrorMessage = p5.errorMessage
							})
						end
					end
				end
			},
			onChallengeAbandoned = function()
				self.cancelTimeToLoginAttempt()
				self.updateIsLoginInProgress(false)
			end,
			onChallengeLoadFailed = function()
				self.cancelTimeToLoginAttempt()
				self.updateIsLoginInProgress(false)

				if self.isMounted then
					self:setState({
						errorKey = "Authentication.Login.Response.SomethingWentWrong"
					})
				end
			end,
			forceWebViewVisible = true
		})
	end

	function self.renderTwoStepChallenge(p2, p3, p4)
		local launchApp = self.props.launchApp
		local networking = self.props.networking
		local appPolicy = self.props.appPolicy
		local analytics = self.props.analytics
		local omniRecommendationsRequest = self.props.omniRecommendationsRequest

		local ticket = p2.twoStepVerificationData.ticket
		local id = p2.user.id
		local handleLoginCompletionWithAccountSwitching = self.props.handleLoginCompletionWithAccountSwitching
		local clearApp = self.props.clearApp

		if module48() then
			wait(module49())
		end

		if defineFastFlag7 then
			self.props.authAnalytics.reportAuthPageload(
				module42.Context.TwoStepLoginChallengeRenderInitiated,
				ticket
			)
		end

		self.props.renderChallenge({
			challengeType = module47.TwoStepVerification,
			challengeParameters = {
				actionType = module55.Login,
				challengeId = ticket,
				userId = id,
				allowRememberDevice = true,
				clientSupports2svRecovery = getFFlagEnable2SVRecovery() and true or false,
				onChallengeCompleted = function(p5)
					if defineFastFlag7 then
						self.props.authAnalytics.reportAuthPageload(
							module42.Context.TwoStepLoginChallengeCompleted,
							ticket
						)
					end

					module52.login(networking, id, ticket, p5.verificationToken, p5.rememberDevice):andThen(
						function(p6)
							if p3 then
								if not (fFlagDisableMemStorageServicePasswordEvent or self.shouldUseIosAuthServicePasswordSave()) then
									MemStorageService:Fire(module36.AuthenticatedCredentials, p3)
								end

								if
									module60()
									and self.state.isCredentialsProtocolRegisterPasswordAvailable
								then
									self.credentialsProtocolRegisterPassword(p3):await()
								end
							end

							module40(module41.Success, 1)

							if p4 then
								iosAuthServiceHealthCounters.reportLoginSuccess({
									credentialType = p4,
									iosAuthServiceEnabled = isIosAuthServiceEnabled()
								})
							end

							if module66 then
								handleLoginCompletionWithAccountSwitching(
									networking,
									omniRecommendationsRequest,
									analytics,
									appPolicy,
									p6.responseBody.accountBlob,
									clearApp,
									launchApp
								)
							else
								launchApp(networking, omniRecommendationsRequest, analytics, appPolicy)
							end
						end,
						function(p6)
							self.cancelTimeToLoginAttempt()
							module40(module41.Failure, 1)

							if p4 then
								iosAuthServiceHealthCounters.reportLoginFailure({
									credentialType = p4,
									errorCode = "twoStepFailed",
									iosAuthServiceEnabled = isIosAuthServiceEnabled()
								})
							end

							local v12 = "Authentication.Login.Response.SomethingWentWrong"

							if defineFastFlag then
								local success, result = pcall(function()
									return HttpService:JSONDecode(p6.Body).errors[1].code
								end)

								if result == twoStepErrorCodes.IllegalChildAccountLinking then
									module40(module41.FailureTwoStepVerification, 1)
								else
									module40(module41.FailureUnknownError, 1)
								end

								v12 = getTwoStepLoginErrorKey(result)
							else
								module40(module41.FailureUnknownError, 1)
							end

							self.updateIsLoginInProgress(false)

							if self.isMounted then
								self:setState({ errorKey = v12 })
							end

							if p6 and p6.Body then
								local jsonDecode = HttpService:JSONDecode(p6.Body)
								local code = jsonDecode
									and jsonDecode.errors
									and jsonDecode.errors[1]
									and jsonDecode.errors[1].code

								local userFacingMessage = jsonDecode
									and jsonDecode.errors
									and jsonDecode.errors[1]
									and jsonDecode.errors[1].userFacingMessage

								if code == twoStepErrorCodes.AccountLinkingRequired then
									self.props.showAccountLinkingAlert(
										accountLinkingAlertType.IncompatibleAccounts,
										userFacingMessage
									)
								end

								if code == twoStepErrorCodes.AccountLinkingFailed then
									self.props.showAccountLinkingAlert(accountLinkingAlertType.RetryLogInConnectionFailure)
								end
							end
						end
					)
				end,
				onChallengeInvalidated = function(p5)
					self.cancelTimeToLoginAttempt()

					if defineFastFlag7 then
						self.props.authAnalytics.reportAuthPageload(
							module42.Context.TwoStepLoginChallengeInvalidated,
							ticket
						)
					end

					self.updateIsLoginInProgress(false)

					if self.isMounted then
						if p5.errorCode == 0 then
							self:setState({
								errorKey = "Authentication.Login.Response.SomethingWentWrong"
							})
						else
							self:setState({
								errorKey = false,
								localizedErrorMessage = p5.errorMessage
							})
						end
					end
				end
			},
			onChallengeAbandoned = function()
				self.cancelTimeToLoginAttempt()

				if defineFastFlag7 then
					self.props.authAnalytics.reportAuthPageload(
						module42.Context.TwoStepLoginChallengeAbandoned,
						ticket
					)
				end

				self.updateIsLoginInProgress(false)
			end,
			onChallengeLoadFailed = function()
				self.cancelTimeToLoginAttempt()

				if defineFastFlag7 then
					self.props.authAnalytics.reportAuthPageload(
						module42.Context.TwoStepLoginChallengeLoadFailed,
						ticket
					)
				end

				self.updateIsLoginInProgress(false)

				if self.isMounted then
					self:setState({
						errorKey = "Authentication.Login.Response.SomethingWentWrong"
					})
				end
			end,
			forceWebViewVisible = true
		})
	end

	function self.handleMultipleUsersPerCredentialError(p2)
		local v12 = ""

		if self.state.isLoginByOtp then
			v12 = module42.Context.DisambiguationOTP
		elseif isStringEmail(self.props.cvalue) then
			v12 = module42.Context.DisambiguationEmail
		elseif isStringPhone(self.props.cvalue) then
			v12 = module42.Context.DisambiguationPhone
		end

		local v13 = {
			origin = module42.Context.Login,
			context = v12,
			users = p2,
			onAccountSelection = function(p3)
				if self.state.isLoginByOtp then
					if defineFastFlag3 then
						self.handleLoginWithOtp(nil, p3):await()
					else
						self.handleLoginWithOtp(nil, p3)
					end
				elseif defineFastFlag3 then
					self.handleLoginWithFormData(nil, nil, p3):await()
				else
					self.handleLoginWithFormData(nil, nil, p3)
				end
			end,
			onAccountSelectionAbandoned = function()
				self.cancelTimeToLoginAttempt()
				self.updateIsLoginInProgress(false)
				self.state.otpSessionToken = ""
				self.state.otpCode = ""
				self.state.isLoginByOtp = false
				self.props.closeCentralOverlay()
			end,
			titleTextKey = "Authentication.Login.Label.AccountSelectorTitle",
			helpTextKey = "Authentication.Login.Description.AccountSelectorHelp",
			screenSize = self.props.screenSize
		}

		local showFoundationDisambiguationSelector = self.props.showFoundationDisambiguationSelector

		if showFoundationDisambiguationSelector then
			v13.hideActions = true
			v13.showFoundationDisambiguationSelector = true
		end

		if module59() then
			self.props.closeCentralOverlay()
		end

		self.props.openAccountSelector(v13, showFoundationDisambiguationSelector)
	end

	function self.performKeystoreOperations(p2, json)
		return Promise.new(function(callback, callback2)
			if (module74 or getFFlagKeystoreAutoLoginAvailable()) == false or json == nil then
				callback()
				return
			end

			local jsonEncode = HttpService:JSONEncode({
				server = ContentProvider.BaseUrl
			})

			json = HttpService:JSONDecode(json)

			getUserByUsername(p2, json.cvalue)():andThen(function(p3)
				if p3 and p3.id then
					if getFFlagKeystoreAutoLoginAvailable() then
						return module64(jsonEncode):andThen(function()
							return p3
						end)
					end

					return default:deleteAllCredentialsFromiOSKeychain(
						default.CredentialsTypes.iosKeychainPassword,
						jsonEncode,
						keystoreConstants.KeystoreTimeout
					):andThen(function()
						return p3
					end)
				end

				return callback2("Invalid usernameInfo")
			end):andThen(function(p3)
				keystoreAnalyticsEvents.sendPageLoadEvent(
					keystoreEventConstants.origin.saveCredentials,
					(tostring(p3.id))
				)

				TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
					customFields = { result = "attempt" }
				}, 1)

				local jsonEncode2 = HttpService:JSONEncode({
					server = tostring(ContentProvider.BaseUrl),
					username = tostring(json.cvalue),
					userId = tostring(p3.id),
					password = tostring(json.password)
				})

				if getFFlagKeystoreAutoLoginAvailable() then
					return (default:isAvailable(
						default.CredentialsTypes.keystore,
						keystoreConstants.KeystoreTimeout
					):andThen(function(p4)
						if p4 and p4.keystore and p4.keystore.isAvailable then
							return default:registerCredentials(
								default.CredentialsTypes.keystore,
								jsonEncode2,
								keystoreConstants.KeystoreTimeout
							)
						end

						return Promise.resolve(nil)
					end))
				end

				return default:registerCredentials(
					default.CredentialsTypes.iosKeychainPassword,
					jsonEncode2,
					keystoreConstants.KeystoreTimeout
				)
			end):andThen(function(p3)
				callback()
			end):catch(function(p3)
				TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
					customFields = { result = "error" }
				}, 1)

				callback2(p3)
			end)
		end)
	end

	function self.handleLoginResult(p2, p3, p4)
		self.props.setBackNavigationDisabled(false)

		local launchApp = self.props.launchApp

		local networking = self.props.networking
		local appPolicy = self.props.appPolicy
		local analytics = self.props.analytics
		local omniRecommendationsRequest = self.props.omniRecommendationsRequest

		if self.passwordRef.current then
			self.passwordRef.current.Text = ""
		end

		local clearApp = self.props.clearApp
		local handleLoginCompletionWithAccountSwitching = self.props.handleLoginCompletionWithAccountSwitching

		self.performKeystoreOperations(networking, p3):finally(function()
			if module13.hasTwoStepData(p2) then
				if fFlagEnableTimeToLoginMetrics then
					default2.markTwoStepVerification()
				end

				module40(module41.FailureTwoStepVerification, 1)

				spawn(function()
					self.renderTwoStepChallenge(p2, p3, p4)
				end)
			else
				if p3 then
					if not (fFlagDisableMemStorageServicePasswordEvent or self.shouldUseIosAuthServicePasswordSave()) then
						MemStorageService:Fire(module36.AuthenticatedCredentials, p3)
					end

					if module60() and self.state.isCredentialsProtocolRegisterPasswordAvailable then
						self.credentialsProtocolRegisterPassword(p3):await()
					end
				end

				module40(module41.Success, 1)

				if module66 then
					handleLoginCompletionWithAccountSwitching(
						networking,
						omniRecommendationsRequest,
						analytics,
						appPolicy,
						p2.accountBlob,
						clearApp,
						launchApp
					)
				else
					launchApp(networking, omniRecommendationsRequest, analytics, appPolicy)
					module75.ClearThemeOverride()
				end
			end

			if module56() then
				self.props.closeCentralOverlay()
			end
		end)
	end

	function self.shouldUseIosAuthServicePasswordSave()
		return fFlagLuaAppSkipDuplicateIosPasswordSavePrompt
			and shouldSkipLegacyPasswordSaveEvent(module60() and self.state.isCredentialsProtocolRegisterPasswordAvailable == true)
	end

	function self.credentialsProtocolRegisterPassword(json)
		local jsonDecode = HttpService:JSONDecode(json)

		if jsonDecode.cvalue == nil or jsonDecode.password == nil then
			return
		end

		local jsonEncode = HttpService:JSONEncode({
			username = jsonDecode.cvalue,
			password = jsonDecode.password
		})
		return default:registerCredentials(
			default.CredentialsTypes.password,
			jsonEncode,
			constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
		):andThen(
			function(json2)
				if json2 then
					local jsonDecode2 = HttpService:JSONDecode(json2)

					if jsonDecode2.errorCode == nil then
						if self.passwordManagerUsageStore then
							self.passwordManagerUsageStore.setSavedPasswordAfterLogin(true)
						end

						self.props.authAnalytics.reportAuthButtonClick(
							module42.Context.CMPasswordLogin,
							module42.Button.SavePassword
						)

						logger:info("Successfully registered password.")
						iosAuthServiceHealthCounters.reportPasswordSaveSuccess({
							credentialType = "password",
							iosAuthServiceEnabled = isIosAuthServiceEnabled()
						})
					else
						logger:warning("Error registering password: " .. tostring(jsonDecode2.errorMsg))
						iosAuthServiceHealthCounters.reportPasswordSaveFailure({
							credentialType = "password",
							errorCode = tostring(jsonDecode2.errorCode),
							iosAuthServiceEnabled = isIosAuthServiceEnabled()
						})
					end
				end
			end,
			function(p2)
				logger:warning("Error registering password: " .. tostring(p2))
				iosAuthServiceHealthCounters.reportPasswordSaveFailure({
					credentialType = "password",
					errorCode = "transportError",
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})
			end
		)
	end

	function self.logoutAllLoggedInUsersCallback()
		local networking = self.props.networking
		local accountBlob = module63.getAccountBlob()
		local v12 = Models.fromLocalStorage().userId ~= -1

		self:setState({
			errorKey = false,
			loginButtonDisabled = true,
			isLoginInProgress = false
		})

		module53(networking, accountBlob):await()

		local v13 = false

		if self.pendingLoginRetryCredentials then
			local pendingLoginRetryCredentials = self.pendingLoginRetryCredentials
			self.pendingLoginRetryCredentials = nil

			if pendingLoginRetryCredentials.isPasswordLogin then
				local success, result = pcall(function()
					return self.props.login(
						networking,
						pendingLoginRetryCredentials.cvalue,
						pendingLoginRetryCredentials.password
					):expect()
				end)

				if success and result and not module13.hasTwoStepData(result) then
					if module66 then
						self.props.handleLoginCompletionWithAccountSwitching(
							networking,
							self.props.omniRecommendationsRequest,
							self.props.analytics,
							self.props.appPolicy,
							result.accountBlob,
							self.props.clearApp,
							self.props.launchApp
						)
					else
						self.props.launchApp(
							networking,
							self.props.omniRecommendationsRequest,
							self.props.analytics,
							self.props.appPolicy
						)
					end

					return
				end
			else
				v13 = type(pendingLoginRetryCredentials.cvalue) == "table" or false
			end
		end

		if v12 == true then
			self.props.resetAppState()
			AppStorageService:SetItem(localStorageKey.CredentialValue, "")
			AppStorageService:flush()

			local v14 = if v13 then accountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV1AfterLogoutAll else accountSwitcherConstants.AccountSwitcherPendingLoginAfterLogoutAll
			module63.setAccountSwitchStatus(v14)
			module63.flush()
			self.props.logoutWithoutShowConfirmation(networking, GuiService)
		end

		self:setState({ loginButtonDisabled = false })

		self.props.closeCentralOverlay()
	end

	function self.handleLoginError(state, value, p2)
		local v12 = v7
		v7 = false
		local v13

		if v12 then
			v13 = type(value) ~= "string" and "" or value
		else
			v13 = not (self.cvalueRef and self.cvalueRef.current) and ""
				or self.cvalueRef.current.Text
				or ""
		end

		self.props.setBackNavigationDisabled(false)
		local forceLoginByUsername = self.state.forceLoginByUsername
		local errorHandlingInfo = self.errorHandlingInfoList[state.errorCode]

		forceLoginByUsername = errorHandlingInfo and errorHandlingInfo.forceLoginByUsername
			or forceLoginByUsername

		local v15 = module56()

		if v15 then
			if state.errorCode == module35.MultipleUsersPerCredential then
				v15 = not self.props.appPolicy.getAccountDisambiguationDisabled()
			else
				v15 = false
			end
		end

		local v16 = self.props.appPolicy.getLinkedAuthEndpointsEnabled()
			and (state.errorCode == module35.AccountLinkingRequired or state.errorCode == module35.AccountLinkingFailed)

		local v17 = module50() and state.errorCode == module35.SecurityQuestions
		local v18 = (v15 or v17 or state.errorCode == module35.Captcha) and true or false

		module40(module41.Failure, 1)

		if state.errorCode == module35.Captcha then
			module40(module41.FailureCaptcha, 1)
		elseif state.errorCode == module35.IncorrectCValueOrPassword then
			module40(module41.FailureCredentials, 1)
		elseif state.errorCode == module35.AccountLocked then
			module40(module41.FailurePasswordReset, 1)
		elseif state.errorCode == module35.CTypeNotSupported then
			module40(module41.FailureBadRequest, 1)
		elseif state.errorCode == module35.CValueAndPasswordRequired then
			module40(module41.FailureBadRequest, 1)
		elseif v17 then
			module40(module41.FailureSecurityQuestions, 1)
		elseif state.errorCode == module35.MultipleUsersPerCredential then
			module40(module41.FailureMultipleUsersPerCredential, 1)
		elseif
			state.HttpError == Enum.HttpError.OK
			and state.StatusCode == statusCodes.TOO_MANY_REQUESTS
		then
			module40(module41.FailureThrottled, 1)
		elseif state.HttpError == Enum.HttpError.OK and state.StatusCode == statusCodes.REQUEST_TIMEOUT then
			module40(module41.FailureTimeout, 1)
		elseif state.HttpError == Enum.HttpError.OK and state.StatusCode == statusCodes.BAD_REQUEST then
			module40(module41.FailureBadRequest, 1)
		elseif state.HttpError == Enum.HttpError.OK and state.StatusCode == statusCodes.NOT_FOUND then
			module40(module41.FailureNotFound, 1)
		elseif
			state.HttpError == Enum.HttpError.OK
			and state.StatusCode == statusCodes.INTERNAL_SERVER_ERROR
		then
			module40(module41.FailureInternalServerError, 1)
		else
			module40(module41.FailureUnknownError, 1)
		end

		local v19 = fFlagUseGenericAccountSwitchSignOutCopy and not v12

		if module66 == true and state.errorCode == module35.EmptyAccountSwitchBlobRequired then
			self:setState({ errorKey = false })

			self.pendingLoginRetryCredentials = {
				cvalue = value,
				password = p2,
				isPasswordLogin = v12
			}

			module63.setAccountSwitchTargetUsername(v13)

			self.props.openAccountSwitchingErrorOverlay(
				"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
				v19 and "Authentication.AccountSwitch.Description.ContinueSignOutOthersGeneric" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers",
				"Authentication.AccountSwitch.Action.Continue",
				"Authentication.CrossDevice.Action.CancelLogin",
				self.logoutAllLoggedInUsersCallback,
				self.cancelAccountSwitchLogin,
				module43.Auth.AccountSwitcherLoginEmptyBlobRequiredError,
				value or nil
			)
		end

		if module66 == true and state.errorCode == module35.ParentEmptyAccountSwitchBlobRequired then
			self:setState({ errorKey = false })

			self.pendingLoginRetryCredentials = {
				cvalue = value,
				password = p2,
				isPasswordLogin = v12
			}

			module63.setAccountSwitchTargetUsername(v13)

			self.props.openAccountSwitchingErrorOverlay(
				"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
				v19 and "Authentication.AccountSwitch.Description.ContinueSignOutOthersGeneric" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers",
				"Authentication.AccountSwitch.Action.Continue",
				"Authentication.CrossDevice.Action.CancelLogin",
				self.logoutAllLoggedInUsersCallback,
				self.cancelAccountSwitchLogin,
				module43.Auth.AccountSwitcherParentLoginEmptyBlobRequiredError,
				value or nil
			)
		end

		if state.errorCode == module35.AccountLocked then
			self.props.openPasswordResetPrompt()
		end

		if
			state.errorCode == module35.AccountNotVerified
			and isStringEmail(value)
			and self.canVerifyCredentials(module38.Email, value, p2)
		then
			self.props.openEmailVerificationPrompt(value, p2, self.closeVerificationEmailModal)
		end

		if module71() and state.errorCode == module35.GlobalAppAccessDeniedVNG and self.isMounted then
			self.props.openNewAppAvailableModal(function()
				local v20 = module72()
				self.props.linking:openURL(v20)
			end)
		end

		if
			module50()
			and state.errorCode == module35.SecurityQuestions
			and state.securityQuestionsData
			and state.securityQuestionsCallback
		then
			task.spawn(function()
				if self.isMounted then
					self.renderSecurityQuestions(
						value,
						p2,
						state.securityQuestionsCallback,
						state.securityQuestionsData
					)
				end
			end)
		end

		if v15 then
			if state.usersData then
				self.handleMultipleUsersPerCredentialError(state.usersData)
			end
		elseif state.errorCode == module35.MultipleUsersPerCredential then
			state.errorKey = "Authentication.Login.Response.MoreThanOneUsername"
		end

		if state.errorCode == module35.PlatformNotSupported then
			state.errorKey = "Authentication.Login.Error.PlatformAccountConnectionFailure"
		end

		if v16 then
			if state.errorCode == module35.AccountLinkingRequired then
				self.props.showAccountLinkingAlert(
					accountLinkingAlertType.IncompatibleAccounts,
					state.userFacingMessage
				)
			elseif state.errorCode == module35.AccountLinkingFailed then
				self.props.showAccountLinkingAlert(accountLinkingAlertType.RetryLogInConnectionFailure)
			end
		end

		spawn(function()
			if self.isMounted then
				self:setState({
					errorKey = state.errorKey,
					errorCode = state.errorCode,
					forceLoginByUsername = forceLoginByUsername
				})
			end
		end)

		self.updateIsLoginInProgress(v18)
	end

	function self.onLoginButtonActivated()
		if self.state.loginButtonDisabled or self.isLoginSubmitBlocked() then
			return
		end

		self.updateIsLoginInProgress(true)

		self.props.authAnalytics.reportLogInButtonClicked(module42.Context.LoginScreen)
		self.handleLoginWithFormData()
	end

	function self.onForgetButtonActivated()
		if self.state.isLoginInProgress then
			return
		end

		self.unfocusTextBoxes()
		self.props.authAnalytics.reportAuthButtonClick(
			module42.Context.LoginForm,
			module42.Button.ForgotPassword
		)

		self.props.authAnalytics.reportForgotPasswordButtonClicked(module42.Context.LoginScreen)

		if getFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
			self.props.navigateToPage({
				name = module8.AccountRecovery,
				extraProps = {
					identifier = self.cvalueRef and self.cvalueRef.current and self.cvalueRef.current.Text or self.cvalueText and self.cvalueText:getValue() or "",
					recoverPassword = true
				}
			})
		elseif self.props.appPolicy.shouldUseExternalBrowserForDisclaimerLinks() then
			self.props.linking:openURL(ContentProvider.BaseUrl .. "login/forgot-password-or-username")
		else
			self.props.navigateToPage({
				name = module8.GenericWebPage,
				detail = ContentProvider.BaseUrl .. "login/forgot-password-or-username",
				extraProps = {
					title = "",
					transitionAnimation = module34.SlideInFromRight
				}
			})
		end
	end

	function self.onCrossDeviceLoginActivated(p2)
		if self.state.isLoginInProgress then
			return
		end

		self.unfocusTextBoxes()

		if defineFastFlag6 then
			if not p2 then
				self.props.authAnalytics.reportAuthButtonClick(
					module42.Context.LoginForm,
					module42.Button.QuickLogin
				)

				self.props.authAnalytics.reportButtonClicked(
					module42.Context.Login,
					module42.Button.LoginOtherDevice
				)
			end
		else
			self.props.authAnalytics.reportAuthButtonClick(
				module42.Context.LoginForm,
				module42.Button.QuickLogin
			)

			self.props.authAnalytics.reportButtonClicked(
				module42.Context.Login,
				module42.Button.LoginOtherDevice
			)
		end

		local fn = nil

		fn = defineFastFlag6
			and fFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose
			and p2
			and function(p3)
				if not p3 then
					self.showSavedCredentialsPrompt()
				end
			end
			or fn

		if not self.props.appPolicy.getShowVNGLoginWithExistingAccountQuickLoginButton() then
			self.props.openCrossDeviceLoginPrompt(self.handleLoginWithCode, fn)

			return
		end

		if module61() then
			RbxAnalyticsService:ReportCounter("CrossAppLoginAttempt", 1)
		end

		self.props.openCrossAppLoginPrompt(self.handleLoginWithCode)
	end

	function self.topButtonActivatedTracking()
		if module66 == true and self.isAlreadyAuthenticated == true then
			LUAUFORGE_MODULE_GLOBALS_hOv_resetDefaultTheme()
		end

		self.props.authAnalytics.reportDismissCornerXButtonClicked(module42.Context.LoginScreen)
	end

	function self.onEmailOtpLoginAbandoned()
		self.cancelTimeToLoginAttempt()
		self.state.isLoginByOtp = false
	end

	function self.onEmailOtpLoginCompleted(otpSessionToken, otpCode)
		self.state.otpSessionToken = otpSessionToken
		self.state.otpCode = otpCode
		return self.handleLoginWithOtp(nil, nil)
	end

	function self.onEmailOtpLoginActivated()
		if self.state.isLoginInProgress then
			return
		end

		self.unfocusTextBoxes()
		local v12 = {
			origin = "login",
			codeLength = 6,
			enterEmailTitleKey = "Authentication.Login.Label.GetOneTimeCode",
			enterEmailDescriptionKey = "Authentication.Login.Description.GetOneTimeCodeHelp",
			enterCodeTitleKey = "Authentication.Login.Label.EnterOneTimeCode",
			enterCodeDescriptionKey = "Authentication.Login.Description.EnterOneTimeCodeHelpV2",
			onSubmitCode = self.onEmailOtpLoginCompleted,
			onModalAbandoned = self.onEmailOtpLoginAbandoned,
			screenSize = self.props.screenSize
		}

		self.props.openEmailOtp(v12)
		self.state.isLoginByOtp = true
		self.props.authAnalytics.reportAuthButtonClick(module42.Context.LoginForm, module42.Button.EmailOtp)

		self.props.authAnalytics.reportButtonClicked(
			module42.Context.Login,
			module42.Button.OneTimePasscode
		)
	end

	function self.closeVerificationEmailModal(p2)
		if self.isMounted then
			self.updateCValueText(p2)

			if p2 ~= "" and self.passwordRef.current then
				self.passwordRef.current:CaptureFocus()
			end

			self:setState({
				errorCode = -1,
				errorKey = "",
				forceLoginByUsername = false
			})
		end
	end

	self.events = {}
	self.props.authAnalytics.reportScreenLoaded(module42.Context.LoginScreen)
end

function extended:didMount()
	self.isMounted = true

	self.props.authAnalytics.reportAuthPageload(module42.Context.LoginForm)

	local url = preAuthDeepLinkUrlStore.getUrl()
	self.props.authAnalytics.reportAuthPageload(module42.Context.LoginScreen, url)

	if module66 == true and self.isAlreadyAuthenticated == true then
		MemStorageService:Fire(module36.ThemeUpdate, "dark")
	end

	module75.SetDarkThemeOverride()

	local v7 = defineFastFlag6 and self.props.appPolicy.getUseCrossDeviceLoginByDefault()

	if v7 then
		self.onCrossDeviceLoginActivated(true)
	end

	if self.props.appPolicy.getLoginUsernameOnly() then
		self:setState({ forceLoginByUsername = true })
	end

	if module74 or getFFlagKeystoreAutoLoginAvailable() then
		if defineFastFlag5 then
			self:setState({ loginButtonDisabled = true })
		else
			self:setState({ loginButtonDisabled = false })
		end
	end

	local function isWithinBounds(position, current): boolean
		if self.props.uiModeInfo.uiMode == uiMode.VR then
			error("Input position is not supported in VR")
		end

		local absolutePosition = current.AbsolutePosition
		local absoluteSize = current.AbsoluteSize

		return position.X > absolutePosition.X
			and position.X < absolutePosition.X + absoluteSize.X
			and position.Y > absolutePosition.Y
			and position.Y < absolutePosition.Y + absoluteSize.Y
	end

	local function getNextSelectedObject(p2)
		if
			UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		then
			return self.focusRef and self.focusRef.current and self.focusRef.current.NextSelectionUp
		end

		return self.focusRef and self.focusRef.current and self.focusRef.current.NextSelectionDown
	end

	local function getNewSelectedObject()
		local current = self.focusRef and self.focusRef.current

		local nextSelectedObject = getNextSelectedObject(current)

		if nextSelectedObject == self.loginButtonRef.current and self.state.loginButtonDisabled then
			nextSelectedObject = getNextSelectedObject(nextSelectedObject)
		end

		if self.isMounted then
			self:setState({
				forgotLinkFocused = nextSelectedObject == self.forgotLinkRef.current
			})
		end

		return nextSelectedObject
	end

	table.insert(self.events, UserInputService.InputBegan:connect(function(p2, p3)
		if fFlagSignalsNavP3eAuth then
			if not getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false) then
				return
			end
		elseif self.props.currentPageName ~= module8.Login then
			return
		end

		if p2.UserInputType == Enum.UserInputType.Keyboard then
			if p2.KeyCode == Enum.KeyCode.Return then
				if self.state.forgotLinkFocused then
					self.onForgetButtonActivated()
				else
					self.onLoginButtonActivated()
				end
			elseif p2.KeyCode == Enum.KeyCode.Tab then
				local current = self.focusRef and self.focusRef.current

				if not current then
					return
				end

				local newSelectedObject = getNewSelectedObject()

				if not newSelectedObject then
					return
				end

				if current:IsA("TextBox") and current.ManualFocusRelease then
					current:ReleaseFocus()
				end

				self.focusRef.current = newSelectedObject

				if newSelectedObject:IsA("TextBox") then
					newSelectedObject:CaptureFocus()
				end
			end
		end
	end))

	table.insert(self.events, UserInputService.InputEnded:connect(function(p2, p3)
		if fFlagSignalsNavP3eAuth then
			if not getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false) then
				return
			end
		elseif self.props.currentPageName ~= module8.Login then
			return
		end

		if self.props.uiModeInfo.uiMode == uiMode.VR then
			return
		end

		if
			p2.UserInputType == Enum.UserInputType.MouseButton1
			or p2.UserInputType == Enum.UserInputType.Touch
		then
			local position = p2.Position

			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if not (self.cvalueRef.current and self.passwordRef.current and focusedTextBox) then
				return
			end

			local withinBounds = isWithinBounds(position, self.cvalueRef.current)
			local withinBounds2 = isWithinBounds(position, self.passwordRef.current)

			if focusedTextBox == self.cvalueRef.current and withinBounds2 then
				self.cvalueRef.current:ReleaseFocus()
				self.passwordRef.current:CaptureFocus()
			elseif focusedTextBox == self.passwordRef.current and withinBounds then
				self.passwordRef.current:ReleaseFocus()
				self.cvalueRef.current:CaptureFocus()
			elseif
				not withinBounds
				and not withinBounds2
				and (focusedTextBox == self.cvalueRef.current or focusedTextBox == self.passwordRef.current)
			then
				focusedTextBox:ReleaseFocus()
			end
		end
	end))

	table.insert(self.events, UserInputService.TextBoxFocused:connect(function(current)
		if fFlagSignalsNavP3eAuth then
			if not getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false) then
				return
			end
		elseif self.props.currentPageName ~= module8.Login then
			return
		end

		if self.state.isLoginInProgress then
			current:ReleaseFocus()
		else
			self.focusRef.current = current
		end
	end))

	table.insert(self.events, UserInputService.TextBoxFocusReleased:connect(function(p2)
		if fFlagSignalsNavP3eAuth then
			if not getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false) then
				return
			end
		elseif self.props.currentPageName ~= module8.Login then
			return
		end

		self.focusRef.current = nil
	end))

	table.insert(self.events, MemStorageService:bind(module36.AutoFillCredentials, function(json)
		if fFlagSignalsNavP3eAuth then
			if not getLegacyNavigationStore(false).getIsCurrentPageSignal(module8.Login)(false) then
				return
			end
		elseif self.props.currentPageName ~= module8.Login then
			return
		end

		if self.state.isLoginInProgress then
			return
		end

		local jsonDecode = HttpService:JSONDecode(json)

		if jsonDecode then
			self.updateCValueText(jsonDecode.cvalue)
			self.updatePasswordText(jsonDecode.password)
		end
	end))

	if getFFlagLuaAppEnableDesktopDualLoginABTest() then
		module27(self.props.networking, "PlayerApp.Login", { "isDesktopDualLoginEnabled" }):andThen(
			function(p2)
				local responseBody = p2 and p2.responseBody
				local isDesktopDualLoginEnabled = responseBody
					and self.isMounted
					and responseBody.isDesktopDualLoginEnabled

				if isDesktopDualLoginEnabled then
					self:setState({
						isDesktopDualLoginEnabled = isDesktopDualLoginEnabled
					})
				end
			end,
			function() end
		)
	end

	if v7 then
		logger:info("Skipping credentials prompt because cross-device QR login is shown by default.")
	else
		self.showSavedCredentialsPrompt()
	end

	if LocalizationService.RobloxLocaleId:match("^en") then
		module27(self.props.networking, "PlayerApp.Login", { "CrossDeviceButtonText" }):andThen(function(p2)
			local responseBody = p2 and p2.responseBody
			local crossDeviceButtonText = responseBody
				and self.isMounted
				and responseBody.CrossDeviceButtonText

			if crossDeviceButtonText then
				self:setState({ quickLoginButtonTextOverride = crossDeviceButtonText })
			end
		end, function() end)
	end

	self.props.loggingProtocol:logEventOnce("login_view_did_mount")
	self.props.loggingProtocol:logRobloxTelemetryCounter(
		telemetryConfigs.LoginPageMountTelemetryConfig,
		1,
		{ version = 1 }
	)
end

function extended:willUnmount()
	if module66 == true and self.isAlreadyAuthenticated == true then
		LUAUFORGE_MODULE_GLOBALS_hOv_resetDefaultTheme()
	end

	self.unfocusTextBoxes()

	for i, event in ipairs(self.events) do
		event:Disconnect()
	end

	self.events = {}
	self.isMounted = false
end

function extended.didUpdate(data, p2, p3)
	if data.state.errorCode == -1 then
		return
	end

	local isLoginInProgress = data.state.isLoginInProgress

	if p3.isLoginInProgress and not isLoginInProgress then
		local errorHandlingInfo = data.errorHandlingInfoList[data.state.errorCode]

		if not errorHandlingInfo then
			return
		end

		if errorHandlingInfo.textBoxesToClear then
			for k, v7 in pairs(errorHandlingInfo.textBoxesToClear) do
				if v7 == 1 then
					data.updateCValueText("")
				elseif v7 == 2 then
					data.updatePasswordText("")
				end
			end
		end

		if errorHandlingInfo.newFocusedTextBox == 1 and data.cvalueRef.current then
			data.cvalueRef.current:CaptureFocus()
		elseif errorHandlingInfo.newFocusedTextBox == 2 and data.passwordRef.current then
			data.passwordRef.current:CaptureFocus()
		end
	end
end

function extended.render(data)
	local errorKey = if data.state.errorKey ~= "" then data.state.errorKey or nil else nil
	local localizedErrorMessage = if data.state.errorKey == false then data.state.localizedErrorMessage or nil else nil
	local v7 = not data.props.appPolicy.getWebViewSupport() and data.props.uiModeInfo.uiMode ~= uiMode.VR

	local v8 = data.props.uiModeInfo.uiMode == uiMode.TenFoot or data.props.uiModeInfo.uiMode == uiMode.VR
	local isDesktopDualLoginEnabled = getFFlagLuaAppEnableDesktopDualLoginABTest()
		and data.state.isDesktopDualLoginEnabled
	local v9 = v8 or data.props.appPolicy.getEnableDualLogin() and isDesktopDualLoginEnabled

	local disableEmailOTPLogin = data.props.appPolicy.getDisableEmailOTPLogin()

	local v10 = module58() and data.props.isLoginWithOtpEnabled and not disableEmailOTPLogin

	local useVNGUserAgreementPopup = data.props.appPolicy.getUseVNGUserAgreementPopup()

	local v11 = module67 and data.props.appPolicy.getUseKoreaKISAUserAgreementPopup()

	local disableLoginForgotButton = data.props.appPolicy.getDisableLoginForgotButton()

	return withStyle(function(p2)
		local v12 = module45.CrossDeviceLoginRolloutEnabledForDevice() and not v9

		if data.props.appPolicy.getExcludeCrossDeviceSignIn() then
			v12 = false
		end

		local showVNGLoginWithExistingAccountQuickLoginButton = data.props.appPolicy.getShowVNGLoginWithExistingAccountQuickLoginButton()

		if data.props.appPolicy.getDisableRegularLogin() == false then
			v7 = false
		end

		return module39({
			localizedError = errorKey,
			logInText = "Authentication.Login.Action.SignIn",
			forgotText = "Authentication.Login.Action.ForgotPasswordOrUsernameQuestionCapitalized",
			cvaluePlaceholder = data.state.forceLoginByUsername and "Authentication.Login.Label.Username" or "Authentication.Login.Label.UsernameEmailPhone",
			passwordPlaceholder = "CommonUI.Messages.Label.Password",
			twoStepHeader = "Authentication.TwoStepVerification.Label.TwoStepVerification",
			crossDeviceLoginHeader = "Authentication.CrossDevice.Heading.QuickLogin",
			loginWithExistingAccountButtonText = "Authentication.CrossDevice.Heading.QuickLogin",
			orText = "CommonUI.Messages.Label.OR"
		})(function(props)
			local v13 = data.state.quickLoginButtonTextOverride ~= ""
				and data.state.quickLoginButtonTextOverride
				or props.crossDeviceLoginHeader

			if showVNGLoginWithExistingAccountQuickLoginButton then
				v13 = props.loginWithExistingAccountButtonText
			end

			local v14 = if v8 then module29 else module28
			local v15 = v8 and data.props.uiModeInfo.uiMode ~= uiMode.VR

			local createElement = module2.createElement
			local v16 = {
				ContentAlign = alignment.Top,
				topButtonActivatedTracking = data.topButtonActivatedTracking,
				topButtonEnabled = not data.state.isLoginInProgress,
				statusBarHeight = data.props.statusBarHeight,
				globalGuiInset = data.props.globalGuiInset,
				screenSize = data.props.screenSize,
				isDualLayout = v9,
				navigateBack = 0,
				buttonRef = 0
			}

			local v17 = if v8 then data.props.navigateBack else nil
			v16.navigateBack = v17
			v16.buttonRef = data.props.containerRef
			local v18 = {
				UIListLayout = v9 and module2.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}) or module2.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 15)
				}),
				Form = 0,
				Divider = 0,
				LoginCode = 0,
				Forgot = 0,
				DisclaimerLinks = 0,
				Padding = 0
			}
			local v19

			if v9 then
				local createElement2 = module2.createElement
				local v21 = {
					Size = UDim2.new(0.5, 0, 1, 0),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				}

				local createElement3 = module2.createElement
				local v24 = {}
				v24.Size = UDim2.new(0, 0, 1, 0)
				v24.crossDeviceLoginEnabled = v12
				v24.quickLoginButtonText = v13
				v24.loginWithExistingAccountVariantEnabled = showVNGLoginWithExistingAccountQuickLoginButton
				v24.handleLoginWithFormDataCallback = data.handleLoginWithFormData
				v24.updateIsLoginInProgress = data.updateIsLoginInProgress
				v24.cvalueText = data.cvalueText
				v24.passwordText = data.passwordText
				v24.onTextBoxesChanged = data.onTextBoxesChanged
				v24.buttonRef = data.props.defaultRef
				v24.cvalueRef = data.cvalueRef
				v24.passwordRef = data.passwordRef
				v24.loginButtonRef = data.loginButtonRef
				v24.forgotLinkRef = data.forgotLinkRef
				v24.crossDeviceButtonRef = data.crossDeviceButtonRef
				v24.emailOtpRef = data.emailOtpRef
				v24.localizedError = props.localizedError
				v24.localizedErrorMessage = localizedErrorMessage
				v24.forceLoginByUsername = data.state.forceLoginByUsername or v8
				function v24.onCrossDeviceLoginActivated()
					data.onCrossDeviceLoginActivated()
				end
				v24.onEmailOtpActivated = data.onEmailOtpLoginActivated
				v24.loginButtonDisabled = data.state.loginButtonDisabled
				v24.isLoginInProgress = data.state.isLoginInProgress
				v24.authAnalytics = data.props.authAnalytics
				v24.disableRegularLogin = v7
				v24.showLinkAccountText = v15
				v24.showForgotButton = not (v7 or v8)
				v24.onForgetButtonActivated = data.onForgetButtonActivated
				v24.maxSizeX = 1e999
				local v25 = not v8

				if v25 then
					v25 = not (useVNGUserAgreementPopup or v11)
				end

				v24.showDisclaimerLinks = v25

				v24.showDisclaimerButtons = v8 and not useVNGUserAgreementPopup
				v24.showCredentialHeader = not v8
				v24.isDualLayout = true
				v24.isTenFootUiMode = v8
				v24.emailOtpEnabled = v10
				v24.LayoutOrder = 2
				v19 = createElement2("Frame", v21, {
					FormContent = createElement3(module31, v24)
				})
			else
				local createElement2 = module2.createElement
				local v21 = {}
				v21.crossDeviceLoginEnabled = v12
				v21.quickLoginButtonText = v13
				v21.loginWithExistingAccountVariantEnabled = showVNGLoginWithExistingAccountQuickLoginButton
				v21.handleLoginWithFormDataCallback = data.handleLoginWithFormData
				v21.updateIsLoginInProgress = data.updateIsLoginInProgress
				v21.cvalueText = data.cvalueText
				v21.passwordText = data.passwordText
				v21.onTextBoxesChanged = data.onTextBoxesChanged
				v21.buttonRef = data.props.defaultRef
				v21.cvalueRef = data.cvalueRef
				v21.passwordRef = data.passwordRef
				v21.loginButtonRef = data.loginButtonRef
				v21.forgotLinkRef = data.forgotLinkRef
				v21.crossDeviceButtonRef = data.crossDeviceButtonRef
				v21.emailOtpRef = data.emailOtpRef
				v21.localizedError = props.localizedError
				v21.localizedErrorMessage = localizedErrorMessage
				v21.forceLoginByUsername = data.state.forceLoginByUsername or v8
				function v21.onCrossDeviceLoginActivated()
					data.onCrossDeviceLoginActivated()
				end
				v21.onEmailOtpActivated = data.onEmailOtpLoginActivated
				v21.loginButtonDisabled = data.state.loginButtonDisabled
				v21.isLoginInProgress = data.state.isLoginInProgress
				v21.authAnalytics = data.props.authAnalytics
				v21.disableRegularLogin = v7
				v21.showLinkAccountText = data.props.appPolicy.getUseSingleSignOn()
				v21.showForgotButton = not v7 and v9 and not v8
				v21.onForgetButtonActivated = data.onForgetButtonActivated
				v21.maxSizeX = v9 and 1e999 or 360
				local v22 = v9 and not v8

				if v22 then
					v22 = not (useVNGUserAgreementPopup or v11)
				end

				v21.showDisclaimerLinks = v22

				v21.showDisclaimerButtons = v9 and v8 and not useVNGUserAgreementPopup
				v21.showCredentialHeader = v9 and not v8
				v21.isDualLayout = v9
				v21.isTenFootUiMode = v8
				v21.emailOtpEnabled = v10
				v19 = createElement2(module31, v21)
			end

			v18.Form = v19

			local v20 = if v9 then module2.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.new(0, p2.Tokens.Size.Size_1000, 1, 0),
					BackgroundTransparency = 1
				},
				{
					module2.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, p2.Tokens.Size.Size_300)
					}),
					module2.createElement("Frame", {
						Size = UDim2.new(0, p2.Tokens.Size.Size_50, 0.5, 0),
						BackgroundTransparency = 0,
						BackgroundColor3 = p2.Tokens.Color.Extended.Gray.Gray_800.Color3,
						LayoutOrder = 1
					}),
					module2.createElement("TextLabel", {
						Text = props.orText,
						TextSize = p2.Tokens.Size.Size_400,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextTransparency = 0,
						TextColor3 = p2.Tokens.Color.Extended.Gray.Gray_800.Color3,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					}),
					module2.createElement("Frame", {
						Size = UDim2.new(0, p2.Tokens.Size.Size_50, 0.5, 0),
						BackgroundTransparency = 0,
						BackgroundColor3 = p2.Tokens.Color.Extended.Gray.Gray_800.Color3,
						LayoutOrder = 3
					})
				}
			) or nil else nil
			v18.Divider = v20

			v18.LoginCode = v9
				and module2.createElement(
					"Frame",
					{
						Size = UDim2.new(0.5, 0, 1, 0),
						LayoutOrder = 3,
						BackgroundTransparency = 1
					},
					{ module2.createElement(module32, {
							loginCallback = data.handleLoginWithCode,
							isOverlay = false,
							hideDeviceCode = not v8,
							showLockIcon = not v8,
							isDualLayout = true
						}) }
				)

			local v21 = if not (v7 or v9 or disableLoginForgotButton) then module2.createElement(linkButton, {
				text = props.forgotText,
				size = UDim2.new(0, 0, 0, 30),
				fontStyle = "Footer",
				onActivated = data.onForgetButtonActivated,
				colorStyleDefault = "TextDefault",
				colorStyleHover = "TextDefault"
			}) else nil
			v18.Forgot = v21

			local v22 = if not (v9 or useVNGUserAgreementPopup or v11) then module2.createElement(module20, {
				fillDirection = Enum.FillDirection.Vertical,
				LayoutOrder = 60
			}) else nil
			v18.DisclaimerLinks = v22

			local v23 = if not v9 then module2.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v5),
				LayoutOrder = 61
			}) or nil else nil
			v18.Padding = v23
			return createElement(v14, v16, v18)
		end)
	end)
end

local v7 = roactServices.connect({
	networking = module4,
	analytics = module6,
	authAnalytics = module5,
	loggingProtocol = appLogging,
	linking = appLinking
})(extended)

local v8 = useSheetNavigation.connect(function(data, p2)
	local v9

	if not fFlagSignalsNavP3eAuth then
		if fFlagUseNavigationSelectors then
			v9 = selectors.selectCurrentPageName(data)
		else
			local v10 = data.Navigation.history[#data.Navigation.history]
			v9 = v10[#v10].name
		end
	end

	if fFlagSignalsNavP3eAuth then
		v9 = nil
	end

	return {
		currentPageName = v9,
		screenSize = data.ScreenSize,
		statusBarHeight = data.TopBar.statusBarHeight,
		globalGuiInset = data.GlobalGuiInset
	}
end, function(callback)
	return {
		login = function(...)
			return callback(module9(...))
		end,
		loginByCode = function(...)
			return callback(module10(...))
		end,
		loginByPasskey = function(...)
			return callback(module11(...))
		end,
		loginByOtp = function(...)
			return callback(module12(...))
		end,
		launchApp = function(p2, p3, p4, p5)
			return callback(module14(p2, p3, p4, p5, module44.Login))
		end,
		clearApp = function()
			callback(module54())
			return Promise.resolve(true)
		end,
		handleLoginCompletionWithAccountSwitching = function(p2, p3, p4, p5, p6, callback2, callback3)
			if Models.fromLocalStorage().userId ~= -1 then
				callback2():andThen(function(p7)
					local v9 = if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus else module43.Auth.AccountSwitcherSwitchedStatus
					module63.setAccountSwitchStatus(v9)
					module63.setAccountBlob(p6)
					module63.flush()

					if module68 then
						GuiService:BroadcastNotification("", module70.DID_SWITCH_ACCOUNT)
					else
						GuiService:BroadcastNotification("", module70.DID_LOG_OUT)
					end

					if fFlagAccountSwitchRelaunchFallback then
						scheduleAccountSwitchRelaunchFallback(function()
							callback3(p2, p3, p4, p5)
						end)
					end
				end, function(p7)
					module63.setAccountSwitchStatus(not fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues and "switched" or accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus)

					module63.setAccountBlob(p6)
					module63.flush()
					callback3(p2, p3, p4, p5)
				end)
				return
			end

			module63.setAccountBlob(p6)
			module63.flush()
			callback3(p2, p3, p4, p5)
		end,
		setBackNavigationDisabled = function(p2)
			return module.setDisabled(p2)
		end,
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module16(p2))
		end,
		openPasswordResetPrompt = function()
			callback(module17())
		end,
		openEmailVerificationPrompt = function(p2, p3, onClose)
			callback(module18(module37.LoginEmailVerificationPrompt, {
				credentialValue = p2,
				password = p3,
				onClose = onClose
			}))
		end,
		openNewAppAvailableModal = function(onButtonActivated)
			if module71() then
				callback(module18(module37.NewAppAvailableModal, {
					onButtonActivated = onButtonActivated
				}))
			end
		end,
		openCrossDeviceLoginPrompt = function(p2, onDismiss)
			callback(module19.OpenLoginCodePrompt({
				loginCallback = p2,
				onDismiss = onDismiss,
				isOverlay = true
			}))
		end,
		openCrossAppLoginPrompt = function(p2)
			callback(module19.OpenLoginCodePrompt({
				loginCallback = p2,
				isOverlay = true,
				isCrossApp = true
			}))
		end,
		openAccountSelector = function(p2, p3)
			if p3 then
				callback(module21(p2, true, true))
			else
				callback(module21(p2, module59(), false))
			end
		end,
		openEmailOtp = function(p2)
			callback(module23(p2))
		end,
		closeCentralOverlay = function()
			return callback(module24())
		end,
		resetAppState = function()
			return callback(module54())
		end,
		renderChallenge = function(p2, p3)
			return callback(module51(p2, p3))
		end,
		startPasskeyAuthentication = function(p2)
			return callback(module15(p2))
		end,
		logoutAllLoggedInUsers = function(p2, p3)
			return callback(module53(p2, p3))
		end,
		logoutWithoutShowConfirmation = function(p2, p3)
			return callback(module22(p2, p3))
		end,
		openAccountSwitchingErrorOverlay = function(p2, p3, p4, p5, p6, p7, p8, p9)
			return callback(module65(p2, p3, p4, p5, p6, p7, p8, p9))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end,
		showAccountLinkingAlert = function(p2, p3)
			return callback(module18(module37.AccountLinkingAlert, {
				alertType = p2,
				userFacingMessage = p3
			}))
		end
	}
end)(v7)

local v9 = roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v8)

local v10 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.LoginLayer }, function(p2, p3)
	local v11 = p2[appBtidLayers.LoginLayer] or {}

	return {
		isLoginWithOtpEnabled = defineFastFlag8 or v11.IsLoginWithOtpEnabled,
		showFoundationDisambiguationSelector = v11.showFoundationDisambiguationSelector or false
	}
end)(v9)

local v11 = withNavigationProps(function(p2, p3)
	return p3
end)(v10)

local function LoginViewFn(p2)
	local v12 = useUiModeInfo()

	local v13, v14 = ReactFocusNavigation.useDefaultFocusBehavior()

	return module2.createElement(
		v11,
		Cryo.Dictionary.join({ uiModeInfo = v12, defaultRef = v13, containerRef = v14 }, p2)
	)
end

return LoginViewFn
