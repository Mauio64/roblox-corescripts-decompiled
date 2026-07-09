local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local CollectionViews = require(Parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useTokens = require(Parent.Foundation).Hooks.useTokens
local getPageMargin = require(Parent.UIBlox).App.Container.getPageMargin
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagFixCohubUiBugs = require(Parent.SharedFlags).FFlagFixCohubUiBugs
local FFlagAFPConnectionsChannelsHeader = require(Parent.SharedFlags).FFlagAFPConnectionsChannelsHeader

local function ConnectionChannelsCarousel(t1: {[any]: any}) -- line: 32
	-- upvalues: FFlagAFPConnectionsChannelsHeader (copy), FFlagFixCohubUiBugs (copy), useScreenSize (copy), useSelector (copy), getPageMargin (copy), React (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), useTokens (copy), CollectionCarousel (copy)
	local layoutOrder = t1.layoutOrder
	local items = t1.items
	local renderItem = t1.renderItem
	local contextualInfoHeight = t1.contextualInfoHeight
	local v19 = if not FFlagAFPConnectionsChannelsHeader then nil else t1.headerComponent
	local vector2 = nil

	if FFlagFixCohubUiBugs then
		local v21 = useScreenSize()
		local v22 = useSelector(function(p1) -- line: 42
			return p1.GlobalGuiInset and p1.GlobalGuiInset.left or 0
		end)

		vector2 = Vector2.new(v21.X - 2 * getPageMargin(v21.X) - v22, 1)
	end

	local v23, v24 = React.useState(nil)
	local v25 = useCollectionLayoutParams(CollectionItemSize.XSmall, v23, true, {
		sideMargin = 0
	}, nil, if not FFlagFixCohubUiBugs then nil else vector2)
	local v26 = useTokens()
	local v27 = nil
	local u28 = nil
	local v29 = nil

	if FFlagFixCohubUiBugs then
		local v30

		v27, v30 = React.useState(false)
		u28 = v30
		v29 = React.useCallback(function() -- line: 64
			-- upvalues: u28 (ref)
			u28(true)
		end, {})
	end

	return React.createElement(CollectionCarousel, {
		LayoutOrder = layoutOrder,
		containerRef = v24,
		items = if not FFlagFixCohubUiBugs or v27 then items else {},
		numColumns = v25.numColumns,
		fractionalItemAmount = v25.fractionalItemAmount,
		columnGap = v25.columnGap,
		onContainerSizeChanged = if not FFlagFixCohubUiBugs then nil else v29,
		headerComponent = if not FFlagAFPConnectionsChannelsHeader then nil else v19,
		renderItem = renderItem,
		getItemHeight = function(n1: number) -- line: 80
			-- upvalues: contextualInfoHeight (copy), v26 (copy)
			return n1 + contextualInfoHeight * v26.Config.UI.Scale
		end
	})
end

return ConnectionChannelsCarousel
