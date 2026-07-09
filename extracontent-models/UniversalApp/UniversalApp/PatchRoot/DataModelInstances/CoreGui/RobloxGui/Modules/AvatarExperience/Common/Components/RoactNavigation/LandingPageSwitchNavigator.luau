local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarEditorPage = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarEditorPage)
local CatalogPage = require(Modules.AvatarExperience.Catalog.Components.CatalogPage)
local ProfilePictureEditorEmotesPage = require(Modules.AvatarExperience.ProfilePictureEditor.Components.ProfilePictureEditorEmotesPage)
local BackButtonAction = require(Modules.AvatarExperience.Common.Components.RoactNavigation.BackButtonAction)
local LandingPage = require(Modules.AvatarExperience.Common.Components.LandingPage)
local createPreloadingSwitchNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.createPreloadingSwitchNavigator)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local SlotBasedEditorPage = require(Modules.AvatarExperience.SlotBasedEditor.Pages.SlotBasedEditorPage)
local FavoritesSavedScreen = require(script.Parent.FavoritesSavedScreen)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local AXAlternateLandingPageIXP = require(Modules.AvatarExperience.Flags.AXAlternateLandingPageIXP)
local AXDisableAlwaysRenderedScreensIXP = require(Modules.AvatarExperience.Experiments.AXDisableAlwaysRenderedScreensIXP)
local GetFFlagCleanUpAXAlternativeLandingPageIXP = require(Modules.AvatarExperience.Flags.GetFFlagCleanUpAXAlternativeLandingPageIXP)
local GetFFlagAXSlotBasedEditorPrimaryEntryPoint = require(Modules.AvatarExperience.Flags.GetFFlagAXSlotBasedEditorPrimaryEntryPoint)
local v25 = game:DefineFastFlag("AXFixVRForAlwaysDisabledEnabled", false)
local createAvatarSwitchNavigator = require(script.Parent.createAvatarSwitchNavigator)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local v29 = GuiService:IsTenFootInterface() and not FFlagEnableLeftNavOnConsole
local AXPrefetchMarketplaceIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXPrefetchMarketplaceIXP
local v31 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local FFlagAXEnableProfileTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableProfileTab
local v35 = if not FFlagAXEnableProfileTab then nil else require(Modules.AvatarExperience.Common.Components.Profile.ProfileTabPage)
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local FFlagEnableBottomNavOnMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBottomNavOnMarketplace
local FFlagAXFavoritesManagerNavEntry = AvatarExperienceFlags.FFlagAXFavoritesManagerNavEntry

function shouldEnableAlwaysRenderedScreensForUser() -- line: 69
	-- upvalues: IxpUtils (copy), AXDisableAlwaysRenderedScreensIXP (copy)
	return not IxpUtils.readTestVariable(AXDisableAlwaysRenderedScreensIXP.DisableAlwaysRenderedScreen)
end

local t1 = {}
local v40 = if not FFlagAXEnableProfileTab then nil else {
	[AvatarScreen.Profile] = {
		screen = v35,
		navigationOptions = {
			alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
			tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
		}
	}
}

if v31 or FFlagAXUnifiedMarketplaceResultsFetcher then
	local t2 = {
		[AvatarScreen.AvatarExperienceLandingPage] = {
			screen = LandingPage,
			navigationOptions = {
				tabBarVisible = true,
				alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
				backButtonAction = BackButtonAction.Unhandled,
				screenKind = ScreenKind.Default,
				globalNavDisplayOption = GlobalNavDisplayOption.ShowAll
			}
		}
	}
	local t3 = {
		[AvatarScreen.AvatarEditor] = {
			screen = if not GetFFlagAXSlotBasedEditorPrimaryEntryPoint() then AvatarEditorPage else SlotBasedEditorPage,
			navigationOptions = {
				alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
				tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
			}
		}
	}
	local t4 = {
		[AvatarScreen.Catalog] = {
			screen = CatalogPage,
			navigationOptions = {
				alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
				tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
			}
		}
	}
	local t5 = {
		[AvatarScreen.ProfilePictureEditorEmotes] = ProfilePictureEditorEmotesPage
	}

	if v29 then
		table.insert(t1, t2)
	end

	if FFlagLuaAppsDefaultSelection then
		table.insert(t1, t4)
		table.insert(t1, t3)
	else
		table.insert(t1, t3)
		table.insert(t1, t4)
	end

	if v40 then
		table.insert(t1, v40)
	end

	table.insert(t1, t5)
else
	t1 = {
		{
			[AvatarScreen.AvatarExperienceLandingPage] = {
				screen = LandingPage,
				navigationOptions = {
					tabBarVisible = true,
					alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
					backButtonAction = BackButtonAction.Unhandled,
					screenKind = ScreenKind.Default,
					globalNavDisplayOption = GlobalNavDisplayOption.ShowAll
				}
			}
		},
		{
			[AvatarScreen.AvatarEditor] = {
				screen = if not GetFFlagAXSlotBasedEditorPrimaryEntryPoint() then AvatarEditorPage else SlotBasedEditorPage,
				navigationOptions = {
					alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
					tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
				}
			}
		},
		{
			[AvatarScreen.Catalog] = {
				screen = CatalogPage,
				navigationOptions = {
					alwaysRendered = if not v25 or isSpatial() then if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then not IsVRAppBuild() else shouldEnableAlwaysRenderedScreensForUser() else shouldEnableAlwaysRenderedScreensForUser(),
					tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
				}
			}
		},
		{
			[AvatarScreen.ProfilePictureEditorEmotes] = ProfilePictureEditorEmotesPage
		}
	}

	if v40 then
		table.insert(t1, v40)
	end
end

if FFlagAXFavoritesManagerNavEntry then
	table.insert(t1, {
		[AvatarScreen.FavoritesSaved] = {
			screen = FavoritesSavedScreen,
			navigationOptions = {
				alwaysRendered = false,
				tabBarVisible = not not FFlagEnableBottomNavOnMarketplace or nil
			}
		}
	})
end

local function navigationOptions(p1) -- line: 241
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), ScreenKind (copy), GlobalNavDisplayOption (copy), GetFFlagCleanUpAXAlternativeLandingPageIXP (copy), v29 (copy), AXAlternateLandingPageIXP (copy), IxpUtils (copy), BackButtonAction (copy), FFlagAXEnableProfileTab (copy)
	local t6 = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		hasSelectionGroup = not FFlagAXMigrateAXToGlobalAutofocus and nil,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll
	}

	if if not GetFFlagCleanUpAXAlternativeLandingPageIXP() then AXAlternateLandingPageIXP and IxpUtils.readTestVariable(AXAlternateLandingPageIXP.EnabledForUser) else not v29 then
		local key = p1.navigation.state.key
		local NoOp = BackButtonAction.NoOp

		t6.backButtonAction = if key ~= "AvatarEditor" and (key ~= "Catalog" and (not FFlagAXEnableProfileTab or key ~= "Profile")) then nil else NoOp
	end

	return t6
end

if FFlagAXMigrateAXToGlobalAutofocus then
	return createAvatarSwitchNavigator(t1, {
		backBehavior = RoactNavigation.BackBehavior.InitialRoute,
		defaultNavigationOptions = navigationOptions,
		keepVisitedScreensMounted = not IsVRAppBuild()
	})
end

return createPreloadingSwitchNavigator(t1, {
	backBehavior = RoactNavigation.BackBehavior.InitialRoute,
	defaultNavigationOptions = navigationOptions,
	keepVisitedScreensMounted = not IsVRAppBuild()
})
