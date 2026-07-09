local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Types = ParentParent.Types
local Rodux = require(ParentParentParent.Rodux)

require(Types.ReducerTypes)
require(Types.ActionTypes)

local DeviceContactsReceived = require(ParentParent.Actions).DeviceContactsReceived
local Dash = require(ParentParentParent.Dash)
local DeviceContact = require(ParentParent.Models.DeviceContact)
local t1 = {}

return function(_) -- line: 14
	-- upvalues: Rodux (copy), t1 (copy), DeviceContactsReceived (copy), Dash (copy), DeviceContact (copy)
	return Rodux.createReducer(t1, {
		[DeviceContactsReceived.name] = function(_, p3) -- line: 16
			-- upvalues: Dash (copy), DeviceContact (copy)
			local payload = p3.payload
			local t2 = {}

			Dash.forEach(payload, function(p4) -- line: 22
				-- upvalues: DeviceContact (copy), t2 (copy)
				local v15 = DeviceContact.formatFromDevice(p4)

				t2[v15.id] = v15
			end)

			return t2
		end
	})
end
