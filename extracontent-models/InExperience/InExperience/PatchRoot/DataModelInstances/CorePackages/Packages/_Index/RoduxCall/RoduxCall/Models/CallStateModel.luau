local RoduxCall = script:FindFirstAncestor("RoduxCall")
local parent = RoduxCall.Parent

local Enums = require(RoduxCall.Enums)
local Status = Enums.Status

local t = require(parent.t)

local CallStateModel = {}

function CallStateModel.new(p)
	assert(CallStateModel.isValid(p))

	CallStateModel.__index = CallStateModel

	setmetatable(p, CallStateModel)

	return p
end

function CallStateModel.mock(options)
	local v = options or {}

	return (CallStateModel.new({
		status = v.status or Status.Active,
		callerId = v.callerId or 123,
		calleeId = v.calleeId or 456,
		placeId = v.placeId or 789,
		reservedServerAccessCode = v.reservedServerAccessCode or nil,
		callId = v.callId or nil,
		callerCombinedName = v.callerCombinedName or nil,
		calleeCombinedName = v.calleeCombinedName or nil,
		instanceId = v.instanceId or nil,
		createdUtc = v.createdUtc or 0,
		activeUtc = v.activeUtc or 0
	}))
end

function CallStateModel.format(data)
	return (CallStateModel.new({
		status = data.status,
		callerId = data.callerId,
		calleeId = data.calleeId,
		placeId = data.placeId,
		reservedServerAccessCode = data.reservedServerAccessCode,
		callId = data.callId,
		callerCombinedName = data.callerCombinedName,
		calleeCombinedName = data.calleeCombinedName,
		instanceId = data.instanceId,
		createdUtc = data.createdUtc,
		activeUtc = data.activeUtc
	}))
end

CallStateModel.isValid = t.strictInterface({
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

return CallStateModel
