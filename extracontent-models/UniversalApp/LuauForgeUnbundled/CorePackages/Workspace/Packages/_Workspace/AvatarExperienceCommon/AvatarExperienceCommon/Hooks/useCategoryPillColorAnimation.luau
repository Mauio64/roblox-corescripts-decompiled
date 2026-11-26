local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactOtter")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation").Hooks.useTokens

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Loggers").mutedError

local function interpolateColors(p2, p3, p4)
	local color3 = p3.Color3
	local color3_2 = p4.Color3
	local transparency = p3.Transparency
	local transparency2 = p4.Transparency

	if color3 ~= nil and color3_2 ~= nil and transparency ~= nil and transparency2 ~= nil then
		return {
			Color3 = color3:Lerp(color3_2, p2),
			Transparency = transparency + (transparency2 - transparency) * p2
		}
	end

	mutedError("useCategoryPillColorAnimation: ColorStyle is nil")
	return p3
end

local function useCategoryPillColorAnimation(p2)
	local v5 = useTokens()

	local v6, v7 = ReactOtter.useAnimatedBinding(p2 and 1 or 0)

	React.useEffect(function()
		local v8 = p2 and 1 or 0

		if p2 then
			v7(ReactOtter.spring(v8, { frequency = 1.2, dampingRatio = 1 }))
		else
			v7(ReactOtter.instant(v8))
		end
	end, { p2 })

	return {
		animatedBackgroundStyle = v6:map(function(p3)
			return interpolateColors(
				p3,
				v5.Color.ActionStandard.Background,
				v5.Color.ActionSubEmphasis.Background
			)
		end),
		animatedTextStyle = v6:map(function(p3)
			return interpolateColors(
				p3,
				v5.Color.ActionStandard.Foreground,
				v5.Color.ActionSubEmphasis.Foreground
			)
		end)
	}
end

return useCategoryPillColorAnimation
