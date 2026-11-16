local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(parent.AXCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local Cryo = require(parent.Cryo)
local Constants = AXCommon.Constants
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local LAYERED_CLOTHING_ORDER = Constants.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = Constants.LAYERED_ASSET_TYPES
local BODY_BUNDLE_TYPE_ID = Constants.BODY_BUNDLE_TYPE_ID
local SHOES_BUNDLE_TYPE_ID = Constants.SHOES_BUNDLE_TYPE_ID
local DYNAMIC_HEAD_BUNDLE_TYPE_ID = Constants.DYNAMIC_HEAD_BUNDLE_TYPE_ID

require(AvatarExperienceInspectAndBuy.Types)

local function fn(p: string, p2: string) -- 2 equivalent calls inferred from this helper
	return {
		AssetId = tonumber(p2) or 0,
		Order = LAYERED_CLOTHING_ORDER[p],
		AccessoryType = ASSET_TYPE_TO_ACCESSORY_TYPE[p],
		IsLayered = LAYERED_ASSET_TYPES[p] ~= nil
	}
end

local function fn2(assetsInBundle, items)
	local result = {}

	for _, item in assetsInBundle do
		local assetType = item.assetType
		local id = item.id

		if not (assetType and id) then
			continue
		end

		local v = ASSET_TYPE_TO_ACCESSORY_TYPE[assetType]
		local v2

		if items then
			v2 = false

			for _, item2 in items do
				if v == item2 then
					v2 = true
					break
				end
			end
		else
			v2 = true
		end

		if v2 and v then
			table.insert(result, fn(assetType, id)) -- inferred equivalent call
		end
	end

	return result
end

local function fn3(object, items)
	local accessories = object:GetAccessories(true)

	local accessoryTypes = {}

	for _, item in items do
		table.insert(accessoryTypes, item.AccessoryType)
	end

	local filtered = Cryo.List.filter(accessories, function(p): boolean
		for _, v in accessoryTypes do
			if p.AccessoryType == v then
				return false
			end
		end

		return true
	end)

	object:SetAccessories(Cryo.List.join(filtered, items), true)
end

return function(data, p)
	if
		data.itemType == ItemTypeEnum.Asset
		and (ASSET_TYPE_TO_ACCESSORY_TYPE[data.itemSubType] or ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[data.itemSubType])
	then
		local itemSubType = data.itemSubType
		local itemId = data.itemId
		local v = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[itemSubType]

		if
			itemId
			and itemSubType ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear
			and ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType]
		then
			fn3(p, { fn(itemSubType, itemId) }) -- inferred equivalent call
		elseif v and itemId then
			p[v] = itemId
		end
	end

	if data.itemType == ItemTypeEnum.Bundle and data.assetsInBundle and data.itemSubType == BODY_BUNDLE_TYPE_ID then
		local v = fn2(data.assetsInBundle, { Enum.AccessoryType.Hair })

		if #v > 0 then
			fn3(p, v)
		end

		for _, v2 in data.assetsInBundle do
			local assetType = v2.assetType

			if not assetType then
				continue
			end

			local v3 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

			if ASSET_TYPE_TO_ACCESSORY_TYPE[assetType] ~= Enum.AccessoryType.Hair and v3 and v2.id then
				p[v3] = v2.id
			end
		end
	end

	if data.itemSubType == SHOES_BUNDLE_TYPE_ID and data.assetsInBundle then
		local v = fn2(data.assetsInBundle, { Enum.AccessoryType.LeftShoe, Enum.AccessoryType.RightShoe })

		if #v > 0 then
			fn3(p, v)
		end
	end

	if data.itemSubType == DYNAMIC_HEAD_BUNDLE_TYPE_ID and data.assetsInBundle then
		for _, v in data.assetsInBundle do
			local assetType = v.assetType
			local id = v.id

			if not assetType then
				continue
			end

			local v2 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

			if v2 and id then
				p[v2] = id
			end
		end
	end
end
