local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local iconSize = UIBlox.App.Constant.IconSize

local withStyle = UIBlox.Style.withStyle

local iconsactionspreviewShrink = images["icons/actions/previewShrink"]

local iconsactionspreviewExpand = images["icons/actions/previewExpand"]
local vector2 = Vector2.new(8, 8)
local component_assetscircle_17 = images["component_assets/circle_17"]
local component_assetsdropshadow_24_6 = images["component_assets/dropshadow_24_6"]

local extended = Roact.PureComponent:extend("FullViewEntryButton")

extended.validateProps = t.strictInterface({
	isUIFullView = t.optional(t.boolean),
	isSceneFullView = t.optional(t.boolean),
	changeViewFunction = t.optional(t.callback),
	LayoutOrder = t.optional(t.number)
})

function extended:renderExpandButton(p3)
	return Roact.createElement(imageSetButton, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, iconSize.Regular, 0, iconSize.Regular),
		Image = iconsactionspreviewShrink,
		ImageColor3 = p3.IconEmphasis.Color,
		ImageTransparency = p3.IconEmphasis.Transparency,
		LayoutOrder = self.props.LayoutOrder,
		[Roact.Event.Activated] = self.props.changeViewFunction
	})
end

function extended:renderCollapseButton(props)
	return Roact.createElement(imageSetLabel, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, iconSize.Regular + vector2.X + 14, 0, iconSize.Regular + vector2.Y + 14),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(16, 16, 18, 18),
		Image = component_assetsdropshadow_24_6,
		ImageColor3 = props.DropShadow.Color,
		ImageTransparency = props.DropShadow.Transparency,
		LayoutOrder = self.props.LayoutOrder,
		ZIndex = 2
	}, {
		BackgroundImage = Roact.createElement(imageSetButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, iconSize.Regular + vector2.X, 0, iconSize.Regular + vector2.Y),
			BackgroundTransparency = 1,
			Image = component_assetscircle_17,
			ImageColor3 = props.BackgroundContrast.Color,
			ImageTransparency = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			[Roact.Event.Activated] = self.props.changeViewFunction
		}, {
			FullViewImageButton = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Image = iconsactionspreviewExpand,
				ImageColor3 = props.IconEmphasis.Color,
				ImageTransparency = props.IconEmphasis.Transparency,
				Size = UDim2.new(0, -iconSize.Regular, 0, -iconSize.Regular),
				BackgroundTransparency = 1
			})
		})
	})
end

function extended:render()
	return withStyle(function(p2)
		local theme = p2.Theme

		if self.props.isUIFullView then
			return self:renderCollapseButton(theme)
		end

		return self:renderExpandButton(theme)
	end)
end

return extended
