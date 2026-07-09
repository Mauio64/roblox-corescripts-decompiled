local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAssetVersionData = require(Modules.AvatarExperience.Catalog.Actions.SetAssetVersionData)

local function keyMapper(p1) -- line: 21
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchAssetVersionDataKey .. tostring(p1)
end

return function(p2, p3) -- line: 25
	-- upvalues: ArgCheck (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetAssetVersionData (copy)
	return function(p4) -- line: 26
		-- upvalues: ArgCheck (copy), p3 (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), p2 (copy), SetAssetVersionData (copy)
		ArgCheck.isType(p3, "string", "FetchAssetVersionData thunk expects assetId to be a string")

		local v14 = p4:getState().AvatarExperience.Common.AssetInfos[p3]

		if v14 and v14.receivedFromVersionData then
			return Promise.resolve("We already have the asset version data")
		end

		local Single = PerformFetch.Single
		local v16 = p3

		return Single(CatalogConstants.FetchAssetVersionDataKey .. tostring(v16), function(p5) -- line: 35
			-- upvalues: WebApi (copy), p2 (copy), p3 (copy), SetAssetVersionData (copy), Promise (copy)
			return WebApi.FetchAssetVersionData(p2, p3):andThen(function(p6) -- line: 36
				-- upvalues: p5 (copy), SetAssetVersionData (copy), p3 (copy), Promise (copy)
				local v19 = p6 and p6.responseBody

				if v19 then
					p5:dispatch(SetAssetVersionData(p3, v19))

					return Promise.resolve()
				end

				return Promise.reject()
			end)
		end)(p4)
	end
end
