local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local SlotBasedEditorAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics

local function useSettingsTileProps(t1: {[any]: any}, p1) -- line: 23
	-- upvalues: useNavigation (copy), useDispatch (copy), ReactFocusNavigation (copy), Responsive (copy), React (copy), SlotBasedEditorAnalytics (copy), AvatarScreen (copy), NavigateWithLock (copy)
	local v14 = useNavigation()
	local v15 = useDispatch()
	local v16 = ReactFocusNavigation.useFocusGuiObject()
	local v17 = Responsive.usePreferredInput()
	local v18 = React.useCallback(function() -- line: 29
		-- upvalues: v17 (copy), Responsive (copy), v16 (copy), p1 (copy)
		if v17 == Responsive.Input.Directional then
			v16(p1.current)
		end
	end, {
		v17,
		v16
	})
	local v19 = React.useCallback(function() -- line: 35
		-- upvalues: SlotBasedEditorAnalytics (copy), p1 (copy), v14 (copy), AvatarScreen (copy), v18 (copy)
		SlotBasedEditorAnalytics.trackSettingsTileClick()

		if p1.current then
			local v21 = p1.current.AbsolutePosition + p1.current.AbsoluteSize * Vector2.new(0.5, 0.5)

			v14.navigate(AvatarScreen.CreateOrUpdateOutfitMenu, {
				saveTilePosition = v21,
				onOverlayClosed = v18
			})
		end
	end, {
		v14,
		v18
	})
	local v20 = React.useCallback(function() -- line: 46
		-- upvalues: p1 (copy), v15 (copy), NavigateWithLock (copy), v19 (copy)
		if p1.current then
			v15(NavigateWithLock(v19))
		end
	end, {
		v15,
		v19
	})

	return {
		index = t1.index,
		itemWidth = t1.itemWidth,
		onActivated = v20,
		squareAspectRatio = t1.squareAspectRatio
	}
end

return useSettingsTileProps
