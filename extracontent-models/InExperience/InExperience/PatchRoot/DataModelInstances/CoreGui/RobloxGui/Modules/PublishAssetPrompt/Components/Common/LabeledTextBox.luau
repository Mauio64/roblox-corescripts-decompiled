local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Cryo = require(CorePackages.Packages.Cryo)

local useStyle = UIBlox.Core.Style.useStyle

local parent = script.Parent

local NameTextBox = require(parent.NameTextBox)

local v = { textBoxHeight = 30, topPadding = 0 }

local function LabeledTextBox(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useStyle()
	local font = v2.Font
	local baseSize = font.BaseSize
	local theme = v2.Theme

	local v3 = 19 + joined.textBoxHeight + joined.topPadding

	local captionHeader = font.CaptionHeader
	local color = theme.TextDefault.Color

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, v3),
			BackgroundTransparency = 1,
			LayoutOrder = joined.LayoutOrder
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 4)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, joined.topPadding)
			}),
			TextboxLabel = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 15),
				FontFace = normalizeFontFace(v2.Tokens.Typography.CaptionLarge.Font),
				Text = joined.labelText,
				TextSize = baseSize * captionHeader.RelativeSize,
				TextColor3 = color,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Textbox = React.createElement(NameTextBox, {
				Size = UDim2.new(1, 0, 0, joined.textBoxHeight),
				maxLength = joined.maxLength,
				onNameUpdated = joined.onTextUpdated,
				defaultName = joined.defaultText,
				centerText = joined.centerText,
				nameTextBoxRef = joined.textBoxRef,
				LayoutOrder = 2,
				invalidInputText = joined.invalidInputText
			})
		}
	)
end

return LabeledTextBox
