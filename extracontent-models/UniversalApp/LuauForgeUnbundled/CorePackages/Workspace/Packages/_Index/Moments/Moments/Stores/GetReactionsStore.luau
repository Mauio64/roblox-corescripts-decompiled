local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore/createReactionsStore")

return Signals.createComputed(function()
	return createReactionsStore()
end)
