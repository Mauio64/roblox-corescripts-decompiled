local parent = script.Parent.Parent
local types = parent.Types
local byContactId = require(parent.Reducers.Contacts.byContactId)
local byDeviceContactId = require(parent.Reducers.Contacts.byDeviceContactId)
local hasSentRequest = require(parent.Reducers.Contacts.hasSentRequest)
require(types.ReducerTypes)
local deviceContactToRobloxContact = require(parent.Reducers.Contacts.deviceContactToRobloxContact)

local v = {
	byContactId = {},
	byDeviceContactId = {},
	hasSentRequest = {},
	deviceContactToRobloxContact = {}
}

return function(p)
	local v2 = byContactId(p)
	local v3 = byDeviceContactId(p)
	local sentRequest = hasSentRequest(p)
	local v4 = deviceContactToRobloxContact(p)

	return function(p2, p3)
		local v5 = p2 or v
		return {
			byContactId = v2(v5.byContactId, p3),
			byDeviceContactId = v3(v5.byDeviceContactId, p3),
			hasSentRequest = sentRequest(v5.hasSentRequest, p3),
			deviceContactToRobloxContact = v4(v5.deviceContactToRobloxContact, p3)
		}
	end
end
