local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

require(AvatarViewport.Types)

local function useAvatarViewportScene()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	return React.useMemo(function()
		return { viewportFrame = ref, worldModel = ref2, camera = ref3 }
	end, { ref, ref2, ref3 })
end

return useAvatarViewportScene
