local parent = script:FindFirstAncestor("Style").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ColorMode = Foundation.Enums.ColorMode
local getSceneOverridesStore = require(script.Parent.getSceneOverridesStore)

local function SceneOverridesRegistry(p)
	local isActive = p.isActive
	local v = useTokens()

	local v2 = React.useMemo(function()
		local color3 = v.Color.Extended.Gray.Gray_300.Color3
		local color3_2 = v.Color.Extended.Gray.Gray_400.Color3
		local color3_3 = v.Color.Extended.Gray.Gray_500.Color3
		local color3_4 = v.Color.Extended.Gray.Gray_700.Color3
		local color3_5 = v.Color.Extended.Gray.Gray_800.Color3
		local color3_6 = v.Color.Extended.Gray.Gray_900.Color3
		local color3_7 = v.Color.Extended.Gray.Gray_1100.Color3

		local color3_8 = v.Color.Surface.Surface_200.Color3
		local color3_9 = v.Color.Surface.Surface_100.Color3

		if v.Config.ColorMode.Name == ColorMode.Light then
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
	end, { v })

	React.useEffect(function()
		local sceneOverridesStore = getSceneOverridesStore()

		if not isActive then
			return
		end

		sceneOverridesStore.setSceneOverrides(v2)
		return function()
			sceneOverridesStore.setSceneOverrides(nil)
		end
	end, { isActive, v2 })

	return p.children
end

return SceneOverridesRegistry
