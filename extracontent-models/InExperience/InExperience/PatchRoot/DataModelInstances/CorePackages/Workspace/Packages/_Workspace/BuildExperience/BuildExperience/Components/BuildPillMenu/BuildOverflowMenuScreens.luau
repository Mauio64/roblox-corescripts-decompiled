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
local function getGameInfoName(p2) -- line: 72
	if p2 == nil or (p2.isUnavailable or typeof(p2.name) ~= "string" or p2.name == "") then
		return nil
	end

	return p2.name
end
local function getTargetWithGameInfo(p3, p4) -- line: 80
	if p3 == nil then
		return p3
	end

	local v35 = if not (p4 ~= nil and not p4.isUnavailable) then nil else p4
	local v36 = if not v35 then nil else v35.creator
	local v37 = if p4 ~= nil and (not p4.isUnavailable and (typeof(p4.name) == "string" and p4.name ~= "")) then p4.name else nil

	return {
		universeId = p3.universeId,
		placeId = p3.placeId or if not v35 then nil else tonumber(v35.rootPlaceId),
		sessionId = p3.sessionId,
		experienceName = v37,
		description = not v35 and "Loading..." or (v35.description or ""),
		creatorName = (not v36 or v36.name == "") and "Loading..." or v36.name,
		gameIcon = p3.gameIcon,
		isCreatorVerified = not not v36 and v36.hasVerifiedBadge == true,
		isNewGameTarget = p3.isNewGameTarget
	}
end
local function isTitleDescriptionReady(p5) -- line: 105
	return ((if p5 ~= nil and (not p5.isUnavailable and (typeof(p5.name) == "string" and p5.name ~= "")) then p5.name else nil)) ~= nil
end
local function useGameInfo(n1: number?) -- line: 109
	-- upvalues: React (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v40 = if n1 ~= nil then tostring(n1) else nil
	local v41 = React.useMemo(function() -- line: 111
		-- upvalues: Signals (copy), v40 (copy), DataHydration (copy)
		return Signals.createComputed(function(p6) -- line: 112
			-- upvalues: v40 (copy), DataHydration (copy)
			if v40 == nil then
				return nil
			end

			return DataHydration.Game.getGameInfoStore(p6).getAndFetchGameInfo(v40).data(p6)
		end)
	end, { v40 })

	return SignalsReact.useSignalState(v41)
end
local function BuildFullscreenPage(t3: {[any]: any}) -- line: 129
	-- upvalues: useBuildPageLayout (copy), React (copy), FullscreenPageWithSafeArea (copy)
	local v43 = useBuildPageLayout()

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v43.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v43.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v43.shouldIncludeBottomBar and t3.hideBottomBar ~= true
	}, {
		Page = t3.pageContent
	})
end
local function BuildSheetPage(t4: {[any]: any}) -- line: 142
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v45 = useTokens()

	return React.createElement(View, {
		tag = "size-full",
		BackgroundColor3 = v45.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v45.Color.Surface.Surface_0.Transparency
	}, {
		Page = t4.pageContent
	})
