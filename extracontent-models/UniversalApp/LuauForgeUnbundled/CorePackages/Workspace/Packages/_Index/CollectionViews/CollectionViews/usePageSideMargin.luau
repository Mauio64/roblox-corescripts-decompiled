local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize
local useCollectionLayoutParams = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionLayoutParams")
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/FormFactor").Enums.FormFactor
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/RoactUtils").Hooks.RoactRodux.useSelector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/UniversalAppPolicy").useAppPolicy
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryTypes")
local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/AppComposition")

local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagLuaAppCompositionAlways

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function usePageSideMargin(p2, p3)
	local margin = AppComposition.useCompositionLayout().margin

	if fFlagLuaAppCompositionAlways then
		return margin
	end

	local v5 = useSelector(function(p4)
		return p4.FormFactor
	end)
	local v6

	if not useAppPolicy(function(p4)
		return p4.useGridPageLayout()
	end) then
		v6 = { sideMargin = 0 }
		local v7 = if v5 == formFactor.COMPACT then GAME_CAROUSEL_SIDE_COMPACT_PADDING else GAME_CAROUSEL_SIDE_WIDE_PADDING
		v6.sideMargin = v7
	end

	local v7 = useCollectionLayoutParams(collectionItemSize.Small, p2, false, v6)

	if p3 then
		return margin
	end

	return v7.sideMargin
end

return usePageSideMargin
