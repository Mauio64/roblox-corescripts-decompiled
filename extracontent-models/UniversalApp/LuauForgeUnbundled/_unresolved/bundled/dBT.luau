local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local omniRecommendationsContentType = require("@luauforge/bundled/cyO").OmniRecommendationsContentType

local addContentMetadata = require("@luauforge/bundled/dpZ").Modules.LuaApp.Actions.Games.AddContentMetadata

return Rodux.createReducer({}, {
	[addContentMetadata.name] = function(options, p2)
		local joined = options or {}

		if p2.contentMetadata[omniRecommendationsContentType.CatalogBundle] then
			joined = Cryo.Dictionary.join(
				joined,
				p2.contentMetadata[omniRecommendationsContentType.CatalogBundle]
			)
		end

		return joined
	end
})
