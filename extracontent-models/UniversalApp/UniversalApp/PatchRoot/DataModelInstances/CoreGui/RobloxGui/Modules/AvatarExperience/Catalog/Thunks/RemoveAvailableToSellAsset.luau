local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = CoreGui.RobloxGui.Modules
local UpdateUserAssetPrice = require(Modules.AvatarExperience.Catalog.Actions.UpdateUserAssetPrice)
local AddCurrentlySellingAsset = require(Modules.AvatarExperience.Catalog.Actions.AddCurrentlySellingAsset)
local RemoveAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Actions.RemoveAvailableToSellAsset)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

local function keyMapper(p1) -- line: 21
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.RemoveAvailableToSellAssetKey .. tostring(p1)
end

local t1 = {
	toastMessage = "Feature.Catalog.Label.SellSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

return function(p2, p3, p4, p5) -- line: 31
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), UpdateUserAssetPrice (copy), RemoveAvailableToSellAsset (copy), AddCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return function(p6) -- line: 32
		-- upvalues: ArgCheck (copy), p3 (copy), p4 (copy), p5 (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), p2 (copy), UpdateUserAssetPrice (copy), RemoveAvailableToSellAsset (copy), AddCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
		ArgCheck.isType(p3, "string", "RemoveAvailableToSellAsset thunk expects assetId to be a string")
		ArgCheck.isType(p4, "string", "RemoveAvailableToSellAsset thunk expects userAssetId to be a string")
		ArgCheck.isType(p5, "number", "RemoveAvailableToSellAsset thunk expects priceInRobux to be a number")

		local Single = PerformFetch.Single
		local v24 = p4

		return Single(CatalogConstants.RemoveAvailableToSellAssetKey .. tostring(v24), function(p7) -- line: 37
			-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), UpdateUserAssetPrice (copy), RemoveAvailableToSellAsset (copy), AddCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
			return WebApi.RemoveAvailableToSell(p2, p3, p4, p5):andThen(function(_) -- line: 39
				-- upvalues: p7 (copy), UpdateUserAssetPrice (copy), p4 (copy), p5 (copy), RemoveAvailableToSellAsset (copy), p3 (copy), AddCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy)
				p7:dispatch(UpdateUserAssetPrice(p4, p5))
				p7:dispatch(RemoveAvailableToSellAsset(p3, p4))
				p7:dispatch(AddCurrentlySellingAsset(p3, p4))
				p7:dispatch(SetCurrentToastMessage(t1))

				return Promise.resolve()
			end, function(p9) -- line: 47
				-- upvalues: p7 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p7:dispatch(SetNetworkingErrorToast(p9))

				return Promise.reject(p9)
			end)
		end)(p6)
	end
end
