local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/AssetUserAuthStoreTypes")

return {
	createAssetUserAuthStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/createAssetUserAuthStore"),
	getAssetUserAuthStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/getAssetUserAuthStore"),
	AssetUserAuthStoreTypes = module
}
