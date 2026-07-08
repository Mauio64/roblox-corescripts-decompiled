local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local useCollectionLayoutParams = require(CollectionViews.useCollectionLayoutParams)
local FormFactor = require(CollectionViewsParent.FormFactor).Enums.FormFactor
local useSelector = require(CollectionViewsParent.RoactUtils).Hooks.RoactRodux.useSelector
local useAppPolicy = require(CollectionViewsParent.UniversalAppPolicy).useAppPolicy
local DiscoveryTypes = require(CollectionViewsParent.DiscoveryTypes)
local AppComposition = require(CollectionViewsParent.AppComposition)
local FFlagLuaAppCompositionAlways = require(CollectionViewsParent.SharedFlags).FFlagLuaAppCompositionAlways
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function usePageSideMargin(p1, b1: boolean?) -- line: 18
	-- upvalues: AppComposition (copy), FFlagLuaAppCompositionAlways (copy), useSelector (copy), useAppPolicy (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy)
	local margin = AppComposition.useCompositionLayout().margin

	if FFlagLuaAppCompositionAlways then
		return margin
	end

	local v17 = useSelector(function(p2) -- line: 26
		return p2.FormFactor
	end)
	local v18 = if not useAppPolicy(function(p3) -- line: 30
		return p3.useGridPageLayout()
	end) then {
		sideMargin = if v17 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING
	} else nil
	local v19 = useCollectionLayoutParams(CollectionItemSize.Small, p1, false, v18)

	if b1 then
		return margin
	end

	return v19.sideMargin
end

return usePageSideMargin
