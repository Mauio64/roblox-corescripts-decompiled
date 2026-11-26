local function defaultLoadAnimation(animator, animation)
	return animator:LoadAnimation(animation)
end

local v5 = defaultLoadAnimation

local function getAnimator(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		return nil
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")

	if animator then
		return animator
	end

	local animator2 = Instance.new("Animator")
	animator2.Parent = humanoid
	return animator2
end

return {
	play = function(instance)
		local humanoid = instance:FindFirstChildOfClass("Humanoid")
		local v6

		if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
			v6 = humanoid:FindFirstChildOfClass("Animator")

			if not v6 then
				v6 = Instance.new("Animator")
				v6.Parent = humanoid
			end
		end

		if not v6 then
			return nil
		end

		local wave = Instance.new("Animation")
		wave.Name = "Wave"
		wave.AnimationId = "rbxassetid://128777973"
		wave.Parent = v6

		local v7 = v5(v6, wave)

		v7.Priority = Enum.AnimationPriority.Action
		v7.Looped = true
		v7:Play()
		return { track = v7, animation = wave }
	end,
	stop = function(p2)
		if not p2 then
			return
		end

		p2.track:Stop()
		p2.track:Destroy()
		p2.animation:Destroy()
	end,
	setLoadAnimationForTesting = function(p2)
		v5 = p2 or defaultLoadAnimation
	end
}
