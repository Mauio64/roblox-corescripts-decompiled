local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Signals = require(parent.Signals)
local Otter = require(parent.Otter)

local v = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function createAnimatedVisibilityStore(value: number?)
	local v2 = value or 1

	local signal, v3 = Signals.createSignal(v2)

	local signal2, v4 = Signals.createSignal(false)

	local signal3, v5 = Signals.createSignal(v2 > 0.5)

	local singleMotor = Otter.createSingleMotor(v2)
	local v6 = v

	singleMotor:onStep(function(p)
		v3(p)
	end)

	singleMotor:onComplete(function()
		v4(false)
	end)

	return {
		getVisibilityRatio = signal,
		getIsVisible = signal3,
		getIsAnimating = signal2,
		show = function()
			v5(true)
			v4(true)
			singleMotor:setGoal(Otter.spring(1, v6))
		end,
		hide = function()
			v5(false)
			v4(true)
			singleMotor:setGoal(Otter.spring(0, v6))
		end,
		destroy = function()
			singleMotor:destroy()
		end
	}
end

return createAnimatedVisibilityStore
