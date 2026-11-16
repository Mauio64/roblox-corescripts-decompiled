local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppAssets").GetImageData
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local v9 = {
		ZIndex = 2,
		Size = size,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = getImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = v7,
		ImageTransparency = transparency,
		LayoutOrder = layoutOrder
	}

	local createElement2 = React.createElement
	local v12 = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = countryPrefix,
		Font = if not foundationFontFaceMigration then font else nil
	}

	local v14 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
	v12.FontFace = v14
	v12.TextSize = textSize
	v12.TextColor3 = v6.Base.FieldValue.ContentColor.Color3
	v12.TextTransparency = v6.Base.FieldValue.ContentColor.Transparency
	v12[Roact.Event.Activated] = props.onButtonClick
	v12[Roact.Ref] = props.forwardRef
	return createElement(imageSetLabel, v9, {
		Button = createElement2("TextButton", v12)
	})
end

return CountryCodeButton
