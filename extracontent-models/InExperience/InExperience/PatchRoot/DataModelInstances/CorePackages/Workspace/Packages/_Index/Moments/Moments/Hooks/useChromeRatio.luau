local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactOtter = require(MomentsParent.ReactOtter)
local Signals = require(MomentsParent.Signals)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local t1 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function useChromeRatio() -- line: 35
	-- upvalues: GetFFlagMomentsImmersiveChrome (copy), GetImmersiveChromeStore (copy), ReactOtter (copy), React (copy), Signals (copy), t1 (copy)
	local v10 = GetFFlagMomentsImmersiveChrome()
	local v11 = GetImmersiveChromeStore(false)
	local v12, v13 = ReactOtter.useAnimatedBinding(1)

	React.useEffect(function() -- line: 41
		-- upvalues: v10 (copy), Signals (copy), v11 (copy), v13 (copy), ReactOtter (copy), t1 (copy)
		if not v10 then
			return
		end

		return (Signals.createEffect(function(p1) -- line: 45
			-- upvalues: v11 (copy), v13 (copy), ReactOtter (copy), t1 (copy)
			local v15 = v11.getChromeVisible(p1)

			v13((ReactOtter.spring(not v15 and 0 or 1, t1)))
		end))
	end, {
		v10,
		v11
	})

	return v12
end

return useChromeRatio
