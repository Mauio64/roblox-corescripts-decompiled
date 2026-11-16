local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local react = dependencies.React
local reactOtter = dependencies.ReactOtter

require(CrossExperienceVoice.Common.Types)

return function(p: number)
	local ref = react.useRef(nil)
	local v, v2 = reactOtter.useAnimatedBinding(p, function()
		if ref.current then
			ref.current()
			ref.current = nil
		end
	end)

	return v, (react.useCallback(function(p2, callback)
		local function animateStep(data, current)
			ref.current = current
			v2(reactOtter.ease(data.value, {
				duration = data.durationInMs / 1000,
				easingStyle = data.easingStyle
			}))
		end

		local function animateImpl(p3, p4: number, callback2)
			local v3 = p3[p4]

			if v3 ~= nil then
				function ref.current()
					if callback2 then
						callback2(p4)
					end

					animateImpl(p3, p4 + 1, callback2)
				end

				v2(reactOtter.ease(v3.value, {
					duration = v3.durationInMs / 1000,
					easingStyle = v3.easingStyle
				}))
			end
		end

		return animateImpl(p2, 1, callback)
	end, {}))
end
