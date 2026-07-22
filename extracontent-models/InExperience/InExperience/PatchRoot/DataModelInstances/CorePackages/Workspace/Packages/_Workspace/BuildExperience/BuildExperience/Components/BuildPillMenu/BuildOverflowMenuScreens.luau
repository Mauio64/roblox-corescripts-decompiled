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
	BuildTitleDescription = "BuildTitleDescription",
	BuildMediaSelection = "BuildMediaSelection"
}
local t2 = {
	publish = t1.BuildPublish,
	settings = t1.BuildSettings
}

local function normalizeTarget(p1) -- line: 58
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
local function getGameInfoName(p2) -- line: 73
	if p2 == nil or (p2.isUnavailable or typeof(p2.name) ~= "string" or p2.name == "") then
		return nil
	end

	return p2.name
end
local function getTargetWithGameInfo(p3, p4) -- line: 81
	-- upvalues: LocalizationStrings (copy)
	if p3 == nil then
		return p3
	end

	local v37 = if not (p4 ~= nil and not p4.isUnavailable) then nil else p4
	local v38 = if not v37 then nil else v37.creator
	local v39 = if p4 ~= nil and (not p4.isUnavailable and (typeof(p4.name) == "string" and p4.name ~= "")) then p4.name else nil

	return {
		universeId = p3.universeId,
		placeId = p3.placeId or if not v37 then nil else tonumber(v37.rootPlaceId),
		sessionId = p3.sessionId,
		experienceName = v39,
		description = if not v37 then LocalizationStrings.BUILD_MENU_LOADING else v37.description or "",
		creatorName = if not v38 or v38.name == "" then LocalizationStrings.BUILD_MENU_LOADING else v38.name,
		gameIcon = p3.gameIcon,
		isCreatorVerified = not not v38 and v38.hasVerifiedBadge == true,
		isNewGameTarget = p3.isNewGameTarget
	}
end
local function isTitleDescriptionReady(p5) -- line: 106
	return ((if p5 ~= nil and (not p5.isUnavailable and (typeof(p5.name) == "string" and p5.name ~= "")) then p5.name else nil)) ~= nil
end
local function useGameInfo(n1: number?) -- line: 110
	-- upvalues: React (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v42 = if n1 ~= nil then tostring(n1) else nil
	local v43 = React.useMemo(function() -- line: 112
		-- upvalues: Signals (copy), v42 (copy), DataHydration (copy)
		return Signals.createComputed(function(p6) -- line: 113
			-- upvalues: v42 (copy), DataHydration (copy)
			if v42 == nil then
				return nil
			end

			return DataHydration.Game.getGameInfoStore(p6).getAndFetchGameInfo(v42).data(p6)
		end)
	end, { v42 })

	return SignalsReact.useSignalState(v43)
end
local function BuildFullscreenPage(t3: {[any]: any}) -- line: 130
	-- upvalues: useBuildPageLayout (copy), React (copy), FullscreenPageWithSafeArea (copy)
	local v45 = useBuildPageLayout()

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v45.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v45.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v45.shouldIncludeBottomBar and t3.hideBottomBar ~= true
	}, {
		Page = t3.pageContent
	})
end
local function BuildSheetPage(t4: {[any]: any}) -- line: 143
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v47 = useTokens()

	return React.createElement(View, {
		tag = "size-full",
		BackgroundColor3 = v47.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v47.Color.Surface.Surface_0.Transparency
	}, {
		Page = t4.pageContent
	})
