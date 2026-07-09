local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local ContentProvider = game:GetService("ContentProvider")
local Enums = require(LoginV2.Enums)

require(LoginV2.Components.Types)

local UserIdentifierType = Enums.UserIdentifierType
local React = require(LoginV2Parent.React)
local Promise = require(LoginV2Parent.Promise)
local AuthCommon = require(LoginV2Parent.AuthCommon)
local BackDisableStore = require(LoginV2Parent.BackDisableStore)
local OtpLogin = require(LoginV2Parent.OtpLogin)

require(LoginV2Parent.LuauPolyfill)

local useDispatch = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(LoginV2Parent.RobloxAppHooks).useRoactService
local useAppPolicy = require(LoginV2Parent.UniversalAppPolicy).useAppPolicy
local LaunchContext = require(LoginV2Parent.AppStartup).Enums.LaunchContext
local CloseCentralOverlay = require(LoginV2Parent.CentralOverlay).Thunks.CloseCentralOverlay
local SetCentralOverlay = require(LoginV2Parent.CentralOverlay).Actions.SetCentralOverlay
local NotificationType = require(LoginV2Parent.RobloxAppEnums).NotificationType
local CentralOverlayType = require(LoginV2Parent.RobloxAppEnums).CentralOverlayType
local AppPage = require(LoginV2Parent.RobloxAppEnums).AppPage
local OpenAccountSwitchingErrorOverlay = require(LoginV2Parent.AccountSwitcher).OpenAccountSwitchingErrorOverlay
local RenderChallenge = require(LoginV2Parent.GenericChallenges).Middleware.RenderChallenge
local ChallengeType = require(LoginV2Parent.GenericChallenges).Types.ChallengeType
local TwoStepVerificationActionType = require(LoginV2Parent.GenericChallenges).Types.TwoStepVerificationActionType
local NavigateDown = require(LoginV2Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(LoginV2Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v31 = if not FFlagSignalsNavP3Dispatch then nil else require(LoginV2Parent.RobloxAppNavigation).NavigationCommands
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local StatusCodes = require(LoginV2Parent.Http).StatusCodes
local EventStreamConstants = require(LoginV2Parent.AuthAnalytics).EventStreamConstants
local RoactAppExperiment = require(LoginV2Parent.RoactAppExperiment)
local AppBtidLayers = require(LoginV2Parent.ExperimentLayers).AppBtidLayers
local RoactServiceTags = require(LoginV2Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppLinking = RoactServiceTags.AppLinking
local CredentialsProtocol = require(LoginV2Parent.CredentialsProtocol)
local Constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default
local CredentialsProtocolErrorCodes = CredentialsProtocol.CredentialsProtocolErrorCodes
local SharedFlags = require(LoginV2Parent.SharedFlags)
local GetFFlagEnableLoginAccountSelector = SharedFlags.GetFFlagEnableLoginAccountSelector
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local FFlagLuaEnableDidSwitchAccount = SharedFlags.FFlagLuaEnableDidSwitchAccount
local GetFStringVNGDownloadNowUrl = SharedFlags.GetFStringVNGDownloadNowUrl
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local FFlagAddReasonToEveryLogout = SharedFlags.FFlagAddReasonToEveryLogout
local FFlagEnablePasskeyLoginErrorLogging = SharedFlags.FFlagEnablePasskeyLoginErrorLogging
local FFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local FFlagEnableLoginV2ForcedUsernameOverride = SharedFlags.FFlagEnableLoginV2ForcedUsernameOverride
local FFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local GetFFlagBypassKeystoreLoginIxpV2 = SharedFlags.GetFFlagBypassKeystoreLoginIxpV2
local GetFFlagRemoveKeystoreIxpLogic = SharedFlags.GetFFlagRemoveKeystoreIxpLogic
local GetFFlagEnableAccountSwitcherFoundationDesign = SharedFlags.GetFFlagEnableAccountSwitcherFoundationDesign
local GetFFlagEnableAccountSwitcherRedesignIXP = SharedFlags.GetFFlagEnableAccountSwitcherRedesignIXP
local GetFFlagEnableLoginDisambiguationFoundationSwitcher = SharedFlags.GetFFlagEnableLoginDisambiguationFoundationSwitcher
local FFlagEnableNavigateToLoginAfterLogoutAll = SharedFlags.FFlagEnableNavigateToLoginAfterLogoutAll
local FFlagEnable2SVRecovery = SharedFlags.FFlagEnable2SVRecovery
local FFlagUseBackDisableSignalStore = SharedFlags.FFlagUseBackDisableSignalStore
local FFlagRemoveUnusedLoginResultRoduxSlice = SharedFlags.FFlagRemoveUnusedLoginResultRoduxSlice
local v66 = game:DefineFastFlag("LoginV2AwaitPasswordRegistration", false)
local v67 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOn2SVLoginV2", false)
local LoginContext = require(LoginV2.Context.LoginContext)
local LoginStateReducer = require(LoginV2.Reducers.LoginStateReducer)
local StartAuthenticationByUser = require(LoginV2.Thunks.StartAuthenticationByUser)
local StartPasskeyAuthentication = require(LoginV2.Thunks.StartPasskeyAuthentication)
local LoginPageState = require(LoginV2.Enums.LoginPageState)
local LoginActionType = require(LoginV2.Enums.LoginActionType)
local Base64 = AuthCommon.Utils.Base64
local AccountSwitcherConstants = AuthCommon.Common.AccountSwitcherConstants
local LoginResult = AuthCommon.Models.LoginResult
local SetLoginResult = AuthCommon.Actions.SetLoginResult
local SetBackNavigationDisabled = AuthCommon.Actions.SetBackNavigationDisabled
local authClientError = AuthAnalytics.Events.authClientError
local authButtonClick = AuthAnalytics.Events.authButtonClick
local reportEphemeralCounter = AuthCommon.Analytics.reportEphemeralCounter
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local LoginByPasskey = AuthCommon.Thunks.LoginByPasskey
local LoginByCode = AuthCommon.Thunks.LoginByCode
local LoginByOtp = AuthCommon.Thunks.LoginByOtp
local Login = AuthCommon.Thunks.Login
local User = AuthCommon.Thunks.User
local AppLoginCounterNames = AuthCommon.Enums.AppLoginCounterNames
local LoginErrorCodes = AuthCommon.Enums.LoginErrorCodes
local getTwoStepLoginErrorKey = AuthCommon.Utils.getTwoStepLoginErrorKey
local OpenCentralOverlayForLoginPasswordResetPrompt = AuthCommon.Thunks.OpenCentralOverlayForLoginPasswordResetPrompt
local LogoutAllLoggedInUsers = AuthCommon.Thunks.LogoutAllLoggedInUsers
local AuthLocalStorageKeys = AuthCommon.Enums.AuthLocalStorageKeys
local OpenAccountSelector = AuthCommon.Thunks.OpenAccountSelector
local AuthMemStorageKeys = AuthCommon.Enums.AuthMemStorageKeys
local TwoStepRequests = AuthCommon.Http.Requests.TwoStepRequests
local LogoutReasonNames = AuthCommon.Enums.LogoutReasonNames
local PasskeyConstants = AuthCommon.Common.PasskeyConstants
local record2svCompletion = AuthCommon.Utils.record2svCompletion
local recordLogin = AuthCommon.Utils.recordLogin
local TwoStepErrorCodes = AuthCommon.Enums.TwoStepErrorCodes
local GetUserByUsername = AuthCommon.Thunks.GetUserByUsername
local KeystoreConstants = AuthCommon.Common.KeystoreConstants
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local FFlagEnableRecordLogin = require(LoginV2Parent.SharedFlags).FFlagEnableRecordLogin
local LoginMethods = AuthCommon.Enums.LoginMethods
local GetPasswordManagerUsageStore = AuthCommon.Stores.GetPasswordManagerUsageStore
local SendCode = OtpLogin.Thunks.SendCode
local ResendCode = OtpLogin.Thunks.ResendCode
local Constants2 = OtpLogin.Constants
local Logger = require(LoginV2Parent.Loggers).Logger
local default2 = require(LoginV2Parent.LoggingProtocol).default
local TelemetryConfigs = require(LoginV2Parent.AuthAnalytics).TelemetryConfigs
local KeystoreSaveCredentialsTelemetryConfig = TelemetryConfigs.KeystoreSaveCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local useNavigationProps = require(LoginV2Parent.RobloxAppNavigation).useNavigationProps

return function(t1: {[any]: any}) -- line: 166
	-- upvalues: useNavigationProps (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), UserIdentifierType (copy), React (copy), LoginStateReducer (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), RoactAppExperiment (copy), AppBtidLayers (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), AppLinking (copy), useAppPolicy (copy), StartPasskeyAuthentication (copy), StartAuthenticationByUser (copy), SetLoginResult (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy), LaunchContext (copy), Promise (copy), LoginActionType (copy), LoginPageState (copy), GetPasswordManagerUsageStore (copy), FFlagEnablePWManagerSignupCheck (copy), LoginByPasskey (copy), LoginByCode (copy), LoginByOtp (copy), CloseCentralOverlay (copy), Login (copy), GetFFlagEnableLoginDisambiguationFoundationSwitcher (copy), OpenAccountSelector (copy), User (copy), RenderChallenge (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), NavigateDown (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), AppStorageUtilities (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), default2 (copy), TelemetryConfigs (copy), HttpService (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), AuthMemStorageKeys (copy), default (copy), Constants (copy), Logger (copy), authButtonClick (copy), EventStreamConstants (copy), getTwoStepLoginErrorKey (copy), TwoStepErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), ChallengeType (copy), TwoStepVerificationActionType (copy), FFlagEnable2SVRecovery (copy), TwoStepRequests (copy), v66 (copy), FFlagEnableRecordLogin (copy), record2svCompletion (copy), FFlagEnableLuaAccountSwitch (copy), v67 (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), ContentProvider (copy), GetUserByUsername (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), GetFFlagEnableLoginAccountSelector (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), recordLogin (copy), LoginMethods (copy), Constants2 (copy), SendCode (copy), ResendCode (copy), UserInputService (copy), Base64 (copy), CredentialsProtocolErrorCodes (copy), authClientError (copy), PasskeyConstants (copy), FFlagEnablePasskeyLoginErrorLogging (copy), OpenAccountSwitchingErrorOverlay (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy), LogoutAllLoggedInUsers (copy), SetCentralOverlay (copy), CentralOverlayType (copy), GetFStringVNGDownloadNowUrl (copy), LoginErrorCodes (copy), StatusCodes (copy), FFlagAddReasonToEveryLogout (copy), LogoutReasonNames (copy), LoginContext (copy)
	local v120 = useNavigationProps(function(_: string, p1) -- line: 167
		-- upvalues: FFlagEnableLoginV2ForcedUsernameOverride (copy)
		return {
			credProtocolIsAvailableResponse = p1.credProtocolIsAvailableResponse,
			forcedUsernameOverride = if not FFlagEnableLoginV2ForcedUsernameOverride then nil else p1.forcedUsernameOverride
		}
	end)
	local t2 = {
		userIdentifier = "",
		numLoginAttempts = 0,
		forceLoginByUsername = false,
		shouldAutoShowCredentialPopup = true,
		userIdentifierType = UserIdentifierType.Unknown,
		availableLoginMethods = {},
		credentialsProtocolStatus = {
			fido2Supported = false,
			passwordsSupported = false,
			v2InterfaceSupported = false,
			shouldShowAuthScreenCredentialsPopup = false,
			shouldShowAuthScreenUserSpecificPasskeyPopup = false,
			initialStateUpdated = false
		},
		componentState = {
			LoginScreenV2 = {
				errorKey = "",
				userIdentifier = "",
				shouldAttemptCredentialPrefill = true
			},
			AuthenticationScreen = {
				errorKey = "",
				errorType = nil,
				password = ""
			},
			EmailOtpScreen = {
				errorKey = "",
				emailOtp = "",
				sessionToken = ""
			}
		},
		monoDeps = t1.monoDeps,
		extraProps = v120
	}
	local v122, v123 = React.useReducer(LoginStateReducer, t2)
	local u124 = nil

	if FFlagEnableNavigateToLoginAfterLogoutAll then
		u124 = React.useRef(v122.userIdentifier)
		u124.current = v122.userIdentifier
	end

	local v125 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.LoginLayer }, function(p2) -- line: 222
		-- upvalues: AppBtidLayers (copy)
		local v159 = p2[AppBtidLayers.LoginLayer] or {}

		return {
			shouldLoginWithKeystoreCredentials = v159.shouldLoginWithKeystoreCredentials or false,
			showFoundationDisambiguationSelector = v159.showFoundationDisambiguationSelector or false
		}
	end)
	local v126 = not GetFFlagEnableAccountSwitcherRedesignIXP() or RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AccountSwitcherLayer }, function(p3) -- line: 234
		-- upvalues: AppBtidLayers (copy)
		return (p3[AppBtidLayers.AccountSwitcherLayer] or {}).enableAccountSwitcherFoundationDesign == true
	end)
	local v127 = GetFFlagEnableAccountSwitcherFoundationDesign() and v126
	local v128 = useDispatch()
	local v129 = useRoactService(RoactNetworking)
	local v130 = useRoactService(RoactAnalytics)
	local v131 = useRoactService(AppLinking)
	local v132 = useAppPolicy(function(p4) -- line: 246
		return p4
	end)
	local LaunchApp = v122.monoDeps.LaunchApp
	local ResetAppState = v122.monoDeps.ResetAppState
	local Logout = v122.monoDeps.Logout

	local function v136() -- line: 255
		-- upvalues: v128 (copy), StartPasskeyAuthentication (copy), v129 (copy)
		return v128(StartPasskeyAuthentication(v129))
	end
	local function v137(p5) -- line: 259
		-- upvalues: v128 (copy), StartAuthenticationByUser (copy), v129 (copy)
		return v128(StartAuthenticationByUser(v129, p5))
	end
	local function v138() -- line: 282
		-- upvalues: v123 (copy), LoginActionType (copy), LoginPageState (copy), UserIdentifierType (copy)
		v123({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.AuthenticationScreen,
				payload = {
					errorKey = "",
					errorType = nil,
					password = ""
				}
			}
		})
		v123({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.LoginScreenV2,
				payload = {
					errorKey = "",
					userIdentifier = ""
				}
			}
		})
		v123({
			type = LoginActionType.SetUserIdentifierAndType,
			data = {
				userIdentifier = "",
				userIdentifierType = UserIdentifierType.Unknown
			}
		})
	end

	local v139 = GetPasswordManagerUsageStore(false)

	if FFlagEnablePWManagerSignupCheck and v139 then
		v139.resetAll()
	elseif v139 then
		v139.setLoggedinUsingSavedPassword(false)
		v139.setSavedPasswordAfterLogin(false)
	end

	local function v140(...) -- line: 369
		-- upvalues: v128 (copy), Login (copy)
		return v128(Login(...))
	end
	local function v141(p6) -- line: 373
		-- upvalues: GetFFlagEnableLoginDisambiguationFoundationSwitcher (copy), v125 (copy), v128 (copy), OpenAccountSelector (copy)
		if GetFFlagEnableLoginDisambiguationFoundationSwitcher() and v125.showFoundationDisambiguationSelector then
			local v179 = table.clone(p6)

			v179.hideActions = true
			v179.showFoundationDisambiguationSelector = true

			return v128(OpenAccountSelector(v179, true, true))
		end

		return v128(OpenAccountSelector(p6, true, false))
	end
	local function v142(p7) -- line: 425
		-- upvalues: User (copy), v128 (copy), ResetAppState (copy), Promise (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), AppStorageUtilities (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy)
		if User.fromLocalStorage().userId ~= -1 then
			v128(ResetAppState())
			Promise.resolve():andThen(function(_) -- line: 427
				-- upvalues: FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AccountSwitcherConstants (copy), AppStorageUtilities (copy), p7 (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy)
				local v282 = if not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then AccountSwitcherConstants.AccountSwitcherSwitchedStatus else AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus

				AppStorageUtilities.setAccountSwitchStatus(v282)
				AppStorageUtilities.setAccountBlob(p7)
				AppStorageUtilities.flush()

				if FFlagLuaEnableDidSwitchAccount then
					GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)

					return
				end

				GuiService:BroadcastNotification("", NotificationType.DID_LOG_OUT)
			end, function(_) -- line: 439
				-- upvalues: AppStorageUtilities (copy), p7 (copy), v128 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy)
				AppStorageUtilities.setAccountSwitchStatus("switched")
				AppStorageUtilities.setAccountBlob(p7)
				AppStorageUtilities.flush()
				v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
			end)

			return
		end

		AppStorageUtilities.setAccountBlob(p7)
		AppStorageUtilities.flush()
		v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
	end
	local function v143(s2: string?) -- line: 452
		-- upvalues: default2 (copy), TelemetryConfigs (copy), HttpService (copy), v122 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), AuthMemStorageKeys (copy), default (copy), Constants (copy), v139 (copy), Logger (copy), authButtonClick (copy), EventStreamConstants (copy)
		if s2 == nil then
			default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig, 1, {
				reason = "missingCredentialsJson"
			})

			return nil
		end

		local data = HttpService:JSONDecode(s2)

		if data.cvalue == nil or data.password == nil then
			default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig, 1, {
				reason = "missingUsernameOrPassword"
			})

			return nil
		end

		if not v122.credentialsProtocolStatus.passwordsSupported then
			if not FFlagDisableMemStorageServicePasswordEvent then
				MemStorageService:Fire(AuthMemStorageKeys.AuthenticatedCredentials, s2)
			end

			default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveSkippedConfig, 1, {
				reason = "passwordsNotSupported"
			})

			return nil
		end

		local t3 = {
			username = data.cvalue,
			password = data.password
		}
		local json = HttpService:JSONEncode(t3)

		default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveAttemptedConfig, 1)

		return default:registerCredentials(default.CredentialsTypes.password, json, Constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p10) -- line: 500
			-- upvalues: HttpService (copy), v139 (copy), Logger (copy), authButtonClick (copy), EventStreamConstants (copy), default2 (copy), TelemetryConfigs (copy)
			if p10 then
				local data2 = HttpService:JSONDecode(p10)

				if data2.errorCode == nil then
					if v139 then
						v139.setSavedPasswordAfterLogin(true)
					end

					Logger:info("Successfully registered password.")
					authButtonClick(EventStreamConstants.Context.CMPasswordLogin, EventStreamConstants.Button.SavePassword)
					default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveSuccessConfig, 1)

					return
				end

				Logger:warning("Error registering password: {}", data2.errorMsg)
				default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveFailureConfig, 1, {
					errorCode = tostring(data2.errorCode)
				})
			end
		end, function(p11) -- line: 526
			-- upvalues: Logger (copy), default2 (copy), TelemetryConfigs (copy)
			Logger:warning("Error registering password: {}", p11)
			default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginPasswordSaveFailureConfig, 1, {
				error = tostring(p11)
			})
		end)
	end
	local function v144(n1: number?, t4: {[any]: any}) -- line: 536
		-- upvalues: getTwoStepLoginErrorKey (copy), TwoStepErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy)
		local v192 = getTwoStepLoginErrorKey(n1)

		if n1 and n1 == TwoStepErrorCodes.IllegalChildAccountLinking then
			reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
		else
			reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
		end

		t4.setInProgress(false)
		t4.setErrorKey(v192)
	end
	local function v145(p12, p13, t5: {[any]: any}) -- line: 549
		-- upvalues: ChallengeType (copy), TwoStepVerificationActionType (copy), FFlagEnable2SVRecovery (copy), TwoStepRequests (copy), v129 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v66 (copy), v143 (copy), FFlagEnableRecordLogin (copy), record2svCompletion (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), v67 (copy), HttpService (copy), v144 (copy), RenderChallenge (copy)
		local ticket = p12.twoStepVerificationData.ticket
		local id = p12.user.id
		local t6 = {
			title = "Authentication.Login.Label.TwoStepVerification",
			challengeType = ChallengeType.TwoStepVerification,
			challengeParameters = {
				allowRememberDevice = true,
				actionType = TwoStepVerificationActionType.Login,
				challengeId = ticket,
				userId = id,
				clientSupports2svRecovery = not not FFlagEnable2SVRecovery
			},
			callbacks = {
				OnChallengeCompleted = function(p14) -- line: 564
					-- upvalues: TwoStepRequests (copy), v129 (copy), id (copy), ticket (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v66 (copy), v143 (copy), p13 (copy), FFlagEnableRecordLogin (copy), record2svCompletion (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), v67 (copy), HttpService (copy), v144 (copy), t5 (copy)
					TwoStepRequests.login(v129, id, ticket, p14.data.verificationToken, p14.data.rememberDevice):andThen(function(p15) -- line: 572
						-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v66 (copy), v143 (copy), p13 (copy), FFlagEnableRecordLogin (copy), record2svCompletion (copy), id (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy)
						if FFlagUseBackDisableSignalStore then
							BackDisableStore.setDisabled(false)
						else
							v128(SetBackNavigationDisabled(false))
						end

						reportEphemeralCounter(AppLoginCounterNames.Success, 1)

						if v66 then
							local v379 = v143(p13)

							if v379 then
								v379:await()
							end
						end

						if FFlagEnableRecordLogin then
							pcall(function() -- line: 584
								-- upvalues: record2svCompletion (copy), id (copy)
								record2svCompletion(id)
							end)
						end

						if FFlagEnableLuaAccountSwitch then
							v142(p15.responseBody and p15.responseBody.accountBlob)

							return
						end

						v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
					end, function(p16) -- line: 596
						-- upvalues: reportEphemeralCounter (copy), AppLoginCounterNames (copy), v67 (copy), HttpService (copy), v144 (copy), t5 (copy)
						reportEphemeralCounter(AppLoginCounterNames.Failure, 1)

						if v67 then
							local ok, result = pcall(function() -- line: 600
								-- upvalues: HttpService (copy), p16 (copy)
								return HttpService:JSONDecode(p16.Body).errors[1].code
							end)

							v144(if not ok then nil else result, t5)

							return
						end

						reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
						t5.setInProgress(false)
						t5.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
					end):finally(function() -- line: 611
						-- upvalues: v66 (copy), v143 (copy), p13 (copy)
						if not v66 then
							v143(p13)
						end
					end)
				end,
				OnChallengeAbandoned = function() -- line: 617
					-- upvalues: t5 (copy)
					t5.setInProgress(false)
				end,
				OnChallengeInvalidated = function() -- line: 620
					-- upvalues: t5 (copy)
					t5.setInProgress(false)
					t5.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end,
				OnChallengeLoadFailed = function() -- line: 624
					-- upvalues: t5 (copy)
					t5.setInProgress(false)
					t5.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end
			}
		}

		RenderChallenge(t6)
	end
	local function v146(_, _, p19, p20, t7: {[any]: any}) -- line: 632
		-- upvalues: ChallengeType (copy), RenderChallenge (copy)
		local t9 = {
			challengeType = ChallengeType.SecurityQuestions,
			challengeParameters = {
				sessionId = p19.sessionId,
				userId = p19.userId
			},
			callbacks = {
				OnChallengeCompleted = function(p21) -- line: 646
					-- upvalues: p19 (copy), p20 (copy)
					local t8 = {
						sessionId = p19.sessionId,
						redemptionToken = p21.data.redemptionToken
					}

					p20(t8)
				end,
				OnChallengeAbandoned = function() -- line: 653
					-- upvalues: t7 (copy)
					t7.setInProgress(false)
				end,
				OnChallengeInvalidated = function() -- line: 656
					-- upvalues: t7 (copy)
					t7.setInProgress(false)
					t7.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end,
				OnChallengeLoadFailed = function() -- line: 660
					-- upvalues: t7 (copy)
					t7.setInProgress(false)
					t7.setErrorKey("Authentication.Login.Response.SomethingWentWrong")
				end
			}
		}

		RenderChallenge(t9)
	end

	local u147 = nil

	local function handleLoginWithFormData(p22, p23, p24, p25, p26, p27, t10: {[any]: any}) -- line: 834
		-- upvalues: u147 (ref), v122 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), handleLoginWithFormData (copy), v140 (copy), v129 (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), v139 (copy), HttpService (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), ContentProvider (copy), GetUserByUsername (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy)
		local v216 = u147(t10)
		local v217 = p22 or v122.userIdentifier

		if FFlagUseBackDisableSignalStore then
			BackDisableStore.setDisabled(true)
		else
			v128(SetBackNavigationDisabled(true))
		end

		return v140(v129, v217, p23, function(p28, p29) -- line: 849
			-- upvalues: handleLoginWithFormData (copy), p22 (copy), p23 (copy), p25 (copy), p26 (copy), p27 (copy), t10 (copy)
			if p28 then
				handleLoginWithFormData(p22, p23, p29, p25, p26, p27, t10)
			end
		end, p24, function(p30) -- line: 863
			-- upvalues: handleLoginWithFormData (copy), p22 (copy), p23 (copy), p24 (copy), p26 (copy), p27 (copy), t10 (copy)
			handleLoginWithFormData(p22, p23, p24, p30, p26, p27, t10)
		end, p25, p26, v122.forceLoginByUsername):andThen(function(p31) -- line: 885
			-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), v217 (copy), v139 (copy), p27 (copy), HttpService (copy), p23 (copy), t10 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
			AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, v217)
			AppStorageService:Flush()

			if v139 and p27 then
				v139.setLoggedinUsingSavedPassword(true)
			end

			local v306 = if p27 then nil else HttpService:JSONEncode({
				authType = "login",
				cvalue = v217,
				password = p23
			})
			local v307 = t10

			if FFlagUseBackDisableSignalStore then
				BackDisableStore.setDisabled(false)
			else
				v128(SetBackNavigationDisabled(false))
			end

			Promise.new(function(resolve, reject) -- line: 671
				-- upvalues: GetFFlagKeystoreAutoLoginAvailable (copy), v306 (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
				if GetFFlagKeystoreAutoLoginAvailable() == false or v306 == nil then
					resolve()

					return
				end

				local v397 = not not GetFFlagRemoveKeystoreIxpLogic() or (v125.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})
				local data = HttpService:JSONDecode(v306)

				GetUserByUsername(v129, data.cvalue)():andThen(function(p32) -- line: 693
					-- upvalues: reject (copy), default (copy), KeystoreConstants (copy), json (copy), Promise (copy)
					if not p32 or not p32.id then
						return reject("Invalid usernameInfo")
					end

					return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p33) -- line: 701
						-- upvalues: default (copy), json (copy), KeystoreConstants (copy), Promise (copy)
						if p33 and (p33.keystore and p33.keystore.isAvailable) then
							return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
						end

						return Promise.resolve(nil)
					end):andThen(function() -- line: 716
						-- upvalues: p32 (copy)
						return p32
					end)
				end):andThen(function(p34) -- line: 720
					-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), data (copy), v397 (copy), KeystoreConstants (copy), default (copy)
					local json2

					if GetFFlagRemoveKeystoreIxpLogic() then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p34.id)))

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
								customFields = {
									result = "attempt"
								}
							}, 1)
						end

						json2 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p34.id),
							password = tostring(data.password)
						})
					else
						local Experiment

						if v397 == true then
							Experiment = KeystoreConstants.Experiment
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p34.id)))
						else
							Experiment = KeystoreConstants.Control
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p34.id)))
						end

						json2 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p34.id),
							password = tostring(data.password),
							experimentGroup = tostring(Experiment)
						})
					end

					return default:registerCredentials(default.CredentialsTypes.keystore, json2, KeystoreConstants.KeystoreTimeout)
				end):andThen(function(_) -- line: 772
					-- upvalues: resolve (copy)
					resolve()
				end):catch(function(p36) -- line: 775
					-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
							customFields = {
								result = "error"
							}
						}, 1)
					end

					reject(p36)
				end)
			end):finally(function() -- line: 791
				-- upvalues: LoginResult (copy), p31 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), v128 (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v306 (copy), v307 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
				if LoginResult.hasTwoStepData(p31) then
					if not FFlagRemoveUnusedLoginResultRoduxSlice then
						local v400 = p31

						v128(SetLoginResult(v400))
					end

					reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
					spawn(function() -- line: 800
						-- upvalues: v145 (copy), p31 (copy), v306 (copy), v307 (copy)
						v145(p31, v306, v307)
					end)
				else
					reportEphemeralCounter(AppLoginCounterNames.Success, 1)

					if v306 then
						if v66 then
							local v401 = v143(v306)

							if v401 then
								v401:await()
							end
						else
							v143(v306)
						end
					end

					if FFlagEnableLuaAccountSwitch then
						v142(p31.accountBlob)
					else
						v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
					end
				end

				if GetFFlagEnableLoginAccountSelector() then
					v128(CloseCentralOverlay())
				end
			end)
		end, function(p37) -- line: 902
			-- upvalues: v216 (copy), v217 (copy), p23 (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy)
			v216(p37, v217, p23, not not FFlagEnableNavigateToLoginAfterLogoutAll or nil)
		end)
	end
	local function v149(p38, p39, t11: {[any]: any}) -- line: 907
		-- upvalues: u147 (ref), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), LoginByPasskey (copy), v129 (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
		local v221 = u147(t11)

		if FFlagUseBackDisableSignalStore then
			BackDisableStore.setDisabled(true)
		else
			v128(SetBackNavigationDisabled(true))
		end

		return v128(LoginByPasskey(v129, p38, p39)):andThen(function(p40) -- line: 912
			-- upvalues: t11 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
			local v310 = t11

			if FFlagUseBackDisableSignalStore then
				BackDisableStore.setDisabled(false)
			else
				v128(SetBackNavigationDisabled(false))
			end

			local v311 = nil
			local v312 = nil

			Promise.new(function(resolve, reject) -- line: 671
				-- upvalues: GetFFlagKeystoreAutoLoginAvailable (copy), v311 (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
				if GetFFlagKeystoreAutoLoginAvailable() == false or v311 == nil then
					resolve()

					return
				end

				local v404 = not not GetFFlagRemoveKeystoreIxpLogic() or (v125.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})
				local data = HttpService:JSONDecode(v311)

				GetUserByUsername(v129, data.cvalue)():andThen(function(p41) -- line: 693
					-- upvalues: reject (copy), default (copy), KeystoreConstants (copy), json (copy), Promise (copy)
					if not p41 or not p41.id then
						return reject("Invalid usernameInfo")
					end

					return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p42) -- line: 701
						-- upvalues: default (copy), json (copy), KeystoreConstants (copy), Promise (copy)
						if p42 and (p42.keystore and p42.keystore.isAvailable) then
							return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
						end

						return Promise.resolve(nil)
					end):andThen(function() -- line: 716
						-- upvalues: p41 (copy)
						return p41
					end)
				end):andThen(function(p43) -- line: 720
					-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), data (copy), v404 (copy), KeystoreConstants (copy), default (copy)
					local json3

					if GetFFlagRemoveKeystoreIxpLogic() then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p43.id)))

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
								customFields = {
									result = "attempt"
								}
							}, 1)
						end

						json3 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p43.id),
							password = tostring(data.password)
						})
					else
						local Experiment

						if v404 == true then
							Experiment = KeystoreConstants.Experiment
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p43.id)))
						else
							Experiment = KeystoreConstants.Control
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p43.id)))
						end

						json3 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p43.id),
							password = tostring(data.password),
							experimentGroup = tostring(Experiment)
						})
					end

					return default:registerCredentials(default.CredentialsTypes.keystore, json3, KeystoreConstants.KeystoreTimeout)
				end):andThen(function(_) -- line: 772
					-- upvalues: resolve (copy)
					resolve()
				end):catch(function(p45) -- line: 775
					-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
							customFields = {
								result = "error"
							}
						}, 1)
					end

					reject(p45)
				end)
			end):finally(function() -- line: 791
				-- upvalues: LoginResult (copy), p40 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), v128 (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v312 (copy), v310 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
				if LoginResult.hasTwoStepData(p40) then
					if not FFlagRemoveUnusedLoginResultRoduxSlice then
						local v407 = p40

						v128(SetLoginResult(v407))
					end

					reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
					spawn(function() -- line: 800
						-- upvalues: v145 (copy), p40 (copy), v312 (copy), v310 (copy)
						v145(p40, v312, v310)
					end)
				else
					reportEphemeralCounter(AppLoginCounterNames.Success, 1)

					if v312 then
						if v66 then
							local v408 = v143(v312)

							if v408 then
								v408:await()
							end
						else
							v143(v312)
						end
					end

					if FFlagEnableLuaAccountSwitch then
						v142(p40.accountBlob)
					else
						v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
					end
				end

				if GetFFlagEnableLoginAccountSelector() then
					v128(CloseCentralOverlay())
				end
			end)
		end, function(p46) -- line: 914
			-- upvalues: v221 (copy), p38 (copy)
			v221(p46, p38, nil)
		end)
	end
	local function handleLoginWithCode(p47, p48, p49, p50, t12: {[any]: any}) -- line: 919
		-- upvalues: u147 (ref), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), handleLoginWithCode (copy), LoginByCode (copy), v129 (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
		local v227 = u147(t12)

		if FFlagUseBackDisableSignalStore then
			BackDisableStore.setDisabled(true)
		else
			v128(SetBackNavigationDisabled(true))
		end

		return v128(LoginByCode(v129, p47, p48, function(p51, p52) -- line: 930
			-- upvalues: handleLoginWithCode (copy), p47 (copy), p48 (copy), t12 (copy)
			if p51 then
				handleLoginWithCode(p47, p48, p52, nil, t12)
			end
		end, p49, function(p53) -- line: 936
			-- upvalues: handleLoginWithCode (copy), p47 (copy), p48 (copy), t12 (copy)
			handleLoginWithCode(p47, p48, nil, p53, t12)
		end, p50)):andThen(function(p54) -- line: 947
			-- upvalues: t12 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
			local v318 = t12

			if FFlagUseBackDisableSignalStore then
				BackDisableStore.setDisabled(false)
			else
				v128(SetBackNavigationDisabled(false))
			end

			local v319 = nil
			local v320 = nil

			Promise.new(function(resolve, reject) -- line: 671
				-- upvalues: GetFFlagKeystoreAutoLoginAvailable (copy), v319 (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
				if GetFFlagKeystoreAutoLoginAvailable() == false or v319 == nil then
					resolve()

					return
				end

				local v411 = not not GetFFlagRemoveKeystoreIxpLogic() or (v125.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})
				local data = HttpService:JSONDecode(v319)

				GetUserByUsername(v129, data.cvalue)():andThen(function(p55) -- line: 693
					-- upvalues: reject (copy), default (copy), KeystoreConstants (copy), json (copy), Promise (copy)
					if not p55 or not p55.id then
						return reject("Invalid usernameInfo")
					end

					return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p56) -- line: 701
						-- upvalues: default (copy), json (copy), KeystoreConstants (copy), Promise (copy)
						if p56 and (p56.keystore and p56.keystore.isAvailable) then
							return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
						end

						return Promise.resolve(nil)
					end):andThen(function() -- line: 716
						-- upvalues: p55 (copy)
						return p55
					end)
				end):andThen(function(p57) -- line: 720
					-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), data (copy), v411 (copy), KeystoreConstants (copy), default (copy)
					local json4

					if GetFFlagRemoveKeystoreIxpLogic() then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p57.id)))

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
								customFields = {
									result = "attempt"
								}
							}, 1)
						end

						json4 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p57.id),
							password = tostring(data.password)
						})
					else
						local Experiment

						if v411 == true then
							Experiment = KeystoreConstants.Experiment
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p57.id)))
						else
							Experiment = KeystoreConstants.Control
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p57.id)))
						end

						json4 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p57.id),
							password = tostring(data.password),
							experimentGroup = tostring(Experiment)
						})
					end

					return default:registerCredentials(default.CredentialsTypes.keystore, json4, KeystoreConstants.KeystoreTimeout)
				end):andThen(function(_) -- line: 772
					-- upvalues: resolve (copy)
					resolve()
				end):catch(function(p59) -- line: 775
					-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
							customFields = {
								result = "error"
							}
						}, 1)
					end

					reject(p59)
				end)
			end):finally(function() -- line: 791
				-- upvalues: LoginResult (copy), p54 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), v128 (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v320 (copy), v318 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
				if LoginResult.hasTwoStepData(p54) then
					if not FFlagRemoveUnusedLoginResultRoduxSlice then
						local v414 = p54

						v128(SetLoginResult(v414))
					end

					reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
					spawn(function() -- line: 800
						-- upvalues: v145 (copy), p54 (copy), v320 (copy), v318 (copy)
						v145(p54, v320, v318)
					end)
				else
					reportEphemeralCounter(AppLoginCounterNames.Success, 1)

					if v320 then
						if v66 then
							local v415 = v143(v320)

							if v415 then
								v415:await()
							end
						else
							v143(v320)
						end
					end

					if FFlagEnableLuaAccountSwitch then
						v142(p54.accountBlob)
					else
						v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
					end
				end

				if GetFFlagEnableLoginAccountSelector() then
					v128(CloseCentralOverlay())
				end
			end)
		end, function(p60) -- line: 949
			-- upvalues: reportEphemeralCounter (copy), AppLoginCounterNames (copy), v227 (copy), p47 (copy), p48 (copy)
			reportEphemeralCounter(AppLoginCounterNames.FailureAuthCode, 1)
			v227(p60, p47, p48)
		end)
	end
	local function handleLoginWithOtp(s3: string, s4: string, p61, p62, t13: {[any]: any}) -- line: 955
		-- upvalues: u147 (ref), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), handleLoginWithOtp (copy), LoginByOtp (copy), v129 (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), v122 (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), LoginMethods (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
		local v233 = u147(t13)

		if FFlagUseBackDisableSignalStore then
			BackDisableStore.setDisabled(true)
		else
			v128(SetBackNavigationDisabled(true))
		end

		return v128(LoginByOtp(v129, s3, s4, function(p63) -- line: 966
			-- upvalues: handleLoginWithOtp (copy), s3 (copy), s4 (copy), p62 (copy), t13 (copy)
			handleLoginWithOtp(s3, s4, p63, p62, t13)
		end, p61, p62)):andThen(function(p64) -- line: 971
			-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), v122 (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), LoginMethods (copy), t13 (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
			AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, v122.userIdentifier)

			if FFlagEnableRecordLogin then
				pcall(function() -- line: 974
					-- upvalues: recordLogin (copy), p64 (copy), LoginMethods (copy), v122 (copy)
					recordLogin(p64, LoginMethods.EmailOtp, v122.userIdentifier)
				end)
			end

			local v324 = t13

			if FFlagUseBackDisableSignalStore then
				BackDisableStore.setDisabled(false)
			else
				v128(SetBackNavigationDisabled(false))
			end

			local v325 = nil
			local v326 = nil

			Promise.new(function(resolve, reject) -- line: 671
				-- upvalues: GetFFlagKeystoreAutoLoginAvailable (copy), v325 (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
				if GetFFlagKeystoreAutoLoginAvailable() == false or v325 == nil then
					resolve()

					return
				end

				local v418 = not not GetFFlagRemoveKeystoreIxpLogic() or (v125.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})
				local data = HttpService:JSONDecode(v325)

				GetUserByUsername(v129, data.cvalue)():andThen(function(p65) -- line: 693
					-- upvalues: reject (copy), default (copy), KeystoreConstants (copy), json (copy), Promise (copy)
					if not p65 or not p65.id then
						return reject("Invalid usernameInfo")
					end

					return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p66) -- line: 701
						-- upvalues: default (copy), json (copy), KeystoreConstants (copy), Promise (copy)
						if p66 and (p66.keystore and p66.keystore.isAvailable) then
							return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
						end

						return Promise.resolve(nil)
					end):andThen(function() -- line: 716
						-- upvalues: p65 (copy)
						return p65
					end)
				end):andThen(function(p67) -- line: 720
					-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), data (copy), v418 (copy), KeystoreConstants (copy), default (copy)
					local json5

					if GetFFlagRemoveKeystoreIxpLogic() then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p67.id)))

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
								customFields = {
									result = "attempt"
								}
							}, 1)
						end

						json5 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p67.id),
							password = tostring(data.password)
						})
					else
						local Experiment

						if v418 == true then
							Experiment = KeystoreConstants.Experiment
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p67.id)))
						else
							Experiment = KeystoreConstants.Control
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p67.id)))
						end

						json5 = HttpService:JSONEncode({
							server = tostring(ContentProvider.BaseUrl),
							username = tostring(data.cvalue),
							userId = tostring(p67.id),
							password = tostring(data.password),
							experimentGroup = tostring(Experiment)
						})
					end

					return default:registerCredentials(default.CredentialsTypes.keystore, json5, KeystoreConstants.KeystoreTimeout)
				end):andThen(function(_) -- line: 772
					-- upvalues: resolve (copy)
					resolve()
				end):catch(function(p69) -- line: 775
					-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
							customFields = {
								result = "error"
							}
						}, 1)
					end

					reject(p69)
				end)
			end):finally(function() -- line: 791
				-- upvalues: LoginResult (copy), p64 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), v128 (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v326 (copy), v324 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
				if LoginResult.hasTwoStepData(p64) then
					if not FFlagRemoveUnusedLoginResultRoduxSlice then
						local v421 = p64

						v128(SetLoginResult(v421))
					end

					reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
					spawn(function() -- line: 800
						-- upvalues: v145 (copy), p64 (copy), v326 (copy), v324 (copy)
						v145(p64, v326, v324)
					end)
				else
					reportEphemeralCounter(AppLoginCounterNames.Success, 1)

					if v326 then
						if v66 then
							local v422 = v143(v326)

							if v422 then
								v422:await()
							end
						else
							v143(v326)
						end
					end

					if FFlagEnableLuaAccountSwitch then
						v142(p64.accountBlob)
					else
						v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
					end
				end

				if GetFFlagEnableLoginAccountSelector() then
					v128(CloseCentralOverlay())
				end
			end)
		end, function(p70) -- line: 980
			-- upvalues: v233 (copy), s3 (copy), s4 (copy)
			v233(p70, s3, s4)
		end)
	end
	local function v152() -- line: 1338
		-- upvalues: v128 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v131 (copy), GetFStringVNGDownloadNowUrl (copy)
		return v128(SetCentralOverlay(CentralOverlayType.NewAppAvailableModal, {
			onButtonActivated = function() -- line: 1340
				-- upvalues: v131 (copy), GetFStringVNGDownloadNowUrl (copy)
				v131:openURL(GetFStringVNGDownloadNowUrl())
			end
		}))
	end
	local function v153(p71, p72, p73, t14: {[any]: any}) -- line: 1347
		-- upvalues: EventStreamConstants (copy), v122 (copy), UserIdentifierType (copy), handleLoginWithOtp (copy), handleLoginWithFormData (copy), v128 (copy), CloseCentralOverlay (copy), v141 (copy)
		local s5 = ""

		if t14.isLoginByOtp then
			s5 = EventStreamConstants.Context.DisambiguationOTP
		elseif v122.userIdentifierType == UserIdentifierType.Email then
			s5 = EventStreamConstants.Context.DisambiguationEmail
		elseif v122.userIdentifierType == UserIdentifierType.Phone then
			s5 = EventStreamConstants.Context.DisambiguationPhone
		end

		local t15 = {
			titleTextKey = "Authentication.Login.Label.AccountSelectorTitle",
			origin = EventStreamConstants.Context.Login,
			context = s5,
			users = p71,
			onAccountSelection = function(p74) -- line: 1366
				-- upvalues: t14 (copy), handleLoginWithOtp (copy), p72 (copy), p73 (copy), handleLoginWithFormData (copy)
				if t14.isLoginByOtp then
					handleLoginWithOtp(p72, p73, nil, p74, t14)

					return
				end

				handleLoginWithFormData(p72, p73, nil, nil, p74, false, t14):await()
			end,
			onAccountSelectionAbandoned = function() -- line: 1373
				-- upvalues: t14 (copy), v128 (copy), CloseCentralOverlay (copy)
				t14.setInProgress(false)
				v128(CloseCentralOverlay())
			end
		}

		v141(t15)
	end
	local function v154(p75) -- line: 1383
		-- upvalues: v138 (copy), v123 (copy), LoginActionType (copy), LoginPageState (copy)
		v138()
		v123({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.LoginScreenV2,
				payload = {
					errorKey = p75.errorKey
				}
			}
		})
		v123({
			type = LoginActionType.ForceLoginByUsername
		})
	end
	local function v155(p76) -- line: 1399
		-- upvalues: LoginErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), StatusCodes (copy)
		if p76.errorCode == LoginErrorCodes.IncorrectCValueOrPassword then
			reportEphemeralCounter(AppLoginCounterNames.FailureCredentials, 1)

			return
		end

		if p76.errorCode == LoginErrorCodes.AccountLocked then
			reportEphemeralCounter(AppLoginCounterNames.FailurePasswordReset, 1)

			return
		end

		if p76.errorCode == LoginErrorCodes.CTypeNotSupported then
			reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)

			return
		end

		if p76.errorCode == LoginErrorCodes.CValueAndPasswordRequired then
			reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)

			return
		end

		if p76.errorCode == LoginErrorCodes.SecurityQuestions then
			reportEphemeralCounter(AppLoginCounterNames.FailureSecurityQuestions, 1)

			return
		end

		if p76.errorCode == LoginErrorCodes.MultipleUsersPerCredential then
			reportEphemeralCounter(AppLoginCounterNames.FailureMultipleUsersPerCredential, 1)

			return
		end

		if p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.TOO_MANY_REQUESTS then
			reportEphemeralCounter(AppLoginCounterNames.FailureThrottled, 1)

			return
		end

		if p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.REQUEST_TIMEOUT then
			reportEphemeralCounter(AppLoginCounterNames.FailureTimeout, 1)

			return
		end

		if p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.BAD_REQUEST then
			reportEphemeralCounter(AppLoginCounterNames.FailureBadRequest, 1)

			return
		end

		if p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.NOT_FOUND then
			reportEphemeralCounter(AppLoginCounterNames.FailureNotFound, 1)

			return
		end

		if p76.HttpError == Enum.HttpError.OK and p76.StatusCode == StatusCodes.INTERNAL_SERVER_ERROR then
			reportEphemeralCounter(AppLoginCounterNames.FailureInternalServerError, 1)

			return
		end

		reportEphemeralCounter(AppLoginCounterNames.FailureUnknownError, 1)
	end

	function u147(t16: {[any]: any}) -- line: 1427
		-- upvalues: LoginErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v155 (copy), authClientError (copy), v128 (copy), CloseCentralOverlay (copy), AppStorageUtilities (copy), User (copy), v129 (copy), LogoutAllLoggedInUsers (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), v140 (copy), LoginResult (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), ResetAppState (copy), Promise (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), AccountSwitcherConstants (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), LogoutReasonNames (copy), Logout (copy), u124 (ref), v127 (copy), OpenAccountSwitchingErrorOverlay (copy), v154 (copy), LoginPageState (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy), v152 (copy), v146 (copy), v153 (copy)
		local function handleLoginError(p77, s6: string?, s7: string?, b1: boolean?) -- line: 1428
			-- upvalues: LoginErrorCodes (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v155 (copy), authClientError (copy), t16 (copy), v128 (copy), CloseCentralOverlay (copy), AppStorageUtilities (copy), User (copy), v129 (copy), LogoutAllLoggedInUsers (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), v140 (copy), LoginResult (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), ResetAppState (copy), Promise (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), AccountSwitcherConstants (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), LogoutReasonNames (copy), Logout (copy), u124 (ref), v127 (copy), OpenAccountSwitchingErrorOverlay (copy), v154 (copy), LoginPageState (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy), v152 (copy), v146 (copy), v153 (copy)
			local u361 = false
			local v362 = p77.errorCode == LoginErrorCodes.MultipleUsersPerCredential
			local v363 = p77.errorCode == LoginErrorCodes.SecurityQuestions

			if v362 or v363 then
				u361 = true
			end

			reportEphemeralCounter(AppLoginCounterNames.Failure, 1)
			v155(p77)
			authClientError(t16.eventContext, p77.errorCode)

			local function v364() -- line: 1446
				-- upvalues: t16 (copy), u361 (ref), v128 (copy), CloseCentralOverlay (copy)
				t16.setInProgress(u361)
				v128(CloseCentralOverlay())
			end
			local function v365() -- line: 1451
				-- upvalues: AppStorageUtilities (copy), User (copy), t16 (copy), v129 (copy), LogoutAllLoggedInUsers (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), b1 (copy), v140 (copy), s6 (copy), s7 (copy), LoginResult (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), v128 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), ResetAppState (copy), Promise (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), AccountSwitcherConstants (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), LogoutReasonNames (copy), Logout (copy), CloseCentralOverlay (copy)
				local v428 = AppStorageUtilities.getAccountBlob()
				local v429 = User.fromLocalStorage().userId ~= -1

				t16.setInProgress(true)

				local v430 = v129

				LogoutAllLoggedInUsers(v430, v428):await()

				local v431 = false

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					if b1 then
						local ok, result = pcall(function() -- line: 1460
							-- upvalues: v140 (copy), v129 (copy), s6 (copy), s7 (copy)
							return v140(v129, s6, s7):expect()
						end)

						if ok and result and not LoginResult.hasTwoStepData(result) then
							if FFlagEnableLuaAccountSwitch then
								v142(result.accountBlob)

								return
							end

							v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))

							return
						end
					elseif type(s6) ~= "string" then
						v431 = true
					end
				end

				if v429 == true then
					v128(ResetAppState())
					Promise.resolve()
					AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, "")
					AppStorageService:Flush()

					if FFlagEnableNavigateToLoginAfterLogoutAll then
						local v434 = if not v431 then AccountSwitcherConstants.AccountSwitcherPendingLoginV2AfterLogoutAll else AccountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV2AfterLogoutAll

						AppStorageUtilities.setAccountSwitchStatus(v434)
						AppStorageUtilities.flush()
					end

					if FFlagAddReasonToEveryLogout then
						local v435 = v129
						local v436 = GuiService
						local LoginContextAccountSwitchingErrorOverlay = LogoutReasonNames.LoginContextAccountSwitchingErrorOverlay

						v128(Logout(v435, v436, LoginContextAccountSwitchingErrorOverlay))
					else
						local v438 = v129
						local v439 = GuiService

						v128(Logout(v438, v439, nil))
					end
				end

				t16.setInProgress(false)
				v128(CloseCentralOverlay())
			end

			if FFlagEnableLuaAccountSwitch and p77.errorCode == LoginErrorCodes.EmptyAccountSwitchBlobRequired then
				t16.setErrorKey("")

				local v366 = if not FFlagEnableNavigateToLoginAfterLogoutAll or b1 then s6 else u124.current

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					AppStorageUtilities.setAccountSwitchTargetUsername(v366)
				end

				local v367 = not v127 and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts"
				local v368 = not v127 and "Authentication.AccountSwitch.Description.LogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers"
				local v369 = not v127 and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue"
				local AccountSwitcherLoginEmptyBlobRequiredError = AccountSwitcherConstants.AccountSwitcherLoginEmptyBlobRequiredError
				local v371 = v366 or nil

				v128(OpenAccountSwitchingErrorOverlay(v367, v368, v369, "Authentication.CrossDevice.Action.CancelLogin", v365, v364, AccountSwitcherLoginEmptyBlobRequiredError, v371))

				return
			end

			if FFlagEnableLuaAccountSwitch and p77.errorCode == LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired then
				t16.setErrorKey("")

				local v372 = if not FFlagEnableNavigateToLoginAfterLogoutAll or b1 then s6 else u124.current

				if FFlagEnableNavigateToLoginAfterLogoutAll then
					AppStorageUtilities.setAccountSwitchTargetUsername(v372)
				end

				local v373 = not v127 and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts"
				local v374 = not v127 and "Authentication.AccountSwitch.Description.ParentLogoutConfirmation" or "Authentication.AccountSwitch.Description.ContinueSignOutOthers"
				local v375 = not v127 and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue"
				local AccountSwitcherParentLoginEmptyBlobRequiredError = AccountSwitcherConstants.AccountSwitcherParentLoginEmptyBlobRequiredError
				local v377 = v372 or nil

				v128(OpenAccountSwitchingErrorOverlay(v373, v374, v375, "Authentication.CrossDevice.Action.CancelLogin", v365, v364, AccountSwitcherParentLoginEmptyBlobRequiredError, v377))

				return
			end

			if p77.errorCode == LoginErrorCodes.MoreThanOneUsername then
				v154(p77)
				t16.navigation.navigate(LoginPageState.LoginScreenV2)

				return
			end

			if p77.errorCode == LoginErrorCodes.AccountLocked then
				v128(OpenCentralOverlayForLoginPasswordResetPrompt())
			end

			if p77.errorCode == LoginErrorCodes.GlobalAppAccessDeniedVNG then
				v152()
			end

			if v363 and p77.securityQuestionsData and p77.securityQuestionsCallback then
				spawn(function() -- line: 1578
					-- upvalues: v146 (copy), s6 (copy), s7 (copy), p77 (copy), t16 (copy)
					v146(s6, s7, p77.securityQuestionsData, p77.securityQuestionsCallback, t16)
				end)

				return
			end

			if v362 and p77.usersData and s6 and s7 then
				v153(p77.usersData, s6, s7, t16)

				return
			end

			t16.setErrorKey(p77.errorKey or "Authentication.Login.Response.SomethingWentWrong")
			t16.setInProgress(u361)
		end

		return handleLoginError
	end

	return React.createElement(LoginContext.Provider, {
		value = {
			state = v122,
			dispatch = v123,
			parentNavigation = t1.parentNavigation,
			utils = {
				handleLoginCompletionWithAccountSwitching = v142,
				handleLoginResult = function(p78, s8: string?, t17: {[any]: any}) -- line: 788
					-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Promise (copy), GetFFlagKeystoreAutoLoginAvailable (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), LoginResult (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
					if FFlagUseBackDisableSignalStore then
						BackDisableStore.setDisabled(false)
					else
						v128(SetBackNavigationDisabled(false))
					end

					Promise.new(function(resolve, reject) -- line: 671
						-- upvalues: GetFFlagKeystoreAutoLoginAvailable (copy), s8 (copy), GetFFlagRemoveKeystoreIxpLogic (copy), v125 (copy), GetFFlagBypassKeystoreLoginIxpV2 (copy), HttpService (copy), ContentProvider (copy), GetUserByUsername (copy), v129 (copy), default (copy), KeystoreConstants (copy), Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy)
						if GetFFlagKeystoreAutoLoginAvailable() == false or s8 == nil then
							resolve()

							return
						end

						local v297 = not not GetFFlagRemoveKeystoreIxpLogic() or (v125.shouldLoginWithKeystoreCredentials or GetFFlagBypassKeystoreLoginIxpV2())
						local json = HttpService:JSONEncode({
							server = ContentProvider.BaseUrl
						})
						local data = HttpService:JSONDecode(s8)

						GetUserByUsername(v129, data.cvalue)():andThen(function(p79) -- line: 693
							-- upvalues: reject (copy), default (copy), KeystoreConstants (copy), json (copy), Promise (copy)
							if not p79 or not p79.id then
								return reject("Invalid usernameInfo")
							end

							return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p80) -- line: 701
								-- upvalues: default (copy), json (copy), KeystoreConstants (copy), Promise (copy)
								if p80 and (p80.keystore and p80.keystore.isAvailable) then
									return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
								end

								return Promise.resolve(nil)
							end):andThen(function() -- line: 716
								-- upvalues: p79 (copy)
								return p79
							end)
						end):andThen(function(p81) -- line: 720
							-- upvalues: GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), HttpService (copy), ContentProvider (copy), data (copy), v297 (copy), KeystoreConstants (copy), default (copy)
							local json6

							if GetFFlagRemoveKeystoreIxpLogic() then
								KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentials, (tostring(p81.id)))

								if GetFFlagAddPromCounterToKeystoreOps() then
									TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
										customFields = {
											result = "attempt"
										}
									}, 1)
								end

								json6 = HttpService:JSONEncode({
									server = tostring(ContentProvider.BaseUrl),
									username = tostring(data.cvalue),
									userId = tostring(p81.id),
									password = tostring(data.password)
								})
							else
								local Experiment

								if v297 == true then
									Experiment = KeystoreConstants.Experiment
									KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsExperimentGroup, (tostring(p81.id)))
								else
									Experiment = KeystoreConstants.Control
									KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.saveCredentialsControlGroup, (tostring(p81.id)))
								end

								json6 = HttpService:JSONEncode({
									server = tostring(ContentProvider.BaseUrl),
									username = tostring(data.cvalue),
									userId = tostring(p81.id),
									password = tostring(data.password),
									experimentGroup = tostring(Experiment)
								})
							end

							return default:registerCredentials(default.CredentialsTypes.keystore, json6, KeystoreConstants.KeystoreTimeout)
						end):andThen(function(_) -- line: 772
							-- upvalues: resolve (copy)
							resolve()
						end):catch(function(p83) -- line: 775
							-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreSaveCredentialsTelemetryConfig (copy), reject (copy)
							if GetFFlagAddPromCounterToKeystoreOps() then
								TelemetryService:LogCounter(KeystoreSaveCredentialsTelemetryConfig, {
									customFields = {
										result = "error"
									}
								}, 1)
							end

							reject(p83)
						end)
					end):finally(function() -- line: 791
						-- upvalues: LoginResult (copy), p78 (copy), FFlagRemoveUnusedLoginResultRoduxSlice (copy), v128 (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), v145 (copy), s8 (copy), t17 (copy), v66 (copy), v143 (copy), FFlagEnableLuaAccountSwitch (copy), v142 (copy), LaunchApp (copy), v129 (copy), v130 (copy), v132 (copy), LaunchContext (copy), GetFFlagEnableLoginAccountSelector (copy), CloseCentralOverlay (copy)
						if LoginResult.hasTwoStepData(p78) then
							if not FFlagRemoveUnusedLoginResultRoduxSlice then
								local v300 = p78

								v128(SetLoginResult(v300))
							end

							reportEphemeralCounter(AppLoginCounterNames.FailureTwoStepVerification, 1)
							spawn(function() -- line: 800
								-- upvalues: v145 (copy), p78 (copy), s8 (copy), t17 (copy)
								v145(p78, s8, t17)
							end)
						else
							reportEphemeralCounter(AppLoginCounterNames.Success, 1)

							if s8 then
								if v66 then
									local v301 = v143(s8)

									if v301 then
										v301:await()
									end
								else
									v143(s8)
								end
							end

							if FFlagEnableLuaAccountSwitch then
								v142(p78.accountBlob)
							else
								v128(LaunchApp(v129, nil, v130, v132, LaunchContext.Login))
							end
						end

						if GetFFlagEnableLoginAccountSelector() then
							v128(CloseCentralOverlay())
						end
					end)
				end,
				showPasskeyLoginPopup = function(t18: {[any]: any}, b2: boolean, b3: boolean) -- line: 1033
					-- upvalues: v137 (copy), v122 (copy), v136 (copy), HttpService (copy), Constants (copy), UserInputService (copy), Base64 (copy), default (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), authClientError (copy), EventStreamConstants (copy), PasskeyConstants (copy), v149 (copy)
					local v244 = not b2 and function() -- line: 1046
						-- upvalues: v136 (copy)
						return v136()
					end or function() -- line: 1040
						-- upvalues: v137 (copy), v122 (copy)
						return v137({
							cvalue = v122.userIdentifier,
							ctype = v122.userIdentifierType
						})
					end
					local u245 = false

					return v244():andThen(function(p84) -- line: 1053
						-- upvalues: HttpService (copy), Constants (copy), b3 (copy), UserInputService (copy), Base64 (copy), default (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), authClientError (copy), EventStreamConstants (copy), PasskeyConstants (copy), t18 (copy), u245 (ref), v149 (copy)
						local data = HttpService:JSONDecode(p84.authenticationOptions)
						local sessionId = p84.sessionId
						local num = tonumber(data.publicKey.timeout)
						local v342 = if not num then Constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT else num / 1000

						data.keyType = "platform"
						data.deviceBoundOnly = b3

						if UserInputService:GetPlatform() ~= Enum.Platform.Android then
							data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)

							if data.publicKey.allowCredentials then
								for _, v in ipairs(data.publicKey.allowCredentials) do
									v.id = Base64.FromUrlSafeBase64(v.id)
								end
							end
						end

						local json = HttpService:JSONEncode(data)

						default:getCredentials(default.CredentialsTypes.FIDO2, json, v342):andThen(function(p85) -- line: 1079
							-- upvalues: HttpService (copy), Logger (copy), CredentialsProtocolErrorCodes (copy), authClientError (copy), EventStreamConstants (copy), PasskeyConstants (copy), Base64 (copy), t18 (copy), u245 (ref), v149 (copy), sessionId (copy)
							if p85 ~= nil then
								local data3 = HttpService:JSONDecode(p85)

								if data3 == nil or next(data3) == nil then
									Logger:info("Passkey credential signing failed. No result returned.")

									return
								end

								if data3.errorCode ~= nil then
									Logger:info("Passkey credential signing failed. Error {} (msg: {}) returned.", data3.errorCode, data3.errorMsg)

									local num2 = tonumber(data3.errorCode)
									local v426 = CredentialsProtocolErrorCodes.GetCredentialsErrorCodes[num2 or -1] or string.format(CredentialsProtocolErrorCodes.UNMAPPED_ERROR_CODE, (tostring(data3.errorCode)))

									authClientError(EventStreamConstants.Context.PasskeyLoginAttempt, v426, PasskeyConstants.PASSKEY_FETCH_LOGIN_V2)

									return
								end

								Logger:info("Passkey credential signing completed. Attempting login.")
								data3.id = Base64.ToUrlSafeBase64(data3.id)
								data3.rawId = Base64.ToUrlSafeBase64(data3.rawId)
								data3.response.signature = Base64.ToUrlSafeBase64(data3.response.signature)
								data3.response.userHandle = Base64.ToUrlSafeBase64(data3.response.userHandle)
								data3.response.authenticatorData = Base64.ToUrlSafeBase64(data3.response.authenticatorData)
								data3.response.clientDataJSON = Base64.ToUrlSafeBase64(data3.response.clientDataJSON)
								t18.setInProgress(true)
								u245 = true
								v149(data3, sessionId, t18)
							end
						end, function(p86) -- line: 1118
							-- upvalues: Logger (copy)
							Logger:warning("Passkey credential signing failed. Error: {}", p86)
						end):await()
					end, function(p87) -- line: 1122
						-- upvalues: Logger (copy), b2 (copy), b3 (copy), t18 (copy)
						Logger:warning("Fetching passkey login options failed with error code: {}", p87.errorCode)

						if b2 and not b3 then
							t18.setErrorKey("Authentication.Login.Response.UnableToSignIn")
						end
					end):finally(function() -- line: 1129
						-- upvalues: t18 (copy), u245 (ref)
						if t18.onCredentialsPopupAbandoned and not u245 then
							t18.onCredentialsPopupAbandoned()
						end
					end)
				end,
				showGenericCredentialLoginPopup = function(b4: boolean, b5: boolean, b6: boolean, t19: {[any]: any}) -- line: 1136
					-- upvalues: v137 (copy), v122 (copy), v136 (copy), HttpService (copy), Constants (copy), UserInputService (copy), Base64 (copy), Logger (copy), default2 (copy), TelemetryConfigs (copy), default (copy), FFlagEnablePasskeyLoginErrorLogging (copy), authClientError (copy), EventStreamConstants (copy), PasskeyConstants (copy), handleLoginWithFormData (copy), v149 (copy)
					if not b4 and not b5 then
						return
					end

					local v250 = not b6 and function() -- line: 1154
						-- upvalues: v136 (copy)
						return v136()
					end or function() -- line: 1148
						-- upvalues: v137 (copy), v122 (copy)
						return v137({
							cvalue = v122.userIdentifier,
							ctype = v122.userIdentifierType
						})
					end
					local data = nil
					local sessionId = nil
					local u253 = nil
					local t20 = {}

					if b4 then
						v250():andThen(function(p88) -- line: 1164
							-- upvalues: data (ref), HttpService (copy), sessionId (ref), u253 (ref), Constants (copy), UserInputService (copy), Base64 (copy)
							data = HttpService:JSONDecode(p88.authenticationOptions)
							sessionId = p88.sessionId
							u253 = tonumber(data.publicKey.timeout) or Constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT
							data.keyType = "platform"
							data.deviceBoundOnly = true

							if UserInputService:GetPlatform() ~= Enum.Platform.Android then
								data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)

								if data.publicKey.allowCredentials then
									for _, v in ipairs(data.publicKey.allowCredentials) do
										v.id = Base64.FromUrlSafeBase64(v.id)
									end
								end
							end
						end, function(p89) -- line: 1185
							-- upvalues: Logger (copy)
							Logger:warning("Fetching passkey login options failed with error code: {}", p89.errorCode)
						end):await()

						if data ~= nil then
							t20.FIDO2 = data
						end
					end

					if b5 then
						t20.password = {}

						if b6 then
							t20.password.username = v122.userIdentifier
						end
					end

					local v255 = if not u253 then Constants.Defaults.CREDENTIALSPROTOCOL_GETCREDENTIALS_DEFAULTTIMEOUT else u253 / 1000
					local u256 = false
					local json = HttpService:JSONEncode(t20)

					default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetShownConfig, 1)

					return default:getCredentials(default.CredentialsTypes.all, json, v255):andThen(function(p90) -- line: 1215
						-- upvalues: HttpService (copy), Logger (copy), default2 (copy), TelemetryConfigs (copy), FFlagEnablePasskeyLoginErrorLogging (copy), authClientError (copy), EventStreamConstants (copy), PasskeyConstants (copy), default (copy), t19 (copy), u256 (ref), handleLoginWithFormData (copy), Base64 (copy), v149 (copy), sessionId (ref)
						if p90 ~= nil then
							local data4 = HttpService:JSONDecode(p90)

							if data4 == nil or not data4.response and not data4.errorCode then
								Logger:info("Generic credential fetch failed. No result returned.")
								default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig, 1)

								return
							end

							if data4.errorCode ~= nil then
								Logger:info("Generic credential fetch failed. Error {} (msg: {}) returned.", data4.errorCode, data4.errorMsg)
								default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetErrorConfig, 1, {
									errorCode = tostring(data4.errorCode)
								})

								if FFlagEnablePasskeyLoginErrorLogging and type(data4.errorMsg) == "string" then
									authClientError(EventStreamConstants.Context.PasskeyLoginAttempt, data4.errorMsg, PasskeyConstants.GENERIC_CREDENTIAL_FETCH_LOGIN_V2)

									return
								end
							else
								if data4.credentialType == default.CredentialsTypes.password then
									default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasswordSelectedConfig, 1)
									t19.setInProgress(true)
									u256 = true
									handleLoginWithFormData(data4.response.username, data4.response.password, nil, nil, nil, true, t19)

									return
								end

								if data4.credentialType == default.CredentialsTypes.FIDO2 then
									default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetPasskeySelectedConfig, 1)
									data4.response.id = Base64.ToUrlSafeBase64(data4.response.id)
									data4.response.rawId = Base64.ToUrlSafeBase64(data4.response.rawId)
									data4.response.response.signature = Base64.ToUrlSafeBase64(data4.response.response.signature)
									data4.response.response.userHandle = Base64.ToUrlSafeBase64(data4.response.response.userHandle)
									data4.response.response.authenticatorData = Base64.ToUrlSafeBase64(data4.response.response.authenticatorData)
									data4.response.response.clientDataJSON = Base64.ToUrlSafeBase64(data4.response.response.clientDataJSON)
									t19.setInProgress(true)
									u256 = true
									v149(data4.response, sessionId, t19)
								end
							end
						end
					end, function(p91) -- line: 1280
						-- upvalues: Logger (copy), default2 (copy), TelemetryConfigs (copy)
						Logger:warning("Generic credential signing failed. Error: {}", p91)
						default2:logRobloxTelemetryCounter(TelemetryConfigs.IosAuthServiceLoginCredentialSheetDismissedConfig, 1)
					end):andThen(function(_) -- line: 1289
						-- upvalues: t19 (copy), u256 (ref)
						if t19.onCredentialsPopupAbandoned and not u256 then
							t19.onCredentialsPopupAbandoned()
						end
					end):catch(function(_) -- line: 1295
						-- upvalues: t19 (copy), u256 (ref)
						if t19.onCredentialsPopupAbandoned and not u256 then
							t19.onCredentialsPopupAbandoned()
						end
					end)
				end,
				handleLoginWithCode = handleLoginWithCode,
				handleLoginWithFormData = handleLoginWithFormData,
				handleLoginWithPasskey = v149,
				handleLoginWithOtp = handleLoginWithOtp,
				handleSendEmailOtp = function(p94: ((...any) -> ...any), t21: {[any]: any}) -- line: 986
					-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Constants2 (copy), v122 (copy), SendCode (copy), v129 (copy)
					if FFlagUseBackDisableSignalStore then
						BackDisableStore.setDisabled(true)
					else
						v128(SetBackNavigationDisabled(true))
					end

					local t22 = {
						origin = Constants2.otpServiceOrigin,
						contactType = Constants2.otpServiceContactType,
						contactValue = v122.userIdentifier
					}

					return v128(SendCode(v129, t22)):andThen(function(p95) -- line: 997
						-- upvalues: p94 (copy)
						p94(p95.otpSessionToken)
					end, function(p96) -- line: 1000
						-- upvalues: t21 (copy), Constants2 (copy)
						t21.setInProgress(false)

						local v330 = tonumber(p96) or 0
						local v331 = Constants2.statusCodeMap[v330] or "Unknown"
						local v332 = Constants2.errorMessageKeys[v331] or Constants2.errorMessageKeys.Unknown

						t21.setErrorKey(v332)
					end)
				end,
				handleResendEmailOtp = function(s9: string, p97: ((...any) -> ...any), t23: {[any]: any}) -- line: 1009
					-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), v128 (copy), SetBackNavigationDisabled (copy), Constants2 (copy), ResendCode (copy), v129 (copy)
					if FFlagUseBackDisableSignalStore then
						BackDisableStore.setDisabled(true)
					else
						v128(SetBackNavigationDisabled(true))
					end

					local t24 = {
						origin = Constants2.otpServiceOrigin,
						contactType = Constants2.otpServiceContactType,
						otpSessionToken = s9
					}

					return v128(ResendCode(v129, t24)):andThen(function(p98) -- line: 1021
						-- upvalues: p97 (copy)
						p97(p98.otpSessionToken)
					end, function(p99) -- line: 1024
						-- upvalues: t23 (copy), Constants2 (copy)
						t23.setInProgress(false)

						local v335 = tonumber(p99) or 0
						local v336 = Constants2.statusCodeMap[v335] or "Unknown"
						local v337 = Constants2.errorMessageKeys[v336] or Constants2.errorMessageKeys.Unknown

						t23.setErrorKey(v337)
					end)
				end,
				openAccountSwitchingErrorOverlay = function(p100, p101, p102, p103, p104, p105, p106, p107) -- line: 1302
					-- upvalues: v128 (copy), OpenAccountSwitchingErrorOverlay (copy)
					return v128(OpenAccountSwitchingErrorOverlay(p100, p101, p102, p103, p104, p105, p106, p107))
				end,
				openPasswordResetPrompt = function() -- line: 1326
					-- upvalues: v128 (copy), OpenCentralOverlayForLoginPasswordResetPrompt (copy)
					return v128(OpenCentralOverlayForLoginPasswordResetPrompt())
				end,
				openWebView = function(s10: string) -- line: 394
					-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), v128 (copy), NavigateDown (copy)
					local t25 = {
						name = AppPage.GenericWebPage,
						detail = s10,
						extraProps = {
							title = "",
							transitionAnimation = "SlideInFromBottom"
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v31.down(v31.fromLegacyPage(t25))

						return
					end

					v128(NavigateDown(t25))
				end,
				openAccountRecovery = function(s11: string) -- line: 410
					-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), v128 (copy), NavigateDown (copy)
					local t26 = {
						name = AppPage.AccountRecovery,
						extraProps = {
							recoverPassword = true,
							identifier = s11
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v31.down(v31.fromLegacyPage(t26))

						return
					end

					v128(NavigateDown(t26))
				end,
				logoutAllLoggedInUsers = function(p108, p109) -- line: 1330
					-- upvalues: LogoutAllLoggedInUsers (copy)
					return LogoutAllLoggedInUsers(p108, p109)
				end,
				logoutWithoutShowConfirmation = function(p110, p111, s12: string?) -- line: 1334
					-- upvalues: v128 (copy), Logout (copy)
					return v128(Logout(p110, p111, s12))
				end,
				openNewAppAvailableModal = v152,
				closeCentralOverlay = function() -- line: 365
					-- upvalues: v128 (copy), CloseCentralOverlay (copy)
					return v128(CloseCentralOverlay())
				end,
				clearApp = function() -- line: 277
					-- upvalues: v128 (copy), ResetAppState (copy), Promise (copy)
					v128(ResetAppState())

					return Promise.resolve()
				end,
				openAccountSelector = v153,
				handleCredentialsCollision = v154,
				registerPassword = v143,
				isUserAuthenticated = function() -- line: 386
					-- upvalues: User (copy)
					return User.fromLocalStorage().userId ~= -1
				end
			}
		}
	}, t1.children)
end
