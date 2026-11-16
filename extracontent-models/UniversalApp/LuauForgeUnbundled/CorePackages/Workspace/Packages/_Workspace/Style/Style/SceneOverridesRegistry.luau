local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Foundation")
local useTokens = Foundation.Hooks.useTokens
local colorMode = Foundation.Enums.ColorMode
local getSceneOverridesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/getSceneOverridesStore")

local function SceneOverridesRegistry(p2)
	local isActive = p2.isActive
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		local color3 = v5.Color.Extended.Gray.Gray_300.Color3
		local color3_2 = v5.Color.Extended.Gray.Gray_400.Color3
		local color3_3 = v5.Color.Extended.Gray.Gray_500.Color3
		local color3_4 = v5.Color.Extended.Gray.Gray_700.Color3
		local color3_5 = v5.Color.Extended.Gray.Gray_800.Color3
		local color3_6 = v5.Color.Extended.Gray.Gray_900.Color3
		local color3_7 = v5.Color.Extended.Gray.Gray_1100.Color3

		local color3_8 = v5.Color.Surface.Surface_200.Color3
		local color3_9 = v5.Color.Surface.Surface_100.Color3

		if v5.Config.ColorMode.Name == colorMode.Light then
			return {
				SkyboxBlockerColor = color3_2:Lerp(color3_8, 0.6),
				SkyboxBlockerTransparency = 0,
				BackPanel = color3_3:Lerp(color3_8, 0.6),
				Clouds = color3_3:Lerp(color3_8, 0.3),
				LargerShapes = color3_3:Lerp(color3_8, 0.4),
				AvatarParticles = color3_3:Lerp(color3_8, 0.4),
				Baseplate = color3:Lerp(color3_8, 0.2),
				FogColor = color3_2:Lerp(color3_8, 0.4),
				FogStart = 400,
				FogEnd = 500
			}
		end

		return {
			SkyboxBlockerColor = color3_5:Lerp(color3_8, 0.3),
			SkyboxBlockerTransparency = 0,
			BackPanel = color3_4:Lerp(color3_8, 0.3),
			Clouds = color3_4:Lerp(color3_8, 0.3),
			LargerShapes = color3_4:Lerp(color3_9, 0.4),
			AvatarParticles = color3_4:Lerp(color3_8, 0.4),
			Baseplate = color3_6:Lerp(color3_8, 0.2),
			FogColor = color3_7:Lerp(color3_8, 0.3),
			FogStart = 400,
			FogEnd = 500
		}
	end, { v5 })

	React.useEffect(function()
		local v7 = getSceneOverridesStore()

		if not isActive then
			return
		end

		v7.setSceneOverrides(v6)
		return function()
			v7.setSceneOverrides(nil)
		end
	end, { isActive, v6 })

	return p2.children
end

return SceneOverridesRegistry
