local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Modules = CoreGui.RobloxGui.Modules
local SetCollectibleMarketplaceResaleParameters = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleMarketplaceResaleParameters)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)

local function keyMapper(p1) -- line: 23
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetCollectibleMarketplaceResaleParametersKey .. tostring(p1)
end

return function(p2, s1: string, s2: string?) -- line: 27
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetCollectibleMarketplaceResaleParameters (copy), Promise (copy)
	return PerformFetch.Single(CatalogConstants.GetCollectibleMarketplaceResaleParametersKey .. tostring(s1), function(p3) -- line: 28
		-- upvalues: WebApi (copy), p2 (copy), s1 (copy), SetCollectibleMarketplaceResaleParameters (copy), s2 (copy), Promise (copy)
		return WebApi.GetCollectibleMarketplaceResaleParameters(p2, s1):andThen(function(p4) -- line: 30
			-- upvalues: p3 (copy), SetCollectibleMarketplaceResaleParameters (copy), s1 (copy), s2 (copy), Promise (copy)
			local v16 = p4 and p4.responseBody

			if v16 then
				p3:dispatch(SetCollectibleMarketplaceResaleParameters(s1, v16, s2))

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
