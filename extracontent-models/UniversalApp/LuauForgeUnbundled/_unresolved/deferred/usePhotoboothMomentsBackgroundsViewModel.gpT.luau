local module = require("@luauforge/deferred/gpo")
local useLocalization = require("@luauforge/deferred/gpA").Hooks.useLocalization
local useSignalState = require("@luauforge/deferred/gpM").useSignalState

require("@luauforge/deferred/gpI")
local module2 = require("@luauforge/deferred/gpN")

local function getBackgroundThumbnailUrl(p2)
	return `rbxthumb://type=Asset&id={p2}&w={150}&h={150}`
end

local function usePhotoboothMomentsBackgroundsViewModel(data)
	local v5 = useLocalization({ title = "Feature.Catalog.Label.Backgrounds" })

	local v6 = module2(false)
	local v7 = useSignalState(v6.getActiveBackgroundId)

	local v8 = module.useCallback(function(p2)
		if p2 == v7 then
			return
		end

		v6.setActiveBackground(p2)
	end, { v6, v7 })

	local backgrounds = data.backgrounds
	local v9 = module.useMemo(function()
		local result = {}

		for k, background in backgrounds do
			table.insert(result, {
				id = background.assetId,
				itemName = background.name,
				thumbnailUrl = `rbxthumb://type=Asset&id={background.assetId}&w={150}&h={150}`,
				onActivated = v8,
				isSelected = background.assetId == v7
			})
		end

		return result
	end, { backgrounds, v8, v7 })

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
		testId = "PhotoboothMomentsBackgroundsView",
		hideCardTitles = true
	}
end

return usePhotoboothMomentsBackgroundsViewModel
