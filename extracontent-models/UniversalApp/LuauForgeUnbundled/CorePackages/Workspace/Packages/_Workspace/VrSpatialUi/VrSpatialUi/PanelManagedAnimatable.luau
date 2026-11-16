local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/Otter")
require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/Observable")

local function fn() end

local v5 = {
	Default = { dampingRatio = 1, frequency = 4.5 },
	Slower = { dampingRatio = 1, frequency = 0.66 }
}

local class = {}

class.__index = class

function class:checkIfAnimateNeeded(p3): boolean
	return p3 ~= self._currentGoal
end

function class:hideAndBlockAnimationUntilLookBackAgain()
	self._ignoreAnimateShow = true
	self:animateHideIfNeeded(true)
end

function class:animateHideIfNeeded(p2)
	if not p2 then
		self._ignoreAnimateShow = false
	end

	if
		not self:checkIfAnimateNeeded(1)
		or self._pendingHideAnimation and self._pendingHideAnimation ~= fn
	then
		return
	end

	self._currentGoal = 1
	self:animateToGoal(self._currentGoal, v5.Slower)
end

function class:animateShowIfNeeded()
	if not self:checkIfAnimateNeeded(0) or self._ignoreAnimateShow then
		return
	end

	self:cancelPendingTaskIfNeeded()
	self._currentGoal = 0
	self:animateToGoal(self._currentGoal, v5.Default)

	local pendingHideAnimation = nil
	function self._pendingHideAnimation()
		if self._pendingHideAnimation == pendingHideAnimation then
			self._pendingHideAnimation = fn
			self:animateToGoal(1, v5.Slower)
		end
	end
	pendingHideAnimation = self._pendingHideAnimation
	task.delay(3, self._pendingHideAnimation)
end

function class:animateToGoal(p3, p4)
	self._fadeTransparencyMotor:stop()
	self._fadeTransparencyMotor:setGoal(Otter.spring(p3, p4))
end

function class:isTargetVisible(): boolean
	return self._targetInstance.GroupTransparency == 0
end

function class:reset()
	self._fadeTransparencyMotor:stop()
	self:cancelPendingTaskIfNeeded()
	self._ignoreAnimateShow = false
	self._currentGoal = -1
	self._targetInstance.GroupTransparency = 0
	self._visibilityObservable:set(true)
end

function class:cancelPendingTaskIfNeeded()
	self._pendingHideAnimation = fn
end

function class.create(folder, object, p2)
	local v6 = nil

	for i, descendant in ipairs(folder:GetDescendants()) do
		if descendant.Name == "AnimatablePanelManagedContent" then
			v6 = descendant
			break
		end
	end

	if v6 == nil then
		return nil
	end

	if p2 then
		v6.GroupTransparency = 1
	end

	object:set(v6.GroupTransparency == 0)
	local singleMotor = Otter.createSingleMotor(p2 and 1 or 0)
	singleMotor:onStep(function(groupTransparency)
		v6.GroupTransparency = groupTransparency
		object:set(v6.GroupTransparency == 0)
	end)

	local v8 = {
		_targetInstance = v6,
		_fadeTransparencyMotor = singleMotor,
		_currentGoal = -1,
		_pendingHideAnimation = fn,
		_ignoreAnimateShow = false,
		_visibilityObservable = object
	}

	setmetatable(v8, class)
	return v8
end

return class
