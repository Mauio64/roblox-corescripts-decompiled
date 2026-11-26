local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceCommon")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceModel")
local ASSET_TYPE_ID_STRING_TO_NAME = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_NAME
local ASSET_TYPE_NAME_TO_ID_STRING = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING
local inventoryOutfitTypeToInventoryTypeId = AvatarExperienceModel.Constants.InventoryOutfitTypeToInventoryTypeId
local inventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType
local InventorySearchItemType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySearchItemType")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")

local set = {
	[ASSET_TYPE_NAME_TO_ID_STRING.Head] = true,
	[ASSET_TYPE_NAME_TO_ID_STRING.Face] = true
}

local v5 = {}

for k, v6 in ASSET_TYPE_ID_STRING_TO_NAME do
	if not set[k] then
		v5[tonumber(k)] = v6
	end
end

local v6 = {}

for k, v7 in inventoryOutfitTypeToInventoryTypeId do
	v6[v7] = k
end

local v7 = {
	Enum.AvatarAssetType.DynamicHead,
	Enum.AvatarAssetType.MoodAnimation,
	Enum.AvatarAssetType.EyebrowAccessory,
	Enum.AvatarAssetType.EyelashAccessory,
	Enum.AvatarAssetType.Torso,
	Enum.AvatarAssetType.LeftArm,
	Enum.AvatarAssetType.RightArm,
	Enum.AvatarAssetType.LeftLeg,
	Enum.AvatarAssetType.RightLeg,
	Enum.AvatarAssetType.ClimbAnimation,
	Enum.AvatarAssetType.FallAnimation,
	Enum.AvatarAssetType.IdleAnimation,
	Enum.AvatarAssetType.JumpAnimation,
	Enum.AvatarAssetType.RunAnimation,
	Enum.AvatarAssetType.SwimAnimation,
	Enum.AvatarAssetType.WalkAnimation,
	Enum.AvatarAssetType.LeftShoeAccessory,
	Enum.AvatarAssetType.RightShoeAccessory,
	Enum.AvatarAssetType.EmoteAnimation
}

local set2 = {
	[inventoryOutfitType.Body] = true,
	[inventoryOutfitType.DynamicHead] = true,
	[inventoryOutfitType.Shoes] = true,
	[inventoryOutfitType.Animations] = true
}

local set3 = {}

for k, v8 in v7 do
	set3[v8.Value] = true
end

local v8 = {}

for k in v5 do
	if not set3[k] then
		table.insert(v8, k)
	end
end

table.sort(v8)

local v9 = {}

for k, v10 in inventoryOutfitTypeToInventoryTypeId do
	if set2[k] then
		table.insert(v9, v10)
	end
end

table.sort(v9)

local v10 = {}

for k, v11 in v8 do
	table.insert(v10, { itemType = InventorySearchItemType.Asset, itemSubType = v11 })
end

for k, v11 in v9 do
	table.insert(v10, { itemType = InventorySearchItemType.Outfit, itemSubType = v11 })
end

return {
	KeyPrefix = "InventorySearch:",
	MaxPageLimit = 500,
	AssetSubtypes = v5,
	OutfitSubtypes = v6,
	SearchableSubtypesByItemType = { [InventorySearchItemType.Asset] = v5, [InventorySearchItemType.Outfit] = v6 },
	AllTabItemCategories = v10
}
