local parent = script.Parent
local parent2 = parent.Parent

local Promise = require(parent2.Promise)

local CallProtocolConstants = require(parent.CallProtocolConstants)
require(parent.CallProtocolTypes)

local MessageBusService = game:GetService("MessageBusService")

local CallProtocol = {}
CallProtocol.__index = CallProtocol

function CallProtocol.new()
	return (setmetatable({}, CallProtocol))
end

function CallProtocol.initCall(_, callerId: number, calleeId: number, callerCombinedName: string, calleeCombinedName: string, muted: boolean, camEnabled: boolean, callerUniqueIdentifier: string, value: string?)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_INIT_CALL, {
		callerId = callerId,
		calleeId = calleeId,
		callerCombinedName = callerCombinedName,
		calleeCombinedName = calleeCombinedName,
		muted = muted,
		camEnabled = camEnabled,
		callerUniqueIdentifier = callerUniqueIdentifier,
		tag = value or ""
	})
end

function CallProtocol.answerCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_CALL, { callId = callId })
end

function CallProtocol.answerSuccessCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_SUCCESS_CALL, { callId = callId })
end

function CallProtocol.rejectCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_REJECT_CALL, { callId = callId })
end

function CallProtocol.cancelCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_CANCEL_CALL, { callId = callId })
end

function CallProtocol.teleportSuccessCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_TELEPORT_SUCCESS_CALL, {
		callId = callId
	})
end

function CallProtocol.finishCall(_, callId: string)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_FINISH_CALL, { callId = callId })
end

function CallProtocol.getCallState(_)
	return (Promise.new(function(callback, _)
		MessageBusService:MakeRequest(
			CallProtocolConstants.NAME,
			CallProtocolConstants.METHOD_GET_CALL_STATE,
			{},
			function(p)
				callback(p)
			end,
			{}
		)
	end))
end

function CallProtocol.updateMicAndCamState(_, muted, camEnabled)
	local v = {}

	if muted ~= nil then
		v.muted = muted
	end

	if camEnabled ~= nil then
		v.camEnabled = camEnabled
	end

	MessageBusService:Publish(CallProtocolConstants.MESSAGE_UDPATE_MIC_AND_CAM_STATE, v)
end

function CallProtocol.listenToHandleInitCall(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_INIT_CALL, callback, false, true)
end

function CallProtocol.listenToHandleConnectingCall(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CONNECTING_CALL, callback, false, true)
end

function CallProtocol.listenToHandleTeleportingCall(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TELEPORTING_CALL, callback, false, true)
end

function CallProtocol.listenToHandleActiveCall(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_ACTIVE_CALL, callback, false, true)
end

function CallProtocol.listenToHandleEndCall(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_END_CALL, callback, false, true)
end

function CallProtocol.listenToHandleCallMessage(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CALL_MESSAGE, callback, false, true)
end

function CallProtocol.listenToHandleMicAndCamChanged(_, callback)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_MIC_AND_CAM_CHANGED, callback, false, true)
end

function CallProtocol.listenToHandleTransferCallTeleportLeave(_, callback)
	return MessageBusService:Subscribe(
		CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_LEAVE,
		callback,
		false,
		true
	)
end

function CallProtocol.listenToHandleTransferCallTeleportJoin(_, callback)
	return MessageBusService:Subscribe(
		CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_JOIN,
		callback,
		false,
		true
	)
end

CallProtocol.default = CallProtocol.new()

return CallProtocol
