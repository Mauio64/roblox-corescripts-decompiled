local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local useLastInputMethod = require(FocusNavigationUtils.useLastInputMethod)
local useSelector = require(FocusNavigationUtilsParent.RoactUtils).Hooks.RoactRodux.useSelector
local Navigation = require(FocusNavigationUtilsParent.Navigation)
local useNavigation = Navigation.useNavigation
local getRouteIsFocused = Navigation.getRouteIsFocused
local getCurrentNavigationState = Navigation.getCurrentNavigationState
local AvatarScreen = require(FocusNavigationUtilsParent.AvatarExperienceNavigation).Enums.AvatarScreen
local AppPage = require(FocusNavigationUtilsParent.RobloxAppEnums).AppPage
local FFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require(FocusNavigationUtilsParent.SharedFlags).FFlagAXMigrateSaveOutfitPromptFromRoactGamepad
local t1 = {
	[AvatarScreen.CatalogContextMenu] = true,
	[AvatarScreen.SaveOutfitPrompt] = not not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad or nil,
	[AvatarScreen.ColorAdjustment] = true
}

local function getAvatarRouteIsFocused(p1) -- line: 26
	-- upvalues: getRouteIsFocused (copy), AppPage (copy)
	return getRouteIsFocused(p1, AppPage.AvatarExperienceRoot)
end
local function getRouteInGreenList(p2) -- line: 30
	-- upvalues: getCurrentNavigationState (copy), t1 (copy)
	local v18 = getCurrentNavigationState(p2.state)
	local v19 = if not v18 then nil else v18.routeName

	if v19 then
		return t1[v19]
	end

	return false
end
local function useDisableAutoFocus() -- line: 37
	-- upvalues: useLastInputMethod (copy), useNavigation (copy), getRouteIsFocused (copy), AppPage (copy), getCurrentNavigationState (copy), t1 (copy), useSelector (copy)
	local v20 = useLastInputMethod()
	local v21 = useNavigation()
	local state = v21.state
	local v23 = getRouteIsFocused(state, AppPage.AvatarExperienceRoot)

	if v23 then
		local v24 = getCurrentNavigationState(v21.state)
		local v25 = if not v24 then nil else v24.routeName

		v23 = not (not not v25 and t1[v25])
	end

	local v26 = useSelector(function(p3) -- line: 42
		return p3.CentralOverlay.OverlayType ~= nil
	end)

	return v23 and (not v26 and v20 == "Gamepad")
end

return useDisableAutoFocus
