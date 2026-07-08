local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local useSequentialAnimation = require(CrossExperienceVoice.Hooks.useSequentialAnimation)

return function(n1: number, n2: number, p1) -- line: 5
	-- upvalues: useSequentialAnimation (copy)
	local v6, v7 = useSequentialAnimation(n1)

	local function animate(n3: number) -- line: 8
		-- upvalues: v7 (copy), n2 (copy), p1 (copy)
		v7({{
			value = n3,
			durationInMs = n2,
			easingStyle = p1
		}}, nil)
	end

	return v6, animate
end
