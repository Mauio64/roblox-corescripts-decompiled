local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)

local calculateItemWidth = require(CollectionViews.calculateItemWidth)
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local function getItemSize(p: number, p2: number, p3: number, x: number, p4: number, callback, p5: number?) -- 1 equivalent call inferred from this helper
	local v = calculateItemWidth(p, p2, p3, x, p4, p5)
	local v2 = callback(v)
	return Vector2.new(v, v2)
end

local function useCollectionSizeBindings(p: number, p2: number, p3: number, p4: number, callback, callback2, p5: number?)
	local v = useStore()
	local v2, v3 = React.useBinding(Vector2.zero)

	if v2:getValue() == Vector2.zero then
		v3(v:getState().ScreenSize)
	end

	local v4, v5 = React.useBinding(getItemSize(p, p2, p3, v2:getValue() and v2:getValue().X or 0, p4, callback, p5))

	local state, setState = React.useState(nil)
	local v6 = React.useCallback(function(p6)
		local absoluteSize = p6.AbsoluteSize

		if absoluteSize.X == 0 then
			return
		end

		if callback2 then
			callback2(absoluteSize)
		end

		v3(absoluteSize)

		local itemSize = getItemSize(p, p2, p3, absoluteSize and absoluteSize.X or 0, p4, callback, p5) -- inferred equivalent call

		v5(itemSize)
	end, { p, p2, p3, p4, callback, callback2, p5 })

	React.useEffect(function()
		if state then
			v6(state)
		end
	end, { v6, state })

	return v4, v2, v6, setState
end

return useCollectionSizeBindings
