local module = require("@luauforge/bundled/hCf")

local useDesignTokens = require("@luauforge/bundled/hCm").useDesignTokens
local useDispatch = require("@luauforge/bundled/hCt").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/hCu").useRoactService
local useLocalization = require("@luauforge/bundled/hCl").Hooks.useLocalization
local module2 = require("@luauforge/bundled/hCk")
local module3 = require("@luauforge/bundled/hCv")

local roactNetworking = require("@luauforge/bundled/hCx").RoactNetworking

local module4 = require("@luauforge/bundled/hCj")
local useStyle = module4.Core.Style.useStyle
local styledTextLabel = module4.App.Text.StyledTextLabel
local pillGroup = module4.App.Control.PillGroup

local getFFlagEnableSignupFoundationText = require("@luauforge/bundled/hCn").GetFFlagEnableSignupFoundationText
local module5 = require("@luauforge/bundled/hCo")
local text = module5.Text
local textInput = module5.TextInput

local module6 = require("@luauforge/bundled/hBs")

local activationFrameworkWrapper = module6.Components.ActivationFrameworkWrapper
local payloadKey = module6.Enums.PayloadKey
local fullPageActivationFrameworkContext = module6.Context.FullPageActivationFrameworkContext
local callbackStatus = module6.Enums.CallbackStatus

local module7 = require("@luauforge/bundled/hCi")
local usernameValidator = module7.Thunks.UsernameValidator
local usernameSuggestor = module7.Thunks.UsernameSuggestor
local usernameSuggestionScrollView = module7.Components.UsernameSuggestionScrollView
local module8 = require("@luauforge/bundled/hCy")

local module9 = require("@luauforge/bundled/hCh")
local usernameValidationContext = module9.Enums.UsernameValidationContext
local usernameIssue = module9.Enums.UsernameIssue
local issueCondition = module9.Enums.IssueCondition
local disclaimerLinks = module9.Components.DisclaimerLinks
local module10 = require("@luauforge/bundled/hCq")
local eventStreamConstants = module10.EventStreamConstants
local authMsgShown = module10.Events.authMsgShown
local authButtonClick = module10.Events.authButtonClick
local authModalShown = module10.Events.authModalShown
local authClientError = module10.Events.authClientError

local module11 = require("@luauforge/bundled/hCn")

local defineFastFlag = game:DefineFastFlag("UseFoundationUsernameSuggestion", false)
local getFFlagEnableMultiPageSignupV2Updates = module11.GetFFlagEnableMultiPageSignupV2Updates

local registerPreauthPasskey = module9.Thunks.RegisterPreauthPasskey
local module12 = require("@luauforge/bundled/hCz")
local module13 = require("@luauforge/bundled/hCC")

local module14 = require("@luauforge/bundled/hCD")
local fStringLuaMultiPageSignupIxpLayer = module11.FStringLuaMultiPageSignupIxpLayer

local defineFastFlag2 = game:DefineFastFlag("HideMultipageUsernameAutofillSignupExperiment2", false)

local v5 = {
	usernameIssue.LengthTooShortOrTooLong,
	usernameIssue.ContainsInvalidCharacter,
	usernameIssue.MultipleUnderscores,
	usernameIssue.BoundingUnderscore,
	usernameIssue.Inappropriate,
	usernameIssue.AlreadyInUse,
	usernameIssue.ContainsPII
}

local v6 = {
	[usernameIssue.LengthTooShortOrTooLong] = "Authentication.SignUp.Label.Error.UsernameLengthTooShortOrTooLong",
	[usernameIssue.ContainsInvalidCharacter] = "Authentication.SignUp.Label.Error.UsernameContainsInvalidCharacter",
	[usernameIssue.MultipleUnderscores] = "Authentication.SignUp.Label.Error.UsernameContainsMultipleUnderscores",
	[usernameIssue.BoundingUnderscore] = "Authentication.SignUp.Label.Error.UsernameContainsBoundingUnderscore",
	[usernameIssue.Inappropriate] = "Authentication.SignUp.Label.Error.UsernameInappropriate",
	[usernameIssue.AlreadyInUse] = "Authentication.SignUp.Label.Error.UsernameAlreadyInUse",
	[usernameIssue.ContainsPII] = "Authentication.SignUp.Label.Error.UsernameContainsPII"
}

