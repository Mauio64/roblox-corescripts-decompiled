local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createUsersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUsersStore/createUsersStore")

return Signals.createComputed(function(p2)
	return createUsersStore()
end)
