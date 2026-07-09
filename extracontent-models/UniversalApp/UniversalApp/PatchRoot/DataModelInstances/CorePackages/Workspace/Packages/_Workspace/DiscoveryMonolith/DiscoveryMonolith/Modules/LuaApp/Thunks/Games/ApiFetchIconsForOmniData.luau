local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local PromiseUtilities = require(DiscoveryMonolithParent.AppCommonLib).Utils.PromiseUtilities
local OmniRecommendationsContentType = require(DiscoveryMonolithParent.DiscoveryTypes).OmniRecommendationsContentType
local Constants = require(DiscoveryMonolithParent.UserLib).Utils.Constants
local Modules = DiscoveryMonolith.Modules
local ApiPreloadContentProviderThumbnail = require(Modules.LuaApp.Thunks.ApiPreloadContentProviderThumbnail)

return function(_, p2) -- line: 24
	-- upvalues: OmniRecommendationsContentType (copy), Constants (copy), ApiPreloadContentProviderThumbnail (copy), PromiseUtilities (copy)
	return function(p3) -- line: 25
		-- upvalues: p2 (copy), OmniRecommendationsContentType (copy), Constants (copy), ApiPreloadContentProviderThumbnail (copy), PromiseUtilities (copy)
		local t1 = {}

		for k, v in pairs(p2) do
			local t2 = {}

			for k2, _ in pairs(v) do
				table.insert(t2, k2)
			end

			local v18 = if k ~= OmniRecommendationsContentType.CatalogAsset then if k ~= OmniRecommendationsContentType.CatalogBundle then nil else Constants.RbxthumbTypes.BundleThumbnail else Constants.RbxthumbTypes.Asset

			if v18 then
				table.insert(t1, p3:dispatch(ApiPreloadContentProviderThumbnail(t2, v18, 150)))
			end
		end

		return PromiseUtilities.Batch(t1)
	end
end
