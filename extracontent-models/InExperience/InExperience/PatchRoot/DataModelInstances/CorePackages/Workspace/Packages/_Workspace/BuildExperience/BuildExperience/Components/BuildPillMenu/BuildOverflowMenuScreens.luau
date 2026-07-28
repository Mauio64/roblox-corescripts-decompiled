local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FullscreenPageWithSafeArea = require(BuildExperienceParent.AppBlox).FullscreenPageWithSafeArea
local View = Foundation.View
local AudienceConfigurationContent = require(BuildExperience.Components.GameConfigurations.AudienceConfigurationContent.AudienceConfigurationContent)
local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)
local PrivateInvitesPickerHost = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerHost)
local PrivateInvitesManagementContainer = require(BuildExperience.Components.GameConfigurations.PrivateInvitesManagement.PrivateInvitesManagementContainer)
local BuildOverflowMenuPage = require(script.Parent.BuildOverflowMenuPage)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local TitleDescriptionPage = require(BuildExperience.Components.TitleDescriptionPage.TitleDescriptionPage)
local MediaSelectionPage = require(BuildExperience.Components.MediaSelectionPage.MediaSelectionPage)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local useBuildPageLayout = require(BuildExperience.utils.useBuildPageLayout)
local useOnScreenKeyboardVisible = require(BuildExperience.utils.useOnScreenKeyboardVisible)
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	BuildPublish = "BuildPublish",
	BuildSettings = "BuildSettings",
	BuildAudience = "BuildAudience",
	BuildPrivateInvitesPicker = "BuildPrivateInvitesPicker",
	BuildPlaytestInviteManagement = "BuildPlaytestInviteManagement",
	BuildTitleDescription = "BuildTitleDescription",
	BuildVersionTitleDescription = "BuildVersionTitleDescription",
	BuildMediaSelection = "BuildMediaSelection"
}
local t2 = {
	publish = t1.BuildPublish,
	settings = t1.BuildSettings
}

local function normalizeTarget(p1) -- line: 67
	if p1 == nil then
		return nil
	end

	return {
		universeId = p1.universeId,
		placeId = p1.placeId,
		sessionId = p1.sessionId,
		experienceName = p1.experienceName,
		gameIcon = p1.gameIcon,
		isNewGameTarget = p1.isNewGameTarget
	}
end
local function getGameInfoName(p2) -- line: 82
	if p2 == nil or (p2.isUnavailable or typeof(p2.name) ~= "string" or p2.name == "") then
		return nil
	end

	return p2.name
end
local function getTargetWithGameInfo(p3, p4) -- line: 90
	-- upvalues: LocalizationStrings (copy)
	if p3 == nil then
		return p3
	end

	local v40 = if not (p4 ~= nil and not p4.isUnavailable) then nil else p4
	local v41 = if not v40 then nil else v40.creator
	local v42 = if p4 ~= nil and (not p4.isUnavailable and (typeof(p4.name) == "string" and p4.name ~= "")) then p4.name else nil

	return {
		universeId = p3.universeId,
		placeId = p3.placeId or if not v40 then nil else tonumber(v40.rootPlaceId),
		sessionId = p3.sessionId,
		experienceName = v42,
		description = if not v40 then LocalizationStrings.BUILD_MENU_LOADING else v40.description or "",
		creatorName = if not v41 or v41.name == "" then LocalizationStrings.BUILD_MENU_LOADING else v41.name,
		gameIcon = p3.gameIcon,
		isCreatorVerified = not not v41 and v41.hasVerifiedBadge == true,
		isNewGameTarget = p3.isNewGameTarget
	}
end
local function isTitleDescriptionReady(p5) -- line: 115
	return ((if p5 ~= nil and (not p5.isUnavailable and (typeof(p5.name) == "string" and p5.name ~= "")) then p5.name else nil)) ~= nil
