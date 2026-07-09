local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Navigation)

local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local FFlagEnableTopSongsSort = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppSortDeeplinkFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSortDeeplinkFix
local FFlagLuaAppBadgesSeeAllEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllEnabled
local FFlagLuaAppBadgeDetailsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgeDetailsEnabled
local FFlagLuaAppChartsAppPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsAppPage
local FFlagLuaAppDevStoreSeeAllSduiEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDevStoreSeeAllSduiEnabled
local FFlagLuaAppSduiEventDetailsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiEventDetailsEnabled
local FFlagLuaAppSduiLandingPageEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiLandingPageEnabled
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local FFlagAppIaHomeSubTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaHomeSubTab

return function() -- line: 35
	-- upvalues: AppPage (copy), createLazyComponent (copy), Modules (copy), GlobalNavDisplayOption (copy), ScreenKind (copy), CorePackages (copy), FFlagLuaAppSduiLandingPageEnabled (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), NavigationRodux (copy), default (copy), FFlagLuaAppChartsAppPage (copy), FFlagLuaAppBadgesSeeAllEnabled (copy), FFlagLuaAppBadgeDetailsEnabled (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), FFlagEnableTopSongsSort (copy), FFlagLuaAppSortDeeplinkFix (copy)
	local t1 = {
		{
			[AppPage.GamesList] = {
				screen = createLazyComponent(function() -- line: 39
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Games.GamesList)
				end),
				navigationOptions = {
					enableFocusRestoration = false,
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		},
		{
			[AppPage.ExperienceDetail] = {
				screen = createLazyComponent(function() -- line: 50
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.ExperienceDetails.Navigation.ExperienceDetailsSelector)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.SearchPage] = {
				screen = createLazyComponent(function() -- line: 61
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Search.AdaptiveSearchPage)
				end),
				navigationOptions = {
					enableFocusRestoration = false,
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.GameFilterMenuPeekView] = {
				screen = createLazyComponent(function() -- line: 73
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.GameFilters).FilterMenuPeekView
				end),
				navigationOptions = {
					transparent = true,
					overlayEnabled = false
				}
			}
		}
	}

	if FFlagLuaAppSduiLandingPageEnabled then
		table.insert(t1, {
			[AppPage.SduiLandingPage] = {
				screen = createLazyComponent(function() -- line: 87
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SduiLandingPage).SduiLandingPage
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen
				}
			}
		})
	end

	if FFlagAppIaHomeSubTab and FlyoutSidePanelIXP.isHomeSubTabEnabled() then
		table.insert(t1, {
			[NavigationRodux.Constants.HomeContainerName] = {
				getScreen = function() -- line: 100
					-- upvalues: Modules (copy)
					return (require(Modules.Personalization.HomeContainer.HomeContainerPage))
				end
			}
		})
	else
		table.insert(t1, {
			[AppPage.Home] = createLazyComponent(function() -- line: 107
				-- upvalues: default (copy), Modules (copy)
				default:logEventOnce("lazily_require_home_page")

				return require(Modules.Personalization.Home.HomePage)
			end)
		})
		table.insert(t1, {
			[AppPage.Games] = createLazyComponent(function() -- line: 113
				-- upvalues: FFlagLuaAppChartsAppPage (copy), Modules (copy)
				if FFlagLuaAppChartsAppPage then
					return require(Modules.Personalization.Games.SduiChartsPage)
				end

				return require(Modules.Personalization.Games.GamesPage)
			end)
		})
	end

	if FFlagLuaAppBadgesSeeAllEnabled then
		table.insert(t1, {
			[AppPage.BadgesSeeAll] = {
				screen = createLazyComponent(function() -- line: 125
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.Badges).BadgesSeeAllPage
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen
				}
			}
		})
	end

	if FFlagLuaAppBadgeDetailsEnabled then
		table.insert(t1, {
			[AppPage.BadgeDetails] = {
				screen = createLazyComponent(function() -- line: 138
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.Badges).BadgeDetailsPage
				end),
				navigationOptions = {
					transparent = true,
					absorbInput = true
				}
			}
		})
	end

	if FFlagLuaAppDevStoreSeeAllSduiEnabled then
		table.insert(t1, {
			[AppPage.DevStoreSeeAll] = {
				screen = createLazyComponent(function() -- line: 152
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.DevStore).DevStoreSeeAllPage
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen
				}
			}
		})
	end

	if FFlagLuaAppSduiEventDetailsEnabled then
		table.insert(t1, {
			[AppPage.EventDetails] = {
				screen = createLazyComponent(function() -- line: 165
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.VirtualEvents).SduiEventDetailsPage
				end),
				navigationOptions = {
					transparent = true,
					absorbInput = true
				}
			}
		})
	end

	if FFlagEnableTopSongsSort then
		table.insert(t1, {
			[AppPage.SongDetail] = {
				screen = createLazyComponent(function() -- line: 179
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SongDetails).SongDetailPage
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		})
		table.insert(t1, {
			[AppPage.SongList] = {
				screen = createLazyComponent(function() -- line: 191
					-- upvalues: Modules (copy)
					return require(Modules.Personalization.Songs.SongGridPage)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen
				}
			}
		})
	end

	if FFlagLuaAppSortDeeplinkFix then
		table.insert(t1, {
			[AppPage.DeeplinkGamesList] = {
				screen = createLazyComponent(function() -- line: 204
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Games.DeeplinkGamesListWrapper)
				end),
				navigationOptions = {
					enableFocusRestoration = false,
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		})
	end

	return t1
end
