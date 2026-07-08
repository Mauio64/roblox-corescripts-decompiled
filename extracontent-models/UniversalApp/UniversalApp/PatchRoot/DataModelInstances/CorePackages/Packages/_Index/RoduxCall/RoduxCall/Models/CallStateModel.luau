local RoduxCall = script:FindFirstAncestor("RoduxCall")
local RoduxCallParent = RoduxCall.Parent
local Status = require(RoduxCall.Enums).Status
local t = require(RoduxCallParent.t)
local t1 = {}

function t1.new(p1) -- line: 10
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 22
	-- upvalues: t1 (copy), Status (copy)
	local v8 = p2 or {}

	return (t1.new({
		status = v8.status or Status.Active,
		callerId = v8.callerId or 123,
		calleeId = v8.calleeId or 456,
		placeId = v8.placeId or 789,
		reservedServerAccessCode = v8.reservedServerAccessCode or nil,
		callId = v8.callId or nil,
		callerCombinedName = v8.callerCombinedName or nil,
		calleeCombinedName = v8.calleeCombinedName or nil,
		instanceId = v8.instanceId or nil,
		createdUtc = v8.createdUtc or 0,
		activeUtc = v8.activeUtc or 0
	}))
end
function t1.format(p3) -- line: 42
	-- upvalues: t1 (copy)
	return (t1.new({
		status = p3.status,
		callerId = p3.callerId,
		calleeId = p3.calleeId,
		placeId = p3.placeId,
		reservedServerAccessCode = p3.reservedServerAccessCode,
		callId = p3.callId,
		callerCombinedName = p3.callerCombinedName,
		calleeCombinedName = p3.calleeCombinedName,
		instanceId = p3.instanceId,
		createdUtc = p3.createdUtc,
		activeUtc = p3.activeUtc
	}))
end

t1.isValid = t.strictInterface({
	status = t.string,
	callerId = t.optional(t.number),
	calleeId = t.optional(t.number),
	placeId = t.optional(t.number),
	reservedServerAccessCode = t.optional(t.string),
	callId = t.optional(t.string),
	callerCombinedName = t.optional(t.string),
	calleeCombinedName = t.optional(t.string),
	instanceId = t.optional(t.string),
	createdUtc = t.optional(t.number),
	activeUtc = t.optional(t.number)
})

return t1
