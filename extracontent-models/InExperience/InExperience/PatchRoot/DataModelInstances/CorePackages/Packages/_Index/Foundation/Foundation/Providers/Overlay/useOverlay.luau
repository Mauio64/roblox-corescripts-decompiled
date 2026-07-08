local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local OverlayContext = require(script.Parent.OverlayContext)
local Flags = require(Foundation.Utility.Flags)

local function useOverlay() -- line: 10
	-- upvalues: React (copy), OverlayContext (copy), Flags (copy)
	local v7 = React.useContext(OverlayContext)

	React.useLayoutEffect(function() -- line: 13
		-- upvalues: v7 (copy)
		v7.requestOverlay()
	end, if not Flags.FoundationOverlayKeyboardAwarenessHardened then {} else { v7.requestOverlay })

	return v7.instance
end

return useOverlay
