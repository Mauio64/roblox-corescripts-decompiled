local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)

local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)

local v = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function useChromeRatio()
	local immersiveChromeStore = GetImmersiveChromeStore(false)
	local v2, v3 = ReactOtter.useAnimatedBinding(1)

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			local chromeVisible = immersiveChromeStore.getChromeVisible(p)
			v3((ReactOtter.spring(chromeVisible and 1 or 0, v)))
		end))
	end, { immersiveChromeStore })

	return v2
end

return useChromeRatio
