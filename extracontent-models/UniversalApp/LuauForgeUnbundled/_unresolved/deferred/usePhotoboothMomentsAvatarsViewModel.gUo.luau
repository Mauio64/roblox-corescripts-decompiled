local module = require("@luauforge/deferred/gTR")
local useLocalization = require("@luauforge/deferred/gUd").Hooks.useLocalization
local useSignalState = require("@luauforge/deferred/gUp").useSignalState

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@luauforge/deferred/gTV").FFlagAXPhotoboothMomentsCurrentAvatarTile

local module2 = require("@luauforge/deferred/gUq")

require("@luauforge/deferred/gUl")

local function getOutfitThumbnailUrl(p2, p3)
	return `rbxthumb://type=Outfit&id={p2}&w={420}&h={420}&filters={p3}`
end

local function usePhotoboothMomentsAvatarsViewModel(data)
	local v5 = useLocalization(fFlagAXPhotoboothMomentsCurrentAvatarTile and {
		title = "Feature.Avatar.Label.Title.MyAvatars",
		currentAvatar = "Feature.Avatar.Title.MyAvatar",
		currentTag = "Feature.Avatar.Label.Current"
	} or { title = "Feature.Avatar.Label.Title.MyAvatars" })

	local v6 = module2(false)
	local v7 = useSignalState(v6.getActiveOutfitId)

	local v8 = module.useCallback(function(p2)
		v6.setActiveOutfit(p2)
	end, { v6 })

	local avatars = data.avatars
	local v9

	if fFlagAXPhotoboothMomentsCurrentAvatarTile then
		local currentAvatarThumbnailUrl = data.currentAvatarThumbnailUrl
		v9 = module.useMemo(function()
			local result = {}
			table.insert(result, {
				id = "",
				itemName = v5.currentAvatar,
				thumbnailUrl = currentAvatarThumbnailUrl or "",
				onActivated = v8,
				isSelected = v7 == "",
				tagText = v5.currentTag
			})

			for k, avatar in avatars do
				table.insert(result, {
					id = avatar.outfitId,
					itemName = avatar.name,
					thumbnailUrl = `rbxthumb://type=Outfit&id={avatar.outfitId}&w={420}&h={420}&filters={avatar.updateCounter}`,
					onActivated = v8,
					isSelected = avatar.outfitId == v7
				})
			end

			return result
		end, {
			avatars,
			v8,
			v7,
			currentAvatarThumbnailUrl,
			v5.currentAvatar,
			v5.currentTag
		})
	else
		v9 = module.useMemo(function()
			local result = {}

			for k, avatar in avatars do
				table.insert(result, {
					id = avatar.outfitId,
					itemName = avatar.name,
					thumbnailUrl = `rbxthumb://type=Outfit&id={avatar.outfitId}&w={420}&h={420}&filters={avatar.updateCounter}`,
					onActivated = v8,
					isSelected = avatar.outfitId == v7
				})
			end

			return result
		end, { avatars, v8, v7 })
	end

	return {
		title = v5.title,
		cards = v9,
		hasMore = data.hasMore,
		onEndReached = data.onEndReached,
		onClose = data.onClose,
		testId = "PhotoboothMomentsAvatarsView",
		hideCardTitles = true,
		cardAspectRatio = 0.7
	}
end

return usePhotoboothMomentsAvatarsViewModel
