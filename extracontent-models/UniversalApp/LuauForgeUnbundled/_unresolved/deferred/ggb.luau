local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dNs")
local module2 = require("@luauforge/bundled/dME")
require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module4 = require("@luauforge/bundled/dCh")
local module5 = require("@luauforge/bundled/ecW")

local module6 = require("@luauforge/bundled/dwB")

local function keyMapper(p2)
	return module2.UpdateCollectibleInstanceResaleStateKey .. tostring(p2)
end

local v5 = {
	toastMessage = "Feature.Catalog.Response.PlacedOnSaleSuccess",
	isLocalized = false,
	toastType = module6.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.Catalog.Response.TakenOffSaleSuccess",
	isLocalized = false,
	toastType = module6.SuccessConfirmation
}

local function getCollectibleInstance(p2, p3, p4)
	local collectiblesResellableInstances = p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances

	if collectiblesResellableInstances[p3] then
		return collectiblesResellableInstances[p3][p4]
	end

	return nil
end

return function(p2, p3, p4, p5, p6)
	return function(p7)
		return performFetch.Single(
			module2.UpdateCollectibleInstanceResaleStateKey .. tostring(p4),
			function(object)
				local state = object:getState()
				local localUserId = state.LocalUserId
				local v8 = p3
				local v9 = p4
				local collectiblesResellableInstances = state.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
				local v10

				if collectiblesResellableInstances[v8] then
					v10 = collectiblesResellableInstances[v8][v9]
				end

				if v10 == nil then
					return Promise.reject("Unable to find collectible instance")
				end

				return GetExperienceSourceLanguage.UpdateCollectibleInstanceResaleState(
					p2,
					p3,
					p4,
					v10.collectibleProductId,
					p6,
					p5,
					localUserId
				):andThen(
					function(p8)
						local v11 = p3
						local v12 = p4
						local collectiblesResellableInstances2 = object:getState().AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
						local v13

						if collectiblesResellableInstances2[v11] then
							v13 = collectiblesResellableInstances2[v11][v12]
						end

						if v13 then
							v13.price = p6 or v13.price
							v13.saleState = p5 and "OnSale" or "OffSale"
							object:dispatch(module(p3, p4, v13))
						end

						object:dispatch(module4(if p5 then v5 else v6))

						return Promise.resolve()
					end,
					function(p8)
						object:dispatch(module5(p8))
						return Promise.reject(p8)
					end
				)
			end
		)(p7)
	end
end
