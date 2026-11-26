local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Cryo")
local constants = AvatarExperienceCommon.Constants
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local ASSET_TYPE_TO_ACCESSORY_TYPE = constants.ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_NAME_TO_ID_STRING = constants.ASSET_TYPE_NAME_TO_ID_STRING
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local LAYERED_CLOTHING_ORDER = constants.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = constants.LAYERED_ASSET_TYPES
local BODY_BUNDLE_TYPE_ID = constants.BODY_BUNDLE_TYPE_ID
local SHOES_BUNDLE_TYPE_ID = constants.SHOES_BUNDLE_TYPE_ID
local DYNAMIC_HEAD_BUNDLE_TYPE_ID = constants.DYNAMIC_HEAD_BUNDLE_TYPE_ID

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local function fn(assetsInBundle, items)
	local result = {}

	for k, item in assetsInBundle do
		local assetType = item.assetType
		local id = item.id

		if not (assetType and id) then
			continue
		end

		local v5 = ASSET_TYPE_TO_ACCESSORY_TYPE[assetType]
		local v6

		if items then
			v6 = false

			for k2, item2 in items do
				if v5 == item2 then
					v6 = true
					break
				end
			end
		else
			v6 = true
		end

		if v6 and v5 then
			table.insert(result, {
				AssetId = tonumber(id) or 0,
				Order = LAYERED_CLOTHING_ORDER[assetType],
				AccessoryType = ASSET_TYPE_TO_ACCESSORY_TYPE[assetType],
				IsLayered = LAYERED_ASSET_TYPES[assetType] ~= nil
			})
		end
	end

	return result
end

local function fn2(object, items)
	local accessories = object:GetAccessories(true)

	local accessoryTypes = {}

	for k, item in items do
		table.insert(accessoryTypes, item.AccessoryType)
	end

	local filtered = Cryo.List.filter(accessories, function(p2): boolean
		for k, v5 in accessoryTypes do
			if p2.AccessoryType == v5 then
				return false
			end
		end

		return true
	end)

	object:SetAccessories(Cryo.List.join(filtered, items), true)
end

return function(data, p2)
	if
		data.itemType == itemTypeEnum.Asset
		and (ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] or ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[data.itemSubType])
	then
		local itemSubType = data.itemSubType
		local itemId = data.itemId
		local v5 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[itemSubType]

		if
			itemId
			and itemSubType ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear
			and ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType]
		then
			fn2(p2, {
				{
					AssetId = tonumber(itemId) or 0,
					Order = LAYERED_CLOTHING_ORDER[itemSubType],
					AccessoryType = ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType],
					IsLayered = LAYERED_ASSET_TYPES[itemSubType] ~= nil
				}
			})
		elseif v5 and itemId then
			p2[v5] = itemId
		end
	end

	if
		data.itemType == itemTypeEnum.Bundle
		and data.assetsInBundle
		and data.itemSubType == BODY_BUNDLE_TYPE_ID
	then
		local v5 = fn(data.assetsInBundle, { Enum.AccessoryType.Hair })

		if #v5 > 0 then
			fn2(p2, v5)
		end

		for k, v6 in data.assetsInBundle do
			local assetType = v6.assetType

			if not assetType then
				continue
			end

			local v7 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

			if ASSET_TYPE_TO_ACCESSORY_TYPE[assetType] ~= Enum.AccessoryType.Hair and v7 and v6.id then
				p2[v7] = v6.id
			end
		end
	end

	if data.itemSubType == SHOES_BUNDLE_TYPE_ID and data.assetsInBundle then
		local v5 = fn(data.assetsInBundle, { Enum.AccessoryType.LeftShoe, Enum.AccessoryType.RightShoe })

		if #v5 > 0 then
			fn2(p2, v5)
		end
	end

	if data.itemSubType == DYNAMIC_HEAD_BUNDLE_TYPE_ID and data.assetsInBundle then
		for k, v5 in data.assetsInBundle do
			local assetType = v5.assetType
			local id = v5.id

			if not assetType then
				continue
			end

			local v6 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

			if v6 and id then
				p2[v6] = id
			end
		end
	end
end
