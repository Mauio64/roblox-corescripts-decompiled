local omniRecommendationsContentType = require("@luauforge/bundled/dtp").OmniRecommendationsContentType
local gameInfosReducer = require("@luauforge/bundled/dto").GameInfosReducer

return {
	storeForContentType = function(data, p2)
		if p2 == omniRecommendationsContentType.Game then
			return data.Personalization[gameInfosReducer.key]
		end

		if p2 == omniRecommendationsContentType.GameCoPlay then
			return data.GameCoPlay
		end

		if p2 == omniRecommendationsContentType.CatalogAsset then
			return data.CatalogAssets
		end

		if p2 == omniRecommendationsContentType.CatalogBundle then
			return data.CatalogBundles
		end

		return nil
	end
}
