local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local FullscreenPageWithSafeArea = require(BuildExperienceParent.AppBlox).FullscreenPageWithSafeArea
local View = Foundation.View
local AudienceConfigurationContent = require(BuildExperience.Components.GameConfigurations.AudienceConfigurationContent.AudienceConfigurationContent)
local BuildOverflowMenuPage = require(script.Parent.BuildOverflowMenuPage)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local TitleDescriptionPage = require(BuildExperience.Components.TitleDescriptionPage.TitleDescriptionPage)
local MediaSelectionPage = require(BuildExperience.Components.MediaSelectionPage.MediaSelectionPage)
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

local function normalizeTarget(p1) -- line: 57
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
local function getTargetWithGameInfo(p2, p3) -- line: 72
	if p2 == nil then
		return p2
	end

	local v32 = if not (p3 ~= nil and not p3.isUnavailable) then nil else p3
	local v33 = if not v32 then nil else v32.creator

	return {
		universeId = p2.universeId,
		placeId = p2.placeId or if not v32 then nil else tonumber(v32.rootPlaceId),
		sessionId = p2.sessionId,
		experienceName = if not v32 or v32.name == "" then p2.experienceName else v32.name,
		description = not v32 and "Loading..." or (v32.description or ""),
		creatorName = (not v33 or v33.name == "") and "Loading..." or v33.name,
		gameIcon = p2.gameIcon,
		isCreatorVerified = not not v33 and v33.hasVerifiedBadge == true,
		isNewGameTarget = p2.isNewGameTarget
	}
end
local function useGameInfo(n1: number?) -- line: 98
	-- upvalues: React (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v35 = if n1 ~= nil then tostring(n1) else nil
	local v36 = React.useMemo(function() -- line: 100
		-- upvalues: Signals (copy), v35 (copy), DataHydration (copy)
		return Signals.createComputed(function(p4) -- line: 101
			-- upvalues: v35 (copy), DataHydration (copy)
			if v35 == nil then
				return nil
			end

			return DataHydration.Game.getGameInfoStore(p4).getAndFetchGameInfo(v35).data(p4)
		end)
	end, { v35 })

	return SignalsReact.useSignalState(v36)
end
local function BuildFullscreenPage(t3: {[any]: any}) -- line: 118
	-- upvalues: useBuildPageLayout (copy), React (copy), FullscreenPageWithSafeArea (copy)
	local v38 = useBuildPageLayout()

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v38.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v38.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v38.shouldIncludeBottomBar and t3.hideBottomBar ~= true
	}, {
		Page = t3.pageContent
	})
end
local function BuildSheetPage(t4: {[any]: any}) -- line: 131
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v40 = useTokens()

	return React.createElement(View, {
		tag = "size-full",
		BackgroundColor3 = v40.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v40.Color.Surface.Surface_0.Transparency
	}, {
		Page = t4.pageContent
	})
end
local function ConfigurationScreen(t5: {[any]: any}, p5, s1: string) -- line: 143
	-- upvalues: BuildNavigationParams (copy), useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), t1 (copy), BuildOverflowMenuPage (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
	local navigation = t5.navigation
	local v45 = t5.screenProps or {}
	local v46 = BuildNavigationParams.getTarget(navigation) or v45.target
	local v47 = if v46 ~= nil then {
		universeId = v46.universeId,
		placeId = v46.placeId,
		sessionId = v46.sessionId,
		experienceName = v46.experienceName,
		gameIcon = v46.gameIcon,
		isNewGameTarget = v46.isNewGameTarget
	} else nil
	local v48 = useGameInfo(if not v47 then nil else v47.universeId)
	local v49 = getTargetWithGameInfo(v47, v48)
	local v50 = React.useCallback(function() -- line: 150
		-- upvalues: v45 (copy), navigation (copy)
		if v45.onClose then
			v45.onClose()

			return
		end

		navigation.goBack()
	end, {
		navigation,
		v45.onClose
	})
	local v51 = React.useCallback(function() -- line: 157
		-- upvalues: v45 (copy), navigation (copy), t1 (copy), v49 (copy)
		if v45.onOpenAudiencePage then
			v45.onOpenAudiencePage()

			return
		end

		navigation.navigate(t1.BuildAudience, {
			target = v49
		})
	end, {
		navigation,
		v45.onOpenAudiencePage,
		v49
	})
	local v52 = React.useCallback(function() -- line: 166
		-- upvalues: v45 (copy), navigation (copy), t1 (copy), v49 (copy)
		if v45.onOpenTitleDescriptionPage then
			v45.onOpenTitleDescriptionPage()

			return
		end

		navigation.navigate(t1.BuildTitleDescription, {
			target = v49
		})
	end, {
		navigation,
		v45.onOpenTitleDescriptionPage,
		v49
	})
	local v53 = React.useCallback(function() -- line: 175
		-- upvalues: v45 (copy), navigation (copy), t1 (copy), v49 (copy)
		if v45.onOpenMediaSelectionPage then
			v45.onOpenMediaSelectionPage()

			return
		end

		navigation.navigate(t1.BuildMediaSelection, {
			target = v49
		})
	end, {
		navigation,
		v45.onOpenMediaSelectionPage,
		v49
	})
	local v54 = if v49 ~= nil then React.createElement(BuildOverflowMenuPage, {
		page = p5,
		target = v49,
		testId = s1,
		onClose = v50,
		onOpenAudiencePage = v51,
		onOpenTitleDescriptionPage = v52,
		onOpenMediaSelectionPage = v53,
		showPreviewButton = v45.showPreviewButton
	}) else nil

	if v45.onClose then
		return React.createElement(BuildSheetPage, {
			pageContent = v54
		})
	end

	return React.createElement(BuildFullscreenPage, {
		pageContent = v54
	})
end
local function BuildTitleDescriptionContent(t6: {[any]: any}) -- line: 255
	-- upvalues: useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), TitleDescriptionPage (copy)
	local v65 = useGameInfo(t6.target.universeId)

	if v65 == nil or v65.isUnavailable then
		return nil
	end

	local v66 = getTargetWithGameInfo(t6.target, v65)

	if v66 == nil then
		return nil
	end

	return React.createElement(TitleDescriptionPage, {
		universeId = v66.universeId,
		titleText = v66.experienceName or "Loading...",
		descriptionText = v66.description or "",
		onBack = t6.onBack,
		testId = t6.testId
	})
