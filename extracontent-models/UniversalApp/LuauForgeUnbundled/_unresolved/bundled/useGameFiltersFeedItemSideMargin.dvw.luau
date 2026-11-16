local module = require("@luauforge/bundled/dsr")
local collectionItemSize = module.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = module.useCollectionLayoutParams
local formFactor = require("@luauforge/bundled/dso").Enums.FormFactor
local useSelector = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useSelector
local useAppPolicy = require("@luauforge/bundled/drN").useAppPolicy
local module2 = require("@luauforge/bundled/dqn")

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module2.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module2.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function useGameFiltersFeedItemSideMargin(p2)
	local v5 = useSelector(function(p3)
		return p3.FormFactor
	end)
	local v6

	if not useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end) then
		v6 = { sideMargin = 0 }
		local v7 = if v5 == formFactor.COMPACT then GAME_CAROUSEL_SIDE_COMPACT_PADDING else GAME_CAROUSEL_SIDE_WIDE_PADDING
		v6.sideMargin = v7
	end

	return useCollectionLayoutParams(collectionItemSize.Small, p2, false, v6).sideMargin
end

return useGameFiltersFeedItemSideMargin
