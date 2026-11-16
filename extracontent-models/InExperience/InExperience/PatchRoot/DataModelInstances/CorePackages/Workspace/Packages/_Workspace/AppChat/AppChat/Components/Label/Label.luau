local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local v = { bodyText = "" }

local function Label(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2

	local size_100 = style.Tokens.Size.Size_100
	local size_150 = style.Tokens.Size.Size_150
	local size_300 = style.Tokens.Size.Size_300

	local createElement = React.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = joined.backgroundColor3 or style.Theme.BackgroundDefault.Color,
		BackgroundTransparency = joined.backgroundTransparency or style.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, style.Tokens.Size.Size_500),
		LayoutOrder = joined.layoutOrder
	}
	local v4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_100)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_100),
			PaddingRight = UDim.new(0, size_150),
			PaddingBottom = UDim.new(0, size_100),
			PaddingTop = UDim.new(0, size_100)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, style.Tokens.Radius.Small)
		}),
		IconImage = 0,
		BodyText = 0
	}
	local iconImage

	if joined.iconImage then
		iconImage = React.createElement(ImageSetLabel, {
			Size = UDim2.new(0, size_300, 0, size_300),
			BackgroundTransparency = 1,
			Image = joined.iconImage,
			ImageColor3 = joined.imageColor3 or style.Theme.IconEmphasis.Color,
			ImageTransparency = joined.imageTransparency or style.Theme.IconEmphasis.Transparency,
			LayoutOrder = 1
		})
	end

	v4.IconImage = iconImage

	local createElement2 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		Size = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = style.Font.Body.Font
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(style.Tokens.Typography.BodyLarge.Font)
	end

	v5.FontFace = fontFace

	v5.Size = UDim2.new(0, 0, 1, 0)
	v5.Text = joined.bodyText
	v5.TextColor3 = joined.bodyTextColor3 or style.Theme.TextEmphasis.Color
	v5.TextSize = style.Tokens.FontSize.FontSize_250
	v5.TextXAlignment = Enum.TextXAlignment.Left
	v5.TextYAlignment = Enum.TextYAlignment.Center
	v4.BodyText = createElement2("TextLabel", v5)
	return createElement("Frame", v3, v4)
end

return memo(Label)
