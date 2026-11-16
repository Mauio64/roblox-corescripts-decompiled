local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFx")
local module3 = require("@luauforge/bundled/fFm")
local module4 = require("@luauforge/bundled/fCs")
local module5 = require("@luauforge/bundled/fFy")
local fFlagEnableLoginV2Modalization = require("@luauforge/bundled/fFu").FFlagEnableLoginV2Modalization
local module6 = require("@luauforge/bundled/fFz")
local module7 = require("@luauforge/bundled/fFA")
local module8 = require("@luauforge/bundled/fFB")
local appBtidLayers = require("@luauforge/bundled/fFC").AppBtidLayers
local module9 = require("@luauforge/bundled/fCw")
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization

local useRoactService = require("@luauforge/bundled/fFD").useRoactService
local useDispatch = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useDispatch
local roactNetworking = require("@luauforge/bundled/fFE").RoactNetworking

local fullscreenPageWithSafeArea = module2.FullscreenPageWithSafeArea
local module10 = require("@luauforge/bundled/fFF")
local module11 = require("@luauforge/bundled/fFs")
local module12 = require("@luauforge/bundled/fFL")
local module13 = require("@luauforge/bundled/fFM")
local module14 = require("@luauforge/bundled/fFO")
local module15 = require("@luauforge/bundled/fFP")
local module16 = require("@luauforge/bundled/fFl")
local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens
local useStyle = module16.Core.Style.useStyle
local iconButton = module16.App.Button.IconButton
local images = module16.App.ImageSet.Images
local toast = module16.App.Dialog.Toast
local styledTextLabel = module16.App.Text.StyledTextLabel

local module17 = require("@luauforge/bundled/fFp")
local text = module17.Text
local button = module17.Button
local buttonVariant = module17.Enums.ButtonVariant
local inputSize = module17.Enums.InputSize
local iconName = module17.Enums.IconName

local module18 = require("@luauforge/bundled/fFk")
local module19 = require("@luauforge/bundled/fFQ")
local module20 = require("@luauforge/bundled/fFS")
local module21 = require("@luauforge/bundled/fCm")
local module22 = require("@luauforge/bundled/fCx")
local module23 = require("@luauforge/bundled/fFq")
local module24 = require("@luauforge/bundled/fCy")
local module25 = require("@luauforge/bundled/fCC")
local module26 = require("@luauforge/bundled/fFV")

local authFormInteraction = module3.Events.authFormInteraction
local authPageload = module3.Events.authPageload
local authButtonClick = module3.Events.authButtonClick
local authModalShown = module3.Events.authModalShown
local eventStreamConstants = module3.EventStreamConstants

local getUserByUsername = module4.Thunks.GetUserByUsername
local crossDeviceLogin = module4.Thunks.CrossDeviceLogin
local appStorageUtilities = module4.Utils.AppStorageUtilities

local defineFastFlag = game:DefineFastFlag("FixAuthScreenOrDividerOrder", false)
local module27 = require("@luauforge/bundled/fFW")
local module28 = require("@luauforge/bundled/fFK")
local module29 = require("@luauforge/bundled/fFX")
local module30 = require("@luauforge/bundled/fFY")
local module31 = require("@luauforge/bundled/fFZ")

local module32 = require("@luauforge/bundled/fGa")
local module33 = require("@luauforge/bundled/fFv")

local function offersCredentialPopupOnMount(p2): boolean
	local credentialsProtocolStatus = p2.credentialsProtocolStatus

	if credentialsProtocolStatus.shouldShowAuthScreenCredentialsPopup then
		return true
	end

	return credentialsProtocolStatus.shouldShowAuthScreenUserSpecificPasskeyPopup == true
		and credentialsProtocolStatus.fido2Supported == true
		and module6.List.find(p2.availableLoginMethods, module9.Passkey) ~= nil
end

local function getCachedUserDetailsFromStorage(p2)
	local success, result = pcall(appStorageUtilities.getPreviousAccountsList)

	if success then
		return module26(result, p2)
	end

	return nil, nil
end

