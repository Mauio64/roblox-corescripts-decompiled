local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local Images = require(ParentParent.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local BadgeStates = require(script.Parent.Enum.BadgeStates)
local BadgeVariant = require(script.Parent.Enum.BadgeVariant)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local v13 = Images["component_assets/circle_25"]
local v14 = Images["component_assets/circle_21"]
local v15 = Roact.PureComponent:extend("Badge")

v15.validateProps = t.strictInterface({
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	disabled = t.optional(t.boolean),
	hasShadow = t.optional(t.boolean),
	value = t.union(t.string, t.integer, BadgeStates.isEnumValue),
	badgeVariant = t.optional(BadgeVariant.isEnumValue),
	layoutOrder = t.optional(t.integer)
})
v15.defaultProps = {
	disabled = false,
	hasShadow = false,
	position = UDim2.new(0, 0, 0, 0),
	anchorPoint = Vector2.new(0, 0),
	badgeVariant = BadgeVariant.Default
}

function v15.render(p1) -- line: 65
	-- upvalues: withStyle (copy), t (copy), BadgeStates (copy), GetTextSize (copy), BadgeVariant (copy), Roact (copy), ImageSetComponent (copy), Images (copy), divideTransparency (copy), v13 (copy), v14 (copy), GenericTextLabel (copy)
	return withStyle(function(p2) -- line: 66
		-- upvalues: p1 (copy), t (copy), BadgeStates (copy), GetTextSize (copy), BadgeVariant (copy), Roact (copy), ImageSetComponent (copy), Images (copy), divideTransparency (copy), v13 (copy), v14 (copy), GenericTextLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local str = tostring(p1.props.value)

		if t.number(p1.props.value) and p1.props.value > 99 then
			str = "99+"
		elseif t.string(p1.props.value) and utf8.len(utf8.nfcnormalize(p1.props.value)) > 4 then
			local v21 = utf8.offset(p1.props.value, 4) - 1

			str = string.sub(p1.props.value, 1, v21) .. "..."
		end

		if p1.props.value == BadgeStates.isEmpty then
			str = ""
		end

		local BaseSize = p2.Font.BaseSize
		local v23 = p2Font.CaptionBody.RelativeSize * BaseSize
		local v24 = GetTextSize(str, v23, p2Font.CaptionBody.Font, Vector2.new(10000, 10000)).X + 10 + 4

		if v24 < 24 then
			v24 = 24
		end

		local n1 = 24

		if p1.props.value == BadgeStates.isEmpty then
			v24 = 12
			n1 = 12
		end

		local Badge = p2.Tokens.Semantic.Color.Common.Badge
		local t1 = {
			Color = p2.Tokens.Semantic.Color.Common.BadgeContent.Color3,
			Transparency = p2.Tokens.Semantic.Color.Common.BadgeContent.Transparency
		}

		if p1.props.badgeVariant == BadgeVariant.Alert then
			Badge = p2.Tokens.Semantic.Color.Common.Alert
			t1 = {
				Color = p2.Tokens.Global.Color.White.Color3,
				Transparency = p2.Tokens.Semantic.Color.Common.BadgeContent.Transparency
			}
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = p1.props.position,
			AnchorPoint = p1.props.anchorPoint,
			Size = UDim2.fromOffset(v24, n1),
			LayoutOrder = p1.props.layoutOrder
		}, {
			Shadow = p1.props.hasShadow and Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 1,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 12, 1, 12),
				Image = Images["component_assets/dropshadow_25"],
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(18, 18, 19, 19)
			}),
			Background = Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ImageColor3 = Theme.BackgroundDefault.Color,
				ImageTransparency = divideTransparency(Theme.BackgroundDefault.Transparency, not p1.props.disabled and 1 or 2),
				Image = v13,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(14, 14, 15, 15)
			}),
			Inner = Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 3,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, -4, 1, -4),
				ImageColor3 = Badge.Color3,
				ImageTransparency = divideTransparency(Badge.Transparency, not p1.props.disabled and 1 or 2),
				Image = v14,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 12, 13, 13)
			}, {
				TextLabel = Roact.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					fontStyle = p2Font.CaptionBody,
					colorStyle = t1,
					Text = str,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			})
		})
	end)
end

return v15
