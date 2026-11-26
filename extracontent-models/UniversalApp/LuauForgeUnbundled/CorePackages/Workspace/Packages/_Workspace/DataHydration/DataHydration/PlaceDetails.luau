local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/PlaceDetailsStoreTypes")

return {
	createPlaceDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/createPlaceDetailsStore"),
	getPlaceDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/getPlaceDetailsStore"),
	PlaceDetailsStoreTypes = module
}
