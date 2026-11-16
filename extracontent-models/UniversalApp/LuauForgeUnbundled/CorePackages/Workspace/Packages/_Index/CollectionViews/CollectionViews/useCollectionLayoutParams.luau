local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Responsive").usePreferredInput
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Display")

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/RoactUtils").Hooks.RoactRodux.useStore

local CollectionLayoutCalculators = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutCalculators")
local calculateItemWidth = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateItemWidth")
require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagLuaAppLayoutParamsInContext
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagSduiComponentsUseFoundationTokens

local defineFastFlag = game:DefineFastFlag("LuaAppUseDisplayStoreForCollectionLayoutParams", false)

local function useCollectionLayoutParams(p2, instance, p3, data, p4, p5)
	local v5 = useStore()
	local v6

	if defineFastFlag then
		v6 = Display.GetDisplayStore(false).getViewportSize(false) or Vector2.new(0, 0)
	else
		v6 = v5:getState().ScreenSize or Vector2.new(0, 0)
	end

	local v7 = p4 or CollectionLayoutCalculators
	local sideMargin = if data then data.sideMargin or nil else nil
	local columnGap = if data then data.columnGap or nil else nil
	local numColumns = if data then data.numColumns or nil else nil
	local fractionalItemAmount = if data then data.fractionalItemAmount or nil else nil
	local loadMoreThreshold = if data then data.loadMoreThreshold or nil else nil
	local verticalPadding = data and data.verticalPadding or nil
	local v8

	if fFlagLuaAppLayoutParamsInContext or fFlagSduiComponentsUseFoundationTokens then
		v8 = useTokens()
	else
		v8 = useDesignTokens()
	end

	local v9 = usePreferredInput()

	local v10 = verticalPadding or v7.calculateVerticalPadding(v8, p2)
	local maxTilesToShow = v7.calculateMaxTilesToShow(v9)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = p5 or v6
	end

	local x = ref.current.X

	local state, setState = React.useState(function()
		return sideMargin or v7.calculateSideMargin(x, v8, v6.X)
	end)

	local state2, setState2 = React.useState(function()
		return columnGap or v7.calculateColumnGap(x, v8, v6.X)
	end)

	local state3, setState3 = React.useState(function()
		return fractionalItemAmount or v7.calculateFractionalItemAmount(p2, v9)
	end)

	local state4, setState4 = React.useState(function()
		return numColumns or v7.calculateNumColumns(x, state, state2, p2, v8)
	end)

	local state5, setState5 = React.useState(function()
		return loadMoreThreshold or v7.calculateLoadMoreThreshold(x)
	end)

	local state6, setState6 = React.useState(function()
		if p3 then
			return calculateItemWidth(state4, state2, state, x, state3)
		end

		return 1
	end)

	local v11 = React.useCallback(function(current)
		local x2 = current.X
		local x3

		if defineFastFlag then
			x3 = Display.GetDisplayStore(false).getViewportSize(false)
				and Display.GetDisplayStore(false).getViewportSize(false).X
				or 0
		else
			x3 = v5:getState().ScreenSize and v5:getState().ScreenSize.X or 0
		end

		local v12 = sideMargin or v7.calculateSideMargin(x2, v8, x3)
		setState(v12)

		local v13 = columnGap or v7.calculateColumnGap(x2, v8, x3)
		setState2(v13)

		local v14 = numColumns or v7.calculateNumColumns(x2, v12, v13, p2, v8)

		setState4(v14)

		local v15 = fractionalItemAmount or v7.calculateFractionalItemAmount(p2, v9)
		setState3(v15)

		setState5(loadMoreThreshold or v7.calculateLoadMoreThreshold(x2))

		ref.current = current

		if p3 then
			setState6((calculateItemWidth(v14, v13, v12, x2, v15)))
		end
	end, {
		p2,
		p3,
		columnGap,
		sideMargin,
		numColumns,
		fractionalItemAmount,
		loadMoreThreshold,
		v8,
		v5
	})

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			v11(instance.AbsoluteSize)
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				v11(instance.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v11, instance })

	return {
		numColumns = state4,
		fractionalItemAmount = state3,
		columnGap = state2,
		sideMargin = state,
		verticalPadding = v10,
		maxTilesToShow = maxTilesToShow,
		itemWidth = state6,
		loadMoreThreshold = state5
	}
end

return useCollectionLayoutParams
