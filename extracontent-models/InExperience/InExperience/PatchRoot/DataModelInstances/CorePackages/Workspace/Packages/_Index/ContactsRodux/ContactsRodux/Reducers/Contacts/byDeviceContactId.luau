local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local types = parent.Types
local Rodux = require(parent2.Rodux)
require(types.ReducerTypes)
require(types.ActionTypes)
local Actions = require(parent.Actions)
local DeviceContactsReceived = Actions.DeviceContactsReceived
local Dash = require(parent2.Dash)
local DeviceContact = require(parent.Models.DeviceContact)

local v = {}

return function(_)
	return Rodux.createReducer(v, {
		[DeviceContactsReceived.name] = function(_, p)
			local payload = p.payload
			local formatFromDevicesById = {}
			Dash.forEach(payload, function(p2)
				local formatFromDevice = DeviceContact.formatFromDevice(p2)

				formatFromDevicesById[formatFromDevice.id] = formatFromDevice
			end)

			return formatFromDevicesById
		end
	})
end
