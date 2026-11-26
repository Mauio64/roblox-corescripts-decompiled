local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local ContentProvider = game:GetService("ContentProvider")

local module = require("@luauforge/bundled/ggO")
require("@luauforge/bundled/gjL")

local userIdentifierType = module.UserIdentifierType

local module2 = require("@luauforge/bundled/ggX")
local module3 = require("@luauforge/bundled/ggA")
local module4 = require("@luauforge/bundled/ggL")
local module5 = require("@luauforge/bundled/glr")
local module6 = require("@luauforge/bundled/gkz")

require("@luauforge/bundled/gls")

local useDispatch = require("@luauforge/bundled/ggY").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gjX").useRoactService
local useAppPolicy = require("@luauforge/bundled/gjU").useAppPolicy
local launchContext = require("@luauforge/bundled/glt").Enums.LaunchContext
local closeCentralOverlay = require("@luauforge/bundled/ggM").Thunks.CloseCentralOverlay
local setCentralOverlay = require("@luauforge/bundled/ggM").Actions.SetCentralOverlay
local notificationType = require("@luauforge/bundled/ggZ").NotificationType
local centralOverlayType = require("@luauforge/bundled/ggZ").CentralOverlayType
local appPage = require("@luauforge/bundled/ggZ").AppPage
local openAccountSwitchingErrorOverlay = require("@luauforge/bundled/gkd").OpenAccountSwitchingErrorOverlay
local renderChallenge = require("@luauforge/bundled/glu").Middleware.RenderChallenge
local challengeType = require("@luauforge/bundled/glu").Types.ChallengeType
local twoStepVerificationActionType = require("@luauforge/bundled/glu").Types.TwoStepVerificationActionType
local navigateDown = require("@luauforge/bundled/glv").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/gjO").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/glw").NavigationCommands else nil

local module7 = require("@luauforge/bundled/gjG")
local statusCodes = require("@luauforge/bundled/ggD").StatusCodes

local eventStreamConstants = require("@luauforge/bundled/gjG").EventStreamConstants
local module8 = require("@luauforge/bundled/gjV")
local appBtidLayers = require("@luauforge/bundled/gjW").AppBtidLayers

local module9 = require("@luauforge/bundled/gjY")
local roactNetworking = module9.RoactNetworking
local roactAnalytics = module9.RoactAnalytics
local appLinking = module9.AppLinking

local module10 = require("@luauforge/bundled/glx")
local constants = module10.Constants
local default = module10.CredentialsProtocol.default
local credentialsProtocolErrorCodes = module10.CredentialsProtocolErrorCodes

local module11 = require("@luauforge/bundled/gjO")
local getFFlagEnableLoginAccountSelector = module11.GetFFlagEnableLoginAccountSelector
local fFlagEnableLuaAccountSwitch = module11.FFlagEnableLuaAccountSwitch
local fFlagLuaEnableDidSwitchAccount = module11.FFlagLuaEnableDidSwitchAccount
local fFlagAccountSwitchRelaunchFallback = module11.FFlagAccountSwitchRelaunchFallback
local getFStringVNGDownloadNowUrl = module11.GetFStringVNGDownloadNowUrl

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = module11.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local fFlagAddReasonToEveryLogout = module11.FFlagAddReasonToEveryLogout
local fFlagEnablePasskeyLoginErrorLogging = module11.FFlagEnablePasskeyLoginErrorLogging
local fFlagDisableMemStorageServicePasswordEvent = module11.FFlagDisableMemStorageServicePasswordEvent
local fFlagEnableLoginV2Modalization = module11.FFlagEnableLoginV2Modalization
local fFlagEnableAccountIneligibleLoginModal = module11.FFlagEnableAccountIneligibleLoginModal
local fFlagLoginV2FullFlowDevOverride = module11.FFlagLoginV2FullFlowDevOverride
local fFlagUseGenericAccountSwitchSignOutCopy = module11.FFlagUseGenericAccountSwitchSignOutCopy
local fFlagEnableAccountSwitchSsoLogin = module11.FFlagEnableAccountSwitchSsoLogin
local fFlagFixLoginV2AccountSwitchOverlaySoftLock = module11.FFlagFixLoginV2AccountSwitchOverlaySoftLock
local module12 = require("@luauforge/bundled/gke")
local fFlagEnablePWManagerSignupCheck = module11.FFlagEnablePWManagerSignupCheck
local getFFlagKeystoreAutoLoginAvailable = module11.GetFFlagKeystoreAutoLoginAvailable

local fFlagEnable2SVRecovery = module11.FFlagEnable2SVRecovery

local module13 = require("@luauforge/bundled/gly")
local module14 = require("@luauforge/bundled/glz")
local module15 = require("@luauforge/bundled/glA")
local module16 = require("@luauforge/bundled/glB")
local module17 = require("@luauforge/bundled/glC")
local fFlagSkipAccountSwitchRelaunchForPioneerLogin = module11.FFlagSkipAccountSwitchRelaunchForPioneerLogin
local isPioneerLaunch = require("@luauforge/bundled/glD").isPioneerLaunch

local defineFastFlag = game:DefineFastFlag("LoginV2AwaitPasswordRegistration", false)

local defineFastFlag2 = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOn2SVLoginV2",
	false
)
local module18 = require("@luauforge/bundled/gjK")
local module19 = require("@luauforge/bundled/glE")
local module20 = require("@luauforge/bundled/ggG")
local module21 = require("@luauforge/bundled/ggI")
local module22 = require("@luauforge/bundled/ggQ")
local module23 = require("@luauforge/bundled/ggR")

local base64 = module4.Utils.Base64
local accountSwitcherConstants = module4.Common.AccountSwitcherConstants
local loginResult = module4.Models.LoginResult
local authClientError = module7.Events.authClientError
local authButtonClick = module7.Events.authButtonClick
local fFlagEnableTimeToLoginMetrics = module7.Flags.FFlagEnableTimeToLoginMetrics

local fFlagRestartTimeToLoginOnHumanInteractionRetry = module7.Flags.FFlagRestartTimeToLoginOnHumanInteractionRetry
local default2 = module7.RobloxTelemetry.TimeToLoginTracker.default
local loginType = module7.LoginType
local reportEphemeralCounter = module4.Analytics.reportEphemeralCounter
local appStorageUtilities = module4.Utils.AppStorageUtilities
local scheduleAccountSwitchRelaunchFallback = module4.Utils.scheduleAccountSwitchRelaunchFallback
local loginByPasskey = module4.Thunks.LoginByPasskey
local loginByCode = module4.Thunks.LoginByCode
local loginByOtp = module4.Thunks.LoginByOtp
local login = module4.Thunks.Login
local user = module4.Thunks.User
local appLoginCounterNames = module4.Enums.AppLoginCounterNames
local loginErrorCodes = module4.Enums.LoginErrorCodes
local getTwoStepLoginErrorKey = module4.Utils.getTwoStepLoginErrorKey
local openCentralOverlayForLoginPasswordResetPrompt = module4.Thunks.OpenCentralOverlayForLoginPasswordResetPrompt
local openAccountIneligibleLoginModal = module4.Thunks.OpenAccountIneligibleLoginModal
local logoutAllLoggedInUsers = module4.Thunks.LogoutAllLoggedInUsers
local authLocalStorageKeys = module4.Enums.AuthLocalStorageKeys
local openAccountSelector = module4.Thunks.OpenAccountSelector
local authMemStorageKeys = module4.Enums.AuthMemStorageKeys
local twoStepRequests = module4.Http.Requests.TwoStepRequests
local redeemAuthenticationTicket = module4.Http.Requests.RedeemAuthenticationTicket
local logoutReasonNames = module4.Enums.LogoutReasonNames
local passkeyConstants = module4.Common.PasskeyConstants
local record2svCompletion = module4.Utils.record2svCompletion
local recordLogin = module4.Utils.recordLogin
local twoStepErrorCodes = module4.Enums.TwoStepErrorCodes
local getUserByUsername = module4.Thunks.GetUserByUsername
local keystoreConstants = module4.Common.KeystoreConstants
local keystoreAnalyticsEvents = module4.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = module4.Analytics.KeystoreEventConstants
local fFlagEnableRecordLogin = require("@luauforge/bundled/gjO").FFlagEnableRecordLogin
local loginMethods = module4.Enums.LoginMethods
local getPasswordManagerUsageStore = module4.Stores.GetPasswordManagerUsageStore

