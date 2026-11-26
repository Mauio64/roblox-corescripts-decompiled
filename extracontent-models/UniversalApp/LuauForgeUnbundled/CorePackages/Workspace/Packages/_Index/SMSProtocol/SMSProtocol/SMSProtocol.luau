local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/SMSProtocol/MessageBus").MessageBus
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SMSProtocol/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SMSProtocol/t")

require("@game/CorePackages/Workspace/Packages/_Index/SMSProtocol/SMSProtocol/SMSProtocolTypes")

local strictInterface = t.strictInterface({
	sent = t.optional(t.boolean)
})

local v5 = {
	SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "SMSProtocol",
		methodName = "sendSMS",
		validateParams = t.strictInterface({
			address = t.string,
			message = t.string
		})
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

v5.__index = v5

function v5.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, v5))
end

function v5:sendSMS(p2)
	local v6 = Promise.new(function(callback, p3)
		local SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		self.subscriber:subscribeProtocolMethodResponse(
			SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p4)
				self.subscriber:unsubscribeToProtocolMethodResponse(SEND_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p4)
			end
		)
	end)

	messageBus.publishProtocolMethodRequest(self.SEND_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, p2, {})

	return v6
end

function v5:supportsSMS()
	local v6 = Promise.new(function(callback, p2)
		local SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		self.subscriber:subscribeProtocolMethodResponse(
			SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p3)
				self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_SMS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p3.support)
			end
		)
	end)
	messageBus.publishProtocolMethodRequest(
		self.SUPPORTS_SMS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		{ includeStatus = false },
		{}
	)

	return v6
end

v5.default = v5.new()

return v5
