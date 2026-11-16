local parent = script.Parent.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local t = require(parent.t)
local Otter = require(parent.Otter)

local v = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("IntroScroll")

extended.validateProps = t.strictInterface({
	childWidgetIndex = t.number,
	scrollingFrameRef = t.table,
	updateCanvasPosition = t.callback
})

function extended:init()
	self.motor = Otter.createSingleMotor(0)
	self.motor:onStep(function(p)
		self.props.updateCanvasPosition(Vector2.new(p, 0))
	end)
end

function extended:didUpdate(p, _)
	if self.props.childWidgetIndex and self.props.childWidgetIndex ~= p.childWidgetIndex then
		local current = self.props.scrollingFrameRef.current
		local v2 = math.clamp(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, 0, current.AbsoluteSize.X * 0.25)

		self.motor:setGoal(Otter.instant(v2))
		self.motor:step(0)

		self.motor:setGoal(self:getGoal())
	end
end

function extended:getGoal(_)
	return Otter.spring(0, v)
end

function extended.render(_): nil
	return nil
end

function extended:willUnmount()
	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

return extended
