local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Roact")

local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Otter")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local openTypeSupport = UIBlox.Utility.OpenTypeSupport
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Localization").withLocalization

local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText
local fitChildren = AuthCommon.Components.FitChildren
local fitTextLabel = AuthCommon.Components.FitTextLabel
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local passwordBox = AuthCommon.Components.PasswordBox
local genericTextBox = AuthCommon.Components.GenericTextBox
local issueTracker = AuthCommon.Components.IssueTracker

local inputValidity = AuthCommon.Enums.InputValidity
local registerAuditContent = AuthCommon.Components.RegisterAuditContent

local textInput = Foundation.TextInput
local inputLabel = Foundation.InputLabel

local extended = Roact.PureComponent:extend("CollapsingTextInputValidator")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")
local getFFlagLuaAppEnable10ftSignUpView = SharedFlags.GetFFlagLuaAppEnable10ftSignUpView
local getFFlagEnableAuthStatefulTextInputUpdates = SharedFlags.GetFFlagEnableAuthStatefulTextInputUpdates
local fFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local getFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local getFFlagLuaAppEnableOpenTypeSignUpPageFix = SharedFlags.GetFFlagLuaAppEnableOpenTypeSignUpPageFix
local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local getFFlagAuthCollapsingValidatorFoundationInput = SharedFlags.GetFFlagAuthCollapsingValidatorFoundationInput
local fFlagAuthValidatorStyleOverrides = SharedFlags.FFlagAuthValidatorStyleOverrides
local fFlagAuthValidatorRebindTextBoxRef = SharedFlags.FFlagAuthValidatorRebindTextBoxRef

local function computeIsInErrorState(p2, data)
	if fFlagSignUpTrackFailedRequest and p2.hasFieldFailed then
		return true
	end

	if not p2.prerequisiteMet then
		return data.textBoxFocused or data.interactionBegan and data.inputTextToValidate ~= ""
	end

	if data.inputTextToValidate == "" then
		return false
	end

	if data.isInputTextValid == inputValidity.Invalid then
		return data.interactionBegan
	end

	return false
end

extended.defaultProps = { prerequisiteMet = true, captureFocusOnTapStart = true }

