local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local UserLib = require(parent.UserLib)

require(AvatarExperienceProfilePictureEditor.Api.profileFramesWidgetsApi)

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants

local function buildHydratedAssetLookup(p)
	local hydratedAssetLookup = {}

	if p == nil then
		return hydratedAssetLookup
	end

	local hydratedContent = p.hydratedContent

	if hydratedContent == nil then
		return hydratedAssetLookup
	end

	for _, v in hydratedContent do
		if v.type == "Asset" then
			hydratedAssetLookup[tostring(v.id)] = v
		end
	end

	return hydratedAssetLookup
end

local MapWidgetContentToFrameItems = {}
MapWidgetContentToFrameItems.FRAME_PICKER_THUMB_SIZE = 150
MapWidgetContentToFrameItems.FRAME_PREVIEW_THUMB_SIZE = 420

function MapWidgetContentToFrameItems.getProfileFramePickerImage(p: string)
	return getRbxthumbWithTypeSizeAndOptions(p, Constants.RbxthumbTypes.Asset, 150)
end

function MapWidgetContentToFrameItems.getProfileFramePreviewImage(p: string)
	return getRbxthumbWithTypeSizeAndOptions(p, Constants.RbxthumbTypes.Asset, 420)
end

function MapWidgetContentToFrameItems.mapWidgetContentToFrameItems(items, p)
	local hydratedAssetLookup = buildHydratedAssetLookup(p)
	local result = {}

	for _, item in items do
		if item.type ~= "Asset" then
			continue
		end

		local id = tostring(item.id)
		local hydratedAsset = hydratedAssetLookup[id]
		local label

		if hydratedAsset and hydratedAsset.name then
			label = hydratedAsset.name
		end

		table.insert(result, {
			id = id,
			label = label,
			image = getRbxthumbWithTypeSizeAndOptions(id, Constants.RbxthumbTypes.Asset, 150),
			previewImage = getRbxthumbWithTypeSizeAndOptions(id, Constants.RbxthumbTypes.Asset, 420)
		})
	end

	return result
end

return MapWidgetContentToFrameItems
