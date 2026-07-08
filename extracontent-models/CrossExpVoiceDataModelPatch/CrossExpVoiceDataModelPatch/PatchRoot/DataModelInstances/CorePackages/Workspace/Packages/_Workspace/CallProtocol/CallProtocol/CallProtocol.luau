local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Promise = require(scriptParentParent.Promise)
local CallProtocolConstants = require(scriptParent.CallProtocolConstants)

require(scriptParent.CallProtocolTypes)

local MessageBusService = game:GetService("MessageBusService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 35
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.initCall(_: {[any]: any}, n1: number, n2: number, s1: string, s2: string, b1: boolean, b2: boolean, s3: string, s4: string?) -- line: 40
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	local t3 = {
		callerId = n1,
		calleeId = n2,
		callerCombinedName = s1,
		calleeCombinedName = s2,
		muted = b1,
		camEnabled = b2,
		callerUniqueIdentifier = s3,
		tag = s4 or ""
	}

	MessageBusService:Publish(CallProtocolConstants.MESSAGE_INIT_CALL, t3)
end
function t1.answerCall(_: {[any]: any}, s5: string) -- line: 64
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_CALL, {
		callId = s5
	})
end
function t1.answerSuccessCall(_: {[any]: any}, s6: string) -- line: 73
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_SUCCESS_CALL, {
		callId = s6
	})
end
function t1.rejectCall(_: {[any]: any}, s7: string) -- line: 82
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_REJECT_CALL, {
		callId = s7
	})
end
function t1.cancelCall(_: {[any]: any}, s8: string) -- line: 91
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_CANCEL_CALL, {
		callId = s8
	})
end
function t1.teleportSuccessCall(_: {[any]: any}, s9: string) -- line: 100
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_TELEPORT_SUCCESS_CALL, {
		callId = s9
	})
end
function t1.finishCall(_: {[any]: any}, s10: string) -- line: 109
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_FINISH_CALL, {
		callId = s10
	})
end
function t1.getCallState(_) -- line: 118
	-- upvalues: Promise (copy), MessageBusService (copy), CallProtocolConstants (copy)
	return (Promise.new(function(resolve, _) -- line: 119
		-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
		MessageBusService:MakeRequest(CallProtocolConstants.NAME, CallProtocolConstants.METHOD_GET_CALL_STATE, {}, function(p3) -- line: 124
			-- upvalues: resolve (copy)
			resolve(p3)
		end, {})
	end))
end
function t1.updateMicAndCamState(_, p5, p6) -- line: 133
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	local t10 = {}

	if p5 ~= nil then
		t10.muted = p5
	end

	if p6 ~= nil then
		t10.camEnabled = p6
	end

	MessageBusService:Publish(CallProtocolConstants.MESSAGE_UDPATE_MIC_AND_CAM_STATE, t10)
end
function t1.listenToHandleInitCall(_: {[any]: any}, p7: ((...any) -> ...any)) -- line: 145
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_INIT_CALL, p7, false, true)
end
function t1.listenToHandleConnectingCall(_: {[any]: any}, p8: ((...any) -> ...any)) -- line: 149
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CONNECTING_CALL, p8, false, true)
end
function t1.listenToHandleTeleportingCall(_: {[any]: any}, p9: ((...any) -> ...any)) -- line: 153
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TELEPORTING_CALL, p9, false, true)
end
function t1.listenToHandleActiveCall(_: {[any]: any}, p10: ((...any) -> ...any)) -- line: 157
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_ACTIVE_CALL, p10, false, true)
end
function t1.listenToHandleEndCall(_: {[any]: any}, p11: ((...any) -> ...any)) -- line: 161
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_END_CALL, p11, false, true)
end
function t1.listenToHandleCallMessage(_: {[any]: any}, p12: ((...any) -> ...any)) -- line: 165
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CALL_MESSAGE, p12, false, true)
end
function t1.listenToHandleMicAndCamChanged(_: {[any]: any}, p13: ((...any) -> ...any)) -- line: 169
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_MIC_AND_CAM_CHANGED, p13, false, true)
end
function t1.listenToHandleTransferCallTeleportLeave(_: {[any]: any}, p14: ((...any) -> ...any)) -- line: 173
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_LEAVE, p14, false, true)
end
function t1.listenToHandleTransferCallTeleportJoin(_: {[any]: any}, p15: ((...any) -> ...any)) -- line: 177
	-- upvalues: MessageBusService (copy), CallProtocolConstants (copy)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_JOIN, p15, false, true)
end

t1.default = t1.new()

return t1
