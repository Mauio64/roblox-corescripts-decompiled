local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAssetResellersList = require(Modules.AvatarExperience.Catalog.Actions.SetAssetResellersList)
local SetAssetLowestPrice = require(Modules.AvatarExperience.Catalog.Actions.SetAssetLowestPrice)
local SetUserAssetsFromSellPageAndResellers = require(Modules.AvatarExperience.Catalog.Actions.SetUserAssetsFromSellPageAndResellers)
local AppendAssetResellersList = require(Modules.AvatarExperience.Catalog.Actions.AppendAssetResellersList)
local SetResellerCursor = require(Modules.AvatarExperience.Catalog.Actions.SetResellerCursor)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)

local function keyMapper(p1) -- line: 22
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetResellersKey .. tostring(p1)
end

return function(p2, p3, p4, p5, p6) -- line: 26
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), SetResellerCursor (copy), SetUserAssetsFromSellPageAndResellers (copy), AppendAssetResellersList (copy), SetAssetResellersList (copy), SetAssetLowestPrice (copy), Promise (copy), SetNetworkingErrorToast (copy)
	ArgCheck.isType(p3, "string", "GetResellers thunk expects assetId to be a string")

	return PerformFetch.Single(CatalogConstants.GetResellersKey .. tostring(p3), function(p7) -- line: 28
		-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), SetResellerCursor (copy), SetUserAssetsFromSellPageAndResellers (copy), AppendAssetResellersList (copy), SetAssetResellersList (copy), p6 (copy), SetAssetLowestPrice (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return WebApi.FetchAssetResellers(p2, p3, p4, p5):andThen(function(p8) -- line: 29
			-- upvalues: p7 (copy), SetResellerCursor (copy), SetUserAssetsFromSellPageAndResellers (copy), p4 (copy), AppendAssetResellersList (copy), p3 (copy), SetAssetResellersList (copy), p6 (copy), SetAssetLowestPrice (copy), Promise (copy), SetNetworkingErrorToast (copy)
			local v23 = p8 and (p8.responseBody and p8.responseBody.data)

			if v23 then
				if #v23 > 0 then
					p7:dispatch(SetResellerCursor(p8.responseBody.nextPageCursor))

					local t1 = {}

					for _, v26 in v23 do
						table.insert(t1, (tostring(v26.userAssetId)))
					end

					p7:dispatch(SetUserAssetsFromSellPageAndResellers(v23))

					if p4 then
						p7:dispatch(AppendAssetResellersList(p3, t1))
					else
						p7:dispatch(SetAssetResellersList(p3, t1))
					end

					if p6 then
						p7:dispatch(SetAssetLowestPrice(p3, v23[1].price))
					end

					return Promise.resolve()
				end

				return Promise.resolve()
			end

			p7:dispatch(SetNetworkingErrorToast())

			return Promise.reject()
		end)
	end)
end
