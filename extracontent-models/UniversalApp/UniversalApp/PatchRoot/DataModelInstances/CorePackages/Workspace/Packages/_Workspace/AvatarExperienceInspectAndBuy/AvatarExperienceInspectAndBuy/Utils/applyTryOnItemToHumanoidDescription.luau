local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)
local Cryo = require(AvatarExperienceInspectAndBuyParent.Cryo)
local Constants = AXCommon.Constants
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local LAYERED_CLOTHING_ORDER = Constants.LAYERED_CLOTHING_ORDER
local LAYERED_ASSET_TYPES = Constants.LAYERED_ASSET_TYPES
local BODY_BUNDLE_TYPE_ID = Constants.BODY_BUNDLE_TYPE_ID
local SHOES_BUNDLE_TYPE_ID = Constants.SHOES_BUNDLE_TYPE_ID
local DYNAMIC_HEAD_BUNDLE_TYPE_ID = Constants.DYNAMIC_HEAD_BUNDLE_TYPE_ID

require(AvatarExperienceInspectAndBuy.Types)

local function v15(t1: {[any]: any}, t2: {[any]: any}?) -- line: 60
	-- upvalues: ASSET_TYPE_TO_ACCESSORY_TYPE (copy), LAYERED_CLOTHING_ORDER (copy), LAYERED_ASSET_TYPES (copy)
	local t3 = {}

	for _, v25 in t1 do
		local assetType = v25.assetType
		local id = v25.id

		if assetType and id then
			local v28 = ASSET_TYPE_TO_ACCESSORY_TYPE[assetType]
			local v29 = true

			if t2 then
				v29 = false

				for _, v31 in t2 do
					if v28 == v31 then
						v29 = true

						break
					end
				end
			end

			if v29 and v28 then
				table.insert(t3, {
					AssetId = tonumber(id) or 0,
					Order = LAYERED_CLOTHING_ORDER[assetType],
					AccessoryType = ASSET_TYPE_TO_ACCESSORY_TYPE[assetType],
					IsLayered = LAYERED_ASSET_TYPES[assetType] ~= nil
				})
			end
		end
	end

	return t3
end
local function v16(p1, t4: {[any]: any}) -- line: 97
	-- upvalues: Cryo (copy)
	local Accessories = p1:GetAccessories(true)
	local t5 = {}

	for _, v37 in t4 do
		table.insert(t5, v37.AccessoryType)
	end

	local v38 = Cryo.List.filter(Accessories, function(p2) -- line: 47
		-- upvalues: t5 (copy)
		for _, v61 in t5 do
			if v61 == p2.AccessoryType then
				return false
			end
		end

		return true
	end)

	p1:SetAccessories(Cryo.List.join(v38, t4), true)
end

return function(p3, p4) -- line: 116
	-- upvalues: ItemTypeEnum (copy), ASSET_TYPE_TO_ACCESSORY_TYPE (copy), ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), LAYERED_CLOTHING_ORDER (copy), LAYERED_ASSET_TYPES (copy), v16 (copy), BODY_BUNDLE_TYPE_ID (copy), v15 (copy), SHOES_BUNDLE_TYPE_ID (copy), DYNAMIC_HEAD_BUNDLE_TYPE_ID (copy)
	if p3.itemType == ItemTypeEnum.Asset and (ASSET_TYPE_TO_ACCESSORY_TYPE[p3.itemSubType] or ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[p3.itemSubType]) then
		local itemSubType = p3.itemSubType
		local itemId = p3.itemId
		local v43 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[itemSubType]

		if itemId and itemSubType ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear and ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType] then
			local t6 = {{
				AssetId = tonumber(itemId) or 0,
				Order = LAYERED_CLOTHING_ORDER[itemSubType],
				AccessoryType = ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType],
				IsLayered = LAYERED_ASSET_TYPES[itemSubType] ~= nil
			}}

			v16(p4, t6)
		elseif v43 and itemId then
			p4[v43] = itemId
		end
	end

	if p3.itemType == ItemTypeEnum.Bundle and p3.assetsInBundle and p3.itemSubType == BODY_BUNDLE_TYPE_ID then
		local v45 = v15(p3.assetsInBundle, { Enum.AccessoryType.Hair })

		if #v45 > 0 then
			v16(p4, v45)
		end

		for _, v47 in p3.assetsInBundle do
			local assetType = v47.assetType

			if assetType then
				local v49 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

				if ASSET_TYPE_TO_ACCESSORY_TYPE[assetType] ~= Enum.AccessoryType.Hair and v49 and v47.id then
					p4[v49] = v47.id
				end
			end
		end
	end

	if p3.itemSubType == SHOES_BUNDLE_TYPE_ID and p3.assetsInBundle then
		local v50 = v15(p3.assetsInBundle, {
			Enum.AccessoryType.LeftShoe,
			Enum.AccessoryType.RightShoe
		})

		if #v50 > 0 then
			v16(p4, v50)
		end
	end

	if p3.itemSubType == DYNAMIC_HEAD_BUNDLE_TYPE_ID and p3.assetsInBundle then
		for _, v52 in p3.assetsInBundle do
			local assetType = v52.assetType
			local id = v52.id

			if assetType then
				local v55 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[assetType]

				if v55 and id then
					p4[v55] = id
				end
			end
		end
	end
end
