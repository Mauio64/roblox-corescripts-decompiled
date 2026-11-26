local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation").Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/PasswordBox")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/GenericTextBox")
local AuthStatefulRoundCornerBorder = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/AuthStatefulRoundCornerBorder")

local getFFlagEnableAuthStatefulTextInputUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableAuthStatefulTextInputUpdates

local extended = Roact.PureComponent:extend("TextInputBoxWithBorder")

extended.defaultProps = {
	text = "",
	textInputType = Enum.TextInputType.NoSuggestions,
	textInputHeight = 30,
	textInputListPadding = 12,
	borderState = AuthStatefulRoundCornerBorder.BorderState.Default
}

function extended.render(p2)
	local text = p2.props.text
	local textInputType = p2.props.textInputType
	local textInputHeight = p2.props.textInputHeight
	local v5 = not getFFlagEnableAuthStatefulTextInputUpdates() and 12 or p2.props.textInputListPadding

	local layoutOrder = p2.props.layoutOrder
	local borderState = p2.props.borderState
	local placeholderText = p2.props.placeholderText
	local onChangeTextCallback = p2.props.onChangeTextCallback
	local onFocused = p2.props.onFocused
	local onFocusLost = p2.props.onFocusLost
	local labelText = p2.props.labelText
	local errorText = p2.props.errorText

	local maxLength = p2.props.maxLength
	local v6 = p2.props.textInputType == Enum.TextInputType.Password

	return withStyle(function(props)
		local font = props.Font.Body.Font
		local v7 = props.Font.BaseSize * props.Font.Body.RelativeSize
		local color = props.Theme.TextDefault.Color
		local transparency = props.Theme.TextDefault.Transparency
		local v8 = props.Theme.BackgroundUIContrast.Color
		local transparency2 = props.Theme.BackgroundUIContrast.Transparency
		local v9 = props.Theme.UIDefault.Color
		local v10 = props.Theme.TextEmphasis.Color

		if p2.props.placeholderTextColor then
			v9 = p2.props.placeholderTextColor
		end

		if p2.props.labelTextColor then
			v10 = p2.props.labelTextColor
		end

		if p2.props.textBarColor then
			v8 = p2.props.textBarColor
		end

		local createElement = Roact.createElement
		local v12 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v13 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v5)
			}),
			TextBoxLabel = labelText and Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = labelText,
				TextWrapped = true,
				FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
				TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
				TextColor3 = v10,
				TextTransparency = props.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			TextBox = 0,
			ErrorText = 0
		}

		local createElement2 = Roact.createElement
		local v15 = {
			size = UDim2.new(1, 0, 0, textInputHeight),
			layoutOrder = getFFlagEnableAuthStatefulTextInputUpdates() and 2 or layoutOrder,
			borderState = borderState
		}

		local v16 = {
			PasswordBox = v6 and Roact.createElement(module3, {
				LayoutOrder = not getFFlagEnableAuthStatefulTextInputUpdates() and 2 or nil,
				Size = UDim2.new(1, 0, 1, 0),
				Color = v8,
				Transparency = transparency2,
				TextSize = v7,
				TextColor = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = text,
				PlaceholderText = placeholderText,
				PlaceholderColor3 = v9,
				ManualFocusRelease = false,
				CaptureFocusOnTapStart = true,
				onChangeText = onChangeTextCallback
			}),
			GenericTextBox = 0
		}

		local v17 = not v6

		if v17 then
			local createElement3 = Roact.createElement
			local v19 = {
				LayoutOrder = not getFFlagEnableAuthStatefulTextInputUpdates() and 2 or nil,
				Size = UDim2.new(1, 0, 1, 0),
				Text = text,
				Font = font,
				TextSize = v7,
				TextColor = color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Color = v8,
				Transparency = transparency2,
				TextInputType = textInputType,
				onChangeText = onChangeTextCallback,
				PlaceholderText = placeholderText,
				PlaceholderColor = v9,
				PaddingX = 12,
				onFocused = onFocused,
				onFocusLost = onFocusLost,
				TextBoxRef = 0,
				maxLength = 0
			}

			local v20 = if getFFlagEnableAuthStatefulTextInputUpdates then p2.props.textBoxRef else nil
			v19.TextBoxRef = v20
			v19.maxLength = maxLength
			v17 = createElement3(module4, v19)
		end

		v16.GenericTextBox = v17
		v13.TextBox = createElement2(AuthStatefulRoundCornerBorder, v15, v16)

		v13.ErrorText = errorText and Roact.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Text = errorText,
			TextSize = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize,
			FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
			TextColor3 = props.Theme.Alert.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0)
		})
		return createElement("Frame", v12, v13)
	end)
end

return extended
