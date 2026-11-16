require("@game/CorePackages/Workspace/Packages/Navigation")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableTopSongsSort
local fFlagLuaAppSortDeeplinkFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSortDeeplinkFix

local fFlagLuaAppBadgesSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllEnabled

local fFlagLuaAppBadgeDetailsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgeDetailsEnabled
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableSduiHomePage

local fFlagLuaAppDevStoreSeeAllSduiEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDevStoreSeeAllSduiEnabled

local fFlagLuaAppSduiEventDetailsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiEventDetailsEnabled

local fFlagLuaAppSduiLandingPageEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiLandingPageEnabled

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local defineFastFlag = game:DefineFastFlag("EnableDeeplinkGamesListSplitPaneContent", false)
local fFlagSplitPaneBadgesSeeAllSupportRegion = SharedFlags.FFlagSplitPaneBadgesSeeAllSupportRegion
local fFlagSplitPaneDevStoreSeeAllSupportRegion = SharedFlags.FFlagSplitPaneDevStoreSeeAllSupportRegion
local splitPaneSlot, splitPaneVariant

if fFlagEnableSplitPane then
	splitPaneSlot = require("@luauforge/bundled/dDG").Enums.SplitPaneSlot
	splitPaneVariant = require("@luauforge/bundled/dFR").SplitPaneVariant
else
	splitPaneSlot = nil
	splitPaneVariant = nil
end

return function()
	local gamesList = appPage.GamesList
	local v7 = {
		screen = createLazyComponent(function()
			return require("@luauforge/deferred/hEp")
		end),
		navigationOptions = 0
	}

	local v9 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
	v7.navigationOptions = { enableFocusRestoration = false, splitPaneEligibility = v9 }
	local v6 = { [gamesList] = v7 }

	local experienceDetail = appPage.ExperienceDetail
	local v11 = {
		screen = createLazyComponent(function()
			return require("@luauforge/deferred/fWD")
		end),
		navigationOptions = 0
	}

	local v13 = if fFlagEnableSplitPane then splitPaneVariant.getExperienceDetailSplitPaneEligibility() else nil
	v11.navigationOptions = { splitPaneEligibility = v13 }
	local v10 = { [experienceDetail] = v11 }

	local searchPage = appPage.SearchPage
	local v15 = {
		screen = createLazyComponent(function()
			return require("@luauforge/deferred/hEP")
		end),
		navigationOptions = 0
	}

	local v17 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
	v15.navigationOptions = {
		enableFocusRestoration = false,
		splitPaneEligibility = v17
	}
	local v5 = {
		v6,
		v10,
		{ [searchPage] = v15 },
		{
			[appPage.GameFilterMenuPeekView] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/dzO").FilterMenuPeekView
				end),
				navigationOptions = { transparent = true, overlayEnabled = false }
			}
		}
	}

	if fFlagLuaAppSduiLandingPageEnabled then
		local v19 = {
			[appPage.SduiLandingPage] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hFi").SduiLandingPage
				end)
			}
		}
		table.insert(v5, v19)
	end

	if fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() then
		local v19 = {
			[NavigationRodux.Constants.HomeContainerName] = {
				getScreen = function()
					return require("@luauforge/bundled/hFA")
				end,
				navigationOptions = fFlagEnableSplitPane and {
					splitPaneEligibility = splitPaneSlot.Content
				} or nil
			}
		}
		table.insert(v5, v19)
	elseif fFlagEnableSplitPane then
		local v19 = {
			[appPage.Home] = {
				screen = createLazyComponent(function()
					default:logEventOnce("lazily_require_home_page")

					if fFlagLuaAppEnableSduiHomePage then
						return require("@luauforge/bundled/hFC")
					end

					return require("@luauforge/bundled/hGi")
				end),
				navigationOptions = { splitPaneEligibility = splitPaneSlot.Content }
			}
		}
		table.insert(v5, v19)

		local v20 = {
			[appPage.Games] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hGs")
				end),
				navigationOptions = { splitPaneEligibility = splitPaneSlot.Content }
			}
		}
		table.insert(v5, v20)
	else
		local v19 = {
			[appPage.Home] = createLazyComponent(function()
				default:logEventOnce("lazily_require_home_page")

				if fFlagLuaAppEnableSduiHomePage then
					return require("@luauforge/bundled/hFC")
				end

				return require("@luauforge/bundled/hGi")
			end)
		}
		table.insert(v5, v19)

		local v20 = {
			[appPage.Games] = createLazyComponent(function()
				return require("@luauforge/deferred/hGs")
			end)
		}
		table.insert(v5, v20)
	end

	if fFlagLuaAppBadgesSeeAllEnabled then
		local badgesSeeAll = appPage.BadgesSeeAll
		local v20 = {
			screen = createLazyComponent(function()
				return require("@luauforge/deferred/fXm").BadgesSeeAllPage
			end),
			navigationOptions = 0
		}

		local v22 = if fFlagEnableSplitPane and fFlagSplitPaneBadgesSeeAllSupportRegion then splitPaneVariant.getBadgesSeeAllSplitPaneEligibility() else nil
		v20.navigationOptions = { splitPaneEligibility = v22 }
		local v19 = { [badgesSeeAll] = v20 }
		table.insert(v5, v19)
	end

	if fFlagLuaAppBadgeDetailsEnabled then
		local v19 = {
			[appPage.BadgeDetails] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/fXm").BadgeDetailsPage
				end),
				navigationOptions = { transparent = true, absorbInput = true }
			}
		}
		table.insert(v5, v19)
	end

	if fFlagLuaAppDevStoreSeeAllSduiEnabled then
		local devStoreSeeAll = appPage.DevStoreSeeAll
		local v20 = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/fXn").DevStoreSeeAllPage()
			end),
			navigationOptions = 0
		}

		local v22 = if fFlagEnableSplitPane and fFlagSplitPaneDevStoreSeeAllSupportRegion then splitPaneVariant.getDevStoreSeeAllSplitPaneEligibility() else nil
		v20.navigationOptions = { splitPaneEligibility = v22 }
		local v19 = { [devStoreSeeAll] = v20 }
		table.insert(v5, v19)
	end

	if fFlagLuaAppSduiEventDetailsEnabled then
		local v19 = {
			[appPage.EventDetails] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/fYS").SduiEventDetailsPage
				end),
				navigationOptions = { transparent = true, absorbInput = true }
			}
		}
		table.insert(v5, v19)
	end

	if fFlagEnableTopSongsSort then
		local v19 = {
			[appPage.SongDetail] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/fZt").SongDetailPage
				end)
			}
		}
		table.insert(v5, v19)

		local v20 = {
			[appPage.SongList] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hGM")
				end)
			}
		}
		table.insert(v5, v20)
	end

	if not fFlagLuaAppSortDeeplinkFix then
		return v5
	end

	local deeplinkGamesList = appPage.DeeplinkGamesList
	local v20 = {
		screen = createLazyComponent(function()
			return require("@luauforge/deferred/hGO")
		end),
		navigationOptions = 0
	}

	local v22 = if defineFastFlag and fFlagEnableSplitPane then splitPaneSlot.Content else nil
	v20.navigationOptions = {
		enableFocusRestoration = false,
		splitPaneEligibility = v22
	}
	local v19 = { [deeplinkGamesList] = v20 }
	table.insert(v5, v19)

	return v5
end
