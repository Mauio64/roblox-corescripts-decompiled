local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Immutable = require(Modules.Common.Immutable)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4) -- line: 71
	-- upvalues: t1 (copy)
	assert(typeof(p1) == "string", "name must be a string")
	assert(#p1 > 0, "name must not be an empty string")
	assert(typeof(p2) == "string", "initialState must be a string")
	assert(#p2 > 0, "initialState must not be an empty string")
	assert(p3 == nil or typeof(p3) == "table", "initialContext must be a table or nil")
	assert(typeof(p4) == "table", "transitionTable must be a table")
	assert(typeof(p4[p2]) == "table", "initialState must be present in transitionTable")

	local t2 = {}

	setmetatable(t2, t1)
	t2.loggingEnabled = false
	t2.name = p1
	t2.currentState = p2
	t2.currentContext = p3 or {}
	t2.transitionTable = {}
	t2.events = {}

	for k, v in pairs(p4) do
		assert(typeof(k) == "string", string.format("state name '%s' must be a string", (tostring(k))))
		assert(typeof(v) == "table", string.format("state name '%s' must map to a table", k))

		local t3 = {}

		for k2, v2 in pairs(v) do
			assert(typeof(k2) == "string", string.format("event name '%s' must be a string", (tostring(k2))))
			assert(typeof(v2) == "table", string.format("event name '%s' must map to a table", k2))

			local nextState = v2.nextState
			local action = v2.action

			if nextState ~= nil then
				assert(typeof(nextState) == "string", string.format("nextState '%s' must be a string or nil", (tostring(nextState))))
				assert(p4[nextState] ~= nil, string.format("nextState '%s' does not exist in transitionTable", nextState))
			end

			assert(action == nil or typeof(action) == "function", "action must be a function")
			t3[k2] = v2

			if t2.events[k2] == nil then
				t2.events[k2] = function(p5) -- line: 127
					-- upvalues: t2 (copy), k2 (copy)
					return t2:handleEvent(k2, p5)
				end
			end
		end

		t2.transitionTable[k] = t3
	end

	setmetatable(t2.events, {
		__index = function(_, p7) -- line: 138
			-- upvalues: t2 (copy)
			error(string.format("'%s' is not a valid event in StateTable '%s'", tostring(p7), t2.name), 2)
		end
	})

	return t2
end
function t1.handleEvent(p8, p9, p10) -- line: 158
	-- upvalues: Immutable (copy), Logging (copy)
	assert(typeof(p9) == "string", "eventKey must be a string")
	assert(#p9 > 0, "eventKey must not be an empty string")
	assert(p10 == nil or typeof(p10) == "table", "args must be nil or valid table")

	local currentState = p8.currentState
	local v22 = p8.transitionTable[currentState]

	assert(v22 ~= nil)

	if v22[p9] ~= nil then
		local v23 = v22[p9]
		local v24 = v23.nextState or currentState
		local action = v23.action

		if p8.loggingEnabled then
			print(string.format("%s: changing state, '%s' [%s] --> '%s'", p8.name, currentState, p9, v24))
		end

		local currentContext = p8.currentContext

		if action ~= nil then
			local v27 = action(currentState, v24, p10, p8.currentContext) or {}

			currentContext = Immutable.JoinDictionaries(p8.currentContext, v27)
			p8.currentContext = currentContext
		end

		p8.currentState = v24

		if p8.stateChangeHandler ~= nil then
			p8.stateChangeHandler(currentState, v24, currentContext)

			return
		end
	elseif p8.loggingEnabled then
		Logging.warn(string.format("%s: unhandled state transition (%s[%s])", p8.name, currentState, p9))
	end
end
function t1.onStateChange(p11, p12) -- line: 208
	assert(p12 == nil or typeof(p12) == "function", "stateChangeHandler must be nil or a function")
	p11.stateChangeHandler = p12
end

return t1