end
local function useGameInfo(n1: number?) -- line: 119
	-- upvalues: React (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v45 = if n1 ~= nil then tostring(n1) else nil
	local v46 = React.useMemo(function() -- line: 121
		-- upvalues: Signals (copy), v45 (copy), DataHydration (copy)
		return Signals.createComputed(function(p6) -- line: 122
			-- upvalues: v45 (copy), DataHydration (copy)
			if v45 == nil then
				return nil
			end

			return DataHydration.Game.getGameInfoStore(p6).getAndFetchGameInfo(v45).data(p6)
		end)
	end, { v45 })

	return SignalsReact.useSignalState(v46)
end
local function BuildFullscreenPage(t3: {[any]: any}) -- line: 139
	-- upvalues: useBuildPageLayout (copy), React (copy), FullscreenPageWithSafeArea (copy)
	local v48 = useBuildPageLayout()

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v48.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v48.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v48.shouldIncludeBottomBar and t3.hideBottomBar ~= true
	}, {
		Page = t3.pageContent
	})
end
local function BuildSheetPage(t4: {[any]: any}) -- line: 152
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v50 = useTokens()

	return React.createElement(View, {
		tag = "size-full",
		BackgroundColor3 = v50.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v50.Color.Surface.Surface_0.Transparency
	}, {
		Page = t4.pageContent
	})