end
local function ConfigurationScreen(t5: {[any]: any}, p7, s1: string) -- line: 155
	-- upvalues: BuildNavigationParams (copy), useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), t1 (copy), BuildOverflowMenuPage (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
	local navigation = t5.navigation
	local v52 = t5.screenProps or {}
	local v53 = BuildNavigationParams.getTarget(navigation) or v52.target
	local v54 = if v53 ~= nil then {
		universeId = v53.universeId,
		placeId = v53.placeId,
		sessionId = v53.sessionId,
		experienceName = v53.experienceName,
		gameIcon = v53.gameIcon,
		isNewGameTarget = v53.isNewGameTarget
	} else nil
	local v55 = useGameInfo(if not v54 then nil else v54.universeId)
	local v56 = getTargetWithGameInfo(v54, v55)
	local v57 = React.useCallback(function() -- line: 162
		-- upvalues: v52 (copy), navigation (copy)
		if v52.onClose then
			v52.onClose()

			return
		end

		navigation.goBack()
	end, {
		navigation,
		v52.onClose
	})
	local v58 = React.useCallback(function() -- line: 169
		-- upvalues: v52 (copy), navigation (copy), t1 (copy), v56 (copy)
		if v52.onOpenAudiencePage then
			v52.onOpenAudiencePage()

			return
		end

		navigation.navigate(t1.BuildAudience, {
			target = v56
		})
	end, {
		navigation,
		v52.onOpenAudiencePage,
		v56
	})
	local v59 = React.useCallback(function() -- line: 178
		-- upvalues: v55 (copy), v52 (copy), navigation (copy), t1 (copy), v56 (copy)
		local v87 = v55

		if ((if v87 ~= nil and (not v87.isUnavailable and (typeof(v87.name) == "string" and v87.name ~= "")) then v87.name else nil)) == nil then
			return
		end

		if v52.onOpenTitleDescriptionPage then
			v52.onOpenTitleDescriptionPage()

			return
		end

		navigation.navigate(t1.BuildTitleDescription, {
			target = v56
		})
	end, {
		v55,
		navigation,
		v52.onOpenTitleDescriptionPage,
		v56
	})
	local v60 = React.useCallback(function() -- line: 190
		-- upvalues: v52 (copy), navigation (copy), t1 (copy), v56 (copy)
		if v52.onOpenMediaSelectionPage then
			v52.onOpenMediaSelectionPage()

			return
		end

		navigation.navigate(t1.BuildMediaSelection, {
			target = v56
		})
	end, {
		navigation,
		v52.onOpenMediaSelectionPage,
		v56
	})
	local v61 = if v56 ~= nil then React.createElement(BuildOverflowMenuPage, {
		page = p7,
		target = v56,
		testId = s1,
		onClose = v57,
		onOpenAudiencePage = v58,
		onOpenTitleDescriptionPage = v59,
		onOpenMediaSelectionPage = v60,
		showPreviewButton = v52.showPreviewButton
	}) else nil

	if v52.onClose then
		return React.createElement(BuildSheetPage, {
			pageContent = v61
		})
	end

	return React.createElement(BuildFullscreenPage, {
		pageContent = v61
	})
end
local function BuildTitleDescriptionContent(t6: {[any]: any}) -- line: 273
	-- upvalues: useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), TitleDescriptionPage (copy), LocalizationStrings (copy)
	local v72 = useGameInfo(t6.target.universeId)

	if ((if v72 ~= nil and (not v72.isUnavailable and (typeof(v72.name) == "string" and v72.name ~= "")) then v72.name else nil)) == nil then
		return nil
	end

	local v73 = getTargetWithGameInfo(t6.target, v72)

	if v73 == nil then
		return nil
	end

	return React.createElement(TitleDescriptionPage, {
		universeId = v73.universeId,
		titleText = v73.experienceName or LocalizationStrings.BUILD_MENU_LOADING,
		descriptionText = v73.description or "",
		onBack = t6.onBack,
		testId = t6.testId
	})
end

return {
	Screens = t1,
	SCREEN_BY_PAGE = t2,
	BuildPublishScreen = function(t7: {[any]: any}) -- line: 224
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t7, "publish", "BuildPage.publish.Page")
	end,
	BuildSettingsScreen = function(t8: {[any]: any}) -- line: 228
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t8, "settings", "BuildPage.settings.Page")
	end,
	BuildAudienceScreen = function(t9: {[any]: any}) -- line: 232
		-- upvalues: BuildNavigationParams (copy), React (copy), OverflowMenuPageShell (copy), LocalizationStrings (copy), IconName (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), AudienceConfigurationContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t9.navigation
		local v66 = t9.screenProps or {}
		local v67 = BuildNavigationParams.getTarget(navigation) or v66.target
		local v68 = if v67 ~= nil then {
			universeId = v67.universeId,
			placeId = v67.placeId,
			sessionId = v67.sessionId,
			experienceName = v67.experienceName,
			gameIcon = v67.gameIcon,
			isNewGameTarget = v67.isNewGameTarget
		} else nil
		local v69 = React.useCallback(function() -- line: 237
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v70 = if v68 ~= nil then React.createElement(OverflowMenuPageShell, {
			testId = "BuildPage.audience.Page",
			title = LocalizationStrings.BUILD_MENU_AUDIENCE,
			closeIcon = IconName.ChevronLargeLeft,
			onClose = v69,
			scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else "LuaApp_Build_Audience_Scroll",
			content = React.createElement(AudienceConfigurationContent, {
				universeId = v68.universeId
			})
		}) else nil

		if v66.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v70
			})
		end

		return React.createElement(BuildFullscreenPage, {
			pageContent = v70
		})
	end,
	BuildTitleDescriptionScreen = function(t10: {[any]: any}) -- line: 295
		-- upvalues: BuildNavigationParams (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildTitleDescriptionContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t10.navigation
		local v76 = t10.screenProps or {}
		local v77 = BuildNavigationParams.getTarget(navigation) or v76.target
		local v78 = if v77 ~= nil then {
			universeId = v77.universeId,
			placeId = v77.placeId,
			sessionId = v77.sessionId,
			experienceName = v77.experienceName,
			gameIcon = v77.gameIcon,
			isNewGameTarget = v77.isNewGameTarget
		} else nil
		local v79 = useOnScreenKeyboardVisible()
		local v80 = if v78 ~= nil then React.createElement(BuildTitleDescriptionContent, {
			testId = "BuildPage.titleDescription.Page",
			target = v78,
			onBack = navigation.goBack
		}) else nil

		if v76.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v80
			})
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v79,
			pageContent = v80
		})
	end,
	BuildMediaSelectionScreen = function(p8) -- line: 321
		-- upvalues: BuildNavigationParams (copy), useBuildPageLayout (copy), React (copy), MediaSelectionPage (copy), FullscreenPageWithSafeArea (copy)
		local navigation = p8.navigation
		local v83 = BuildNavigationParams.getTarget(navigation)
		local v84 = useBuildPageLayout()
		local v85 = React.useCallback(function() -- line: 326
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v86 = if v83 ~= nil and v83.universeId ~= nil then React.createElement(MediaSelectionPage, {
			onClose = v85,
			universeId = v83.universeId
		}) else nil

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v84.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v84.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v84.shouldIncludeBottomBar
		}, {
			Page = v86
		})
	end
}
