local module = require("@luauforge/bundled/hCf")
local useDesignTokens = require("@luauforge/bundled/hCm").useDesignTokens
local useLocalization = require("@luauforge/bundled/hCl").Hooks.useLocalization

local module2 = require("@luauforge/bundled/hCj")
local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel
local module3 = require("@luauforge/bundled/hCh")
local appStorageUtilities = module3.Utils.AppStorageUtilities
local inputValidity = module3.Enums.InputValidity
local disclaimerLinks = module3.Components.DisclaimerLinks

local getFFlagEnableSignupFoundationText = require("@luauforge/bundled/hCn").GetFFlagEnableSignupFoundationText
local text = require("@luauforge/bundled/hCo").Text

local module4 = require("@luauforge/bundled/hCq")
local authMsgShown = module4.Events.authMsgShown
local authFormInteraction = module4.Events.authFormInteraction
local authModalShown = module4.Events.authModalShown
local authClientError = module4.Events.authClientError
local eventStreamConstants = module4.EventStreamConstants

local useRoactService = require("@luauforge/bundled/hCu").useRoactService
local roactNetworking = require("@luauforge/bundled/hCx").RoactNetworking
local module5 = require("@luauforge/bundled/hCD")
local module6 = require("@luauforge/bundled/hCv")

local module7 = require("@luauforge/bundled/hCi")
local authTextInputValidator = module7.Components.AuthTextInputValidator
local passwordValidator = module7.Thunks.PasswordValidator
local passwordIssue = module3.Enums.PasswordIssue

local module8 = require("@luauforge/bundled/hBs")
local fullPageActivationFrameworkContext = module8.Context.FullPageActivationFrameworkContext
local activationFrameworkWrapper = module8.Components.ActivationFrameworkWrapper
local payloadKey = module8.Enums.PayloadKey
local callbackStatus = module8.Enums.CallbackStatus

local fStringLuaMultiPageSignupIxpLayer = require("@luauforge/bundled/hCn").FStringLuaMultiPageSignupIxpLayer

local registerPreauthPasskey = module3.Thunks.RegisterPreauthPasskey
local module9 = require("@luauforge/bundled/hCz")

local v5 = { passwordIssue.Length, passwordIssue.UsernameMatch, passwordIssue.Simple }

local getFFlagPasswordErrorSimple = require("@luauforge/bundled/hCn").GetFFlagPasswordErrorSimple
local getFFlagPasswordErrorLength = require("@luauforge/bundled/hCn").GetFFlagPasswordErrorLength

local v6 = {
	[passwordIssue.Length] = getFFlagPasswordErrorLength() and "Authentication.SignUp.Label.PasswordErrorLengthNew" or "Authentication.SignUp.Label.NewPasswordError1",
	[passwordIssue.UsernameMatch] = "Authentication.SignUp.Label.NewPasswordError2",
	[passwordIssue.Simple] = getFFlagPasswordErrorSimple() and "Authentication.SignUp.Label.PasswordErrorSimple" or "Authentication.SignUp.Label.NewPasswordError3"
}

