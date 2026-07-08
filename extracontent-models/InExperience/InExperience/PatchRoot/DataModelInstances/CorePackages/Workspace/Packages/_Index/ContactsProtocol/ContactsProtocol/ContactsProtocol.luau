local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local Promise = require(ParentParent.Promise)
local t = require(ParentParent.t)

require(script.Parent.ContactsProtocolTypes)

local v5 = t.strictInterface({
	firstName = t.optional(t.string),
	lastName = t.optional(t.string),
	phoneNumbers = t.optional(t.table)
})
local t1 = {
	GET_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "getContacts",
		validateParams = t.table
	},
	GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "getContacts",
		validateParams = v5
	},
	SUPPORTS_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "SupportsContacts",
		validateParams = t.table
	},
	SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "SupportsContacts",
		validateParams = t.table
	}
}

t1.__index = t1

function t1.new() -- line: 55
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		subscriber = MessageBus.Subscriber.new()
	}, t1))
end
function t1.getContacts(p1) -- line: 68
	-- upvalues: Promise (copy), MessageBus (copy)
	local v8 = Promise.new(function(resolve, _) -- line: 69
		-- upvalues: p1 (copy)
		local GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p1.GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p1.subscriber:subscribeProtocolMethodResponse(GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p3) -- line: 71
			-- upvalues: p1 (copy), GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p1.subscriber:unsubscribeToProtocolMethodResponse(GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p3)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p1.GET_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		includeVariable = false
	}, {})

	return v8
end
function t1.supportsContacts(p4) -- line: 96
	-- upvalues: Promise (copy), MessageBus (copy)
	local v10 = Promise.new(function(resolve, _) -- line: 97
		-- upvalues: p4 (copy)
		local SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p4.SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p4.subscriber:subscribeProtocolMethodResponse(SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(t2: {[any]: any}) -- line: 99
			-- upvalues: p4 (copy), SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p4.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(t2.support)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p4.SUPPORTS_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v10
end

t1.default = t1.new()

return t1
