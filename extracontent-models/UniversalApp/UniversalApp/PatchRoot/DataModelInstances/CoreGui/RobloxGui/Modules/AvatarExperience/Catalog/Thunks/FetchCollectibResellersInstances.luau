local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetCollectibleResellersInstances = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResellersInstances)
local AppendCollectibleResellersInstances = require(Modules.AvatarExperience.Catalog.Actions.AppendCollectibleResellersInstances)
local SetResellerCursor = require(Modules.AvatarExperience.Catalog.Actions.SetResellerCursor)

local function keyMapper(p1) -- line: 22
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetResellersKey .. tostring(p1)
end

return function(p2, p3, p4, p5) -- line: 26
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetResellerCursor (copy), AppendCollectibleResellersInstances (copy), SetCollectibleResellersInstances (copy), Promise (copy)
	ArgCheck.isType(p3, "string", "FetchCollectibResellersInstances thunk expects collectibleItemId")

	return PerformFetch.Single(CatalogConstants.GetResellersKey .. tostring(p3), function(p6) -- line: 29
		-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), SetResellerCursor (copy), AppendCollectibleResellersInstances (copy), SetCollectibleResellersInstances (copy), Promise (copy)
		return WebApi.GetCollectibleResellers(p2, p3, p4, p5):andThen(function(p7) -- line: 31
			-- upvalues: p6 (copy), SetResellerCursor (copy), p4 (copy), AppendCollectibleResellersInstances (copy), p3 (copy), SetCollectibleResellersInstances (copy), Promise (copy)
			local v19 = p7 and (p7.responseBody and p7.responseBody.data)

			if v19 then
				local nextPageCursor = p7.responseBody.nextPageCursor

				if nextPageCursor and nextPageCursor == "" then
					nextPageCursor = nil
				end

				p6:dispatch(SetResellerCursor(nextPageCursor))

				if p4 then
					p6:dispatch(AppendCollectibleResellersInstances(p3, v19))
				else
					p6:dispatch(SetCollectibleResellersInstances(p3, v19))
				end

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