return function(p2)
	local v7 = useRoactService(roactNetworking)

	local v8 = module.useContext(fullPageActivationFrameworkContext)
	local activationFrameworkState = v8.activationFrameworkState

	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(true)
	local state3, setState3 = module.useState("")
	local state4, setState4 = module.useState(inputValidity.Unvalidated)

	local state5, setState5 = module.useState(false)

	local state6, setState6 = module.useState(false)

	local ref = module.useRef(nil)

	local v9 = useDesignTokens()
	local v10 = useStyle()
	local v11 = module6()

	local state7, setState7 = module.useState("")

	local v12 = module5.useBrowserTrackerExperiment({ fStringLuaMultiPageSignupIxpLayer }, function(p3)
		local v13 = p3[fStringLuaMultiPageSignupIxpLayer] or {}

		return {
			shouldShowPasskeyOnMultiPageSignup = v13.shouldShowPasskeyOnMultiPageSignup or false,
			shouldAwaitPasswordRegistrationOnMultiPageSignup = v13.shouldAwaitPasswordRegistrationOnMultiPageSignup or false,
			shouldShowCreateAccountHeaderOnMultiPageSignup = v13.shouldShowCreateAccountHeaderOnMultiPageSignup or false,
			shouldPromptPasskey = v13.shouldPromptPasskey or false
		}
	end)

	module.useEffect(function()
		if
			activationFrameworkState.payloadTable
			and activationFrameworkState.payloadTable[payloadKey.SignupUsername]
		then
			setState7(activationFrameworkState.payloadTable[payloadKey.SignupUsername])
		else
			setState7(appStorageUtilities.getIncompleteSignupUsername())
		end
	end, {})

	module.useEffect(function()
		if ref.current and ref.current.focus then
			ref.current.focus()
		end
	end, {})

	module.useEffect(function()
		setState(state4 == inputValidity.Valid)
	end, { state4 })

	module.useEffect(function()
		if not activationFrameworkState.payloadTable then
			return
		end

		local v13, v14, v15 = module9(activationFrameworkState.payloadTable, p2.namespace, v8.dispatch)

		setState6(v13)
		setState5(v14)
	end, {})

	local function onTextChanged(p3, p4)
		setState3(p3)
		setState4(p4)
	end

	local v13 = useLocalization({
		passwordLabel = "Authentication.Login.Label.Password",
		passwordPlaceholder = "Authentication.SignUp.Label.Use8CharPassword"
	})

	local v14 = module.useCallback(function()
		return v12.shouldShowPasskeyOnMultiPageSignup and state6
	end, { v12.shouldShowPasskeyOnMultiPageSignup, state6 })

	local v15 = v14() and "Authentication.SignUp.Header.CreatePasswordOrPasskey"
		or "Authentication.SignUp.Header.CreatePassword"

	local createElement = module.createElement
	local v17 = {
		namespace = p2.namespace,
		titleTextKey = {
			v15,
			username = "@" .. state7
		},
		bodyTextKey = "Authentication.SignUp.Description.ThisKeepYourAccountSecure",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = state,
			onButtonClicked = function()
				return {
					payloadAddendum = {
						[payloadKey.SignupPassword] = state3,
						[payloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(state5),
						[payloadKey.SignupPasskeySessionId] = "",
						[payloadKey.SignupPasskeyResult] = ""
					},
					status = callbackStatus.Success
				}
			end
		},
		secondaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.CreateAPasskey",
			icon = "icons/menu/passkey",
			shouldShowButton = v14(),
			isButtonEnabled = state6 and state2,
			onButtonClicked = function()
				setState(false)
				setState2(false)
				local v18, v19 = registerPreauthPasskey(v7, state7):andThen(function(p3)
					if not p3 then
						authModalShown(
							eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage,
							eventStreamConstants.State.Unknown
						)

						return {
							payloadAddendum = nil,
							status = callbackStatus.PageError
						}
					end

					authModalShown(
						eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage,
						eventStreamConstants.State.Success
					)

					return {
						payloadAddendum = {
							[payloadKey.SignupPasskeySessionId] = p3.sessionId,
							[payloadKey.SignupPasskeyResult] = p3.result,
							[payloadKey.SignupPassword] = ""
						},
						status = callbackStatus.Success
					}
				end, function(data)
					if data.name then
						authModalShown(
							eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage,
							data.name
						)

						if type(data.body) == "string" then
							authClientError(
								eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage,
								data.body,
								data.source
							)
						end
					else
						authModalShown(
							eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedAuthPage,
							eventStreamConstants.State.Unknown
						)
					end

					return { payloadAddendum = nil, status = callbackStatus.PageError }
				end):await()
				setState(state4 == inputValidity.Valid)
				setState2(true)
				return v19
			end
		},
		shouldShowButtonDivider = v14(),
		navigation = p2.navigation,
		subFooterContent = 0
	}
	local createElement2 = module.createElement
	local v19 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 1, 0)
	}
	local v20 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			FillDirection = Enum.FillDirection.Vertical
		}),
		DisclaimerLinks = 0
	}

	local v21 = if v11 then module.createElement(disclaimerLinks, {
		ctx = p2.namespace,
		state = activationFrameworkState.currentState
	}) else nil
	v20.DisclaimerLinks = v21
	v17.subFooterContent = createElement2("Frame", v19, v20)

	local createElement3 = module.createElement
	local v24 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v9.Size.Size_50)
		}),
		ContentPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v9.Size.Size_50)
		}),
		PasswordInputLabel = 0,
		PasswordLabelSpacing = 0,
		PasswordField = 0
	}

	local v25 = if getFFlagEnableSignupFoundationText() then module.createElement(text, {
		LayoutOrder = 1,
		Text = v13.passwordLabel,
		tag = "text-body-small auto-xy"
	}) else module.createElement(styledTextLabel, {
		layoutOrder = 1,
		text = v13.passwordLabel,
		fontStyle = v10.Font.Body,
		colorStyle = v10.Theme.TextDefault,
		automaticSize = Enum.AutomaticSize.XY
	})
	children.PasswordInputLabel = v25

	children.PasswordLabelSpacing = module.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_100),
		BackgroundTransparency = 1
	})

	children.PasswordField = module.createElement(authTextInputValidator, {
		layoutOrder = 3,
		textInputType = Enum.TextInputType.Password,
		placeholder = v13.passwordPlaceholder,
		validator = passwordValidator,
		validatorAdditionalProps = { username = state7 },
		validatorIssuePriorityList = v5,
		validatorIssueMessageList = v6,
		onTextChanged = onTextChanged,
		onTextFocusedGained = function()
			authFormInteraction(
				v8.activationFrameworkState.namespace,
				eventStreamConstants.Field.Password,
				v8.activationFrameworkState.currentState,
				nil,
				true
			)
		end,
		onErrorShown = function(p3)
			authMsgShown(
				p2.namespace,
				activationFrameworkState.currentState,
				eventStreamConstants.Field.Password,
				p3
			)
		end,
		textBoxRef = ref
	})
	return createElement(activationFrameworkWrapper, v17, {
		Content = createElement3("Frame", v24, children)
	})
end
