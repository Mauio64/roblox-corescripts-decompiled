local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local FetchCollectibleItemDataBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchCollectibleItemDataBatchedSuccess

local function getFetchKey(t1: {[any]: any}) -- line: 13
	return "BatchCollectibles-" .. table.concat(t1, ",")
end

return function(p1, t2: {[any]: any}) -- line: 19
	-- upvalues: PerformFetch (copy), WebApi (copy), FetchCollectibleItemDataBatchedSuccess (copy)
	local v11 = "BatchCollectibles-" .. table.concat(t2, ",")

	return PerformFetch.Single(v11, function(p2) -- line: 21
		-- upvalues: WebApi (copy), p1 (copy), t2 (copy), FetchCollectibleItemDataBatchedSuccess (copy)
		return WebApi.FetchCollectibleItemDetails(p1, t2):andThen(function(p3) -- line: 22
			-- upvalues: p2 (copy), FetchCollectibleItemDataBatchedSuccess (copy)
			local v14 = if not p3 then {} else p3.responseBody

			p2:dispatch(FetchCollectibleItemDataBatchedSuccess({
				collectibleItemData = v14
			}))
		end)
	end)
end
