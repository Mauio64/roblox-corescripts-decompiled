local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local OmniRecommendationsContentType = require(Parent.DiscoveryTypes).OmniRecommendationsContentType
local GameInfosReducer = require(Parent.GameInfosRodux).GameInfosReducer

return {
	storeForContentType = function(p1, p2) -- line: 9
		-- upvalues: OmniRecommendationsContentType (copy), GameInfosReducer (copy)
		if p2 == OmniRecommendationsContentType.Game then
			return p1.Personalization[GameInfosReducer.key]
		end

		if p2 == OmniRecommendationsContentType.GameCoPlay then
			return p1.GameCoPlay
		end

		if p2 == OmniRecommendationsContentType.CatalogAsset then
			return p1.CatalogAssets
		end

		if p2 == OmniRecommendationsContentType.CatalogBundle then
			return p1.CatalogBundles
		end

		return nil
	end
}
