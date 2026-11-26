local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
local requestSent = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Actions").RequestSent
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")

local v5 = {}

return function(p2)
	return Rodux.createReducer(v5, {
		[requestSent.name] = function(p3, p4)
			return Dash.join(p3, { [p4.payload.id] = true })
		end
	})
end
