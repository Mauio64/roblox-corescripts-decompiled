local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore/createShareCountsStore")

return Signals.createComputed(function()
	return createShareCountsStore()
end)
