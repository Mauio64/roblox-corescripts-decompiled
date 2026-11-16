local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/ReactOtter")

local v5 = { frequency = 3, dampingRatio = 1 }

local function useImageLoadFade()
	local state, setState = React.useState(true)

	local v6, v7 = ReactOtter.useAnimatedBinding(0, function()
		setState(false)
	end)

	return {
		onLoaded = React.useCallback(function(p2)
			if p2 == Enum.AssetFetchStatus.Success then
				v7(ReactOtter.spring(1, v5))
			end
		end, {}),
		skeletonVisible = state,
		overlayTransparency = v6
	}
end

return useImageLoadFade
