local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local Roact = require(Parent.Roact)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens

local function CountryCodeButton(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), ImageSetLabel (copy), GetImageData (copy), Roact (copy)
	local v11 = useStyle()
	local Tokens = v11.Tokens
	local v13 = if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Component.TextField else {
		Base = {
			Field = {
				Typography = Tokens.Typography.BodyLarge
			},
			FieldValue = {
				ContentColor = Tokens.Color.Content.Emphasis
			}
		}
	}
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local countryPrefix = t1.countryPrefix
	local v17 = if not t1.error then v11.Theme.UIDefault.Color else Tokens.Color.System.Alert.Color3
	local UIDefaultTransparency = v11.Theme.UIDefault.Transparency
	local v19 = t1.font or v13.Base.Field.Typography.Font
	local v20 = t1.textSize or v13.Base.Field.Typography.FontSize

	return React.createElement(ImageSetLabel, {
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = size,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = GetImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = v17,
		ImageTransparency = UIDefaultTransparency,
		LayoutOrder = layoutOrder
	}, {
		Button = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = countryPrefix,
			Font = v19,
			TextSize = v20,
			TextColor3 = v13.Base.FieldValue.ContentColor.Color3,
			TextTransparency = v13.Base.FieldValue.ContentColor.Transparency,
			[Roact.Event.Activated] = t1.onButtonClick,
			[Roact.Ref] = t1.forwardRef
		})
	})
end

return CountryCodeButton
