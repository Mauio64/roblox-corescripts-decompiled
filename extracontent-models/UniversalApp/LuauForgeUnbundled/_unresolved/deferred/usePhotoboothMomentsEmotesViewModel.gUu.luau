local module = require("@luauforge/deferred/gTR")
local useLocalization = require("@luauforge/deferred/gUd").Hooks.useLocalization
local useSignalState = require("@luauforge/deferred/gUp").useSignalState

require("@luauforge/deferred/gUl")
local module2 = require("@luauforge/deferred/gUq")

local function getEmoteThumbnailUrl(p2)
	return `rbxthumb://type=Asset&id={p2}&w={150}&h={150}&filters=0`
end

local function usePhotoboothMomentsEmotesViewModel(data)
	local v5 = useLocalization({ title = "Feature.Avatar.Heading.Emotes" })

	local v6 = module2(false)
	local v7 = useSignalState(v6.getActiveEmoteId)

	local isEmotesDisabled = data.isEmotesDisabled
	local onEmoteBlocked = data.onEmoteBlocked
	local v8 = module.useCallback(function(p2)
		if isEmotesDisabled then
			onEmoteBlocked()
		else
			v6.setActiveEmote(p2 == v7 and "" or p2)
		end
	end, { v6, v7, isEmotesDisabled, onEmoteBlocked })

	local emotes = data.emotes
	local v9 = module.useMemo(function()
		local result = {}

		for k, emote in emotes do
			table.insert(result, {
				id = emote.assetId,
				itemName = emote.name,
				thumbnailUrl = `rbxthumb://type=Asset&id={emote.assetId}&w={150}&h={150}&filters=0`,
				onActivated = v8,
				isSelected = emote.assetId == v7
			})
		end

		return result
	end, { emotes, v8, v7 })

	local onEndReached = data.onEndReached
	module.useEffect(function()
		onEndReached()
	end, { onEndReached })

	return {
		title = v5.title,
		cards = v9,
		hasMore = data.hasMore,
		onEndReached = data.onEndReached,
		onClose = data.onClose,
		testId = "PhotoboothMomentsEmotesView"
	}
end

return usePhotoboothMomentsEmotesViewModel
