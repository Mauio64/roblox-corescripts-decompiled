local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFz")
local module3 = require("@luauforge/bundled/fFx")
local module4 = require("@luauforge/bundled/fFm")
local module5 = require("@luauforge/bundled/fCs")
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useDispatch

local useRoactService = require("@luauforge/bundled/fFD").useRoactService
local module6 = require("@luauforge/bundled/fCw")
local module7 = require("@luauforge/bundled/fCy")
local module8 = require("@luauforge/bundled/fCm")
local module9 = require("@luauforge/bundled/fFA")

local roactNetworking = require("@luauforge/bundled/fFE").RoactNetworking

local authPageload = module4.Events.authPageload
local authFormInteraction = module4.Events.authFormInteraction
local authButtonClick = module4.Events.authButtonClick
local authClientError = module4.Events.authClientError
local authModalShown = module4.Events.authModalShown
local eventStreamConstants = module4.EventStreamConstants

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local module10 = require("@luauforge/bundled/fFF")
local module11 = require("@luauforge/bundled/fFs")
local module12 = require("@luauforge/bundled/fFL")
local module13 = require("@luauforge/bundled/fFM")
local module14 = require("@luauforge/bundled/fFt")
local module15 = require("@luauforge/bundled/fFO")
local module16 = require("@luauforge/bundled/fFP")
local module17 = require("@luauforge/bundled/fFl")
local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens
local useStyle = module17.Core.Style.useStyle
local button = module17.App.Button.Button
local buttonType = module17.App.Button.Enum.ButtonType
local buttonStack = module17.App.Button.ButtonStack
local iconButton = module17.App.Button.IconButton
local images = module17.App.ImageSet.Images
local standardButtonSize = module17.App.Button.Enum.StandardButtonSize
local styledTextLabel = module17.App.Text.StyledTextLabel

local module18 = require("@luauforge/bundled/fFp")
local textInput = module18.TextInput
local text = module18.Text
local button2 = module18.Button
local iconButton2 = module18.IconButton
local view = module18.View
local progress = module18.Progress
local buttonVariant = module18.Enums.ButtonVariant
local inputSize = module18.Enums.InputSize
local iconName = module18.Enums.IconName
local progressShape = module18.Enums.ProgressShape
local progressSize = module18.Enums.ProgressSize

local module19 = require("@luauforge/bundled/fHd")
local default = module19.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module19.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local module20 = require("@luauforge/bundled/fFu")

local fFlagEnableLastLoginMethodTracking = module20.FFlagEnableLastLoginMethodTracking
local fFlagEnableLoginV2Modalization = module20.FFlagEnableLoginV2Modalization
local fFlagLoginV2SubmitOnKeyboardReturn = module20.FFlagLoginV2SubmitOnKeyboardReturn

local module21 = require("@luauforge/bundled/fHB")
local module22 = require("@luauforge/bundled/fHC")
local module23 = require("@luauforge/bundled/fHD")
local module24 = require("@luauforge/bundled/fFZ")

local module25 = require("@luauforge/bundled/fGa")
local module26 = require("@luauforge/bundled/fFK")

local module27 = require("@luauforge/bundled/fHE")
local module28 = require("@luauforge/bundled/fHF")
local module29 = require("@luauforge/bundled/fHG")
local module30 = require("@luauforge/bundled/fFv")

local module31 = require("@luauforge/bundled/fFQ")
local module32 = require("@luauforge/bundled/fHH")
local module33 = require("@luauforge/bundled/fCx")
local module34 = require("@luauforge/bundled/fFq")
local module35 = require("@luauforge/bundled/fCg")
local module36 = require("@luauforge/bundled/fCC")

local isStringEmail = module5.Utils.isStringEmail
local isStringPhone = module5.Utils.isStringPhone
local getLinkedPlatformAccountName = module5.Utils.getLinkedPlatformAccountName
local crossDeviceLogin = module5.Thunks.CrossDeviceLogin
local apiFetchAuthMetaData = module5.Thunks.ApiFetchAuthMetaData
local appStorageUtilities = module5.Utils.AppStorageUtilities
local loginMethods = module5.Enums.LoginMethods
local isIosAuthServiceEnabled = module5.Utils.isIosAuthServiceEnabled

local logger = require("@luauforge/bundled/fCu").Logger
local default2 = require("@luauforge/bundled/fHl").default
local telemetryConfigs = require("@luauforge/bundled/fFm").TelemetryConfigs

local v5 = {
	disableLoginForgotButton = false,
	excludeUsernamePasswordSignIn = false,
	excludeEmailPasswordSignIn = false,
	excludePhoneNumberPasswordSignIn = false,
	excludePasskeyLogin = false,
	excludeCrossDeviceSignIn = false,
	excludeExternalIdentityOtherSignInOptions = true
}

function LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(p2)
	if isStringEmail(p2) then
		return module8.Email
	end

	if isStringPhone(p2) then
		return module8.Phone
	end

	return module8.Username
end

local function namesAnAccount(p2): boolean
	return p2 ~= nil and p2.forcedUsernameOverride ~= nil and p2.forcedUsernameOverride ~= ""
end

