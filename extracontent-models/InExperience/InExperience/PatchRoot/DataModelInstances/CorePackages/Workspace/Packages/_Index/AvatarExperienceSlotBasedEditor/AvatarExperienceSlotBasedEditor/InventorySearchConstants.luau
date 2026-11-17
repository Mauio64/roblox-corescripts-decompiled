local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local parent = AvatarExperienceSlotBasedEditor.Parent
local AXCommon = require(parent.AXCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ASSET_TYPE_ID_STRING_TO_NAME = AXCommon.Constants.ASSET_TYPE_ID_STRING_TO_NAME
local ASSET_TYPE_NAME_TO_ID_STRING = AXCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING
local InventoryOutfitTypeToInventoryTypeId = AvatarExperienceModel.Constants.InventoryOutfitTypeToInventoryTypeId
local InventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType
local InventorySearchItemType = require(AvatarExperienceSlotBasedEditor.Enums.InventorySearchItemType)
require(AvatarExperienceSlotBasedEditor.Types)

local set = {
	[ASSET_TYPE_NAME_TO_ID_STRING.Head] = true,
	[ASSET_TYPE_NAME_TO_ID_STRING.Face] = true
}

local assetSubtypes = {}

for k, v in ASSET_TYPE_ID_STRING_TO_NAME do
	if not set[k] then
		assetSubtypes[tonumber(k)] = v
	end
end

local outfitSubtypes = {}

for k, v in InventoryOutfitTypeToInventoryTypeId do
	outfitSubtypes[v] = k
end

local v = {
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
	[InventoryOutfitType.Body] = true,
	[InventoryOutfitType.DynamicHead] = true,
	[InventoryOutfitType.Shoes] = true,
	[InventoryOutfitType.Animations] = true
}

local set3 = {}

for _, v2 in v do
	set3[v2.Value] = true
end

local v2 = {}

for k in assetSubtypes do
	if not set3[k] then
		table.insert(v2, k)
	end
end

table.sort(v2)

local v3 = {}

for k, v4 in InventoryOutfitTypeToInventoryTypeId do
	if set2[k] then
		table.insert(v3, v4)
	end
end

table.sort(v3)

local allTabItemCategories = {}

for _, itemSubType in v2 do
	table.insert(allTabItemCategories, {
		itemType = InventorySearchItemType.Asset,
		itemSubType = itemSubType
	})
end

for _, itemSubType in v3 do
	table.insert(allTabItemCategories, {
		itemType = InventorySearchItemType.Outfit,
		itemSubType = itemSubType
	})
end

return {
	KeyPrefix = "InventorySearch:",
	MaxPageLimit = 500,
	AssetSubtypes = assetSubtypes,
	OutfitSubtypes = outfitSubtypes,
	SearchableSubtypesByItemType = {
		[InventorySearchItemType.Asset] = assetSubtypes,
		[InventorySearchItemType.Outfit] = outfitSubtypes
	},
	AllTabItemCategories = allTabItemCategories
}
