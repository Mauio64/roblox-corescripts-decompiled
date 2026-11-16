require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/UserLib")
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = UserLib.Utils.Constants
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useOwnedEmotes")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useRecommendedEmotes")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/mapWidgetContentToFrameItems")

local getRecommendationPriceLineContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getRecommendationPriceLineContent")

local function buildOwnedEmoteItems(ownedEmotes)
	local ownedEmoteItems = {}

	for k, item in ownedEmotes do
		table.insert(ownedEmoteItems, {
			id = item.id,
			label = item.label,
			image = getRbxthumbWithTypeSizeAndOptions(item.id, constants.RbxthumbTypes.Asset, 150)
		})
	end

	return ownedEmoteItems
end

local function buildRecommendedEmoteItems(ownedEmotes, recommendedEmotes, freeLabel)
	local idSet = {}
	local recommendedEmoteItems = {}

	for k, item in ownedEmotes do
		idSet[item.id] = true
	end

	for k, item in recommendedEmotes do
		if not idSet[item.id] then
			table.insert(recommendedEmoteItems, {
				id = item.id,
				label = item.label,
				image = getRbxthumbWithTypeSizeAndOptions(item.id, constants.RbxthumbTypes.Asset, 150),
				priceLineContent = getRecommendationPriceLineContent({
					priceInRobux = item.priceInRobux,
					lowestPrice = item.lowestPrice,
					priceStatus = item.priceStatus,
					freeLabel = freeLabel
				})
			})
		end
	end

	return recommendedEmoteItems
end

local function buildCombinedEmoteItems(p2, items)
	local clone = table.clone(p2)

	for k, item in items do
		table.insert(clone, item)
	end

	return clone
end

local function buildFrameAssetItems(frameItems)
	local frameAssetItems = {}

	for k, item in frameItems do
		table.insert(frameAssetItems, {
			id = item.id,
			label = item.label,
			image = item.image
		})
	end

	return frameAssetItems
end

local function buildEditProfileImageAssetItems(data)
	local ownedEmoteItems = buildOwnedEmoteItems(data.ownedEmotes)

	local recommendedEmoteItems = buildRecommendedEmoteItems(
		data.ownedEmotes,
		data.recommendedEmotes,
		data.freeLabel
	)
	local clone = table.clone(ownedEmoteItems)

	local editProfileImageAssetItems = {
		ownedEmoteItems = ownedEmoteItems,
		recommendedEmoteItems = recommendedEmoteItems,
		combinedEmoteItems = 0,
		frameAssetItems = 0
	}

	for k, recommendedEmoteItem in recommendedEmoteItems do
		table.insert(clone, recommendedEmoteItem)
	end

	editProfileImageAssetItems.combinedEmoteItems = clone
	editProfileImageAssetItems.frameAssetItems = buildFrameAssetItems(data.frameItems)
	return editProfileImageAssetItems
end

return buildEditProfileImageAssetItems
