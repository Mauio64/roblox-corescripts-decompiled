local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function CountryCodeButton(props)
	local v = useStyle()
	local tokens = v.Tokens
	local v2 = {
		Base = {
			Field = { Typography = tokens.Typography.BodyLarge },
			FieldValue = { ContentColor = tokens.Color.Content.Emphasis }
		}
	}

	local size = props.size
	local layoutOrder = props.layoutOrder
	local countryPrefix = props.countryPrefix
	local imageColor

	if props.error then
		imageColor = tokens.Color.System.Alert.Color3
	else
		imageColor = v.Theme.UIDefault.Color
	end

	local transparency = v.Theme.UIDefault.Transparency
	local font = props.font or v2.Base.Field.Typography.Font
	local textSize = props.textSize or v2.Base.Field.Typography.FontSize

	local createElement = React.createElement
	local v3 = {
		ZIndex = 2,
		Size = size,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = GetImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = imageColor,
		ImageTransparency = transparency,
		LayoutOrder = layoutOrder
	}

	local createElement2 = React.createElement
	local v4 = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = countryPrefix
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font
	end

	v4.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(font)
	end

	v4.FontFace = fontFace
	v4.TextSize = textSize
	v4.TextColor3 = v2.Base.FieldValue.ContentColor.Color3
	v4.TextTransparency = v2.Base.FieldValue.ContentColor.Transparency
	v4[Roact.Event.Activated] = props.onButtonClick
	v4[Roact.Ref] = props.forwardRef
	return createElement(ImageSetLabel, v3, {
		Button = createElement2("TextButton", v4)
	})
end

return CountryCodeButton
