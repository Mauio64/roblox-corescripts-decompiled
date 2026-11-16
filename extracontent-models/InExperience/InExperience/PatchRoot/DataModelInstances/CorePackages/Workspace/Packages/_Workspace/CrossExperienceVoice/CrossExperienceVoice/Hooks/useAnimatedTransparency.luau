local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")

local useSequentialAnimation = require(CrossExperienceVoice.Hooks.useSequentialAnimation)

return function(p: number, durationInMs: number, easingStyle)
	local v, v2 = useSequentialAnimation(p)

	local function animate(p2: number)
		v2({
			{ value = p2, durationInMs = durationInMs, easingStyle = easingStyle }
		}, nil)
	end

	return v, animate
end
