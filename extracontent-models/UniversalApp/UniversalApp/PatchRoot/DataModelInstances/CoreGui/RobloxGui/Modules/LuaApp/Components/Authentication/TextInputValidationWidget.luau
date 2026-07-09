local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local withLocalization = require(Modules.LuaApp.withLocalization)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local UIBlox = require(CorePackages.Packages.UIBlox)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local AuthBackAndNextButton = require(Modules.LuaApp.Components.Authentication.AuthBackAndNextButton)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local IssueTracker = require(Modules.LuaApp.Components.Authentication.IssueTracker)
local PasswordBox = AuthCommon.Components.PasswordBox
local FitChildren = require(Modules.LuaApp.FitChildren)
local GenericTextBox = AuthCommon.Components.GenericTextBox
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local withStyle = UIBlox.Style.withStyle
local InputValidity = require(CorePackages.Workspace.Packages.AuthCommon).Enums.InputValidity
local v19 = Roact.PureComponent:extend("TextInputValidationWidget")

v19.defaultProps = {
	captureFocusOnMount = false,
	continueButtonActionInProgress = false
}

function v19.init(p1) -- line: 42
	-- upvalues: InputValidity (copy), Roact (copy), Text (copy), withStyle (copy), withLocalization (copy), PasswordBox (copy), GenericTextBox (copy)
	p1.state = {
		inputTextToValidate = "",
		validatedInputText = "",
		textBoxFocused = false,
		inputValidity = InputValidity.Unvalidated,
		inputTextBoxAlignment = Enum.TextXAlignment.Left
	}
	p1.isMounted = false
	p1.inputBoxRef = Roact.createRef()

	function p1.onInputTextChanged(p2) -- line: 53
		-- upvalues: p1 (copy)
		p1.updateTextBoxAlignment(p2)
		p1.textInputChangedCallback(p2)
	end
	function p1.updateTextBoxAlignment(p3) -- line: 58
		-- upvalues: p1 (copy), Text (copy)
		local inputTextBoxAlignment = p1.state.inputTextBoxAlignment
		local u35 = if not (Text.GetTextWidth(p3.Text, p3.Font, p3.TextSize) > p3.AbsoluteSize.X) then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right

		spawn(function() -- line: 69
			-- upvalues: p1 (copy), inputTextBoxAlignment (copy), u35 (ref)
			if p1.isMounted and inputTextBoxAlignment ~= u35 then
				p1:setState({
					inputTextBoxAlignment = u35
				})
			end
		end)
	end
	function p1.textInputChangedCallback(p4) -- line: 78
		-- upvalues: p1 (copy)
		spawn(function() -- line: 79
			-- upvalues: p1 (copy), p4 (copy)
			if p1.isMounted then
				p1:setState({
					inputTextToValidate = p4.Text
				})
			end
		end)
	end
	function p1.onTextValidated(p5, p6) -- line: 88
		-- upvalues: p1 (copy)
		spawn(function() -- line: 89
			-- upvalues: p1 (copy), p5 (copy), p6 (copy)
			if p1.isMounted and p1.state.inputTextToValidate == p5 then
				p1:setState({
					validatedInputText = p5,
					inputValid = p6,
					inputValidity = p6
				})
			end
		end)
	end
	function p1.continueButtonActivated(_) -- line: 100
		-- upvalues: p1 (copy), InputValidity (copy)
		if p1.state.inputValidity == InputValidity.Valid and p1.props.continueButtonActivated then
			local inputTextToValidate = p1.state.inputTextToValidate

			p1.props.continueButtonActivated(inputTextToValidate)
		end
	end
	function p1.onTextInputBoxFocused() -- line: 117
		-- upvalues: p1 (copy)
		spawn(function() -- line: 118
			-- upvalues: p1 (copy)
			if p1.isMounted then
				p1:setState({
					textBoxFocused = true
				})
				p1.props.textInputOnFocus()
			end
		end)
	end
	function p1.onTextInputBoxFocusLost() -- line: 128
		-- upvalues: p1 (copy)
		spawn(function() -- line: 129
			-- upvalues: p1 (copy)
			if p1.isMounted then
				p1:setState({
					textBoxFocused = false
				})
			end
		end)
	end
	function p1.textInputBox(p8) -- line: 138
		-- upvalues: withStyle (copy), p1 (copy), withLocalization (copy), Roact (copy), PasswordBox (copy), GenericTextBox (copy)
		return withStyle(function(p9) -- line: 139
			-- upvalues: p1 (copy), p8 (copy), withLocalization (copy), Roact (copy), PasswordBox (copy), GenericTextBox (copy)
			local inputTextBoxAlignment = p1.state.inputTextBoxAlignment
			local BodyFont = p9.Font.Body.Font
			local v46 = p9.Font.BaseSize * p9.Font.Body.RelativeSize
			local TextDefaultColor = p9.Theme.TextDefault.Color
			local TextDefaultTransparency = p9.Theme.TextDefault.Transparency
			local BackgroundUIContrastColor = p9.Theme.BackgroundUIContrast.Color
			local BackgroundUIContrastTransparency = p9.Theme.BackgroundUIContrast.Transparency
			local UIDefaultColor = p9.Theme.UIDefault.Color
			local layoutOrder = p8.layoutOrder
			local textInputType = p1.props.textInputType
			local returnKeyType = p1.props.returnKeyType

			return withLocalization({
				passwordPlaceholderText = "Authentication.Login.Label.Password",
				usernamePlaceholderText = "Authentication.Login.Label.Username"
			})(function(p10) -- line: 158
				-- upvalues: textInputType (copy), Roact (copy), PasswordBox (copy), layoutOrder (copy), BackgroundUIContrastColor (copy), v46 (copy), TextDefaultColor (copy), TextDefaultTransparency (copy), returnKeyType (copy), p1 (copy), UIDefaultColor (copy), GenericTextBox (copy), BodyFont (copy), inputTextBoxAlignment (copy), BackgroundUIContrastTransparency (copy)
				if textInputType == Enum.TextInputType.Password then
					return Roact.createElement(PasswordBox, {
						Text = "",
						LayoutOrder = layoutOrder,
						Size = UDim2.new(1, 0, 0, 36),
						Position = UDim2.new(0, 0, 0, 0),
						Color = BackgroundUIContrastColor,
						TextSize = v46,
						TextColor = TextDefaultColor,
						TextTransparency = TextDefaultTransparency,
						ReturnKeyType = returnKeyType,
						TextBoxRef = p1.inputBoxRef,
						onChangeText = p1.onInputTextChanged,
						onReturnPressedFromOnScreenKeyboard = p1.continueButtonActivated,
						onFocused = p1.onTextInputBoxFocused,
						onFocusLost = p1.onTextInputBoxFocusLost,
						PlaceholderText = p10.passwordPlaceholderText,
						PlaceholderColor = UIDefaultColor
					})
				end

				return Roact.createElement(GenericTextBox, {
					Text = "",
					ClearTextOnFocus = false,
					PaddingX = 8,
					LayoutOrder = layoutOrder,
					Size = UDim2.new(1, 0, 0, 36),
					Font = BodyFont,
					TextSize = v46,
					onChangeText = p1.onInputTextChanged,
					TextXAlignment = inputTextBoxAlignment,
					TextColor = TextDefaultColor,
					TextTransparency = TextDefaultTransparency,
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextInputType = textInputType,
					ReturnKeyType = returnKeyType,
					TextBoxRef = p1.inputBoxRef,
					onReturnPressedFromOnScreenKeyboard = p1.continueButtonActivated,
					onFocused = p1.onTextInputBoxFocused,
					onFocusLost = p1.onTextInputBoxFocusLost,
					PlaceholderText = p10.usernamePlaceholderText,
					PlaceholderColor = UIDefaultColor
				})
			end)
		end)
	end
