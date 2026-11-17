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

	return React.createElement(ImageSetLabel, {
		ZIndex = 2,
		Size = size,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = GetImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = imageColor,
		ImageTransparency = transparency,
		LayoutOrder = layoutOrder
	}, {
		Button = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = countryPrefix,
			FontFace = normalizeFontFace(font),
			TextSize = textSize,
			TextColor3 = v2.Base.FieldValue.ContentColor.Color3,
			TextTransparency = v2.Base.FieldValue.ContentColor.Transparency,
			[Roact.Event.Activated] = props.onButtonClick,
			[Roact.Ref] = props.forwardRef
		})
	})
end

return CountryCodeButton
