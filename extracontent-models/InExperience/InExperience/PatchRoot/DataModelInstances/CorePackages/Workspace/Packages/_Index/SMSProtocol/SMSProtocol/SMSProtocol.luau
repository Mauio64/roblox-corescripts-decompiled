local parent = script.Parent.Parent

local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local Promise = require(parent.Promise)
local t = require(parent.t)

require(script.Parent.SMSProtocolTypes)

local strictInterface = t.strictInterface({ sent = t.optional(t.boolean) })

local SMSProtocol = {
	SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "sendSMS",
		validateParams = t.strictInterface({ address = t.string, message = t.string })
	},
	SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "sendSMS",
		validateParams = strictInterface
	},
	SUPPORTS_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "supportsSMS",
		validateParams = t.table
	},
	SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "supportsSMS",
		validateParams = t.table
	}
}

SMSProtocol.__index = SMSProtocol

function SMSProtocol.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, SMSProtocol))
end

function SMSProtocol.sendSMS(data, p)
	local v = Promise.new(function(callback, _)
		local SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		data.subscriber:subscribeProtocolMethodResponse(SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p2)
			data.subscriber:unsubscribeToProtocolMethodResponse(SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			callback(p2)
		end)
	end)

	messageBus.publishProtocolMethodRequest(data.SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, p, {})

	return v
end

function SMSProtocol.supportsSMS(data)
	local v = Promise.new(function(callback, _)
		local SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		data.subscriber:subscribeProtocolMethodResponse(SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p)
			data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			callback(p.support)
		end)
	end)
	messageBus.publishProtocolMethodRequest(
		data.SUPPORTS_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		{ includeStatus = false },
		{}
	)

	return v
end

SMSProtocol.default = SMSProtocol.new()

return SMSProtocol