function LUAUFORGE_MODULE_GLOBALS_fFw_AuthenticationScreen(p2)
	local v5 = module.useContext(module23)
	local state = v5.state
	local utils = v5.utils

	local v6 = nil

	local function reportAuthPageload(p3, p4, p5, p6)
		authPageload(p3, p4, p5, p6 or v5.eventOrigin)
	end

	local function reportAuthFormInteraction(p3, p4, p5, p6, p7)
		authFormInteraction(p3, p4, p5, p6 or v5.eventOrigin, p7)
	end

	local function reportAuthButtonClick(p3, p4, p5, p6, p7, p8, p9)
		authButtonClick(p3, p4, p5 or v6, p6, p7, p8 or v5.eventOrigin, p9)
	end

	local function reportAuthModalShown(p3, p4, p5, p6)
		if not p4 then
			p4 = if module33 then eventStreamConstants.ActionType.Shown else nil
		end

		authModalShown(p3, p4, p5, p6 or v5.eventOrigin)
	end

	local v7 = useDesignTokens()
	local v8 = if v5.isDialogLayoutForced then module12(v7) else nil
	local v9 = useStyle()
	local v10 = useRoactService(roactNetworking)

	local v11 = if fFlagEnableLoginV2Modalization then module11() else false
	v6 = if module33 then (if v11 then "dialog" else "fullscreen") else nil
	local v12, v13

	if module27 then
		v12 = useDispatch()
		v13 = module7.useAppPolicy(function(p3)
			return p3.getExcludeCrossDeviceSignIn()
		end)
	else
		v12 = nil
		v13 = false
	end

	local state2, setState = module.useState(nil)
	local state3, setState2 = module.useState(nil)

	local ref = module.useRef(nil)

	local state4, setState3 = module.useState(function()
		local v14 = module31 and v11

		if not v14 then
			return v14
		end

		local v15 = state
		local credentialsProtocolStatus = v15.credentialsProtocolStatus

		if credentialsProtocolStatus.shouldShowAuthScreenCredentialsPopup then
			return true
		end

		if
			credentialsProtocolStatus.shouldShowAuthScreenUserSpecificPasskeyPopup == true
			and credentialsProtocolStatus.fido2Supported == true
		then
			v14 = module6.List.find(v15.availableLoginMethods, module9.Passkey) ~= nil
		else
			v14 = false
		end

		return v14
	end)

	local v14, v15 = module13(ref, v11 and not state4)

	local function fn()
		task.delay(0.1, function()
			setState3(false)
		end)
	end

	module.useEffect(function()
		if module31 and state4 then
			local v16 = false
			task.delay(module32, function()
				if not v16 then
					setState3(false)
				end
			end)

			return function()
				v16 = true
			end
		end
	end, { state4 })

	local v16 = module8.useBrowserTrackerExperiment({ appBtidLayers.LoginLayer }, function(p3)
		return {
			shouldFilterCredentialsForPrefill = (p3[appBtidLayers.LoginLayer] or {}).shouldFilterCredentialsForPrefill or false
		}
	end)

	local function fn2(p3)
		v5.dispatch({
			type = module24.SetComponentState,
			data = { component = module22.AuthenticationScreen, payload = p3 }
		})
	end

	local function fn3(p3)
		v5.dispatch({
			type = module24.SetComponentState,
			data = { component = module22.LoginScreenV2, payload = p3 }
		})
	end

	local errorType

	if state then
		errorType = state.componentState[module22.AuthenticationScreen].errorType or nil
	end

	local errorKey = state and state.componentState[module22.AuthenticationScreen].errorKey or ""

	local function fn4(p3)
		local v17 = { sessionToken = p3 }

		if module27 then
			v17.sentToEnteredEmail = false
		end

		v5.dispatch({
			type = module24.SetComponentState,
			data = { component = module22.EmailOtpScreen, payload = v17 }
		})
	end

	local userIdentifier = state and state.userIdentifier or ""

	local state5, setState4 = module.useState(false)

	module.useEffect(function()
		local v17 = {
			isAuthenticated = utils.isUserAuthenticated(),
			userIdentifierType = state.userIdentifierType,
			authenticationMethods = table.concat(state.availableLoginMethods, ",")
		}

		local loginFormV2Auth = eventStreamConstants.Context.LoginFormV2Auth
		local jsonEncode, v18, v19 = HttpService:JSONEncode(v17)
		authPageload(loginFormV2Auth, jsonEncode, v18, v19 or v5.eventOrigin)
	end, {})

	module.useEffect(function()
		if module29 then
			return
		end

		if state.userIdentifierType == module21.Username then
			getUserByUsername(v10, userIdentifier)():andThen(function(p3)
				setState(p3.id)
				setState2(p3.displayName)
			end):catch(function(p3) end)
		end
	end, {})

	module.useEffect(function()
		if not module29 then
			return
		end

		if state.userIdentifierType == module21.Username then
			local v17 = userIdentifier
			local success, result = pcall(appStorageUtilities.getPreviousAccountsList)
			local v18, v19

			if success then
				v18, v19 = module26(result, v17)
			end

			setState(v18)
			setState2(v19)

			local v20 = true
			getUserByUsername(v10, userIdentifier)():andThen(function(p3)
				if not v20 or p3 == nil or p3.id == nil then
					return
				end

				setState(p3.id)
				setState2(p3.displayName)
			end):catch(function() end)

			return function()
				v20 = false
			end
		end

		setState(nil)
		setState2(nil)
	end, { v10, userIdentifier, state.userIdentifierType })
	local v17 = {
		setInProgress = setState4,
		setErrorKey = function(p3)
			fn2({ errorKey = p3 })
		end,
		navigation = p2.navigation,
		isLoginByOtp = false,
		eventContext = eventStreamConstants.Context.LoginFormV2Auth,
		eventOrigin = v5.eventOrigin
	}

	local joined = module6.Dictionary.join(v17, {
		onCredentialsPopupAbandoned = not (module31 and v11) and function()
			spawn(function()
				wait(0.1)

				if ref.current then
					ref.current.focus()
				end
			end)
		end or fn
	})

	local shouldShowAuthScreenCredentialsPopup = state
		and state.credentialsProtocolStatus.shouldShowAuthScreenCredentialsPopup

	local shouldShowAuthScreenUserSpecificPasskeyPopup = state
		and state.credentialsProtocolStatus.shouldShowAuthScreenUserSpecificPasskeyPopup

	module.useEffect(function()
		local v18 = nil

		if shouldShowAuthScreenCredentialsPopup then
			local fido2Supported = state and state.credentialsProtocolStatus.fido2Supported
			local passwordsSupported = state and state.credentialsProtocolStatus.passwordsSupported

			if state and state.credentialsProtocolStatus.v2InterfaceSupported then
				v18 = utils.showGenericCredentialLoginPopup(
					fido2Supported,
					passwordsSupported,
					v16.shouldFilterCredentialsForPrefill,
					joined
				)
			elseif fido2Supported then
				v18 = utils.showPasskeyLoginPopup(joined, v16.shouldFilterCredentialsForPrefill, true)
			end

			v5.dispatch({
				type = module24.UpdateCredentialsProtocolStatus,
				data = {
					shouldShowAuthScreenCredentialsPopup = false,
					shouldShowAuthScreenUserSpecificPasskeyPopup = false
				}
			})
		elseif
			shouldShowAuthScreenUserSpecificPasskeyPopup
			and module6.List.find(state.availableLoginMethods, module9.Passkey) ~= nil
		then
			if state.credentialsProtocolStatus.fido2Supported then
				v18 = utils.showPasskeyLoginPopup(joined, true, true)
			end

			v5.dispatch({
				type = module24.UpdateCredentialsProtocolStatus,
				data = { shouldShowAuthScreenUserSpecificPasskeyPopup = false }
			})
		elseif not v11 and ref.current then
			ref.current.focus()
		end

		if module31 and v11 and v18 == nil then
			setState3(false)
		end
	end, {})

	local v18 = {
		[module9.Password] = function(p3)
			if p3 ~= "" then
				setState4(true)
				fn2({ errorType = module9.Password })
				fn2({ errorKey = "" })

				local loginFormV2Auth = eventStreamConstants.Context.LoginFormV2Auth
				local password2 = eventStreamConstants.Field.Password
				local v19 = if module33 then eventStreamConstants.ActionType.Submit else nil
				authFormInteraction(loginFormV2Auth, password2, v19, v5.eventOrigin, nil)

				authButtonClick(
					eventStreamConstants.Context.LoginFormV2Auth,
					eventStreamConstants.Button.Password,
					v6,
					nil,
					nil,
					v5.eventOrigin,
					nil
				)

				utils.handleLoginWithFormData(nil, p3, nil, nil, nil, false, v17)
			end
		end,
		[module9.Passkey] = function(p3)
			fn2({ errorType = module9.Passkey })
			fn2({ errorKey = "" })
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2Auth,
				eventStreamConstants.Button.Passkey,
				v6,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)

			utils.showPasskeyLoginPopup(v17, true, false)
		end,
		[module9.EmailOtp] = function(p3)
			setState4(true)
			fn2({ errorType = module9.EmailOtp })
			fn2({ errorKey = "" })
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2Auth,
				eventStreamConstants.Button.EmailOtp,
				v6,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)

			local function fn5(p4)
				setState4(false)
				fn4(p4)
				p2.navigation.navigate(module22.EmailOtpScreen)
			end
			utils.handleSendEmailOtp(fn5, v17)
		end
	}

	local v19 = module6.List.find(state.availableLoginMethods, module9.Password) ~= nil

	local v20 = module27 and v11

	if v20 then
		if #state.availableLoginMethods == 1 and state.availableLoginMethods[1] == module9.Passkey then
			v20 = not state.credentialsProtocolStatus.fido2Supported
		else
			v20 = false
		end
	end

	if errorKey == "" or errorType == module9.Password or not errorKey then
		errorKey = nil
	end

	local v23 = useLocalization({
		toastErrorText = errorKey,
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		signInToRobloxHeadingText = "Authentication.Login.Heading.SignInToRoblox",
		enterYourPasswordHeadingText = "Authentication.Login.Label.EnterYourPassword",
		signInAnotherWayHeadingText = "Authentication.Login.Heading.SignInAnotherWay",
		passkeyDescriptionText = "Authentication.Login.Description.PasskeyDescription",
		passkeyLoginIncompatibleText = "Authentication.Login.Description.PasskeyLoginIncompatibleDevice",
		passkeyOnlyMobileText = "Authentication.Login.Description.PasskeyMobileOnly",
		signInWithQrCodeActionText = "Authentication.Login.Action.SignInWithQrCode",
		orText = "Authentication.SignUp.Description.Or"
	})

	local function onActivated()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2Auth,
			eventStreamConstants.Button.QuickLogin,
			v6,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)

		if module28() and v11 then
			local loginFormV2Auth2 = eventStreamConstants.Context.LoginFormV2Auth

			local loginV2QuickLoginModal = eventStreamConstants.Field.LoginV2QuickLoginModal
			local v24 = if module33 then eventStreamConstants.ActionType.Shown else nil
			authModalShown(loginFormV2Auth2, v24, loginV2QuickLoginModal, v5.eventOrigin)
		end

		if v12 then
			v12(crossDeviceLogin.OpenLoginCodePrompt({
				loginCallback = function(p3, p4, p5, p6)
					utils.handleLoginWithCode(p3, p4, p5, p6, v17)
				end,
				isOverlay = true,
				useFoundationSheet = v11,
				renderNeedHelpButton = v11 and function(p3)
					return module.createElement(module23.Provider, { value = v5 }, {
						Button = module.createElement(module19, {
							name = "HavingTroubleLink",
							layoutOrder = 2,
							originPage = eventStreamConstants.Context.LoginFormV2Auth,
							textKey = "Authentication.Login.Label.TroubleSigningIn",
							identifierAutofill = userIdentifier,
							contentStartRef = p3.contentStartRef,
							onBeforeActivated = p3.onBeforeActivated
						})
					})
				end or nil,
				onLeaveLogin = v11 and function()
					local loginFormV2Auth2 = eventStreamConstants.Context.LoginFormV2Auth
					local v24 = if module28() then eventStreamConstants.Button.DismissSheet else eventStreamConstants.Button.DismissCornerX
					authButtonClick(loginFormV2Auth2, v24, v6, nil, nil, v5.eventOrigin, nil)

					v5.parentNavigation.goBack()
				end or nil,
				onReturnToLogin = module28() and v11 and function()
					authButtonClick(
						eventStreamConstants.Context.LoginFormV2Auth,
						eventStreamConstants.Button.QuickLoginBack,
						v6,
						nil,
						nil,
						v5.eventOrigin,
						nil
					)
				end or nil
			}))
		end
	end

	local function onSubmit(p3): nil
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2Auth,
			eventStreamConstants.Button.EmailOtp,
			v6,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)

		p2.navigation.navigate(module22.EnterEmailScreen)
		return nil
	end

	local v24 = (function(list)
		if v20 then
			local v25 = {
				PasskeyOnlyDescription = module.createElement(
					"Frame",
					{
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					},
					{
						UIPadding = module.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, v7.Size.Size_500)
						}),
						Text = module.createElement(text, {
							Text = v23.passkeyOnlyMobileText,
							tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
						})
					}
				),
				EmailOtpMethod = module.createElement(module18, {
					layoutOrder = 2,
					isFirstItemInList = true,
					authMethod = module9.EmailOtp,
					onSubmit = onSubmit,
					isLoginInProgress = state5,
					setIsLoginInProgress = setState4,
					textBoxRef = v14,
					inputRef = v15,
					dialogBottomPadding = v7.Size.Size_200
				}),
				QuickSignIn = 0
			}

			local v26 = if not v13 then module.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					Button = module.createElement(button, {
						text = v23.signInWithQrCodeActionText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium,
						width = UDim.new(1, 0),
						icon = iconName.SquaresGridQr,
						isLoading = state5,
						onActivated = onActivated
					})
				}
			) else nil
			v25.QuickSignIn = v26
			return v25
		else
			if
				not state.credentialsProtocolStatus.fido2Supported
				and #list > 1
				and module6.List.find(list, module9.Passkey) ~= nil
			then
				list = module6.List.filter(list, function(p3): boolean
					return p3 ~= module9.Passkey
				end)
			end

			local v25 = #list > 1 and list[1] == module9.Password
			local mapped = module6.List.map(list, function(authMethod, p3)
				local createElement = module.createElement
				local v28

				if v11 and v19 and p3 > 1 then
					v28 = p3 + 2
				else
					v28 = if defineFastFlag and v25 and p3 > 1 then p3 + 1 else p3
				end

				return createElement(module18, {
					layoutOrder = v28,
					isFirstItemInList = p3 == 1,
					authMethod = authMethod,
					onSubmit = v18[authMethod],
					isLoginInProgress = state5,
					setIsLoginInProgress = setState4,
					textBoxRef = v14,
					inputRef = v15,
					dialogBottomPadding = v11 and not v19 and p3 == #list and 0 or nil
				})
			end)

			if v11 and v19 then
				table.insert(mapped, module.createElement(module19, {
					layoutOrder = 2,
					isDisabled = state5,
					originPage = eventStreamConstants.Context.LoginFormV2Auth,
					textKey = "Authentication.Login.Label.ForgotPassword",
					identifierAutofill = userIdentifier
				}))
			end

			if
				defineFastFlag and v25
				or not defineFastFlag and #list > 1 and list[1] == module9.Password
			then
				local createElement = module.createElement
				local v27 = {
					LayoutOrder = v11 and v19 and 3 or defineFastFlag and 2 or 1.5,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}

				local v28 = {
					UIPadding = module.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v7.Size.Size_200),
						PaddingBottom = UDim.new(0, v7.Size.Size_400)
					}),
					ListLayout = 0,
					DividerText = 0
				}

				local v29 = if not v11 then module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}) else nil
				v28.ListLayout = v29

				local v30 = if v11 then module.createElement(module15, {
					layoutOrder = 1,
					orText = v23.orText
				}) else module.createElement(styledTextLabel, {
					layoutOrder = 1,
					text = v23.orText,
					fontStyle = v9.Font.Header2,
					colorStyle = v9.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Center
				})
				v28.DividerText = v30
				table.insert(mapped, createElement("Frame", v27, v28))
			elseif #list == 1 and list[1] == module9.Passkey then
				local createElement = module.createElement
				local v27 = {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}

				local v28 = {
					UIPadding = module.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v7.Size.Size_400)
					}),
					TextLabel = 0
				}
				local v29

				if v11 then
					local createElement2 = module.createElement

					local v32 = if state.credentialsProtocolStatus.fido2Supported then v23.passkeyDescriptionText else v23.passkeyLoginIncompatibleText
					v29 = createElement2(text, {
						LayoutOrder = 0,
						Text = v32,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
					})
				else
					local createElement2 = module.createElement

					local v32 = if state.credentialsProtocolStatus.fido2Supported then v23.passkeyDescriptionText else v23.passkeyLoginIncompatibleText
					v29 = createElement2(styledTextLabel, {
						layoutOrder = 0,
						text = v32,
						fontStyle = v9.Font.Body,
						colorStyle = v9.Theme.TextDefault,
						automaticSize = Enum.AutomaticSize.XY,
						fluidSizing = true,
						lineHeight = 1
					})
				end

				v28.TextLabel = v29
				table.insert(mapped, createElement("Frame", v27, v28))
			end

			return mapped
		end
	end)(state.availableLoginMethods)

	local v25 = module.useMemo(function()
		return {
			toastTitle = v23.toastErrorText,
			iconImage = images["icons/status/error_large"],
			iconSize = Vector2.new(v7.Size.Size_600, v7.Size.Size_600),
			iconColorStyle = { Color = v7.Color.System.Alert.Color3, Transparency = 0 }
		}
	end, { v23.toastErrorText })

	local v26 = #state.availableLoginMethods == 1 and state.availableLoginMethods[1] == module9.Password

	local function onHeaderBack()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2Auth,
			eventStreamConstants.Button.Back,
			v6,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)
		fn2({ errorKey = "" })

		fn2({ errorType = nil })

		fn2({ password = "" })

		fn3({ userIdentifier = "", shouldAttemptCredentialPrefill = false })

		p2.navigation.navigate(module22.LoginScreenV2)
	end

	local function onHeaderClose()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2Auth,
			eventStreamConstants.Button.DismissCornerX,
			v6,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)
		v5.parentNavigation.goBack()
	end

	local function onSheetDismiss()
		if module28() then
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2Auth,
				eventStreamConstants.Button.DismissSheet,
				v6,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)
			v5.parentNavigation.goBack()
		else
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2Auth,
				eventStreamConstants.Button.DismissCornerX,
				v6,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)
			v5.parentNavigation.goBack()
		end
	end

	local element = module.createElement(iconButton, {
		layoutOrder = 1,
		icon = images["icons/actions/cycleLeft"],
		onActivated = onHeaderBack,
		size = UDim2.new(0, 36, 0, 36),
		isDisabled = state5
	})
	local v27

	if v11 then
		local createElement = module.createElement
		local v30

		if v20 then
			v30 = v23.signInAnotherWayHeadingText
		else
			v30 = if v19 then v23.enterYourPasswordHeadingText else v23.signInToRobloxHeadingText
		end

		local v31 = if v8 then v8.titleTopOffset else nil
		v27 = createElement(module14, {
			layoutOrder = 1,
			titleText = v30,
			titleTopOffset = v31,
			icon = iconName.X,
			onActivated = onHeaderClose,
			onBack = onHeaderBack,
			isDisabled = state5
		})
	else
		v27 = module.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				BackButton = element,
				SignInHeadingFrame = module.createElement("Frame", {
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = module.createElement(styledTextLabel, {
						text = v23.signInHeadingText,
						fontStyle = v9.Font.Header1,
						colorStyle = v9.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}
		)
	end

	local v28 = not v11

	local v30 = if not v11 then module.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v7.Size.Size_200),
		PaddingBottom = UDim.new(0, v7.Size.Size_200),
		PaddingLeft = UDim.new(0, v7.Size.Size_200),
		PaddingRight = UDim.new(0, v7.Size.Size_200)
	}) else nil
	local v31

	if not (module30 and v11 and not v23.toastErrorText) then
		local createElement = module.createElement

		local v34 = if module30 and v11 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0.5, 0)
		v31 = createElement("Frame", {
			BackgroundTransparency = 1,
			Size = v34,
			ZIndex = 100
		}, {
			ErrorToast = v23.toastErrorText and module.createElement(toast, {
				toastContent = v25,
				duration = 3
			})
		})
	end

	local createElement = module.createElement
	local v32 = v28 and "ScrollingFrame" or module5.FitFrameVertical
	local v33

	if v28 then
		v33 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BorderSizePixel = 0
		}
	else
		v33 = {
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}
	end

	local createElement2 = module.createElement
	local v35 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = 0,
		HorizontalAlignment = 0
	}
	local v36 = if v11 then UDim.new(0, v7.Size.Size_600) else nil
	v35.Padding = v36
	local v37 = if not v11 then Enum.HorizontalAlignment.Center else nil
	v35.HorizontalAlignment = v37
	local children = {
		UIListLayout = createElement2("UIListLayout", v35),
		Header = if not v11 then v27 else nil,
		ButtonSpacing = 0,
		Content = 0
	}

	local v39 = if not v11 then module.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v7.Size.Size_200),
		BackgroundTransparency = 1
	}) else nil
	children.ButtonSpacing = v39

	local createElement3 = module.createElement
	local v41 = {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		UISizeConstraint = not v11 and module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(module25.CONTENT_MAX_WIDTH, 1e999)
		}),
		UIPadding = 0,
		UIListLayout = 0,
		Heading = 0,
		AuthenticationComponents = 0,
		HelpButtonFrame = 0
	}

	local createElement4 = module.createElement
	local v44 = if not v11 then UDim.new(0, v7.Size.Size_200) else nil
	local v45 = if not v11 then UDim.new(0, v7.Size.Size_200) else nil
	local v46 = if not v11 then UDim.new(0, v7.Size.Size_800) else nil
	local v47

	if v11 then
		if v8 then
			v47 = v8.formTopPadding
		end
	else
		v47 = UDim.new(0, v7.Size.Size_400)
	end

	children2.UIPadding = createElement4("UIPadding", {
		PaddingLeft = v44,
		PaddingRight = v45,
		PaddingBottom = v46,
		PaddingTop = v47
	})

	children2.UIListLayout = module.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v11 and 0 or v7.Size.Size_50)
	})

	children2.Heading = module.createElement(module20, {
		layoutOrder = 1,
		userIdentifier = userIdentifier,
		userId = state2,
		displayName = state3
	})

	children2.AuthenticationComponents = module.createElement(
		module5.FitFrameVertical,
		{ LayoutOrder = 2, width = UDim.new(1, 0), BackgroundTransparency = 1 },
		v24
	)

	children2.HelpButtonFrame = not (v11 and v19)
		and module.createElement(
			"Frame",
			{
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				ListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				HelpButton = module.createElement(module19, {
					layoutOrder = 1,
					isDisabled = state5,
					originPage = eventStreamConstants.Context.LoginFormV2Auth,
					textKey = (v11 or not v26) and "Authentication.Login.Label.TroubleSigningIn" or "Authentication.Login.Label.ForgotYourPassword",
					identifierAutofill = userIdentifier
				})
			}
		)
	children.Content = createElement3("Frame", v41, children2)
	local v29 = {
		UIPadding = v30,
		ErrorToastFrame = v31,
		Wrapper = createElement(v32, v33, children)
	}

	if not fFlagEnableLoginV2Modalization then
		return module.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = v9.Theme.BackgroundDefault.Color
			},
			v29
		)
	end

	local createElement5 = module.createElement

	if not v11 then
		v27 = nil
	end

	return createElement5(
		module10,
		{
			header = v27,
			onClose = onSheetDismiss,
			eventContext = eventStreamConstants.Context.LoginFormV2Auth
		},
		v29
	)
end

return LUAUFORGE_MODULE_GLOBALS_fFw_AuthenticationScreen
