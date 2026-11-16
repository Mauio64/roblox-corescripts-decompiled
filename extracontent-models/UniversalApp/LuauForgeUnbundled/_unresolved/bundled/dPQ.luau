local module = require("@luauforge/bundled/dPR")
local module2 = require("@luauforge/bundled/dPT")

return {
	SduiAvatarExperienceRegister = require("@luauforge/bundled/dPW"),
	registerAvatarExperienceActions = require("@luauforge/bundled/dPX"),
	registerAvatarExperienceUiComponents = require("@luauforge/bundled/dRn"),
	MarketplaceCatalogSduiSelectionBridge = module,
	useCatalogSelectionReader = require("@luauforge/bundled/dRt"),
	Context = {
		SduiWidgetTTITileLatencyContext = require("@luauforge/bundled/dRJ"),
		CatalogSelectionReaderContext = module2
	},
	System = {
		FavoritesActiveTabStore = require("@luauforge/bundled/dQl"),
		resolveFavoritesDefaultLeafId = require("@luauforge/bundled/dQm"),
		getFavoritesSelectedCameraCategoryInfo = require("@luauforge/bundled/dRP")
	}
}