local sendCode = module6.Thunks.SendCode
local resendCode = module6.Thunks.ResendCode
local constants2 = module6.Constants

local logger = require("@luauforge/bundled/ggN").Logger
local default3 = require("@luauforge/bundled/glF").default
local telemetryConfigs = require("@luauforge/bundled/gjG").TelemetryConfigs
local iosAuthServiceHealthCounters = require("@luauforge/bundled/gjG").RobloxTelemetry.IosAuthServiceHealthCounters
local credentialSheetTelemetry = require("@luauforge/bundled/gjG").RobloxTelemetry.CredentialSheetTelemetry
local keystoreSaveCredentialsTelemetryConfig = telemetryConfigs.KeystoreSaveCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")

local isIosAuthServiceEnabled = module4.Utils.isIosAuthServiceEnabled
local coarseLoginErrorBucket = module4.Utils.coarseLoginErrorBucket
local isNonTerminalLoginError = module4.Utils.isNonTerminalLoginError

local useNavigationProps = require("@luauforge/bundled/glw").useNavigationProps

local v5 = nil
local v6 = nil
local v7 = nil

local function getSharedExternalIdentityClient()
	if v5 ~= nil then
		return v5
	end

	local module24 = require("@luauforge/bundled/glG")
	local create = module24.create
	local v9

	if module16 or fFlagEnableAccountSwitchSsoLogin then
		v9 = module24.createRequests(nil, nil, {
			appleUsesBrowserSignIn = fFlagEnableAccountSwitchSsoLogin and function()
				return v6.appleUsesBrowserSignIn()
			end or nil,
			usesBrowserSignIn = function()
				return module24.isDesktopBrowserSignInEnabled()
			end
		})
	end

	local v10 = create({
		requests = v9,
		redeemTicket = function(p2)
			v7 = nil
			return redeemAuthenticationTicket(v6.networking, p2):andThen(function(p3)
				v7 = if p3.responseBody then p3.responseBody.accountBlob else nil

				return p3
			end)
		end,
		completeSession = function(): boolean
			local v10 = v7
			v7 = nil

			if fFlagEnableAccountSwitchSsoLogin and v10 == nil then
				local accountBlob = appStorageUtilities.getAccountBlob()

				if accountBlob ~= nil and accountBlob ~= "" then
					v10 = accountBlob
				end
			end

			v6.completeLogin(v10)
			return true
		end
	})

	v5 = v10
	return v10
end

