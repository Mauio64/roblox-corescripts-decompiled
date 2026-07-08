local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local calculateItemWidth = require(CollectionViews.calculateItemWidth)
local useStore = require(CollectionViewsParent.RoactUtils).Hooks.RoactRodux.useStore
local v6 = game:DefineFastFlag("LuaAppFixCollectionSizeBindingsZero", false)

local function getItemSize(n1: number, n2: number, n3: number, n4: number, n5: number, p1: ((...any) -> ...any), n6: number?) -- line: 12
	-- upvalues: calculateItemWidth (copy)
	local v16 = calculateItemWidth(n1, n2, n3, n4, n5, n6)
	local v17 = p1(v16)

	return Vector2.new(v16, v17)
end
local function useCollectionSizeBindings(n7: number, n8: number, n9: number, n10: number, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, n11: number?) -- line: 31
	-- upvalues: useStore (copy), React (copy), getItemSize (copy), v6 (copy), calculateItemWidth (copy)
	local v25 = useStore()
	local v26, v27 = React.useBinding(Vector2.zero)

	if v26:getValue() == Vector2.zero then
		v27(v25:getState().ScreenSize)
	end

	local v28, v29 = React.useBinding(getItemSize(n7, n8, n9, v26:getValue() and v26:getValue().X or 0, n10, p2, n11))
	local v30, v31 = React.useState(nil)
	local v32 = React.useCallback(function(p4) -- line: 60
		-- upvalues: v6 (copy), p3 (copy), v27 (copy), n7 (copy), n8 (copy), n9 (copy), n10 (copy), p2 (copy), n11 (copy), calculateItemWidth (copy), v29 (copy)
		local AbsoluteSize = p4.AbsoluteSize

		if v6 and AbsoluteSize.X == 0 then
			return
		end

		if p3 then
			p3(AbsoluteSize)
		end

		v27(AbsoluteSize)

		local v35 = n7
		local v36 = n8
		local v37 = n9
		local v38 = AbsoluteSize and AbsoluteSize.X or 0
		local v39 = n10
		local v40 = p2
		local v41 = n11
		local v42 = calculateItemWidth(v35, v36, v37, v38, v39, v41)
		local v43 = v40(v42)
		local vector2 = Vector2.new(v42, v43)

		v29(vector2)
	end, {
		n7,
		n8,
		n9,
		n10,
		p2,
		p3,
		n11
	})

	React.useEffect(function() -- line: 93
		-- upvalues: v30 (copy), v32 (copy)
		if v30 then
			v32(v30)
		end
	end, {
		v32,
		v30
	})

	return v28, v26, v32, v31
end

return useCollectionSizeBindings
