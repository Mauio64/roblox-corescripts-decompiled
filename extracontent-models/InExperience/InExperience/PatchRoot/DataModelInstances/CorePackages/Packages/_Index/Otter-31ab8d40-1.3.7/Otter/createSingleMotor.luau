local parent = script.Parent.Parent

local Signal = require(parent.Signal)
local createSignal = Signal.createSignal

local AnimationStepSignal = require(script.Parent.AnimationStepSignal)

require(script.Parent.types)

local class = {}
class.__index = class

local function createSingleMotor(p)
	local signal, fireOnComplete = createSignal()
	local signal2, fireOnStep = createSignal()

	local singleMotor = {
		__goal = nil,
		__state = { value = p, complete = true },
		__onComplete = signal,
		__fireOnComplete = fireOnComplete,
		__onStep = signal2,
		__fireOnStep = fireOnStep,
		__running = false
	}

	setmetatable(singleMotor, class)

	return singleMotor
end

function class:start()
	if self.__running then
		return
	end

	self.__connection = AnimationStepSignal:Connect(function(p)
		self:step(p)
	end)

	self.__running = true

	if self.__goal and self.__goal.startingValue then
		self.__state.value = self.__goal.startingValue

		if self.__state.initialValue then
			self.__state.initialValue = self.__goal.startingValue
		end

		self:step(0)
	end
end

function class:stop()
	if self.__connection ~= nil then
		self.__connection:Disconnect()
	end

	self.__running = false
end

function class:step(p: number)
	if self.__state.complete or self.__goal == nil then
		return
	end

	local state = self.__goal.step(self.__state, p)

	if state ~= nil then
		self.__state = state
	end

	self.__fireOnStep(self.__state.value)

	if self.__state.complete and self.__running then
		self:stop()
		self.__fireOnComplete(self.__state.value)
	end
end

function class:setGoal(goal)
	self.__goal = goal
	self.__state.complete = false
	self:start()
end

function class:onStep(p)
	local v = self.__onStep:subscribe(p)

	return function()
		v:unsubscribe()
	end
end

function class:onComplete(p)
	local v = self.__onComplete:subscribe(p)

	return function()
		v:unsubscribe()
	end
end

function class:destroy()
	self:stop()
end

return createSingleMotor
