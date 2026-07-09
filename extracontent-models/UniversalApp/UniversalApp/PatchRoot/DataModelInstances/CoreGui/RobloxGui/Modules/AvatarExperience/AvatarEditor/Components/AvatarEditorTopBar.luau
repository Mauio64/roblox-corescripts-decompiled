local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local AppPage = require(Modules.LuaApp.AppPage)
local React = require(CorePackages.Packages.React)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local AndroidBackButtonConnection = require(Modules.LuaApp.Navigation.AndroidBackButtonConnection)
local Common = Modules.AvatarExperience.Common
local v18 = if not require(Modules.AvatarExperience.Flags.GetFFlagAXTransitionMenuV2)() then require(Modules.AvatarExperience.Common.Components.AXTransitionSegmentedMenu_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.AXTransitionSegmentedMenu)
local makeAvatarBackButton = require(Common.Components.TopBar.makeAvatarBackButton)
local ManageButton = require(Common.Components.TopBar.ManageButton)
local CommunityAvatarEntryButton = require(Common.Components.TopBar.CommunityAvatarEntryButton)
local makeTitleDropDown = require(Common.Components.TopBar.makeTitleDropDown)
local isAvatarRouteVisible = require(Common.Components.RoactNavigation.Utils.isAvatarRouteVisible)
local GetIfUserInFStringAXCommunityAvatarsEntryPointWhiteList = require(Modules.AvatarExperience.Flags.GetIfUserInFStringAXCommunityAvatarsEntryPointWhiteList)
local FFlagAXAvatarSharingEntryPoint = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarSharingEntryPoint
local FFlagAXOpaqueMarketplaceTopbar = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXOpaqueMarketplaceTopbar
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagFlyoutNavigationInMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFlyoutNavigationInMarketplace
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v30 = if not FFlagFlyoutNavigationInMarketplace or not FFlagEnableFlyoutSidePanel then nil else require(Common.Components.TopBar.MeTabFlyoutLeftItem)

local function selectIsPortrait(p1) -- line: 67
	-- upvalues: DeviceOrientationMode (copy)
	return p1.DeviceOrientation == DeviceOrientationMode.Portrait
end
local function selectIsCurrentUserAllowedToCreateShares(p2) -- line: 71
	return p2.AvatarExperience.Catalog.Metadata.isCurrentUserAllowedToCreateShares
end
local function AvatarEditorTopBar(t1: {[any]: any}) -- line: 75
	-- upvalues: useSelector (copy), selectIsPortrait (copy), selectIsCurrentUserAllowedToCreateShares (copy), useLocalization (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), React (copy), AndroidBackButtonConnection (copy), AppPage (copy), AvatarScreen (copy), isAvatarRouteVisible (copy), usePrevious (copy), makeAvatarBackButton (copy), makeTitleDropDown (copy), IsVRAppBuild (copy), FFlagFlyoutNavigationInMarketplace (copy), FFlagEnableFlyoutSidePanel (copy), v30 (copy), v18 (copy), ManageButton (copy), GetIfUserInFStringAXCommunityAvatarsEntryPointWhiteList (copy), FFlagAXAvatarSharingEntryPoint (copy), CommunityAvatarEntryButton (copy), TopBar (copy), FFlagAXOpaqueMarketplaceTopbar (copy)
	local v37 = useSelector(selectIsPortrait)
	local v38 = useSelector(selectIsCurrentUserAllowedToCreateShares)
	local navigation = t1.navigation
	local v40 = useLocalization({
		title = "Feature.Catalog.Action.Customize"
	})
	local v41 = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole
	local current = React.useRef(AndroidBackButtonConnection()).current
	local showManageOutfitButton = t1.showManageOutfitButton
	local v44 = React.useCallback(function() -- line: 88
		-- upvalues: AppPage (copy), v41 (copy), AvatarScreen (copy), navigation (copy)
		local Home = AppPage.Home

		if v41 then
			Home = AvatarScreen.AvatarExperienceLandingPage
		end

		navigation.navigate(Home)
	end, {
		navigation,
		v41
	})

	React.useEffect(function() -- line: 96
		-- upvalues: isAvatarRouteVisible (copy), t1 (copy), current (copy), v44 (copy)
		if isAvatarRouteVisible(t1) then
			current.connect(v44)
		end

		return function() -- line: 100
			-- upvalues: current (copy)
			current.disconnect()
		end
	end, {
		t1.navigation,
		t1.avatarRoute,
		current,
		v44
	})

	local v45 = usePrevious(t1)

	React.useEffect(function() -- line: 111
		-- upvalues: v45 (copy), isAvatarRouteVisible (copy), t1 (copy), current (copy), v44 (copy)
		if not v45 then
			return
		end

		if not isAvatarRouteVisible(v45) and isAvatarRouteVisible(t1) then
			current.connect(v44)

			return
		end

		if isAvatarRouteVisible(v45) and not isAvatarRouteVisible(t1) then
			current.disconnect()
		end
	end, {
		t1.navigation,
		t1.avatarRoute,
		v45,
		current
	})

	local v46 = makeAvatarBackButton(v44)
	local v47 = makeTitleDropDown("Feature.Catalog.Action.Customize", t1.overlayClosedCallback)
	local v48, v49

	if IsVRAppBuild() then
		v48 = nil
		v49 = nil
	else
		v48 = if not FFlagFlyoutNavigationInMarketplace or not FFlagEnableFlyoutSidePanel then v46 else v30
		v49 = if not v41 then v18 else v47

		if showManageOutfitButton then
			local _ = { ManageButton }
		end
	end

	local v51 = if not v38 and not GetIfUserInFStringAXCommunityAvatarsEntryPointWhiteList() or (v41 or FFlagAXAvatarSharingEntryPoint) then {} else { CommunityAvatarEntryButton }

	return React.createElement(TopBar.Container, {
		useParentSizeForCenterItem = true,
		transparentBackground = not FFlagAXOpaqueMarketplaceTopbar and not FFlagEnableLeftNavOnConsole or (v37 and true or false),
		hideSiteMessageBanner = v37,
		ref = t1.topBarRef,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionRight = t1.NextSelectionRight,
		titleText = v40.title,
		leftItem = v48,
		centerItem = v49,
		rightItems = v51
	})
end

return AvatarEditorTopBar