end
local function ConfigurationScreen(t5: {[any]: any}, p7, s1: string) -- line: 164
	-- upvalues: BuildNavigationParams (copy), useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), t1 (copy), BuildOverflowMenuPage (copy), BuildSheetPage (copy), BuildFullscreenPage (copy), PrivateInvitesPickerHost (copy), BuildExperience (copy)
	local navigation = t5.navigation
	local v55 = t5.screenProps or {}
	local v56 = BuildNavigationParams.getTarget(navigation) or v55.target
	local v57 = if v56 ~= nil then {
		universeId = v56.universeId,
		placeId = v56.placeId,
		sessionId = v56.sessionId,
		experienceName = v56.experienceName,
		gameIcon = v56.gameIcon,
		isNewGameTarget = v56.isNewGameTarget
	} else nil
	local v58 = useGameInfo(if not v57 then nil else v57.universeId)
	local v59 = getTargetWithGameInfo(v57, v58)
	local v60, v61 = React.useState(false)
	local v62, v63 = React.useState(false)
	local v64 = React.useCallback(function() -- line: 173
		-- upvalues: v55 (copy), navigation (copy)
		if v55.onClose then
			v55.onClose()

			return
		end

		navigation.goBack()
	end, {
		navigation,
		v55.onClose
	})
	local v65 = React.useCallback(function() -- line: 180
		-- upvalues: v55 (copy), navigation (copy), t1 (copy), v59 (copy)
		if v55.onOpenAudiencePage then
			v55.onOpenAudiencePage()

			return
		end

		navigation.navigate(t1.BuildAudience, {
			target = v59
		})
	end, {
		navigation,
		v55.onOpenAudiencePage,
		v59
	})
	local v66 = React.useCallback(function() -- line: 189
		-- upvalues: v58 (copy), v55 (copy), navigation (copy), t1 (copy), v59 (copy)
		local v128 = v58

		if ((if v128 ~= nil and (not v128.isUnavailable and (typeof(v128.name) == "string" and v128.name ~= "")) then v128.name else nil)) == nil then
			return
		end

		if v55.onOpenTitleDescriptionPage then
			v55.onOpenTitleDescriptionPage()

			return
		end

		navigation.navigate(t1.BuildTitleDescription, {
			target = v59
		})
	end, {
		v58,
		navigation,
		v55.onOpenTitleDescriptionPage,
		v59
	})
	local v67 = React.useCallback(function() -- line: 201
		-- upvalues: v55 (copy), navigation (copy), t1 (copy), v59 (copy)
		if v55.onOpenMediaSelectionPage then
			v55.onOpenMediaSelectionPage()

			return
		end

		navigation.navigate(t1.BuildMediaSelection, {
			target = v59
		})
	end, {
		navigation,
		v55.onOpenMediaSelectionPage,
		v59
	})
	local v68 = React.useCallback(function() -- line: 210
		-- upvalues: v59 (copy), v55 (copy), navigation (copy), t1 (copy)
		if v59 == nil or v59.placeId == nil then
			return
		end

		if v55.onOpenVersionTitleDescriptionPage then
			v55.onOpenVersionTitleDescriptionPage()

			return
		end

		navigation.navigate(t1.BuildVersionTitleDescription, {
			target = v59
		})
	end, {
		navigation,
		v55.onOpenVersionTitleDescriptionPage,
		v59
	})
	local v69 = React.useCallback(function() -- line: 222
		-- upvalues: v59 (copy), v55 (copy), v63 (copy)
		if v59 == nil or v59.placeId == nil then
			return
		end

		if v55.onOpenVersionHistory then
			v55.onOpenVersionHistory()

			return
		end

		v63(true)
	end, {
		v55.onOpenVersionHistory,
		v59
	})
	local v70 = React.useCallback(function() -- line: 232
		-- upvalues: v63 (copy)
		v63(false)
	end, {})
	local v71 = React.useCallback(function() -- line: 235
		-- upvalues: v61 (copy)
		v61(true)
	end, {})
	local v72 = React.useCallback(function() -- line: 238
		-- upvalues: v61 (copy)
		v61(false)
	end, {})
	local v73 = React.useCallback(function() -- line: 241
		-- upvalues: navigation (copy), t1 (copy), v59 (copy)
		navigation.navigate(t1.BuildPlaytestInviteManagement, {
			target = v59
		})
	end, {
		navigation,
		v59
	})
	local v74 = React.useCallback(function() -- line: 248
		-- upvalues: v61 (copy), v73 (copy)
		v61(false)
		v73()
	end, { v73 })
	local v75 = p7 == "settings"
	local v76 = if v59 ~= nil then React.createElement(BuildOverflowMenuPage, {
		page = p7,
		target = v59,
		testId = s1,
		onClose = v64,
		onOpenAudiencePage = v65,
		onOpenTitleDescriptionPage = v66,
		onOpenMediaSelectionPage = v67,
		onOpenVersionTitleDescriptionPage = v68,
		onOpenVersionHistory = v69,
		onOpenPlaytestPicker = if not v75 then nil else v71,
		onOpenPlaytestManagement = if not v75 then nil else v73,
		showPreviewButton = v55.showPreviewButton
	}) else nil
	local v77 = if not v55.onClose then React.createElement(BuildFullscreenPage, {
		pageContent = v76
	}) else React.createElement(BuildSheetPage, {
		pageContent = v76
	})

	return React.createElement(React.Fragment, nil, {
		Page = v77,
		Picker = if not v60 or v59 == nil then nil else React.createElement(PrivateInvitesPickerHost, {
			universeId = v59.universeId,
			onClose = v72,
			onInvitesSent = v74
		}),
		VersionHistory = if not v62 or (v59 == nil or v59.placeId == nil) then nil else React.createElement(require(BuildExperience.Components.VersionHistory.VersionHistoryContainer), {
			isOpen = true,
			testId = "build-publish-version-history",
			placeId = v59.placeId,
			onClose = v70
		})
	})
end
local function BuildTitleDescriptionContent(t6: {[any]: any}) -- line: 435
	-- upvalues: useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), TitleDescriptionPage (copy), LocalizationStrings (copy)
	local v106 = useGameInfo(t6.target.universeId)

	if ((if v106 ~= nil and (not v106.isUnavailable and (typeof(v106.name) == "string" and v106.name ~= "")) then v106.name else nil)) == nil then
		return nil
	end

	local v107 = getTargetWithGameInfo(t6.target, v106)

	if v107 == nil then
		return nil
	end

	return React.createElement(TitleDescriptionPage, {
		universeId = v107.universeId,
		titleText = v107.experienceName or LocalizationStrings.BUILD_MENU_LOADING,
		descriptionText = v107.description or "",
		onBack = t6.onBack,
		testId = t6.testId
	})