game:DefineFastInt("DefaultUsernameDebounceMs", 700)

return function(p2)
	local v7 = module.useContext(fullPageActivationFrameworkContext)
	local activationFrameworkState = v7.activationFrameworkState

	local v8 = useStyle()
	local v9 = useDesignTokens()
	local v10 = useDispatch()
	local v11 = useRoactService(roactNetworking)

	local v12 = module14.useBrowserTrackerExperiment({ fStringLuaMultiPageSignupIxpLayer }, function(p3)
		local v13 = p3[fStringLuaMultiPageSignupIxpLayer] or {}

		return {
			shouldMultipageDisableUsernameAutofill = v13.shouldMultipageDisableUsernameAutofill or false,
			shouldCleanUsernameSuggestionInput = v13.shouldCleanUsernameSuggestionInput or false,
			shouldDisableClearingUsernameSuggestions = v13.shouldDisableClearingUsernameSuggestions or false,
			shouldPromptPasskey = v13.shouldPromptPasskey or false
		}
	end)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(game:GetFastInt("DefaultUsernameDebounceMs") / 1000)
	local state3, setState3 = module.useState(usernameValidator.getDefaultIssues())
	local state4, setState4 = module.useState({})
	local state5, setState5 = module.useState(false)
	local v13 = module3()
	local state6, setState6 = module.useState(false)
	local ref = module.useRef(nil)
	local state7, setState7 = module.useState(false)

	local state8, setState8 = module.useState(false)

	local v14 = activationFrameworkState.payloadTable[payloadKey.SignupBirthdayTimestampUtc]

	module.useEffect(function()
		if ref.current and ref.current.focus then
			ref.current.focus()
		end
	end, {})

	module.useEffect(function()
		if getFFlagEnableMultiPageSignupV2Updates() and state6 then
			if ref.current and ref.current.focus then
				ref.current.focus()
			end

			setState6(false)
		end
	end, { state6 })

	local v15 = module.useCallback(module2(function(p3)
		setState(p3)
	end, state2), { setState, state2 })

	local v16 = module.useCallback(function()
		for i, v18 in ipairs(v5) do
			if state3[v18] == issueCondition.Problematic then
				return v18
			end
		end

		return nil
	end, { state3 })

	local function fn()
		local v17 = if v12.shouldCleanUsernameSuggestionInput then module8(state) else state

		usernameSuggestor.suggestUsernames(v11, v17, v14, usernameValidationContext.Signup):andThen(function(p3)
			if v12.shouldDisableClearingUsernameSuggestions then
				if #p3.suggestions > 0 then
					setState4(p3.suggestions)
				end
			elseif p3.shouldUpdateState then
				setState4(p3.suggestions)
			end
		end)
	end
	module.useEffect(fn, { state })

	module.useEffect(function()
		local v17 = tostring(v16())

		if v17 and state5 and #state > 0 then
			authMsgShown(
				p2.namespace,
				activationFrameworkState.currentState,
				eventStreamConstants.Field.Username,
				v17
			)
		end
	end, { state3 })

	local function fn2()
		v10(usernameValidator.validateFunction(v11, state, state3, {
			birthday = v14,
			context = usernameValidationContext.Signup
		})):andThen(function(p3)
			setState3(p3.IssueCondition)
			setState5(#state > 0)

			if p3.InputValid then
				setState2(0.2)
			end
		end)
	end

	module.useEffect(fn2, { state })

	local v17 = v16()
	local v18 = v17 and state5 and #state > 0
	local v19 = v18 and #state4 > 0

	local v20 = useLocalization({
		username = "Authentication.Login.Label.Username",
		usernameSuggestionHeaderText = "Authentication.SignUp.Label.MaybeTryOneOfThese",
		errorText = v17 and v6[v17],
		noRealNamePlaceholderText = "Authentication.SignUp.Message.Username.NoRealNameUse",
		usernameRule1 = "Authentication.SignUp.Description.UsernameRule1",
		usernameRule2 = "Authentication.SignUp.Description.UsernameRule2"
	})

	local function fn3(p3)
		local v21

		if getFFlagEnableSignupFoundationText() then
			v21 = module.createElement(text, {
				Text = not v18 and "" or v20.errorText,
				TextWrapped = true,
				textStyle = {
					Color3 = v8.Theme.Alert.Color,
					Transparency = v8.Theme.Alert.Transparency
				},
				tag = "text-body-small auto-xy"
			})
		else
			v21 = module.createElement(styledTextLabel, {
				text = not v18 and "" or v20.errorText,
				fontStyle = v8.Font.BodySmall,
				colorStyle = v8.Theme.Alert,
				automaticSize = Enum.AutomaticSize.XY,
				textWrapped = true
			})
		end

		local size_400 = v9.Size.Size_400
		return module.createElement(
			"Frame",
			{
				LayoutOrder = p3,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, size_400)
			},
			{ v21 }
		)
	end

	local function fn4(p3)
		if defineFastFlag then
			return module.createElement(usernameSuggestionScrollView, {
				inputUsername = state,
				suggestionUsernames = state4,
				eventContext = tostring(v7.activationFrameworkState.namespace),
				onUsernameSelected = function(p4)
					setState(p4)
					setState4({})
					authButtonClick(
						v7.activationFrameworkState.namespace,
						eventStreamConstants.Button.UsernameSuggestion,
						p4
					)
				end,
				layoutOrder = p3
			})
		end

		return module.createElement(pillGroup, {
			layoutOrder = 8,
			pills = state4,
			leftPadding = 0,
			onSelectionChanged = function(list)
				if #list == 1 then
					if #list[1] == 0 then
						return
					end

					local item = list[1]
					setState(item)
					setState4({})
					authButtonClick(
						v7.activationFrameworkState.namespace,
						eventStreamConstants.Button.UsernameSuggestion,
						item
					)
				end
			end
		})
	end

	local function fn5()
		if not v12.shouldPromptPasskey then
			return module13.reject()
		end

		setState7(true)

		if not state8 then
			return module13.reject()
		end

		local v21, v22 = registerPreauthPasskey(v11, state):andThen(function(p3)
			if not p3 then
				authModalShown(
					eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage,
					eventStreamConstants.State.Unknown
				)

				return nil
			end

			authModalShown(
				eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage,
				eventStreamConstants.State.Success
			)

			return {
				[payloadKey.SignupPasskeySessionId] = p3.sessionId,
				[payloadKey.SignupPasskeyResult] = p3.result
			}
		end, function(data)
			if data.name then
				authModalShown(
					eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage,
					data.name
				)

				if type(data.body) == "string" then
					authClientError(
						eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage,
						data.body,
						data.source
					)
				end
			else
				authModalShown(
					eventStreamConstants.Context.MultiPageSignupPreauthPasskeyCreatedIdentifierPage,
					eventStreamConstants.State.Unknown
				)
			end
		end):await()
		return module13.resolve(v22)
	end

	module.useEffect(function()
		if activationFrameworkState.payloadTable and v12.shouldPromptPasskey then
			local v21, v22, v23 = module12(activationFrameworkState.payloadTable, p2.namespace, v7.dispatch)

			setState8(v21)
		end
	end, { activationFrameworkState.payloadTable, v12.shouldPromptPasskey })

	local shouldMultipageDisableUsernameAutofill = defineFastFlag2
		and v12.shouldMultipageDisableUsernameAutofill

	local createElement = module.createElement
	local v22 = {
		namespace = p2.namespace,
		titleTextKey = "Authentication.SignUp.Header.UsernamePage4",
		bodyTextKey = "Authentication.SignUp.Description.UsernameHelpV2",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = #state > 0 and state5 and not (v18 or state7),
			onButtonClicked = function()
				local v25 = { [payloadKey.SignupUsername] = state }
				local v26, v27 = fn5():andThen(function(p3)
					return p3
				end):await()
				setState7(false)

				if v26 and v27 then
					for k, v28 in pairs(v27) do
						v25[k] = v28
					end

					v25[payloadKey.SignupPassword] = ""
				end

				return { payloadAddendum = v25, status = callbackStatus.Success }
			end
		},
		navigation = p2.navigation,
		subFooterContent = 0
	}
	local createElement2 = module.createElement
	local v26 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 1, 0)
	}
	local v27 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			FillDirection = Enum.FillDirection.Vertical
		}),
		DisclaimerLinks = 0
	}

	local v28 = if v13 then module.createElement(disclaimerLinks, {
		ctx = p2.namespace,
		state = activationFrameworkState.currentState
	}) else nil
	v27.DisclaimerLinks = v28
	v22.subFooterContent = createElement2("Frame", v26, v27)

	local createElement3 = module.createElement
	local v31 = {
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
		UsernameInputLabel = 0,
		IdentifierLabelSpacing = 0,
		UsernameTextInput = 0,
		TextSpacing = 0,
		AdditionalText = 0,
		SuggestionsLabelSpacing = 0,
		SuggestionsLabel = 0,
		UsernameSuggestion = 0
	}

	local v32 = if getFFlagEnableSignupFoundationText() then module.createElement(text, {
		LayoutOrder = 1,
		Text = v20.username,
		tag = "text-body-small auto-xy"
	}) else module.createElement(styledTextLabel, {
		layoutOrder = 1,
		text = v20.username,
		fontStyle = v8.Font.Body,
		colorStyle = v8.Theme.TextDefault,
		automaticSize = Enum.AutomaticSize.XY
	})
	children.UsernameInputLabel = v32

	children.IdentifierLabelSpacing = module.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_100),
		BackgroundTransparency = 1
	})

	local createElement4 = module.createElement

	local v35 = if not shouldMultipageDisableUsernameAutofill then Enum.TextInputType.Username else nil
	children.UsernameTextInput = createElement4(textInput, {
		LayoutOrder = 3,
		textInputType = v35,
		width = UDim.new(1, 0),
		text = state,
		placeholder = v20.noRealNamePlaceholderText,
		onChanged = function(p3)
			v15(p3)
		end,
		label = "",
		hasError = v18,
		iconTrailing = v18 and {
			name = "icons/navigation/close",
			onActivated = function()
				authButtonClick(
					v7.activationFrameworkState.namespace,
					eventStreamConstants.Button.ClearUsernameField,
					v7.activationFrameworkState.currentState
				)

				setState("")
				setState4({})
				setState2(game:GetFastInt("DefaultUsernameDebounceMs") / 1000)

				if getFFlagEnableMultiPageSignupV2Updates() then
					setState6(true)
				end
			end
		} or nil,
		textBoxRef = ref
	})

	children.TextSpacing = module.createElement("Frame", {
		LayoutOrder = 4,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_100),
		BackgroundTransparency = 1
	})

	children.AdditionalText = fn3(5)
	children.SuggestionsLabelSpacing = v19
		and module.createElement("Frame", {
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_400),
			BackgroundTransparency = 1
		})
	local v36

	if v19 then
		if getFFlagEnableSignupFoundationText() then
			v36 = module.createElement(text, {
				LayoutOrder = 7,
				Text = v20.usernameSuggestionHeaderText,
				tag = "text-body-small auto-xy"
			})
		else
			v36 = module.createElement(styledTextLabel, {
				layoutOrder = 7,
				text = v20.usernameSuggestionHeaderText,
				fontStyle = v8.Font.Body,
				colorStyle = v8.Theme.TextDefault,
				automaticSize = Enum.AutomaticSize.XY
			})
		end
	else
		v36 = v19
	end

	children.SuggestionsLabel = v36

	children.UsernameSuggestion = v19 and fn4(8)
	return createElement(activationFrameworkWrapper, v22, {
		Content = createElement3("Frame", v31, children)
	})
end
