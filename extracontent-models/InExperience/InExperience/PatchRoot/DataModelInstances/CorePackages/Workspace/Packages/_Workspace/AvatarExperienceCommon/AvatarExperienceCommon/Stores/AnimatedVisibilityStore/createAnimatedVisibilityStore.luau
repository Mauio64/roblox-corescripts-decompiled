local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Signals = require(Parent.Signals)
local Otter = require(Parent.Otter)
local t1 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function createAnimatedVisibilityStore(n1: number?) -- line: 38
	-- upvalues: Signals (copy), Otter (copy), t1 (copy)
	local v7 = n1 or 1
	local v8, v9 = Signals.createSignal(v7)
	local v10, v11 = Signals.createSignal(false)
	local v12, v13 = Signals.createSignal(v7 > 0.5)
	local v14 = Otter.createSingleMotor(v7)
	local v15 = t1

	v14:onStep(function(p1) -- line: 51
		-- upvalues: v9 (copy)
		v9(p1)
	end)
	v14:onComplete(function() -- line: 55
		-- upvalues: v11 (copy)
		v11(false)
	end)

	return {
		getVisibilityRatio = v8,
		getIsVisible = v12,
		getIsAnimating = v10,
		show = function() -- line: 60
			-- upvalues: v13 (copy), v11 (copy), v14 (copy), Otter (copy), v15 (copy)
			v13(true)
			v11(true)
			v14:setGoal(Otter.spring(1, v15))
		end,
		hide = function() -- line: 67
			-- upvalues: v13 (copy), v11 (copy), v14 (copy), Otter (copy), v15 (copy)
			v13(false)
			v11(true)
			v14:setGoal(Otter.spring(0, v15))
		end,
		destroy = function() -- line: 73
			-- upvalues: v14 (copy)
			v14:destroy()
		end
	}
end

return createAnimatedVisibilityStore
