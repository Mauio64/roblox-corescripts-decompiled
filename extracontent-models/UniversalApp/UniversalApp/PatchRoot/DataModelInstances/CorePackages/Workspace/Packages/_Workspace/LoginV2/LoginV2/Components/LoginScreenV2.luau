local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local React = require(LoginV2Parent.React)
local Cryo = require(LoginV2Parent.Cryo)
local AppBlox = require(LoginV2Parent.AppBlox)
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local AuthCommon = require(LoginV2Parent.AuthCommon)
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local useDispatch = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(LoginV2Parent.RobloxAppHooks).useRoactService
local AuthenticationMethodType = require(LoginV2.Enums.AuthenticationMethodType)
local LoginActionType = require(LoginV2.Enums.LoginActionType)
local UserIdentifierType = require(LoginV2.Enums.UserIdentifierType)
local UniversalAppPolicy = require(LoginV2Parent.UniversalAppPolicy)
local RoactNetworking = require(LoginV2Parent.RoactServiceTags).RoactNetworking
local authPageload = AuthAnalytics.Events.authPageload
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authClientError = AuthAnalytics.Events.authClientError
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local UIBlox = require(LoginV2Parent.UIBlox)
local useDesignTokens = require(LoginV2Parent.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ButtonStack = UIBlox.App.Button.ButtonStack
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local TextInput = require(LoginV2Parent.Foundation).TextInput
local CredentialsProtocol = require(LoginV2Parent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local SharedFlags = require(LoginV2Parent.SharedFlags)
local FFlagEnableLastLoginMethodTracking = SharedFlags.FFlagEnableLastLoginMethodTracking
local FFlagEnableLoginV2ForcedUsernameOverride = SharedFlags.FFlagEnableLoginV2ForcedUsernameOverride
local FFlagAuthSecExclusions = SharedFlags.FFlagAuthSecExclusions
local FFlagFixLoginV2LandscapeLayout = SharedFlags.FFlagFixLoginV2LandscapeLayout
local FFlagEnableNavigateToLoginAfterLogoutAll = SharedFlags.FFlagEnableNavigateToLoginAfterLogoutAll
local NeedHelpButton = require(LoginV2.Components.NeedHelpButton)
local LoginPageState = require(LoginV2.Enums.LoginPageState)
local LoginContext = require(LoginV2.Context.LoginContext)
local InitializeLogin = require(LoginV2.Thunks.InitializeLogin)
local Constants = require(LoginV2.Components.Constants)
local isStringEmail = AuthCommon.Utils.isStringEmail
local isStringPhone = AuthCommon.Utils.isStringPhone
local CrossDeviceLogin = AuthCommon.Thunks.CrossDeviceLogin
local ApiFetchAuthMetaData = AuthCommon.Thunks.ApiFetchAuthMetaData
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local LoginMethods = AuthCommon.Enums.LoginMethods
local Logger = require(LoginV2Parent.Loggers).Logger
local default2 = require(LoginV2Parent.LoggingProtocol).default
local TelemetryConfigs = require(LoginV2Parent.AuthAnalytics).TelemetryConfigs
local t1 = {
	disableLoginForgotButton = false,
	excludeUsernamePasswordSignIn = false,
	excludeEmailPasswordSignIn = false,
	excludePhoneNumberPasswordSignIn = false,
	excludePasskeyLogin = false,
	excludeCrossDeviceSignIn = false
}

function getUserIdentifierType(s1: string) -- line: 93
	-- upvalues: isStringEmail (copy), UserIdentifierType (copy), isStringPhone (copy)
	if isStringEmail(s1) then
		return UserIdentifierType.Email
	end

	if isStringPhone(s1) then
		return UserIdentifierType.Phone
	end

	return UserIdentifierType.Username
end
function LoginScreenV2(t2: {[any]: any}) -- line: 103
	-- upvalues: React (copy), LoginContext (copy), useStyle (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), FFlagAuthSecExclusions (copy), UniversalAppPolicy (copy), t1 (copy), LoginActionType (copy), LoginPageState (copy), InitializeLogin (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), UserIdentifierType (copy), Cryo (copy), AuthenticationMethodType (copy), Logger (copy), HttpService (copy), authClientError (copy), EventStreamConstants (copy), AppStorageUtilities (copy), authButtonClick (copy), FFlagEnableLastLoginMethodTracking (copy), LoginMethods (copy), default2 (copy), TelemetryConfigs (copy), ApiFetchAuthMetaData (copy), authPageload (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), useLocalization (copy), ButtonType (copy), CrossDeviceLogin (copy), Images (copy), StandardButtonSize (copy), NeedHelpButton (copy), FullscreenPageWithSafeArea (copy), FFlagFixLoginV2LandscapeLayout (copy), IconButton (copy), StyledTextLabel (copy), Constants (copy), TextInput (copy), authFormInteraction (copy), Button (copy), ButtonStack (copy)
	local v60 = React.useContext(LoginContext)
	local utils = v60.utils
	local state = v60.state
	local v63 = useStyle()
	local v64 = useDesignTokens()
	local v65 = useDispatch()
	local v66 = useRoactService(RoactNetworking)

	if FFlagAuthSecExclusions then
		UniversalAppPolicy.useAppPolicy(function(p1) -- line: 114
			-- upvalues: t1 (copy)
			t1.disableLoginForgotButton = p1.getDisableLoginForgotButton()
			t1.excludeUsernamePasswordSignIn = p1.getExcludeUsernamePasswordSignIn()
			t1.excludeEmailPasswordSignIn = p1.getExcludeEmailPasswordSignIn()
			t1.excludePhoneNumberPasswordSignIn = p1.getExcludePhoneNumberPasswordSignIn()
			t1.excludePasskeyLogin = p1.getExcludePasskeyLogin()
			t1.excludeCrossDeviceSignIn = p1.getExcludeCrossDeviceSignIn()
		end)
	end

	local function v67(p2) -- line: 124
		-- upvalues: v60 (copy), LoginActionType (copy), LoginPageState (copy)
		v60.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.LoginScreenV2,
				payload = p2
			}
		})
	end

	local v68, v69 = React.useState(false)
	local v70 = state and state.componentState[LoginPageState.LoginScreenV2].userIdentifier or ""
	local v71, v72 = React.useState(v70)
	local v73 = state and state.componentState[LoginPageState.LoginScreenV2].errorKey or ""

	local function v74(s2: string?) -- line: 162
		-- upvalues: v71 (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), state (copy), v60 (copy), LoginActionType (copy), v69 (copy), v67 (copy), v72 (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), UserIdentifierType (copy), v65 (copy), InitializeLogin (copy), v66 (copy), Cryo (copy), AuthenticationMethodType (copy), t2 (copy), LoginPageState (copy), Logger (copy), HttpService (copy), authClientError (copy), EventStreamConstants (copy)
		local u89 = s2 or v71

		if FFlagEnableLoginV2ForcedUsernameOverride and (state and state.extraProps and state.extraProps.forcedUsernameOverride and state.extraProps.forcedUsernameOverride ~= "") then
			u89 = state.extraProps.forcedUsernameOverride
			v60.dispatch({
				type = LoginActionType.ClearForcedUsernameOverride
			})
		end

		v69(true)

		local v90 = u89

		v67({
			userIdentifier = v90
		})
		v72(u89)

		if FFlagEnableNavigateToLoginAfterLogoutAll then
			v60.dispatch({
				type = LoginActionType.SetUserIdentifierAndType,
				data = {
					userIdentifier = u89,
					userIdentifierType = if not state.forceLoginByUsername then getUserIdentifierType(u89) else UserIdentifierType.Username
				}
			})
		end

		local v91 = u89

		v65(InitializeLogin(v66, {
			cvalue = v91,
			ctype = getUserIdentifierType(v91)
		})):andThen(function(p3) -- line: 197
			-- upvalues: Cryo (copy), AuthenticationMethodType (copy), v60 (copy), LoginActionType (copy), u89 (ref), state (copy), UserIdentifierType (copy), s2 (copy), v67 (copy), v69 (copy), t2 (copy), LoginPageState (copy)
			local v108 = Cryo.List.map(p3.loginMethods, function(p4) -- line: 198
				-- upvalues: AuthenticationMethodType (copy)
				return AuthenticationMethodType[p4.method]
			end)

			v60.dispatch({
				type = LoginActionType.SetUserIdentifierAndType,
				data = {
					userIdentifier = u89,
					userIdentifierType = if not state.forceLoginByUsername then getUserIdentifierType(u89) else UserIdentifierType.Username
				}
			})
			v60.dispatch({
				type = LoginActionType.SetAvailableLoginMethods,
				data = v108
			})

			if s2 ~= nil then
				v60.dispatch({
					type = LoginActionType.UpdateCredentialsProtocolStatus,
					data = {
						shouldShowAuthScreenCredentialsPopup = true
					}
				})
			else
				v60.dispatch({
					type = LoginActionType.UpdateCredentialsProtocolStatus,
					data = {
						shouldShowAuthScreenUserSpecificPasskeyPopup = true
					}
				})
			end

			v67({
				errorKey = ""
			})
			v69(false)
			t2.navigation.navigate(LoginPageState.AuthenticationScreen)
		end, function(p5) -- line: 235
			-- upvalues: Logger (copy), HttpService (copy), authClientError (copy), EventStreamConstants (copy), v67 (copy), v69 (copy)
			Logger:warning("Error initializing login: {}", HttpService:JSONEncode(p5))
			authClientError(EventStreamConstants.Context.LoginFormV2Username, p5.errorCode)

			local v110 = p5.errorKey or "Authentication.Login.Response.SomethingWentWrong"

			v67({
				errorKey = v110
			})
			v69(false)
		end)
	end

	local t3 = {
		isLoginByOtp = false,
		setInProgress = v69,
		setErrorKey = function(p6) -- line: 149
			-- upvalues: v67 (copy)
			v67({
				errorKey = p6
			})
		end,
		navigation = t2.navigation,
		eventContext = EventStreamConstants.Context.LoginFormV2Username
	}

	React.useEffect(function() -- line: 277
		-- upvalues: state (copy), LoginPageState (copy), AppStorageUtilities (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), v71 (copy), authButtonClick (copy), EventStreamConstants (copy), FFlagEnableLastLoginMethodTracking (copy), LoginMethods (copy), v67 (copy), v72 (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), v60 (copy), LoginActionType (copy), v74 (copy)
		if not not state and (state.componentState[LoginPageState.LoginScreenV2].shouldAttemptCredentialPrefill or false) then
			local v96 = AppStorageUtilities.getAccountBlob()
			local v97 = AppStorageUtilities.getDefaultUsername()
			local v98 = v96 and v96 ~= ""
			local v99 = v97 and v97 ~= ""

			if if not FFlagEnableLoginV2ForcedUsernameOverride or (not state.extraProps or not state.extraProps.forcedUsernameOverride) then v99 and not (v98 or v71 ~= "") else state.extraProps.forcedUsernameOverride ~= "" then
				local v100 = AppStorageUtilities.getDefaultUsername()

				authButtonClick(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Button.PrefilledNext, nil, nil)

				if FFlagEnableLastLoginMethodTracking then
					if AppStorageUtilities.getLastSuccessfulSignInMethod() ~= LoginMethods.QuickLogin then
						v74(v100)

						return
					end

					v67({
						userIdentifier = v100
					})
					v72(v100)

					if FFlagEnableNavigateToLoginAfterLogoutAll then
						v60.dispatch({
							type = LoginActionType.SetUserIdentifierAndType,
							data = {
								userIdentifier = v100,
								userIdentifierType = getUserIdentifierType(v100)
							}
						})

						return
					end
				else
					v74(v100)
				end

				return
			end
		end
	end, {})
	React.useEffect(function() -- line: 319
		-- upvalues: default2 (copy), TelemetryConfigs (copy), utils (copy), HttpService (copy), ApiFetchAuthMetaData (copy), v66 (copy), authPageload (copy), EventStreamConstants (copy), Logger (copy)
		default2:logRobloxTelemetryCounter(TelemetryConfigs.LoginPageMountTelemetryConfig, 1, {
			version = 2
		})

		local t4 = {
			isAuthenticated = utils.isUserAuthenticated()
		}
		local json = HttpService:JSONEncode(t4)

		ApiFetchAuthMetaData(v66):andThen(function(p7) -- line: 331
			-- upvalues: authPageload (copy), EventStreamConstants (copy), json (copy)
			local v112 = p7 and p7.IsAltBrowserTracker

			authPageload(EventStreamConstants.Context.LoginFormV2Username, json, v112)
		end, function(p8) -- line: 334
			-- upvalues: Logger (copy), authPageload (copy), EventStreamConstants (copy), json (copy)
			Logger:warning("Error auth metadata: {}", p8)
			authPageload(EventStreamConstants.Context.LoginFormV2Username, json, nil)
		end)
	end, {})

	local initialStateUpdated = state.credentialsProtocolStatus.initialStateUpdated
	local fido2Supported = state.credentialsProtocolStatus.fido2Supported

	React.useEffect(function() -- line: 343
		-- upvalues: initialStateUpdated (copy), state (copy), FFlagAuthSecExclusions (copy), t1 (copy), authPageload (copy), EventStreamConstants (copy), v60 (copy), LoginActionType (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), v71 (copy), utils (copy), t3 (copy), Logger (copy), HttpService (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy)
		if initialStateUpdated or not state.shouldAutoShowCredentialPopup then
			return
		end

		local function v103(p9) -- line: 349
			-- upvalues: FFlagAuthSecExclusions (copy), t1 (copy), authPageload (copy), EventStreamConstants (copy), v60 (copy), LoginActionType (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), state (copy), v71 (copy), utils (copy), t3 (copy)
			local v115 = false
			local v116 = false
			local v117

			if p9.FIDO2 ~= nil then
				v117 = p9.FIDO2.isAvailable and p9.FIDO2.supportsDeviceBoundOnly
				v115 = p9.password and p9.password.isAvailable
				v116 = p9.password ~= nil
			else
				v117 = not not p9.isAvailable and (p9.supportsDeviceBoundOnly or false)
			end

			if FFlagAuthSecExclusions and t1.excludePasskeyLogin then
				v117 = false
			end

			authPageload(EventStreamConstants.Context.PasskeyLoginV2, v117 == nil and "timeout" or tostring(v117))
			v60.dispatch({
				type = LoginActionType.UpdateCredentialsProtocolStatus,
				data = {
					fido2Supported = v117,
					passwordsSupported = v115,
					v2InterfaceSupported = v116
				}
			})
			v60.dispatch({
				type = LoginActionType.SetCredentialAutoPopupShown
			})

			if AppStorageUtilities.getLastSuccessfulSignInMethod() ~= LoginMethods.QuickLogin then
				local v118 = AppStorageUtilities.getAccountBlob()
				local v119 = AppStorageUtilities.getDefaultUsername()
				local v120 = v118 and v118 ~= ""
				local v121 = v119 and v119 ~= ""

				if if not FFlagEnableLoginV2ForcedUsernameOverride or (not state.extraProps or not state.extraProps.forcedUsernameOverride) then v121 and not (v120 or v71 ~= "") else state.extraProps.forcedUsernameOverride ~= "" then
					return
				end
			end

			if v116 then
				utils.showGenericCredentialLoginPopup(v117, v115, false, t3)

				return
			end

			if v117 then
				utils.showPasskeyLoginPopup(t3, false, true)
			end
		end

		local extraProps = state.extraProps

		if extraProps.credProtocolIsAvailableResponse and extraProps.credProtocolIsAvailableResponse.isAvailable ~= nil then
			Logger:info("Using prefetched credentials protocol response: {}", HttpService:JSONEncode(extraProps.credProtocolIsAvailableResponse))
			authPageload(EventStreamConstants.Context.LoginRevampIsAvailableFetch, "0")
			v103(extraProps.credProtocolIsAvailableResponse)

			return
		end

		local elapsed = os.clock()

		default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p10) -- line: 423
			-- upvalues: authPageload (copy), EventStreamConstants (copy), elapsed (copy), v103 (copy)
			authPageload(EventStreamConstants.Context.LoginRevampIsAvailableFetch, (tostring(os.clock() - elapsed)))
			v103(p10)
		end):catch(function(p11) -- line: 430
			-- upvalues: v60 (copy), LoginActionType (copy), Logger (copy)
			v60.dispatch({
				type = LoginActionType.UpdateCredentialsProtocolStatus,
				data = {
					fido2Supported = false,
					passwordsSupported = false,
					v2InterfaceSupported = false
				}
			})
			Logger:warning("Error checking for available credential types. Error: {}", p11)
		end)
	end, {})

	local v78 = useLocalization({
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		orText = "Authentication.SignUp.Description.Or",
		nextActionText = "Authentication.Login.Action.Next",
		quickSignInActionText = "Authentication.Login.Action.QuickSignIn",
		usePasskeyActionText = "Authentication.Login.Action.UsePasskey",
		passkeyIncompatibleText = "Authentication.Login.Label.PasskeyIncompatible",
		identifierLabelText = not FFlagAuthSecExclusions and "Authentication.Login.Label.UsernameEmailOrPhoneNumber" or if not t1.excludeEmailPasswordSignIn or not t1.excludePhoneNumberPasswordSignIn then if not t1.excludeEmailPasswordSignIn or not t1.excludeUsernamePasswordSignIn then if not t1.excludeUsernamePasswordSignIn or not t1.excludePhoneNumberPasswordSignIn then if not t1.excludeEmailPasswordSignIn then if not t1.excludeUsernamePasswordSignIn then not t1.excludePhoneNumberPasswordSignIn and "Authentication.Login.Label.UsernameEmailOrPhoneNumber" or "Authentication.Login.Label.UsernameOrEmail" else "Authentication.Login.Label.EmailOrPhone" else "Authentication.Login.Label.UsernameOrPhone" else "Authentication.Login.Label.Email" else "Authentication.Login.Label.Phone" else "Authentication.Login.Label.Username",
		errorText = if v73 == "" then nil else v73
	})
	local t5 = {}

	if not t1.excludeCrossDeviceSignIn then
		table.insert(t5, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 490
					-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v65 (copy), CrossDeviceLogin (copy), utils (copy), t3 (copy)
					authButtonClick(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Button.QuickLogin, nil, nil)
					v65(CrossDeviceLogin.OpenLoginCodePrompt({
						isOverlay = true,
						loginCallback = function(p12, p13, p14, p15) -- line: 498
							-- upvalues: utils (copy), t3 (copy)
							utils.handleLoginWithCode(p12, p13, p14, p15, t3)
						end
					}))
				end,
				text = v78.quickSignInActionText,
				icon = Images["icons/menu/scanqr"],
				standardSize = StandardButtonSize.Regular,
				isLoading = v68
			}
		})
	end

	local v80 = not FFlagAuthSecExclusions or (not t1.excludeEmailPasswordSignIn or (not t1.excludePhoneNumberPasswordSignIn or not t1.excludeUsernamePasswordSignIn))

	if (fido2Supported or not initialStateUpdated) and not t1.excludePasskeyLogin then
		table.insert(t5, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 530
					-- upvalues: authButtonClick (copy), EventStreamConstants (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), v71 (copy), v60 (copy), LoginActionType (copy), utils (copy), t3 (copy)
					authButtonClick(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Button.UsePasskey, nil, nil)

					if FFlagEnableNavigateToLoginAfterLogoutAll and v71 ~= "" then
						v60.dispatch({
							type = LoginActionType.SetUserIdentifierAndType,
							data = {
								userIdentifier = v71,
								userIdentifierType = getUserIdentifierType(v71)
							}
						})
					end

					utils.showPasskeyLoginPopup(t3, false, false)
				end,
				text = v78.usePasskeyActionText,
				icon = Images["icons/menu/passkey"],
				standardSize = StandardButtonSize.Regular,
				isLoading = not initialStateUpdated or v68
			}
		})
	end

	local v81 = if not t1.disableLoginForgotButton then React.createElement(NeedHelpButton, {
		layoutOrder = 10,
		textKey = "Authentication.Login.Action.ForgotUsername",
		isDisabled = v68,
		originPage = EventStreamConstants.Context.LoginFormV2Username,
		identifierAutofill = v71
	}) else nil
	local v82 = #t5 > 0

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v63.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v64.Size.Size_200),
			PaddingLeft = UDim.new(0, v64.Size.Size_200),
			PaddingRight = UDim.new(0, v64.Size.Size_200),
			PaddingBottom = UDim.new(0, v64.Size.Size_200)
		}),
		Wrapper = React.createElement(not FFlagFixLoginV2LandscapeLayout and "Frame" or "ScrollingFrame", if not FFlagFixLoginV2LandscapeLayout then {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		} else {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = if not FFlagFixLoginV2LandscapeLayout then nil else Enum.HorizontalAlignment.Center
			}),
			Header = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				BackButton = React.createElement(IconButton, {
					icon = Images["icons/navigation/close"],
					onActivated = function() -- line: 611
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v60 (copy)
						authButtonClick(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Button.Back)
						v60.parentNavigation.goBack()
					end,
					size = UDim2.new(0, 36, 0, 36),
					isDisabled = v68
				}),
				SignInHeadingFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = React.createElement(StyledTextLabel, {
						text = v78.signInHeadingText,
						fontStyle = v63.Font.Header1,
						colorStyle = v63.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UISizeConstraint = FFlagFixLoginV2LandscapeLayout and React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Constants.CONTENT_MAX_WIDTH, 1e999)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v64.Size.Size_200),
					PaddingRight = UDim.new(0, v64.Size.Size_200),
					PaddingBottom = if not FFlagFixLoginV2LandscapeLayout then nil else UDim.new(0, v64.Size.Size_800)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v64.Size.Size_50)
				}),
				SignInHeadingSpacing = v80 and React.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64.Size.Size_800)
				}),
				IdentifierLabel = v80 and React.createElement(StyledTextLabel, {
					layoutOrder = 3,
					text = v78.identifierLabelText,
					fontStyle = v63.Font.Body,
					colorStyle = v63.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY
				}),
				IdentifierLabelSpacing = v80 and React.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64.Size.Size_100)
				}),
				UserIdentifierTextField = v80 and React.createElement(TextInput, {
					LayoutOrder = 5,
					label = "",
					text = v70,
					width = UDim.new(1, 0),
					textInputType = Enum.TextInputType.Username,
					onChanged = function(p16) -- line: 681
						-- upvalues: v73 (copy), v67 (copy), v72 (copy)
						if v73 ~= "" then
							v67({
								errorKey = ""
							})
						end

						v72(p16)
					end,
					onFocusGained = function() -- line: 688
						-- upvalues: authFormInteraction (copy), EventStreamConstants (copy), v71 (copy)
						authFormInteraction(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Field.Username, nil, nil, #v71 > 0)
					end,
					isDisabled = v68
				}),
				ErrorTextSpacing = v80 and (v78.errorText and React.createElement("Frame", {
					LayoutOrder = 6,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64.Size.Size_100)
				})),
				ErrorTextLabel = v80 and (v78.errorText and React.createElement(StyledTextLabel, {
					layoutOrder = 7,
					textWrapped = true,
					text = v78.errorText,
					fontStyle = v63.Font.BodySmall,
					colorStyle = v63.Theme.Alert,
					automaticSize = Enum.AutomaticSize.XY
				})),
				NextButtonSpacing = v80 and React.createElement("Frame", {
					LayoutOrder = 8,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64.Size.Size_400)
				}),
				NextButton = v80 and React.createElement(Button, {
					layoutOrder = 9,
					standardSize = StandardButtonSize.Regular,
					buttonType = ButtonType.PrimaryContextual,
					text = v78.nextActionText,
					buttonTextOverride = Constants.getButtonTextOverrideConfig(),
					onActivated = function() -- line: 727
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v74 (copy)
						authButtonClick(EventStreamConstants.Context.LoginFormV2Username, EventStreamConstants.Button.Next, nil, nil)
						v74()
					end,
					isDisabled = v71 == "",
					isLoading = v68
				}),
				HelpButton = v80 and v81,
				AlternativeLoginDivider = v82 and (v80 and React.createElement("Frame", {
					LayoutOrder = 11,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					DividerText = React.createElement(StyledTextLabel, {
						layoutOrder = 1,
						text = v78.orText,
						fontStyle = v63.Font.Header2,
						colorStyle = v63.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})),
				Spacing = React.createElement("Frame", {
					LayoutOrder = 12,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v64.Size.Size_400)
				}),
				AlternativeLoginButtonFrame = React.createElement("Frame", {
					LayoutOrder = 13,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					AlternativeLoginButtons = React.createElement(ButtonStack, {
						forcedFillDirection = Enum.FillDirection.Vertical,
						buttons = t5
					})
				})
			})
		})
	})
end

return LoginScreenV2
