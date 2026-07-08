local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local useDesignTokens = require(CollectionViewsParent.Style).useDesignTokens
local useTokens = require(CollectionViewsParent.Foundation).Hooks.useTokens
local usePreferredInput = require(CollectionViewsParent.Responsive).usePreferredInput
local Display = require(CollectionViewsParent.Display)
local useStore = require(CollectionViewsParent.RoactUtils).Hooks.RoactRodux.useStore
local CollectionLayoutCalculators = require(CollectionViews.CollectionLayoutCalculators)
local calculateItemWidth = require(CollectionViews.calculateItemWidth)

require(CollectionViews.CollectionViewTypes)

local FFlagLuaAppLayoutParamsInContext = require(CollectionViewsParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local v12 = game:DefineFastFlag("LuaAppUseDisplayStoreForCollectionLayoutParams", false)

local function useCollectionLayoutParams(p1, p2, b1: boolean?, t1: {[any]: any}?, p3, vector2: Vector2?) -- line: 35
	-- upvalues: useStore (copy), v12 (copy), Display (copy), CollectionLayoutCalculators (copy), FFlagLuaAppLayoutParamsInContext (copy), useTokens (copy), useDesignTokens (copy), usePreferredInput (copy), React (copy), calculateItemWidth (copy)
	local v20 = useStore()
	local v21 = if not v12 then v20:getState().ScreenSize or Vector2.new(0, 0) else Display.GetDisplayStore(false).getViewportSize(false) or Vector2.new(0, 0)
	local v22 = p3 or CollectionLayoutCalculators
	local v23 = t1 and t1.sideMargin or nil
	local v24 = t1 and t1.columnGap or nil
	local v25 = t1 and t1.numColumns or nil
	local v26 = t1 and t1.fractionalItemAmount or nil
	local v27 = t1 and t1.loadMoreThreshold or nil
	local v28 = t1 and t1.verticalPadding or nil
	local v29 = if not FFlagLuaAppLayoutParamsInContext then useDesignTokens() else useTokens()
	local v30 = usePreferredInput()
	local v31 = v28 or v22.calculateVerticalPadding(v29, p1)
	local v32 = v22.calculateMaxTilesToShow(v30)
	local v33 = React.useRef(nil)

	if v33.current == nil then
		v33.current = vector2 or v21
	end

	local currentX = v33.current.X
	local v35, v36 = React.useState(function() -- line: 80
		-- upvalues: v23 (copy), v22 (copy), currentX (copy), v29 (copy), v21 (copy)
		return v23 or v22.calculateSideMargin(currentX, v29, v21.X)
	end)
	local v37, v38 = React.useState(function() -- line: 83
		-- upvalues: v24 (copy), v22 (copy), currentX (copy), v29 (copy), v21 (copy)
		return v24 or v22.calculateColumnGap(currentX, v29, v21.X)
	end)
	local v39, v40 = React.useState(function() -- line: 86
		-- upvalues: v26 (copy), v22 (copy), p1 (copy), v30 (copy)
		return v26 or v22.calculateFractionalItemAmount(p1, v30)
	end)
	local v41, v42 = React.useState(function() -- line: 90
		-- upvalues: v25 (copy), v22 (copy), currentX (copy), v35 (copy), v37 (copy), p1 (copy), v29 (copy)
		return v25 or v22.calculateNumColumns(currentX, v35, v37, p1, v29)
	end)
	local v43, v44 = React.useState(function() -- line: 94
		-- upvalues: v27 (copy), v22 (copy), currentX (copy)
		return v27 or v22.calculateLoadMoreThreshold(currentX)
	end)
	local v45, v46 = React.useState(function() -- line: 99
		-- upvalues: b1 (copy), calculateItemWidth (copy), v41 (copy), v37 (copy), v35 (copy), currentX (copy), v39 (copy)
		if b1 then
			return calculateItemWidth(v41, v37, v35, currentX, v39)
		end

		return 1
	end)
	local v47 = React.useCallback(function(vector2_2: Vector2) -- line: 108
		-- upvalues: v12 (copy), Display (copy), v20 (copy), v23 (copy), v22 (copy), v29 (copy), v36 (copy), v24 (copy), v38 (copy), v25 (copy), p1 (copy), v42 (copy), v26 (copy), v30 (copy), v40 (copy), v27 (copy), v44 (copy), v33 (copy), b1 (copy), calculateItemWidth (copy), v46 (copy)
		local vector2_2X = vector2_2.X
		local v50 = if not v12 then v20:getState().ScreenSize and v20:getState().ScreenSize.X or 0 else Display.GetDisplayStore(false).getViewportSize(false) and Display.GetDisplayStore(false).getViewportSize(false).X or 0
		local v51 = v23 or v22.calculateSideMargin(vector2_2X, v29, v50)

		v36(v51)

		local v52 = v24 or v22.calculateColumnGap(vector2_2X, v29, v50)

		v38(v52)

		local v53 = v25 or v22.calculateNumColumns(vector2_2X, v51, v52, p1, v29)

		v42(v53)

		local v54 = v26 or v22.calculateFractionalItemAmount(p1, v30)

		v40(v54)

		local v55 = v27 or v22.calculateLoadMoreThreshold(vector2_2X)

		v44(v55)
		v33.current = vector2_2

		if b1 then
			local v56 = calculateItemWidth(v53, v52, v51, vector2_2X, v54)

			v46(v56)
		end
	end, {
		p1,
		b1,
		v24,
		v23,
		v25,
		v26,
		v27,
		v29,
		v20
	})

	React.useEffect(function() -- line: 168
		-- upvalues: p2 (copy), v47 (copy)
		local connection = nil

		if p2 then
			v47(p2.AbsoluteSize)
			connection = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 172
				-- upvalues: v47 (copy), p2 (copy)
				v47(p2.AbsoluteSize)
			end)
		end

		return function() -- line: 176
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v47,
		p2
	})

	return {
		numColumns = v41,
		fractionalItemAmount = v39,
		columnGap = v37,
		sideMargin = v35,
		verticalPadding = v31,
		maxTilesToShow = v32,
		itemWidth = v45,
		loadMoreThreshold = v43
	}
end

return useCollectionLayoutParams
