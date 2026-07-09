local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetUserAssetsFromSellPageAndResellers = require(Modules.AvatarExperience.Catalog.Actions.SetUserAssetsFromSellPageAndResellers)
local UpdateUserAssetPrice = require(Modules.AvatarExperience.Catalog.Actions.UpdateUserAssetPrice)
local UserAssetModel = require(Modules.AvatarExperience.Catalog.Models.UserAssetModel)
local Cryo = require(CorePackages.Packages.Cryo)

return Rodux.createReducer({}, {
	[SetUserAssetsFromSellPageAndResellers.name] = function(p1, p2) -- line: 19
		-- upvalues: UserAssetModel (copy), Cryo (copy)
		local t1 = {}

		for _, v12 in p2.userAssets do
			local str = tostring(v12.userAssetId)
			local v14 = UserAssetModel.fromSellPageAndResellers(v12)
			local v15 = p1[str]

			if v15 then
				t1[str] = Cryo.Dictionary.join(v15, v14)
			else
				t1[str] = v14
			end
		end

		return Cryo.Dictionary.join(p1, t1)
	end,
	[UpdateUserAssetPrice.name] = function(p3, p4) -- line: 41
		-- upvalues: UserAssetModel (copy), Cryo (copy)
		local str = tostring(p4.userAssetId)
		local priceInRobux = p4.priceInRobux
		local v20 = UserAssetModel.fromPriceInRobux(str, priceInRobux)
		local v21 = p3[str]

		if v21 then
			return Cryo.Dictionary.join(p3, {
				[str] = Cryo.Dictionary.join(v21, v20)
			})
		end

		return Cryo.Dictionary.join(p3, {
			[str] = v20
		})
	end
})
