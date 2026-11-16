local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local react = dependencies.React
local reactOtter = dependencies.ReactOtter

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Common/Types")

return function(p2)
	local ref = react.useRef(nil)
	local v5, v6 = reactOtter.useAnimatedBinding(p2, function()
		if ref.current then
			ref.current()
			ref.current = nil
		end
	end)

	return v5, (react.useCallback(function(p3, p4)
		local function animateStep(data, current)
			ref.current = current
			v6(reactOtter.ease(data.value, {
				duration = data.durationInMs / 1000,
				easingStyle = data.easingStyle
			}))
		end

		local function animateImpl(p5, p6, callback)
			local v7 = p5[p6]

			if v7 ~= nil then
				function ref.current()
					if callback then
						callback(p6)
					end

					animateImpl(p5, p6 + 1, callback)
				end

				v6(reactOtter.ease(v7.value, {
					duration = v7.durationInMs / 1000,
					easingStyle = v7.easingStyle
				}))
			end
		end

		return animateImpl(p3, 1, p4)
	end, {}))
end
