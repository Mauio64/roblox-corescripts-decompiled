local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local CollectionViewTypes = require(CollectionViews.CollectionViewTypes)
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = require(CollectionViews.useCollectionLayoutParams)
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local DiscoveryTypes = require(parent.DiscoveryTypes)
local AppComposition = require(parent.AppComposition)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function usePageSideMargin(p, flag: boolean?)
	local margin = AppComposition.useCompositionLayout().margin

	if FFlagLuaAppCompositionAlways then
		return margin
	end

	local v = useSelector(function(p2)
		return p2.FormFactor
	end)
	local v2

	if not useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end) then
		v2 = { sideMargin = 0 }
		local sideMargin

		if v == formFactor.COMPACT then
			sideMargin = GAME_CAROUSEL_SIDE_COMPACT_PADDING
		else
			sideMargin = GAME_CAROUSEL_SIDE_WIDE_PADDING
		end

		v2.sideMargin = sideMargin
	end

	local v3 = useCollectionLayoutParams(CollectionItemSize.Small, p, false, v2)

	return if flag then margin else v3.sideMargin
end

return usePageSideMargin
