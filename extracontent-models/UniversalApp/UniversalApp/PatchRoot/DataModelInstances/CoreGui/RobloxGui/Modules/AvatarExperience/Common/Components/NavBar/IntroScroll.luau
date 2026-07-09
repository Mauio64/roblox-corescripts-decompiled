local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v6 = Roact.PureComponent:extend("IntroScroll")

v6.validateProps = t.strictInterface({
	childWidgetIndex = t.string,
	scrollingFrameRef = t.table,
	updateCanvasPosition = t.callback
})

function v6.init(p1) -- line: 26
	-- upvalues: Otter (copy)
	p1.initMotorValue = 0
	p1.motor = Otter.createSingleMotor(0)
	p1.motor:onStep(function(p2) -- line: 29
		-- upvalues: p1 (copy)
		p1.props.updateCanvasPosition(Vector2.new(p2, 0))
	end)
end
function v6.didUpdate(p3, p4, _) -- line: 34
	-- upvalues: Otter (copy)
	if p3.props.childWidgetIndex and p3.props.childWidgetIndex ~= p4.childWidgetIndex then
		local current = p3.props.scrollingFrameRef.current
		local v12 = math.clamp(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, 0, current.AbsoluteSize.X * 0.25)

		p3.motor:setGoal(Otter.instant(v12))
		p3.motor:step(0)
		p3.motor:setGoal(p3:getGoal())
	end
end
function v6.getGoal(_, _) -- line: 50
	-- upvalues: Otter (copy), t1 (copy)
	return Otter.spring(0, t1)
end
function v6.render(_) -- line: 54
	return nil
end
function v6.willUnmount(p9) -- line: 58
	if p9.motor then
		p9.motor:destroy()
		p9.motor = nil
	end
end

return v6
