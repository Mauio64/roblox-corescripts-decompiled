local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SignalsReact")
local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/AppComposition")

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize
local CollectionLayoutStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionLayoutStoreContext")
local getMainCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/getMainCollectionLayoutStore")

local function useCollectionLayout(p2)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = p2 or collectionItemSize.Small

	local v7 = AppComposition.useCompositionLayout()
	local v8 = React.useContext(CollectionLayoutStoreContext) or getMainCollectionLayoutStore(false)

	local v9 = SignalsReact.useSignalState(v8.getItemsPerRow[v6])

	return React.useMemo(function()
		return {
			margin = v7.margin,
			gutter = v7.gutter,
			carouselPeek = v7.carouselPeek,
			verticalGap = v5.Gap.Large,
			itemsPerRow = v9,
			getContainerWidth = v8.getContainerWidth,
			getDesignSpaceContainerWidth = v8.getDesignSpaceContainerWidth
		}
	end, { v7, v9, v5, v8 })
end

return useCollectionLayout
