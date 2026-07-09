local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetCollectibleResaleData = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResaleData)

local function keyMapper(p1) -- line: 18
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchCollectibleResaleDataKey .. tostring(p1)
end

return function(p2, p3) -- line: 22
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetCollectibleResaleData (copy), Promise (copy)
	ArgCheck.isType(p3, "string", "FetchCollectibleResaleData thunk expects collectibleItemId")

	return PerformFetch.Single(CatalogConstants.FetchCollectibleResaleDataKey .. tostring(p3), function(p4) -- line: 24
		-- upvalues: WebApi (copy), p2 (copy), p3 (copy), SetCollectibleResaleData (copy), Promise (copy)
		return WebApi.FetchCollectibleResaleData(p2, p3):andThen(function(p5) -- line: 25
			-- upvalues: p4 (copy), SetCollectibleResaleData (copy), p3 (copy), Promise (copy)
			local v15 = p5 and p5.responseBody

			if v15 then
				p4:dispatch(SetCollectibleResaleData(p3, v15))

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
