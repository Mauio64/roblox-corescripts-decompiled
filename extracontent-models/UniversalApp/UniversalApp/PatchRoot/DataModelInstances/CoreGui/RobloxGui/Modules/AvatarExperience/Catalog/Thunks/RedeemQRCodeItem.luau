local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local SetAssetOwned = require(Modules.AvatarExperience.Common.Actions.SetAssetOwned)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local t1 = {
	HttpError = Enum.HttpError.OK
}
local t2 = {
	toastMessage = "Feature.Catalog.Label.Redeemed",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t3 = {
	toastMessage = "Feature.Catalog.Label.NotAvailable",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t4 = {
	toastMessage = "Feature.Catalog.Label.AlreadyOwned",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function redeemQRCodeItemKeyMapper(p1) -- line: 39
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.RedeemQRCodeItemKey .. tostring(p1)
end

return function(p2, p3, p4, p5) -- line: 44
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), FetchAssetOrBundleInfo (copy), ItemData (copy), SetCurrentToastMessage (copy), t4 (copy), Promise (copy), WebApi (copy), SetAssetOwned (copy), t2 (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy), t3 (copy)
	return PerformFetch.Single(CatalogConstants.RedeemQRCodeItemKey .. tostring(p4), function(p6) -- line: 45
		-- upvalues: FetchAssetOrBundleInfo (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), ItemData (copy), SetCurrentToastMessage (copy), t4 (copy), Promise (copy), WebApi (copy), SetAssetOwned (copy), t2 (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy), t3 (copy)
		return p6:dispatch(FetchAssetOrBundleInfo(p2, p3, p4, p5)):andThen(function() -- line: 46
			-- upvalues: ItemData (copy), p6 (copy), p4 (copy), p5 (copy), SetCurrentToastMessage (copy), t4 (copy), Promise (copy), WebApi (copy), p2 (copy), SetAssetOwned (copy), t2 (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy), t3 (copy)
			local v25 = ItemData(p6:getState().AvatarExperience.Common, p4, p5)

			if v25 and v25.isOwned then
				p6:dispatch(SetCurrentToastMessage(t4))

				return Promise.resolve()
			end

			return WebApi.RedeemQRCodeItem(p2, p4):andThen(function(p7) -- line: 55
				-- upvalues: p6 (copy), SetAssetOwned (copy), p4 (copy), SetCurrentToastMessage (copy), t2 (copy), Promise (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy)
				local responseBody = p7.responseBody

				if type(responseBody) == "table" and responseBody.success == true then
					p6:dispatch(SetAssetOwned(p4, true))
					p6:dispatch(SetCurrentToastMessage(t2))

					return Promise.resolve()
				end

				local v28 = t1

				Logging.warn("Response from RedeemQRCodeItem is malformed!")
				p6:dispatch(SetNetworkingErrorToast(v28))

				return Promise.reject(v28)
			end, function(p8) -- line: 67
				-- upvalues: t1 (copy), p6 (copy), SetCurrentToastMessage (copy), t3 (copy), Promise (copy)
				if type(p8) ~= "table" or p8.HttpError == nil then
					p8 = t1
				end

				p6:dispatch(SetCurrentToastMessage(t3))

				return Promise.reject(p8)
			end)
		end)
	end)
end