function extended:init()
	self.state = {
		inputTextToValidate = "",
		validatedInputText = "",
		isInputTextValid = inputValidity.Unvalidated,
		interactionBegan = false,
		textBoxFocused = false,
		textBoxHover = false,
		issueSummaryHeight = 0,
		issueFullListHeight = 0
	}

	self.isMounted = false
	self.frameRef = Roact.createRef()

	if self:isUsingFoundationTextInput() then
		self.foundationTextBoxRef = Roact.createRef()
		self.foundationProxyText = self.props.prefilledText or ""
		self.foundationTextBoxProxy = nil
	end

	if fFlagAuthValidatorRebindTextBoxRef and self.foundationTextBoxRef == nil then
		self.foundationTextBoxRef = Roact.createRef()
	end

	function self.getFrameRef()
		return self.props.frameRef or self.frameRef
	end

	local binding, v5 = Roact.createBinding(1)
	self.issueSummaryTextTransparency = binding
	self.updateIssueSummaryTextTransparency = v5
	local binding2, v6 = Roact.createBinding(1)
	self.issueFullListTextTransparency = binding2
	self.updateIssueFullListTextTransparency = v6
	local binding3, v7 = Roact.createBinding(1)
	self.issueCheckmarkTransparency = binding3
	self.updateIssueCheckmarkTransparency = v7
	local binding4, v8 = Roact.createBinding(UDim2.new(1, 0, 0, 0))
	self.issueTrackerHeight = binding4
	self.updateIssueTrackerHeight = v8

	function self.getContentGap()
		if fFlagAuthValidatorStyleOverrides and self.props.contentGapOverride then
			return self.props.contentGapOverride
		end

		if getFFlagLuaAppEnable10ftSignUpView() and self.props.tokens then
			return self.props.tokens.boxPadding
		end

		return 5
	end

	self.issueTrailingPadding = self.issueTrackerHeight:map(function(p2)
		return UDim.new(0, -math.max(0, self.getContentGap() - p2.Y.Offset))
	end)

	self.springOptions = { frequency = 3 }

	function self.onSizeChange(p2, p3)
		local absoluteSize = p3.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			spawn(function()
				if self.isMounted then
					self:setState({ [p2] = absoluteSize.Y })
				end
			end)
		end
	end

	function self.onIssueSummarySizeChange(p2)
		self.onSizeChange("issueSummaryHeight", p2)
	end

	function self.onIssueFullListSizeChange(p2)
		self.onSizeChange("issueFullListHeight", p2)
	end

	function self.textInputChangedCallback(p2)
		spawn(function()
			if self.isMounted then
				local text = p2.Text
				local onInputTextChanged = self.props.onInputTextChanged

				if onInputTextChanged then
					onInputTextChanged(text, inputValidity.Unvalidated)
				end

				self:setState({
					inputTextToValidate = text,
					isInputTextValid = inputValidity.Unvalidated,
					interactionBegan = true
				})
			end
		end)
	end

	function self.foundationTextInputChangedCallback(foundationProxyText)
		self.foundationProxyText = foundationProxyText
		self.textInputChangedCallback({ Text = foundationProxyText })
	end

	function self.bindFoundationTextBoxProxy()
		local textBoxRef = self.props.textBoxRef

		if textBoxRef == nil or self.foundationTextBoxProxy ~= nil then
			return
		end

		local v9 = {
			CaptureFocus = function()
				local current = self.foundationTextBoxRef.current

				if current and current.focus then
					current.focus()
				end
			end,
			ReleaseFocus = function()
				local current = self.foundationTextBoxRef.current

				if current and current.releaseFocus then
					current.releaseFocus()
				end
			end,
			IsFocused = function(): boolean
				local current = self.foundationTextBoxRef.current

				if current and current.getIsFocused then
					return current.getIsFocused() == true
				end

				return false
			end
		}

		setmetatable(v9, {
			__index = function(p2, p3)
				if p3 == "Text" then
					return self.foundationProxyText or ""
				end

				return nil
			end,
			__newindex = function(p2, p3, value)
				if p3 ~= "Text" then
					rawset(v9, p3, value)

					return
				end

				local v10 = typeof(value) ~= "string" and "" or value
				self.foundationProxyText = v10
				self.foundationTextInputChangedCallback(v10)
			end
		})

		self.foundationTextBoxProxy = v9
		textBoxRef.current = v9
	end

	function self.onTextValidated(p2, p3, p4)
		spawn(function()
			if self.isMounted and self.state.inputTextToValidate == p2 then
				local onInputTextValidated = self.props.onInputTextValidated

				if onInputTextValidated then
					if fFlagSignUpTrackFailedRequest then
						onInputTextValidated(p2, p3, p4)
					else
						onInputTextValidated(p2, p3)
					end
				end

				self:setState({ validatedInputText = p2, isInputTextValid = p3 })
			end
		end)
	end

	function self.onTextInputBoxFocused()
		spawn(function()
			if self.isMounted then
				local frameRef = self.getFrameRef()

				if self.props.textBoxFocusedCallback and frameRef.current then
					self.props.textBoxFocusedCallback(frameRef.current.AbsolutePosition)
				end

				self:setState({ textBoxFocused = true })
			end
		end)
	end

	function self.onMouseEnter()
		if self.isMounted then
			self:setState({ textBoxHover = true })
		end
	end

	function self.onMouseLeave()
		if self.isMounted then
			self:setState({ textBoxHover = false })
		end
	end

	function self.onTextInputBoxFocusLost()
		spawn(function()
			if self.isMounted then
				if self.props.textBoxFocusLostCallback then
					self.props.textBoxFocusLostCallback()
				end

				self:setState({ textBoxFocused = false })
			end
		end)
	end

	function self.onPositionChanged()
		spawn(function()
			if self.isMounted and self.state.textBoxFocused then
				local frameRef = self.getFrameRef()

				if self.props.focusedTextBoxPositionChangedCallback and frameRef.current then
					self.props.focusedTextBoxPositionChangedCallback(frameRef.current.AbsolutePosition)
				end
			end
		end)
	end

	function self.isInErrorState()
		local props = self.props
		local state = self.state

		if fFlagSignUpTrackFailedRequest and props.hasFieldFailed then
			return true
		end

		local v9

		if props.prerequisiteMet then
			if state.inputTextToValidate == "" then
				return false
			end

			if state.isInputTextValid == inputValidity.Invalid then
				return state.interactionBegan
			end

			v9 = false
		else
			v9 = state.textBoxFocused

			if v9 then
				return v9
			end

			v9 = state.interactionBegan

			if v9 then
				return state.inputTextToValidate ~= ""
			end
		end

		return v9
	end

	function self.textInputBoxWithBorder()
		return withStyle(function(p2)
			local tokens = self.props.tokens
			local font = p2.Font.Body.Font
			local v9 = p2.Font.BaseSize * p2.Font.Body.RelativeSize

			if getFFlagLuaAppEnable10ftSignUpView() and tokens then
				v9 = tokens.textBodySize
			end

			local color = p2.Theme.TextDefault.Color
			local transparency = p2.Theme.TextDefault.Transparency
			local color2 = p2.Theme.BackgroundUIContrast.Color
			local transparency2 = p2.Theme.BackgroundUIContrast.Transparency
			local color3 = p2.Theme.TextDefault.Color

			local placeholderText = self.props.placeholderText
			local textInputType = self.props.textInputType
			local returnKeyType = self.props.returnKeyType

			local prefilledText = self.props.prefilledText or ""

			if
				textInputType == Enum.TextInputType.Password
				or engineFeature and textInputType == Enum.TextInputType.NewPassword
			then
				return Roact.createElement(passwordBox, {
					Size = UDim2.new(1, 0, 1, 0),
					Color = color2,
					Transparency = transparency2,
					TextSize = v9,
					TextColor = color,
					TextTransparency = transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = "",
					PlaceholderText = placeholderText,
					PlaceholderColor3 = nil,
					PlaceholderColor = color3,
					ReturnKeyType = returnKeyType,
					ManualFocusRelease = false,
					CaptureFocusOnTapStart = self.props.captureFocusOnTapStart,
					Disabled = self.props.disabled,
					onChangeText = self.textInputChangedCallback,
					onFocused = self.onTextInputBoxFocused,
					onFocusLost = self.onTextInputBoxFocusLost,
					onMouseEnter = self.onMouseEnter,
					onMouseLeave = self.onMouseLeave,
					onReturnPressedFromOnScreenKeyboard = self.props.onReturnPressedFromOnScreenKeyboard,
					IsKeyboardOverlayUsed = self.props.IsKeyboardOverlayUsed,
					TextBoxRef = self.props.textBoxRef,
					CentralOverlayBlocksInput = self.props.centralOverlayBlocksInput,
					hidePassword = self.props.hidePassword,
					onToggleCallback = self.props.onToggleCallback,
					IsNewPassword = engineFeature and (textInputType == Enum.TextInputType.NewPassword or textInputType == Enum.TextInputType.NewPasswordShown)
				})
			end

			local createElement = Roact.createElement
			local v11 = {
				Size = UDim2.new(1, 0, 1, 0),
				Text = prefilledText,
				Font = font,
				TextSize = v9,
				TextColor = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Color = color2,
				Transparency = transparency2,
				TextInputType = textInputType,
				openTypeFeatures = 0,
				ReturnKeyType = 0,
				PaddingX = 12,
				PaddingY = 7,
				PlaceholderText = 0,
				PlaceholderColor = 0,
				onChangeText = 0,
				onFocused = 0,
				onFocusLost = 0,
				onMouseEnter = 0,
				onMouseLeave = 0,
				onReturnPressedFromOnScreenKeyboard = 0,
				NextSelectionDown = 0,
				TextBoxRef = 0
			}

			local v12 = if getFFlagLuaAppEnableOpenTypeSupport() and getFFlagLuaAppEnableOpenTypeSignUpPageFix() then openTypeSupport:getUserNameStylisticAlternative() else nil
			v11.openTypeFeatures = v12

			v11.ReturnKeyType = returnKeyType

			v11.PlaceholderText = placeholderText
			v11.PlaceholderColor = color3
			v11.onChangeText = self.textInputChangedCallback
			v11.onFocused = self.onTextInputBoxFocused
			v11.onFocusLost = self.onTextInputBoxFocusLost
			v11.onMouseEnter = self.onMouseEnter
			v11.onMouseLeave = self.onMouseLeave
			v11.onReturnPressedFromOnScreenKeyboard = self.props.onReturnPressedFromOnScreenKeyboard
			v11.NextSelectionDown = self.props.NextSelectionDown
			v11.TextBoxRef = self.props.textBoxRef
			return createElement(genericTextBox, v11)
		end)
	end

	function self.textInputBoxFoundation()
		local foundationInputSize, foundationIconTrailing

		if fFlagAuthValidatorStyleOverrides then
			foundationInputSize = self.props.foundationInputSize
			foundationIconTrailing = self.props.foundationIconTrailing
		end

		return Roact.createElement(textInput, {
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			size = foundationInputSize,
			iconTrailing = foundationIconTrailing,
			label = "",
			text = self.foundationProxyText or "",
			placeholder = self.props.placeholderText,
			textInputType = self.props.textInputType,
			hasError = self.isInErrorState(),
			isDisabled = self.props.disabled,
			onChanged = self.foundationTextInputChangedCallback,
			onFocusGained = self.onTextInputBoxFocused,
			onFocusLost = self.onTextInputBoxFocusLost,
			onReturnPressed = self.props.onReturnPressedFromOnScreenKeyboard,
			textBoxRef = self.foundationTextBoxRef,
			inputRef = self.props.foundationInputRef,
			NextSelectionDown = self.props.NextSelectionDown
		})
	end
