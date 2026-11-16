local RunService = game:GetService("RunService")

local assign = require(script.Parent.assign)
local createSignal = require(script.Parent.createSignal)

local v = {}
v.prototype = {}
v.__index = v.prototype

local function createGroupMotor(items)
	assert(typeof(items) == "table")

	local states = {}

	for k, item in pairs(items) do
		states[k] = { value = item, complete = true }
	end

	local groupMotor = {
		__goals = {},
		__states = states,
		__allComplete = true,
		__onComplete = createSignal(),
		__onStep = createSignal(),
		__running = false
	}

	setmetatable(groupMotor, v)

	return groupMotor
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
		self.__running = false
	end
end

function v.prototype:step(value)
	assert(typeof(value) == "number")

	if self.__allComplete then
		return
	end

	local v2 = {}
	local allComplete = true

	for k, __state in pairs(self.__states) do
		if not __state.complete then
			local __goal = self.__goals[k]

			if __goal == nil then
				__state.complete = true
			else
				local v3 = __goal:step(__state, value)

				if v3 ~= nil then
					self.__states[k] = v3
					__state = v3
				end
			end

			if not __state.complete then
				allComplete = false
			end
		end

		v2[k] = __state.value
	end

	local __allComplete = self.__allComplete
	self.__allComplete = allComplete

	self.__onStep:fire(v2)

	if self.__allComplete and not __allComplete and self.__running then
		self:stop()
		self.__onComplete:fire(v2)
	end
end

function v.prototype:setGoal(items)
	assert(typeof(items) == "table")

	self.__goals = assign({}, self.__goals, items)

	for k in pairs(items) do
		local __state = self.__states[k]

		if __state == nil then
			error(("Cannot set goal for the value %s because it doesn't exist"):format((tostring(k))), 2)
		end

		__state.complete = false
	end

	self.__allComplete = false
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

return createGroupMotor
