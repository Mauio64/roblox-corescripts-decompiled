local module = require("@luauforge/bundled/dTh")
local module2 = require("@luauforge/bundled/dTj")

return {
	SduiAvatarExperienceRegister = require("@luauforge/bundled/dTm"),
	registerAvatarExperienceActions = require("@luauforge/bundled/dTn"),
	registerAvatarExperienceUiComponents = require("@luauforge/bundled/dUH"),
	MarketplaceCatalogSduiSelectionBridge = module,
	useCatalogSelectionReader = require("@luauforge/bundled/dUN"),
	Context = {
		SduiWidgetTTITileLatencyContext = require("@luauforge/bundled/dVe"),
		CatalogSelectionReaderContext = module2
	},
	System = {
		FavoritesActiveTabStore = require("@luauforge/bundled/dTB"),
		resolveFavoritesDefaultLeafId = require("@luauforge/bundled/dTC"),
		getFavoritesSelectedCameraCategoryInfo = require("@luauforge/bundled/dVk")
	}
}
