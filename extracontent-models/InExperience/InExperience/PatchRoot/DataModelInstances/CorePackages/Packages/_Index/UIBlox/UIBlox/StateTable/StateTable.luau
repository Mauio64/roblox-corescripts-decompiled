local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Parent.Cryo)
local t1 = {}

t1.__index = t1

local function validateStateTableItem(p1, p2) -- line: 9
	local v7 = typeof(p1)

	assert(v7 == "string" or v7 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", p2, tostring(p1), v7))
end

function t1.new(p3, p4, p5, p6) -- line: 72
	-- upvalues: t1 (copy)
	assert(typeof(p3) == "string", "name must be a string")
	assert(#p3 > 0, "name must not be an empty string")

	local v12 = typeof(p4)

	assert(v12 == "string" or v12 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", "initialState", tostring(p4), v12))
	assert(p5 == nil or typeof(p5) == "table", "initialContext must be a table or nil")
	assert(typeof(p6) == "table", "transitionTable must be a table")
	assert(typeof(p6[p4]) == "table", "initialState must be present in transitionTable")

	local t2 = {}

	setmetatable(t2, t1)
	t2.name = p3
	t2.currentState = p4
	t2.currentContext = p5 or {}
	t2.transitionTable = {}
	t2.events = {}

	for k, v in pairs(p6) do
		local v16 = typeof(k)

		assert(v16 == "string" or v16 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", "state", tostring(k), v16))
		assert(typeof(v) == "table", string.format("state '%s' must map to a table", (tostring(k))))

		local t3 = {}

		for k2, v2 in pairs(v) do
			local v20 = typeof(k2)

			assert(v20 == "string" or v20 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", "event", tostring(k2), v20))
			assert(typeof(v2) == "table", string.format("event '%s' must map to a table", (tostring(k2))))

			local nextState = v2.nextState
			local action = v2.action

			if nextState ~= nil then
				local v23 = typeof(nextState)

				assert(v23 == "string" or v23 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", "nextState", tostring(nextState), v23))
				assert(p6[nextState] ~= nil, string.format("nextState '%s' does not exist in transitionTable", (tostring(nextState))))
			end

			assert(action == nil or typeof(action) == "function", "action must be a function")
			t3[k2] = v2

			if t2.events[k2] == nil then
				t2.events[k2] = function(p7) -- line: 119
					-- upvalues: t2 (copy), k2 (copy)
					return t2:handleEvent(k2, p7)
				end
			end
		end

		t2.transitionTable[k] = t3
	end

	setmetatable(t2.events, {
		__index = function(_, p9) -- line: 130
			-- upvalues: t2 (copy)
			error(string.format("'%s' is not a valid event in StateTable '%s'", tostring(p9), t2.name), 2)
		end
	})

	return t2
end
function t1.handleEvent(p10, p11, p12) -- line: 150
	-- upvalues: Cryo (copy)
	local v27 = typeof(p11)

	assert(v27 == "string" or v27 == "userdata", string.format("%s '%s' must be a string or userdata but is a %s", "event", tostring(p11), v27))
	assert(p12 == nil or typeof(p12) == "table", "args must be nil or valid table")

	local currentState = p10.currentState
	local v29 = p10.transitionTable[currentState]

	assert(v29 ~= nil, "no transition events for current state")

	if v29[p11] ~= nil then
		local v30 = v29[p11]
		local v31 = v30.nextState or currentState
		local action = v30.action
		local currentContext = p10.currentContext

		if action ~= nil then
			local v34 = action(currentState, v31, p12, p10.currentContext) or {}

			currentContext = Cryo.Dictionary.join(p10.currentContext, v34)
			p10.currentContext = currentContext
		end

		p10.currentState = v31

		if p10.stateChangeHandler ~= nil then
			p10.stateChangeHandler(currentState, v31, currentContext)
		end
	end
end
function t1.onStateChange(p13, p14) -- line: 191
	assert(p14 == nil or typeof(p14) == "function", "stateChangeHandler must be nil or a function")
	p13.stateChangeHandler = p14
end

return t1
