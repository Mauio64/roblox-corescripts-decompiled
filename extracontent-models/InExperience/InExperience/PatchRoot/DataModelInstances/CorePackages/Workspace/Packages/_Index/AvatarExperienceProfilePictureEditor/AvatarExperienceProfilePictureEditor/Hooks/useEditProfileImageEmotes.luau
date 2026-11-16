local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local useRealtimeEvent = RealtimeDelivery.useRealtimeEvent
local Localization = require(parent.Localization)

local useOwnedEmotes = require(AvatarExperienceProfilePictureEditor.Hooks.useOwnedEmotes)
local useRecommendedEmotes = require(AvatarExperienceProfilePictureEditor.Hooks.useRecommendedEmotes)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local EditProfileImageActionsContext = require(AvatarExperienceProfilePictureEditor.Context.EditProfileImageActionsContext)
local useEditProfileImageActions = EditProfileImageActionsContext.useEditProfileImageActions

local function useEditProfileImageEmotes(p)
	local v = useEditProfileImageActions()
	local v2 = useOwnedEmotes()
	local v3 = useRecommendedEmotes()
	local emoteItems = v2.emoteItems
	local recommendedEmotes = v3.recommendedEmotes

	local v4 = React.useCallback(function(p2: string)
		local label = nil

		for _, recommendedEmote in recommendedEmotes do
			if recommendedEmote.id == p2 then
				label = recommendedEmote.label
				break
			end
		end

		v2.markEmoteOwned(p2, label)
	end, { recommendedEmotes, v2.markEmoteOwned })

	useRealtimeEvent("AvatarAssetOwnershipNotifications", "Grant", function(p2)
		if tostring(p2.AssetTypeId) == tostring(Enum.AvatarAssetType.EmoteAnimation.Value) then
			v4((tostring(p2.AssetId)))
		end
	end, { v4 })

	local v5 = React.useMemo(function()
		local idSet = {}

		for _, emoteItem in emoteItems do
			idSet[emoteItem.id] = true
		end

		return idSet
	end, { emoteItems })
	local v6 = React.useMemo(function()
		local idSet = {}

		for _, recommendedEmote in recommendedEmotes do
			idSet[recommendedEmote.id] = true
		end

		return idSet
	end, { recommendedEmotes })
	local selectedEmoteId = p.selectedEmoteId
	local isRecommendedEmoteSelected

	if selectedEmoteId and v5[selectedEmoteId] ~= true then
		isRecommendedEmoteSelected = v6[selectedEmoteId] == true
	else
		isRecommendedEmoteSelected = false
	end

	React.useEffect(function()
		if selectedEmoteId and isRecommendedEmoteSelected then
			v.onPrepareRecommendedEmotePurchase(selectedEmoteId)
		end
	end, { selectedEmoteId, isRecommendedEmoteSelected, v.onPrepareRecommendedEmotePurchase })

	local v7 = Localization.Hooks.useLocalization({ free = TextKeys.Free })

	return {
		ownedEmotes = emoteItems,
		recommendedEmotes = recommendedEmotes,
		isLoading = v2.isLoading,
		hasError = v2.hasError,
		hasMoreEmotes = v2.hasMoreEmotes,
		isLoadingMoreEmotes = v2.isLoadingMoreEmotes,
		hasLoadMoreError = v2.hasLoadMoreError,
		onRetry = v2.refetch,
		onMoreEmotes = v2.onMoreEmotes,
		isRecommendedEmoteSelected = isRecommendedEmoteSelected,
		freeLabel = v7.free
	}
end

return useEditProfileImageEmotes
