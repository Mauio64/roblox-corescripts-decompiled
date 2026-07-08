local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local OverlayContext = require(script.Parent.OverlayContext)

local function useScreen() -- line: 8
	-- upvalues: React (copy), OverlayContext (copy)
	local v5 = React.useContext(OverlayContext)

	React.useLayoutEffect(function() -- line: 11
		-- upvalues: v5 (copy)
		v5.requestOverlay()
	end, { v5.requestOverlay })

	return v5.screen
end

return useScreen
