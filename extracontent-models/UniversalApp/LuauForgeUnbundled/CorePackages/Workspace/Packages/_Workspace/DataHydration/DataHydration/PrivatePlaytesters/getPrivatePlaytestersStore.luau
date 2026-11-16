local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPrivatePlaytestersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PrivatePlaytesters/createPrivatePlaytestersStore")

return Signals.createComputed(function()
	return createPrivatePlaytestersStore()
end)
