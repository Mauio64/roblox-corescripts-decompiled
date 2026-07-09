local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAssetResaleData = require(Modules.AvatarExperience.Catalog.Actions.SetAssetResaleData)

local function keyMapper(p1) -- line: 14
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetAssetResalesDataKey .. tostring(p1)
end

return function(p2, p3) -- line: 18
	-- upvalues: ArgCheck (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetAssetResaleData (copy)
	return function(p4) -- line: 19
		-- upvalues: ArgCheck (copy), p3 (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), p2 (copy), SetAssetResaleData (copy)
		ArgCheck.isType(p3, "string", "FetchAssetResaleData thunk expects assetId to be a string")

		local v14 = p4:getState().AvatarExperience.Common.AssetInfos[p3]

		if v14 and v14.receivedFromResaleData then
			return Promise.resolve("We already have the asset resale data")
		end

		local Single = PerformFetch.Single
		local v16 = p3

		return Single(CatalogConstants.GetAssetResalesDataKey .. tostring(v16), function(p5) -- line: 28
			-- upvalues: WebApi (copy), p2 (copy), p3 (copy), SetAssetResaleData (copy), Promise (copy)
			return WebApi.FetchAssetResaleData(p2, p3):andThen(function(p6) -- line: 29
				-- upvalues: p5 (copy), SetAssetResaleData (copy), p3 (copy), Promise (copy)
				local v19 = p6 and p6.responseBody

				if v19 then
					p5:dispatch(SetAssetResaleData(p3, v19))

					return Promise.resolve()
				end

				return Promise.reject()
			end)
		end)(p4)
	end
end
