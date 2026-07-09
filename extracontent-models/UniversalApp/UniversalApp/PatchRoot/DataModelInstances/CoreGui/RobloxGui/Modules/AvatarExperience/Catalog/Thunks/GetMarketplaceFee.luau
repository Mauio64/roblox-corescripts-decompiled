local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local SetMarketplaceFee = require(Modules.AvatarExperience.Catalog.Actions.SetMarketplaceFee)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch

local function keyMapper() -- line: 12
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetMarketplaceFeeKey
end

return function(p1) -- line: 16
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetMarketplaceFee (copy), Promise (copy)
	return PerformFetch.Single(CatalogConstants.GetMarketplaceFeeKey, function(p2) -- line: 17
		-- upvalues: WebApi (copy), p1 (copy), SetMarketplaceFee (copy), Promise (copy)
		return WebApi.GetMarketplaceFee(p1):andThen(function(p3) -- line: 18
			-- upvalues: p2 (copy), SetMarketplaceFee (copy), Promise (copy)
			local v13 = p3 and p3.responseBody

			if v13 then
				p2:dispatch(SetMarketplaceFee(v13))

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
