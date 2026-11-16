local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/MessageBus").MessageBus
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/t")

local getFFlagLuaIdentityProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IdentityProtocol/IdentityProtocol/Flags/getFFlagLuaIdentityProtocol")
local getFFlagLuaIdentityGetSMSOTP = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/SharedFlags").GetFFlagLuaIdentityGetSMSOTP
local getFFlagLuaIdentityGetPhoneNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/SharedFlags").GetFFlagLuaIdentityGetPhoneNumber
local getFFlagLuaIdentityVerifySNA = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityProtocol/SharedFlags").GetFFlagLuaIdentityVerifySNA
require("@game/CorePackages/Workspace/Packages/_Index/IdentityProtocol/IdentityProtocol/IdentityProtocolTypes")

local strictInterface = t.strictInterface({
	result = t.optional(t.string)
})

local v5 = {
	GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getPhoneNumber",
		validateParams = t.table
	},
	GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getPhoneNumber",
		validateParams = strictInterface
	},
	SUPPORTS_GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsGetPhoneNumber",
		validateParams = t.table
	},
	SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsGetPhoneNumber",
		validateParams = t.table
	},
	GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getSMSOTP",
		validateParams = t.table
	},
	GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getSMSOTP",
		validateParams = strictInterface
	},
	SUPPORTS_GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsGetSMSOTP",
		validateParams = t.table
	},
	SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsGetSMSOTP",
		validateParams = t.table
	},
	SUPPORTS_VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsVerifySNA",
		validateParams = t.table
	},
	SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "supportsVerifySNA",
		validateParams = t.table
	},
	VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "verifySNA",
		validateParams = t.table
	},
	VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "verifySNA",
		validateParams = t.table
	}
}

v5.__index = v5

function v5.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, v5))
end

function v5.supportsVerifySNA(data)
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityVerifySNA() then
		local v6 = Promise.new(function(callback, p2)
			local SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR,
				function(p3)
					data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
					callback(p3.support)
				end
			)
		end)

		messageBus.publishProtocolMethodRequest(data.SUPPORTS_VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, {}, {})

		return v6
	end

	return Promise.resolve(false)
end

function v5.verifySNA(data, p2)
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityVerifySNA() then
		local v6 = Promise.new(function(callback, p3)
			local VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = data.VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(
				VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR,
				function(p4)
					data.subscriber:unsubscribeToProtocolMethodResponse(VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
					callback(p4.result)
				end
			)
		end)

		messageBus.publishProtocolMethodRequest(data.VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, p2, {})

		return v6
	end

	return Promise.resolve(false)
end

function v5:getPhoneNumber()
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityGetPhoneNumber() then
		local v6 = Promise.new(function(callback, p2)
			local GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = self.GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR
			self.subscriber:subscribeProtocolMethodResponse(
				GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR,
				function(p3)
					self.subscriber:unsubscribeToProtocolMethodResponse(GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
					callback(p3.result)
				end
			)
		end)

		messageBus.publishProtocolMethodRequest(
			self.GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v6
	end

	return Promise.resolve()
end

function v5:supportsGetPhoneNumber()
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityGetPhoneNumber() then
		local v6 = Promise.new(function(callback, p2)
			local SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR
			self.subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR,
				function(p3)
					self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
					callback(p3.support)
				end
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SUPPORTS_GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v6
	end

	return Promise.resolve()
end

function v5:getSMSOTP()
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityGetSMSOTP() then
		local v6 = Promise.new(function(callback, p2)
			local GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = self.GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR
			self.subscriber:subscribeProtocolMethodResponse(
				GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR,
				function(p3)
					self.subscriber:unsubscribeToProtocolMethodResponse(GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
					callback(p3.result)
				end
			)
		end)

		messageBus.publishProtocolMethodRequest(
			self.GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v6
	end

	return Promise.resolve()
end

function v5:supportsGetSMSOTP()
	if getFFlagLuaIdentityProtocol() and getFFlagLuaIdentityGetSMSOTP() then
		local v6 = Promise.new(function(callback, p2)
			local SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR
			self.subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR,
				function(p3)
					self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
					callback(p3.support)
				end
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SUPPORTS_GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v6
	end

	return Promise.resolve()
end

v5.default = v5.new()

return v5
