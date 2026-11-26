local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetMessageReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore")
local createMessageReactionsViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsViewModelStore/createMessageReactionsViewModelStore")

return Signals.createComputed(function()
	return createMessageReactionsViewModelStore(GetMessageReactionsStore(false))
end)
