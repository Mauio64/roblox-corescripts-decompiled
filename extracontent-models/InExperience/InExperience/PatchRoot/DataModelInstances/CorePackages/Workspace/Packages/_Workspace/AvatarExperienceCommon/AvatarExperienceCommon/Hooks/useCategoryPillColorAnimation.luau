local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local function interpolateColors(p: number, p2, p3)
	local color3 = p2.Color3
	local color3_2 = p3.Color3
	local transparency = p2.Transparency
	local transparency2 = p3.Transparency

	if color3 ~= nil and color3_2 ~= nil and transparency ~= nil and transparency2 ~= nil then
		return {
			Color3 = color3:Lerp(color3_2, p),
			Transparency = transparency + (transparency2 - transparency) * p
		}
	end

	mutedError("useCategoryPillColorAnimation: ColorStyle is nil")
	return p2
end

local function useCategoryPillColorAnimation(flag: boolean)
	local v = useTokens()

	local v2, v3 = ReactOtter.useAnimatedBinding(flag and 1 or 0)

	React.useEffect(function()
		local v4 = flag and 1 or 0

		if flag then
			v3((ReactOtter.spring(v4, { frequency = 1.2, dampingRatio = 1 })))
		else
			v3((ReactOtter.instant(v4)))
		end
	end, { flag })

	return {
		animatedBackgroundStyle = v2:map(function(p)
			return interpolateColors(p, v.Color.ActionStandard.Background, v.Color.ActionSubEmphasis.Background)
		end),
		animatedTextStyle = v2:map(function(p)
			return interpolateColors(p, v.Color.ActionStandard.Foreground, v.Color.ActionSubEmphasis.Foreground)
		end)
	}
end

return useCategoryPillColorAnimation