end
local function ConfigurationScreen(t5: {[any]: any}, p7, s1: string) -- line: 154
	-- upvalues: BuildNavigationParams (copy), useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), t1 (copy), BuildOverflowMenuPage (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
	local navigation = t5.navigation
	local v50 = t5.screenProps or {}
	local v51 = BuildNavigationParams.getTarget(navigation) or v50.target
	local v52 = if v51 ~= nil then {
		universeId = v51.universeId,
		placeId = v51.placeId,
		sessionId = v51.sessionId,
		experienceName = v51.experienceName,
		gameIcon = v51.gameIcon,
		isNewGameTarget = v51.isNewGameTarget
	} else nil
	local v53 = useGameInfo(if not v52 then nil else v52.universeId)
	local v54 = getTargetWithGameInfo(v52, v53)
	local v55 = React.useCallback(function() -- line: 161
		-- upvalues: v50 (copy), navigation (copy)
		if v50.onClose then
			v50.onClose()

			return
		end

		navigation.goBack()
	end, {
		navigation,
		v50.onClose
	})
	local v56 = React.useCallback(function() -- line: 168
		-- upvalues: v50 (copy), navigation (copy), t1 (copy), v54 (copy)
		if v50.onOpenAudiencePage then
			v50.onOpenAudiencePage()

			return
		end

		navigation.navigate(t1.BuildAudience, {
			target = v54
		})
	end, {
		navigation,
		v50.onOpenAudiencePage,
		v54
	})
	local v57 = React.useCallback(function() -- line: 177
		-- upvalues: v53 (copy), v50 (copy), navigation (copy), t1 (copy), v54 (copy)
		local v85 = v53

		if ((if v85 ~= nil and (not v85.isUnavailable and (typeof(v85.name) == "string" and v85.name ~= "")) then v85.name else nil)) == nil then
			return
		end

		if v50.onOpenTitleDescriptionPage then
			v50.onOpenTitleDescriptionPage()

			return
		end

		navigation.navigate(t1.BuildTitleDescription, {
			target = v54
		})
	end, {
		v53,
		navigation,
		v50.onOpenTitleDescriptionPage,
		v54
	})
	local v58 = React.useCallback(function() -- line: 189
		-- upvalues: v50 (copy), navigation (copy), t1 (copy), v54 (copy)
		if v50.onOpenMediaSelectionPage then
			v50.onOpenMediaSelectionPage()

			return
		end

		navigation.navigate(t1.BuildMediaSelection, {
			target = v54
		})
	end, {
		navigation,
		v50.onOpenMediaSelectionPage,
		v54
	})
	local v59 = if v54 ~= nil then React.createElement(BuildOverflowMenuPage, {
		page = p7,
		target = v54,
		testId = s1,
		onClose = v55,
		onOpenAudiencePage = v56,
		onOpenTitleDescriptionPage = v57,
		onOpenMediaSelectionPage = v58,
		showPreviewButton = v50.showPreviewButton
	}) else nil

	if v50.onClose then
		return React.createElement(BuildSheetPage, {
			pageContent = v59
		})
	end

	return React.createElement(BuildFullscreenPage, {
		pageContent = v59
	})
end
local function BuildTitleDescriptionContent(t6: {[any]: any}) -- line: 269
	-- upvalues: useGameInfo (copy), getTargetWithGameInfo (copy), React (copy), TitleDescriptionPage (copy)
	local v70 = useGameInfo(t6.target.universeId)

	if ((if v70 ~= nil and (not v70.isUnavailable and (typeof(v70.name) == "string" and v70.name ~= "")) then v70.name else nil)) == nil then
		return nil
	end

	local v71 = getTargetWithGameInfo(t6.target, v70)

	if v71 == nil then
		return nil
	end

	return React.createElement(TitleDescriptionPage, {
		universeId = v71.universeId,
		titleText = v71.experienceName or "Loading...",
		descriptionText = v71.description or "",
		onBack = t6.onBack,
		testId = t6.testId
	})
end

return {
	Screens = t1,
	SCREEN_BY_PAGE = t2,
	BuildPublishScreen = function(t7: {[any]: any}) -- line: 223
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t7, "publish", "BuildPage.publish.Page")
	end,
	BuildSettingsScreen = function(t8: {[any]: any}) -- line: 227
		-- upvalues: ConfigurationScreen (copy)
		return ConfigurationScreen(t8, "settings", "BuildPage.settings.Page")
	end,
	BuildAudienceScreen = function(t9: {[any]: any}) -- line: 231
		-- upvalues: BuildNavigationParams (copy), React (copy), OverflowMenuPageShell (copy), IconName (copy), AudienceConfigurationContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t9.navigation
		local v64 = t9.screenProps or {}
		local v65 = BuildNavigationParams.getTarget(navigation) or v64.target
		local v66 = if v65 ~= nil then {
			universeId = v65.universeId,
			placeId = v65.placeId,
			sessionId = v65.sessionId,
			experienceName = v65.experienceName,
			gameIcon = v65.gameIcon,
			isNewGameTarget = v65.isNewGameTarget
		} else nil
		local v67 = React.useCallback(function() -- line: 236
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v68 = if v66 ~= nil then React.createElement(OverflowMenuPageShell, {
			title = "Audience",
			testId = "BuildPage.audience.Page",
			closeIcon = IconName.ChevronLargeLeft,
			onClose = v67,
			content = React.createElement(AudienceConfigurationContent, {
				universeId = v66.universeId
			})
		}) else nil

		if v64.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v68
			})
		end

		return React.createElement(BuildFullscreenPage, {
			pageContent = v68
		})
	end,
	BuildTitleDescriptionScreen = function(t10: {[any]: any}) -- line: 291
		-- upvalues: BuildNavigationParams (copy), useOnScreenKeyboardVisible (copy), React (copy), BuildTitleDescriptionContent (copy), BuildSheetPage (copy), BuildFullscreenPage (copy)
		local navigation = t10.navigation
		local v74 = t10.screenProps or {}
		local v75 = BuildNavigationParams.getTarget(navigation) or v74.target
		local v76 = if v75 ~= nil then {
			universeId = v75.universeId,
			placeId = v75.placeId,
			sessionId = v75.sessionId,
			experienceName = v75.experienceName,
			gameIcon = v75.gameIcon,
			isNewGameTarget = v75.isNewGameTarget
		} else nil
		local v77 = useOnScreenKeyboardVisible()
		local v78 = if v76 ~= nil then React.createElement(BuildTitleDescriptionContent, {
			testId = "BuildPage.titleDescription.Page",
			target = v76,
			onBack = navigation.goBack
		}) else nil

		if v74.onClose then
			return React.createElement(BuildSheetPage, {
				pageContent = v78
			})
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v77,
			pageContent = v78
		})
	end,
	BuildMediaSelectionScreen = function(p8) -- line: 317
		-- upvalues: BuildNavigationParams (copy), useBuildPageLayout (copy), React (copy), MediaSelectionPage (copy), FullscreenPageWithSafeArea (copy)
		local navigation = p8.navigation
		local v81 = BuildNavigationParams.getTarget(navigation)
		local v82 = useBuildPageLayout()
		local v83 = React.useCallback(function() -- line: 322
			-- upvalues: navigation (copy)
			navigation.goBack()
		end, { navigation })
		local v84 = if v81 ~= nil and v81.universeId ~= nil then React.createElement(MediaSelectionPage, {
			onClose = v83,
			universeId = v81.universeId
		}) else nil

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v82.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v82.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v82.shouldIncludeBottomBar
		}, {
			Page = v84
		})
	end
}
