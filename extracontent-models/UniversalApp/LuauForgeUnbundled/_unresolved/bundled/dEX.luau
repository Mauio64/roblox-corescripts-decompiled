local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local omniRecommendationsContentType = require("@luauforge/bundled/cBc").OmniRecommendationsContentType

local addContentMetadata = require("@luauforge/bundled/dtb").Modules.LuaApp.Actions.Games.AddContentMetadata

return Rodux.createReducer({}, {
	[addContentMetadata.name] = function(options, p2)
		local joined = options or {}

		if p2.contentMetadata[omniRecommendationsContentType.CatalogAsset] then
			joined = Cryo.Dictionary.join(
				joined,
				p2.contentMetadata[omniRecommendationsContentType.CatalogAsset]
			)
		end

		return joined
	end
})
