local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local FitFrameVertical = require(ParentParentParentParent.FitFrame).FitFrameVertical
local Images = require(ParentParent.ImageSet.Images)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local getModalWindowWidth = require(scriptParent.getModalWindowWidth)
local rect = Rect.new(8, 8, 9, 9)
local v13 = Roact.PureComponent:extend("ModalWindow")

v13.validateProps = t.strictInterface({
	isFullHeight = t.boolean,
	screenSize = t.Vector2,
	[Roact.Children] = t.table,
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	distanceFromTop = t.optional(t.number)
})
v13.defaultProps = {
	distanceFromTop = 0
}

function v13.init(p1) -- line: 48
	-- upvalues: Roact (copy)
	local v15, v16 = Roact.createBinding(Vector2.new(0, 0))

	p1.contentSize = v15
	p1.changeContentSize = v16
end
function v13.isFullWidth(_, p3) -- line: 53
	return p3 < 540
end
function v13.render(p4) -- line: 57
	-- upvalues: withStyle (copy), getModalWindowWidth (copy), Roact (copy), ImageSetComponent (copy), Images (copy), rect (copy), FitFrameVertical (copy)
	return withStyle(function(p5) -- line: 58
		-- upvalues: p4 (copy), getModalWindowWidth (copy), Roact (copy), ImageSetComponent (copy), Images (copy), rect (copy), FitFrameVertical (copy)
		local Theme = p5.Theme
		local screenSize = p4.props.screenSize
		local uDim = UDim.new(0, getModalWindowWidth(screenSize.X))
		local vector2, s1, v26

		if p4:isFullWidth(screenSize.X) then
			vector2 = Vector2.new(0.5, 1)
			s1 = "component_assets/bullet_17"
			v26 = p4.props.position or UDim2.new(0.5, 0, 1, 0)
		else
			vector2 = Vector2.new(0.5, 0.5)
			s1 = "component_assets/circle_17"
			v26 = p4.props.position or UDim2.new(0.5, 0, 0.5, 0)
		end

		local v27 = p4.props.anchorPoint or vector2

		if p4.props.isFullHeight then
			local uDim2

			if p4.props.distanceFromTop > 0 then
				uDim2 = UDim.new(1, -p4.props.distanceFromTop)
			else
				uDim2 = UDim.new(1, 0)

				if screenSize.X >= 540 and screenSize.Y >= 700 then
					uDim2 = UDim.new(0.8, 0)
				end
			end

			return Roact.createElement(ImageSetComponent.Button, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ClipsDescendants = true,
				Selectable = false,
				Position = v26,
				Size = UDim2.new(uDim, uDim2),
				AnchorPoint = v27,
				Image = Images[s1],
				ImageColor3 = Theme.BackgroundUIDefault.Color,
				ImageTransparency = Theme.BackgroundUIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect
			}, {
				BackgroundImage = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}, p4.props[Roact.Children])
			})
		end

		return Roact.createElement(ImageSetComponent.Button, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false,
			Position = v26,
			Size = p4.contentSize:map(function(p6) -- line: 112
				return UDim2.new(0, p6.X, 0, p6.Y)
			end),
			AnchorPoint = v27,
			Image = Images[s1],
			ImageColor3 = Theme.BackgroundUIDefault.Color,
			ImageTransparency = Theme.BackgroundUIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect
		}, {
			BackgroundImage = Roact.createElement(FitFrameVertical, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				width = uDim,
				[Roact.Change.AbsoluteSize] = function(p7) -- line: 133
					-- upvalues: p4 (copy)
					p4.changeContentSize(p7.AbsoluteSize)
				end
			}, p4.props[Roact.Children])
		})
	end)
end

return v13