function LUAUFORGE_MODULE_GLOBALS_fHA_LoginScreenV2(p2)
	local v6 = module.useContext(module34)
	local utils = v6.utils
	local state = v6.state

	local v7 = nil

	local function reportAuthPageload(p3, p4, p5, p6)
		authPageload(p3, p4, p5, p6 or v6.eventOrigin)
	end

	local function reportAuthFormInteraction(p3, p4, p5, p6, p7)
		authFormInteraction(p3, p4, p5, p6 or v6.eventOrigin, p7)
	end

	local function reportAuthButtonClick(p3, p4, p5, p6, p7, p8, p9)
		authButtonClick(p3, p4, p5 or v7, p6, p7, p8 or v6.eventOrigin, p9)
	end

	local function reportAuthClientError(p3, p4, p5, p6)
		authClientError(p3, p4, p5, p6 or v6.eventOrigin)
	end

	local function reportAuthModalShown(p3, p4, p5, p6)
		if not p4 then
			p4 = if module30 then eventStreamConstants.ActionType.Shown else nil
		end

		authModalShown(p3, p4, p5, p6 or v6.eventOrigin)
	end

	local v8 = useStyle()
	local v9 = useDesignTokens()
	local v10 = if v6.isDialogLayoutForced then module12(v9) else nil
	local v11 = useDispatch()
	local v12 = useRoactService(roactNetworking)

	local v13 = if fFlagEnableLoginV2Modalization then module11() else false

	local v15 = (if module28 then module5.Experiments.useAuthEntryVariant() ~= module5.Experiments.AuthEntryVariant.Control else false)
		and not v13

	local v16 = v13 or v15
	local v17 = v13 and "dialog" or v15 and "compactFoundation" or "fullscreen"
	v7 = if module30 then v17 else nil
	local v18 = if v13 then inputSize.Medium else inputSize.Large

	local v19 = module9.useAppPolicy(function(data)
		v5.disableLoginForgotButton = data.getDisableLoginForgotButton()
		v5.excludeUsernamePasswordSignIn = data.getExcludeUsernamePasswordSignIn()
		v5.excludeEmailPasswordSignIn = data.getExcludeEmailPasswordSignIn()
		v5.excludePhoneNumberPasswordSignIn = data.getExcludePhoneNumberPasswordSignIn()
		v5.excludePasskeyLogin = data.getExcludePasskeyLogin()
		v5.excludeCrossDeviceSignIn = data.getExcludeCrossDeviceSignIn()

		if module27 then
			v5.excludeExternalIdentityOtherSignInOptions = data.getExcludeExternalIdentityOtherSignInOptions()
		end

		if v6.isDialogLayoutForced then
			return (getLinkedPlatformAccountName(data))
		end

		return nil
	end)

	local function fn(p3)
		v6.dispatch({
			type = module7.SetComponentState,
			data = { component = module33.LoginScreenV2, payload = p3 }
		})
	end

	local state2, setState = module.useState(false)
	local state3, setState2

	if module23 then
		state3, setState2 = module.useState(false)
	else
		state3 = false

		setState2 = function(p3) end
	end

	local userIdentifier = state and state.componentState[module33.LoginScreenV2].userIdentifier or ""

	local state4, setState3 = module.useState(userIdentifier)

	local ref = module.useRef(nil)

	local state5, setState4 = module.useState(function()
		local v20 = module24 and v13

		if v20 then
			if state.shouldAutoShowCredentialPopup == true then
				v20 = not state.credentialsProtocolStatus.initialStateUpdated
			else
				v20 = false
			end
		end

		return v20
	end)

	local v20, v21, v22 = module13(ref, v13 and not (state5 or state3))

	local fn2
	local v23, v24 = module14(function()
		fn2()
	end, fFlagLoginV2SubmitOnKeyboardReturn and v13, v21)

	local function fn3()
		task.delay(0.1, function()
			setState4(false)
		end)
	end

	module.useEffect(function()
		if module24 and state5 then
			local v25 = false
			task.delay(module25, function()
				if not v25 then
					setState4(false)
				end
			end)

			return function()
				v25 = true
			end
		end
	end, { state5 })

	local errorKey = state and state.componentState[module33.LoginScreenV2].errorKey or ""

	local function fn4(p3)
		local v25 = p3 or state4

		if
			state
			and state.extraProps
			and state.extraProps.forcedUsernameOverride
			and state.extraProps.forcedUsernameOverride ~= ""
		then
			v25 = state.extraProps.forcedUsernameOverride

			v6.dispatch({ type = module7.ClearForcedUsernameOverride })
		end

		setState(true)
		fn({ userIdentifier = v25 })

		setState3(v25)
		local dispatch = v6.dispatch
		local v26 = { type = module7.SetUserIdentifierAndType, data = 0 }
		local v27 = { userIdentifier = v25, userIdentifierType = 0 }

		local v28 = if state.forceLoginByUsername then module8.Username else LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(v25)
		v27.userIdentifierType = v28
		v26.data = v27
		dispatch(v26)

		local v29 = v25
		v11(module35(v12, {
			cvalue = v29,
			ctype = LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(v29)
		})):andThen(
			function(p4)
				local mapped = module2.List.map(p4.loginMethods, function(p5)
					return module6[p5.method]
				end)

				local dispatch2 = v6.dispatch
				local v30 = { type = module7.SetUserIdentifierAndType, data = 0 }
				local v31 = { userIdentifier = v25, userIdentifierType = 0 }

				local v32 = if state.forceLoginByUsername then module8.Username else LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(v25)
				v31.userIdentifierType = v32
				v30.data = v31
				dispatch2(v30)

				v6.dispatch({ type = module7.SetAvailableLoginMethods, data = mapped })

				if p3 == nil then
					v6.dispatch({
						type = module7.UpdateCredentialsProtocolStatus,
						data = { shouldShowAuthScreenUserSpecificPasskeyPopup = true }
					})
				else
					v6.dispatch({
						type = module7.UpdateCredentialsProtocolStatus,
						data = { shouldShowAuthScreenCredentialsPopup = true }
					})
				end

				fn({ errorKey = "" })

				setState(false)
				setState2(false)
				p2.navigation.navigate(module33.AuthenticationScreen)
			end,
			function(p4)
				logger:warning("Error initializing login: {}", HttpService:JSONEncode(p4))
				authClientError(
					eventStreamConstants.Context.LoginFormV2Username,
					p4.errorCode,
					nil,
					v6.eventOrigin
				)
				local errorKey2 = p4.errorKey or "Authentication.Login.Response.SomethingWentWrong"
				fn({ errorKey = errorKey2 })

				setState(false)
				setState2(false)
			end
		)
	end

	local v25 = {
		setInProgress = setState,
		setErrorKey = function(p3)
			fn({ errorKey = p3 })
		end,
		navigation = p2.navigation,
		isLoginByOtp = false,
		eventContext = eventStreamConstants.Context.LoginFormV2Username,
		eventOrigin = v6.eventOrigin
	}
	local v26

	if module27 then
		v26 = module32(v5.excludeExternalIdentityOtherSignInOptions, function()
			fn({ errorKey = "Authentication.Login.Response.SomethingWentWrong" })
		end)
	end

	module.useEffect(function()
		if state and state.componentState[module33.LoginScreenV2].shouldAttemptCredentialPrefill then
			local accountBlob = appStorageUtilities.getAccountBlob()
			local defaultUsername = appStorageUtilities.getDefaultUsername()
			local v27 = accountBlob and accountBlob ~= ""
			local v28 = defaultUsername and defaultUsername ~= ""

			if state.extraProps and state.extraProps.forcedUsernameOverride then
				v28 = state.extraProps.forcedUsernameOverride ~= ""
			elseif v28 then
				v28 = not v27 and state4 == ""
			end

			if v28 then
				local defaultUsername2 = appStorageUtilities.getDefaultUsername()
				authButtonClick(
					eventStreamConstants.Context.LoginFormV2Username,
					eventStreamConstants.Button.PrefilledNext,
					v7,
					nil,
					nil,
					v6.eventOrigin,
					nil
				)

				if
					fFlagEnableLastLoginMethodTracking
					and appStorageUtilities.getLastSuccessfulSignInMethod() == loginMethods.QuickLogin
				then
					local v29 = module21

					if v29 then
						local extraProps = state.extraProps

						if extraProps == nil or extraProps.forcedUsernameOverride == nil then
							v29 = false
						else
							v29 = extraProps.forcedUsernameOverride ~= ""
						end
					end

					if not v29 then
						fn({ userIdentifier = defaultUsername2 })

						setState3(defaultUsername2)
						v6.dispatch({
							type = module7.SetUserIdentifierAndType,
							data = {
								userIdentifier = defaultUsername2,
								userIdentifierType = LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(defaultUsername2)
							}
						})
						return
					end
				end

				if module23 and v13 then
					setState2(true)
				end

				fn4(defaultUsername2)
			end
		end
	end, {})

	module.useEffect(function()
		default2:logRobloxTelemetryCounter(telemetryConfigs.LoginPageMountTelemetryConfig, 1, {
			version = 2
		})

		local jsonEncode = HttpService:JSONEncode({
			isAuthenticated = utils.isUserAuthenticated(),
			isCompactFoundation = if module30 then v15 else nil,
			layout = if module30 then v17 else nil
		})
		apiFetchAuthMetaData(v12):andThen(function(p3)
			local isAltBrowserTracker = p3 and p3.IsAltBrowserTracker
			authPageload(
				eventStreamConstants.Context.LoginFormV2Username,
				jsonEncode,
				isAltBrowserTracker,
				v6.eventOrigin
			)
		end, function(p3)
			logger:warning("Error auth metadata: {}", p3)
			authPageload(eventStreamConstants.Context.LoginFormV2Username, jsonEncode, nil, v6.eventOrigin)
		end)
	end, {})

	local initialStateUpdated = state.credentialsProtocolStatus.initialStateUpdated
	local v27 = state.credentialsProtocolStatus.fido2Supported

	module.useEffect(function()
		if initialStateUpdated or not state.shouldAutoShowCredentialPopup then
			return
		end

		local function fn5(data)
			local v28 = false
			local v29 = false
			local v30

			if data.FIDO2 == nil then
				v30 = data.isAvailable and data.supportsDeviceBoundOnly or false
			else
				v30 = data.FIDO2.isAvailable and data.FIDO2.supportsDeviceBoundOnly
				v28 = data.password and data.password.isAvailable

				v29 = data.password ~= nil
			end

			if v5.excludePasskeyLogin then
				v30 = false
			end

			authPageload(
				eventStreamConstants.Context.PasskeyLoginV2,
				v30 == nil and "timeout" or tostring(v30),
				nil,
				v6.eventOrigin
			)

			v6.dispatch({
				type = module7.UpdateCredentialsProtocolStatus,
				data = {
					fido2Supported = v30,
					passwordsSupported = v28,
					v2InterfaceSupported = v29
				}
			})

			v6.dispatch({ type = module7.SetCredentialAutoPopupShown })
			local v32, v33, v34, v35, v36, v37

			if appStorageUtilities.getLastSuccessfulSignInMethod() == loginMethods.QuickLogin then
				local v38 = module21

				if v38 then
					local extraProps = state.extraProps

					if extraProps == nil or extraProps.forcedUsernameOverride == nil then
						v38 = false
					else
						v38 = extraProps.forcedUsernameOverride ~= ""
					end
				end

				v32 = not v38

				if not v32 then
					v33 = appStorageUtilities.getAccountBlob()
					v34 = appStorageUtilities.getDefaultUsername()
					v35 = v33 and v33 ~= ""
					v36 = v34 and v34 ~= ""

					if state.extraProps and state.extraProps.forcedUsernameOverride then
						v36 = state.extraProps.forcedUsernameOverride ~= ""
					elseif v36 then
						v37 = v35 or state4 ~= ""
						v36 = not v37
					end

					v32 = not v36
				end
			else
				v33 = appStorageUtilities.getAccountBlob()
				v34 = appStorageUtilities.getDefaultUsername()
				v35 = v33 and v33 ~= ""
				v36 = v34 and v34 ~= ""

				if state.extraProps and state.extraProps.forcedUsernameOverride then
					v36 = state.extraProps.forcedUsernameOverride ~= ""
				elseif v36 then
					v37 = v35 or state4 ~= ""
					v36 = not v37
				end

				v32 = not v36
			end

			local v38 = nil

			if v32 then
				local v39

				if v13 then
					local join = module2.Dictionary.join
					local v42

					if module24 then
						v42 = fn3
					else
						v42 = function()
							task.delay(0.1, v22)
						end
					end

					v39 = join(v25, { onCredentialsPopupAbandoned = v42 })
				else
					v39 = v25
				end

				if v29 then
					v38 = utils.showGenericCredentialLoginPopup(v30, v28, false, v39)
				elseif v30 then
					v38 = utils.showPasskeyLoginPopup(v39, false, true)
				elseif isIosAuthServiceEnabled() then
					default2:logRobloxTelemetryCounter(
						telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
						1,
						{ errorCode = "protocolNotSupported" }
					)
				end
			end

			if module24 and v13 and v38 == nil then
				setState4(false)
			end
		end

		local extraProps = state.extraProps

		if
			extraProps.credProtocolIsAvailableResponse
			and extraProps.credProtocolIsAvailableResponse.isAvailable ~= nil
		then
			logger:info(
				"Using prefetched credentials protocol response: {}",
				HttpService:JSONEncode(extraProps.credProtocolIsAvailableResponse)
			)
			authPageload(eventStreamConstants.Context.LoginRevampIsAvailableFetch, "0", nil, v6.eventOrigin)
			fn5(extraProps.credProtocolIsAvailableResponse)
		else
			local lastTime = os.clock()

			default:isAvailable(
				default.CredentialsTypes.FIDO2,
				getFIntLuaAppCredentialsProtocolAvailableTimeout()
			):andThen(function(p3)
				authPageload(
					eventStreamConstants.Context.LoginRevampIsAvailableFetch,
					tostring(os.clock() - lastTime),
					nil,
					v6.eventOrigin
				)

				fn5(p3)
			end):catch(function(p3)
				v6.dispatch({
					type = module7.UpdateCredentialsProtocolStatus,
					data = {
						fido2Supported = false,
						passwordsSupported = false,
						v2InterfaceSupported = false
					}
				})

				if module24 and v13 then
					setState4(false)
				end

				logger:warning("Error checking for available credential types. Error: {}", p3)

				if isIosAuthServiceEnabled() then
					local v28, v29, v30, v31, v32, v33

					if appStorageUtilities.getLastSuccessfulSignInMethod() == loginMethods.QuickLogin then
						local v34 = module21

						if v34 then
							local extraProps2 = state.extraProps

							if extraProps2 == nil or extraProps2.forcedUsernameOverride == nil then
								v34 = false
							else
								v34 = extraProps2.forcedUsernameOverride ~= ""
							end
						end

						v28 = not v34

						if not v28 then
							v29 = appStorageUtilities.getAccountBlob()
							v30 = appStorageUtilities.getDefaultUsername()
							v31 = v29 and v29 ~= ""
							v32 = v30 and v30 ~= ""

							if state.extraProps and state.extraProps.forcedUsernameOverride then
								v32 = state.extraProps.forcedUsernameOverride ~= ""
							elseif v32 then
								v33 = v31 or state4 ~= ""
								v32 = not v33
							end

							v28 = not v32
						end
					else
						v29 = appStorageUtilities.getAccountBlob()
						v30 = appStorageUtilities.getDefaultUsername()
						v31 = v29 and v29 ~= ""
						v32 = v30 and v30 ~= ""

						if state.extraProps and state.extraProps.forcedUsernameOverride then
							v32 = state.extraProps.forcedUsernameOverride ~= ""
						elseif v32 then
							v33 = v31 or state4 ~= ""
							v32 = not v33
						end

						v28 = not v32
					end

					if v28 then
						default2:logRobloxTelemetryCounter(
							telemetryConfigs.IosAuthServiceLoginCredentialSheetUnavailableConfig,
							1,
							{ errorCode = "protocolUnavailable" }
						)
					end
				end
			end)
		end
	end, {})

	local v29 = {
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		signInWithRobloxHeadingText = "Authentication.Login.Heading.SignInWithRoblox",
		identifierLabelText = v5.excludeEmailPasswordSignIn and v5.excludePhoneNumberPasswordSignIn and "Authentication.Login.Label.Username" or v5.excludeEmailPasswordSignIn and v5.excludeUsernamePasswordSignIn and "Authentication.Login.Label.Phone" or v5.excludeUsernamePasswordSignIn and v5.excludePhoneNumberPasswordSignIn and "Authentication.Login.Label.Email" or v5.excludeEmailPasswordSignIn and "Authentication.Login.Label.UsernameOrPhone" or v5.excludeUsernamePasswordSignIn and "Authentication.Login.Label.EmailOrPhone" or v5.excludePhoneNumberPasswordSignIn and "Authentication.Login.Label.UsernameOrEmail" or "Authentication.Login.Label.UsernameEmailOrPhoneNumber",
		orText = "Authentication.SignUp.Description.Or",
		nextActionText = "Authentication.Login.Action.Next",
		continueActionText = "Authentication.Login.Action.Continue",
		quickSignInActionText = "Authentication.Login.Action.QuickSignIn",
		signInWithQrCodeActionText = "Authentication.Login.Action.SignInWithQrCode",
		qrCodeActionText = (v15 or v6.isDialogLayoutForced) and "Authentication.Login.Action.QrCode" or nil,
		usePasskeyActionText = "Authentication.Login.Action.UsePasskey",
		passkeyIncompatibleText = "Authentication.Login.Label.PasskeyIncompatible",
		enterHerePlaceholderText = "Authentication.Login.Label.EnterHere",
		errorText = 0,
		linkAccountText = 0
	}
	local v30 = if errorKey ~= "" then errorKey else nil
	v29.errorText = v30
	v29.linkAccountText = v19 and {
		"Authentication.Login.Label.LinkAccountWarning",
		platform = v19
	} or nil
	local v31 = useLocalization(v29)

	local v32 = {}

	if not v5.excludeCrossDeviceSignIn then
		local v33 = {
			buttonType = buttonType.Secondary,
			foundationIcon = iconName.SquaresGridQr,
			foundationText = 0,
			props = 0
		}
		local v34 = if v15 or v6.isDialogLayoutForced then v31.qrCodeActionText else v31.signInWithQrCodeActionText
		v33.foundationText = v34

		v33.props = {
			onActivated = function()
				authButtonClick(
					eventStreamConstants.Context.LoginFormV2Username,
					eventStreamConstants.Button.QuickLogin,
					v7,
					nil,
					nil,
					v6.eventOrigin,
					nil
				)

				if module26() and v13 then
					local loginFormV2Username2 = eventStreamConstants.Context.LoginFormV2Username

					local loginV2QuickLoginModal = eventStreamConstants.Field.LoginV2QuickLoginModal
					local v35 = if module30 then eventStreamConstants.ActionType.Shown else nil
					authModalShown(loginFormV2Username2, v35, loginV2QuickLoginModal, v6.eventOrigin)
				end

				v11(crossDeviceLogin.OpenLoginCodePrompt({
					loginCallback = function(p3, p4, p5, p6)
						utils.handleLoginWithCode(p3, p4, p5, p6, v25)
					end,
					isOverlay = true,
					useFoundationSheet = v13,
					renderNeedHelpButton = v13 and function(p3)
						return module.createElement(module34.Provider, { value = v6 }, {
							Button = module.createElement(module31, {
								name = "HavingTroubleLink",
								layoutOrder = 2,
								originPage = eventStreamConstants.Context.LoginFormV2Username,
								textKey = "Authentication.Login.Label.TroubleSigningIn",
								identifierAutofill = state4,
								contentStartRef = p3.contentStartRef,
								onBeforeActivated = p3.onBeforeActivated
							})
						})
					end or nil,
					onLeaveLogin = v13 and function()
						local loginFormV2Username2 = eventStreamConstants.Context.LoginFormV2Username
						local v35 = if module26() then eventStreamConstants.Button.DismissSheet else eventStreamConstants.Button.DismissCornerX
						authButtonClick(loginFormV2Username2, v35, v7, nil, nil, v6.eventOrigin, nil)

						v6.parentNavigation.goBack()
					end or nil,
					onReturnToLogin = module26() and v13 and function()
						authButtonClick(
							eventStreamConstants.Context.LoginFormV2Username,
							eventStreamConstants.Button.QuickLoginBack,
							v7,
							nil,
							nil,
							v6.eventOrigin,
							nil
						)
					end or nil
				}))
			end,
			text = v31.quickSignInActionText,
			icon = images["icons/menu/scanqr"],
			standardSize = standardButtonSize.Regular,
			isLoading = state2
		}
		table.insert(v32, v33)
	end

	local v33 = not (v5.excludeEmailPasswordSignIn and v5.excludePhoneNumberPasswordSignIn and v5.excludeUsernamePasswordSignIn)

	if not module22 then
		v27 = v27 or not initialStateUpdated
	end

	if v27 and not v5.excludePasskeyLogin then
		local v34 = {
			buttonType = buttonType.Secondary,
			foundationIcon = iconName.Key,
			props = 0
		}
		local v35 = {
			onActivated = function()
				authButtonClick(
					eventStreamConstants.Context.LoginFormV2Username,
					eventStreamConstants.Button.UsePasskey,
					v7,
					nil,
					nil,
					v6.eventOrigin,
					nil
				)

				if state4 ~= "" then
					v6.dispatch({
						type = module7.SetUserIdentifierAndType,
						data = {
							userIdentifier = state4,
							userIdentifierType = LUAUFORGE_MODULE_GLOBALS_fHA_getUserIdentifierType(state4)
						}
					})
				end

				utils.showPasskeyLoginPopup(v25, false, false)
			end,
			text = v31.usePasskeyActionText,
			icon = images["icons/menu/passkey"],
			standardSize = standardButtonSize.Regular,
			isLoading = 0
		}
		local v36 = if module22 then state2 else not initialStateUpdated or state2
		v35.isLoading = v36
		v34.props = v35
		table.insert(v32, v34)
	end

	if v26 then
		table.insert(v32, not v13 and 1 or #v32 + 1, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = v26.open,
				text = v26.text,
				standardSize = standardButtonSize.Regular,
				isLoading = state2
			}
		})
	end

	local v34

	if not v5.disableLoginForgotButton then
		v34 = module.createElement(module31, {
			layoutOrder = 11,
			isDisabled = state2,
			originPage = eventStreamConstants.Context.LoginFormV2Username,
			textKey = v16 and "Authentication.Login.Action.ForgotUsernameOrPassword" or "Authentication.Login.Action.ForgotUsername",
			identifierAutofill = state4,
			useFoundation = v15
		})
	end

	local v35 = #v32 > 0

	local function onHeaderClose()
		local loginFormV2Username = eventStreamConstants.Context.LoginFormV2Username
		local v36 = if module26() then eventStreamConstants.Button.DismissCornerX else eventStreamConstants.Button.Back
		authButtonClick(loginFormV2Username, v36, v7, nil, nil, v6.eventOrigin, nil)

		v6.parentNavigation.goBack()
	end

	local function onSheetDismiss()
		if module26() then
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2Username,
				eventStreamConstants.Button.DismissSheet,
				v7,
				nil,
				nil,
				v6.eventOrigin,
				nil
			)

			v6.parentNavigation.goBack()
		else
			local loginFormV2Username = eventStreamConstants.Context.LoginFormV2Username
			local v36 = if module26() then eventStreamConstants.Button.DismissCornerX else eventStreamConstants.Button.Back
			authButtonClick(loginFormV2Username, v36, v7, nil, nil, v6.eventOrigin, nil)

			v6.parentNavigation.goBack()
		end
	end

	local v36

	if v15 then
		v36 = module.createElement(iconButton2, {
			icon = iconName.ChevronLargeLeft,
			variant = buttonVariant.Utility,
			size = inputSize.Medium,
			isCircular = true,
			onActivated = onHeaderClose,
			isDisabled = state2
		})
	else
		v36 = module.createElement(iconButton, {
			icon = images["icons/navigation/close"],
			onActivated = onHeaderClose,
			size = UDim2.new(0, 36, 0, 36),
			isDisabled = state2
		})
	end

	local v37

	if v13 then
		local createElement = module.createElement

		local v40 = if v6.isDialogLayoutForced then v31.signInHeadingText else v31.signInWithRobloxHeadingText
		local v41 = if v10 then v10.titleTopOffset else nil
		v37 = createElement(module15, {
			layoutOrder = 1,
			titleText = v40,
			titleTopOffset = v41,
			icon = iconName.X,
			onActivated = onHeaderClose,
			isDisabled = state2
		})
	else
		v37 = module.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				BackButton = v36,
				SignInHeadingFrame = module.createElement("Frame", {
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = module.createElement(styledTextLabel, {
						text = v31.signInHeadingText,
						fontStyle = v8.Font.Header1,
						colorStyle = v8.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}
		)
	end

	local v38 = not v13

	local element = module.createElement(styledTextLabel, {
		layoutOrder = 3,
		text = v31.identifierLabelText,
		fontStyle = v8.Font.Body,
		colorStyle = v8.Theme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.XY
	})
	local v39

	if v16 then
		v39 = module.createElement(text, {
			LayoutOrder = 7,
			Text = v31.errorText,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert"
		})
	else
		v39 = module.createElement(styledTextLabel, {
			layoutOrder = 7,
			text = v31.errorText,
			fontStyle = v8.Font.BodySmall,
			colorStyle = v8.Theme.Alert,
			automaticSize = Enum.AutomaticSize.XY,
			textWrapped = true
		})
	end

	fn2 = function()
		if state4 == "" or state2 then
			return
		end

		authButtonClick(
			eventStreamConstants.Context.LoginFormV2Username,
			eventStreamConstants.Button.Next,
			v7,
			nil,
			nil,
			v6.eventOrigin,
			nil
		)

		fn4()
	end

	local v40

	if v16 then
		local createElement = module.createElement

		local v43 = if v13 or module29 then v31.continueActionText else v31.nextActionText
		v40 = createElement(button2, {
			LayoutOrder = 9,
			text = v43,
			variant = buttonVariant.Emphasis,
			size = v18,
			width = UDim.new(1, 0),
			onActivated = fn2,
			isDisabled = state4 == "",
			isLoading = state2
		})
	else
		v40 = module.createElement(button, {
			layoutOrder = 9,
			standardSize = standardButtonSize.Regular,
			buttonType = buttonType.PrimaryContextual,
			text = v31.nextActionText,
			buttonTextOverride = module36.getButtonTextOverrideConfig(),
			onActivated = function()
				authButtonClick(
					eventStreamConstants.Context.LoginFormV2Username,
					eventStreamConstants.Button.Next,
					v7,
					nil,
					nil,
					v6.eventOrigin,
					nil
				)

				fn4()
			end,
			isDisabled = state4 == "",
			isLoading = state2
		})
	end

	local element2 = module.createElement(styledTextLabel, {
		layoutOrder = 1,
		text = v31.orText,
		fontStyle = v8.Font.Header2,
		colorStyle = v8.Theme.TextDefault,
		textXAlignment = Enum.TextXAlignment.Center
	})
	local v41

	if v16 then
		local children = {}

		for k, v42 in v32 do
			local v43 = "AlternativeLoginButton" .. k
			local createElement = module.createElement

			if not v13 then
				k = #v32 - k + 1
			end

			children[v43] = createElement(button2, {
				LayoutOrder = k,
				text = v42.foundationText or v42.props.text,
				icon = v42.foundationIcon,
				variant = buttonVariant.Standard,
				size = v18,
				width = UDim.new(1, 0),
				onActivated = v42.props.onActivated,
				isLoading = v42.props.isLoading
			})
		end

		v41 = module.createElement(view, { tag = "col gap-small size-full-0 auto-y" }, children)
	else
		v41 = module.createElement(buttonStack, {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = v32
		})
	end

	local newUDim = UDim.new
	local v43 = if v15 then v9.Size.Size_300 else v9.Size.Size_200
	local udim = newUDim(0, v43)
	local v44 = if v15 then v9.Size.Size_300 else v9.Size.Size_800

	local v46 = if not v13 then module.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v9.Size.Size_200),
		PaddingLeft = UDim.new(0, v9.Size.Size_200),
		PaddingRight = UDim.new(0, v9.Size.Size_200),
		PaddingBottom = UDim.new(0, v9.Size.Size_200)
	}) else nil

	local createElement = module.createElement
	local v48

	if v38 then
		v48 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BorderSizePixel = 0
		}
	else
		v48 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
	end

	local createElement2 = module.createElement
	local v50 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = 0,
		HorizontalAlignment = 0
	}
	local v51 = if v13 then UDim.new(0, v9.Size.Size_600) else nil
	v50.Padding = v51
	local v52 = if not v13 then Enum.HorizontalAlignment.Center else nil
	v50.HorizontalAlignment = v52
	local children = {
		UIListLayout = createElement2("UIListLayout", v50),
		Header = if not v13 then v37 else nil,
		RememberedAccountLoading = state3 and module.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "size-full-0 auto-y col align-x-center padding-y-xxlarge",
				testId = "login-v2-remembered-account-loading"
			},
			{
				Progress = module.createElement(progress, {
					shape = progressShape.Circle,
					size = progressSize.Large
				})
			}
		),
		Content = 0
	}

	local createElement3 = module.createElement
	local v55 = {
		LayoutOrder = 2,
		Visible = not state3,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		UISizeConstraint = not v13 and module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(module36.CONTENT_MAX_WIDTH, 1e999)
		}),
		UIPadding = 0,
		UIListLayout = 0,
		SignInHeadingSpacing = 0,
		IdentifierLabel = 0,
		IdentifierLabelSpacing = 0,
		UserIdentifierTextField = 0,
		ErrorTextSpacing = 0,
		ErrorTextLabel = 0,
		NextButtonSpacing = 0,
		NextButton = 0,
		HelpButton = 0,
		AlternativeLoginDividerSpacing = 0,
		AlternativeLoginDivider = 0,
		Spacing = 0,
		AlternativeLoginButtonFrame = 0,
		LinkAccountSpacing = 0,
		LinkAccountWarning = 0
	}
	local v56

	if v13 then
		local createElement4 = module.createElement
		local v59 = if v10 then v10.formTopPadding else nil
		v56 = createElement4("UIPadding", {
			PaddingTop = v59,
			PaddingBottom = UDim.new(0, v9.Size.Size_200)
		})
	else
		v56 = module.createElement("UIPadding", {
			PaddingLeft = udim,
			PaddingRight = udim,
			PaddingBottom = UDim.new(0, v9.Size.Size_800)
		})
	end

	children2.UIPadding = v56

	children2.UIListLayout = module.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v16 and 0 or v9.Size.Size_50)
	})

	children2.SignInHeadingSpacing = v33
		and not v13
		and module.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v44),
			BackgroundTransparency = 1
		})

	children2.IdentifierLabel = v33 and not v16 and element
	children2.IdentifierLabelSpacing = v33
		and not v16
		and module.createElement("Frame", {
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_100),
			BackgroundTransparency = 1
		})
	local v57

	if v33 then
		local createElement4 = module.createElement
		local v59 = {
			LayoutOrder = 5,
			text = userIdentifier,
			label = not v16 and "" or v31.identifierLabelText,
			size = 0,
			placeholder = 0,
			width = 0,
			textInputType = 0,
			onChanged = 0,
			onFocusGained = 0,
			onReturnPressed = 0,
			textBoxRef = 0,
			inputRef = 0,
			isDisabled = 0
		}
		local v60 = if v13 then inputSize.Medium else nil
		v59.size = v60

		local v61 = if v16 then v31.enterHerePlaceholderText else nil
		v59.placeholder = v61
		v59.width = UDim.new(1, 0)
		v59.textInputType = Enum.TextInputType.Username
		function v59.onChanged(p3)
			if errorKey ~= "" then
				fn({ errorKey = "" })
			end

			setState3(p3)
		end
		function v59.onFocusGained()
			local loginFormV2Username = eventStreamConstants.Context.LoginFormV2Username
			local username = eventStreamConstants.Field.Username
			local focus = if module30 then eventStreamConstants.ActionType.Focus else nil

			local v62 = #state4 > 0
			authFormInteraction(loginFormV2Username, username, focus, v6.eventOrigin, v62)
		end

		if not fFlagLoginV2SubmitOnKeyboardReturn then
			v24 = if v13 then fn2 else nil
		end

		v59.onReturnPressed = v24

		v59.textBoxRef = v20

		if fFlagLoginV2SubmitOnKeyboardReturn then
			v21 = v23
		end

		v59.inputRef = v21

		v59.isDisabled = state2
		v57 = createElement4(textInput, v59)
	else
		v57 = v33
	end

	children2.UserIdentifierTextField = v57

	children2.ErrorTextSpacing = v33
		and v31.errorText
		and module.createElement("Frame", {
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_100),
			BackgroundTransparency = 1
		})

	children2.ErrorTextLabel = v33 and v31.errorText and v39
	children2.NextButtonSpacing = v33
		and module.createElement("Frame", {
			LayoutOrder = 8,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_400),
			BackgroundTransparency = 1
		})

	children2.NextButton = v33 and v40
	children2.HelpButton = v33 and v34
	children2.AlternativeLoginDividerSpacing = v35
		and v33
		and v16
		and module.createElement("Frame", {
			LayoutOrder = 12,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_200),
			BackgroundTransparency = 1
		})

	if v35 then
		if v33 then
			if v16 then
				v33 = module.createElement(module16, {
					layoutOrder = 13,
					orText = v31.orText
				})
			else
				v33 = module.createElement(
					"Frame",
					{
						LayoutOrder = 13,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					},
					{
						ListLayout = module.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						DividerText = element2
					}
				)
			end
		end
	else
		v33 = v35
	end

	children2.AlternativeLoginDivider = v33

	children2.Spacing = module.createElement("Frame", {
		LayoutOrder = 14,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_400),
		BackgroundTransparency = 1
	})

	children2.AlternativeLoginButtonFrame = module.createElement(
		"Frame",
		{
			LayoutOrder = 15,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{ AlternativeLoginButtons = v41 }
	)

	children2.LinkAccountSpacing = v31.linkAccountText
		and module.createElement("Frame", {
			LayoutOrder = 16,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_400),
			BackgroundTransparency = 1
		})

	children2.LinkAccountWarning = v31.linkAccountText
		and module.createElement(text, {
			LayoutOrder = 17,
			Text = v31.linkAccountText,
			tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left content-muted"
		})
	children.Content = createElement3("Frame", v55, children2)
	local v45 = {
		UIPadding = v46,
		Wrapper = createElement(v38 and "ScrollingFrame" or "Frame", v48, children),
		OtherSignInOptionsDialog = 0
	}

	local v58 = if v26 then v26.dialog else nil
	v45.OtherSignInOptionsDialog = v58

	if not fFlagEnableLoginV2Modalization then
		return module.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = v8.Theme.BackgroundDefault.Color
			},
			v45
		)
	end

	local createElement4 = module.createElement

	if not v13 then
		v37 = nil
	end

	return createElement4(module10, {
		header = v37,
		onClose = onSheetDismiss,
		eventContext = eventStreamConstants.Context.LoginFormV2Username,
		isCoveredByDialog = v26 ~= nil and v26.dialog ~= nil
	}, v45)
end

return LUAUFORGE_MODULE_GLOBALS_fHA_LoginScreenV2
