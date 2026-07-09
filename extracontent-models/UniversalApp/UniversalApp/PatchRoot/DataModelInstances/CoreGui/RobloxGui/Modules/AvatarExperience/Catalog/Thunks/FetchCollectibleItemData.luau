local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetCollectibleItemInfo = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleItemInfo)

return function(p1, s1: string) -- line: 10
	-- upvalues: PerformFetch (copy), WebApi (copy), SetCollectibleItemInfo (copy)
	return PerformFetch.Single(s1, function(p2) -- line: 11
		-- upvalues: WebApi (copy), p1 (copy), s1 (copy), SetCollectibleItemInfo (copy)
		return WebApi.FetchCollectibleItemDetails(p1, { s1 }):andThen(function(p3) -- line: 12
			-- upvalues: p2 (copy), SetCollectibleItemInfo (copy), s1 (copy)
			local v10 = if not p3 then nil else p3.responseBody
			local v11 = if not v10 then nil else v10[1]

			if v11 == nil then
				return
			end

			p2:dispatch(SetCollectibleItemInfo(s1, v11))
		end)
	end)
end
