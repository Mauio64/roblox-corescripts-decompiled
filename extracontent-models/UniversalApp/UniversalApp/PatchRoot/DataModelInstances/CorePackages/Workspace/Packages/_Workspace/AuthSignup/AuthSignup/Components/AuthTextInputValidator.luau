local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local React = require(AuthSignupParent.React)
local useDispatch = require(AuthSignupParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(AuthSignupParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AuthSignupParent.RoactServiceTags).RoactNetworking
local UIBlox = require(AuthSignupParent.UIBlox)
local useDesignTokens = require(AuthSignupParent.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Foundation = require(AuthSignupParent.Foundation)
local TextInput = Foundation.TextInput
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(AuthSignupParent.Localization).Hooks.useLocalization
local AuthCommon = require(AuthSignupParent.AuthCommon)
local InputValidity = AuthCommon.Enums.InputValidity
local IssueCondition = AuthCommon.Enums.IssueCondition
local UIConstants = AuthCommon.Common.UIConstants
local debounce = require(AuthSignup.Util.debounce)
local SharedFlags = require(AuthSignupParent.SharedFlags)
local GetFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local GetFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow

local function AuthTextInputValidator(t1: {[any]: any}) -- line: 68
	-- upvalues: useDesignTokens (copy), useTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useStyle (copy), React (copy), InputValidity (copy), debounce (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), IssueCondition (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), UIConstants (copy), useLocalization (copy), FoundationText (copy), StyledTextLabel (copy), TextInput (copy)
	local v26 = useDesignTokens()
	local v27 = useTokens()
	local v28 = useDispatch()
	local v29 = useRoactService(RoactNetworking)
	local v30 = useStyle()
	local v31, v32 = React.useState("")
	local v33, v34 = React.useState("")
	local v35, v36 = React.useState(t1.validator.getDefaultIssues())
	local v37, v38 = React.useState(true)
	local v39, v40 = React.useState(InputValidity.Unvalidated)
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useState(false)
	local v45 = React.useCallback(debounce(function(s1: string) -- line: 87
		-- upvalues: v34 (copy)
		v34(s1)
	end, t1.debounceTime or 0.5), { v34 })

	React.useEffect(function() -- line: 92
		-- upvalues: v33 (copy), v31 (copy), v45 (copy)
		if v33 ~= v31 then
			v45(v31)
		end
	end, { v31 })

	local t2 = { v33 }

	if GetFFlagEnableLuafiedRecoveryFlow() then
		local validationDependencies = t1.validationDependencies

		if validationDependencies then
			for i = 1, #validationDependencies do
				t2[#t2 + 1] = validationDependencies[i]
			end
		end
	end

	React.useEffect(function() -- line: 108
		-- upvalues: v33 (copy), v40 (copy), InputValidity (copy), v36 (copy), t1 (copy), v28 (copy), v29 (copy), v35 (copy), v31 (copy), v32 (copy)
		if #v33 == 0 then
			v40(InputValidity.Unvalidated)
			v36(t1.validator.getDefaultIssues())

			return
		end

		v28(t1.validator.validateFunction(v29, v33, v35, t1.validatorAdditionalProps)):andThen(function(p1) -- line: 117
			-- upvalues: InputValidity (copy), v31 (copy), t1 (copy), v36 (copy), v40 (copy), v32 (copy)
			local v65 = if not p1.InputValid then InputValidity.Invalid else InputValidity.Valid

			if v31 == p1.Input and t1.onTextChanged then
				t1.onTextChanged(p1.Input, v65)
			end

			v36(p1.IssueCondition)
			v40(v65)
			v32(p1.Input)
		end)
	end, t2)
	React.useEffect(function() -- line: 131
		-- upvalues: v39 (copy), InputValidity (copy), v42 (copy), t1 (copy), v35 (copy), IssueCondition (copy)
		if v39 ~= InputValidity.Invalid then
			v42(nil)

			return
		end

		local v57 = nil

		if t1.validatorIssuePriorityList then
			for _, v in ipairs(t1.validatorIssuePriorityList) do
				if v35[v] == IssueCondition.Problematic then
					v57 = v

					break
				end
			end
		else
			for k, v in pairs(v35) do
				if v == IssueCondition.Problematic then
					v57 = k

					break
				end
			end
		end

		if v57 == nil then
			v42(nil)

			return
		end

		if t1.onErrorShown then
			t1.onErrorShown(v57)
		end

		if t1.validatorIssueMessageList then
			v42(t1.validatorIssueMessageList[v57])

			return
		end

		v42(t1.validator.getIssueMessageList()[v57])
	end, { v39 })
	React.useEffect(function() -- line: 172
		-- upvalues: GetFFlagEnableMultiPageSignupV2Updates (copy), v43 (copy), t1 (copy), v44 (copy)
		if GetFFlagEnableMultiPageSignupV2Updates() and v43 then
			local textBoxRef = t1.textBoxRef

			if textBoxRef.current and textBoxRef.current.focus then
				textBoxRef.current.focus()
			end

			v44(false)
		end
	end, { v43 })

	local function getTextInputType() -- line: 191
		-- upvalues: t1 (copy), v37 (copy)
		if t1.textInputType == Enum.TextInputType.Password then
			if v37 then
				return Enum.TextInputType.Password
			end

			return Enum.TextInputType.PasswordShown
		end

		return t1.textInputType
	end
	local function getShowPasswordIconButton() -- line: 201
		-- upvalues: t1 (copy), v37 (copy), UIConstants (copy), v38 (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), v44 (copy)
		if t1.textInputType == Enum.TextInputType.Password then
			if v37 then
				return UIConstants.HIDE_PASSWORD_ICON, function() -- line: 205
					-- upvalues: v38 (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), v44 (copy)
					v38(false)

					if GetFFlagEnableMultiPageSignupV2Updates() then
						v44(true)
					end
				end
			end

			return UIConstants.SHOW_PASSWORD_ICON, function() -- line: 213
				-- upvalues: v38 (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), v44 (copy)
				v38(true)

				if GetFFlagEnableMultiPageSignupV2Updates() then
					v44(true)
				end
			end
		end

		return nil, nil
	end

	local v51 = useLocalization({
		errorText = v41
	})
	local v52, v53 = getShowPasswordIconButton()
	local v54 = if v39 ~= InputValidity.Invalid or (not GetFFlagEnableLuafiedRecoveryFlow() or not t1.useFoundationTextForIssue) then if v39 ~= InputValidity.Invalid then nil else React.createElement(StyledTextLabel, {
		textWrapped = true,
		text = v51.errorText or "",
		fontStyle = v30.Font.BodySmall,
		colorStyle = v30.Theme.Alert,
		automaticSize = Enum.AutomaticSize.XY
	}) else React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v27.Size.Size_200)
	}, {
		IssuePadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, t1.foundationIssueTextPadding or 0)
		}),
		IssueText = React.createElement(FoundationText, {
			Text = v51.errorText or "",
			fontStyle = v27.Typography.CaptionSmall,
			textStyle = v27.Color.System.Alert,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
	local Size_100 = v26.Size.Size_100

	if GetFFlagEnableLuafiedRecoveryFlow() then
		Size_100 = t1.customPadding or v26.Size.Size_100
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Size_100),
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		}),
		TextInputBox = React.createElement(TextInput, {
			LayoutOrder = 1,
			label = "",
			textInputType = if t1.textInputType ~= Enum.TextInputType.Password then t1.textInputType else if not v37 then Enum.TextInputType.PasswordShown else Enum.TextInputType.Password,
			width = UDim.new(1, 0),
			text = t1.initialText or "",
			placeholder = t1.placeholder,
			onChanged = function(s2: string) -- line: 185
				-- upvalues: t1 (copy), InputValidity (copy), v40 (copy), v32 (copy)
				t1.onTextChanged(s2, InputValidity.Unvalidated)
				v40(InputValidity.Unvalidated)
				v32(s2)
			end,
			iconTrailing = if not GetFFlagEnableLuafiedRecoveryFlow() or not t1.hideIconButton then if not v52 then nil else {
				name = v52,
				onActivated = v53
			} else nil,
			hasError = v39 == InputValidity.Invalid and #v31 > 0,
			textBoxRef = t1.textBoxRef,
			size = t1.size
		}),
		IssueWrapper = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, GetFFlagEnableLuafiedRecoveryFlow() and t1.issueHeight or v26.Size.Size_400)
		}, {
			Issue = v54
		})
	})
end

return AuthTextInputValidator
