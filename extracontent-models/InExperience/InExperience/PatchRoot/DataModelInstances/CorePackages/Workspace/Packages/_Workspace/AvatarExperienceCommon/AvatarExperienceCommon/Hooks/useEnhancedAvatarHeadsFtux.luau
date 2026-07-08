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
local FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss = AvatarExperienceFlags.FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss

local function v16(p1) -- line: 26
	return p1.ScreenSize
end
local function useEnhancedAvatarHeadsFtux() -- line: 30
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useSelector (copy), v16 (copy), React (copy), SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy), FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss (copy), useIsSpatial (copy), AvatarScreen (copy), FIntAXEnhancedAvatarHeadsFtuxDelay (copy)
	local v19 = useNavigation()
	local v20 = useAvatarRoute()
	local v21 = useSelector(v16)
	local v22 = React.useMemo(function() -- line: 35
		-- upvalues: v20 (copy)
		return v20 and (v20.opaque and v20.opaque.name)
	end, { v20 })
	local v23 = React.useCallback(function() -- line: 39
		-- upvalues: SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy)
		return SafeAppStorageService.getItem("AXEnhancedAvatarHeadsFtux", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
	end, {})
	local v24 = React.useCallback(function() -- line: 43
		-- upvalues: SafeAppStorageService (copy), FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage (copy)
		SafeAppStorageService.setItem("AXEnhancedAvatarHeadsFtux", "true", FFlagAXEnhancedAvatarHeadsFtuxUseMemStorage)
		SafeAppStorageService.flush()
	end, {})
	local v25 = not not FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss and useIsSpatial()

	React.useEffect(function() -- line: 51
		-- upvalues: FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss (copy), v25 (copy), v23 (copy), v22 (copy), AvatarScreen (copy), FIntAXEnhancedAvatarHeadsFtuxDelay (copy), v19 (copy), v21 (copy), v24 (copy)
		if FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss and v25 then
			return
		end

		if v23() == "true" then
			return
		end

		if v22 ~= AvatarScreen.AvatarEditor then
			return
		end

		local thread = task.delay(FIntAXEnhancedAvatarHeadsFtuxDelay / 1000, function() -- line: 66
			-- upvalues: v19 (copy), AvatarScreen (copy), v21 (copy), v24 (copy)
			v19.navigate(AvatarScreen.EnhancedAvatarHeadsFtuxPrompt, {
				screenSize = v21,
				onConfirm = function() -- line: 69
					-- upvalues: v24 (copy)
					v24()
				end
			})
		end)

		return function() -- line: 75
			-- upvalues: thread (copy)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		v23,
		v24,
		v22,
		v21,
		v19,
		if not FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss then nil else v25
	})
end

return useEnhancedAvatarHeadsFtux
