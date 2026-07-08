local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParent.Parent.t)
local Label = require(ParentParent.Core.ImageSet.ImageSetComponent).Label
local v7 = Roact.PureComponent:extend("SpinningImage")

v7.validateProps = t.strictInterface({
	image = t.table,
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.union(t.UDim2, t.table)),
	rotationRate = t.optional(t.number)
})
v7.defaultProps = {
	rotationRate = 360
}

function v7.init(p1) -- line: 25
	-- upvalues: Roact (copy)
	local v9, v10 = Roact.createBinding(0)

	p1.angle = v9
	p1.updateAngle = v10
end
function v7.didMount(p2) -- line: 29
	-- upvalues: RunService (copy)
	p2.heartbeatConnection = RunService.Heartbeat:Connect(function(dt) -- line: 30
		-- upvalues: p2 (copy)
		local v18 = p2.angle:getValue() + p2.props.rotationRate * dt

		if v18 > 360 then
			v18 -= 360
		elseif v18 < 0 then
			v18 += 360
		end

		p2.updateAngle(v18)
	end)
end
function v7.willUnmount(p3) -- line: 41
	p3.heartbeatConnection:Disconnect()
end
function v7.getDerivedStateFromProps(p4, _) -- line: 45
	local ImageRectSize = p4.image.ImageRectSize

	return {
		size = p4.size or UDim2.fromOffset(ImageRectSize.X, ImageRectSize.Y)
	}
end
function v7.render(p6) -- line: 52
	-- upvalues: Roact (copy), Label (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p6.state.size,
		AnchorPoint = p6.props.anchorPoint,
		Position = p6.props.position
	}, {
		inner = Roact.createElement(Label, {
			BackgroundTransparency = 1,
			Size = p6.state.size,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = p6.props.image,
			Rotation = p6.angle
		})
	})
end

return v7
