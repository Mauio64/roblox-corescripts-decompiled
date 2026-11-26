local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
local deviceContactsReceived = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Actions").DeviceContactsReceived
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")
local DeviceContact = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Models/DeviceContact")

local v5 = {}

return function(p2)
	return Rodux.createReducer(v5, {
		[deviceContactsReceived.name] = function(p3, p4)
			local payload = p4.payload
			local formatFromDevicesById = {}
			Dash.forEach(payload, function(p5)
				local formatFromDevice = DeviceContact.formatFromDevice(p5)

				formatFromDevicesById[formatFromDevice.id] = formatFromDevice
			end)

			return formatFromDevicesById
		end
	})
end
