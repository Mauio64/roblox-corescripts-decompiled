local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetAvailableToSellAssetsFromFetchSellData = require(Modules.AvatarExperience.Catalog.Actions.SetAvailableToSellAssetsFromFetchSellData)
local AddAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Actions.AddAvailableToSellAsset)
local RemoveAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Actions.RemoveAvailableToSellAsset)
local Cryo = require(CorePackages.Packages.Cryo)

return Rodux.createReducer({}, {
	[SetAvailableToSellAssetsFromFetchSellData.name] = function(p1, p2) -- line: 21
		-- upvalues: Cryo (copy)
		local assetId = p2.assetId
		local userAssetIdList = p2.userAssetIdList

		return Cryo.Dictionary.join(p1, {
			[assetId] = userAssetIdList
		})
	end,
	[AddAvailableToSellAsset.name] = function(p3, p4) -- line: 34
		-- upvalues: Cryo (copy)
		local assetId = p4.assetId
		local t1 = { p4.userAssetId }
		local v16 = p3[assetId]

		if v16 then
			t1 = Cryo.List.join(v16, t1)
		end

		return Cryo.Dictionary.join(p3, {
			[assetId] = t1
		})
	end,
	[RemoveAvailableToSellAsset.name] = function(p5, p6) -- line: 53
		-- upvalues: Cryo (copy)
		local assetId = p6.assetId
		local v20 = p5[assetId]

		if not v20 then
			return p5
		end

		local v21 = Cryo.List.removeValue(v20, p6.userAssetId)

		return Cryo.Dictionary.join(p5, {
			[assetId] = v21
		})
	end
})
