local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local mutedError = require(Parent.Loggers).mutedError

local function interpolateColors(n1: number, p1, p2) -- line: 19
	-- upvalues: mutedError (copy)
	local p1Color3 = p1.Color3
	local p2Color3 = p2.Color3
	local p1Transparency = p1.Transparency
	local p2Transparency = p2.Transparency

	if p1Color3 == nil or (p2Color3 == nil or p1Transparency == nil or p2Transparency == nil) then
		mutedError("useCategoryPillColorAnimation: ColorStyle is nil")

		return p1
	end

	return {
		Color3 = p1Color3:Lerp(p2Color3, n1),
		Transparency = p1Transparency + (p2Transparency - p1Transparency) * n1
	}
end
local function useCategoryPillColorAnimation(b1: boolean) -- line: 38
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), interpolateColors (copy)
	local v16 = useTokens()
	local v17, v18 = ReactOtter.useAnimatedBinding(not b1 and 0 or 1)

	React.useEffect(function() -- line: 45
		-- upvalues: b1 (copy), v18 (copy), ReactOtter (copy)
		local v21 = not b1 and 0 or 1

		if not b1 then
			v18((ReactOtter.instant(v21)))

			return
		end

		v18((ReactOtter.spring(v21, {
			frequency = 1.2,
			dampingRatio = 1
		})))
	end, { b1 })

	local v19 = v17:map(function(p3) -- line: 60
		-- upvalues: interpolateColors (copy), v16 (copy)
		return (interpolateColors(p3, v16.Color.ActionStandard.Background, v16.Color.ActionSubEmphasis.Background))
	end)
	local v20 = v17:map(function(p4) -- line: 68
		-- upvalues: interpolateColors (copy), v16 (copy)
		return (interpolateColors(p4, v16.Color.ActionStandard.Foreground, v16.Color.ActionSubEmphasis.Foreground))
	end)

	return {
		animatedBackgroundStyle = v19,
		animatedTextStyle = v20
	}
end

return useCategoryPillColorAnimation
