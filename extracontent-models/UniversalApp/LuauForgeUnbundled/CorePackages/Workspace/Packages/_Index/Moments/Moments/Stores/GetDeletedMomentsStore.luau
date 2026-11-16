local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeletedMomentsStore/createDeletedMomentsStore")

return Signals.createComputed(function()
	return createDeletedMomentsStore()
end)
