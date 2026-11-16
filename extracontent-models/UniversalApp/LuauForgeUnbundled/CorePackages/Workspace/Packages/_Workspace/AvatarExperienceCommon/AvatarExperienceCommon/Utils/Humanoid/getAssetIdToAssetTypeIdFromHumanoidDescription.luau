local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function getAssetIdToAssetTypeIdFromHumanoidDescription(object)
	local assetIdToAssetTypeId = {}

	for k, v5 in Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP do
		if Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[tostring(k)] ~= nil then
			continue
		end

		local v6 = object[v5]

		if typeof(v6) == "number" and v6 > 0 then
			assetIdToAssetTypeId[tostring(v6)] = tostring(k)
		elseif typeof(v6) == "string" and v6 ~= "" then
			for k2 in v6:gmatch("([%d]+),?") do
				assetIdToAssetTypeId[k2] = tostring(k)
			end
		end
	end

	local accessories = object:GetAccessories(true)

	for k, accessory in accessories do
		local accessoryType = accessory.AccessoryType
		assetIdToAssetTypeId[tostring(accessory.AssetId)] = Constants.ACCESSORY_TYPE_TO_ASSET_TYPE[accessoryType]
	end

	return assetIdToAssetTypeId
end

return getAssetIdToAssetTypeIdFromHumanoidDescription
