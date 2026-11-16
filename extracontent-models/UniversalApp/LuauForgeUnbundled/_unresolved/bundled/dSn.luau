local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dSo")
local module2 = require("@luauforge/bundled/dSp")
local module3 = require("@luauforge/bundled/dSq")
local Cryo = require(CorePackages.Packages.Cryo)

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local values = {}

		for k, userAsset in p3.userAssets do
			local userAssetId = tostring(userAsset.userAssetId)
			local v6 = module3.fromSellPageAndResellers(userAsset)

			local v7 = p2[userAssetId]

			if v7 then
				values[userAssetId] = Cryo.Dictionary.join(v7, v6)
			else
				values[userAssetId] = v6
			end
		end

		return Cryo.Dictionary.join(p2, values)
	end,
	[module2.name] = function(p2, p3)
		local userAssetId = tostring(p3.userAssetId)
		local priceInRobux = p3.priceInRobux
		local v6 = module3.fromPriceInRobux(userAssetId, priceInRobux)

		local v7 = p2[userAssetId]

		if v7 then
			return Cryo.Dictionary.join(p2, {
				[userAssetId] = Cryo.Dictionary.join(v7, v6)
			})
		end

		return Cryo.Dictionary.join(p2, { [userAssetId] = v6 })
	end
})
