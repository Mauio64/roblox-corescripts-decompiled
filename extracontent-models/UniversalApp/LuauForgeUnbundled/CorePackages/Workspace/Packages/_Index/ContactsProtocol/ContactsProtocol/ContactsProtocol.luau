local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsProtocol/MessageBus").MessageBus
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsProtocol/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsProtocol/t")

require("@game/CorePackages/Workspace/Packages/_Index/ContactsProtocol/ContactsProtocol/ContactsProtocolTypes")

local strictInterface = t.strictInterface({
	firstName = t.optional(t.string),
	lastName = t.optional(t.string),
	phoneNumbers = t.optional(t.table)
})

local v5 = {
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

v5.__index = v5

function v5.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, v5))
end

function v5.getContacts(data)
	local contacts = Promise.new(function(callback, p2)
		local GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		data.subscriber:subscribeProtocolMethodResponse(
			GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p3)
				data.subscriber:unsubscribeToProtocolMethodResponse(GET_CONTACTS_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p3)
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

function v5:supportsContacts()
	local v6 = Promise.new(function(callback, p2)
		local SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		self.subscriber:subscribeProtocolMethodResponse(
			SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			function(p3)
				self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_CONTACTS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p3.support)
			end
		)
	end)

	messageBus.publishProtocolMethodRequest(
		self.SUPPORTS_CONTACTS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		{ includeStatus = false },
		{}
	)

	return v6
end

v5.default = v5.new()

return v5
