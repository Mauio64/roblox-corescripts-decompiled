local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement = React.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 0, v3),
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder
	}
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 4)
		}),
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, joined.topPadding) }),
		TextboxLabel = 0,
		Textbox = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 0, 15),
		Font = 0,
		FontFace = 0,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0,
		BackgroundTransparency = 1,
		TextXAlignment = 0,
		LayoutOrder = 1
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = captionHeader.Font
	end

	v5.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Tokens.Typography.CaptionLarge.Font)
	end

	v5.FontFace = fontFace

	v5.Text = joined.labelText
	v5.TextSize = baseSize * captionHeader.RelativeSize
	v5.TextColor3 = color

	v5.TextXAlignment = Enum.TextXAlignment.Left
	children.TextboxLabel = createElement2("TextLabel", v5)

	children.Textbox = React.createElement(NameTextBox, {
		Size = UDim2.new(1, 0, 0, joined.textBoxHeight),
		maxLength = joined.maxLength,
		onNameUpdated = joined.onTextUpdated,
		defaultName = joined.defaultText,
		centerText = joined.centerText,
		nameTextBoxRef = joined.textBoxRef,
		LayoutOrder = 2,
		invalidInputText = joined.invalidInputText
	})
	return createElement("Frame", v4, children)
end

return LabeledTextBox
