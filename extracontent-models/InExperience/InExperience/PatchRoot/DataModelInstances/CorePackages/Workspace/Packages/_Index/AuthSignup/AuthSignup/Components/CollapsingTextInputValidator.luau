local parent = script:FindFirstAncestor("AuthSignup").Parent

local Roact = require(parent.Roact)

local Otter = require(parent.Otter)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local withStyle = UIBlox.Style.withStyle
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local AuthCommon = require(parent.AuthCommon)
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText
local FitChildren = AuthCommon.Components.FitChildren
local FitTextLabel = AuthCommon.Components.FitTextLabel
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local PasswordBox = AuthCommon.Components.PasswordBox
local GenericTextBox = AuthCommon.Components.GenericTextBox
local IssueTracker = AuthCommon.Components.IssueTracker

local InputValidity = AuthCommon.Enums.InputValidity
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent

local TextInput = Foundation.TextInput
local InputLabel = Foundation.InputLabel

local extended = Roact.PureComponent:extend("CollapsingTextInputValidator")

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnable10ftSignUpView = SharedFlags.GetFFlagLuaAppEnable10ftSignUpView
local GetFFlagEnableAuthStatefulTextInputUpdates = SharedFlags.GetFFlagEnableAuthStatefulTextInputUpdates
local FFlagSignUpTrackFailedRequest = SharedFlags.FFlagSignUpTrackFailedRequest
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local GetFFlagLuaAppEnableOpenTypeSignUpPageFix = SharedFlags.GetFFlagLuaAppEnableOpenTypeSignUpPageFix
local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagAuthCollapsingValidatorFoundationInput = SharedFlags.GetFFlagAuthCollapsingValidatorFoundationInput
local FFlagAuthValidatorStyleOverrides = SharedFlags.FFlagAuthValidatorStyleOverrides
local FFlagAuthValidatorRebindTextBoxRef = SharedFlags.FFlagAuthValidatorRebindTextBoxRef

local function computeIsInErrorState(p, data)
	if FFlagSignUpTrackFailedRequest and p.hasFieldFailed then
		return true
	end

	if not p.prerequisiteMet then
		return data.textBoxFocused or data.interactionBegan and data.inputTextToValidate ~= ""
	end

	if data.inputTextToValidate == "" then
		return false
	end

	return data.isInputTextValid == InputValidity.Invalid and data.interactionBegan
end

extended.defaultProps = { prerequisiteMet = true, captureFocusOnTapStart = true }

