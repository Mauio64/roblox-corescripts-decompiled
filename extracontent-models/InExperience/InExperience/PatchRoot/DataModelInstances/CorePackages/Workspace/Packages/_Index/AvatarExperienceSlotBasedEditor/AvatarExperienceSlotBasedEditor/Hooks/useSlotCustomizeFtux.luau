local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local AvatarExperienceSlotBasedEditorParent = AvatarExperienceSlotBasedEditor.Parent
local React = require(AvatarExperienceSlotBasedEditorParent.React)
local useSelector = require(AvatarExperienceSlotBasedEditorParent.RoactUtils).Hooks.RoactRodux.useSelector
local useSlotBasedEditorContext = require(AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext)
local ScreenLayout = require(AvatarExperienceSlotBasedEditor.Enums.ScreenLayout)
local Navigation = require(AvatarExperienceSlotBasedEditorParent.Navigation)
local AXCommon = require(AvatarExperienceSlotBasedEditorParent.AXCommon)
local SlotBasedEditorAnalytics = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local SafeAppStorageService = AXCommon.Lib.SafeAppStorageService
local AvatarExperienceNavigation = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local selectIsFullView = AXCommon.State.Selectors.selectIsFullView
local useIsSpatial = require(AvatarExperienceSlotBasedEditorParent.Responsive).useIsSpatial
local MenuItemEnum = require(AvatarExperienceSlotBasedEditorParent.AXControlBar).Enums.MenuItemEnum
local v18 = game:DefineFastFlag("AXSlotBasedEditorCustomizeFtuxUseMemStorage2", false)
local v19 = game:DefineFastInt("AXSlotBasedEditorCustomizeFtuxDelay2", 3000) / 1000
local v20 = game:DefineFastInt("AXSlotBasedEditorAvatarSwitcherFtuxDelay2", 1000) / 1000
local _ = {
	INIT = "",
	AVATAR_FOCUS_ICON = "AVATAR_FOCUS_ICON",
	PROFILE_REDIRECT = "PROFILE_REDIRECT",
	FINISHED = "FINISHED"
}

local function v22(p1) -- line: 42
	return p1.ScreenSize
end
local function useSlotCustomizeFtux(p2: ((...any) -> ...any)) -- line: 48
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useSlotBasedEditorContext (copy), useSelector (copy), v22 (copy), useIsSpatial (copy), React (copy), selectIsFullView (copy), SafeAppStorageService (copy), v18 (copy), AvatarScreen (copy), ScreenLayout (copy), v19 (copy), SlotBasedEditorAnalytics (copy), v20 (copy), MenuItemEnum (copy)
	local v26 = useNavigation()
	local v27 = useAvatarRoute()
	local v28 = useSlotBasedEditorContext()
	local v29 = v28 and v28.screenLayout
	local v30 = useSelector(v22)
	local v31 = not useIsSpatial()
	local v32 = React.useMemo(function() -- line: 56
		-- upvalues: v27 (copy)
		return v27 and (v27.opaque and v27.opaque.name)
	end, { v27 })
	local v33 = React.useCallback(function(p3) -- line: 60
		-- upvalues: selectIsFullView (copy), v32 (copy)
		return selectIsFullView(p3, v32)
	end, { v32 })
	local v34 = useSelector(v33)
	local v35 = React.useMemo(function() -- line: 66
		-- upvalues: p2 (copy), v34 (copy)
		return p2(v34)
	end, { v34 })
	local v36 = React.useCallback(function() -- line: 70
		-- upvalues: SafeAppStorageService (copy), v18 (copy)
		return (SafeAppStorageService.getItem("AXSlotBasedEditorCustomizeFtux", v18))
	end, {})
	local v37 = React.useCallback(function(p4) -- line: 76
		-- upvalues: SafeAppStorageService (copy), v18 (copy)
		SafeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", p4, v18)
		SafeAppStorageService.flush()
	end, {})

	React.useEffect(function() -- line: 81
		-- upvalues: v36 (copy), v32 (copy), AvatarScreen (copy), v31 (copy), v35 (copy), v29 (copy), ScreenLayout (copy), v19 (copy), v26 (copy), v30 (copy), v37 (copy), SlotBasedEditorAnalytics (copy), v20 (copy)
		local v40 = v36()
		local thread = nil

		if v40 == "" and (v32 == AvatarScreen.AvatarEditor and v31 and v35) and (v29 == ScreenLayout.LandscapeSplit or v29 == ScreenLayout.PortraitSlots) then
			thread = task.delay(v19, function() -- line: 99
				-- upvalues: v26 (copy), AvatarScreen (copy), v30 (copy), v37 (copy), SlotBasedEditorAnalytics (copy)
				v26.navigate(AvatarScreen.SlotsCustomizeFtuxPrompt, {
					screenSize = v30,
					onConfirm = function() -- line: 102
						-- upvalues: v37 (copy), SlotBasedEditorAnalytics (copy)
						v37("AVATAR_FOCUS_ICON")
						SlotBasedEditorAnalytics.trackSlotsCustomizeFtuxPrompt()
					end
				})
			end)
		elseif v40 == "AVATAR_FOCUS_ICON" and v32 == AvatarScreen.AvatarSwitcher and v31 and v35 then
			thread = task.delay(v20, function() -- line: 122
				-- upvalues: v37 (copy), v26 (copy), AvatarScreen (copy), v30 (copy), SlotBasedEditorAnalytics (copy)
				v37("PROFILE_REDIRECT")
				v26.navigate(AvatarScreen.SlotsAvatarSwitcherFtuxPrompt, {
					screenSize = v30,
					onConfirm = function() -- line: 126
						-- upvalues: v37 (copy), SlotBasedEditorAnalytics (copy)
						v37("FINISHED")
						SlotBasedEditorAnalytics.trackSlotsAvatarSwitcherFtuxPrompt()
					end
				})
			end)
		end

		return function() -- line: 134
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		v36,
		v37,
		v32,
		v35,
		v29
	})

	return {
		enabled = v36() == "AVATAR_FOCUS_ICON" and v32 == AvatarScreen.AvatarEditor,
		menuItemId = MenuItemEnum.Main.AvatarSwitcher
	}
end

return useSlotCustomizeFtux
