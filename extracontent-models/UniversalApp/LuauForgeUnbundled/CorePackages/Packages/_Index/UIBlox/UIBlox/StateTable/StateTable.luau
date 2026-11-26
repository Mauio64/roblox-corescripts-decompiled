local module = require("@luauforge/bundled/dzz")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local class = {}

class.__index = class

function class.new(name, currentState, options, items)
	assert(typeof(name) == "string", "name must be a string")
	assert(#name > 0, "name must not be an empty string")

	assert(typeof(currentState) == "string", "initialState must be a string")
	assert(#currentState > 0, "initialState must not be an empty string")

	assert(options == nil or typeof(options) == "table", "initialContext must be a table or nil")

	assert(typeof(items) == "table", "transitionTable must be a table")
	assert(typeof(items[currentState]) == "table", "initialState must be present in transitionTable")

	local class2 = {}
	setmetatable(class2, class)

	class2.loggingEnabled = false
	class2.name = name
	class2.currentState = currentState
	class2.currentContext = options or {}
	class2.transitionTable = {}
	class2.events = {}

	for k, item in pairs(items) do
		assert(typeof(k) == "string", string.format("state name '%s' must be a string", (tostring(k))))
		assert(typeof(item) == "table", string.format("state name '%s' must map to a table", k))

		local v5 = {}

		for k2, v6 in pairs(item) do
			assert(
				typeof(k2) == "string",
				string.format("event name '%s' must be a string", (tostring(k2)))
			)

			assert(typeof(v6) == "table", string.format("event name '%s' must map to a table", k2))

			local nextState = v6.nextState
			local action = v6.action

			if nextState ~= nil then
				assert(
					typeof(nextState) == "string",
					string.format("nextState '%s' must be a string or nil", (tostring(nextState)))
				)

				assert(
					items[nextState] ~= nil,
					string.format("nextState '%s' does not exist in transitionTable", nextState)
				)
			end

			assert(action == nil or typeof(action) == "function", "action must be a function")

			v5[k2] = v6

			if class2.events[k2] ~= nil then
				continue
			end

			local v7 = k2

			class2.events[k2] = function(p2)
				return class2:handleEvent(v7, p2)
			end
		end

		class2.transitionTable[k] = v5
	end

	setmetatable(class2.events, {
		__index = function(p2, p3)
			error(
				string.format("'%s' is not a valid event in StateTable '%s'", tostring(p3), class2.name),
				2
			)
		end
	})

	return class2
end

function class:handleEvent(value, p2)
	assert(typeof(value) == "string", "eventKey must be a string")
	assert(#value > 0, "eventKey must not be an empty string")
	assert(p2 == nil or typeof(p2) == "table", "args must be nil or valid table")

	local currentState = self.currentState
	local v5 = self.transitionTable[currentState]

	assert(v5 ~= nil)

	if v5[value] == nil then
		if self.loggingEnabled then
			logging.warn(string.format(
				"%s: unhandled state transition (%s[%s])",
				self.name,
				currentState,
				value
			))
		end
	else
		local v6 = v5[value]
		local nextState = v6.nextState or currentState
		local action = v6.action

		if self.loggingEnabled then
			print(string.format(
				"%s: changing state, '%s' [%s] --> '%s'",
				self.name,
				currentState,
				value,
				nextState
			))
		end

		local v7 = self.currentContext

		if action ~= nil then
			local v8 = action(currentState, nextState, p2, self.currentContext) or {}
			v7 = module.JoinDictionaries(self.currentContext, v8)
			self.currentContext = v7
		end

		self.currentState = nextState

		if self.stateChangeHandler ~= nil then
			self.stateChangeHandler(currentState, nextState, v7)
		end
	end
end

function class:onStateChange(stateChangeHandler)
	assert(
		stateChangeHandler == nil or typeof(stateChangeHandler) == "function",
		"stateChangeHandler must be nil or a function"
	)

	self.stateChangeHandler = stateChangeHandler
end

return class
