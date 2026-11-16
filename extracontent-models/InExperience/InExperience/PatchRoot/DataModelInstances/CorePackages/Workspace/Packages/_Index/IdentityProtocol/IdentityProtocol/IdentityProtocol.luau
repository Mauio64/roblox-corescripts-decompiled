local parent = script.Parent.Parent

local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local Promise = require(parent.Promise)
local t = require(parent.t)

local getFFlagLuaIdentityProtocol = require(script.Parent.Flags.getFFlagLuaIdentityProtocol)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaIdentityGetSMSOTP = SharedFlags.GetFFlagLuaIdentityGetSMSOTP
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaIdentityGetPhoneNumber = SharedFlags2.GetFFlagLuaIdentityGetPhoneNumber
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagLuaIdentityVerifySNA = SharedFlags3.GetFFlagLuaIdentityVerifySNA
require(script.Parent.IdentityProtocolTypes)

local strictInterface = t.strictInterface({ result = t.optional(t.string) })

local IdentityProtocol = {
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

IdentityProtocol.__index = IdentityProtocol

function IdentityProtocol.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, IdentityProtocol))
end

function IdentityProtocol.supportsVerifySNA(data)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityVerifySNA() then
		local v = Promise.new(function(callback, _)
			local SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR, function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
				callback(p.support)
			end)
		end)

		messageBus.publishProtocolMethodRequest(data.SUPPORTS_VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, {}, {})

		return v
	end

	return Promise.resolve(false)
end

function IdentityProtocol.verifySNA(data, p)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityVerifySNA() then
		local v = Promise.new(function(callback, _)
			local VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = data.VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR, function(p2)
				data.subscriber:unsubscribeToProtocolMethodResponse(VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
				callback(p2.result)
			end)
		end)

		messageBus.publishProtocolMethodRequest(data.VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, p, {})

		return v
	end

	return Promise.resolve(false)
end

function IdentityProtocol.getPhoneNumber(data)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityGetPhoneNumber() then
		local v = Promise.new(function(callback, _)
			local GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = data.GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR, function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
				callback(p.result)
			end)
		end)

		messageBus.publishProtocolMethodRequest(
			data.GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v
	end

	return Promise.resolve()
end

function IdentityProtocol.supportsGetPhoneNumber(data)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityGetPhoneNumber() then
		local v = Promise.new(function(callback, _)
			local SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR,
				function(p)
					data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
					callback(p.support)
				end
			)
		end)
		messageBus.publishProtocolMethodRequest(
			data.SUPPORTS_GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v
	end

	return Promise.resolve()
end

function IdentityProtocol.getSMSOTP(data)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityGetSMSOTP() then
		local v = Promise.new(function(callback, _)
			local GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = data.GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR, function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
				callback(p.result)
			end)
		end)

		messageBus.publishProtocolMethodRequest(
			data.GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v
	end

	return Promise.resolve()
end

function IdentityProtocol.supportsGetSMSOTP(data)
	if getFFlagLuaIdentityProtocol() and GetFFlagLuaIdentityGetSMSOTP() then
		local v = Promise.new(function(callback, _)
			local SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR
			data.subscriber:subscribeProtocolMethodResponse(SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR, function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
				callback(p.support)
			end)
		end)
		messageBus.publishProtocolMethodRequest(
			data.SUPPORTS_GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)

		return v
	end

	return Promise.resolve()
end

IdentityProtocol.default = IdentityProtocol.new()

return IdentityProtocol
