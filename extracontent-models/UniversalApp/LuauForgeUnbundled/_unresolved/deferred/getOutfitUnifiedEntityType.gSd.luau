local module = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")
local inventoryOutfitType = require("@luauforge/bundled/dMd").Enums.InventoryOutfitType
local marketplaceLookType = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums.MarketplaceLookType

local v5 = {
	[inventoryOutfitType.Body] = module.BundleTypeIdStrings.BodyParts,
	[inventoryOutfitType.DynamicHead] = module.BundleTypeIdStrings.DynamicHead,
	[inventoryOutfitType.Shoes] = module.BundleTypeIdStrings.Shoes,
	[inventoryOutfitType.Animations] = module.BundleTypeIdStrings.Animations
}

local set = {
	[inventoryOutfitType.PurchasedMakeup] = true,
	[inventoryOutfitType.CreatedMakeup] = true,
	[module.OutfitTypes.Makeup] = true
}

local set2 = {
	[module.OutfitTypes.Avatar] = true,
	[module.OutfitTypes.EditableAvatar] = true
}

local function getOutfitUnifiedEntityType(data)
	local inventoryType = data.inventoryType
	local outfitType = data.outfitType

	local v6 = v5[inventoryType or outfitType or ""]

	if v6 then
		return v6, nil
	end

	if set[inventoryType or ""] or set[outfitType or ""] then
		return nil, marketplaceLookType.LOOK_TYPE_MAKEUP
	end

	if not set2[outfitType or ""] then
		return nil, nil
	end

	if data.isEditable then
		return nil, marketplaceLookType.LOOK_TYPE_AVATAR
	end

	if inventoryType ~= nil then
		return module.BundleTypeIdStrings.BodyParts, nil
	end

	return nil, nil
end

return getOutfitUnifiedEntityType
