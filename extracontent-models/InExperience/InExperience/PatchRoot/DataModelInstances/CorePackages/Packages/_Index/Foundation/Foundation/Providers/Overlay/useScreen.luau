local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local OverlayContext = require(script.Parent.OverlayContext)

local function useScreen()
	local v = React.useContext(OverlayContext)

	React.useLayoutEffect(function()
		v.requestOverlay()
	end, { v.requestOverlay })

	return v.screen
end

return useScreen