end

function extended:isUsingFoundationTextInput()
	if fFlagAuthValidatorStyleOverrides then
		return self.props.useFoundationTextInput
	end

	return self.props.useFoundationTextInput and getFFlagAuthCollapsingValidatorFoundationInput()
end

function extended:didMount()
	self.isMounted = true

	if self:isUsingFoundationTextInput() then
		self.bindFoundationTextBoxProxy()
	end

	self.motor = Otter.createGroupMotor({
		issueSummaryTextTransparency = 1,
		issueFullListTextTransparency = 1,
		issueCheckmarkTransparency = 1,
		issueTrackerHeight = 0
	})

	self.motor:onStep(function(data)
		self.updateIssueSummaryTextTransparency(data.issueSummaryTextTransparency)
		self.updateIssueFullListTextTransparency(data.issueFullListTextTransparency)
		self.updateIssueCheckmarkTransparency(data.issueCheckmarkTransparency)
		self.updateIssueTrackerHeight(UDim2.new(1, 0, 0, data.issueTrackerHeight))
	end)

	self.motor:onComplete(function()
		if self.props.onAnimationStateChangeCallback then
			self.props.onAnimationStateChangeCallback(self.props.textInputType, false)
		end
	end)

	self.motor:start()

	local prefilledText = self.props.prefilledText

	if prefilledText and prefilledText ~= "" then
		self:setState({
			inputTextToValidate = prefilledText,
			isInputTextValid = inputValidity.Unvalidated,
			interactionBegan = false
		})
	end
