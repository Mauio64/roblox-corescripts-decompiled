local Parent = script:FindFirstAncestor("AuthSignup").Parent
local Roact = require(Parent.Roact)
local Otter = require(Parent.Otter)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Parent.Localization).withLocalization
local AuthCommon = require(Parent.AuthCommon)
local FitChildren = AuthCommon.Components.FitChildren
local FitTextLabel = AuthCommon.Components.FitTextLabel
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local PasswordBox = AuthCommon.Components.PasswordBox
local GenericTextBox = AuthCommon.Components.GenericTextBox
local IssueTracker = AuthCommon.Components.IssueTracker
local InputValidity = AuthCommon.Enums.InputValidity
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local TextInput = Foundation.TextInput
local v21 = Roact.PureComponent:extend("CollapsingTextInputValidator")
local SharedFlags = require(Parent.SharedFlags)
local GetFFlagLuaAppEnable10ftSignUpView = SharedFlags.GetFFlagLuaAppEnable10ftSignUpView
local GetFFlagEnableAuthStatefulTextInputUpdates = SharedFlags.GetFFlagEnableAuthStatefulTextInputUpdates
local FFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local GetFFlagLuaAppEnableOpenTypeSignUpPageFix = SharedFlags.GetFFlagLuaAppEnableOpenTypeSignUpPageFix
local EngineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagAuthCollapsingValidatorFoundationInput = SharedFlags.GetFFlagAuthCollapsingValidatorFoundationInput

local function computeIsInErrorState(p1, p2) -- line: 56
	-- upvalues: FFlagSignUpTrackFailedRequest (copy), InputValidity (copy)
	if FFlagSignUpTrackFailedRequest and p1.hasFieldFailed then
		return true
	end

	if not p1.prerequisiteMet then
		return p2.textBoxFocused or p2.interactionBegan and p2.inputTextToValidate ~= ""
	end

	if p2.inputTextToValidate == "" then
		return false
	end

	if p2.isInputTextValid == InputValidity.Invalid then
		return p2.interactionBegan
	end

	return false
end

v21.defaultProps = {
	prerequisiteMet = true,
	captureFocusOnTapStart = true
}

