local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")

return Signals.createComputed(function(p2)
	return createMomentsStore()
end)