end

function extended:didUpdate(data, data2)
	if self:isUsingFoundationTextInput() and data.prefilledText ~= self.props.prefilledText then
		self.foundationTextInputChangedCallback(self.props.prefilledText or "")
	end

	if
		fFlagAuthValidatorRebindTextBoxRef
		and data.useFoundationTextInput ~= self.props.useFoundationTextInput
	then
		if self:isUsingFoundationTextInput() then
			self.bindFoundationTextBoxProxy()
		else
			self.foundationTextBoxProxy = nil
			self.foundationProxyText = nil
		end
	end

	local textBoxFocused = self.state.textBoxFocused
	local v5 = self.state.issueSummaryHeight
	local issueFullListHeight = self.state.issueFullListHeight
	local showDetailedError = self.props.showDetailedError

	local v6 = data2.validatedInputText ~= ""

	local v7 = not (textBoxFocused and self.props.prerequisiteMet)
	local v8 = self.state.validatedInputText ~= ""

	local props = self.props
	local state = self.state
	local v9

	if fFlagSignUpTrackFailedRequest and props.hasFieldFailed then
		v9 = true
	elseif props.prerequisiteMet then
		if state.inputTextToValidate == "" or state.isInputTextValid ~= inputValidity.Invalid then
			v9 = false
		else
			v9 = state.interactionBegan
		end
	else
		v9 = state.textBoxFocused or state.interactionBegan and state.inputTextToValidate ~= ""
	end

	local v10

	if fFlagSignUpTrackFailedRequest and data.hasFieldFailed then
		v10 = true
	elseif data.prerequisiteMet then
		if data2.inputTextToValidate == "" or data2.isInputTextValid ~= inputValidity.Invalid then
			v10 = false
		else
			v10 = data2.interactionBegan
		end
	else
		v10 = data2.textBoxFocused or data2.interactionBegan and data2.inputTextToValidate ~= ""
	end

	if showDetailedError and v9 then
		v8 = true
		v7 = false
	end

	local v11

	if textBoxFocused or showDetailedError and v9 then
		v11 = if self.props.prerequisiteMet then issueFullListHeight else v5
	else
		v11 = not v9 and 0 or v5
	end

	local flag

	if self.props.pillClicked then
		self.props.resetPillClicked()
		v11 = 0
		v5 = 0
		flag = true
	else
		flag = false
	end

	if
		textBoxFocused == data2.textBoxFocused
		and v6 == v8
		and not (showDetailedError and v9)
		and v9 == v10
	then
		if v5 ~= data2.issueSummaryHeight or issueFullListHeight ~= data2.issueFullListHeight then
			if flag then
				self.motor:setGoal({
					issueTrackerHeight = Otter.spring(v11, self.springOptions)
				})
			else
				self.motor:setGoal({ issueTrackerHeight = Otter.instant(v11) })
			end

			if self.props.onAnimationStateChangeCallback then
				self.props.onAnimationStateChangeCallback(self.props.textInputType, true)
			end
		end
	else
		self.motor:setGoal({
			issueSummaryTextTransparency = Otter.spring(v7 and 0 or 1, self.springOptions),
			issueFullListTextTransparency = Otter.spring(v7 and 1 or 0, self.springOptions),
			issueCheckmarkTransparency = Otter.spring(v8 and 0 or 1, self.springOptions),
			issueTrackerHeight = Otter.spring(v11, self.springOptions)
		})

		if self.props.onAnimationStateChangeCallback then
			self.props.onAnimationStateChangeCallback(self.props.textInputType, true)
		end
	end
