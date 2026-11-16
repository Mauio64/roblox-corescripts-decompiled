local Foundation = script:FindFirstAncestor("Foundation")
require(Foundation.Enums.ControlState)
require(Foundation.Enums.ControlStateEvent)
local Logger = require(Foundation.Utility.Logger)

local StateTable = {}

StateTable.__index = StateTable

function StateTable.new(name: string, currentState, items)
	assert(#name > 0, "name must not be an empty string")
	assert(items[currentState] ~= nil, "initialState must be present in transitionTable")

	local class = {}
	setmetatable(class, StateTable)

	class.name = name
	class.currentState = currentState
	class.transitionTable = {}
	class.events = {}

	for k, item in items do
		local v = {}

		for k2, v2 in item do
			local nextState = v2.nextState

			if nextState ~= nil then
				assert(items[nextState] ~= nil, "nextState does not exist in transitionTable")
			end

			v[k2] = v2

			if class.events[k2] ~= nil then
				continue
			end

			local v3 = k2

			class.events[k2] = function()
				return class:handleEvent(v3)
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

function StateTable:handleEvent(p: string)
	local currentState = self.currentState
	local v = self.transitionTable[currentState][p]

	if v == nil then
		Logger:debug("No transition found for event " .. p .. " in state " .. currentState)
		return
	end

	local nextState = v.nextState

	self.currentState = nextState

	if self.stateChangeHandler ~= nil then
		self.stateChangeHandler(nextState)
	end
end

function StateTable:onStateChange(stateChangeHandler)
	self.stateChangeHandler = stateChangeHandler
end

return StateTable