end

return {
	Screens = t1,
	SCREEN_BY_PAGE = t2,
	BuildPublishScreen = function(t7: {[any]: any}) -- line: 209
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t7, "publish", "BuildPage.publish.Page")
	end,
	BuildSettingsScreen = function(t8: {[any]: any}) -- line: 213
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t8, "settings", "BuildPage.settings.Page")
	end,
	BuildAudienceScreen = function(t9: {[any]: any}) -- line: 217
		-- upvalues: BuildNavigationParams (copy), React (copy), OverflowMenuPageShell (copy), IconName (copy), AudienceConfigurationContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t9.navigation
		local v59 = t9.screenProps or {}
		local v60 = BuildNavigationParams.getTarget(navigation) or v59.target
		local v61 = if v60 ~= nil then {
			universeId = v60.universeId,
			placeId = v60.placeId,
			sessionId = v60.sessionId,
			experienceName = v60.experienceName,
			gameIcon = v60.gameIcon,
			isNewGameTarget = v60.isNewGameTarget
		} else nil
		local v62 = React.useCallback(function() -- line: 222
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v63 = if v61 ~= nil then React.createElement(OverflowMenuPageShell, {
			title = "Audience",
			testId = "BuildPage.audience.Page",
			closeIcon = IconName.ChevronLargeLeft,
			onClose = v62,
			content = React.createElement(AudienceConfigurationContent, {
				universeId = v61.universeId
			})
		}) else nil

		if v59.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v63
			})
		end

		return React.createElement(BuildFullscreenPage, {
			pageContent = v63
		})
	end,
	BuildTitleDescriptionScreen = function(t10: {[any]: any}) -- line: 277
		-- upvalues: BuildNavigationParams (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildTitleDescriptionContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t10.navigation
		local v69 = t10.screenProps or {}
		local v70 = BuildNavigationParams.getTarget(navigation) or v69.target
		local v71 = if v70 ~= nil then {
			universeId = v70.universeId,
			placeId = v70.placeId,
			sessionId = v70.sessionId,
			experienceName = v70.experienceName,
			gameIcon = v70.gameIcon,
			isNewGameTarget = v70.isNewGameTarget
		} else nil
		local v72 = useOnScreenKeyboardVisible()
		local v73 = if v71 ~= nil then React.createElement(BuildTitleDescriptionContent, {
			testId = "BuildPage.titleDescription.Page",
			target = v71,
			onBack = navigation.goBack
		}) else nil

		if v69.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v73
			})
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v72,
			pageContent = v73
		})
	end,
	BuildMediaSelectionScreen = function(p6) -- line: 303
		-- upvalues: BuildNavigationParams (copy), useBuildPageLayout (copy), React (copy), MediaSelectionPage (copy), FullscreenPageWithSafeArea (copy)
		local navigation = p6.navigation
		local v76 = BuildNavigationParams.getTarget(navigation)
		local v77 = useBuildPageLayout()
		local v78 = React.useCallback(function() -- line: 308
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v79 = if v76 ~= nil then React.createElement(MediaSelectionPage, {
			onClose = v78,
			universeId = v76.universeId
		}) else nil

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v77.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v77.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v77.shouldIncludeBottomBar
		}, {
			Page = v79
		})
	end
}
