local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local Common = Modules.AvatarExperience.Common
local makeAvatarBackButton = require(Common.Components.TopBar.makeAvatarBackButton)

local function selectIsPortrait(p1) -- line: 36
	-- upvalues: DeviceOrientationMode (copy)
	return p1.DeviceOrientation == DeviceOrientationMode.Portrait
end
local function FavoritesSavedTopBar(t1: {[any]: any}) -- line: 40
	-- upvalues: useNavigation (copy), useSelector (copy), selectIsPortrait (copy), useLocalization (copy), React (copy), makeAvatarBackButton (copy), TopBar (copy)
	local v15 = useNavigation()
	local v16 = useSelector(selectIsPortrait)
	local v17 = useLocalization({
		title = "Feature.Catalog.Label.Favorites"
	})
	local v18 = React.useCallback(function() -- line: 47
		-- upvalues: v15 (copy)
		v15.goBack()
	end, { v15 })
	local v19 = makeAvatarBackButton(v18)

	return React.createElement(TopBar.Container, {
		transparentBackground = true,
		hideSiteMessageBanner = v16,
		ref = t1.topBarRef,
		titleText = v17.title,
		leftItem = v19,
		rightItems = {}
	})
end

return FavoritesSavedTopBar
