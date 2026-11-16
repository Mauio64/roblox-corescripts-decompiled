local module = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/byContactId")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/byDeviceContactId")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/hasSentRequest")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/deviceContactToRobloxContact")

local v5 = {
	byContactId = {},
	byDeviceContactId = {},
	hasSentRequest = {},
	deviceContactToRobloxContact = {}
}

return function(p2)
	local v6 = module(p2)
	local v7 = module2(p2)
	local v8 = module3(p2)
	local v9 = module4(p2)

	return function(p3, p4)
		local v10 = p3 or v5
		return {
			byContactId = v6(v10.byContactId, p4),
			byDeviceContactId = v7(v10.byDeviceContactId, p4),
			hasSentRequest = v8(v10.hasSentRequest, p4),
			deviceContactToRobloxContact = v9(v10.deviceContactToRobloxContact, p4)
		}
	end
end
