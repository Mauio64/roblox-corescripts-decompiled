local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local Foundation = require(CollectionViewsParent.Foundation)
local React = require(CollectionViewsParent.React)
local SignalsReact = require(CollectionViewsParent.SignalsReact)
local AppComposition = require(CollectionViewsParent.AppComposition)
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local CollectionLayoutStoreContext = require(CollectionViews.CollectionLayoutStore.CollectionLayoutStoreContext)
local getMainCollectionLayoutStore = require(CollectionViews.CollectionLayoutStore.getMainCollectionLayoutStore)

local function useCollectionLayout(p1) -- line: 23
	-- upvalues: Foundation (copy), CollectionItemSize (copy), AppComposition (copy), React (copy), CollectionLayoutStoreContext (copy), getMainCollectionLayoutStore (copy), SignalsReact (copy)
	local v12 = Foundation.Hooks.useTokens()
	local v13 = p1 or CollectionItemSize.Small
	local v14 = AppComposition.useCompositionLayout()
	local v15 = React.useContext(CollectionLayoutStoreContext) or getMainCollectionLayoutStore(false)
	local v16 = SignalsReact.useSignalState(v15.getItemsPerRow[v13])

	return React.useMemo(function() -- line: 33
		-- upvalues: v14 (copy), v12 (copy), v16 (copy), v15 (copy)
		return {
			margin = v14.margin,
			gutter = v14.gutter,
			carouselPeek = v14.carouselPeek,
			verticalGap = v12.Gap.Large,
			itemsPerRow = v16,
			getContainerWidth = v15.getContainerWidth,
			getDesignSpaceContainerWidth = v15.getDesignSpaceContainerWidth
		}
	end, {
		v14,
		v16,
		v12,
		v15
	})
end

return useCollectionLayout
