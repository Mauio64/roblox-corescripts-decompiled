local parent = script.Parent.Parent
local Cryo = require(parent.Parent.Cryo)

local StateTable = {}

StateTable.__index = StateTable

local function validateStateTableItem(p, p2) -- 5 equivalent calls inferred from this helper
	local typeName = typeof(p)
	assert(
		typeName == "string" or typeName == "userdata",
		string.format("%s '%s' must be a string or userdata but is a %s", p2, tostring(p), typeName)
	)
end

function StateTable.new(name, currentState, options, items)
	assert(typeof(name) == "string", "name must be a string")
	assert(#name > 0, "name must not be an empty string")
	validateStateTableItem(currentState, "initialState") -- inferred equivalent call
	assert(options == nil or typeof(options) == "table", "initialContext must be a table or nil")

	assert(typeof(items) == "table", "transitionTable must be a table")
	assert(typeof(items[currentState]) == "table", "initialState must be present in transitionTable")

	local class = {}
	setmetatable(class, StateTable)

	class.name = name
	class.currentState = currentState
	class.currentContext = options or {}
	class.transitionTable = {}
	class.events = {}

	for k, item in pairs(items) do
		validateStateTableItem(k, "state") -- inferred equivalent call
		assert(typeof(item) == "table", string.format("state '%s' must map to a table", (tostring(k))))

		local v = {}

		for k2, v2 in pairs(item) do
			validateStateTableItem(k2, "event") -- inferred equivalent call
			assert(typeof(v2) == "table", string.format("event '%s' must map to a table", (tostring(k2))))

			local nextState = v2.nextState
			local action = v2.action

			if nextState ~= nil then
				validateStateTableItem(nextState, "nextState") -- inferred equivalent call
				assert(
					items[nextState] ~= nil,
					string.format("nextState '%s' does not exist in transitionTable", (tostring(nextState)))
				)
			end

			assert(action == nil or typeof(action) == "function", "action must be a function")

			v[k2] = v2

			if class.events[k2] ~= nil then
				continue
			end

			local v3 = k2

			class.events[k2] = function(p)
				return class:handleEvent(v3, p)
			end
		end

		class.transitionTable[k] = v
	end

	setmetatable(class.events, {
		__index = function(_, p)
			error(string.format("'%s' is not a valid event in StateTable '%s'", tostring(p), class.name), 2)
		end
	})

	return class
end

function StateTable:handleEvent(p, p2)
	validateStateTableItem(p, "event") -- inferred equivalent call
	assert(p2 == nil or typeof(p2) == "table", "args must be nil or valid table")

	local currentState = self.currentState
	local v = self.transitionTable[currentState]

	assert(v ~= nil, "no transition events for current state")

	if v[p] ~= nil then
		local v2 = v[p]
		local nextState = v2.nextState or currentState
		local action = v2.action

		local currentContext = self.currentContext

		if action ~= nil then
			local v3 = action(currentState, nextState, p2, self.currentContext) or {}
			currentContext = Cryo.Dictionary.join(self.currentContext, v3)
			self.currentContext = currentContext
		end

		self.currentState = nextState

		if self.stateChangeHandler ~= nil then
			self.stateChangeHandler(currentState, nextState, currentContext)
		end
	end
end

function StateTable:onStateChange(stateChangeHandler)
	assert(
		stateChangeHandler == nil or typeof(stateChangeHandler) == "function",
		"stateChangeHandler must be nil or a function"
	)

	self.stateChangeHandler = stateChangeHandler
end

return StateTable
