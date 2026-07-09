local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local OmniRecommendationsContentType = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniRecommendationsContentType
local AddContentMetadata = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.Games.AddContentMetadata

return Rodux.createReducer({}, {
	[AddContentMetadata.name] = function(t1: {[any]: any}?, p1) -- line: 17
		-- upvalues: OmniRecommendationsContentType (copy), Cryo (copy)
		local v8 = t1 or {}

		if p1.contentMetadata[OmniRecommendationsContentType.GameCoPlay] then
			v8 = Cryo.Dictionary.join(v8, p1.contentMetadata[OmniRecommendationsContentType.GameCoPlay])
		end

		return v8
	end
})
