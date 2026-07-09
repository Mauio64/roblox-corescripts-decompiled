local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent.Parent
local UIBlox = require(ParentParent.UIBlox)
local Roact = require(ParentParent.Roact)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local IconSize = UIBlox.App.Constant.IconSize
local v9 = IconSize.Small + 16

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: withStyle (copy), TextService (copy), v9 (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), Images (copy)
	return withStyle(function(p1) -- line: 25
		-- upvalues: t1 (copy), TextService (copy), v9 (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), Images (copy)
		local Theme = p1.Theme
		local p1Font = p1.Font
		local text = t1.text
		local v15 = p1Font.Body.RelativeSize * p1Font.BaseSize
		local BodyFont = p1Font.Body.Font
		local v17 = if text == nil then Vector2.new(0, 0) else TextService:GetTextSize(text, v15, BodyFont, Vector2.new(t1.width - v9, 10000))

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v17.Y),
			LayoutOrder = t1.layoutOrder
		}, {
			Bullet = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 2, 0, 2),
				Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
				ScaleType = Enum.ScaleType.Stretch,
				Image = Images["icons/status/success_small"],
				ImageColor3 = Theme.IconDefault.Color,
				ImageTransparency = Theme.IconDefault.Transparency
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Position = UDim2.new(0, v9, 0, 0),
				Size = UDim2.new(1, -v9, 0, v17.Y),
				Text = text,
				TextSize = v15,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				Font = BodyFont,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = t1.layoutOrder
			})
		})
	end)
end
