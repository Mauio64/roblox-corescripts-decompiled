local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

local UIBlox = require(parent.UIBlox)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local Foundation = require(parent.Foundation)
local TextInput = Foundation.TextInput
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AuthCommon = require(parent.AuthCommon)
local InputValidity = AuthCommon.Enums.InputValidity
local IssueCondition = AuthCommon.Enums.IssueCondition
local UIConstants = AuthCommon.Common.UIConstants

local debounce = require(AuthSignup.Util.debounce)

local SharedFlags = require(parent.SharedFlags)

local GetFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local GetFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow

local function AuthTextInputValidator(props)
	local v = useDesignTokens()
	local v2 = useTokens()
	local v3 = useDispatch()
	local v4 = useRoactService(RoactNetworking)
	local v5 = useStyle()

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(props.validator.getDefaultIssues())

	local state4, setState4 = React.useState(true)
	local state5, setState5 = React.useState(InputValidity.Unvalidated)
	local state6, setState6 = React.useState(nil)
	local state7, setState7 = React.useState(false)

	local v6 = React.useCallback(debounce(function(p: string)
		setState2(p)
	end, props.debounceTime or 0.5), { setState2 })

	React.useEffect(function()
		if state2 ~= state then
			v6(state)
		end
	end, { state })

	local v7 = { state2 }

	if GetFFlagEnableLuafiedRecoveryFlow() then
		local validationDependencies = props.validationDependencies

		if validationDependencies then
			for i = 1, #validationDependencies do
				v7[#v7 + 1] = validationDependencies[i]
			end
		end
	end

	React.useEffect(function()
		if #state2 ~= 0 then
			v3(props.validator.validateFunction(v4, state2, state3, props.validatorAdditionalProps)):andThen(function(data)
				local v8

				if data.InputValid then
					v8 = InputValidity.Valid
				else
					v8 = InputValidity.Invalid
				end

				if state == data.Input and props.onTextChanged then
					props.onTextChanged(data.Input, v8)
				end

				setState3(data.IssueCondition)
				setState5(v8)
				setState(data.Input)
			end)
			return
		end

		setState5(InputValidity.Unvalidated)
		setState3(props.validator.getDefaultIssues())
	end, v7)

	React.useEffect(function()
		if state5 ~= InputValidity.Invalid then
			setState6(nil)
			return
		end

		local v8 = nil

		if props.validatorIssuePriorityList then
			for _, validatorIssuePriority in ipairs(props.validatorIssuePriorityList) do
				if state3[validatorIssuePriority] == IssueCondition.Problematic then
					v8 = validatorIssuePriority
					break
				end
			end
		else
			for k, v9 in pairs(state3) do
				if v9 == IssueCondition.Problematic then
					v8 = k
					break
				end
			end
		end

		if v8 == nil then
			setState6(nil)
			return
		end

		if props.onErrorShown then
			props.onErrorShown(v8)
		end

		if props.validatorIssueMessageList then
			setState6(props.validatorIssueMessageList[v8])
		else
			setState6(props.validator.getIssueMessageList()[v8])
		end
	end, { state5 })

	React.useEffect(function()
		if GetFFlagEnableMultiPageSignupV2Updates() and state7 then
			local textBoxRef = props.textBoxRef

			if textBoxRef.current and textBoxRef.current.focus then
				textBoxRef.current.focus()
			end

			setState7(false)
		end
	end, { state7 })

	local function fn(p: string)
		props.onTextChanged(p, InputValidity.Unvalidated)
		setState5(InputValidity.Unvalidated)
		setState(p)
	end

	local function getTextInputType() -- 1 equivalent call inferred from this helper
		if props.textInputType ~= Enum.TextInputType.Password then
			return props.textInputType
		end

		if state4 then
			return Enum.TextInputType.Password
		end

		return Enum.TextInputType.PasswordShown
	end

	local function getShowPasswordIconButton()
		if props.textInputType ~= Enum.TextInputType.Password then
			return nil, nil
		end

		if state4 then
			return UIConstants.HIDE_PASSWORD_ICON, function()
				setState4(false)

				if GetFFlagEnableMultiPageSignupV2Updates() then
					setState7(true)
				end
			end
		end

		return UIConstants.SHOW_PASSWORD_ICON, function()
			setState4(true)

			if GetFFlagEnableMultiPageSignupV2Updates() then
				setState7(true)
			end
		end
	end

	local v8 = useLocalization({ errorText = state6 })

	local showPasswordIconButton, onActivated = getShowPasswordIconButton()
	local issue

	if state5 == InputValidity.Invalid and GetFFlagEnableLuafiedRecoveryFlow() and props.useFoundationTextForIssue then
		issue = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v2.Size.Size_200),
				BackgroundTransparency = 1
			},
			{
				IssuePadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, props.foundationIssueTextPadding or 0)
				}),
				IssueText = React.createElement(Text, {
					Text = v8.errorText or "",
					fontStyle = v2.Typography.CaptionSmall,
					textStyle = v2.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			}
		)
	elseif state5 == InputValidity.Invalid then
		issue = React.createElement(StyledTextLabel, {
			text = v8.errorText or "",
			fontStyle = v5.Font.BodySmall,
			colorStyle = v5.Theme.Alert,
			automaticSize = Enum.AutomaticSize.XY,
			textWrapped = true
		})
	end

	local v9 = v.Size.Size_100

	if GetFFlagEnableLuafiedRecoveryFlow() then
		v9 = props.customPadding or v.Size.Size_100
	end

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v9),
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		}),
		TextInputBox = 0,
		IssueWrapper = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		LayoutOrder = 1,
		textInputType = getTextInputType(), -- inferred equivalent call
		width = UDim.new(1, 0),
		text = props.initialText or "",
		placeholder = props.placeholder,
		onChanged = fn,
		iconTrailing = 0,
		label = "",
		hasError = 0,
		textBoxRef = 0,
		size = 0
	}
	local iconTrailing

	if not (GetFFlagEnableLuafiedRecoveryFlow() and props.hideIconButton) then
		iconTrailing = showPasswordIconButton and {
			name = showPasswordIconButton,
			onActivated = onActivated
		} or nil
	end

	v11.iconTrailing = iconTrailing

	v11.hasError = state5 == InputValidity.Invalid and #state > 0
	v11.textBoxRef = props.textBoxRef

	v11.size = props.size
	children.TextInputBox = createElement2(TextInput, v11)

	children.IssueWrapper = React.createElement("Frame", {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, GetFFlagEnableLuafiedRecoveryFlow() and props.issueHeight or v.Size.Size_400),
		BackgroundTransparency = 1
	}, { Issue = issue })
	return createElement("Frame", v10, children)
end

return AuthTextInputValidator
