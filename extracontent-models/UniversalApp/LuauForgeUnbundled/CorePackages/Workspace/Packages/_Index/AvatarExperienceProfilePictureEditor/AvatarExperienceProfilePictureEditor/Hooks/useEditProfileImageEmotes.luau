local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local useRealtimeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RealtimeDelivery").useRealtimeEvent
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")

local useOwnedEmotes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useOwnedEmotes")
local useRecommendedEmotes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useRecommendedEmotes")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local useEditProfileImageActions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Context/EditProfileImageActionsContext").useEditProfileImageActions

local function useEditProfileImageEmotes(p2)
	local v5 = useEditProfileImageActions()
	local v6 = useOwnedEmotes()
	local v7 = useRecommendedEmotes()
	local emoteItems = v6.emoteItems
	local recommendedEmotes = v7.recommendedEmotes

	local v8 = React.useCallback(function(p3)
		local label = nil

		for k, recommendedEmote in recommendedEmotes do
			if recommendedEmote.id == p3 then
				label = recommendedEmote.label
				break
			end
		end

		v6.markEmoteOwned(p3, label)
	end, { recommendedEmotes, v6.markEmoteOwned })

	useRealtimeEvent("AvatarAssetOwnershipNotifications", "Grant", function(p3)
		if tostring(p3.AssetTypeId) == tostring(Enum.AvatarAssetType.EmoteAnimation.Value) then
			v8((tostring(p3.AssetId)))
		end
	end, { v8 })

	local v9 = React.useMemo(function()
		local idSet = {}

		for k, emoteItem in emoteItems do
			idSet[emoteItem.id] = true
		end

		return idSet
	end, { emoteItems })
	local v10 = React.useMemo(function()
		local idSet = {}

		for k, recommendedEmote in recommendedEmotes do
			idSet[recommendedEmote.id] = true
		end

		return idSet
	end, { recommendedEmotes })
	local selectedEmoteId = p2.selectedEmoteId
	local v11

	if selectedEmoteId and v9[selectedEmoteId] ~= true then
		v11 = v10[selectedEmoteId] == true
	else
		v11 = false
	end

	React.useEffect(function()
		if selectedEmoteId and v11 then
			v5.onPrepareRecommendedEmotePurchase(selectedEmoteId)
		end
	end, { selectedEmoteId, v11, v5.onPrepareRecommendedEmotePurchase })

	local v12 = Localization.Hooks.useLocalization({ free = TextKeys.Free })

	return {
		ownedEmotes = emoteItems,
		recommendedEmotes = recommendedEmotes,
		isLoading = v6.isLoading,
		hasError = v6.hasError,
		hasMoreEmotes = v6.hasMoreEmotes,
		isLoadingMoreEmotes = v6.isLoadingMoreEmotes,
		hasLoadMoreError = v6.hasLoadMoreError,
		onRetry = v6.refetch,
		onMoreEmotes = v6.onMoreEmotes,
		isRecommendedEmoteSelected = v11,
		freeLabel = v12.free
	}
end

return useEditProfileImageEmotes
