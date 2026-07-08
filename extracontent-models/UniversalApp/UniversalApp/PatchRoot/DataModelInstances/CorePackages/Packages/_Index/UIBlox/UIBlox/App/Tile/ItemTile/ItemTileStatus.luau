local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local Roact = require(ParentParent2Parent.Roact)
local t = require(ParentParent2Parent.t)
local withStyle = require(ParentParent2.Core.Style.withStyle)
local GetTextSize = require(ParentParent2.Core.Text.GetTextSize)
local Images = require(ParentParent2.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(ParentParent.Enum.ItemTileEnums)
local v11 = Roact.PureComponent:extend("ItemTileStatus")
local vector2 = Vector2.new(50, 20)
local vector2_2 = Vector2.new(10, 6)

v11.validateProps = t.strictInterface({
	statusText = t.string,
	statusStyle = ItemTileEnums.StatusStyle.isEnumValue
})

local function getStyle(p1, p2) -- line: 30
	-- upvalues: ItemTileEnums (copy)
	if p2 == ItemTileEnums.StatusStyle.Info then
		return {
			Background = p1.SystemPrimaryDefault,
			Text = p1.SystemPrimaryContent
		}
	end

	if p2 == ItemTileEnums.StatusStyle.Alert then
		return {
			Background = p1.Alert,
			Text = p1.TextEmphasis
		}
	end

	return {
		Background = p1.SystemPrimaryDefault,
		Text = p1.SystemPrimaryContent
	}
end

function v11.render(p3) -- line: 49
	-- upvalues: withStyle (copy), GetTextSize (copy), vector2 (copy), getStyle (copy), Roact (copy), ImageSetComponent (copy), Images (copy), vector2_2 (copy)
	return withStyle(function(p4) -- line: 50
		-- upvalues: p3 (copy), GetTextSize (copy), vector2 (copy), getStyle (copy), Roact (copy), ImageSetComponent (copy), Images (copy), vector2_2 (copy)
		local Theme = p4.Theme
		local p4Font = p4.Font
		local Tokens = p4.Tokens
		local statusText = p3.props.statusText
		local statusStyle = p3.props.statusStyle
		local CaptionHeaderFont = p4Font.CaptionHeader.Font
		local v25 = p4Font.BaseSize * p4Font.CaptionHeader.RelativeSize
		local v26 = GetTextSize(statusText, v25, CaptionHeaderFont, vector2)
		local v27 = getStyle(Theme, statusStyle)

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_17"],
			ImageColor3 = v27.Background.Color,
			ImageTransparency = v27.Background.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Position = UDim2.new(0, Tokens.Global.Size_100, 0, Tokens.Global.Size_100),
			Size = UDim2.new(0, v26.X + vector2_2.X, 0, v26.Y + vector2_2.Y)
		}, {
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = CaptionHeaderFont,
				TextSize = v25,
				Text = statusText,
				TextColor3 = v27.Text.Color,
				TextTransparency = v27.Text.TextTransparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return v11
