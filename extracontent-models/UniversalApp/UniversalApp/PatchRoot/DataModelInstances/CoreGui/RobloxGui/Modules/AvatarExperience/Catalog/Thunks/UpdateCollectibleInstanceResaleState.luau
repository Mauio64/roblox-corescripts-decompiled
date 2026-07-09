local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local UpdateCollectibleResellableInstance = require(Modules.AvatarExperience.Catalog.Actions.UpdateCollectibleResellableInstance)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

local function keyMapper(p1) -- line: 25
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.UpdateCollectibleInstanceResaleStateKey .. tostring(p1)
end

local t1 = {
	toastMessage = "Feature.Catalog.Response.PlacedOnSaleSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.Catalog.Response.TakenOffSaleSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local function getCollectibleInstance(p2, p3, p4) -- line: 41
	local CollectiblesResellableInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances

	if CollectiblesResellableInstances[p3] then
		return CollectiblesResellableInstances[p3][p4]
	end

	return nil
end

return function(p5, s1: string, s2: string, b1: boolean, n1: number?) -- line: 48
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), Promise (copy), WebApi (copy), UpdateCollectibleResellableInstance (copy), t1 (copy), t2 (copy), SetCurrentToastMessage (copy), SetNetworkingErrorToast (copy)
	return function(p6) -- line: 55
		-- upvalues: PerformFetch (copy), s2 (copy), CatalogConstants (copy), s1 (copy), Promise (copy), WebApi (copy), p5 (copy), n1 (copy), b1 (copy), UpdateCollectibleResellableInstance (copy), t1 (copy), t2 (copy), SetCurrentToastMessage (copy), SetNetworkingErrorToast (copy)
		local Single = PerformFetch.Single
		local v28 = s2

		return Single(CatalogConstants.UpdateCollectibleInstanceResaleStateKey .. tostring(v28), function(p7) -- line: 56
			-- upvalues: s1 (copy), s2 (copy), Promise (copy), WebApi (copy), p5 (copy), n1 (copy), b1 (copy), UpdateCollectibleResellableInstance (copy), t1 (copy), t2 (copy), SetCurrentToastMessage (copy), SetNetworkingErrorToast (copy)
			local v30 = p7:getState()
			local LocalUserId = v30.LocalUserId
			local v32 = s1
			local v33 = s2
			local CollectiblesResellableInstances = v30.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
			local v35 = if not CollectiblesResellableInstances[v32] then nil else CollectiblesResellableInstances[v32][v33]

			if v35 == nil then
				return Promise.reject("Unable to find collectible instance")
			end

			return WebApi.UpdateCollectibleInstanceResaleState(p5, s1, s2, v35.collectibleProductId, n1, b1, LocalUserId):andThen(function(_) -- line: 71
				-- upvalues: p7 (copy), s1 (copy), s2 (copy), n1 (copy), b1 (copy), UpdateCollectibleResellableInstance (copy), t1 (copy), t2 (copy), SetCurrentToastMessage (copy), Promise (copy)
				local v37 = p7:getState()
				local v38 = s1
				local v39 = s2
				local CollectiblesResellableInstances2 = v37.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
				local v41 = if not CollectiblesResellableInstances2[v38] then nil else CollectiblesResellableInstances2[v38][v39]

				if v41 then
					v41.price = n1 or v41.price
					v41.saleState = not b1 and "OffSale" or "OnSale"
					p7:dispatch(UpdateCollectibleResellableInstance(s1, s2, v41))
				end

				local v42 = if not b1 then t2 else t1

				p7:dispatch(SetCurrentToastMessage(v42))

				return Promise.resolve()
			end, function(p9) -- line: 86
				-- upvalues: p7 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p7:dispatch(SetNetworkingErrorToast(p9))

				return Promise.reject(p9)
			end)
		end)(p6)
	end
end
