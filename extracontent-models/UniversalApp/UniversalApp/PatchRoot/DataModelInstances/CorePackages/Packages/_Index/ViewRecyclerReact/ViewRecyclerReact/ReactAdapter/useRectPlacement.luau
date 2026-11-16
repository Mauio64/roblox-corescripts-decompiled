local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local React = require(ViewRecyclerReact.Parent.React)
local RectPlacement = require(ViewRecyclerReact.ReactAdapter.Private.RectPlacement)
local useRecyclingScope = require(ViewRecyclerReact.ReactAdapter.Private.useRecyclingScope)

local function useRectPlacement(current)
	local v = useRecyclingScope("useRectPlacement")
	local ref = React.useRef(current)
	ref.current = current
	local v2 = React.useState(function()
		local internal = RectPlacement.new(v, function()
			return ref.current
		end)

		return {
			internal = internal,
			public = table.freeze({ sync = internal.sync })
		}
	end)

	React.useLayoutEffect(function()
		return v2.internal.releaseAll
	end, { v2 })

	return v2.public
end

return useRectPlacement
