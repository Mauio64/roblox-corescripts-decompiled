local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Navigation = require(AvatarExperienceCommonParent.Navigation)
local SafeAppStorageService = require(AvatarExperienceCommon.Lib.SafeAppStorageService)
local AvatarExperienceNavigation = require(AvatarExperienceCommonParent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local useSelector = require(AvatarExperienceCommonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useIsSpatial = require(AvatarExperienceCommonParent.Responsive).useIsSpatial
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage = AvatarExperienceFlags.FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage
local FIntAXEnhancedAvatarHeadsFtuxDelay = AvatarExperienceFlags.FIntAXEnhancedAvatarHeadsFtuxDelay

local function v15(p1) -- line: 25
	return p1.ScreenSize
end
local function useEnhancedAvatarHeadsFtux() -- line: 29
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useSelector (copy), v15 (copy), React (copy), SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy), useIsSpatial (copy), AvatarScreen (copy), FIntAXEnhancedAvatarHeadsFtuxDelay (copy)
	local v18 = useNavigation()
	local v19 = useAvatarRoute()
	local v20 = useSelector(v15)
	local v21 = React.useMemo(function() -- line: 34
		-- upvalues: v19 (copy)
		return v19 and (v19.opaque and v19.opaque.name)
	end, { v19 })
	local v22 = React.useCallback(function() -- line: 38
		-- upvalues: SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy)
		return SafeAppStorageService.getItem("AXEnhancedAvatarHeadsFtux", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
	end, {})
	local v23 = React.useCallback(function() -- line: 42
		-- upvalues: SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy)
		SafeAppStorageService.setItem("AXEnhancedAvatarHeadsFtux", "true", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
		SafeAppStorageService.flush()
	end, {})
	local v24 = useIsSpatial()

	React.useEffect(function() -- line: 50
		-- upvalues: v24 (copy), v22 (copy), v21 (copy), AvatarScreen (copy), FIntAXEnhancedAvatarHeadsFtuxDelay (copy), v18 (copy), v20 (copy), v23 (copy)
		if v24 then
			return
		end

		if v22() == "true" then
			return
		end

		if v21 ~= AvatarScreen.AvatarEditor then
			return
		end

		local thread = task.delay(FIntAXEnhancedAvatarHeadsFtuxDelay / 1000, function() -- line: 65
			-- upvalues: v18 (copy), AvatarScreen (copy), v20 (copy), v23 (copy)
			v18.navigate(AvatarScreen.EnhancedAvatarHeadsFtuxPrompt, {
				screenSize = v20,
				onConfirm = function() -- line: 68
					-- upvalues: v23 (copy)
					v23()
				end
			})
		end)

		return function() -- line: 74
			-- upvalues: thread (copy)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		v22,
		v23,
		v21,
		v20,
		v18,
		v24
	})
end

return useEnhancedAvatarHeadsFtux
