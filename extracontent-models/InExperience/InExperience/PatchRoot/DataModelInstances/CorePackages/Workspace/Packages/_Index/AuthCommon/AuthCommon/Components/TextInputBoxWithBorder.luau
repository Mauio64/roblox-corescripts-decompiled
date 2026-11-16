local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local PasswordBox = require(AuthCommon.Components.PasswordBox)
local GenericTextBox = require(AuthCommon.Components.GenericTextBox)
local AuthStatefulRoundCornerBorder = require(AuthCommon.Components.AuthStatefulRoundCornerBorder)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAuthStatefulTextInputUpdates = SharedFlags.GetFFlagEnableAuthStatefulTextInputUpdates

local extended = Roact.PureComponent:extend(script.Name)

extended.defaultProps = {
	text = "",
	textInputType = Enum.TextInputType.NoSuggestions,
	textInputHeight = 30,
	textInputListPadding = 12,
	borderState = AuthStatefulRoundCornerBorder.BorderState.Default
}

function extended.render(p)
	local text = p.props.text
	local textInputType = p.props.textInputType
	local textInputHeight = p.props.textInputHeight
	local v = not GetFFlagEnableAuthStatefulTextInputUpdates() and 12 or p.props.textInputListPadding

	local layoutOrder = p.props.layoutOrder
	local borderState = p.props.borderState
	local placeholderText = p.props.placeholderText
	local onChangeTextCallback = p.props.onChangeTextCallback
	local onFocused = p.props.onFocused
	local onFocusLost = p.props.onFocusLost
	local labelText = p.props.labelText
	local errorText = p.props.errorText

	local maxLength = p.props.maxLength
	local v2 = p.props.textInputType == Enum.TextInputType.Password

	return withStyle(function(props)
		local font = props.Font.Body.Font
		local textSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		local color = props.Theme.TextDefault.Color
		local transparency = props.Theme.TextDefault.Transparency
		local color2 = props.Theme.BackgroundUIContrast.Color
		local transparency2 = props.Theme.BackgroundUIContrast.Transparency
		local placeholderColor = props.Theme.UIDefault.Color
		local textColor = props.Theme.TextEmphasis.Color

		if p.props.placeholderTextColor then
			placeholderColor = p.props.placeholderTextColor
		end

		if p.props.labelTextColor then
			textColor = p.props.labelTextColor
		end

		if p.props.textBarColor then
			color2 = p.props.textBarColor
		end

		local createElement = Roact.createElement
		local v3 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v4 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v)
			}),
			TextBoxLabel = 0,
			TextBox = 0,
			ErrorText = 0
		}

		local textBoxLabel = labelText

		if textBoxLabel then
			local createElement2 = Roact.createElement
			local v5 = {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = labelText,
				TextWrapped = true,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = props.Font.CaptionHeader.Font
			end

			v5.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font)
			end

			v5.FontFace = fontFace

			v5.TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
			v5.TextColor3 = textColor
			v5.TextTransparency = props.Theme.TextEmphasis.Transparency
			v5.TextXAlignment = Enum.TextXAlignment.Left
			textBoxLabel = createElement2("TextLabel", v5)
		end

		v4.TextBoxLabel = textBoxLabel

		local createElement2 = Roact.createElement
		local v5 = {
			size = UDim2.new(1, 0, 0, textInputHeight),
			layoutOrder = GetFFlagEnableAuthStatefulTextInputUpdates() and 2 or layoutOrder,
			borderState = borderState
		}

		local v6 = {
			PasswordBox = v2 and Roact.createElement(PasswordBox, {
				LayoutOrder = not GetFFlagEnableAuthStatefulTextInputUpdates() and 2 or nil,
				Size = UDim2.new(1, 0, 1, 0),
				Color = color2,
				Transparency = transparency2,
				TextSize = textSize,
				TextColor = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = text,
				PlaceholderText = placeholderText,
				PlaceholderColor3 = placeholderColor,
				ManualFocusRelease = false,
				CaptureFocusOnTapStart = true,
				onChangeText = onChangeTextCallback
			}),
			GenericTextBox = 0
		}

		local genericTextBox = not v2

		if genericTextBox then
			local createElement3 = Roact.createElement
			local v7 = {
				LayoutOrder = not GetFFlagEnableAuthStatefulTextInputUpdates() and 2 or nil,
				Size = UDim2.new(1, 0, 1, 0),
				Text = text,
				Font = font,
				TextSize = textSize,
				TextColor = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Color = color2,
				Transparency = transparency2,
				TextInputType = textInputType,
				onChangeText = onChangeTextCallback,
				PlaceholderText = placeholderText,
				PlaceholderColor = placeholderColor,
				PaddingX = 12,
				onFocused = onFocused,
				onFocusLost = onFocusLost,
				TextBoxRef = 0,
				maxLength = 0
			}
			local textBoxRef

			if GetFFlagEnableAuthStatefulTextInputUpdates then
				textBoxRef = p.props.textBoxRef
			end

			v7.TextBoxRef = textBoxRef
			v7.maxLength = maxLength
			genericTextBox = createElement3(GenericTextBox, v7)
		end

		v6.GenericTextBox = genericTextBox
		v4.TextBox = createElement2(AuthStatefulRoundCornerBorder, v5, v6)

		local errorText2 = errorText

		if errorText2 then
			local createElement3 = Roact.createElement
			local v7 = {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = errorText,
				TextSize = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize,
				Font = 0,
				FontFace = 0,
				TextColor3 = 0,
				TextXAlignment = 0,
				AutomaticSize = 0,
				TextWrapped = true,
				Size = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = props.Font.SubHeader1.Font
			end

			v7.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			v7.FontFace = fontFace

			v7.TextColor3 = props.Theme.Alert.Color
			v7.TextXAlignment = Enum.TextXAlignment.Left
			v7.AutomaticSize = Enum.AutomaticSize.Y

			v7.Size = UDim2.new(1, 0, 0, 0)
			errorText2 = createElement3("TextLabel", v7)
		end

		v4.ErrorText = errorText2
		return createElement("Frame", v3, v4)
	end)
end

return extended
