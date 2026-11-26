local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactOtter")

local function useAnimateFullscreen(p2, p3, p4)
	local v5 = p3 ~= nil
	local v6 = p2 and v5 and 0 or 1
	local state, setState = React.useState(v6)

	local state2, setState2 = React.useState(false)
	local v7 = React.useCallback(function()
		setState2(false)
	end, {})

	local v8, v9 = ReactOtter.useAnimatedBinding(v6, v7)

	React.useEffect(function(): nil
		if v6 == state then
			return nil
		end

		setState(v6)
		setState2(true)
		v9(ReactOtter.spring(v6, p4))
		return nil
	end, { v6, state, p4 })

	if state2 or p2 then
		p2 = v5
	end

	return p2, v8
end

return useAnimateFullscreen
