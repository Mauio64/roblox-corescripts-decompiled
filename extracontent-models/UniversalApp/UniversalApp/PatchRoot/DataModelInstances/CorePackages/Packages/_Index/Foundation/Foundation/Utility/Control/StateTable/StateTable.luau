local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.ControlState)
require(Foundation.Enums.ControlStateEvent)

local Logger = require(Foundation.Utility.Logger)
local t1 = {}

t1.__index = t1

function t1.new(s1: string, p1, t2: {[any]: any}) -- line: 53
	-- upvalues: t1 (copy)
	assert(#s1 > 0, "name must not be an empty string")
	assert(t2[p1] ~= nil, "initialState must be present in transitionTable")

	local t3 = {}

	setmetatable(t3, t1)
	t3.name = s1
	t3.currentState = p1
	t3.transitionTable = {}
	t3.events = {}

	for v8, v9 in t2 do
		local t4 = {}

		for v11, v12 in v9 do
			local nextState = v12.nextState

			if nextState ~= nil then
				assert(t2[nextState] ~= nil, "nextState does not exist in transitionTable")
			end

			t4[v11] = v12

			if t3.events[v11] == nil then
				t3.events[v11] = function() -- line: 79
					-- upvalues: t3 (copy), v11 (copy)
					return t3:handleEvent(v11)
				end
			end
		end

		t3.transitionTable[v8] = t4
	end

	setmetatable(t3.events, {
		__index = function(_, p3) -- line: 90
			-- upvalues: t3 (copy)
			error(string.format("'%s' is not a valid event in StateTable '%s'", tostring(p3), t3.name), 2)
		end
	})

	return t3
end
function t1.handleEvent(t5: {[any]: any}, s2: string) -- line: 109
	-- upvalues: Logger (copy)
	local currentState = t5.currentState
	local v17 = t5.transitionTable[currentState][s2]

	if v17 == nil then
		Logger:debug("No transition found for event " .. s2 .. " in state " .. currentState)

		return
	end

	local nextState = v17.nextState

	t5.currentState = nextState

	if t5.stateChangeHandler ~= nil then
		t5.stateChangeHandler(nextState)
	end
end
function t1.onStateChange(t6: {[any]: any}, p4: ((...any) -> ...any)?) -- line: 137
	t6.stateChangeHandler = p4
end

return t1
