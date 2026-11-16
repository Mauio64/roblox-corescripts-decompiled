local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerTile)

local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
require(AvatarExperienceProfilePictureEditor.Hooks.useOwnedEmotes)
require(AvatarExperienceProfilePictureEditor.Hooks.useRecommendedEmotes)
require(AvatarExperienceProfilePictureEditor.Utils.mapWidgetContentToFrameItems)

local getRecommendationPriceLineContent = require(AvatarExperienceProfilePictureEditor.Utils.getRecommendationPriceLineContent)

local function buildOwnedEmoteItems(ownedEmotes)
	local ownedEmoteItems = {}

	for _, item in ownedEmotes do
		table.insert(ownedEmoteItems, {
			id = item.id,
			label = item.label,
			image = getRbxthumbWithTypeSizeAndOptions(item.id, Constants.RbxthumbTypes.Asset, 150)
		})
	end

	return ownedEmoteItems
end

local function buildRecommendedEmoteItems(ownedEmotes, recommendedEmotes, freeLabel: string)
	local idSet = {}
	local recommendedEmoteItems = {}

	for _, item in ownedEmotes do
		idSet[item.id] = true
	end

	for _, item in recommendedEmotes do
		if not idSet[item.id] then
			table.insert(recommendedEmoteItems, {
				id = item.id,
				label = item.label,
				image = getRbxthumbWithTypeSizeAndOptions(item.id, Constants.RbxthumbTypes.Asset, 150),
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

local function buildCombinedEmoteItems(p, items)
	local clone = table.clone(p)

	for _, item in items do
		table.insert(clone, item)
	end

	return clone
end

local function buildFrameAssetItems(frameItems)
	local frameAssetItems = {}

	for _, item in frameItems do
		table.insert(frameAssetItems, { id = item.id, label = item.label, image = item.image })
	end

	return frameAssetItems
end

local function buildEditProfileImageAssetItems(data)
	local ownedEmoteItems = buildOwnedEmoteItems(data.ownedEmotes)

	local recommendedEmoteItems = buildRecommendedEmoteItems(data.ownedEmotes, data.recommendedEmotes, data.freeLabel)
	local clone = table.clone(ownedEmoteItems)

	local editProfileImageAssetItems = {
		ownedEmoteItems = ownedEmoteItems,
		recommendedEmoteItems = recommendedEmoteItems,
		combinedEmoteItems = 0,
		frameAssetItems = 0
	}

	for _, recommendedEmoteItem in recommendedEmoteItems do
		table.insert(clone, recommendedEmoteItem)
	end

	editProfileImageAssetItems.combinedEmoteItems = clone
	editProfileImageAssetItems.frameAssetItems = buildFrameAssetItems(data.frameItems)
	return editProfileImageAssetItems
end

return buildEditProfileImageAssetItems