end

v19.defaultProps = {
	widgetHeight = 0,
	continueButtonKey = "Authentication.SignUp.Label.Continue"
}

function v19.didMount(p11) -- line: 213
	p11.isMounted = true

	local captureFocusOnMount = p11.props.captureFocusOnMount

	spawn(function() -- line: 217
		-- upvalues: captureFocusOnMount (copy), p11 (copy)
		if captureFocusOnMount and p11.inputBoxRef.current then
			p11.inputBoxRef.current:captureFocus()
		end
	end)
end
function v19.willUnmount(p12) -- line: 224
	p12.isMounted = false
end
function v19.render(p13) -- line: 228
	-- upvalues: FormFactor (copy), withStyle (copy), withLocalization (copy), AuthStatefulRoundCornerBorder (copy), InputValidity (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), FitChildren (copy), IssueTracker (copy), AuthBackAndNextButton (copy)
	local widgetHeight = p13.props.widgetHeight
	local continueButtonKey = p13.props.continueButtonKey
	local continueButtonActionInProgress = p13.props.continueButtonActionInProgress
	local v28 = p13.props.formFactor == FormFactor.WIDE
	local validator = p13.props.validator
	local validatorAdditionalProps = p13.props.validatorAdditionalProps
	local inputTextToValidate = p13.state.inputTextToValidate

	return withStyle(function(p14) -- line: 239
		-- upvalues: withLocalization (copy), continueButtonKey (copy), AuthStatefulRoundCornerBorder (copy), p13 (copy), InputValidity (copy), v28 (copy), Roact (copy), ImageSetLabel (copy), widgetHeight (copy), GetImageData (copy), FitChildren (copy), IssueTracker (copy), validator (copy), validatorAdditionalProps (copy), inputTextToValidate (copy), AuthBackAndNextButton (copy), continueButtonActionInProgress (copy)
		return withLocalization({
			continue = continueButtonKey
		})(function(p15) -- line: 242
			-- upvalues: p14 (copy), AuthStatefulRoundCornerBorder (copy), p13 (copy), InputValidity (copy), v28 (copy), Roact (copy), ImageSetLabel (copy), widgetHeight (copy), GetImageData (copy), FitChildren (copy), IssueTracker (copy), validator (copy), validatorAdditionalProps (copy), inputTextToValidate (copy), AuthBackAndNextButton (copy), continueButtonActionInProgress (copy)
			local BackgroundDefaultTransparency = p14.Theme.BackgroundDefault.Transparency
			local Default = AuthStatefulRoundCornerBorder.BorderState.Default
			local v58 = p13.state.inputValidity == InputValidity.Valid

			if p13.state.inputValidity == InputValidity.Invalid then
				Default = AuthStatefulRoundCornerBorder.BorderState.Error
			elseif p13.state.textBoxFocused then
				Default = AuthStatefulRoundCornerBorder.BorderState.Focused
			end

			if v28 then
				BackgroundDefaultTransparency = 1
			end

			return Roact.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, widgetHeight),
				BackgroundColor3 = p14.Theme.BackgroundDefault.Color,
				BackgroundTransparency = BackgroundDefaultTransparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = p14.Theme.BackgroundDefault.Color,
				ImageTransparency = p14.Theme.BackgroundDefault.Transparency
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 8)
				}),
				UsernameInputField = Roact.createElement(FitChildren.FitFrame, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5)
					}),
					TextInputBorder = Roact.createElement(AuthStatefulRoundCornerBorder, {
						layoutOrder = 1,
						size = UDim2.new(1, 0, 0, 36),
						borderState = Default
					}, {
						TextInput = Roact.createElement(p13.textInputBox)
					}),
					IssueTrackerWrapper = Roact.createElement(FitChildren.FitFrame, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height
					}, {
						Padding = Roact.createElement("UIPadding", {
							PaddingRight = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 12)
						}),
						IssueTracker = Roact.createElement(IssueTracker, {
							height = widgetHeight - 36 - 36 - 16 - 5,
							validator = validator,
							validatorAdditionalProps = validatorAdditionalProps,
							textToValidate = inputTextToValidate,
							onTextValidated = p13.onTextValidated
						})
					})
				}),
				AuthBackAndNextButton = Roact.createElement(AuthBackAndNextButton, {
					size = UDim2.new(1, 0, 0, 36),
					position = UDim2.new(0.5, 0, 1, 0),
					anchorPoint = Vector2.new(0.5, 1),
					backButtonIsDisabled = continueButtonActionInProgress,
					nextButtonText = p15.continue,
					nextButtonIsDisabled = not v58,
					nextButtonIsLoading = continueButtonActionInProgress,
					nextButtonOnActivated = p13.continueButtonActivated
				})
			})
		end)
	end)
end

return v19
