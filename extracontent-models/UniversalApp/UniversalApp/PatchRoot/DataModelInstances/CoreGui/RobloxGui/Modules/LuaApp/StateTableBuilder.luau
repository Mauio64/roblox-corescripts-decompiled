local Modules = game:GetService("CoreGui").RobloxGui.Modules
local StateTable = require(Modules.LuaApp.StateTable)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 22
	-- upvalues: t1 (copy)
	local t2 = {
		transitionTable = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.withName(p1, p2) -- line: 29
	assert(typeof(p2) == "string", "stateTableName must be a string")
	assert(#p2 > 0, "stateTableName must not be empty")
	assert(p1.stateTableName == nil, "Cannot call withName twice")
	p1.stateTableName = p2

	return p1
end
function t1.withInitialState(p3, p4) -- line: 38
	assert(typeof(p4) == "string", "initialState must be a string")
	assert(#p4 > 0, "initialState must not be empty")
	assert(p3.initialState == nil, "Cannot call withInitialState twice")
	p3.initialState = p4

	return p3
end
function t1.withInitialContext(p5, p6) -- line: 47
	assert(typeof(p6) == "table", "initialContext must be a table")
	assert(p5.initialContext == nil, "Cannot call withInitialContext twice")
	p5.initialContext = p6

	return p5
end
function t1.addState(p7, p8) -- line: 55
	assert(typeof(p8) == "string", "stateName must be a string")
	assert(#p8 > 0, "stateName must not be empty")
	assert(p7.transitionTable[p8] == nil, string.format("Cannot add the same state '%s' twice", p8))
	p7.transitionTable[p8] = {}
	p7.currentStateName = p8
	p7.currentEventName = nil

	return p7
end
function t1.withEvent(p9, p10) -- line: 66
	assert(typeof(p10) == "string", "eventName must be a string")
	assert(#p10 > 0, "eventName must not be empty")
	assert(p9.currentStateName ~= nil, "Cannot add an event without first specifying a state via addState()")
	assert(p9.transitionTable[p9.currentStateName][p10] == nil, "Cannot add an event to the same state more than once")
	p9.transitionTable[p9.currentStateName][p10] = {}
	p9.currentEventName = p10

	return p9
end
function t1.nextState(p11, p12) -- line: 80
	assert(typeof(p12) == "string", "stateName must be a string")
	assert(#p12 > 0, "stateName must not be empty")
	assert(p11.currentEventName ~= nil, "Must specify an event before attaching nextState, via withEvent()")
	assert(p11.transitionTable[p11.currentStateName][p11.currentEventName].nextState == nil, "Cannot set nextState twice for the same event transition")
	p11.transitionTable[p11.currentStateName][p11.currentEventName].nextState = p12

	return p11
end
function t1.action(p13, p14) -- line: 93
	assert(typeof(p14) == "function", "actionFunctor must be a function")
	assert(p13.currentEventName ~= nil, "Must specify an event before attaching action, via withEvent()")
	assert(p13.transitionTable[p13.currentStateName][p13.currentEventName].action == nil, "Cannot set action twice for the same event transition")
	p13.transitionTable[p13.currentStateName][p13.currentEventName].action = p14

	return p13
end
function t1.build(p15) -- line: 105
	-- upvalues: StateTable (copy)
	assert(p15.stateTableName ~= nil and #p15.stateTableName > 0, "State table name was not set via withName()")
	assert(p15.initialState ~= nil and #p15.initialState > 0, "Initial state was not set via withInitialState()")
	assert(typeof(p15.transitionTable[p15.initialState]) == "table", "Initial state was not added to state table")

	return StateTable.new(p15.stateTableName, p15.initialState, p15.initialContext, p15.transitionTable)
end

return t1
