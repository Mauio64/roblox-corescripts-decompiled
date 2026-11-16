local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local function getAssetIdToAssetTypeIdFromHumanoidDescription(object)
	local assetIdToAssetTypeId = {}

	for k, v in Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP do
		if Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[tostring(k)] ~= nil then
			continue
		end

		local v2 = object[v]

		if typeof(v2) == "number" and v2 > 0 then
			assetIdToAssetTypeId[tostring(v2)] = tostring(k)
		elseif typeof(v2) == "string" and v2 ~= "" then
			for k2 in v2:gmatch("([%d]+),?") do
				assetIdToAssetTypeId[k2] = tostring(k)
			end
		end
	end

	local accessories = object:GetAccessories(true)

	for _, accessory in accessories do
		local accessoryType = accessory.AccessoryType
		assetIdToAssetTypeId[tostring(accessory.AssetId)] = Constants.ACCESSORY_TYPE_TO_ASSET_TYPE[accessoryType]
	end

	return assetIdToAssetTypeId
end

return getAssetIdToAssetTypeIdFromHumanoidDescription
