local parent = script.Parent.Parent

local Collections = require(parent.Collections)
local Object = Collections.Object
local Signal = require(parent.Signal)
local createSignal = Signal.createSignal

local AnimationStepSignal = require(script.Parent.AnimationStepSignal)

require(script.Parent.types)

local class = {}
class.__index = class

local function createGroupMotor(items)
	local states = {}

	for k, item in pairs(items) do
		states[k] = { value = item, complete = true }
	end

	local signal, fireOnComplete = createSignal()
	local signal2, fireOnStep = createSignal()

	local groupMotor = {
		__goals = {},
		__states = states,
		__allComplete = true,
		__onComplete = signal,
		__fireOnComplete = fireOnComplete,
		__onStep = signal2,
		__fireOnStep = fireOnStep,
		__running = false
	}

	setmetatable(groupMotor, class)

	return groupMotor
end

function class:start(flag: boolean)
	if self.__running then
		return
	end

	self.__connection = AnimationStepSignal:Connect(function(p)
		self:step(p)
	end)

	self.__running = true

	if flag then
		self:step(0)
	end
end

function class:stop()
	if self.__connection ~= nil then
		self.__connection:Disconnect()
		self.__running = false
	end
end

function class:step(p: number)
	if self.__allComplete then
		return
	end

	local v = {}
	local allComplete = true

	for k, __state in pairs(self.__states) do
		if not __state.complete then
			local __goal = self.__goals[k]

			if __goal == nil then
				__state.complete = true
			else
				local v2 = __goal.step(__state, p)

				if v2 ~= nil then
					self.__states[k] = v2
					__state = v2
				end
			end

			if not __state.complete then
				allComplete = false
			end
		end

		v[k] = __state.value
	end

	local __allComplete = self.__allComplete
	self.__allComplete = allComplete

	self.__fireOnStep(v)

	if self.__allComplete and not __allComplete and self.__running then
		self:stop()
		self.__fireOnComplete(v)
	end
end

function class:setGoal(items)
	self.__goals = Object.assign({}, self.__goals, items)

	local v = {}
	local v2 = false

	for k, item in pairs(items) do
		local __state = self.__states[k]

		if item.startingValue then
			v2 = true
			__state.value = item.startingValue

			if __state.initialValue then
				__state.initialValue = item.startingValue
			end
		end

		v[k] = __state.value

		if __state == nil then
			error(("Cannot set goal for the value %s because it doesn't exist"):format((tostring(k))), 2)
		end

		__state.complete = false
	end

	self.__allComplete = false
	self:start(v2)
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

return createGroupMotor
