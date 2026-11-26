local useSequentialAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useSequentialAnimation")

return function(p2, p3, p4)
	local v5, v6 = useSequentialAnimation(p2)

	local function animate(p5)
		v6({
			{ value = p5, durationInMs = p3, easingStyle = p4 }
		}, nil)
	end

	return v5, animate
end
