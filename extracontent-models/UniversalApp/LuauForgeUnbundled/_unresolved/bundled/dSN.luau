local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dKU")

local SetTryingOnInfo = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetTryingOnInfo")
local module2 = require("@luauforge/bundled/dRp")
local module3 = require("@luauforge/bundled/dRq")
local module4 = require("@luauforge/bundled/dRw")
local module5 = require("@luauforge/bundled/dPN")

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

return Rodux.createReducer({ grantedAssetsByType = {}, grantedOutfitsByType = {} }, {
	[SetTryingOnInfo.name] = function(p2, p3)
		local v6 = p2.grantedAssetsByType[tostring(p3.assetTypeId)] or {}

		local v7 = Cryo.Dictionary.join(p2.grantedAssetsByType, {
			[tostring(p3.assetTypeId)] = Cryo.List.join({ (tostring(p3.assetId)) }, v6)
		})

		return Cryo.Dictionary.join(p2, { grantedAssetsByType = v7 })
	end,
	[module2.name] = function(p2, p3)
		local v6 = p2.grantedAssetsByType[tostring(p3.assetTypeId)] or {}

		local v8 = Cryo.Dictionary.join(p2.grantedAssetsByType, {
			[tostring(p3.assetTypeId)] = Cryo.List.removeValue(v6, (tostring(p3.assetId)))
		})

		return Cryo.Dictionary.join(p2, { grantedAssetsByType = v8 })
	end,
	[module3.name] = function(p2, data)
		local v6 = data.outfitType

		if
			fFlagAXMigrateOutfitsToUserInventory
			and data.outfitType == module5.OutfitTypes.Makeup
			and data.isEditable == false
		then
			v6 = module5.NonEditableMakeupGrantKey
		end

		local v7 = p2.grantedOutfitsByType[v6] or {}

		local v8 = Cryo.Dictionary.join(p2.grantedOutfitsByType, {
			[tostring(v6)] = Cryo.List.join({ (tostring(data.outfitId)) }, v7)
		})

		return Cryo.Dictionary.join(p2, { grantedOutfitsByType = v8 })
	end,
	[module4.name] = function(p2, p3)
		local v6 = {}

		for k, grantedOutfit in p2.grantedOutfitsByType do
			v6[k] = Cryo.List.removeValue(grantedOutfit, (tostring(p3.outfitId)))
		end

		return Cryo.Dictionary.join(p2, { grantedOutfitsByType = v6 })
	end
})