end

return {
	Screens = t1,
	SCREEN_BY_PAGE = t2,
	BuildPublishScreen = function(t7: {[any]: any}) -- line: 306
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t7, "publish", "BuildPage.publish.Page")
	end,
	BuildSettingsScreen = function(t8: {[any]: any}) -- line: 310
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t8, "settings", "BuildPage.settings.Page")
	end,
	BuildAudienceScreen = function(t9: {[any]: any}) -- line: 314
		-- upvalues: BuildNavigationParams (copy), React (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), AudienceConfigurationContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t9.navigation
		local v82 = t9.screenProps or {}
		local v83 = BuildNavigationParams.getTarget(navigation) or v82.target
		local v84 = if v83 ~= nil then {
			universeId = v83.universeId,
			placeId = v83.placeId,
			sessionId = v83.sessionId,
			experienceName = v83.experienceName,
			gameIcon = v83.gameIcon,
			isNewGameTarget = v83.isNewGameTarget
		} else nil
		local v85 = React.useCallback(function() -- line: 319
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v86 = if v84 ~= nil then React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.audience.Page",
			title = LocalizationStrings.BUILD_MENU_AUDIENCE,
			closeIcon = IconName.ChevronLargeLeft,
			onClose = v85,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Audience_Scroll",
			content = React.createElement(AudienceConfigurationContent, {
				universeId = v84.universeId
			})
		}) else nil

		if v82.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v86
			})
		end

		return React.createElement(BuildFullscreenPage, {
			pageContent = v86
		})
	end,
	BuildPrivateInvitesPickerScreen = function(t10: {[any]: any}) -- line: 353
		-- upvalues: BuildNavigationParams (copy), React (copy), PrivateInvitesPickerContainer (copy)
		local navigation = t10.navigation
		local v89 = t10.screenProps or {}
		local v90 = BuildNavigationParams.getTarget(navigation) or v89.target
		local v91 = if v90 ~= nil then {
			universeId = v90.universeId,
			placeId = v90.placeId,
			sessionId = v90.sessionId,
			experienceName = v90.experienceName,
			gameIcon = v90.gameIcon,
			isNewGameTarget = v90.isNewGameTarget
		} else nil
		local v92 = React.useCallback(function() -- line: 358
			-- upvalues: v89 (copy), navigation (copy)
			if v89.onClose then
				v89.onClose()

				return
			end

			navigation.goBack()
		end, {
			navigation,
			v89.onClose
		})

		if v91 == nil then
			return nil
		end

		return React.createElement(PrivateInvitesPickerContainer, {
			universeId = v91.universeId,
			onClose = v92,
			onInvitesSent = v92
		})
	end,
	BuildPlaytestInviteManagementScreen = function(t11: {[any]: any}) -- line: 377
		-- upvalues: BuildNavigationParams (copy), React (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), PrivateInvitesManagementContainer (copy), BuildSheetPage (copy), BuildFullscreenPage (copy), PrivateInvitesPickerHost (copy)
		local navigation = t11.navigation
		local v95 = t11.screenProps or {}
		local v96 = BuildNavigationParams.getTarget(navigation) or v95.target
		local v97 = if v96 ~= nil then {
			universeId = v96.universeId,
			placeId = v96.placeId,
			sessionId = v96.sessionId,
			experienceName = v96.experienceName,
			gameIcon = v96.gameIcon,
			isNewGameTarget = v96.isNewGameTarget
		} else nil
		local v98, v99 = React.useState(false)
		local v100 = React.useCallback(function() -- line: 383
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v101 = React.useCallback(function() -- line: 386
			-- upvalues: v99 (copy)
			v99(true)
		end, {})
		local v102 = React.useCallback(function() -- line: 389
			-- upvalues: v99 (copy)
			v99(false)
		end, {})
		local v103 = if v97 ~= nil then React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.playtestInviteManagement.Page",
			title = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE,
			closeIcon = IconName.ChevronLargeLeft,
			onClose = v100,
			content = React.createElement(PrivateInvitesManagementContainer, {
				universeId = v97.universeId,
				onOpenInvitePicker = v101
			})
		}) else nil
		local v104 = if not v95.onClose then React.createElement(BuildFullscreenPage, {
			pageContent = v103
		}) else React.createElement(BuildSheetPage, {
			pageContent = v103
		})

		return React.createElement(React.Fragment, nil, {
			Page = v104,
			Picker = if not v98 or v97 == nil then nil else React.createElement(PrivateInvitesPickerHost, {
				universeId = v97.universeId,
				onClose = v102,
				onInvitesSent = v102
			})
		})
	end,
	BuildTitleDescriptionScreen = function(t12: {[any]: any}) -- line: 457
		-- upvalues: BuildNavigationParams (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildTitleDescriptionContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t12.navigation
		local v110 = t12.screenProps or {}
		local v111 = BuildNavigationParams.getTarget(navigation) or v110.target
		local v112 = if v111 ~= nil then {
			universeId = v111.universeId,
			placeId = v111.placeId,
			sessionId = v111.sessionId,
			experienceName = v111.experienceName,
			gameIcon = v111.gameIcon,
			isNewGameTarget = v111.isNewGameTarget
		} else nil
		local v113 = useOnScreenKeyboardVisible()
		local v114 = if v112 ~= nil then React.createElement(BuildTitleDescriptionContent, {
			testId = "BuildPage.titleDescription.Page",
			target = v112,
			onBack = navigation.goBack
		}) else nil

		if v110.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v114
			})
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v113,
			pageContent = v114
		})
	end,
	BuildVersionTitleDescriptionScreen = function(t13: {[any]: any}) -- line: 483
		-- upvalues: BuildNavigationParams (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildExperience (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t13.navigation
		local v117 = t13.screenProps or {}
		local v118 = BuildNavigationParams.getTarget(navigation) or v117.target
		local v119 = if v118 ~= nil then {
			universeId = v118.universeId,
			placeId = v118.placeId,
			sessionId = v118.sessionId,
			experienceName = v118.experienceName,
			gameIcon = v118.gameIcon,
			isNewGameTarget = v118.isNewGameTarget
		} else nil
		local v120 = useOnScreenKeyboardVisible()
		local v121 = if v119 == nil or v119.placeId == nil then nil else React.createElement(require(BuildExperience.Components.VersionTitleDescriptionPage.VersionTitleDescriptionPageContainer), {
			testId = "BuildPage.versionTitleDescription.Page",
			placeId = v119.placeId,
			onBack = navigation.goBack
		})

		if v117.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v121
			})
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v120,
			pageContent = v121
		})
	end,
	BuildMediaSelectionScreen = function(p8) -- line: 512
		-- upvalues: BuildNavigationParams (copy), useBuildPageLayout (copy), React (copy), MediaSelectionPage (copy), FullscreenPageWithSafeArea (copy)
		local navigation = p8.navigation
		local v124 = BuildNavigationParams.getTarget(navigation)
		local v125 = useBuildPageLayout()
		local v126 = React.useCallback(function() -- line: 517
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v127 = if v124 ~= nil and v124.universeId ~= nil then React.createElement(MediaSelectionPage, {
			onClose = v126,
			universeId = v124.universeId
		}) else nil

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v125.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v125.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v125.shouldIncludeBottomBar
		}, {
			Page = v127
		})
	end
}
