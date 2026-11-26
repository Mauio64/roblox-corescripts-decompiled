local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppAssets").GetImageData
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace

local function CountryCodeButton(props)
	local v5 = useStyle()
	local tokens = v5.Tokens
	local v6 = {
		Base = {
			Field = { Typography = tokens.Typography.BodyLarge },
			FieldValue = { ContentColor = tokens.Color.Content.Emphasis }
		}
	}

	local size = props.size
	local layoutOrder = props.layoutOrder
	local countryPrefix = props.countryPrefix
	local v7 = if props.error then tokens.Color.System.Alert.Color3 else v5.Theme.UIDefault.Color
	local transparency = v5.Theme.UIDefault.Transparency
	local font = props.font or v6.Base.Field.Typography.Font
	local textSize = props.textSize or v6.Base.Field.Typography.FontSize

	return React.createElement(imageSetLabel, {
		ZIndex = 2,
		Size = size,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = getImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = v7,
		ImageTransparency = transparency,
		LayoutOrder = layoutOrder
	}, {
		Button = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = countryPrefix,
			FontFace = normalizeFontFace(font),
			TextSize = textSize,
			TextColor3 = v6.Base.FieldValue.ContentColor.Color3,
			TextTransparency = v6.Base.FieldValue.ContentColor.Transparency,
			[Roact.Event.Activated] = props.onButtonClick,
			[Roact.Ref] = props.forwardRef
		})
	})
end

return CountryCodeButton
