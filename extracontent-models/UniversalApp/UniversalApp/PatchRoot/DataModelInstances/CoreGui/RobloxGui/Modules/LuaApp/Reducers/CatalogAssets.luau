local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local OmniRecommendationsContentType = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniRecommendationsContentType
local AddContentMetadata = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.Games.AddContentMetadata

return Rodux.createReducer({}, {
	[AddContentMetadata.name] = function(p1, p2) -- line: 12
		-- upvalues: OmniRecommendationsContentType (copy), Cryo (copy)
		local v8 = p1 or {}

		if p2.contentMetadata[OmniRecommendationsContentType.CatalogAsset] then
			v8 = Cryo.Dictionary.join(v8, p2.contentMetadata[OmniRecommendationsContentType.CatalogAsset])
		end

		return v8
	end
})
