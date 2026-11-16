local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/UserLib")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/profileFramesWidgetsApi")

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = UserLib.Utils.Constants

local function buildHydratedAssetLookup(p2)
	local hydratedAssetLookup = {}

	if p2 == nil then
		return hydratedAssetLookup
	end

	local hydratedContent = p2.hydratedContent

	if hydratedContent == nil then
		return hydratedAssetLookup
	end

	for k, v5 in hydratedContent do
		if v5.type == "Asset" then
			hydratedAssetLookup[tostring(v5.id)] = v5
		end
	end

	return hydratedAssetLookup
end

return {
	FRAME_PICKER_THUMB_SIZE = 150,
	FRAME_PREVIEW_THUMB_SIZE = 420,
	getProfileFramePickerImage = function(p2)
		return getRbxthumbWithTypeSizeAndOptions(p2, constants.RbxthumbTypes.Asset, 150)
	end,
	getProfileFramePreviewImage = function(p2)
		return getRbxthumbWithTypeSizeAndOptions(p2, constants.RbxthumbTypes.Asset, 420)
	end,
	mapWidgetContentToFrameItems = function(items, p2)
		local hydratedAssetLookup = buildHydratedAssetLookup(p2)
		local result = {}

		for k, item in items do
			if item.type ~= "Asset" then
				continue
			end

			local id = tostring(item.id)
			local hydratedAsset = hydratedAssetLookup[id]
			local v5 = if hydratedAsset and hydratedAsset.name then hydratedAsset.name else nil
			table.insert(result, {
				id = id,
				label = v5,
				image = getRbxthumbWithTypeSizeAndOptions(id, constants.RbxthumbTypes.Asset, 150),
				previewImage = getRbxthumbWithTypeSizeAndOptions(id, constants.RbxthumbTypes.Asset, 420)
			})
		end

		return result
	end
}