end

function extended:willUnmount()
	self.isMounted = false
	self.motor:destroy()

	if
		self.foundationTextBoxProxy ~= nil
		and self.props.textBoxRef ~= nil
		and self.props.textBoxRef.current == self.foundationTextBoxProxy
	then
		self.props.textBoxRef.current = nil
		self.foundationTextBoxProxy = nil
	end
end

function extended:render()
	local layoutOrder = self.props.layoutOrder
	local titleTextKey = self.props.titleTextKey
	local summaryErrorTextKey = self.props.summaryErrorTextKey
	local validator = self.props.validator
	local validatorAdditionalProps = self.props.validatorAdditionalProps
	local inputTextToValidate = self.state.inputTextToValidate
	local tokens = self.props.tokens

	local v5 = not self.props.prerequisiteMet and "" or inputTextToValidate

	local v6 = authStatefulRoundCornerBorder.BorderState.Default

	if self.isInErrorState() then
		v6 = authStatefulRoundCornerBorder.BorderState.Error
	elseif self.state.textBoxFocused then
		v6 = authStatefulRoundCornerBorder.BorderState.Focused
	elseif self.state.textBoxHover then
		v6 = authStatefulRoundCornerBorder.BorderState.Hover
	end

	local usingFoundationTextInput = self:isUsingFoundationTextInput()

	if
		fFlagAuthValidatorRebindTextBoxRef
		and usingFoundationTextInput
		and self.foundationProxyText == nil
	then
		self.foundationProxyText = self.state.inputTextToValidate
	end

	local paddingTopOverride, useTrailingPadding, colorContentOverride, useFoundationTitle, foundationTitleSize, foundationTitleIsRequired, flag

	if fFlagAuthValidatorStyleOverrides then
		paddingTopOverride = self.props.paddingTopOverride
		useTrailingPadding = self.props.useTrailingPadding
		colorContentOverride = self.props.colorContentOverride
		useFoundationTitle = self.props.useFoundationTitle
		foundationTitleSize = self.props.foundationTitleSize
		foundationTitleIsRequired = self.props.foundationTitleIsRequired
		flag = self.props.foundationTitleIsBold == true
	else
		paddingTopOverride = nil
		useTrailingPadding = nil
		useFoundationTitle = nil
		flag = nil
		foundationTitleIsRequired = nil
		foundationTitleSize = nil
		colorContentOverride = nil
	end

	return withStyle(function(p2)
		local v7 = p2.Font.BaseSize * p2.Font.CaptionHeader.RelativeSize
		local contentGap = self.getContentGap()

		if getFFlagLuaAppEnable10ftSignUpView() and tokens then
			v7 = tokens.textCaptionHeaderSize
		end

		return withLocalization({
			titleText = titleTextKey,
			summaryErrorText = summaryErrorTextKey
		})(function(p3)
			local createElement = Roact.createElement
			local fitFrame = fitChildren.FitFrame
			local v8 = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = fitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = self.getFrameRef(),
				[Roact.Change.AbsolutePosition] = self.onPositionChanged
			}
			local children = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, contentGap)
				}),
				Padding = 0,
				Title = 0,
				TextInputBox = 0,
				RegisterTitleAuditContent = 0,
				AnimatedWrapper = 0
			}

			local createElement2 = Roact.createElement
			local v10 = {
				PaddingTop = UDim.new(0, not paddingTopOverride and 5 or paddingTopOverride),
				PaddingBottom = 0
			}

			local v11 = if useTrailingPadding then self.issueTrailingPadding else UDim.new(
				0,
				not self.props.paddingBottomOverride and 5 or self.props.paddingBottomOverride
			)
			v10.PaddingBottom = v11
			children.Padding = createElement2("UIPadding", v10)
			local v12

			if useFoundationTitle then
				local createElement3 = Roact.createElement

				local v15 = if flag then formatBoldRichText(p3.titleText or "") else p3.titleText or ""
				v12 = createElement3(inputLabel, {
					LayoutOrder = 0,
					Text = v15,
					RichText = flag,
					isRequired = foundationTitleIsRequired,
					size = foundationTitleSize
				})
			else
				v12 = Roact.createElement(fitTextLabel, {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = fitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					Text = p3.titleText or "",
					TextWrapped = true,
					Font = p2.Font.CaptionHeader.Font,
					TextSize = v7,
					TextColor3 = p2.Theme.TextEmphasis.Color,
					TextTransparency = p2.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			end

			children.Title = v12
			local v13

			if usingFoundationTextInput then
				v13 = Roact.createElement(self.textInputBoxFoundation)
			else
				local createElement3 = Roact.createElement
				local v15 = {
					size = UDim2.new(
						1,
						0,
						0,
						not (getFFlagLuaAppEnable10ftSignUpView() and tokens) and 36 or tokens.textboxHeight
					),
					layoutOrder = 1,
					borderState = v6
				}

				local v16 = {
					textbox = Roact.createElement(self.textInputBoxWithBorder),
					loadingSpinner = 0
				}
				local v17 = if self.props.shouldShowLoadingIcon then Roact.createElement(loading, {
					size = iconSize.Small,
					Position = UDim2.new(1, -22, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}) else nil
				v16.loadingSpinner = v17
				v13 = createElement3(authStatefulRoundCornerBorder, v15, v16)
			end

			children.TextInputBox = v13

			local v14 = if getFFlagEnableAuditForSinglePageSignUp() and self.props.enableAuditContentCapture and registerAuditContent then Roact.createElement(registerAuditContent, {
				translationKey = titleTextKey,
				translatedSourceString = p3.titleText
			}) else nil
			children.RegisterTitleAuditContent = v14

			local createElement3 = Roact.createElement
			local v16 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = self.issueTrackerHeight
			}

			local createElement4 = Roact.createElement
			local v18 = { PaddingRight = UDim.new(0, 12), PaddingLeft = 0 }
			local v19 = if getFFlagEnableAuthStatefulTextInputUpdates() then UDim.new(0, 0) else UDim.new(0, 12)
			v18.PaddingLeft = v19
			local children2 = {
				Padding = createElement4("UIPadding", v18),
				IssueSummaryWrapper = Roact.createElement(fitChildren.FitFrame, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = fitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					[Roact.Change.AbsoluteSize] = self.onIssueSummarySizeChange
				}, {
					IssueSummaryText = self.isInErrorState() and Roact.createElement(fitTextLabel, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = fitChildren.FitAxis.Height,
						BackgroundTransparency = 1,
						Text = p3.summaryErrorText or "",
						TextWrapped = true,
						Font = p2.Font.CaptionBody.Font,
						TextSize = p2.Font.BaseSize * p2.Font.CaptionBody.RelativeSize,
						TextColor3 = p2.Theme.Alert.Color,
						TextTransparency = self.issueSummaryTextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				IssueTrackerWrapper = 0
			}

			local createElement6 = Roact.createElement
			local fitFrame3 = fitChildren.FitFrame
			local onIssueFullListSizeChangesByAbsoluteSize = {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = fitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Change.AbsoluteSize] = self.onIssueFullListSizeChange
			}

			local createElement7 = Roact.createElement
			local v22 = {
				validator = validator,
				validatorAdditionalProps = validatorAdditionalProps,
				textToValidate = v5,
				onTextValidated = self.onTextValidated,
				contentTransparency = self.issueFullListTextTransparency,
				checkmarkTransparency = self.issueCheckmarkTransparency,
				updateIssueCondition = self.props.updateIssueCondition,
				debounceTime = 0,
				colorContentOverride = 0
			}
			local v23 = if fFlagSignUpTrackFailedRequest then self.props.debounceTime else nil
			v22.debounceTime = v23
			v22.colorContentOverride = colorContentOverride
			children2.IssueTrackerWrapper = createElement6(
				fitFrame3,
				onIssueFullListSizeChangesByAbsoluteSize,
				{
					IssueTracker = createElement7(issueTracker, v22)
				}
			)
			children.AnimatedWrapper = createElement3("Frame", v16, children2)
			return createElement(fitFrame, v8, children)
		end)
	end)
end

return extended
