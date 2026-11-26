local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createMessageReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore/createMessageReactionsStore")

return Signals.createComputed(function(p2)
	return createMessageReactionsStore()
end)
