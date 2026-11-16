local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/RoactUtils").Hooks.RoactRodux.useSelector
local useSlotBasedEditorContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/useSlotBasedEditorContext")
local ScreenLayout = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/ScreenLayout")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Navigation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceCommon")
local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics
local safeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local selectIsFullView = AvatarExperienceCommon.State.Selectors.selectIsFullView
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Responsive").useIsSpatial
local menuItemEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceControlBar").Enums.MenuItemEnum

local defineFastFlag = game:DefineFastFlag("AXSlotBasedEditorCustomizeFtuxUseMemStorage2", false)
local v5 = game:DefineFastInt("AXSlotBasedEditorCustomizeFtuxDelay2", 3000) / 1000
local v6 = game:DefineFastInt("AXSlotBasedEditorAvatarSwitcherFtuxDelay2", 1000) / 1000

local v7 = {
	INIT = "",
	AVATAR_FOCUS_ICON = "AVATAR_FOCUS_ICON",
	PROFILE_REDIRECT = "PROFILE_REDIRECT",
	FINISHED = "FINISHED"
}

local function fn(p2)
	return p2.ScreenSize
end

local function useSlotCustomizeFtux(callback)
	local v8 = useNavigation()
	local v9 = useAvatarRoute()
	local v10 = useSlotBasedEditorContext()
	local screenLayout = v10 and v10.screenLayout
	local v11 = useSelector(fn)
	local v12 = not useIsSpatial()

	local v13 = React.useMemo(function()
		return v9 and v9.opaque and v9.opaque.name
	end, { v9 })

	local v15 = useSelector((React.useCallback(function(p2)
		return selectIsFullView(p2, v13)
	end, { v13 })))

	local v16 = React.useMemo(function()
		return callback(v15)
	end, { v15 })

	local v17 = React.useCallback(function()
		return (safeAppStorageService.getItem("AXSlotBasedEditorCustomizeFtux", defineFastFlag))
	end, {})

	local v18 = React.useCallback(function(p2)
		safeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", p2, defineFastFlag)
		safeAppStorageService.flush()
	end, {})

	React.useEffect(function()
		local v19 = v17()

		local thread = nil

		if
			v19 == ""
			and v13 == avatarScreen.AvatarEditor
			and v12
			and v16
			and (screenLayout == ScreenLayout.LandscapeSplit or screenLayout == ScreenLayout.PortraitSlots)
		then
			thread = task.delay(v5, function()
				v8.navigate(avatarScreen.SlotsCustomizeFtuxPrompt, {
					screenSize = v11,
					onConfirm = function()
						v18("AVATAR_FOCUS_ICON")
						slotBasedEditorAnalytics.trackSlotsCustomizeFtuxPrompt()
					end
				})
			end)
		elseif v19 == "AVATAR_FOCUS_ICON" and v13 == avatarScreen.AvatarSwitcher and v12 and v16 then
			thread = task.delay(v6, function()
				v18("PROFILE_REDIRECT")
				v8.navigate(avatarScreen.SlotsAvatarSwitcherFtuxPrompt, {
					screenSize = v11,
					onConfirm = function()
						v18("FINISHED")
						slotBasedEditorAnalytics.trackSlotsAvatarSwitcherFtuxPrompt()
					end
				})
			end)
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v17, v18, v13, v16, screenLayout })

	return {
		enabled = v17() == "AVATAR_FOCUS_ICON" and v13 == avatarScreen.AvatarEditor,
		menuItemId = menuItemEnum.Main.AvatarSwitcher
	}
end

return useSlotCustomizeFtux
