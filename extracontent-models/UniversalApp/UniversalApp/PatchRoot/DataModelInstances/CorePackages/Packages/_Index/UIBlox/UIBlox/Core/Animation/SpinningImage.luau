local RunService = game:GetService("RunService")
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Roact = require(parent2.Roact)
local t = require(parent.Parent.t)

local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label

local extended = Roact.PureComponent:extend("SpinningImage")

extended.validateProps = t.strictInterface({
	image = t.table,
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.union(t.UDim2, t.table)),
	rotationRate = t.optional(t.number)
})

extended.defaultProps = { rotationRate = 360 }

function extended:init()
	local binding, updateAngle = Roact.createBinding(0)
	self.angle = binding
	self.updateAngle = updateAngle
end

function extended:didMount()
	self.heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
		local v = self.angle:getValue() + self.props.rotationRate * dt

		if v > 360 then
			v -= 360
		elseif v < 0 then
			v += 360
		end

		self.updateAngle(v)
	end)
end

function extended.willUnmount(p)
	p.heartbeatConnection:Disconnect()
end

function extended.getDerivedStateFromProps(p, _)
	local imageRectSize = p.image.ImageRectSize
	return {
		size = p.size or UDim2.fromOffset(imageRectSize.X, imageRectSize.Y)
	}
end

function extended.render(props)
	return Roact.createElement(
		"Frame",
		{
			Size = props.state.size,
			AnchorPoint = props.props.anchorPoint,
			Position = props.props.position,
			BackgroundTransparency = 1
		},
		{
			inner = Roact.createElement(Label, {
				Size = props.state.size,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = props.props.image,
				Rotation = props.angle,
				BackgroundTransparency = 1
			})
		}
	)
end

return extended
