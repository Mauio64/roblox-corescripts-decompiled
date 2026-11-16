local promiseUtilities = require("@luauforge/bundled/dqY").Utils.PromiseUtilities
local omniRecommendationsContentType = require("@luauforge/bundled/dqn").OmniRecommendationsContentType
local constants = require("@game/CorePackages/Workspace/Packages/UserLib").Utils.Constants

local module = require("@luauforge/bundled/drF")

return function(p2, items)
	return function(object)
		local v5 = {}

		for k, item in pairs(items) do
			local v6 = {}

			for k2, v7 in pairs(item) do
				table.insert(v6, k2)
			end

			local v7

			if k == omniRecommendationsContentType.CatalogAsset then
				v7 = constants.RbxthumbTypes.Asset
			elseif k == omniRecommendationsContentType.CatalogBundle then
				v7 = constants.RbxthumbTypes.BundleThumbnail
			end

			if v7 then
				table.insert(v5, object:dispatch(module(v6, v7, 150)))
			end
		end

		return promiseUtilities.Batch(v5)
	end
end
