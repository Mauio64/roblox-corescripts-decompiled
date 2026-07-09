local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local Promise = require(ParentParent.Promise)
local t = require(ParentParent.t)

require(script.Parent.SMSProtocolTypes)

local v5 = t.strictInterface({
	sent = t.optional(t.boolean)
})
local v6 = t.strictInterface({
	address = t.string,
	message = t.string
})
local t1 = {
	SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "sendSMS",
		validateParams = v6
	},
	SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "sendSMS",
		validateParams = v5
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

t1.__index = t1

function t1.new() -- line: 59
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		subscriber = MessageBus.Subscriber.new()
	}, t1))
end
function t1.sendSMS(p1, p2) -- line: 72
	-- upvalues: Promise (copy), MessageBus (copy)
	local v10 = Promise.new(function(resolve, _) -- line: 73
		-- upvalues: p1 (copy)
		local SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p1.SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p1.subscriber:subscribeProtocolMethodResponse(SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p4) -- line: 75
			-- upvalues: p1 (copy), SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p1.subscriber:unsubscribeToProtocolMethodResponse(SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p4)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p1.SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, p2, {})

	return v10
end
function t1.supportsSMS(p5) -- line: 93
	-- upvalues: Promise (copy), MessageBus (copy)
	local v12 = Promise.new(function(resolve, _) -- line: 94
		-- upvalues: p5 (copy)
		local SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p5.SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p5.subscriber:subscribeProtocolMethodResponse(SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(t2: {[any]: any}) -- line: 96
			-- upvalues: p5 (copy), SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p5.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t2.support)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p5.SUPPORTS_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v12
end

t1.default = t1.new()

return t1
