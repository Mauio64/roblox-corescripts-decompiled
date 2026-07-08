local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local Promise = require(ParentParent.Promise)
local t = require(ParentParent.t)
local getFFlagLuaIdentityProtocol = require(script.Parent.Flags.getFFlagLuaIdentityProtocol)
local GetFFlagLuaIdentityGetSMSOTP = require(ParentParent.SharedFlags).GetFFlagLuaIdentityGetSMSOTP
local GetFFlagLuaIdentityGetPhoneNumber = require(ParentParent.SharedFlags).GetFFlagLuaIdentityGetPhoneNumber
local GetFFlagLuaIdentityVerifySNA = require(ParentParent.SharedFlags).GetFFlagLuaIdentityVerifySNA

require(script.Parent.IdentityProtocolTypes)

local v9 = t.strictInterface({
	result = t.optional(t.string)
})
local t1 = {
	GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getPhoneNumber",
		validateParams = t.table
	},
	GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "IdentityProtocol",
		methodName = "getPhoneNumber",
		validateParams = v9
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
		validateParams = v9
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

t1.__index = t1

function t1.new() -- line: 101
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		subscriber = MessageBus.Subscriber.new()
	}, t1))
end
function t1.supportsVerifySNA(p1) -- line: 113
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityVerifySNA (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityVerifySNA() then
		return Promise.resolve(false)
	end

	local v12 = Promise.new(function(resolve, _) -- line: 118
		-- upvalues: p1 (copy)
		local SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = p1.SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR

		p1.subscriber:subscribeProtocolMethodResponse(SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR, function(t2: {[any]: any}) -- line: 120
			-- upvalues: p1 (copy), SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p1.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t2.support)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p1.SUPPORTS_VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, {}, {})

	return v12
end
function t1.verifySNA(p3, p4) -- line: 142
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityVerifySNA (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityVerifySNA() then
		return Promise.resolve(false)
	end

	local v15 = Promise.new(function(resolve, _) -- line: 147
		-- upvalues: p3 (copy)
		local VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR = p3.VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR

		p3.subscriber:subscribeProtocolMethodResponse(VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR, function(t3: {[any]: any}) -- line: 149
			-- upvalues: p3 (copy), VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p3.subscriber:unsubscribeToProtocolMethodResponse(VERIFY_SNA_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t3.result)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p3.VERIFY_SNA_METHOD_REQUEST_DESCRIPTOR, p4, {})

	return v15
end
function t1.getPhoneNumber(p6) -- line: 168
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityGetPhoneNumber (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityGetPhoneNumber() then
		return Promise.resolve()
	end

	local v17 = Promise.new(function(resolve, _) -- line: 172
		-- upvalues: p6 (copy)
		local GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = p6.GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR

		p6.subscriber:subscribeProtocolMethodResponse(GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR, function(t4: {[any]: any}) -- line: 174
			-- upvalues: p6 (copy), GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p6.subscriber:unsubscribeToProtocolMethodResponse(GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t4.result)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p6.GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v17
end
function t1.supportsGetPhoneNumber(p8) -- line: 197
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityGetPhoneNumber (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityGetPhoneNumber() then
		return Promise.resolve()
	end

	local v19 = Promise.new(function(resolve, _) -- line: 202
		-- upvalues: p8 (copy)
		local SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR = p8.SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR

		p8.subscriber:subscribeProtocolMethodResponse(SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR, function(t5: {[any]: any}) -- line: 204
			-- upvalues: p8 (copy), SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p8.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_PHONE_NUMBER_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t5.support)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p8.SUPPORTS_GET_PHONE_NUMBER_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v19
end
function t1.getSMSOTP(p10) -- line: 227
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityGetSMSOTP (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityGetSMSOTP() then
		return Promise.resolve()
	end

	local v21 = Promise.new(function(resolve, _) -- line: 231
		-- upvalues: p10 (copy)
		local GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = p10.GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR

		p10.subscriber:subscribeProtocolMethodResponse(GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR, function(t6: {[any]: any}) -- line: 233
			-- upvalues: p10 (copy), GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p10.subscriber:unsubscribeToProtocolMethodResponse(GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t6.result)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p10.GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v21
end
function t1.supportsGetSMSOTP(p12) -- line: 256
	-- upvalues: getFFlagLuaIdentityProtocol (copy), GetFFlagLuaIdentityGetSMSOTP (copy), Promise (copy), MessageBus (copy)
	if not getFFlagLuaIdentityProtocol() or not GetFFlagLuaIdentityGetSMSOTP() then
		return Promise.resolve()
	end

	local v23 = Promise.new(function(resolve, _) -- line: 261
		-- upvalues: p12 (copy)
		local SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR = p12.SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR

		p12.subscriber:subscribeProtocolMethodResponse(SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR, function(t7: {[any]: any}) -- line: 263
			-- upvalues: p12 (copy), SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p12.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_GET_SMS_OTP_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t7.support)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p12.SUPPORTS_GET_SMS_OTP_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v23
end

t1.default = t1.new()

return t1
