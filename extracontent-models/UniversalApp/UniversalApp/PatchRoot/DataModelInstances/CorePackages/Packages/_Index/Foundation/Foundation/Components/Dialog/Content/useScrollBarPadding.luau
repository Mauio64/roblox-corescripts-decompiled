local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useScrollBarPadding()
	local state, setState = React.useState(false)
	local v = useTokens()
	local v2, v3 = React.useBinding(0)

	return state, v2, (React.useCallback(function(p)
		local scrollingFrameOverflowingY = isScrollingFrameOverflowingY(p, 1)
		setState(scrollingFrameOverflowingY)
		v3(not scrollingFrameOverflowingY and 0 or v.Size.Size_150)
	end, { v.Size.Size_150 }))
end

return useScrollBarPadding