function extended:init()
	self.state = {
		inputTextToValidate = "",
		validatedInputText = "",
		isInputTextValid = InputValidity.Unvalidated,
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

	if FFlagAuthValidatorRebindTextBoxRef and self.foundationTextBoxRef == nil then
		self.foundationTextBoxRef = Roact.createRef()
	end

	function self.getFrameRef()
		return self.props.frameRef or self.frameRef
	end

	local binding, updateIssueSummaryTextTransparency = Roact.createBinding(1)
	self.issueSummaryTextTransparency = binding
	self.updateIssueSummaryTextTransparency = updateIssueSummaryTextTransparency
	local binding2, updateIssueFullListTextTransparency = Roact.createBinding(1)
	self.issueFullListTextTransparency = binding2
	self.updateIssueFullListTextTransparency = updateIssueFullListTextTransparency
	local binding3, updateIssueCheckmarkTransparency = Roact.createBinding(1)
	self.issueCheckmarkTransparency = binding3
	self.updateIssueCheckmarkTransparency = updateIssueCheckmarkTransparency
	local binding4, updateIssueTrackerHeight = Roact.createBinding(UDim2.new(1, 0, 0, 0))
	self.issueTrackerHeight = binding4
	self.updateIssueTrackerHeight = updateIssueTrackerHeight

	function self.getContentGap()
		if FFlagAuthValidatorStyleOverrides and self.props.contentGapOverride then
			return self.props.contentGapOverride
		end

		if GetFFlagLuaAppEnable10ftSignUpView() and self.props.tokens then
			return self.props.tokens.boxPadding
		end

		return 5
	end

	self.issueTrailingPadding = self.issueTrackerHeight:map(function(udim: UDim2)
		return UDim.new(0, -math.max(0, self.getContentGap() - udim.Y.Offset))
	end)

	self.springOptions = { frequency = 3 }

	function self.onSizeChange(p, p2)
		local absoluteSize = p2.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			spawn(function()
				if self.isMounted then
					self:setState({ [p] = absoluteSize.Y })
				end
			end)
		end
	end

	function self.onIssueSummarySizeChange(p)
		self.onSizeChange("issueSummaryHeight", p)
	end

	function self.onIssueFullListSizeChange(p)
		self.onSizeChange("issueFullListHeight", p)
	end

	function self.textInputChangedCallback(p)
		spawn(function()
			if self.isMounted then
				local text = p.Text
				local onInputTextChanged = self.props.onInputTextChanged

				if onInputTextChanged then
					onInputTextChanged(text, InputValidity.Unvalidated)
				end

				self:setState({
					inputTextToValidate = text,
					isInputTextValid = InputValidity.Unvalidated,
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

		local v = {
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

		setmetatable(v, {
			__index = function(_, p)
				if p == "Text" then
					return self.foundationProxyText or ""
				end

				return nil
			end,
			__newindex = function(_, p, value)
				if p ~= "Text" then
					rawset(v, p, value)

					return
				end

				local foundationProxyText = typeof(value) ~= "string" and "" or value
				self.foundationProxyText = foundationProxyText
				self.foundationTextInputChangedCallback(foundationProxyText)
			end
		})

		self.foundationTextBoxProxy = v
		textBoxRef.current = v
	end

	function self.onTextValidated(validatedInputText, isInputTextValid, p)
		spawn(function()
			if self.isMounted and self.state.inputTextToValidate == validatedInputText then
				local onInputTextValidated = self.props.onInputTextValidated

				if onInputTextValidated then
					if FFlagSignUpTrackFailedRequest then
						onInputTextValidated(validatedInputText, isInputTextValid, p)
					else
						onInputTextValidated(validatedInputText, isInputTextValid)
					end
				end

				self:setState({
					validatedInputText = validatedInputText,
					isInputTextValid = isInputTextValid
				})
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

		if FFlagSignUpTrackFailedRequest and props.hasFieldFailed then
			return true
		end

		local v

		if props.prerequisiteMet then
			if state.inputTextToValidate == "" then
				return false
			end

			if state.isInputTextValid == InputValidity.Invalid then
				return state.interactionBegan
			end

			return false
		end

		v = state.textBoxFocused

		if v then
			return v
		end

		v = state.interactionBegan

		if v then
			return state.inputTextToValidate ~= ""
		end

		return v
	end

	function self.textInputBoxWithBorder()
		return withStyle(function(p)
			local tokens = self.props.tokens
			local font = p.Font.Body.Font
			local textSize = p.Font.BaseSize * p.Font.Body.RelativeSize

			if GetFFlagLuaAppEnable10ftSignUpView() and tokens then
				textSize = tokens.textBodySize
			end

			local color = p.Theme.TextDefault.Color
			local transparency = p.Theme.TextDefault.Transparency
			local color2 = p.Theme.BackgroundUIContrast.Color
			local transparency2 = p.Theme.BackgroundUIContrast.Transparency
			local color3 = p.Theme.TextDefault.Color

			local placeholderText = self.props.placeholderText
			local textInputType = self.props.textInputType
			local returnKeyType = self.props.returnKeyType

			local prefilledText = self.props.prefilledText or ""

			if
				textInputType == Enum.TextInputType.Password
				or engineFeature and textInputType == Enum.TextInputType.NewPassword
			then
				return Roact.createElement(PasswordBox, {
					Size = UDim2.new(1, 0, 1, 0),
					Color = color2,
					Transparency = transparency2,
					TextSize = textSize,
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
			local v = {
				Size = UDim2.new(1, 0, 1, 0),
				Text = prefilledText,
				Font = font,
				TextSize = textSize,
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
			local openTypeFeatures

			if GetFFlagLuaAppEnableOpenTypeSupport() and GetFFlagLuaAppEnableOpenTypeSignUpPageFix() then
				openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
			end

			v.openTypeFeatures = openTypeFeatures

			v.ReturnKeyType = returnKeyType

			v.PlaceholderText = placeholderText
			v.PlaceholderColor = color3
			v.onChangeText = self.textInputChangedCallback
			v.onFocused = self.onTextInputBoxFocused
			v.onFocusLost = self.onTextInputBoxFocusLost
			v.onMouseEnter = self.onMouseEnter
			v.onMouseLeave = self.onMouseLeave
			v.onReturnPressedFromOnScreenKeyboard = self.props.onReturnPressedFromOnScreenKeyboard
			v.NextSelectionDown = self.props.NextSelectionDown
			v.TextBoxRef = self.props.textBoxRef
			return createElement(GenericTextBox, v)
		end)
	end

	function self.textInputBoxFoundation()
		local foundationInputSize, foundationIconTrailing

		if FFlagAuthValidatorStyleOverrides then
			foundationInputSize = self.props.foundationInputSize
			foundationIconTrailing = self.props.foundationIconTrailing
		end

		return Roact.createElement(TextInput, {
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
	if FFlagAuthValidatorStyleOverrides then
		return self.props.useFoundationTextInput
	end

	return self.props.useFoundationTextInput and GetFFlagAuthCollapsingValidatorFoundationInput()
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
			isInputTextValid = InputValidity.Unvalidated,
			interactionBegan = false
		})
	end
end

function extended:didUpdate(data, data2)
	if self:isUsingFoundationTextInput() and data.prefilledText ~= self.props.prefilledText then
		self.foundationTextInputChangedCallback(self.props.prefilledText or "")
	end

	if FFlagAuthValidatorRebindTextBoxRef and data.useFoundationTextInput ~= self.props.useFoundationTextInput then
		if self:isUsingFoundationTextInput() then
			self.bindFoundationTextBoxProxy()
		else
			self.foundationTextBoxProxy = nil
			self.foundationProxyText = nil
		end
	end

	local textBoxFocused = self.state.textBoxFocused
	local v = self.state.issueSummaryHeight
	local issueFullListHeight = self.state.issueFullListHeight
	local showDetailedError = self.props.showDetailedError

	local v2 = data2.validatedInputText ~= ""

	local v3 = not (textBoxFocused and self.props.prerequisiteMet)
	local v4 = self.state.validatedInputText ~= ""

	local props = self.props
	local state = self.state
	local v5

	if FFlagSignUpTrackFailedRequest and props.hasFieldFailed then
		v5 = true
	elseif props.prerequisiteMet then
		if state.inputTextToValidate == "" or state.isInputTextValid ~= InputValidity.Invalid then
			v5 = false
		else
			v5 = state.interactionBegan
		end
	else
		v5 = state.textBoxFocused or state.interactionBegan and state.inputTextToValidate ~= ""
	end

	local v6

	if FFlagSignUpTrackFailedRequest and data.hasFieldFailed then
		v6 = true
	elseif data.prerequisiteMet then
		if data2.inputTextToValidate == "" or data2.isInputTextValid ~= InputValidity.Invalid then
			v6 = false
		else
			v6 = data2.interactionBegan
		end
	else
		v6 = data2.textBoxFocused or data2.interactionBegan and data2.inputTextToValidate ~= ""
	end

	if showDetailedError and v5 then
		v4 = true
		v3 = false
	end

	local v7

	if textBoxFocused or showDetailedError and v5 then
		if self.props.prerequisiteMet then
			v7 = issueFullListHeight
		else
			v7 = v
		end
	else
		v7 = not v5 and 0 or v
	end

	local flag

	if self.props.pillClicked then
		self.props.resetPillClicked()
		v7 = 0
		v = 0
		flag = true
	else
		flag = false
	end

	if textBoxFocused == data2.textBoxFocused and v2 == v4 and not (showDetailedError and v5) and v5 == v6 then
		if v ~= data2.issueSummaryHeight or issueFullListHeight ~= data2.issueFullListHeight then
			if flag then
				self.motor:setGoal({
					issueTrackerHeight = Otter.spring(v7, self.springOptions)
				})
			else
				self.motor:setGoal({ issueTrackerHeight = Otter.instant(v7) })
			end

			if self.props.onAnimationStateChangeCallback then
				self.props.onAnimationStateChangeCallback(self.props.textInputType, true)
			end
		end
	else
		self.motor:setGoal({
			issueSummaryTextTransparency = Otter.spring(v3 and 0 or 1, self.springOptions),
			issueFullListTextTransparency = Otter.spring(v3 and 1 or 0, self.springOptions),
			issueCheckmarkTransparency = Otter.spring(v4 and 0 or 1, self.springOptions),
			issueTrackerHeight = Otter.spring(v7, self.springOptions)
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

	local textToValidate = not self.props.prerequisiteMet and "" or inputTextToValidate

	local borderState = AuthStatefulRoundCornerBorder.BorderState.Default

	if self.isInErrorState() then
		borderState = AuthStatefulRoundCornerBorder.BorderState.Error
	elseif self.state.textBoxFocused then
		borderState = AuthStatefulRoundCornerBorder.BorderState.Focused
	elseif self.state.textBoxHover then
		borderState = AuthStatefulRoundCornerBorder.BorderState.Hover
	end

	local usingFoundationTextInput = self:isUsingFoundationTextInput()

	if FFlagAuthValidatorRebindTextBoxRef and usingFoundationTextInput and self.foundationProxyText == nil then
		self.foundationProxyText = self.state.inputTextToValidate
	end

	local paddingTopOverride, useTrailingPadding, colorContentOverride, useFoundationTitle, foundationTitleSize, foundationTitleIsRequired, flag

	if FFlagAuthValidatorStyleOverrides then
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

	return withStyle(function(p)
		local textSize = p.Font.BaseSize * p.Font.CaptionHeader.RelativeSize
		local contentGap = self.getContentGap()

		if GetFFlagLuaAppEnable10ftSignUpView() and tokens then
			textSize = tokens.textCaptionHeaderSize
		end

		return withLocalization({ titleText = titleTextKey, summaryErrorText = summaryErrorTextKey })(function(p2)
			local createElement = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v = {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
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
			local v2 = {
				PaddingTop = UDim.new(0, not paddingTopOverride and 5 or paddingTopOverride),
				PaddingBottom = 0
			}
			local paddingBottom

			if useTrailingPadding then
				paddingBottom = self.issueTrailingPadding
			else
				paddingBottom = UDim.new(
					0,
					not self.props.paddingBottomOverride and 5 or self.props.paddingBottomOverride
				)
			end

			v2.PaddingBottom = paddingBottom
			children.Padding = createElement2("UIPadding", v2)
			local title

			if useFoundationTitle then
				local createElement3 = Roact.createElement
				local text

				if flag then
					text = formatBoldRichText(p2.titleText or "")
				else
					text = p2.titleText or ""
				end

				title = createElement3(InputLabel, {
					LayoutOrder = 0,
					Text = text,
					RichText = flag,
					isRequired = foundationTitleIsRequired,
					size = foundationTitleSize
				})
			else
				title = Roact.createElement(FitTextLabel, {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					Text = p2.titleText or "",
					TextWrapped = true,
					Font = p.Font.CaptionHeader.Font,
					TextSize = textSize,
					TextColor3 = p.Theme.TextEmphasis.Color,
					TextTransparency = p.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			end

			children.Title = title
			local textInputBox

			if usingFoundationTextInput then
				textInputBox = Roact.createElement(self.textInputBoxFoundation)
			else
				local createElement3 = Roact.createElement
				local v3 = {
					size = UDim2.new(
						1,
						0,
						0,
						not (GetFFlagLuaAppEnable10ftSignUpView() and tokens) and 36 or tokens.textboxHeight
					),
					layoutOrder = 1,
					borderState = borderState
				}

				local v4 = {
					textbox = Roact.createElement(self.textInputBoxWithBorder),
					loadingSpinner = 0
				}
				local loadingSpinner

				if self.props.shouldShowLoadingIcon then
					loadingSpinner = Roact.createElement(Loading, {
						size = IconSize.Small,
						Position = UDim2.new(1, -22, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				end

				v4.loadingSpinner = loadingSpinner
				textInputBox = createElement3(AuthStatefulRoundCornerBorder, v3, v4)
			end

			children.TextInputBox = textInputBox
			local registerTitleAuditContent

			if
				GetFFlagEnableAuditForSinglePageSignUp()
				and self.props.enableAuditContentCapture
				and RegisterAuditContent
			then
				registerTitleAuditContent = Roact.createElement(RegisterAuditContent, {
					translationKey = titleTextKey,
					translatedSourceString = p2.titleText
				})
			end

			children.RegisterTitleAuditContent = registerTitleAuditContent

			local createElement3 = Roact.createElement
			local v3 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = self.issueTrackerHeight
			}

			local createElement4 = Roact.createElement
			local v4 = { PaddingRight = UDim.new(0, 12), PaddingLeft = 0 }
			local paddingLeft

			if GetFFlagEnableAuthStatefulTextInputUpdates() then
				paddingLeft = UDim.new(0, 0)
			else
				paddingLeft = UDim.new(0, 12)
			end

			v4.PaddingLeft = paddingLeft
			local children2 = {
				Padding = createElement4("UIPadding", v4),
				IssueSummaryWrapper = Roact.createElement(FitChildren.FitFrame, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					[Roact.Change.AbsoluteSize] = self.onIssueSummarySizeChange
				}, {
					IssueSummaryText = self.isInErrorState() and Roact.createElement(FitTextLabel, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundTransparency = 1,
						Text = p2.summaryErrorText or "",
						TextWrapped = true,
						Font = p.Font.CaptionBody.Font,
						TextSize = p.Font.BaseSize * p.Font.CaptionBody.RelativeSize,
						TextColor3 = p.Theme.Alert.Color,
						TextTransparency = self.issueSummaryTextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				IssueTrackerWrapper = 0
			}

			local createElement5 = Roact.createElement
			local fitFrame2 = FitChildren.FitFrame
			local onIssueFullListSizeChangesByAbsoluteSize = {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Change.AbsoluteSize] = self.onIssueFullListSizeChange
			}

			local createElement6 = Roact.createElement
			local v5 = {
				validator = validator,
				validatorAdditionalProps = validatorAdditionalProps,
				textToValidate = textToValidate,
				onTextValidated = self.onTextValidated,
				contentTransparency = self.issueFullListTextTransparency,
				checkmarkTransparency = self.issueCheckmarkTransparency,
				updateIssueCondition = self.props.updateIssueCondition,
				debounceTime = 0,
				colorContentOverride = 0
			}
			local debounceTime

			if FFlagSignUpTrackFailedRequest then
				debounceTime = self.props.debounceTime
			end

			v5.debounceTime = debounceTime
			v5.colorContentOverride = colorContentOverride
			children2.IssueTrackerWrapper = createElement5(fitFrame2, onIssueFullListSizeChangesByAbsoluteSize, {
				IssueTracker = createElement6(IssueTracker, v5)
			})
			children.AnimatedWrapper = createElement3("Frame", v3, children2)
			return createElement(fitFrame, v, children)
		end)
	end)
end

return extended
