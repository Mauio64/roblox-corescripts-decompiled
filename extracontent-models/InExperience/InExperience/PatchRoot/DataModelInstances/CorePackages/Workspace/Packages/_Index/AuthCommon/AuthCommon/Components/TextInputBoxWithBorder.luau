local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local withStyle = require(AuthCommonParent.UIBlox).Style.withStyle
local PasswordBox = require(AuthCommon.Components.PasswordBox)
local GenericTextBox = require(AuthCommon.Components.GenericTextBox)
local AuthStatefulRoundCornerBorder = require(AuthCommon.Components.AuthStatefulRoundCornerBorder)
local GetFFlagEnableAuthStatefulTextInputUpdates = require(AuthCommonParent.SharedFlags).GetFFlagEnableAuthStatefulTextInputUpdates
local v9 = Roact.PureComponent:extend(script.Name)

v9.defaultProps = {
	text = "",
	textInputHeight = 30,
	textInputListPadding = 12,
	textInputType = Enum.TextInputType.NoSuggestions,
	borderState = AuthStatefulRoundCornerBorder.BorderState.Default
}

function v9.render(p1) -- line: 29
	-- upvalues: GetFFlagEnableAuthStatefulTextInputUpdates (copy), withStyle (copy), Roact (copy), AuthStatefulRoundCornerBorder (copy), PasswordBox (copy), GenericTextBox (copy)
	local text = p1.props.text
	local textInputType = p1.props.textInputType
	local textInputHeight = p1.props.textInputHeight
	local v14 = not GetFFlagEnableAuthStatefulTextInputUpdates() and 12 or p1.props.textInputListPadding
	local layoutOrder = p1.props.layoutOrder
	local borderState = p1.props.borderState
	local placeholderText = p1.props.placeholderText
	local onChangeTextCallback = p1.props.onChangeTextCallback
	local onFocused = p1.props.onFocused
	local onFocusLost = p1.props.onFocusLost
	local labelText = p1.props.labelText
	local errorText = p1.props.errorText
	local maxLength = p1.props.maxLength
	local v24 = p1.props.textInputType == Enum.TextInputType.Password

	return withStyle(function(p2) -- line: 48
		-- upvalues: p1 (copy), Roact (copy), layoutOrder (copy), v14 (copy), labelText (copy), AuthStatefulRoundCornerBorder (copy), textInputHeight (copy), GetFFlagEnableAuthStatefulTextInputUpdates (copy), borderState (copy), v24 (copy), PasswordBox (copy), text (copy), placeholderText (copy), onChangeTextCallback (copy), GenericTextBox (copy), textInputType (copy), onFocused (copy), onFocusLost (copy), maxLength (copy), errorText (copy)
		local BodyFont = p2.Font.Body.Font
		local v27 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
		local TextDefaultColor = p2.Theme.TextDefault.Color
		local TextDefaultTransparency = p2.Theme.TextDefault.Transparency
		local BackgroundUIContrastColor = p2.Theme.BackgroundUIContrast.Color
		local BackgroundUIContrastTransparency = p2.Theme.BackgroundUIContrast.Transparency
		local UIDefaultColor = p2.Theme.UIDefault.Color
		local TextEmphasisColor = p2.Theme.TextEmphasis.Color

		if p1.props.placeholderTextColor then
			UIDefaultColor = p1.props.placeholderTextColor
		end

		if p1.props.labelTextColor then
			TextEmphasisColor = p1.props.labelTextColor
		end

		if p1.props.textBarColor then
			BackgroundUIContrastColor = p1.props.textBarColor
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v14)
			}),
			TextBoxLabel = labelText and Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = labelText,
				Font = p2.Font.CaptionHeader.Font,
				TextSize = p2.Font.BaseSize * p2.Font.CaptionHeader.RelativeSize,
				TextColor3 = TextEmphasisColor,
				TextTransparency = p2.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			TextBox = Roact.createElement(AuthStatefulRoundCornerBorder, {
				size = UDim2.new(1, 0, 0, textInputHeight),
				layoutOrder = if not GetFFlagEnableAuthStatefulTextInputUpdates() then layoutOrder else 2,
				borderState = borderState
			}, {
				PasswordBox = v24 and Roact.createElement(PasswordBox, {
					ManualFocusRelease = false,
					CaptureFocusOnTapStart = true,
					LayoutOrder = if GetFFlagEnableAuthStatefulTextInputUpdates() then nil else 2,
					Size = UDim2.new(1, 0, 1, 0),
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextSize = v27,
					TextColor = TextDefaultColor,
					TextTransparency = TextDefaultTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = text,
					PlaceholderText = placeholderText,
					PlaceholderColor3 = UIDefaultColor,
					onChangeText = onChangeTextCallback
				}),
				GenericTextBox = not v24 and Roact.createElement(GenericTextBox, {
					ClearTextOnFocus = false,
					PaddingX = 12,
					LayoutOrder = if GetFFlagEnableAuthStatefulTextInputUpdates() then nil else 2,
					Size = UDim2.new(1, 0, 1, 0),
					Text = text,
					Font = BodyFont,
					TextSize = v27,
					TextColor = TextDefaultColor,
					TextTransparency = TextDefaultTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextInputType = textInputType,
					onChangeText = onChangeTextCallback,
					PlaceholderText = placeholderText,
					PlaceholderColor = UIDefaultColor,
					onFocused = onFocused,
					onFocusLost = onFocusLost,
					TextBoxRef = if not GetFFlagEnableAuthStatefulTextInputUpdates then nil else p1.props.textBoxRef,
					maxLength = maxLength
				})
			}),
			ErrorText = errorText and Roact.createElement("TextLabel", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = errorText,
				TextSize = p2.Font.CaptionBody.RelativeSize * p2.Font.BaseSize,
				Font = p2.Font.SubHeader1.Font,
				TextColor3 = p2.Theme.Alert.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			})
		})
	end)
end

return v9
