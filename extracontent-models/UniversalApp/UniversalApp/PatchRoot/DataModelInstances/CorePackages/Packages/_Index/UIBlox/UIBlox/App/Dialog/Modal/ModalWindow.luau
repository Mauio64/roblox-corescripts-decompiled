local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local FitFrame = require(parent4.FitFrame)
local FitFrameVertical = FitFrame.FitFrameVertical

local Images = require(parent2.ImageSet.Images)
local withStyle = require(parent3.Core.Style.withStyle)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)

local getModalWindowWidth = require(parent.getModalWindowWidth)

local rect = Rect.new(8, 8, 9, 9)

local extended = Roact.PureComponent:extend("ModalWindow")

extended.validateProps = t.strictInterface({
	isFullHeight = t.boolean,
	screenSize = t.Vector2,
	[Roact.Children] = t.table,
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	distanceFromTop = t.optional(t.number)
})

extended.defaultProps = { distanceFromTop = 0 }

function extended:init()
	local binding, changeContentSize = Roact.createBinding(Vector2.new(0, 0))
	self.contentSize = binding
	self.changeContentSize = changeContentSize
end

function extended:isFullWidth(p): boolean
	return p < 540
end

function extended:render()
	return withStyle(function(p)
		local theme = p.Theme
		local screenSize = self.props.screenSize

		local udim = UDim.new(0, getModalWindowWidth(screenSize.X))
		local vector2, position, v

		if self:isFullWidth(screenSize.X) then
			vector2 = Vector2.new(0.5, 1)

			position = self.props.position or UDim2.new(0.5, 0, 1, 0)
			v = "component_assets/bullet_17"
		else
			vector2 = Vector2.new(0.5, 0.5)

			position = self.props.position or UDim2.new(0.5, 0, 0.5, 0)
			v = "component_assets/circle_17"
		end

		local anchorPoint = self.props.anchorPoint or vector2

		if self.props.isFullHeight then
			local udim2

			if self.props.distanceFromTop > 0 then
				udim2 = UDim.new(1, -self.props.distanceFromTop)
			else
				udim2 = UDim.new(1, 0)

				if screenSize.X >= 540 and screenSize.Y >= 700 then
					udim2 = UDim.new(0.8, 0)
				end
			end

			return Roact.createElement(ImageSetComponent.Button, {
				Position = position,
				Size = UDim2.new(udim, udim2),
				AnchorPoint = anchorPoint,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = Images[v],
				ImageColor3 = theme.BackgroundUIDefault.Color,
				ImageTransparency = theme.BackgroundUIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				AutoButtonColor = false,
				ClipsDescendants = true,
				Selectable = false
			}, {
				BackgroundImage = Roact.createElement(ImageSetComponent.Label, {
					Size = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				}, self.props[Roact.Children])
			})
		end

		return Roact.createElement(ImageSetComponent.Button, {
			Position = position,
			Size = self.contentSize:map(function(p2)
				return UDim2.new(0, p2.X, 0, p2.Y)
			end),
			AnchorPoint = anchorPoint,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = Images[v],
			ImageColor3 = theme.BackgroundUIDefault.Color,
			ImageTransparency = theme.BackgroundUIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false
		}, {
			BackgroundImage = Roact.createElement(FitFrameVertical, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				width = udim,
				[Roact.Change.AbsoluteSize] = function(p2)
					self.changeContentSize(p2.AbsoluteSize)
				end
			}, self.props[Roact.Children])
		})
	end)
end

return extended
