local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/RobloxAppHooks").useRoactService

local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/RoactServiceTags").RoactNetworking

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/UIBlox")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Style").useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local textInput = Foundation.TextInput
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Localization").Hooks.useLocalization

local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local inputValidity = AuthCommon.Enums.InputValidity
local issueCondition = AuthCommon.Enums.IssueCondition
local uiConstants = AuthCommon.Common.UIConstants

local debounce = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Util/debounce")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")

local getFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local getFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow

local function AuthTextInputValidator(props)
	local v5 = useDesignTokens()
	local v6 = useTokens()
	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useStyle()

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(props.validator.getDefaultIssues())

	local state4, setState4 = React.useState(true)
	local state5, setState5 = React.useState(inputValidity.Unvalidated)
	local state6, setState6 = React.useState(nil)
	local state7, setState7 = React.useState(false)

	local v10 = React.useCallback(debounce(function(p2)
		setState2(p2)
	end, props.debounceTime or 0.5), { setState2 })

	React.useEffect(function()
		if state2 ~= state then
			v10(state)
		end
	end, { state })

	local v11 = { state2 }

	if getFFlagEnableLuafiedRecoveryFlow() then
		local validationDependencies = props.validationDependencies

		if validationDependencies then
			for i = 1, #validationDependencies do
				v11[#v11 + 1] = validationDependencies[i]
			end
		end
	end

	React.useEffect(function()
		if #state2 ~= 0 then
			v7(props.validator.validateFunction(v8, state2, state3, props.validatorAdditionalProps)):andThen(function(data)
				local v12 = if data.InputValid then inputValidity.Valid else inputValidity.Invalid

				if state == data.Input and props.onTextChanged then
					props.onTextChanged(data.Input, v12)
				end

				setState3(data.IssueCondition)
				setState5(v12)
				setState(data.Input)
			end)
			return
		end

		setState5(inputValidity.Unvalidated)
		setState3(props.validator.getDefaultIssues())
	end, v11)

	React.useEffect(function()
		if state5 ~= inputValidity.Invalid then
			setState6(nil)
			return
		end

		local v12 = nil

		if props.validatorIssuePriorityList then
			for i, validatorIssuePriority in ipairs(props.validatorIssuePriorityList) do
				if state3[validatorIssuePriority] == issueCondition.Problematic then
					v12 = validatorIssuePriority
					break
				end
			end
		else
			for k, v14 in pairs(state3) do
				if v14 == issueCondition.Problematic then
					v12 = k
					break
				end
			end
		end

		if v12 == nil then
			setState6(nil)
			return
		end

		if props.onErrorShown then
			props.onErrorShown(v12)
		end

		if props.validatorIssueMessageList then
			setState6(props.validatorIssueMessageList[v12])
		else
			setState6(props.validator.getIssueMessageList()[v12])
		end
	end, { state5 })

	React.useEffect(function()
		if getFFlagEnableMultiPageSignupV2Updates() and state7 then
			local textBoxRef = props.textBoxRef

			if textBoxRef.current and textBoxRef.current.focus then
				textBoxRef.current.focus()
			end

			setState7(false)
		end
	end, { state7 })

	local function fn(p2)
		props.onTextChanged(p2, inputValidity.Unvalidated)
		setState5(inputValidity.Unvalidated)
		setState(p2)
	end

	local function getTextInputType()
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
			return uiConstants.HIDE_PASSWORD_ICON, function()
				setState4(false)

				if getFFlagEnableMultiPageSignupV2Updates() then
					setState7(true)
				end
			end
		end

		return uiConstants.SHOW_PASSWORD_ICON, function()
			setState4(true)

			if getFFlagEnableMultiPageSignupV2Updates() then
				setState7(true)
			end
		end
	end

	local v12 = useLocalization({ errorText = state6 })

	local showPasswordIconButton, v13 = getShowPasswordIconButton()
	local v14

	if
		state5 == inputValidity.Invalid
		and getFFlagEnableLuafiedRecoveryFlow()
		and props.useFoundationTextForIssue
	then
		v14 = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v6.Size.Size_200),
				BackgroundTransparency = 1
			},
			{
				IssuePadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, props.foundationIssueTextPadding or 0)
				}),
				IssueText = React.createElement(text, {
					Text = v12.errorText or "",
					fontStyle = v6.Typography.CaptionSmall,
					textStyle = v6.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			}
		)
	elseif state5 == inputValidity.Invalid then
		v14 = React.createElement(styledTextLabel, {
			text = v12.errorText or "",
			fontStyle = v9.Font.BodySmall,
			colorStyle = v9.Theme.Alert,
			automaticSize = Enum.AutomaticSize.XY,
			textWrapped = true
		})
	end

	local v15 = v5.Size.Size_100

	if getFFlagEnableLuafiedRecoveryFlow() then
		v15 = props.customPadding or v5.Size.Size_100
	end

	local createElement = React.createElement
	local v17 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v15),
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		}),
		TextInputBox = 0,
		IssueWrapper = 0
	}

	local createElement2 = React.createElement
	local v20

	if props.textInputType == Enum.TextInputType.Password then
		v20 = if state4 then Enum.TextInputType.Password else Enum.TextInputType.PasswordShown
	else
		v20 = props.textInputType
	end

	local v19 = {
		LayoutOrder = 1,
		textInputType = v20,
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

	local v21 = if not (getFFlagEnableLuafiedRecoveryFlow() and props.hideIconButton) then showPasswordIconButton and {
		name = showPasswordIconButton,
		onActivated = v13
	} or nil else nil
	v19.iconTrailing = v21

	v19.hasError = state5 == inputValidity.Invalid and #state > 0
	v19.textBoxRef = props.textBoxRef

	v19.size = props.size
	children.TextInputBox = createElement2(textInput, v19)

	children.IssueWrapper = React.createElement("Frame", {
		LayoutOrder = 3,
		Size = UDim2.new(
			1,
			0,
			0,
			getFFlagEnableLuafiedRecoveryFlow() and props.issueHeight or v5.Size.Size_400
		),
		BackgroundTransparency = 1
	}, { Issue = v14 })
	return createElement("Frame", v17, children)
end

return AuthTextInputValidator
