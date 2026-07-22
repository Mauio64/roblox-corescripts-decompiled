local Parent = script:FindFirstAncestor("Style").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Theme = Foundation.Enums.Theme
local getSceneOverridesStore = require(script.Parent.getSceneOverridesStore)

local function SceneOverridesRegistry(t1: {[any]: any}) -- line: 14
	-- upvalues: useTokens (copy), React (copy), Theme (copy), getSceneOverridesStore (copy)
	local isActive = t1.isActive
	local v10 = useTokens()
	local v11 = React.useMemo(function() -- line: 18
		-- upvalues: v10 (copy), Theme (copy)
		local Gray_300Color3 = v10.Color.Extended.Gray.Gray_300.Color3
		local Gray_400Color3 = v10.Color.Extended.Gray.Gray_400.Color3
		local Gray_500Color3 = v10.Color.Extended.Gray.Gray_500.Color3
		local Gray_700Color3 = v10.Color.Extended.Gray.Gray_700.Color3
		local Gray_800Color3 = v10.Color.Extended.Gray.Gray_800.Color3
		local Gray_900Color3 = v10.Color.Extended.Gray.Gray_900.Color3
		local Gray_1100Color3 = v10.Color.Extended.Gray.Gray_1100.Color3
		local Surface_200Color3 = v10.Color.Surface.Surface_200.Color3
		local Surface_100Color3 = v10.Color.Surface.Surface_100.Color3

		if v10.Config.ColorMode.Name == Theme.Light then
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
	end, { v10 })

	React.useEffect(function() -- line: 59
		-- upvalues: getSceneOverridesStore (copy), isActive (copy), v11 (copy)
		local v21 = getSceneOverridesStore()

		if not isActive then
			return
		end

		v21.setSceneOverrides(v11)

		return function() -- line: 66
			-- upvalues: v21 (copy)
			v21.setSceneOverrides(nil)
		end
	end, {
		isActive,
		v11
	})

	return t1.children
end

return SceneOverridesRegistry
