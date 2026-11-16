local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")

local calculateItemWidth = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateItemWidth")
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/RoactUtils").Hooks.RoactRodux.useStore

local function getItemSize(p2, p3, p4, x, p5, callback, p6)
	local v5 = calculateItemWidth(p2, p3, p4, x, p5, p6)
	local v6 = callback(v5)
	return Vector2.new(v5, v6)
end

local function useCollectionSizeBindings(p2, p3, p4, p5, p6, callback, p7)
	local v5 = useStore()
	local v6, v7 = React.useBinding(Vector2.zero)

	if v6:getValue() == Vector2.zero then
		v7(v5:getState().ScreenSize)
	end

	local v8, v9 = React.useBinding(getItemSize(
		p2,
		p3,
		p4,
		v6:getValue() and v6:getValue().X or 0,
		p5,
		p6,
		p7
	))

	local state, setState = React.useState(nil)
	local v10 = React.useCallback(function(p8)
		local absoluteSize = p8.AbsoluteSize

		if absoluteSize.X == 0 then
			return
		end

		if callback then
			callback(absoluteSize)
		end

		v7(absoluteSize)

		local x = absoluteSize and absoluteSize.X or 0
		local v15 = calculateItemWidth(p2, p3, p4, x, p5, p7)
		local v16 = p6(v15)
		v9((Vector2.new(v15, v16)))
	end, { p2, p3, p4, p5, p6, callback, p7 })

	React.useEffect(function()
		if state then
			v10(state)
		end
	end, { v10, state })

	return v8, v6, v10, setState
end

return useCollectionSizeBindings
