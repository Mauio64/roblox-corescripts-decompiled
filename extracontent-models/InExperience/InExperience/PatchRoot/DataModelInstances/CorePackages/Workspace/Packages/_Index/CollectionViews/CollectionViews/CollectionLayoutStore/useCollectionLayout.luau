local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local AppComposition = require(parent.AppComposition)

local CollectionViewTypes = require(CollectionViews.CollectionViewTypes)
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local CollectionLayoutStoreContext = require(CollectionViews.CollectionLayoutStore.CollectionLayoutStoreContext)
local getMainCollectionLayoutStore = require(CollectionViews.CollectionLayoutStore.getMainCollectionLayoutStore)

local function useCollectionLayout(p)
	local v = Foundation.Hooks.useTokens()
	local v2 = p or CollectionItemSize.Small

	local v3 = AppComposition.useCompositionLayout()
	local v4 = React.useContext(CollectionLayoutStoreContext) or getMainCollectionLayoutStore(false)

	local itemsPerRow = SignalsReact.useSignalState(v4.getItemsPerRow[v2])

	return React.useMemo(function()
		return {
			margin = v3.margin,
			gutter = v3.gutter,
			carouselPeek = v3.carouselPeek,
			verticalGap = v.Gap.Large,
			itemsPerRow = itemsPerRow,
			getContainerWidth = v4.getContainerWidth,
			getDesignSpaceContainerWidth = v4.getDesignSpaceContainerWidth
		}
	end, { v3, itemsPerRow, v, v4 })
end

return useCollectionLayout