function v21.init(p3) -- line: 77
	-- upvalues: InputValidity (copy), Roact (copy), GetFFlagAuthCollapsingValidatorFoundationInput (copy), FFlagSignUpTrackFailedRequest (copy), withStyle (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), EngineFeature (copy), PasswordBox (copy), GenericTextBox (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeSignUpPageFix (copy), OpenTypeSupport (copy), TextInput (copy)
	p3.state = {
		inputTextToValidate = "",
		validatedInputText = "",
		interactionBegan = false,
		textBoxFocused = false,
		textBoxHover = false,
		issueSummaryHeight = 0,
		issueFullListHeight = 0,
		isInputTextValid = InputValidity.Unvalidated
	}
	p3.isMounted = false
	p3.frameRef = Roact.createRef()

	if p3.props.useFoundationTextInput and GetFFlagAuthCollapsingValidatorFoundationInput() then
		p3.foundationTextBoxRef = Roact.createRef()
		p3.foundationProxyText = p3.props.prefilledText or ""
		p3.foundationTextBoxProxy = nil
	end

	function p3.getFrameRef() -- line: 100
		-- upvalues: p3 (copy)
		return p3.props.frameRef or p3.frameRef
	end

	local v35, v36 = Roact.createBinding(1)

	p3.issueSummaryTextTransparency = v35
	p3.updateIssueSummaryTextTransparency = v36

	local v37, v38 = Roact.createBinding(1)

	p3.issueFullListTextTransparency = v37
	p3.updateIssueFullListTextTransparency = v38

	local v39, v40 = Roact.createBinding(1)

	p3.issueCheckmarkTransparency = v39
	p3.updateIssueCheckmarkTransparency = v40

	local v41, v42 = Roact.createBinding(UDim2.new(1, 0, 0, 0))

	p3.issueTrackerHeight = v41
	p3.updateIssueTrackerHeight = v42
	p3.springOptions = {
		frequency = 3
	}

	function p3.onSizeChange(p4, p5) -- line: 113
		-- upvalues: p3 (copy)
		local AbsoluteSize = p5.AbsoluteSize

		if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
			spawn(function() -- line: 119
				-- upvalues: p3 (copy), p4 (copy), AbsoluteSize (copy)
				if p3.isMounted then
					p3:setState({
						[p4] = AbsoluteSize.Y
					})
				end
			end)
		end
	end
	function p3.onIssueSummarySizeChange(p6) -- line: 129
		-- upvalues: p3 (copy)
		p3.onSizeChange("issueSummaryHeight", p6)
	end
	function p3.onIssueFullListSizeChange(p7) -- line: 133
		-- upvalues: p3 (copy)
		p3.onSizeChange("issueFullListHeight", p7)
	end
	function p3.textInputChangedCallback(p8) -- line: 137
		-- upvalues: p3 (copy), InputValidity (copy)
		spawn(function() -- line: 138
			-- upvalues: p3 (copy), p8 (copy), InputValidity (copy)
			if p3.isMounted then
				local p8Text = p8.Text
				local onInputTextChanged = p3.props.onInputTextChanged

				if onInputTextChanged then
					onInputTextChanged(p8Text, InputValidity.Unvalidated)
				end

				p3:setState({
					interactionBegan = true,
					inputTextToValidate = p8Text,
					isInputTextValid = InputValidity.Unvalidated
				})
			end
		end)
	end
	function p3.foundationTextInputChangedCallback(p9) -- line: 156
		-- upvalues: p3 (copy)
		p3.foundationProxyText = p9
		p3.textInputChangedCallback({
			Text = p9
		})
	end
	function p3.bindFoundationTextBoxProxy() -- line: 161
		-- upvalues: p3 (copy)
		local textBoxRef = p3.props.textBoxRef

		if textBoxRef == nil or p3.foundationTextBoxProxy ~= nil then
			return
		end

		local t1 = {
			CaptureFocus = function() -- line: 168
				-- upvalues: p3 (copy)
				local current = p3.foundationTextBoxRef.current

				if current and current.focus then
					current.focus()
				end
			end,
			ReleaseFocus = function() -- line: 174
				-- upvalues: p3 (copy)
				local current = p3.foundationTextBoxRef.current

				if current and current.releaseFocus then
					current.releaseFocus()
				end
			end,
			IsFocused = function() -- line: 180
				-- upvalues: p3 (copy)
				local current = p3.foundationTextBoxRef.current

				if current and current.getIsFocused then
					return current.getIsFocused() == true
				end

				return false
			end
		}

		setmetatable(t1, {
			__index = function(_, p11) -- line: 193
				-- upvalues: p3 (copy)
				if p11 == "Text" then
					return p3.foundationProxyText or ""
				end

				return nil
			end,
			__newindex = function(_, p13, p14) -- line: 199
				-- upvalues: p3 (copy), t1 (copy)
				if p13 == "Text" then
					local v102 = typeof(p14) ~= "string" and "" or p14

					p3.foundationProxyText = v102
					p3.foundationTextInputChangedCallback(v102)

					return
				end

				rawset(t1, p13, p14)
			end
		})
		p3.foundationTextBoxProxy = t1
		textBoxRef.current = t1
	end
	function p3.onTextValidated(p15, p16, p17) -- line: 214
		-- upvalues: p3 (copy), FFlagSignUpTrackFailedRequest (copy)
		spawn(function() -- line: 215
			-- upvalues: p3 (copy), p15 (copy), FFlagSignUpTrackFailedRequest (copy), p16 (copy), p17 (copy)
			if p3.isMounted and p3.state.inputTextToValidate == p15 then
				local onInputTextValidated = p3.props.onInputTextValidated

				if onInputTextValidated then
					if FFlagSignUpTrackFailedRequest then
						onInputTextValidated(p15, p16, p17)
					else
						onInputTextValidated(p15, p16)
					end
				end

				p3:setState({
					validatedInputText = p15,
					isInputTextValid = p16
				})
			end
		end)
	end
	function p3.onTextInputBoxFocused() -- line: 235
		-- upvalues: p3 (copy)
		spawn(function() -- line: 236
			-- upvalues: p3 (copy)
			if p3.isMounted then
				local v104 = p3.getFrameRef()

				if p3.props.textBoxFocusedCallback and v104.current then
					p3.props.textBoxFocusedCallback(v104.current.AbsolutePosition)
				end

				p3:setState({
					textBoxFocused = true
				})
			end
		end)
	end
	function p3.onMouseEnter() -- line: 250
		-- upvalues: p3 (copy)
		if p3.isMounted then
			p3:setState({
				textBoxHover = true
			})
		end
	end
	function p3.onMouseLeave() -- line: 258
		-- upvalues: p3 (copy)
		if p3.isMounted then
			p3:setState({
				textBoxHover = false
			})
		end
	end
	function p3.onTextInputBoxFocusLost() -- line: 266
		-- upvalues: p3 (copy)
		spawn(function() -- line: 267
			-- upvalues: p3 (copy)
			if p3.isMounted then
				if p3.props.textBoxFocusLostCallback then
					p3.props.textBoxFocusLostCallback()
				end

				p3:setState({
					textBoxFocused = false
				})
			end
		end)
	end
	function p3.onPositionChanged() -- line: 280
		-- upvalues: p3 (copy)
		spawn(function() -- line: 281
			-- upvalues: p3 (copy)
			if p3.isMounted and p3.state.textBoxFocused then
				local v105 = p3.getFrameRef()

				if p3.props.focusedTextBoxPositionChangedCallback and v105.current then
					p3.props.focusedTextBoxPositionChangedCallback(v105.current.AbsolutePosition)
				end
			end
		end)
	end
	function p3.isInErrorState() -- line: 291
		-- upvalues: p3 (copy), FFlagSignUpTrackFailedRequest (copy), InputValidity (copy)
		local props = p3.props
		local state = p3.state

		if FFlagSignUpTrackFailedRequest and props.hasFieldFailed then
			return true
		end

		local textBoxFocused

		if not props.prerequisiteMet then
			textBoxFocused = state.textBoxFocused

			if not textBoxFocused then
				textBoxFocused = state.interactionBegan

				if textBoxFocused then
					return state.inputTextToValidate ~= ""
				end
			end
		else
			if state.inputTextToValidate == "" then
				return false
			end

			if state.isInputTextValid == InputValidity.Invalid then
				return state.interactionBegan
			end

			textBoxFocused = false
		end

		return textBoxFocused
	end
	function p3.textInputBoxWithBorder() -- line: 298
		-- upvalues: withStyle (copy), p3 (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), EngineFeature (copy), Roact (copy), PasswordBox (copy), GenericTextBox (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeSignUpPageFix (copy), OpenTypeSupport (copy)
		return withStyle(function(p18) -- line: 299
			-- upvalues: p3 (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), EngineFeature (copy), Roact (copy), PasswordBox (copy), GenericTextBox (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeSignUpPageFix (copy), OpenTypeSupport (copy)
			local tokens = p3.props.tokens
			local BodyFont = p18.Font.Body.Font
			local v109 = p18.Font.BaseSize * p18.Font.Body.RelativeSize

			if GetFFlagLuaAppEnable10ftSignUpView() and tokens then
				v109 = tokens.textBodySize
			end

			local TextDefaultColor = p18.Theme.TextDefault.Color
			local TextDefaultTransparency = p18.Theme.TextDefault.Transparency
			local BackgroundUIContrastColor = p18.Theme.BackgroundUIContrast.Color
			local BackgroundUIContrastTransparency = p18.Theme.BackgroundUIContrast.Transparency
			local TextDefaultColor2 = p18.Theme.TextDefault.Color
			local placeholderText = p3.props.placeholderText
			local textInputType = p3.props.textInputType
			local returnKeyType = p3.props.returnKeyType
			local v118 = p3.props.prefilledText or ""

			if textInputType == Enum.TextInputType.Password or EngineFeature and textInputType == Enum.TextInputType.NewPassword then
				return Roact.createElement(PasswordBox, {
					Text = "",
					PlaceholderColor3 = nil,
					ManualFocusRelease = false,
					Size = UDim2.new(1, 0, 1, 0),
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextSize = v109,
					TextColor = TextDefaultColor,
					TextTransparency = TextDefaultTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					PlaceholderText = placeholderText,
					PlaceholderColor = TextDefaultColor2,
					ReturnKeyType = returnKeyType,
					CaptureFocusOnTapStart = p3.props.captureFocusOnTapStart,
					Disabled = p3.props.disabled,
					onChangeText = p3.textInputChangedCallback,
					onFocused = p3.onTextInputBoxFocused,
					onFocusLost = p3.onTextInputBoxFocusLost,
					onMouseEnter = p3.onMouseEnter,
					onMouseLeave = p3.onMouseLeave,
					onReturnPressedFromOnScreenKeyboard = p3.props.onReturnPressedFromOnScreenKeyboard,
					IsKeyboardOverlayUsed = p3.props.IsKeyboardOverlayUsed,
					TextBoxRef = p3.props.textBoxRef,
					CentralOverlayBlocksInput = p3.props.centralOverlayBlocksInput,
					hidePassword = p3.props.hidePassword,
					onToggleCallback = p3.props.onToggleCallback,
					IsNewPassword = EngineFeature and (textInputType == Enum.TextInputType.NewPassword or textInputType == Enum.TextInputType.NewPasswordShown)
				})
			end

			return Roact.createElement(GenericTextBox, {
				ClearTextOnFocus = false,
				PaddingX = 12,
				PaddingY = 7,
				Size = UDim2.new(1, 0, 1, 0),
				Text = v118,
				Font = BodyFont,
				TextSize = v109,
				TextColor = TextDefaultColor,
				TextTransparency = TextDefaultTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Color = BackgroundUIContrastColor,
				Transparency = BackgroundUIContrastTransparency,
				TextInputType = textInputType,
				openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() or not GetFFlagLuaAppEnableOpenTypeSignUpPageFix() then nil else OpenTypeSupport:getUserNameStylisticAlternative(),
				ReturnKeyType = returnKeyType,
				PlaceholderText = placeholderText,
				PlaceholderColor = TextDefaultColor2,
				onChangeText = p3.textInputChangedCallback,
				onFocused = p3.onTextInputBoxFocused,
				onFocusLost = p3.onTextInputBoxFocusLost,
				onMouseEnter = p3.onMouseEnter,
				onMouseLeave = p3.onMouseLeave,
				onReturnPressedFromOnScreenKeyboard = p3.props.onReturnPressedFromOnScreenKeyboard,
				NextSelectionDown = p3.props.NextSelectionDown,
				TextBoxRef = p3.props.textBoxRef
			})
		end)
	end
	function p3.textInputBoxFoundation() -- line: 391
		-- upvalues: Roact (copy), TextInput (copy), p3 (copy)
		return Roact.createElement(TextInput, {
			LayoutOrder = 1,
			label = "",
			width = UDim.new(1, 0),
			text = p3.foundationProxyText or "",
			placeholder = p3.props.placeholderText,
			textInputType = p3.props.textInputType,
			hasError = p3.isInErrorState(),
			isDisabled = p3.props.disabled,
			onChanged = p3.foundationTextInputChangedCallback,
			onFocusGained = p3.onTextInputBoxFocused,
			onFocusLost = p3.onTextInputBoxFocusLost,
			onReturnPressed = p3.props.onReturnPressedFromOnScreenKeyboard,
			textBoxRef = p3.foundationTextBoxRef
		})
	end
end
function v21.isUsingFoundationTextInput(p19) -- line: 410
	-- upvalues: GetFFlagAuthCollapsingValidatorFoundationInput (copy)
	return p19.props.useFoundationTextInput and GetFFlagAuthCollapsingValidatorFoundationInput()
end
function v21.didMount(p20) -- line: 414
	-- upvalues: Otter (copy), InputValidity (copy)
	p20.isMounted = true

	if p20:isUsingFoundationTextInput() then
		p20.bindFoundationTextBoxProxy()
	end

	p20.motor = Otter.createGroupMotor({
		issueSummaryTextTransparency = 1,
		issueFullListTextTransparency = 1,
		issueCheckmarkTransparency = 1,
		issueTrackerHeight = 0
	})
	p20.motor:onStep(function(p21) -- line: 428
		-- upvalues: p20 (copy)
		p20.updateIssueSummaryTextTransparency(p21.issueSummaryTextTransparency)
		p20.updateIssueFullListTextTransparency(p21.issueFullListTextTransparency)
		p20.updateIssueCheckmarkTransparency(p21.issueCheckmarkTransparency)
		p20.updateIssueTrackerHeight(UDim2.new(1, 0, 0, p21.issueTrackerHeight))
	end)
	p20.motor:onComplete(function() -- line: 435
		-- upvalues: p20 (copy)
		if p20.props.onAnimationStateChangeCallback then
			p20.props.onAnimationStateChangeCallback(p20.props.textInputType, false)
		end
	end)
	p20.motor:start()

	local prefilledText = p20.props.prefilledText

	if prefilledText and prefilledText ~= "" then
		p20:setState({
			interactionBegan = false,
			inputTextToValidate = prefilledText,
			isInputTextValid = InputValidity.Unvalidated
		})
	end
end
function v21.didUpdate(p22, p23, p24) -- line: 453
	-- upvalues: FFlagSignUpTrackFailedRequest (copy), InputValidity (copy), Otter (copy)
	if p22:isUsingFoundationTextInput() and p23.prefilledText ~= p22.props.prefilledText then
		p22.foundationTextInputChangedCallback(p22.props.prefilledText or "")
	end

	local textBoxFocused = p22.state.textBoxFocused
	local issueSummaryHeight = p22.state.issueSummaryHeight
	local issueFullListHeight = p22.state.issueFullListHeight
	local showDetailedError = p22.props.showDetailedError
	local v53 = p24.validatedInputText ~= ""
	local v54 = not textBoxFocused or not p22.props.prerequisiteMet
	local v55 = p22.state.validatedInputText ~= ""
	local props = p22.props
	local state = p22.state
	local v58 = FFlagSignUpTrackFailedRequest and not not props.hasFieldFailed or if props.prerequisiteMet then state.inputTextToValidate ~= "" and (state.isInputTextValid == InputValidity.Invalid and state.interactionBegan) else state.textBoxFocused or state.interactionBegan and state.inputTextToValidate ~= ""
	local v59 = FFlagSignUpTrackFailedRequest and not not p23.hasFieldFailed or if p23.prerequisiteMet then p24.inputTextToValidate ~= "" and (p24.isInputTextValid == InputValidity.Invalid and p24.interactionBegan) else p24.textBoxFocused or p24.interactionBegan and p24.inputTextToValidate ~= ""

	if showDetailedError and v58 then
		v54 = false
		v55 = true
	end

	local v60 = if not textBoxFocused and (not showDetailedError or not v58) then not v58 and 0 or issueSummaryHeight else if not p22.props.prerequisiteMet then issueSummaryHeight else issueFullListHeight
	local v61 = false

	if p22.props.pillClicked then
		issueSummaryHeight = 0
		v60 = 0
		p22.props.resetPillClicked()
		v61 = true
	end

	if textBoxFocused ~= p24.textBoxFocused or v53 ~= v55 or (showDetailedError and v58 or v58 ~= v59) then
		p22.motor:setGoal({
			issueSummaryTextTransparency = Otter.spring(not v54 and 1 or 0, p22.springOptions),
			issueFullListTextTransparency = Otter.spring(not v54 and 0 or 1, p22.springOptions),
			issueCheckmarkTransparency = Otter.spring(not v55 and 1 or 0, p22.springOptions),
			issueTrackerHeight = Otter.spring(v60, p22.springOptions)
		})

		if p22.props.onAnimationStateChangeCallback then
			p22.props.onAnimationStateChangeCallback(p22.props.textInputType, true)

			return
		end
	elseif issueSummaryHeight ~= p24.issueSummaryHeight or issueFullListHeight ~= p24.issueFullListHeight then
		if v61 then
			p22.motor:setGoal({
				issueTrackerHeight = Otter.spring(v60, p22.springOptions)
			})
		else
			p22.motor:setGoal({
				issueTrackerHeight = Otter.instant(v60)
			})
		end

		if p22.props.onAnimationStateChangeCallback then
			p22.props.onAnimationStateChangeCallback(p22.props.textInputType, true)
		end
	end
end
function v21.willUnmount(p25) -- line: 544
	p25.isMounted = false
	p25.motor:destroy()

	if p25.foundationTextBoxProxy ~= nil and (p25.props.textBoxRef ~= nil and p25.props.textBoxRef.current == p25.foundationTextBoxProxy) then
		p25.props.textBoxRef.current = nil
		p25.foundationTextBoxProxy = nil
	end
end
function v21.render(p26) -- line: 558
	-- upvalues: AuthStatefulRoundCornerBorder (copy), withStyle (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), withLocalization (copy), Roact (copy), FitChildren (copy), FitTextLabel (copy), Loading (copy), IconSize (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), GetFFlagEnableAuthStatefulTextInputUpdates (copy), IssueTracker (copy), FFlagSignUpTrackFailedRequest (copy)
	local layoutOrder = p26.props.layoutOrder
	local titleTextKey = p26.props.titleTextKey
	local summaryErrorTextKey = p26.props.summaryErrorTextKey
	local validator = p26.props.validator
	local validatorAdditionalProps = p26.props.validatorAdditionalProps
	local inputTextToValidate = p26.state.inputTextToValidate
	local tokens = p26.props.tokens

	if not p26.props.prerequisiteMet then
		inputTextToValidate = ""
	end

	local Default = AuthStatefulRoundCornerBorder.BorderState.Default

	if p26.isInErrorState() then
		Default = AuthStatefulRoundCornerBorder.BorderState.Error
	elseif p26.state.textBoxFocused then
		Default = AuthStatefulRoundCornerBorder.BorderState.Focused
	elseif p26.state.textBoxHover then
		Default = AuthStatefulRoundCornerBorder.BorderState.Hover
	end

	local v72 = p26:isUsingFoundationTextInput()

	return withStyle(function(p27) -- line: 583
		-- upvalues: GetFFlagLuaAppEnable10ftSignUpView (copy), tokens (copy), withLocalization (copy), titleTextKey (copy), summaryErrorTextKey (copy), Roact (copy), FitChildren (copy), layoutOrder (copy), p26 (copy), FitTextLabel (copy), v72 (copy), AuthStatefulRoundCornerBorder (copy), Default (ref), Loading (copy), IconSize (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), GetFFlagEnableAuthStatefulTextInputUpdates (copy), IssueTracker (copy), validator (copy), validatorAdditionalProps (copy), inputTextToValidate (ref), FFlagSignUpTrackFailedRequest (copy)
		local u90 = p27.Font.BaseSize * p27.Font.CaptionHeader.RelativeSize
		local n1 = 5

		if GetFFlagLuaAppEnable10ftSignUpView() and tokens then
			n1 = tokens.boxPadding
			u90 = tokens.textCaptionHeaderSize
		end

		return withLocalization({
			titleText = titleTextKey,
			summaryErrorText = summaryErrorTextKey
		})(function(p28) -- line: 595
			-- upvalues: Roact (copy), FitChildren (copy), layoutOrder (copy), p26 (copy), n1 (ref), FitTextLabel (copy), p27 (copy), u90 (ref), v72 (copy), AuthStatefulRoundCornerBorder (copy), GetFFlagLuaAppEnable10ftSignUpView (copy), tokens (copy), Default (ref), Loading (copy), IconSize (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), titleTextKey (copy), GetFFlagEnableAuthStatefulTextInputUpdates (copy), IssueTracker (copy), validator (copy), validatorAdditionalProps (copy), inputTextToValidate (ref), FFlagSignUpTrackFailedRequest (copy)
			return Roact.createElement(FitChildren.FitFrame, {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = p26.getFrameRef(),
				[Roact.Change.AbsolutePosition] = p26.onPositionChanged
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, n1)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, not p26.props.paddingBottomOverride and 5 or p26.props.paddingBottomOverride)
				}),
				Title = Roact.createElement(FitTextLabel, {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = p28.titleText or "",
					Font = p27.Font.CaptionHeader.Font,
					TextSize = u90,
					TextColor3 = p27.Theme.TextEmphasis.Color,
					TextTransparency = p27.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				TextInputBox = if not v72 then Roact.createElement(AuthStatefulRoundCornerBorder, {
					layoutOrder = 1,
					size = UDim2.new(1, 0, 0, (not GetFFlagLuaAppEnable10ftSignUpView() or not tokens) and 36 or tokens.textboxHeight),
					borderState = Default
				}, {
					textbox = Roact.createElement(p26.textInputBoxWithBorder),
					loadingSpinner = if not p26.props.shouldShowLoadingIcon then nil else Roact.createElement(Loading, {
						size = IconSize.Small,
						Position = UDim2.new(1, -22, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}) else Roact.createElement(p26.textInputBoxFoundation),
				RegisterTitleAuditContent = if not GetFFlagEnableAuditForSinglePageSignUp() or (not p26.props.enableAuditContentCapture or not RegisterAuditContent) then nil else Roact.createElement(RegisterAuditContent, {
					translationKey = titleTextKey,
					translatedSourceString = p28.titleText
				}),
				AnimatedWrapper = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = p26.issueTrackerHeight
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, 12),
						PaddingLeft = if not GetFFlagEnableAuthStatefulTextInputUpdates() then UDim.new(0, 12) else UDim.new(0, 0)
					}),
					IssueSummaryWrapper = Roact.createElement(FitChildren.FitFrame, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundTransparency = 1,
						[Roact.Change.AbsoluteSize] = p26.onIssueSummarySizeChange
					}, {
						IssueSummaryText = p26.isInErrorState() and Roact.createElement(FitTextLabel, {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Size = UDim2.new(1, 0, 0, 0),
							fitAxis = FitChildren.FitAxis.Height,
							Text = p28.summaryErrorText or "",
							Font = p27.Font.CaptionBody.Font,
							TextSize = p27.Font.BaseSize * p27.Font.CaptionBody.RelativeSize,
							TextColor3 = p27.Theme.Alert.Color,
							TextTransparency = p26.issueSummaryTextTransparency,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					}),
					IssueTrackerWrapper = Roact.createElement(FitChildren.FitFrame, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundTransparency = 1,
						[Roact.Change.AbsoluteSize] = p26.onIssueFullListSizeChange
					}, {
						IssueTracker = Roact.createElement(IssueTracker, {
							validator = validator,
							validatorAdditionalProps = validatorAdditionalProps,
							textToValidate = inputTextToValidate,
							onTextValidated = p26.onTextValidated,
							contentTransparency = p26.issueFullListTextTransparency,
							checkmarkTransparency = p26.issueCheckmarkTransparency,
							updateIssueCondition = p26.props.updateIssueCondition,
							debounceTime = if not FFlagSignUpTrackFailedRequest then nil else p26.props.debounceTime
						})
					})
				})
			})
		end)
	end)
end

return v21
