local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images

local Localization = require(parent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization

local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)

local iconscommonrobux = Images["icons/common/robux"]

local function PriceFooter(props)
	local v = useStyle()
	local font = v.Font
	local theme = v.Theme
	local textSize = font.BaseSize * font.SubHeader1.RelativeSize
	local vector2 = Vector2.new(textSize, textSize)

	local v2 = useLocalization({
		freeText = TextKeys.CatalogLabelFree,
		offSaleText = TextKeys.CatalogLabelOffSale
	})

	local text = nil
	local flag = false

	if props.isOffSale then
		if FFlagProfilePlatformFixResaleLimitedPrice and props.lowestResalePrice and props.lowestResalePrice > 0 then
			text = tostring(props.lowestResalePrice)
			flag = true
		else
			text = v2.offSaleText
		end
	elseif props.price == 0 then
		text = v2.freeText
	elseif props.price then
		text = tostring(props.price)
		flag = true
	end

	local createElement = React.createElement
	local v3 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(0, -4)
	}
	local v4 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 4)
		}),
		Icon = 0,
		Text = 0
	}
	local icon

	if flag then
		icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Image = iconscommonrobux,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = theme.IconEmphasis.Transparency,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		})
	end

	v4.Icon = icon

	local createElement2 = React.createElement
	local v5 = {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, not flag and 0 or -(vector2.X + 4), 1, 0),
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 0,
		Text = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.SubHeader1.Font
	end

	v5.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.TitleLarge.Font)
	end

	v5.FontFace = fontFace

	v5.TextColor3 = theme.SecondaryContent.Color
	v5.TextTransparency = theme.SecondaryContent.Transparency
	v5.TextSize = textSize
	v5.Text = text
	v5.TextXAlignment = Enum.TextXAlignment.Left
	v5.TextYAlignment = Enum.TextYAlignment.Center
	v4.Text = createElement2("TextLabel", v5)
	return createElement("Frame", v3, v4)
end

return PriceFooter
