local RunService = game:GetService("RunService")

local createSignal = require(script.Parent.createSignal)

local v = {}
v.prototype = {}
v.__index = v.prototype

local function createSingleMotor(value)
	assert(typeof(value) == "number")

	local singleMotor = {
		__goal = nil,
		__state = { value = value, complete = true },
		__onComplete = createSignal(),
		__onStep = createSignal(),
		__running = false
	}

	setmetatable(singleMotor, v)

	return singleMotor
end

function v.prototype:start()
	if self.__running then
		return
	end

	self.__connection = RunService.Heartbeat:Connect(function(dt)
		self:step(dt)
	end)

	self.__running = true
end

function v.prototype:stop()
	if self.__connection ~= nil then
		self.__connection:Disconnect()
	end

	self.__running = false
end

function v.prototype:step(value)
	assert(typeof(value) == "number")

	if self.__state.complete or self.__goal == nil then
		return
	end

	local state = self.__goal:step(self.__state, value)

	if state ~= nil then
		self.__state = state
	end

	self.__onStep:fire(self.__state.value)

	if self.__state.complete and self.__running then
		self:stop()
		self.__onComplete:fire(self.__state.value)
	end
end

function v.prototype:setGoal(goal)
	self.__goal = goal
	self.__state.complete = false
	self:start()
end

function v.prototype:onStep(callback)
	assert(typeof(callback) == "function")

	return self.__onStep:subscribe(callback)
end

function v.prototype:onComplete(callback)
	assert(typeof(callback) == "function")

	return self.__onComplete:subscribe(callback)
end

function v.prototype:destroy()
	self:stop()
end

return createSingleMotor
