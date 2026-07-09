local Parent = script:FindFirstAncestor("VrSpatialUi").Parent
local Otter = require(Parent.Otter)

require(Parent.Observable)

local function v3() -- line: 8
end

local t1 = {
	Default = {
		dampingRatio = 1,
		frequency = 4.5
	},
	Slower = {
		dampingRatio = 1,
		frequency = 0.66
	}
}
local t2 = {}

t2.__index = t2

function t2.checkIfAnimateNeeded(p1, n1: number) -- line: 36
	if n1 == p1._currentGoal then
		return false
	end

	return true
end
function t2.hideAndBlockAnimationUntilLookBackAgain(p2) -- line: 43
	p2._ignoreAnimateShow = true
	p2:animateHideIfNeeded(true)
end
function t2.animateHideIfNeeded(p3, b1: boolean) -- line: 48
	-- upvalues: v3 (copy), t1 (copy)
	if not b1 then
		p3._ignoreAnimateShow = false
	end

	if not p3:checkIfAnimateNeeded(1) or p3._pendingHideAnimation and p3._pendingHideAnimation ~= v3 then
		return
	end

	p3._currentGoal = 1
	p3:animateToGoal(p3._currentGoal, t1.Slower)
end
function t2.animateShowIfNeeded(p4) -- line: 59
	-- upvalues: t1 (copy), v3 (copy)
	if not p4:checkIfAnimateNeeded(0) or p4._ignoreAnimateShow then
		return
	end

	p4:cancelPendingTaskIfNeeded()
	p4._currentGoal = 0
	p4:animateToGoal(p4._currentGoal, t1.Default)

	local _pendingHideAnimation = nil

	function p4._pendingHideAnimation() -- line: 68
		-- upvalues: p4 (copy), _pendingHideAnimation (ref), v3 (copy), t1 (copy)
		if p4._pendingHideAnimation == _pendingHideAnimation then
			p4._pendingHideAnimation = v3
			p4:animateToGoal(1, t1.Slower)
		end
	end

	_pendingHideAnimation = p4._pendingHideAnimation
	task.delay(3, p4._pendingHideAnimation)
end
function t2.animateToGoal(p5, p6, p7) -- line: 78
	-- upvalues: Otter (copy)
	p5._fadeTransparencyMotor:stop()
	p5._fadeTransparencyMotor:setGoal(Otter.spring(p6, p7))
end
function t2.isTargetVisible(p8) -- line: 83
	return p8._targetInstance.GroupTransparency == 0
end
function t2.reset(p9) -- line: 87
	p9._fadeTransparencyMotor:stop()
	p9:cancelPendingTaskIfNeeded()
	p9._ignoreAnimateShow = false
	p9._currentGoal = -1
	p9._targetInstance.GroupTransparency = 0
	p9._visibilityObservable:set(true)
end
function t2.cancelPendingTaskIfNeeded(p10) -- line: 96
	-- upvalues: v3 (copy)
	p10._pendingHideAnimation = v3
end
function t2.create(p11, p12) -- line: 100
	-- upvalues: Otter (copy), v3 (copy), t2 (copy)
	local u21 = nil

	for _, descendant in ipairs(p11:GetDescendants()) do
		if descendant.Name == "AnimatablePanelManagedContent" then
			u21 = descendant

			break
		end
	end

	if u21 == nil then
		return nil
	end

	p12:set(u21.GroupTransparency == 0)

	local v24 = Otter.createSingleMotor(0)

	v24:onStep(function(p13) -- line: 116
		-- upvalues: u21 (ref), p12 (copy)
		u21.GroupTransparency = p13
		p12:set(u21.GroupTransparency == 0)
	end)

	local t3 = {
		_currentGoal = -1,
		_ignoreAnimateShow = false,
		_targetInstance = u21,
		_fadeTransparencyMotor = v24,
		_pendingHideAnimation = v3,
		_visibilityObservable = p12
	}

	setmetatable(t3, t2)

	return t3
end

return t2
