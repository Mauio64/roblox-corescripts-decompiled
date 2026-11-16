local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)

local v5 = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("IntroScroll")

extended.validateProps = t.strictInterface({
	childWidgetIndex = t.string,
	scrollingFrameRef = t.table,
	updateCanvasPosition = t.callback
})

function extended:init()
	self.initMotorValue = 0
	self.motor = Otter.createSingleMotor(0)
	self.motor:onStep(function(p2)
		self.props.updateCanvasPosition(Vector2.new(p2, 0))
	end)
end

function extended:didUpdate(p2, p3)
	if self.props.childWidgetIndex and self.props.childWidgetIndex ~= p2.childWidgetIndex then
		local current = self.props.scrollingFrameRef.current
		local v6 = math.clamp(
			current.AbsoluteCanvasSize.X - current.AbsoluteSize.X,
			0,
			current.AbsoluteSize.X * 0.25
		)

		self.motor:setGoal(Otter.instant(v6))
		self.motor:step(0)

		self.motor:setGoal(self:getGoal())
	end
end

function extended:getGoal(p3)
	return Otter.spring(0, v5)
end

function extended.render(p2): nil
	return nil
end

function extended:willUnmount()
	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

return extended
