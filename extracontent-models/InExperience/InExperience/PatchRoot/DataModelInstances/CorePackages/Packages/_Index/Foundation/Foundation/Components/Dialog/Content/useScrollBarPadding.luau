local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useScrollBarPadding() -- line: 9
	-- upvalues: React (copy), useTokens (copy), isScrollingFrameOverflowingY (copy)
	local v7, v8 = React.useState(false)
	local v9 = useTokens()
	local v10, v11 = React.useBinding(0)

	return v7, v10, (React.useCallback(function(p1) -- line: 14
		-- upvalues: isScrollingFrameOverflowingY (copy), v8 (copy), v11 (copy), v9 (copy)
		local v13 = isScrollingFrameOverflowingY(p1, 1)

		v8(v13)
		v11(not v13 and 0 or v9.Size.Size_150)
	end, { v9.Size.Size_150 }))
end

return useScrollBarPadding
