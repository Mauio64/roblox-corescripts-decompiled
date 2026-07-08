local ParentParent = script.Parent.Parent
local Types = ParentParent.Types
local byContactId = require(ParentParent.Reducers.Contacts.byContactId)
local byDeviceContactId = require(ParentParent.Reducers.Contacts.byDeviceContactId)
local hasSentRequest = require(ParentParent.Reducers.Contacts.hasSentRequest)

require(Types.ReducerTypes)

local deviceContactToRobloxContact = require(ParentParent.Reducers.Contacts.deviceContactToRobloxContact)
local t1 = {
	byContactId = {},
	byDeviceContactId = {},
	hasSentRequest = {},
	deviceContactToRobloxContact = {}
}

return function(p1) -- line: 16
	-- upvalues: byContactId (copy), byDeviceContactId (copy), hasSentRequest (copy), deviceContactToRobloxContact (copy), t1 (copy)
	local v9 = byContactId(p1)
	local v10 = byDeviceContactId(p1)
	local v11 = hasSentRequest(p1)
	local v12 = deviceContactToRobloxContact(p1)

	return function(p2, p3) -- line: 22
		-- upvalues: t1 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy)
		local v15 = p2 or t1

		return {
			byContactId = v9(v15.byContactId, p3),
			byDeviceContactId = v10(v15.byDeviceContactId, p3),
			hasSentRequest = v11(v15.hasSentRequest, p3),
			deviceContactToRobloxContact = v12(v15.deviceContactToRobloxContact, p3)
		}
	end
end
