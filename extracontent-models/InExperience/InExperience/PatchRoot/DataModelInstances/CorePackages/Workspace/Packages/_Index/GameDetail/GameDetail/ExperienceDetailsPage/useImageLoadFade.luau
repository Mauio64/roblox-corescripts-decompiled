local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local t1 = {
	frequency = 3,
	dampingRatio = 1
}

local function useImageLoadFade() -- line: 18
	-- upvalues: React (copy), ReactOtter (copy), t1 (copy)
	local v6, v7 = React.useState(true)
	local v8, v9 = ReactOtter.useAnimatedBinding(0, function() -- line: 21
		-- upvalues: v7 (copy)
		v7(false)
	end)

	return {
		onLoaded = React.useCallback(function(p1) -- line: 25
			-- upvalues: v9 (copy), ReactOtter (copy), t1 (copy)
			if p1 == Enum.AssetFetchStatus.Success then
				v9((ReactOtter.spring(1, t1)))
			end
		end, {}),
		skeletonVisible = v6,
		overlayTransparency = v8
	}
end

return useImageLoadFade
