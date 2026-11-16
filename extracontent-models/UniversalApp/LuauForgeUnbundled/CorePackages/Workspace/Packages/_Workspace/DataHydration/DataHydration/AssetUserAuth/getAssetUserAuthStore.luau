local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createAssetUserAuthStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/createAssetUserAuthStore")

return Signals.createComputed(function()
	return createAssetUserAuthStore()
end)
