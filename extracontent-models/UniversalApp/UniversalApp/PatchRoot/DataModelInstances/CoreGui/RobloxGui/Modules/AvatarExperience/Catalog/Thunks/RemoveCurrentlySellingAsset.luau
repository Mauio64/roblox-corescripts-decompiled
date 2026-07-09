local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = CoreGui.RobloxGui.Modules
local UpdateUserAssetPrice = require(Modules.AvatarExperience.Catalog.Actions.UpdateUserAssetPrice)
local RemoveCurrentlySellingAsset = require(Modules.AvatarExperience.Catalog.Actions.RemoveCurrentlySellingAsset)
local AddAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Actions.AddAvailableToSellAsset)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

local function keyMapper(p1) -- line: 21
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.RemoveCurrentlySellingAssetKey .. tostring(p1)
end

local t1 = {
	toastMessage = "Feature.Catalog.Heading.ItemRemoved",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

return function(p2, p3, p4, p5) -- line: 31
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), UpdateUserAssetPrice (copy), AddAvailableToSellAsset (copy), RemoveCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return function(p6) -- line: 32
		-- upvalues: ArgCheck (copy), p3 (copy), p5 (copy), p4 (copy), PerformFetch (copy), CatalogConstants (copy), WebApi (copy), p2 (copy), UpdateUserAssetPrice (copy), AddAvailableToSellAsset (copy), RemoveCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
		ArgCheck.isType(p3, "string", "RemoveCurrentlySellingAsset thunk expects assetId to be a string")
		ArgCheck.isType(p5, "string", "RemoveCurrentlySellingAsset thunk expects userId to be a string")
		ArgCheck.isType(p4, "string", "RemoveCurrentlySellingAsset thunk expects userAssetId to be a string")

		local Single = PerformFetch.Single
		local v24 = p4

		return Single(CatalogConstants.RemoveCurrentlySellingAssetKey .. tostring(v24), function(p7) -- line: 37
			-- upvalues: WebApi (copy), p2 (copy), p3 (copy), p4 (copy), UpdateUserAssetPrice (copy), AddAvailableToSellAsset (copy), RemoveCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy), SetNetworkingErrorToast (copy)
			return WebApi.RemoveCurrentlySellingAsset(p2, p3, p4):andThen(function(_) -- line: 38
				-- upvalues: p7 (copy), UpdateUserAssetPrice (copy), p4 (copy), AddAvailableToSellAsset (copy), p3 (copy), RemoveCurrentlySellingAsset (copy), SetCurrentToastMessage (copy), t1 (copy), Promise (copy)
				p7:dispatch(UpdateUserAssetPrice(p4, nil))
				p7:dispatch(AddAvailableToSellAsset(p3, p4))
				p7:dispatch(RemoveCurrentlySellingAsset(p3, p4))
				p7:dispatch(SetCurrentToastMessage(t1))

				return Promise.resolve()
			end, function(p9) -- line: 46
				-- upvalues: p7 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p7:dispatch(SetNetworkingErrorToast(p9))

				return Promise.reject(p9)
			end)
		end)(p6)
	end
end
