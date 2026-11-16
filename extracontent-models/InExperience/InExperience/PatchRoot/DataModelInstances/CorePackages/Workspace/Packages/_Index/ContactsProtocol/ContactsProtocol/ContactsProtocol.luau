local parent = script.Parent.Parent
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local Promise = require(parent.Promise)
local t = require(parent.t)

require(script.Parent.ContactsProtocolTypes)

local strictInterface = t.strictInterface({
	firstName = t.optional(t.string),
	lastName = t.optional(t.string),
	phoneNumbers = t.optional(t.table)
})

local ContactsProtocol = {
	GET_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "getContacts",
		validateParams = t.table
	},
	GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "ContactsProtocol",
		methodName = "getContacts",
		validateParams = strictInterface
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

ContactsProtocol.__index = ContactsProtocol

function ContactsProtocol.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, ContactsProtocol))
end

function ContactsProtocol.getContacts(data)
	local contacts = Promise.new(function(callback, _)
		local GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		data.subscriber:subscribeProtocolMethodResponse(
			GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end
		)
	end)

	messageBus.publishProtocolMethodRequest(
		data.GET_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		{ includeVariable = false },
		{}
	)

	return contacts
end

function ContactsProtocol.supportsContacts(data)
	local v = Promise.new(function(callback, _)
		local SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		data.subscriber:subscribeProtocolMethodResponse(
			SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p.support)
			end
		)
	end)

	messageBus.publishProtocolMethodRequest(
		data.SUPPORTS_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		{ includeStatus = false },
		{}
	)

	return v
end

ContactsProtocol.default = ContactsProtocol.new()

return ContactsProtocol
