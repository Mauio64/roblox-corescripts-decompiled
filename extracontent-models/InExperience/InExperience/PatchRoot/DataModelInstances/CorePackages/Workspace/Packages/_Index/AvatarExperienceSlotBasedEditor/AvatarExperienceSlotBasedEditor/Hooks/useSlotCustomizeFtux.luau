local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local parent = AvatarExperienceSlotBasedEditor.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSlotBasedEditorContext = require(AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext)
local ScreenLayout = require(AvatarExperienceSlotBasedEditor.Enums.ScreenLayout)
local Navigation = require(parent.Navigation)
local AXCommon = require(parent.AXCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local SafeAppStorageService = AXCommon.Lib.SafeAppStorageService
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = Navigation.useNavigation
local selectIsFullView = AXCommon.State.Selectors.selectIsFullView
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local AXControlBar = require(parent.AXControlBar)
local MenuItemEnum = AXControlBar.Enums.MenuItemEnum

local defineFastFlag = game:DefineFastFlag("AXSlotBasedEditorCustomizeFtuxUseMemStorage2", false)
local v = game:DefineFastInt("AXSlotBasedEditorCustomizeFtuxDelay2", 3000) / 1000
local v2 = game:DefineFastInt("AXSlotBasedEditorAvatarSwitcherFtuxDelay2", 1000) / 1000

local _ = {
	INIT = "",
	AVATAR_FOCUS_ICON = "AVATAR_FOCUS_ICON",
	PROFILE_REDIRECT = "PROFILE_REDIRECT",
	FINISHED = "FINISHED"
}

local function fn(p)
	return p.ScreenSize
end

local function useSlotCustomizeFtux(callback)
	local v3 = useNavigation()
	local v4 = useAvatarRoute()
	local v5 = useSlotBasedEditorContext()
	local screenLayout = v5 and v5.screenLayout
	local screenSize = useSelector(fn)
	local v6 = not useIsSpatial()

	local v7 = React.useMemo(function()
		return v4 and v4.opaque and v4.opaque.name
	end, { v4 })

	local v8 = useSelector((React.useCallback(function(p)
		return selectIsFullView(p, v7)
	end, { v7 })))

	local v9 = React.useMemo(function()
		return callback(v8)
	end, { v8 })

	local v10 = React.useCallback(function()
		return (SafeAppStorageService.getItem("AXSlotBasedEditorCustomizeFtux", defineFastFlag))
	end, {})

	local v11 = React.useCallback(function(p)
		SafeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", p, defineFastFlag)
		SafeAppStorageService.flush()
	end, {})

	React.useEffect(function()
		local v12 = v10()

		local thread = nil

		if
			v12 == ""
			and v7 == AvatarScreen.AvatarEditor
			and v6
			and v9
			and (screenLayout == ScreenLayout.LandscapeSplit or screenLayout == ScreenLayout.PortraitSlots)
		then
			thread = task.delay(v, function()
				v3.navigate(AvatarScreen.SlotsCustomizeFtuxPrompt, {
					screenSize = screenSize,
					onConfirm = function()
						v11("AVATAR_FOCUS_ICON")
						SlotBasedEditorAnalytics.trackSlotsCustomizeFtuxPrompt()
					end
				})
			end)
		elseif v12 == "AVATAR_FOCUS_ICON" and v7 == AvatarScreen.AvatarSwitcher and v6 and v9 then
			thread = task.delay(v2, function()
				v11("PROFILE_REDIRECT")
				v3.navigate(AvatarScreen.SlotsAvatarSwitcherFtuxPrompt, {
					screenSize = screenSize,
					onConfirm = function()
						v11("FINISHED")
						SlotBasedEditorAnalytics.trackSlotsAvatarSwitcherFtuxPrompt()
					end
				})
			end)
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v10, v11, v7, v9, screenLayout })

	return {
		enabled = v10() == "AVATAR_FOCUS_ICON" and v7 == AvatarScreen.AvatarEditor,
		menuItemId = MenuItemEnum.Main.AvatarSwitcher
	}
end

return useSlotCustomizeFtux
