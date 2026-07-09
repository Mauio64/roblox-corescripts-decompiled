local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAvailableToSellAssetsFromFetchSellData = require(Modules.AvatarExperience.Catalog.Actions.SetAvailableToSellAssetsFromFetchSellData)
local SetCurrentlySellingAssetsFromFetchSellData = require(Modules.AvatarExperience.Catalog.Actions.SetCurrentlySellingAssetsFromFetchSellData)
local SetUserAssetsFromSellPageAndResellers = require(Modules.AvatarExperience.Catalog.Actions.SetUserAssetsFromSellPageAndResellers)

local function keyMapper(p1) -- line: 20
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetSellPageDataKey .. tostring(p1)
end

return function(p2, p3, p4) -- line: 24
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetUserAssetsFromSellPageAndResellers (copy), SetAvailableToSellAssetsFromFetchSellData (copy), SetCurrentlySellingAssetsFromFetchSellData (copy), Promise (copy)
	ArgCheck.isType(p3, "string", "FetchSellPageData thunk expects itemId to be a string")
	ArgCheck.isType(p4, "string", "FetchSellPageData thunk expects userId to be a string")

	return PerformFetch.Single(CatalogConstants.GetSellPageDataKey .. tostring(p3), function(p5) -- line: 28
		-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), SetUserAssetsFromSellPageAndResellers (copy), SetAvailableToSellAssetsFromFetchSellData (copy), SetCurrentlySellingAssetsFromFetchSellData (copy), Promise (copy)
		return WebApi.FetchSellPageData(p2, p3, p4):andThen(function(p6) -- line: 29
			-- upvalues: p5 (copy), SetUserAssetsFromSellPageAndResellers (copy), SetAvailableToSellAssetsFromFetchSellData (copy), p3 (copy), SetCurrentlySellingAssetsFromFetchSellData (copy), Promise (copy)
			local v18 = p6 and (p6.responseBody and p6.responseBody.data)

			if v18 then
				local t1 = {}
				local t2 = {}

				for _, v22 in v18 do
					local str = tostring(v22.userAssetId)

					if v22.price then
						table.insert(t2, str)
					else
						table.insert(t1, str)
					end
				end

				p5:dispatch(SetUserAssetsFromSellPageAndResellers(v18))
				p5:dispatch(SetAvailableToSellAssetsFromFetchSellData(p3, t1))
				p5:dispatch(SetCurrentlySellingAssetsFromFetchSellData(p3, t2))

				return Promise.resolve()
			end

			return Promise.reject()
		end)
	end)
end
