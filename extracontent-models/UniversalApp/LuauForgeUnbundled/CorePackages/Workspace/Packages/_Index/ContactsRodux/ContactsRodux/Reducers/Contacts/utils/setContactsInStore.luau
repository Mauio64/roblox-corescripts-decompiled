require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")

require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")

return function(p2)
	local userContactIds = p2.responseBody.userContactIds
	local v5 = {}

	Dash.forEach(userContactIds, function(p3)
		v5[p3] = {}
	end)

	return v5
end
