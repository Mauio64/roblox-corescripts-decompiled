local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local React = dependencies.React
local ReactOtter = dependencies.ReactOtter

require(CrossExperienceVoice.Common.Types)

return function(n1: number) -- line: 11
	-- upvalues: React (copy), ReactOtter (copy)
	local v6 = React.useRef(nil)
	local v7, v8 = ReactOtter.useAnimatedBinding(n1, function() -- line: 13
		-- upvalues: v6 (copy)
		if v6.current then
			v6.current()
			v6.current = nil
		end
	end)

	return v7, (React.useCallback(function(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 20
		-- upvalues: v6 (copy), v8 (copy), ReactOtter (copy)
		local function animateStep(p2, p3: ((...any) -> ...any)) -- line: 21
			-- upvalues: v6 (copy), v8 (copy), ReactOtter (copy)
			v6.current = p3
			v8(ReactOtter.ease(p2.value, {
				duration = p2.durationInMs / 1000,
				easingStyle = p2.easingStyle
			}))
		end
		local function animateImpl(t2: {[any]: any}, n2: number, p4: ((...any) -> ...any)?) -- line: 29
			-- upvalues: animateImpl (copy), v6 (copy), v8 (copy), ReactOtter (copy)
			local v18 = t2[n2]

			if v18 ~= nil then
				function v6.current() -- line: 32
					-- upvalues: p4 (copy), n2 (copy), animateImpl (copy), t2 (copy)
					if p4 then
						p4(n2)
					end

					animateImpl(t2, n2 + 1, p4)
				end

				v8(ReactOtter.ease(v18.value, {
					duration = v18.durationInMs / 1000,
					easingStyle = v18.easingStyle
				}))
			end
		end

		return animateImpl(t1, 1, p1)
	end, {}))
end
