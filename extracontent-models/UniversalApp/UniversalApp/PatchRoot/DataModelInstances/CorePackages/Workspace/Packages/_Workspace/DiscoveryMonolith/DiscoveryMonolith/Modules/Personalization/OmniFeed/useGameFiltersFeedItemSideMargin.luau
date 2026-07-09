local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local CollectionViews = require(Parent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local FormFactor = require(Parent.FormFactor).Enums.FormFactor
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function useGameFiltersFeedItemSideMargin(p1) -- line: 14
	-- upvalues: useSelector (copy), useAppPolicy (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy)
	local v13 = useSelector(function(p2) -- line: 15
		return p2.FormFactor
	end)
	local v14 = if not useAppPolicy(function(p3) -- line: 19
		return p3.useGridPageLayout()
	end) then {
		sideMargin = if v13 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING
	} else nil

	return useCollectionLayoutParams(CollectionItemSize.Small, p1, false, v14).sideMargin
end

return useGameFiltersFeedItemSideMargin
