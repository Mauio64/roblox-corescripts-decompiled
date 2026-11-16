local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local GetImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore")

local v5 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function useChromeRatio()
	local v6 = GetImmersiveChromeStore(false)
	local v7, v8 = ReactOtter.useAnimatedBinding(1)

	React.useEffect(function()
		return (Signals.createEffect(function(p2)
			local chromeVisible = v6.getChromeVisible(p2)
			v8(ReactOtter.spring(chromeVisible and 1 or 0, v5))
		end))
	end, { v6 })

	return v7
end

return useChromeRatio
