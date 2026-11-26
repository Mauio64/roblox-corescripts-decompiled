local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Otter")

local v5 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function createAnimatedVisibilityStore(value)
	local v6 = value or 1

	local signal, v7 = Signals.createSignal(v6)

	local signal2, v8 = Signals.createSignal(false)

	local signal3, v9 = Signals.createSignal(v6 > 0.5)

	local singleMotor = Otter.createSingleMotor(v6)
	local v10 = v5

	singleMotor:onStep(function(p2)
		v7(p2)
	end)

	singleMotor:onComplete(function()
		v8(false)
	end)

	return {
		getVisibilityRatio = signal,
		getIsVisible = signal3,
		getIsAnimating = signal2,
		show = function()
			v9(true)
			v8(true)
			singleMotor:setGoal(Otter.spring(1, v10))
		end,
		hide = function()
			v9(false)
			v8(true)
			singleMotor:setGoal(Otter.spring(0, v10))
		end,
		destroy = function()
			singleMotor:destroy()
		end
	}
end

return createAnimatedVisibilityStore
