local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local function useAnimateFullscreen(flag: boolean, callback, p)
	local v = callback ~= nil
	local v2 = flag and v and 0 or 1
	local state, setState = React.useState(v2)

	local state2, setState2 = React.useState(false)
	local v3 = React.useCallback(function()
		setState2(false)
	end, {})

	local v4, v5 = ReactOtter.useAnimatedBinding(v2, v3)

	React.useEffect(function(): nil
		if v2 == state then
			return nil
		end

		setState(v2)
		setState2(true)
		v5(ReactOtter.spring(v2, p))
		return nil
	end, { v2, state, p })

	if state2 or flag then
		flag = v
	end

	return flag, v4
end

return useAnimateFullscreen
