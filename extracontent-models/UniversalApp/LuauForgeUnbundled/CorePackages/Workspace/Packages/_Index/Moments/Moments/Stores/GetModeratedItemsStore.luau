local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createModeratedItemsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetModeratedItemsStore/createModeratedItemsStore")

return Signals.createComputed(function()
	return createModeratedItemsStore()
end)
