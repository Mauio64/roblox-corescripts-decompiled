local parent = script:FindFirstAncestor("VrSpatialUi").Parent
local Otter = require(parent.Otter)
require(parent.Observable)

local function fn() end

local v = {
	Default = { dampingRatio = 1, frequency = 4.5 },
	Slower = { dampingRatio = 1, frequency = 0.66 }
}

local PanelManagedAnimatable = {}

PanelManagedAnimatable.__index = PanelManagedAnimatable

function PanelManagedAnimatable:checkIfAnimateNeeded(p: number): boolean
	return p ~= self._currentGoal
end

function PanelManagedAnimatable:hideAndBlockAnimationUntilLookBackAgain()
	self._ignoreAnimateShow = true
	self:animateHideIfNeeded(true)
end

function PanelManagedAnimatable:animateHideIfNeeded(flag: boolean)
	if not flag then
		self._ignoreAnimateShow = false
	end

	if not self:checkIfAnimateNeeded(1) or self._pendingHideAnimation and self._pendingHideAnimation ~= fn then
		return
	end

	self._currentGoal = 1
	self:animateToGoal(self._currentGoal, v.Slower)
end

function PanelManagedAnimatable:animateShowIfNeeded()
	if not self:checkIfAnimateNeeded(0) or self._ignoreAnimateShow then
		return
	end

	self:cancelPendingTaskIfNeeded()
	self._currentGoal = 0
	self:animateToGoal(self._currentGoal, v.Default)

	local pendingHideAnimation = nil
	function self._pendingHideAnimation()
		if self._pendingHideAnimation == pendingHideAnimation then
			self._pendingHideAnimation = fn
			self:animateToGoal(1, v.Slower)
		end
	end
	pendingHideAnimation = self._pendingHideAnimation
	task.delay(3, self._pendingHideAnimation)
end

function PanelManagedAnimatable:animateToGoal(p, p2)
	self._fadeTransparencyMotor:stop()
	self._fadeTransparencyMotor:setGoal(Otter.spring(p, p2))
end

function PanelManagedAnimatable:isTargetVisible(): boolean
	return self._targetInstance.GroupTransparency == 0
end

function PanelManagedAnimatable:reset()
	self._fadeTransparencyMotor:stop()
	self:cancelPendingTaskIfNeeded()
	self._ignoreAnimateShow = false
	self._currentGoal = -1
	self._targetInstance.GroupTransparency = 0
	self._visibilityObservable:set(true)
end

function PanelManagedAnimatable:cancelPendingTaskIfNeeded()
	self._pendingHideAnimation = fn
end

function PanelManagedAnimatable.create(folder, visibilityObservable, flag: boolean?)
	local targetInstance = nil

	for _, descendant in ipairs(folder:GetDescendants()) do
		if descendant.Name == "AnimatablePanelManagedContent" then
			targetInstance = descendant
			break
		end
	end

	if targetInstance == nil then
		return nil
	end

	if flag then
		targetInstance.GroupTransparency = 1
	end

	visibilityObservable:set(targetInstance.GroupTransparency == 0)
	local singleMotor = Otter.createSingleMotor(flag and 1 or 0)
	singleMotor:onStep(function(groupTransparency)
		targetInstance.GroupTransparency = groupTransparency
		visibilityObservable:set(targetInstance.GroupTransparency == 0)
	end)

	local v2 = {
		_targetInstance = targetInstance,
		_fadeTransparencyMotor = singleMotor,
		_currentGoal = -1,
		_pendingHideAnimation = fn,
		_ignoreAnimateShow = false,
		_visibilityObservable = visibilityObservable
	}

	setmetatable(v2, PanelManagedAnimatable)
	return v2
end

return PanelManagedAnimatable
