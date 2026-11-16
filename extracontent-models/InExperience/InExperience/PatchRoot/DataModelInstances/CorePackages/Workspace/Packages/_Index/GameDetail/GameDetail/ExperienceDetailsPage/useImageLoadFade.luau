local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local v = { frequency = 3, dampingRatio = 1 }

local function useImageLoadFade()
	local state, setState = React.useState(true)

	local overlayTransparency, v2 = ReactOtter.useAnimatedBinding(0, function()
		setState(false)
	end)

	return {
		onLoaded = React.useCallback(function(p)
			if p == Enum.AssetFetchStatus.Success then
				v2((ReactOtter.spring(1, v)))
			end
		end, {}),
		skeletonVisible = state,
		overlayTransparency = overlayTransparency
	}
end

return useImageLoadFade
