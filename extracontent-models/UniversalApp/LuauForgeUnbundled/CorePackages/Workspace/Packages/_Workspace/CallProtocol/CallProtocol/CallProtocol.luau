local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CallProtocol/Promise")

local CallProtocolConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CallProtocol/CallProtocol/CallProtocolConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/CallProtocol/CallProtocol/CallProtocolTypes")

local MessageBusService = game:GetService("MessageBusService")

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class.initCall(p2, p3, p4, p5, p6, p7, p8, p9, value)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_INIT_CALL, {
		callerId = p3,
		calleeId = p4,
		callerCombinedName = p5,
		calleeCombinedName = p6,
		muted = p7,
		camEnabled = p8,
		callerUniqueIdentifier = p9,
		tag = value or ""
	})
end

function class.answerCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_CALL, { callId = p3 })
end

function class.answerSuccessCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_ANSWER_SUCCESS_CALL, { callId = p3 })
end

function class.rejectCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_REJECT_CALL, { callId = p3 })
end

function class.cancelCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_CANCEL_CALL, { callId = p3 })
end

function class.teleportSuccessCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_TELEPORT_SUCCESS_CALL, { callId = p3 })
end

function class.finishCall(p2, p3)
	MessageBusService:Publish(CallProtocolConstants.MESSAGE_FINISH_CALL, { callId = p3 })
end

function class:getCallState()
	return (Promise.new(function(callback, p3)
		MessageBusService:MakeRequest(CallProtocolConstants.NAME, CallProtocolConstants.METHOD_GET_CALL_STATE, {}, function(p4)
			callback(p4)
		end, {})
	end))
end

function class.updateMicAndCamState(p2, muted, camEnabled)
	local v5 = {}

	if muted ~= nil then
		v5.muted = muted
	end

	if camEnabled ~= nil then
		v5.camEnabled = camEnabled
	end

	MessageBusService:Publish(CallProtocolConstants.MESSAGE_UDPATE_MIC_AND_CAM_STATE, v5)
end

function class.listenToHandleInitCall(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_INIT_CALL, p3, false, true)
end

function class.listenToHandleConnectingCall(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CONNECTING_CALL, p3, false, true)
end

function class.listenToHandleTeleportingCall(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TELEPORTING_CALL, p3, false, true)
end

function class.listenToHandleActiveCall(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_ACTIVE_CALL, p3, false, true)
end

function class.listenToHandleEndCall(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_END_CALL, p3, false, true)
end

function class.listenToHandleCallMessage(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_CALL_MESSAGE, p3, false, true)
end

function class.listenToHandleMicAndCamChanged(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_MIC_AND_CAM_CHANGED, p3, false, true)
end

function class.listenToHandleTransferCallTeleportLeave(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_LEAVE, p3, false, true)
end

function class.listenToHandleTransferCallTeleportJoin(p2, p3)
	return MessageBusService:Subscribe(CallProtocolConstants.MESSAGE_HANDLE_TRANSFER_CALL_TELEPORT_JOIN, p3, false, true)
end

class.default = class.new()

return class
