local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Display = require(parent.Display)

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local CollectionLayoutCalculators = require(CollectionViews.CollectionLayoutCalculators)
local calculateItemWidth = require(CollectionViews.calculateItemWidth)
require(CollectionViews.CollectionViewTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags2.FFlagSduiComponentsUseFoundationTokens

local defineFastFlag = game:DefineFastFlag("LuaAppUseDisplayStoreForCollectionLayoutParams", false)

local function useCollectionLayoutParams(p, instance, flag: boolean?, data, p2, vector2: Vector2?)
	local v = useStore()
	local v2

	if defineFastFlag then
		v2 = Display.GetDisplayStore(false).getViewportSize(false) or Vector2.new(0, 0)
	else
		v2 = v:getState().ScreenSize or Vector2.new(0, 0)
	end

	local v3 = p2 or CollectionLayoutCalculators
	local sideMargin

	if data then
		sideMargin = data.sideMargin or nil
	else
		sideMargin = nil
	end

	local columnGap

	if data then
		columnGap = data.columnGap or nil
	else
		columnGap = nil
	end

	local numColumns

	if data then
		numColumns = data.numColumns or nil
	else
		numColumns = nil
	end

	local fractionalItemAmount

	if data then
		fractionalItemAmount = data.fractionalItemAmount or nil
	else
		fractionalItemAmount = nil
	end

	local loadMoreThreshold

	if data then
		loadMoreThreshold = data.loadMoreThreshold or nil
	else
		loadMoreThreshold = nil
	end

	local verticalPadding = data and data.verticalPadding or nil
	local v4

	if FFlagLuaAppLayoutParamsInContext or FFlagSduiComponentsUseFoundationTokens then
		v4 = useTokens()
	else
		v4 = useDesignTokens()
	end

	local v5 = usePreferredInput()

	local verticalPadding2 = verticalPadding or v3.calculateVerticalPadding(v4, p)
	local maxTilesToShow = v3.calculateMaxTilesToShow(v5)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = vector2 or v2
	end

	local x = ref.current.X

	local state, setState = React.useState(function()
		return sideMargin or v3.calculateSideMargin(x, v4, v2.X)
	end)

	local state2, setState2 = React.useState(function()
		return columnGap or v3.calculateColumnGap(x, v4, v2.X)
	end)

	local state3, setState3 = React.useState(function()
		return fractionalItemAmount or v3.calculateFractionalItemAmount(p, v5)
	end)

	local state4, setState4 = React.useState(function()
		return numColumns or v3.calculateNumColumns(x, state, state2, p, v4)
	end)

	local state5, setState5 = React.useState(function()
		return loadMoreThreshold or v3.calculateLoadMoreThreshold(x)
	end)

	local state6, setState6 = React.useState(function()
		if flag then
			return calculateItemWidth(state4, state2, state, x, state3)
		end

		return 1
	end)

	local v6 = React.useCallback(function(current: Vector2)
		local x2 = current.X
		local x3

		if defineFastFlag then
			x3 = Display.GetDisplayStore(false).getViewportSize(false)
				and Display.GetDisplayStore(false).getViewportSize(false).X
				or 0
		else
			x3 = v:getState().ScreenSize and v:getState().ScreenSize.X or 0
		end

		local v6 = sideMargin or v3.calculateSideMargin(x2, v4, x3)
		setState(v6)

		local v7 = columnGap or v3.calculateColumnGap(x2, v4, x3)
		setState2(v7)

		local v8 = numColumns or v3.calculateNumColumns(x2, v6, v7, p, v4)

		setState4(v8)

		local v9 = fractionalItemAmount or v3.calculateFractionalItemAmount(p, v5)
		setState3(v9)

		setState5(loadMoreThreshold or v3.calculateLoadMoreThreshold(x2))

		ref.current = current

		if flag then
			setState6((calculateItemWidth(v8, v7, v6, x2, v9)))
		end
	end, {
		p,
		flag,
		columnGap,
		sideMargin,
		numColumns,
		fractionalItemAmount,
		loadMoreThreshold,
		v4,
		v
	})

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			v6(instance.AbsoluteSize)
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				v6(instance.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v6, instance })

	return {
		numColumns = state4,
		fractionalItemAmount = state3,
		columnGap = state2,
		sideMargin = state,
		verticalPadding = verticalPadding2,
		maxTilesToShow = maxTilesToShow,
		itemWidth = state6,
		loadMoreThreshold = state5
	}
end

return useCollectionLayoutParams
