local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResellableInstances)

local function keyMapper(p1) -- line: 19
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchCollectibleResellableInstancesKey .. tostring(p1)
end

return function(p2, p3, p4) -- line: 23
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetCollectibleResellableInstances (copy), Promise (copy)
	ArgCheck.isType(p3, "string", "FetchCollectibleResellableInstances thunk expects collectibleItemId")
	ArgCheck.isType(p4, "string", "FetchCollectibleResellableInstances thunk expects userId")

	return PerformFetch.Single(CatalogConstants.FetchCollectibleResellableInstancesKey .. tostring(p3), function(p5) -- line: 27
		-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), SetCollectibleResellableInstances (copy), Promise (copy)
		return WebApi.FetchCollectibleResellableInstances(p2, p3, p4):andThen(function(p6) -- line: 29
			-- upvalues: p5 (copy), SetCollectibleResellableInstances (copy), p3 (copy), Promise (copy)
			local v16 = p6 and (p6.responseBody and p6.responseBody.itemInstances)

			if v16 then
				p5:dispatch(SetCollectibleResellableInstances(p3, v16))

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
