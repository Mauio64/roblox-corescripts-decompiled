local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local Roact = require(Parent.Roact)

local function CountryCodeButton(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), React (copy), ImageSetLabel (copy), GetImageData (copy), Roact (copy)
	local v10 = useStyle()
	local Tokens = v10.Tokens
	local TextField = Tokens.Component.TextField
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local countryPrefix = t1.countryPrefix
	local v16 = if not t1.error then v10.Theme.UIDefault.Color else Tokens.Color.System.Alert.Color3
	local UIDefaultTransparency = v10.Theme.UIDefault.Transparency
	local v18 = t1.font or TextField.Base.Field.Typography.Font
	local v19 = t1.textSize or TextField.Base.Field.Typography.FontSize

	return React.createElement(ImageSetLabel, {
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = size,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(9, 9, 9, 9),
		Image = GetImageData("LuaApp/buttons/buttonStroke"),
		ImageColor3 = v16,
		ImageTransparency = UIDefaultTransparency,
		LayoutOrder = layoutOrder
	}, {
		Button = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = countryPrefix,
			Font = v18,
			TextSize = v19,
			TextColor3 = TextField.Base.FieldValue.ContentColor.Color3,
			TextTransparency = TextField.Base.FieldValue.ContentColor.Transparency,
			[Roact.Event.Activated] = t1.onButtonClick,
			[Roact.Ref] = t1.forwardRef
		})
	})
end

return CountryCodeButton