return function(props)
	local v8 = useNavigationProps(function(p2, data)
		return {
			credProtocolIsAvailableResponse = data.credProtocolIsAvailableResponse,
			forcedUsernameOverride = data.forcedUsernameOverride,
			forceDialogLayout = data.forceDialogLayout
		}
	end)

	local v9 = {
		userIdentifier = "",
		userIdentifierType = userIdentifierType.Unknown,
		numLoginAttempts = 0,
		forceLoginByUsername = false,
		availableLoginMethods = {},
		credentialsProtocolStatus = {
			fido2Supported = false,
			passwordsSupported = false,
			v2InterfaceSupported = false,
			shouldShowAuthScreenCredentialsPopup = false,
			shouldShowAuthScreenUserSpecificPasskeyPopup = false,
			initialStateUpdated = false
		},
		shouldAutoShowCredentialPopup = true,
		componentState = {
			LoginScreenV2 = {
				errorKey = "",
				userIdentifier = "",
				shouldAttemptCredentialPrefill = true
			},
			AuthenticationScreen = { errorKey = "", errorType = nil, password = "" },
			EmailOtpScreen = {
				errorKey = "",
				emailOtp = "",
				sessionToken = "",
				sentToEnteredEmail = false,
				enteredEmail = ""
			}
		},
		monoDeps = props.monoDeps,
		extraProps = v8
	}

	local v10, v11 = module2.useReducer(module19, v9)

	local ref = module2.useRef(v10.userIdentifier)
	ref.current = v10.userIdentifier

	local v12 = module8.useBrowserTrackerExperiment({ appBtidLayers.LoginLayer }, function(p2)
		local v13 = p2[appBtidLayers.LoginLayer] or {}

		return {
			showFoundationDisambiguationSelector = v13.showFoundationDisambiguationSelector or false,
			showLoginModalization = v13.showLoginModalization or false
		}
	end)

	local forceDialogLayout = v8.forceDialogLayout == true

	local v13 = fFlagEnableLoginV2Modalization
		and (forceDialogLayout or fFlagLoginV2FullFlowDevOverride or v12.showLoginModalization)
	local v14

	if module12() then
		if v13 then
			v14 = eventStreamConstants.Origin.LoginV2Modalized
		else
			v14 = eventStreamConstants.Origin.LoginV2Fullscreen
		end
	else
		v14 = nil
	end

	local v15 = useDispatch()

	local v16 = useRoactService(roactNetworking)
	local v17 = useRoactService(roactAnalytics)
	local v18 = useRoactService(appLinking)
	local v19 = useAppPolicy(function(p2)
		return p2
	end)

	local launchApp = v10.monoDeps.LaunchApp
	local resetAppState = v10.monoDeps.ResetAppState
	local logout = v10.monoDeps.Logout

	local function fn()
		return v15(module21(v16))
	end

	local function fn2(p2)
		return v15(module20(v16, p2))
	end

	local function fn3()
		return v15(launchApp(v16, nil, v17, v19, launchContext.Login))
	end

	local function fn4()
		v15(resetAppState())
		return module3.resolve()
	end

	local function fn5()
		v11({
			type = module23.SetComponentState,
			data = {
				component = module22.AuthenticationScreen,
				payload = { errorKey = "", errorType = nil, password = "" }
			}
		})

		v11({
			type = module23.SetComponentState,
			data = {
				component = module22.LoginScreenV2,
				payload = { errorKey = "", userIdentifier = "" }
			}
		})

		v11({
			type = module23.SetUserIdentifierAndType,
			data = {
				userIdentifier = "",
				userIdentifierType = userIdentifierType.Unknown
			}
		})
	end

	local passwordManagerUsageStore = getPasswordManagerUsageStore(false)

	if fFlagEnablePWManagerSignupCheck and passwordManagerUsageStore then
		passwordManagerUsageStore.resetAll()
	elseif passwordManagerUsageStore then
		passwordManagerUsageStore.setLoggedinUsingSavedPassword(false)
		passwordManagerUsageStore.setSavedPasswordAfterLogin(false)
	end

	local function fn6()
		return v15(closeCentralOverlay())
	end

	local function fn7(...)
		return v15(login(...))
	end

	local function fn8(p2)
		if not (fFlagLoginV2FullFlowDevOverride or v12.showFoundationDisambiguationSelector or module17 and v13 and forceDialogLayout) then
			return v15(openAccountSelector(p2, true, false))
		end

		local clone = table.clone(p2)
		clone.hideActions = true
		clone.showFoundationDisambiguationSelector = true
		return v15(openAccountSelector(clone, true, true))
	end

	local function fn9(): boolean
		return user.fromLocalStorage().userId ~= -1
	end

	local function fn10(p2)
		local v20 = {
			name = appPage.GenericWebPage,
			detail = p2,
			extraProps = { title = "", transitionAnimation = "SlideInFromBottom" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v20))
		else
			v15(navigateDown(v20))
		end
	end

	local function fn11(p2)
		local v20 = {
			name = appPage.AccountRecovery,
			extraProps = { identifier = p2, recoverPassword = true }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v20))
		else
			v15(navigateDown(v20))
		end
	end

	local function fn12(p2)
		local v20 = fFlagSkipAccountSwitchRelaunchForPioneerLogin and isPioneerLaunch()

		if user.fromLocalStorage().userId ~= -1 and not v20 then
			v15(resetAppState())
			module3.resolve():andThen(function(p3)
				local v21 = if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus else accountSwitcherConstants.AccountSwitcherSwitchedStatus
				appStorageUtilities.setAccountSwitchStatus(v21)
				appStorageUtilities.setAccountBlob(p2)
				appStorageUtilities.flush()

				if fFlagLuaEnableDidSwitchAccount then
					GuiService:BroadcastNotification("", notificationType.DID_SWITCH_ACCOUNT)
				else
					GuiService:BroadcastNotification("", notificationType.DID_LOG_OUT)
				end

				if fFlagAccountSwitchRelaunchFallback then
					scheduleAccountSwitchRelaunchFallback(fn3)
				end
			end, function(p3)
				appStorageUtilities.setAccountSwitchStatus("switched")
				appStorageUtilities.setAccountBlob(p2)
				appStorageUtilities.flush()
				v15(launchApp(v16, nil, v17, v19, launchContext.Login))
			end)
		else
			appStorageUtilities.setAccountBlob(p2)
			appStorageUtilities.flush()
			v15(launchApp(v16, nil, v17, v19, launchContext.Login))
		end
	end

	v6 = {
		networking = v16,
		appleUsesBrowserSignIn = function(): boolean
			return v19.getExternalIdentityAppleUsesBrowserSignIn ~= nil
				and v19.getExternalIdentityAppleUsesBrowserSignIn() == true
		end,
		completeLogin = function(p2)
			if fFlagEnableLuaAccountSwitch and p2 then
				fn12(p2)
			else
				v15(launchApp(v16, nil, v17, v19, launchContext.Login))
			end
		end
	}

	local function fn13()
		return getSharedExternalIdentityClient().getCapabilitiesAsync()
	end

	local function fn14(p2)
		return getSharedExternalIdentityClient().authenticate(p2)
	end

	local function fn15(json)
		if json == nil then
			default3:logRobloxTelemetryCounter(
				telemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig,
				1,
				{ reason = "missingCredentialsJson" }
			)

			return nil
		end

		local jsonDecode = HttpService:JSONDecode(json)

		local v20 = if module13 then module14(jsonDecode) else nil

		local v21 = if module13 then v20 == nil else jsonDecode.cvalue == nil or jsonDecode.password == nil

		if v21 then
			default3:logRobloxTelemetryCounter(
				telemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig,
				1,
				{ reason = "missingUsernameOrPassword" }
			)

			return nil
		end

		if v10.credentialsProtocolStatus.passwordsSupported then
			local v22

			if v20 == nil then
				v22 = { username = jsonDecode.cvalue, password = jsonDecode.password }
			else
				v22 = {
					username = v20.username,
					password = v20.password,
					context = "login"
				}
			end

			local jsonEncode = HttpService:JSONEncode(v22)
			default3:logRobloxTelemetryCounter(
				telemetryConfigs.IosAuthServiceLoginPasswordSaveAttemptedConfig,
				1
			)

			return default:registerCredentials(
				default.CredentialsTypes.password,
				jsonEncode,
				constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
			):andThen(
				function(json2)
					if json2 then
						local jsonDecode2 = HttpService:JSONDecode(json2)

						if jsonDecode2.errorCode == nil then
							if passwordManagerUsageStore then
								passwordManagerUsageStore.setSavedPasswordAfterLogin(true)
							end

							logger:info("Successfully registered password.")

							authButtonClick(
								eventStreamConstants.Context.CMPasswordLogin,
								eventStreamConstants.Button.SavePassword,
								nil,
								nil,
								nil,
								v14
							)

							default3:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginPasswordSaveSuccessConfig,
								1
							)

							iosAuthServiceHealthCounters.reportPasswordSaveSuccess({
								credentialType = "password",
								iosAuthServiceEnabled = isIosAuthServiceEnabled()
							})
						elseif
							module13
							and jsonDecode2.errorCode == credentialsProtocolErrorCodes.RegisterCredentialsErrorCodes.PASSWORD_AUTOFILL_DISABLED
						then
							logger:info("Skipping password save: iCloud Keychain Password AutoFill is disabled.")

							if not fFlagDisableMemStorageServicePasswordEvent then
								MemStorageService:Fire(authMemStorageKeys.AuthenticatedCredentials, json)
							end

							default3:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig,
								1,
								{ reason = "passwordAutoFillDisabled" }
							)
						else
							logger:warning("Error registering password: {}", jsonDecode2.errorMsg)
							default3:logRobloxTelemetryCounter(
								telemetryConfigs.IosAuthServiceLoginPasswordSaveFailureConfig,
								1,
								{
									errorCode = tostring(jsonDecode2.errorCode)
								}
							)

							iosAuthServiceHealthCounters.reportPasswordSaveFailure({
								credentialType = "password",
								errorCode = tostring(jsonDecode2.errorCode),
								iosAuthServiceEnabled = isIosAuthServiceEnabled()
							})
						end
					end
				end,
				function(p2)
					logger:warning("Error registering password: {}", p2)
					default3:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginPasswordSaveFailureConfig,
						1,
						{ error = tostring(p2) }
					)

					iosAuthServiceHealthCounters.reportPasswordSaveFailure({
						credentialType = "password",
						errorCode = "transportError",
						iosAuthServiceEnabled = isIosAuthServiceEnabled()
					})
				end
			)
		end

		if not fFlagDisableMemStorageServicePasswordEvent then
			MemStorageService:Fire(authMemStorageKeys.AuthenticatedCredentials, json)
		end

		default3:logRobloxTelemetryCounter(
			telemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig,
			1,
			{ reason = "passwordsNotSupported" }
		)

		return nil
	end

	local function fn16(p2, p3)
		local twoStepLoginErrorKey = getTwoStepLoginErrorKey(p2)

		if p2 and p2 == twoStepErrorCodes.IllegalChildAccountLinking then
			reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)
		else
			reportEphemeralCounter(appLoginCounterNames.FailureUnknownError, 1)
		end

		if fFlagEnableAccountIneligibleLoginModal and p2 == twoStepErrorCodes.PioneerAccountIneligible then
			p3.setInProgress(false)
			p3.setErrorKey("")
			v15(openAccountIneligibleLoginModal(function()
				props.parentNavigation.goBack()
			end, v13))
		else
			p3.setInProgress(false)
			p3.setErrorKey(twoStepLoginErrorKey)
		end
	end

	local function fn17(p2, p3, p4, p5)
		local ticket = p2.twoStepVerificationData.ticket
		local id = p2.user.id
		renderChallenge({
			title = "Authentication.Login.Label.TwoStepVerification",
			challengeType = challengeType.TwoStepVerification,
			challengeParameters = {
				actionType = twoStepVerificationActionType.Login,
				challengeId = ticket,
				userId = id,
				allowRememberDevice = true,
				clientSupports2svRecovery = fFlagEnable2SVRecovery and true or false
			},
			callbacks = {
				OnChallengeCompleted = function(p6)
					twoStepRequests.login(
						v16,
						id,
						ticket,
						p6.data.verificationToken,
						p6.data.rememberDevice
					):andThen(
						function(p7)
							module5.setDisabled(false)

							reportEphemeralCounter(appLoginCounterNames.Success, 1)

							if p5 then
								iosAuthServiceHealthCounters.reportLoginSuccess({
									credentialType = p5,
									iosAuthServiceEnabled = isIosAuthServiceEnabled()
								})
							end

							local v21 = defineFastFlag and fn15(p3)

							if v21 then
								v21:await()
							end

							if fFlagEnableRecordLogin then
								pcall(function()
									record2svCompletion(id)
								end)
							end

							if fFlagEnableLuaAccountSwitch then
								fn12(p7.responseBody and p7.responseBody.accountBlob)
							else
								v15(launchApp(v16, nil, v17, v19, launchContext.Login))
							end
						end,
						function(p7)
							if fFlagEnableTimeToLoginMetrics then
								default2.cancel()
							end

							reportEphemeralCounter(appLoginCounterNames.Failure, 1)

							if p5 then
								iosAuthServiceHealthCounters.reportLoginFailure({
									credentialType = p5,
									errorCode = "twoStepFailed",
									iosAuthServiceEnabled = isIosAuthServiceEnabled()
								})
							end

							if defineFastFlag2 then
								local success, result = pcall(function()
									return HttpService:JSONDecode(p7.Body).errors[1].code
								end)

								if not success then
									result = nil
								end

								fn16(result, p4)
							else
								reportEphemeralCounter(appLoginCounterNames.FailureUnknownError, 1)
								p4.setInProgress(false)
								p4.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
							end
						end
					):finally(function()
						if not defineFastFlag then
							fn15(p3)
						end
					end)
				end,
				OnChallengeAbandoned = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					p4.setInProgress(false)
				end,
				OnChallengeInvalidated = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					p4.setInProgress(false)
					p4.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end,
				OnChallengeLoadFailed = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					p4.setInProgress(false)
					p4.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end
			}
		})
	end

	local function fn18(value, p2, securityQuestionsData, securityQuestionsCallback, data)
		renderChallenge({
			challengeType = challengeType.SecurityQuestions,
			challengeParameters = {
				sessionId = securityQuestionsData.sessionId,
				userId = securityQuestionsData.userId
			},
			callbacks = {
				OnChallengeCompleted = function(p3)
					securityQuestionsCallback({
						sessionId = securityQuestionsData.sessionId,
						redemptionToken = p3.data.redemptionToken
					})
				end,
				OnChallengeAbandoned = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					data.setInProgress(false)
				end,
				OnChallengeInvalidated = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					data.setInProgress(false)
					data.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end,
				OnChallengeLoadFailed = function()
					if fFlagEnableTimeToLoginMetrics then
						default2.cancel()
					end

					data.setInProgress(false)
					data.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end
			}
		})
	end

	local function fn19(p2, json, p3, p4)
		module5.setDisabled(false)

		module3.new(function(callback, callback2)
			if getFFlagKeystoreAutoLoginAvailable() == false or json == nil then
				callback()
				return
			end

			local jsonEncode = HttpService:JSONEncode({
				server = ContentProvider.BaseUrl
			})

			local jsonDecode = HttpService:JSONDecode(json)

			getUserByUsername(v16, jsonDecode.cvalue)():andThen(function(p5)
				if p5 and p5.id then
					return default:isAvailable(
						default.CredentialsTypes.keystore,
						keystoreConstants.KeystoreTimeout
					):andThen(function(p6)
						if p6 and p6.keystore and p6.keystore.isAvailable then
							return default:deleteAllCredentialsFromKeystore(
								default.CredentialsTypes.keystore,
								jsonEncode,
								keystoreConstants.KeystoreTimeout
							)
						end

						return module3.resolve(nil)
					end):andThen(function()
						return p5
					end)
				end

				return callback2("Invalid usernameInfo")
			end):andThen(function(p5)
				keystoreAnalyticsEvents.sendPageLoadEvent(
					keystoreEventConstants.origin.saveCredentials,
					(tostring(p5.id))
				)

				TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
					customFields = { result = "attempt" }
				}, 1)

				local jsonEncode2 = HttpService:JSONEncode({
					server = tostring(ContentProvider.BaseUrl),
					username = tostring(jsonDecode.cvalue),
					userId = tostring(p5.id),
					password = tostring(jsonDecode.password)
				})

				return default:registerCredentials(
					default.CredentialsTypes.keystore,
					jsonEncode2,
					keystoreConstants.KeystoreTimeout
				)
			end):andThen(function(p5)
				callback()
			end):catch(function(p5)
				TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
					customFields = { result = "error" }
				}, 1)

				callback2(p5)
			end)
		end):finally(function()
			if loginResult.hasTwoStepData(p2) then
				if fFlagEnableTimeToLoginMetrics then
					default2.markTwoStepVerification()
				end

				reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)

				spawn(function()
					fn17(p2, json, p3, p4)
				end)
			else
				reportEphemeralCounter(appLoginCounterNames.Success, 1)

				if json then
					if defineFastFlag then
						local v20 = fn15(json)

						if v20 then
							v20:await()
						end
					else
						fn15(json)
					end
				end

				if fFlagEnableLuaAccountSwitch then
					fn12(p2.accountBlob)
				else
					v15(launchApp(v16, nil, v17, v19, launchContext.Login))
				end
			end

			if getFFlagEnableLoginAccountSelector() then
				v15(closeCentralOverlay())
			end
		end)
	end

	local fn20
	local function handleLoginWithFormData(p2, p3, p4, p5, p6, p7, p8)
		local v20 = fn20(p8)

		local v21 = p2 or v10.userIdentifier

		if
			fFlagEnableTimeToLoginMetrics
			and (fFlagRestartTimeToLoginOnHumanInteractionRetry or p4 == nil and p5 == nil and p6 == nil)
		then
			default2.start(loginType.Password, v10.userIdentifierType)
		end

		module5.setDisabled(true)

		return fn7(v16, v21, p3, function(p9, p10)
			if p9 then
				handleLoginWithFormData(p2, p3, p10, p5, p6, p7, p8)
			elseif fFlagEnableTimeToLoginMetrics then
				default2.cancel()
			end
		end, p4, function(p9)
			handleLoginWithFormData(p2, p3, p4, p9, p6, p7, p8)
		end, p5, p6, v10.forceLoginByUsername):andThen(function(p9)
			AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, v21)
			AppStorageService:Flush()

			if loginResult.hasTwoStepData(p9) then
				iosAuthServiceHealthCounters.reportLoginTwoStepRequired({
					credentialType = "password",
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})
			else
				iosAuthServiceHealthCounters.reportLoginSuccess({
					credentialType = "password",
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})

				if p7 and isIosAuthServiceEnabled() then
					credentialSheetTelemetry.report(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessConfig,
						{ credentialType = "password" }
					)
				end
			end

			if passwordManagerUsageStore and p7 then
				passwordManagerUsageStore.setLoggedinUsingSavedPassword(true)
			end

			local v22

			if p7 then
				v22 = nil
			else
				local v24 = {
					cvalue = v21,
					password = p3,
					authType = "login",
					canonicalUsername = 0
				}

				local v25 = if module13 then p9 and p9.user and p9.user.name else nil
				v24.canonicalUsername = v25
				v22 = HttpService:JSONEncode(v24)
			end

			local v23 = p8
			module5.setDisabled(false)

			local v24 = "password"
			module3.new(function(callback, callback2)
				if getFFlagKeystoreAutoLoginAvailable() == false or v22 == nil then
					callback()
					return
				end

				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				local jsonDecode = HttpService:JSONDecode(v22)

				getUserByUsername(v16, jsonDecode.cvalue)():andThen(function(p10)
					if p10 and p10.id then
						return default:isAvailable(
							default.CredentialsTypes.keystore,
							keystoreConstants.KeystoreTimeout
						):andThen(function(p11)
							if p11 and p11.keystore and p11.keystore.isAvailable then
								return default:deleteAllCredentialsFromKeystore(
									default.CredentialsTypes.keystore,
									jsonEncode,
									keystoreConstants.KeystoreTimeout
								)
							end

							return module3.resolve(nil)
						end):andThen(function()
							return p10
						end)
					end

					return callback2("Invalid usernameInfo")
				end):andThen(function(p10)
					keystoreAnalyticsEvents.sendPageLoadEvent(
						keystoreEventConstants.origin.saveCredentials,
						(tostring(p10.id))
					)

					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "attempt" }
					}, 1)

					local jsonEncode2 = HttpService:JSONEncode({
						server = tostring(ContentProvider.BaseUrl),
						username = tostring(jsonDecode.cvalue),
						userId = tostring(p10.id),
						password = tostring(jsonDecode.password)
					})

					return default:registerCredentials(
						default.CredentialsTypes.keystore,
						jsonEncode2,
						keystoreConstants.KeystoreTimeout
					)
				end):andThen(function(p10)
					callback()
				end):catch(function(p10)
					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "error" }
					}, 1)

					callback2(p10)
				end)
			end):finally(function()
				if loginResult.hasTwoStepData(p9) then
					if fFlagEnableTimeToLoginMetrics then
						default2.markTwoStepVerification()
					end

					reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)

					spawn(function()
						fn17(p9, v22, v23, v24)
					end)
				else
					reportEphemeralCounter(appLoginCounterNames.Success, 1)

					if v22 then
						if defineFastFlag then
							local v25 = fn15(v22)

							if v25 then
								v25:await()
							end
						else
							fn15(v22)
						end
					end

					if fFlagEnableLuaAccountSwitch then
						fn12(p9.accountBlob)
					else
						v15(launchApp(v16, nil, v17, v19, launchContext.Login))
					end
				end

				if getFFlagEnableLoginAccountSelector() then
					v15(closeCentralOverlay())
				end
			end)
		end, function(p9)
			if not isNonTerminalLoginError(p9, {
				credentialValue = v21,
				password = p3,
				accountSelectorRequiresCredentials = true,
				accountSwitchEnabled = fFlagEnableLuaAccountSwitch
			}) then
				if fFlagEnableTimeToLoginMetrics then
					default2.cancel()
				end

				iosAuthServiceHealthCounters.reportLoginFailure({
					credentialType = "password",
					errorCode = coarseLoginErrorBucket(p9),
					iosAuthServiceEnabled = isIosAuthServiceEnabled()
				})

				if p7 and isIosAuthServiceEnabled() then
					local v22 = { credentialType = "password" }

					if p9 and p9.errorCode ~= nil then
						v22.errorCode = tostring(p9.errorCode)
					end

					credentialSheetTelemetry.report(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureConfig,
						v22
					)
				end
			end

			v20(p9, v21, p3, true)
		end)
	end

	local function fn21(p2, sessionId, p3, p4)
		local v20 = fn20(p3)

		if fFlagEnableTimeToLoginMetrics then
			default2.start(loginType.Passkey, v10.userIdentifierType)
		end

		module5.setDisabled(true)

		return v15(loginByPasskey(v16, p2, sessionId)):andThen(function(p5)
			if loginResult.hasTwoStepData(p5) then
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
					credentialSheetTelemetry.report(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginSuccessConfig,
						{ credentialType = "passkey" }
					)
				end
			end

			local v21 = p3
			module5.setDisabled(false)

			local v22 = nil

			local v23 = nil
			local v24 = "passkey"
			module3.new(function(callback, callback2)
				if getFFlagKeystoreAutoLoginAvailable() == false or v22 == nil then
					callback()
					return
				end

				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				local jsonDecode = HttpService:JSONDecode(v22)

				getUserByUsername(v16, jsonDecode.cvalue)():andThen(function(p6)
					if p6 and p6.id then
						return default:isAvailable(
							default.CredentialsTypes.keystore,
							keystoreConstants.KeystoreTimeout
						):andThen(function(p7)
							if p7 and p7.keystore and p7.keystore.isAvailable then
								return default:deleteAllCredentialsFromKeystore(
									default.CredentialsTypes.keystore,
									jsonEncode,
									keystoreConstants.KeystoreTimeout
								)
							end

							return module3.resolve(nil)
						end):andThen(function()
							return p6
						end)
					end

					return callback2("Invalid usernameInfo")
				end):andThen(function(p6)
					keystoreAnalyticsEvents.sendPageLoadEvent(
						keystoreEventConstants.origin.saveCredentials,
						(tostring(p6.id))
					)

					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "attempt" }
					}, 1)

					local jsonEncode2 = HttpService:JSONEncode({
						server = tostring(ContentProvider.BaseUrl),
						username = tostring(jsonDecode.cvalue),
						userId = tostring(p6.id),
						password = tostring(jsonDecode.password)
					})

					return default:registerCredentials(
						default.CredentialsTypes.keystore,
						jsonEncode2,
						keystoreConstants.KeystoreTimeout
					)
				end):andThen(function(p6)
					callback()
				end):catch(function(p6)
					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "error" }
					}, 1)

					callback2(p6)
				end)
			end):finally(function()
				if loginResult.hasTwoStepData(p5) then
					if fFlagEnableTimeToLoginMetrics then
						default2.markTwoStepVerification()
					end

					reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)

					spawn(function()
						fn17(p5, v23, v21, v24)
					end)
				else
					reportEphemeralCounter(appLoginCounterNames.Success, 1)

					if v23 then
						if defineFastFlag then
							local v25 = fn15(v23)

							if v25 then
								v25:await()
							end
						else
							fn15(v23)
						end
					end

					if fFlagEnableLuaAccountSwitch then
						fn12(p5.accountBlob)
					else
						v15(launchApp(v16, nil, v17, v19, launchContext.Login))
					end
				end

				if getFFlagEnableLoginAccountSelector() then
					v15(closeCentralOverlay())
				end
			end)
		end, function(p5)
			if not isNonTerminalLoginError(p5, {
				accountSelectorRequiresCredentials = true,
				accountSwitchEnabled = fFlagEnableLuaAccountSwitch
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
					local v21 = { credentialType = "passkey" }

					if p5 and p5.errorCode ~= nil then
						v21.errorCode = tostring(p5.errorCode)
					end

					credentialSheetTelemetry.report(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetLoginFailureConfig,
						v21
					)
				end
			end

			v20(p5, p2, nil)
		end)
	end

	local function handleLoginWithCode(p2, p3, p4, p5, p6)
		local v20 = fn20(p6)

		if
			fFlagEnableTimeToLoginMetrics
			and (fFlagRestartTimeToLoginOnHumanInteractionRetry or p4 == nil and p5 == nil)
		then
			default2.start(loginType.AuthCode, v10.userIdentifierType)
		end

		module5.setDisabled(true)

		return v15(loginByCode(v16, p2, p3, function(p7, p8)
			if p7 then
				handleLoginWithCode(p2, p3, p8, nil, p6)
			elseif fFlagEnableTimeToLoginMetrics then
				default2.cancel()
			end
		end, p4, function(p7)
			handleLoginWithCode(p2, p3, nil, p7, p6)
		end, p5)):andThen(function(p7)
			local v21 = p6
			module5.setDisabled(false)

			local v22 = nil

			local v23 = nil
			local v24 = nil
			module3.new(function(callback, callback2)
				if getFFlagKeystoreAutoLoginAvailable() == false or v22 == nil then
					callback()
					return
				end

				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				local jsonDecode = HttpService:JSONDecode(v22)

				getUserByUsername(v16, jsonDecode.cvalue)():andThen(function(p8)
					if p8 and p8.id then
						return default:isAvailable(
							default.CredentialsTypes.keystore,
							keystoreConstants.KeystoreTimeout
						):andThen(function(p9)
							if p9 and p9.keystore and p9.keystore.isAvailable then
								return default:deleteAllCredentialsFromKeystore(
									default.CredentialsTypes.keystore,
									jsonEncode,
									keystoreConstants.KeystoreTimeout
								)
							end

							return module3.resolve(nil)
						end):andThen(function()
							return p8
						end)
					end

					return callback2("Invalid usernameInfo")
				end):andThen(function(p8)
					keystoreAnalyticsEvents.sendPageLoadEvent(
						keystoreEventConstants.origin.saveCredentials,
						(tostring(p8.id))
					)

					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "attempt" }
					}, 1)

					local jsonEncode2 = HttpService:JSONEncode({
						server = tostring(ContentProvider.BaseUrl),
						username = tostring(jsonDecode.cvalue),
						userId = tostring(p8.id),
						password = tostring(jsonDecode.password)
					})

					return default:registerCredentials(
						default.CredentialsTypes.keystore,
						jsonEncode2,
						keystoreConstants.KeystoreTimeout
					)
				end):andThen(function(p8)
					callback()
				end):catch(function(p8)
					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "error" }
					}, 1)

					callback2(p8)
				end)
			end):finally(function()
				if loginResult.hasTwoStepData(p7) then
					if fFlagEnableTimeToLoginMetrics then
						default2.markTwoStepVerification()
					end

					reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)

					spawn(function()
						fn17(p7, v23, v21, v24)
					end)
				else
					reportEphemeralCounter(appLoginCounterNames.Success, 1)

					if v23 then
						if defineFastFlag then
							local v25 = fn15(v23)

							if v25 then
								v25:await()
							end
						else
							fn15(v23)
						end
					end

					if fFlagEnableLuaAccountSwitch then
						fn12(p7.accountBlob)
					else
						v15(launchApp(v16, nil, v17, v19, launchContext.Login))
					end
				end

				if getFFlagEnableLoginAccountSelector() then
					v15(closeCentralOverlay())
				end
			end)
		end, function(p7)
			if
				fFlagEnableTimeToLoginMetrics
				and not isNonTerminalLoginError(p7, {
					credentialValue = p2,
					password = p3,
					accountSelectorRequiresCredentials = true,
					accountSwitchEnabled = fFlagEnableLuaAccountSwitch
				})
			then
				default2.cancel()
			end

			reportEphemeralCounter(appLoginCounterNames.FailureAuthCode, 1)
			v20(p7, p2, p3)
		end)
	end

	local function handleLoginWithOtp(p2, p3, p4, p5, p6)
		local v20 = fn20(p6)

		if
			fFlagEnableTimeToLoginMetrics
			and (fFlagRestartTimeToLoginOnHumanInteractionRetry or p4 == nil and p5 == nil)
		then
			default2.start(loginType.EmailOtp, userIdentifierType.Email)
		end

		module5.setDisabled(true)

		return v15(loginByOtp(v16, p2, p3, function(p7)
			handleLoginWithOtp(p2, p3, p7, p5, p6)
		end, p4, p5)):andThen(function(p7)
			AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, v10.userIdentifier)

			if fFlagEnableRecordLogin then
				pcall(function()
					recordLogin(p7, loginMethods.EmailOtp, v10.userIdentifier)
				end)
			end

			local v21 = p6
			module5.setDisabled(false)

			local v22 = nil

			local v23 = nil
			local v24 = nil
			module3.new(function(callback, callback2)
				if getFFlagKeystoreAutoLoginAvailable() == false or v22 == nil then
					callback()
					return
				end

				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				local jsonDecode = HttpService:JSONDecode(v22)

				getUserByUsername(v16, jsonDecode.cvalue)():andThen(function(p8)
					if p8 and p8.id then
						return default:isAvailable(
							default.CredentialsTypes.keystore,
							keystoreConstants.KeystoreTimeout
						):andThen(function(p9)
							if p9 and p9.keystore and p9.keystore.isAvailable then
								return default:deleteAllCredentialsFromKeystore(
									default.CredentialsTypes.keystore,
									jsonEncode,
									keystoreConstants.KeystoreTimeout
								)
							end

							return module3.resolve(nil)
						end):andThen(function()
							return p8
						end)
					end

					return callback2("Invalid usernameInfo")
				end):andThen(function(p8)
					keystoreAnalyticsEvents.sendPageLoadEvent(
						keystoreEventConstants.origin.saveCredentials,
						(tostring(p8.id))
					)

					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "attempt" }
					}, 1)

					local jsonEncode2 = HttpService:JSONEncode({
						server = tostring(ContentProvider.BaseUrl),
						username = tostring(jsonDecode.cvalue),
						userId = tostring(p8.id),
						password = tostring(jsonDecode.password)
					})

					return default:registerCredentials(
						default.CredentialsTypes.keystore,
						jsonEncode2,
						keystoreConstants.KeystoreTimeout
					)
				end):andThen(function(p8)
					callback()
				end):catch(function(p8)
					TelemetryService:LogCounter(keystoreSaveCredentialsTelemetryConfig, {
						customFields = { result = "error" }
					}, 1)

					callback2(p8)
				end)
			end):finally(function()
				if loginResult.hasTwoStepData(p7) then
					if fFlagEnableTimeToLoginMetrics then
						default2.markTwoStepVerification()
					end

					reportEphemeralCounter(appLoginCounterNames.FailureTwoStepVerification, 1)

					spawn(function()
						fn17(p7, v23, v21, v24)
					end)
				else
					reportEphemeralCounter(appLoginCounterNames.Success, 1)

					if v23 then
						if defineFastFlag then
							local v25 = fn15(v23)

							if v25 then
								v25:await()
							end
						else
							fn15(v23)
						end
					end

					if fFlagEnableLuaAccountSwitch then
						fn12(p7.accountBlob)
					else
						v15(launchApp(v16, nil, v17, v19, launchContext.Login))
					end
				end

				if getFFlagEnableLoginAccountSelector() then
					v15(closeCentralOverlay())
				end
			end)
		end, function(p7)
			if
				fFlagEnableTimeToLoginMetrics
				and not isNonTerminalLoginError(p7, {
					credentialValue = p2,
					password = p3,
					accountSelectorRequiresCredentials = true,
					accountSwitchEnabled = fFlagEnableLuaAccountSwitch
				})
			then
				default2.cancel()
			end

			v20(p7, p2, p3)
		end)
	end

	local function fn22(callback, p2, p3)
		module5.setDisabled(true)

		return v15(sendCode(v16, {
			origin = constants2.otpServiceOrigin,
			contactType = constants2.otpServiceContactType,
			contactValue = p3 or v10.userIdentifier
		})):andThen(function(p4)
			callback(p4.otpSessionToken)
		end, function(p4)
			p2.setInProgress(false)
			local v21 = tonumber(p4) or 0
			local v22 = constants2.statusCodeMap[v21] or "Unknown"
			local v23 = constants2.errorMessageKeys[v22] or constants2.errorMessageKeys.Unknown
			p2.setErrorKey(v23)
		end)
	end

	local function fn23(p2, callback, p3)
		module5.setDisabled(true)

		return v15(resendCode(v16, {
			origin = constants2.otpServiceOrigin,
			contactType = constants2.otpServiceContactType,
			otpSessionToken = p2
		})):andThen(
			function(p4)
				callback(p4.otpSessionToken)
			end,
			function(p4)
				p3.setInProgress(false)
				local v21 = tonumber(p4) or 0
				local v22 = constants2.statusCodeMap[v21] or "Unknown"
				local v23 = constants2.errorMessageKeys[v22] or constants2.errorMessageKeys.Unknown
				p3.setErrorKey(v23)
			end
		)
	end

	local function fn24(data, p2, deviceBoundOnly)
		local fn25

		if p2 then
			fn25 = function()
				return fn2({
					cvalue = v10.userIdentifier,
					ctype = v10.userIdentifierType
				})
			end
		else
			fn25 = function()
				return fn()
			end
		end

		local v20 = false
		return fn25():andThen(function(p3)
			local jsonDecode = HttpService:JSONDecode(p3.authenticationOptions)
			local sessionId = p3.sessionId
			local timeout = tonumber(jsonDecode.publicKey.timeout)
			local v21

			if timeout then
				v21 = timeout / 1000
			else
				v21 = constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT
			end

			jsonDecode.keyType = "platform"
			jsonDecode.deviceBoundOnly = deviceBoundOnly

			if UserInputService:GetPlatform() ~= Enum.Platform.Android then
				jsonDecode.publicKey.challenge = base64.FromUrlSafeBase64(jsonDecode.publicKey.challenge)

				if jsonDecode.publicKey.allowCredentials then
					for i, allowCredential in ipairs(jsonDecode.publicKey.allowCredentials) do
						allowCredential.id = base64.FromUrlSafeBase64(allowCredential.id)
					end
				end
			end

			local jsonEncode = HttpService:JSONEncode(jsonDecode)
			default:getCredentials(default.CredentialsTypes.FIDO2, jsonEncode, v21):andThen(function(json)
				if json ~= nil then
					local jsonDecode2 = HttpService:JSONDecode(json)

					if jsonDecode2 == nil or next(jsonDecode2) == nil then
						logger:info("Passkey credential signing failed. No result returned.")
					elseif jsonDecode2.errorCode == nil then
						logger:info("Passkey credential signing completed. Attempting login.")

						jsonDecode2.id = base64.ToUrlSafeBase64(jsonDecode2.id)
						jsonDecode2.rawId = base64.ToUrlSafeBase64(jsonDecode2.rawId)
						jsonDecode2.response.signature = base64.ToUrlSafeBase64(jsonDecode2.response.signature)
						jsonDecode2.response.userHandle = base64.ToUrlSafeBase64(jsonDecode2.response.userHandle)
						jsonDecode2.response.authenticatorData = base64.ToUrlSafeBase64(jsonDecode2.response.authenticatorData)
						jsonDecode2.response.clientDataJSON = base64.ToUrlSafeBase64(jsonDecode2.response.clientDataJSON)
						data.setInProgress(true)
						v20 = true
						fn21(jsonDecode2, sessionId, data)
					else
						logger:info(
							"Passkey credential signing failed. Error {} (msg: {}) returned.",
							jsonDecode2.errorCode,
							jsonDecode2.errorMsg
						)

						local errorCode = tonumber(jsonDecode2.errorCode)
						local v22 = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[errorCode or -1]
							or string.format(
								credentialsProtocolErrorCodes.UNMAPPED_ERROR_CODE,
								(tostring(jsonDecode2.errorCode))
							)

						authClientError(
							eventStreamConstants.Context.PasskeyLoginAttempt,
							v22,
							passkeyConstants.PASSKEY_FETCH_LOGIN_V2,
							v14
						)
					end
				end
			end, function(p4)
				logger:warning("Passkey credential signing failed. Error: {}", p4)
			end):await()
		end, function(p3)
			logger:warning("Fetching passkey login options failed with error code: {}", p3.errorCode)

			if p2 and not deviceBoundOnly then
				data.setErrorKey("Authentication.Login.Response.UnableToSignIn")
			end
		end):finally(function()
			if data.onCredentialsPopupAbandoned and not v20 then
				data.onCredentialsPopupAbandoned()
			end
		end)
	end

	local function fn25(p2, p3, p4, p5)
		if p2 or p3 then
			local fn26

			if p4 then
				fn26 = function()
					return fn2({
						cvalue = v10.userIdentifier,
						ctype = v10.userIdentifierType
					})
				end
			else
				fn26 = function()
					return fn()
				end
			end

			local v20 = nil
			local sessionId = nil
			local timeout = nil

			local v21 = {}

			if p2 then
				fn26():andThen(function(p6)
					v20 = HttpService:JSONDecode(p6.authenticationOptions)
					sessionId = p6.sessionId
					timeout = tonumber(v20.publicKey.timeout)
						or constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT
					v20.keyType = "platform"
					v20.deviceBoundOnly = true

					if UserInputService:GetPlatform() ~= Enum.Platform.Android then
						v20.publicKey.challenge = base64.FromUrlSafeBase64(v20.publicKey.challenge)

						if v20.publicKey.allowCredentials then
							for i, allowCredential in ipairs(v20.publicKey.allowCredentials) do
								allowCredential.id = base64.FromUrlSafeBase64(allowCredential.id)
							end
						end
					end
				end, function(p6)
					logger:warning(
						"Fetching passkey login options failed with error code: {}",
						p6.errorCode
					)
				end):await()

				if v20 ~= nil then
					v21.FIDO2 = v20
				end
			end

			if p3 then
				v21.password = {}

				if p4 then
					v21.password.username = v10.userIdentifier
				end
			end

			local v22

			if timeout then
				v22 = timeout / 1000
			else
				v22 = constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT
			end

			local v23 = false
			local jsonEncode = HttpService:JSONEncode(v21)

			if isIosAuthServiceEnabled() then
				credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetShownConfig)
			end

			local v24 = module15

			if v24 then
				v24 = not (v21.FIDO2 == nil) and p3
			end

			local v25 = false

			local v26 = false

			local function fn27(json)
				if json ~= nil then
					local jsonDecode = HttpService:JSONDecode(json)

					if jsonDecode == nil or not (jsonDecode.response or jsonDecode.errorCode) then
						logger:info("Generic credential fetch failed. No result returned.")

						if isIosAuthServiceEnabled() then
							credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig)
						end
					elseif jsonDecode.errorCode == nil then
						if jsonDecode.credentialType == default.CredentialsTypes.password then
							if isIosAuthServiceEnabled() then
								credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetPasswordSelectedConfig)
							end

							p5.setInProgress(true)
							v23 = true
							handleLoginWithFormData(
								jsonDecode.response.username,
								jsonDecode.response.password,
								nil,
								nil,
								nil,
								true,
								p5
							)
						elseif jsonDecode.credentialType == default.CredentialsTypes.FIDO2 then
							if isIosAuthServiceEnabled() then
								credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetPasskeySelectedConfig)
							end

							jsonDecode.response.id = base64.ToUrlSafeBase64(jsonDecode.response.id)
							jsonDecode.response.rawId = base64.ToUrlSafeBase64(jsonDecode.response.rawId)
							jsonDecode.response.response.signature = base64.ToUrlSafeBase64(jsonDecode.response.response.signature)
							jsonDecode.response.response.userHandle = base64.ToUrlSafeBase64(jsonDecode.response.response.userHandle)
							jsonDecode.response.response.authenticatorData = base64.ToUrlSafeBase64(jsonDecode.response.response.authenticatorData)
							jsonDecode.response.response.clientDataJSON = base64.ToUrlSafeBase64(jsonDecode.response.response.clientDataJSON)
							p5.setInProgress(true)
							v23 = true
							fn21(jsonDecode.response, sessionId, p5, true)
						end
					else
						logger:info(
							"Generic credential fetch failed. Error {} (msg: {}) returned.",
							jsonDecode.errorCode,
							jsonDecode.errorMsg
						)

						local getCredentialsErrorCode = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[tonumber(jsonDecode.errorCode) or -1]

						if isIosAuthServiceEnabled() then
							if getCredentialsErrorCode == "CANCELLATION_ERROR" then
								credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig)
							else
								credentialSheetTelemetry.report(
									telemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig,
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
							authClientError(
								eventStreamConstants.Context.PasskeyLoginAttempt,
								jsonDecode.errorMsg,
								passkeyConstants.GENERIC_CREDENTIAL_FETCH_LOGIN_V2,
								v14
							)
						end

						if getCredentialsErrorCode == "NO_CREDENTIALS_FOUND" and v24 and not v25 then
							v26 = true
						end
					end
				end
			end

			local function fn28(p6)
				logger:warning("Generic credential signing failed. Error: {}", p6)

				if isIosAuthServiceEnabled() then
					local v27 = if typeof(p6) == "table" then tonumber(p6.errorCode) else tonumber(p6)
					local getCredentialsErrorCode = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[v27 or -1]

					if getCredentialsErrorCode == "CANCELLATION_ERROR" then
						credentialSheetTelemetry.report(telemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig)
					else
						credentialSheetTelemetry.report(
							telemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig,
							{
								errorCode = getCredentialsErrorCode or "rejected"
							}
						)
					end
				end
			end

			local function fn29(p6)
				return default:getCredentials(default.CredentialsTypes.all, p6, v22):andThen(fn27, fn28)
			end

			return default:getCredentials(default.CredentialsTypes.all, jsonEncode, v22):andThen(fn27, fn28):andThen(function()
				if not v26 then
					return nil
				end

				v25 = true
				v21.FIDO2.deviceBoundOnly = false

				if isIosAuthServiceEnabled() then
					credentialSheetTelemetry.report(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
						{ errorCode = "noDeviceBoundCredential" }
					)
				end

				return fn29(HttpService:JSONEncode(v21))
			end):andThen(function(p6)
				if p5.onCredentialsPopupAbandoned and not v23 then
					p5.onCredentialsPopupAbandoned()
				end
			end):catch(function(p6)
				if p5.onCredentialsPopupAbandoned and not v23 then
					p5.onCredentialsPopupAbandoned()
				end
			end)
		elseif isIosAuthServiceEnabled() then
			credentialSheetTelemetry.report(
				telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
				{ errorCode = "noSupportedCredentials" }
			)
		end
	end

	local function fn26(p2, p3, p4, p5, p6, p7, p8, p9, p10)
		return v15(openAccountSwitchingErrorOverlay(p2, p3, p4, p5, p6, p7, p8, p9, nil, v13, p10))
	end

	local function fn27()
		return v15(openCentralOverlayForLoginPasswordResetPrompt())
	end

	local function fn28(p2, p3)
		return logoutAllLoggedInUsers(p2, p3)
	end

	local function fn29()
		return v15(setCentralOverlay(centralOverlayType.NewAppAvailableModal, {
			onButtonActivated = function()
				v18:openURL(getFStringVNGDownloadNowUrl())
			end
		}))
	end

	local function fn30(usersData, value, p2, data)
		local v20 = ""

		if data.isLoginByOtp then
			v20 = eventStreamConstants.Context.DisambiguationOTP
		elseif v10.userIdentifierType == userIdentifierType.Email then
			v20 = eventStreamConstants.Context.DisambiguationEmail
		elseif v10.userIdentifierType == userIdentifierType.Phone then
			v20 = eventStreamConstants.Context.DisambiguationPhone
		end

		fn8({
			origin = eventStreamConstants.Context.Login,
			context = v20,
			users = usersData,
			onAccountSelection = function(p3)
				if data.isLoginByOtp then
					handleLoginWithOtp(value, p2, nil, p3, data)
				else
					handleLoginWithFormData(value, p2, nil, nil, p3, false, data):await()
				end
			end,
			onAccountSelectionAbandoned = function()
				if fFlagEnableTimeToLoginMetrics then
					default2.cancel()
				end

				data.setInProgress(false)
				v15(closeCentralOverlay())
			end,
			titleTextKey = v13 and "Authentication.Login.Label.SelectAnAccount" or "Authentication.Login.Label.AccountSelectorTitle"
		})
	end

	local function fn31(data)
		fn5()
		v11({
			type = module23.SetComponentState,
			data = {
				component = module22.LoginScreenV2,
				payload = { errorKey = data.errorKey }
			}
		})

		v11({ type = module23.ForceLoginByUsername })
	end

	local function fn32(data)
		if data.errorCode == loginErrorCodes.IncorrectCValueOrPassword then
			reportEphemeralCounter(appLoginCounterNames.FailureCredentials, 1)
		elseif data.errorCode == loginErrorCodes.AccountLocked then
			reportEphemeralCounter(appLoginCounterNames.FailurePasswordReset, 1)
		elseif data.errorCode == loginErrorCodes.CTypeNotSupported then
			reportEphemeralCounter(appLoginCounterNames.FailureBadRequest, 1)
		elseif data.errorCode == loginErrorCodes.CValueAndPasswordRequired then
			reportEphemeralCounter(appLoginCounterNames.FailureBadRequest, 1)
		elseif data.errorCode == loginErrorCodes.SecurityQuestions then
			reportEphemeralCounter(appLoginCounterNames.FailureSecurityQuestions, 1)
		elseif data.errorCode == loginErrorCodes.MultipleUsersPerCredential then
			reportEphemeralCounter(appLoginCounterNames.FailureMultipleUsersPerCredential, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.TOO_MANY_REQUESTS then
			reportEphemeralCounter(appLoginCounterNames.FailureThrottled, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.REQUEST_TIMEOUT then
			reportEphemeralCounter(appLoginCounterNames.FailureTimeout, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.BAD_REQUEST then
			reportEphemeralCounter(appLoginCounterNames.FailureBadRequest, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.NOT_FOUND then
			reportEphemeralCounter(appLoginCounterNames.FailureNotFound, 1)
		elseif
			data.HttpError == Enum.HttpError.OK
			and data.StatusCode == statusCodes.INTERNAL_SERVER_ERROR
		then
			reportEphemeralCounter(appLoginCounterNames.FailureInternalServerError, 1)
		else
			reportEphemeralCounter(appLoginCounterNames.FailureUnknownError, 1)
		end
	end

	fn20 = function(data)
		local function handleLoginError(data2, value, p2, p3)
			local v20 = data2.errorCode == loginErrorCodes.MultipleUsersPerCredential
			local v21 = data2.errorCode == loginErrorCodes.SecurityQuestions
			local v22 = (v20 or v21) and true or false
			reportEphemeralCounter(appLoginCounterNames.Failure, 1)

			fn32(data2)

			authClientError(data.eventContext, data2.errorCode, nil, data.eventOrigin)

			local function fn33()
				if fFlagEnableTimeToLoginMetrics then
					default2.cancel()
				end

				data.setInProgress(v22)
				v15(closeCentralOverlay())
			end

			local function fn34()
				if fFlagEnableTimeToLoginMetrics then
					default2.cancel()
				end

				data.setInProgress(v22)
			end

			local function fn35()
				local accountBlob = appStorageUtilities.getAccountBlob()
				local v23 = user.fromLocalStorage().userId ~= -1
				data.setInProgress(true)
				logoutAllLoggedInUsers(v16, accountBlob):await()

				local v24 = false

				if p3 then
					local success, result = pcall(function()
						return fn7(v16, value, p2):expect()
					end)

					if success and result and not loginResult.hasTwoStepData(result) then
						if fFlagEnableLuaAccountSwitch then
							fn12(result.accountBlob)
						else
							v15(launchApp(v16, nil, v17, v19, launchContext.Login))
						end

						return
					end
				else
					v24 = type(value) ~= "string" or false
				end

				if v23 == true then
					v15(resetAppState())
					module3.resolve()

					AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, "")
					AppStorageService:Flush()

					local v25 = if v24 then accountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV2AfterLogoutAll else accountSwitcherConstants.AccountSwitcherPendingLoginV2AfterLogoutAll
					appStorageUtilities.setAccountSwitchStatus(v25)
					appStorageUtilities.flush()

					if fFlagAddReasonToEveryLogout then
						v15(logout(
							v16,
							GuiService,
							logoutReasonNames.LoginContextAccountSwitchingErrorOverlay
						))
					else
						v15(logout(v16, GuiService, nil))
					end
				end

				data.setInProgress(false)
				v15(closeCentralOverlay())
			end

			if
				fFlagEnableAccountIneligibleLoginModal
				and data2.errorCode == loginErrorCodes.PioneerAccountIneligible
			then
				data.setErrorKey("")
				data.setInProgress(false)
				v15(openAccountIneligibleLoginModal(function()
					props.parentNavigation.goBack()
				end, v13))
			else
				local v23 = fFlagUseGenericAccountSwitchSignOutCopy and not p3

				if
					fFlagEnableLuaAccountSwitch
					and data2.errorCode == loginErrorCodes.EmptyAccountSwitchBlobRequired
				then
					data.setErrorKey("")
					local v24 = if p3 then value else ref.current
					appStorageUtilities.setAccountSwitchTargetUsername(v24)

					local accountSwitcherLoginEmptyBlobRequiredError = accountSwitcherConstants.AccountSwitcherLoginEmptyBlobRequiredError

					if not fFlagFixLoginV2AccountSwitchOverlaySoftLock then
						fn34 = nil
					end

					v15(openAccountSwitchingErrorOverlay(
						"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
						v23 and "Authentication.AccountSwitch.Description.ContinueSignOutOthersGeneric" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers",
						"Authentication.AccountSwitch.Action.Continue",
						"Authentication.CrossDevice.Action.CancelLogin",
						fn35,
						fn33,
						accountSwitcherLoginEmptyBlobRequiredError,
						v24 or nil,
						nil,
						v13,
						fn34
					))
				elseif
					fFlagEnableLuaAccountSwitch
					and data2.errorCode == loginErrorCodes.ParentEmptyAccountSwitchBlobRequired
				then
					data.setErrorKey("")
					local v24 = if p3 then value else ref.current
					appStorageUtilities.setAccountSwitchTargetUsername(v24)

					local accountSwitcherParentLoginEmptyBlobRequiredError = accountSwitcherConstants.AccountSwitcherParentLoginEmptyBlobRequiredError

					if not fFlagFixLoginV2AccountSwitchOverlaySoftLock then
						fn34 = nil
					end

					v15(openAccountSwitchingErrorOverlay(
						"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
						v23 and "Authentication.AccountSwitch.Description.ContinueSignOutOthersGeneric" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers",
						"Authentication.AccountSwitch.Action.Continue",
						"Authentication.CrossDevice.Action.CancelLogin",
						fn35,
						fn33,
						accountSwitcherParentLoginEmptyBlobRequiredError,
						v24 or nil,
						nil,
						v13,
						fn34
					))
				elseif data2.errorCode == loginErrorCodes.MoreThanOneUsername then
					fn31(data2)
					data.navigation.navigate(module22.LoginScreenV2)
				else
					if data2.errorCode == loginErrorCodes.AccountLocked then
						v15(openCentralOverlayForLoginPasswordResetPrompt())
					end

					if data2.errorCode == loginErrorCodes.GlobalAppAccessDeniedVNG then
						fn29()
					end

					if v21 and data2.securityQuestionsData and data2.securityQuestionsCallback then
						spawn(function()
							fn18(
								value,
								p2,
								data2.securityQuestionsData,
								data2.securityQuestionsCallback,
								data
							)
						end)
						return
					end

					if v20 and data2.usersData and value and p2 then
						fn30(data2.usersData, value, p2, data)
						return
					end

					data.setErrorKey(data2.errorKey or "Authentication.Login.Response.SomethingWentWrong")
					data.setInProgress(v22)
				end
			end
		end

		return handleLoginError
	end

	return module2.createElement(module18.Provider, {
		value = {
			state = v10,
			dispatch = v11,
			parentNavigation = props.parentNavigation,
			showLoginModalization = v13,
			isDialogLayoutForced = v13 and forceDialogLayout,
			isPageVisible = not fFlagEnableLoginV2Modalization or props.isVisible ~= false,
			eventOrigin = v14,
			utils = {
				handleLoginCompletionWithAccountSwitching = fn12,
				handleLoginResult = fn19,
				showPasskeyLoginPopup = fn24,
				showGenericCredentialLoginPopup = fn25,
				handleLoginWithCode = handleLoginWithCode,
				handleLoginWithFormData = handleLoginWithFormData,
				handleLoginWithPasskey = fn21,
				handleLoginWithOtp = handleLoginWithOtp,
				handleSendEmailOtp = fn22,
				handleResendEmailOtp = fn23,
				openAccountSwitchingErrorOverlay = fn26,
				openPasswordResetPrompt = fn27,
				openWebView = fn10,
				openAccountRecovery = fn11,
				logoutAllLoggedInUsers = fn28,
				logoutWithoutShowConfirmation = function(p2, p3, p4)
					return v15(logout(p2, p3, p4))
				end,
				openNewAppAvailableModal = fn29,
				closeCentralOverlay = fn6,
				clearApp = fn4,
				openAccountSelector = fn30,
				handleCredentialsCollision = fn31,
				registerPassword = fn15,
				isUserAuthenticated = fn9,
				getExternalIdentityCapabilities = fn13,
				authenticateWithExternalIdentity = fn14
			}
		}
	}, props.children)
end
