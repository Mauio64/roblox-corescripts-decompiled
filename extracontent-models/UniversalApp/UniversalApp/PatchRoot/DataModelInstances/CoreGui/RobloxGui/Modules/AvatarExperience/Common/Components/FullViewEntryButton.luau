local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Style.withStyle
local v10 = Images["icons/actions/previewShrink"]
local v11 = Images["icons/actions/previewExpand"]
local vector2 = Vector2.new(8, 8)
local v13 = Images["component_assets/circle_17"]
local v14 = Images["component_assets/dropshadow_24_6"]
local v15 = Roact.PureComponent:extend("FullViewEntryButton")

v15.validateProps = t.strictInterface({
	isUIFullView = t.optional(t.boolean),
	isSceneFullView = t.optional(t.boolean),
	changeViewFunction = t.optional(t.callback),
	LayoutOrder = t.optional(t.number)
})

function v15.renderExpandButton(p1, p2) -- line: 29
	-- upvalues: Roact (copy), ImageSetButton (copy), IconSize (copy), v10 (copy)
	return Roact.createElement(ImageSetButton, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
		Image = v10,
		ImageColor3 = p2.IconEmphasis.Color,
		ImageTransparency = p2.IconEmphasis.Transparency,
		LayoutOrder = p1.props.LayoutOrder,
		[Roact.Event.Activated] = p1.props.changeViewFunction
	})
end
function v15.renderCollapseButton(p3, p4) -- line: 43
	-- upvalues: Roact (copy), ImageSetLabel (copy), IconSize (copy), vector2 (copy), v14 (copy), ImageSetButton (copy), v13 (copy), v11 (copy)
	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, IconSize.Regular + vector2.X + 14, 0, IconSize.Regular + vector2.Y + 14),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(16, 16, 18, 18),
		Image = v14,
		ImageColor3 = p4.DropShadow.Color,
		ImageTransparency = p4.DropShadow.Transparency,
		LayoutOrder = p3.props.LayoutOrder
	}, {
		BackgroundImage = Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, IconSize.Regular + vector2.X, 0, IconSize.Regular + vector2.Y),
			BackgroundTransparency = 1,
			Image = v13,
			ImageColor3 = p4.BackgroundContrast.Color,
			ImageTransparency = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			[Roact.Event.Activated] = p3.props.changeViewFunction
		}, {
			FullViewImageButton = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Image = v11,
				ImageColor3 = p4.IconEmphasis.Color,
				ImageTransparency = p4.IconEmphasis.Transparency,
				Size = UDim2.new(0, -IconSize.Regular, 0, -IconSize.Regular)
			})
		})
	})
end
function v15.render(p5) -- line: 92
	-- upvalues: withStyle (copy)
	return withStyle(function(p6) -- line: 93
		-- upvalues: p5 (copy)
		local Theme = p6.Theme

		if not p5.props.isUIFullView then
			return p5:renderExpandButton(Theme)
		end

		return p5:renderCollapseButton(Theme)
	end)
end

return v15
