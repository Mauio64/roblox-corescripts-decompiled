local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local function useSettingsTileProps(data, p2)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = ReactFocusNavigation.useFocusGuiObject()
	local v8 = Responsive.usePreferredInput()

	local v9 = React.useCallback(function()
		if v8 == Responsive.Input.Directional then
			v7(p2.current)
		end
	end, { v8, v7 })

	local v10 = React.useCallback(function()
		slotBasedEditorAnalytics.trackSettingsTileClick()

		if p2.current then
			local v11 = p2.current.AbsolutePosition + p2.current.AbsoluteSize * Vector2.new(0.5, 0.5)
			v5.navigate(avatarScreen.CreateOrUpdateOutfitMenu, {
				saveTilePosition = v11,
				onOverlayClosed = v9
			})
		end
	end, { v5, v9 })

	local v11 = React.useCallback(function()
		if p2.current then
			v6(navigateWithLock(v10))
		end
	end, { v6, v10 })

	return {
		index = data.index,
		itemWidth = data.itemWidth,
		onActivated = v11,
		squareAspectRatio = data.squareAspectRatio
	}
end

return useSettingsTileProps
