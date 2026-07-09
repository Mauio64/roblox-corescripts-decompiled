local Parent = script:FindFirstAncestor("Style").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Theme = Foundation.Enums.Theme
local getSceneOverridesStore = require(script.Parent.getSceneOverridesStore)
local FFlagFixUiModeStyleProviderTreeShapeRace = require(Parent.SharedFlags).FFlagFixUiModeStyleProviderTreeShapeRace

local function SceneOverridesRegistry(t1: {[any]: any}) -- line: 15
	-- upvalues: FFlagFixUiModeStyleProviderTreeShapeRace (copy), useTokens (copy), React (copy), Theme (copy), getSceneOverridesStore (copy)
	local v10 = if not FFlagFixUiModeStyleProviderTreeShapeRace then nil else t1.isActive
	local v11 = useTokens()
	local v12 = React.useMemo(function() -- line: 19
		-- upvalues: v11 (copy), Theme (copy)
		local Gray_300Color3 = v11.Color.Extended.Gray.Gray_300.Color3
		local Gray_400Color3 = v11.Color.Extended.Gray.Gray_400.Color3
		local Gray_500Color3 = v11.Color.Extended.Gray.Gray_500.Color3
		local Gray_700Color3 = v11.Color.Extended.Gray.Gray_700.Color3
		local Gray_800Color3 = v11.Color.Extended.Gray.Gray_800.Color3
		local Gray_900Color3 = v11.Color.Extended.Gray.Gray_900.Color3
		local Gray_1100Color3 = v11.Color.Extended.Gray.Gray_1100.Color3
		local Surface_200Color3 = v11.Color.Surface.Surface_200.Color3
		local Surface_100Color3 = v11.Color.Surface.Surface_100.Color3

		if v11.Config.ColorMode.Name == Theme.Light then
			return {
				SkyboxBlockerTransparency = 0,
				FogStart = 400,
				FogEnd = 500,
				SkyboxBlockerColor = Gray_400Color3:Lerp(Surface_200Color3, 0.6),
				BackPanel = Gray_500Color3:Lerp(Surface_200Color3, 0.6),
				Clouds = Gray_500Color3:Lerp(Surface_200Color3, 0.3),
				LargerShapes = Gray_500Color3:Lerp(Surface_200Color3, 0.4),
				AvatarParticles = Gray_500Color3:Lerp(Surface_200Color3, 0.4),
				Baseplate = Gray_300Color3:Lerp(Surface_200Color3, 0.2),
				FogColor = Gray_400Color3:Lerp(Surface_200Color3, 0.4)
			}
		end

		return {
			SkyboxBlockerTransparency = 0,
			FogStart = 400,
			FogEnd = 500,
			SkyboxBlockerColor = Gray_800Color3:Lerp(Surface_200Color3, 0.3),
			BackPanel = Gray_700Color3:Lerp(Surface_200Color3, 0.3),
			Clouds = Gray_700Color3:Lerp(Surface_200Color3, 0.3),
			LargerShapes = Gray_700Color3:Lerp(Surface_100Color3, 0.4),
			AvatarParticles = Gray_700Color3:Lerp(Surface_200Color3, 0.4),
			Baseplate = Gray_900Color3:Lerp(Surface_200Color3, 0.2),
			FogColor = Gray_1100Color3:Lerp(Surface_200Color3, 0.3)
		}
	end, { v11 })

	React.useEffect(function() -- line: 60
		-- upvalues: getSceneOverridesStore (copy), FFlagFixUiModeStyleProviderTreeShapeRace (copy), v10 (copy), v12 (copy)
		local v22 = getSceneOverridesStore()

		if FFlagFixUiModeStyleProviderTreeShapeRace and not v10 then
			return
		end

		v22.setSceneOverrides(v12)

		return function() -- line: 67
			-- upvalues: v22 (copy)
			v22.setSceneOverrides(nil)
		end
	end, {
		if not FFlagFixUiModeStyleProviderTreeShapeRace then nil else v10,
		v12
	})

	return t1.children
end

return SceneOverridesRegistry
