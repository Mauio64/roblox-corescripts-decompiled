require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local fFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppBlox").FullscreenPageWithSafeArea
local view = Foundation.View

local AudienceConfigurationContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/AudienceConfigurationContent/AudienceConfigurationContent")
local PrivateInvitesPickerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerContainer")
local PrivateInvitesPickerHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerHost")

local PrivateInvitesManagementContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PrivateInvitesManagement/PrivateInvitesManagementContainer")
local BuildOverflowMenuPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuPage")
local OverflowMenuPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/OverflowMenuPageShell")
local TitleDescriptionPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/TitleDescriptionPage/TitleDescriptionPage")
local MediaSelectionPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/MediaSelectionPage")
local MonetizationPageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageContainer")
local FFlagBuildPublishNavigationSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPublishNavigationSheet")
local BuildNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/BuildNavigationParams")
local GameInfoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameInfoUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local useBuildPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useBuildPageLayout")
local useOnScreenKeyboardVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOnScreenKeyboardVisible")

local useTokens = Foundation.Hooks.useTokens
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")

local v5 = {
	BuildPublish = "BuildPublish",
	BuildSettings = "BuildSettings",
	BuildAudience = "BuildAudience",
	BuildPrivateInvitesPicker = "BuildPrivateInvitesPicker",
	BuildPlaytestInviteManagement = "BuildPlaytestInviteManagement",
	BuildTitleDescription = "BuildTitleDescription",
	BuildVersionTitleDescription = "BuildVersionTitleDescription",
	BuildMediaSelection = "BuildMediaSelection",
	BuildMonetization = "BuildMonetization",
	BuildStats = "BuildStats"
}

local v6 = { publish = v5.BuildPublish, settings = v5.BuildSettings }

if FFlagBuildExperienceMonetizationNativeUI then
	v6.monetization = v5.BuildMonetization
end

if fFlagBuildExperienceAnalytics then
	v6.stats = v5.BuildStats
end

local function normalizeTarget(data)
	if data == nil then
		return nil
	end

	return {
		universeId = data.universeId,
		placeId = data.placeId,
		sessionId = data.sessionId,
		experienceName = data.experienceName,
		gameIcon = data.gameIcon,
		isNewGameTarget = data.isNewGameTarget
	}
end

local function getTargetWithGameInfo(data, p2, loading)
	if data == nil then
		return nil
	end

	local v7 = if GameInfoUtils.isGameInfoReady(p2) then p2 else nil
	local creator = if v7 then v7.creator else nil
	local gameInfoName = GameInfoUtils.getGameInfoName(p2)
	local v8 = {
		universeId = data.universeId,
		placeId = 0,
		sessionId = 0,
		experienceName = 0,
		description = 0,
		creatorName = 0,
		gameIcon = 0,
		isCreatorVerified = 0,
		isNewGameTarget = 0
	}
	local v9 = data.placeId

	if not v9 then
		v9 = if v7 then tonumber(v7.rootPlaceId) else nil
	end

	v8.placeId = v9
	v8.sessionId = data.sessionId
	v8.experienceName = gameInfoName
	v8.description = v7 and (v7.description or "") or loading

	if creator and creator.name ~= "" then
		loading = creator.name
	end

	v8.creatorName = loading
	v8.gameIcon = data.gameIcon
	local v10 = if creator then creator.hasVerifiedBadge == true else false
	v8.isCreatorVerified = v10
	v8.isNewGameTarget = data.isNewGameTarget
	return v8
end

local function BuildFullscreenPage(p2)
	local v7 = useBuildPageLayout()

	return React.createElement(fullscreenPageWithSafeArea, {
		BackgroundColor3 = v7.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v7.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v7.shouldIncludeBottomBar and p2.hideBottomBar ~= true,
		includeStatusBar = true
	}, { Page = p2.pageContent })
end

local function BuildSheetPage(p2)
	local v7 = useTokens()

	return React.createElement(
		view,
		{
			BackgroundColor3 = v7.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v7.Color.Surface.Surface_0.Transparency,
			tag = "size-full"
		},
		{ Page = p2.pageContent }
	)
end

local function ConfigurationScreen(p2, p3, p4)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local navigation = p2.navigation
	local screenProps = p2.screenProps or {}
	local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
	local v8 = v7 ~= nil and {
		universeId = v7.universeId,
		placeId = v7.placeId,
		sessionId = v7.sessionId,
		experienceName = v7.experienceName,
		gameIcon = v7.gameIcon,
		isNewGameTarget = v7.isNewGameTarget
	} or nil

	local useGameInfo = GameInfoUtils.useGameInfo
	local v9 = if v8 then v8.universeId else nil
	local v10 = useGameInfo(v9)
	local targetWithGameInfo = getTargetWithGameInfo(v8, v10, loading)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v11 = React.useCallback(function()
		if screenProps.onClose then
			screenProps.onClose()
		else
			navigation.goBack()
		end
	end, { navigation, screenProps.onClose })
	local v12 = React.useCallback(function()
		if screenProps.onOpenAudiencePage then
			screenProps.onOpenAudiencePage()
		else
			navigation.navigate(v5.BuildAudience, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenAudiencePage, targetWithGameInfo })
	local v13 = React.useCallback(function()
		if not GameInfoUtils.isTitleDescriptionReady(v10) then
			return
		end

		if screenProps.onOpenTitleDescriptionPage then
			screenProps.onOpenTitleDescriptionPage()
		else
			navigation.navigate(v5.BuildTitleDescription, {
				target = targetWithGameInfo
			})
		end
	end, { v10, navigation, screenProps.onOpenTitleDescriptionPage, targetWithGameInfo })
	local v14 = React.useCallback(function()
		if screenProps.onOpenMediaSelectionPage then
			screenProps.onOpenMediaSelectionPage()
		else
			navigation.navigate(v5.BuildMediaSelection, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenMediaSelectionPage, targetWithGameInfo })
	local v15 = React.useCallback(function()
		if targetWithGameInfo == nil or targetWithGameInfo.placeId == nil then
			return
		end

		if screenProps.onOpenVersionTitleDescriptionPage then
			screenProps.onOpenVersionTitleDescriptionPage()
		else
			navigation.navigate(v5.BuildVersionTitleDescription, {
				target = targetWithGameInfo
			})
		end
	end, { navigation, screenProps.onOpenVersionTitleDescriptionPage, targetWithGameInfo })
	local v16 = React.useCallback(function()
		if targetWithGameInfo == nil or targetWithGameInfo.placeId == nil then
			return
		end

		if screenProps.onOpenVersionHistory then
			screenProps.onOpenVersionHistory()
		else
			setState2(true)
		end
	end, { screenProps.onOpenVersionHistory, targetWithGameInfo })
	local v17

	if FFlagBuildExperienceMonetizationNativeUI then
		v17 = React.useCallback(function()
			navigation.navigate(v5.BuildMonetization, { target = targetWithGameInfo })
		end, { navigation, targetWithGameInfo })
	end

	local v18 = React.useCallback(function()
		setState2(false)
	end, {})
	local v19 = React.useCallback(function()
		setState2(false)
		v11()
	end, { v11 })
	local v20 = React.useCallback(function()
		setState(true)
	end, {})
	local v21 = React.useCallback(function()
		setState(false)
	end, {})
	local v22 = React.useCallback(function()
		navigation.navigate(v5.BuildPlaytestInviteManagement, {
			target = targetWithGameInfo
		})
	end, { navigation, targetWithGameInfo })

	local v23 = React.useCallback(function()
		setState(false)
		v22()
	end, { v22 })
	local v24 = p3 == "settings"
	local v25

	if targetWithGameInfo ~= nil then
		local createElement = React.createElement
		local v27 = {
			page = p3,
			target = targetWithGameInfo,
			testId = p4,
			onClose = v11,
			onOpenAudiencePage = v12,
			onOpenTitleDescriptionPage = v13,
			onOpenMediaSelectionPage = v14,
			onOpenMonetizationPage = nil,
			onOpenVersionTitleDescriptionPage = nil,
			onOpenVersionHistory = nil,
			onOpenPlaytestPicker = nil,
			onOpenPlaytestManagement = nil,
			showPreviewButton = 0
		}

		if not (FFlagBuildExperienceMonetizationNativeUI and v24) then
			v17 = nil
		end

		v27.onOpenMonetizationPage = v17

		v27.onOpenVersionTitleDescriptionPage = v15
		v27.onOpenVersionHistory = v16

		if not v24 then
			v20 = nil
		end

		v27.onOpenPlaytestPicker = v20
		v27.onOpenPlaytestManagement = if v24 then v22 else nil
		v27.showPreviewButton = screenProps.showPreviewButton
		v25 = createElement(BuildOverflowMenuPage, v27)
	end

	local v26

	if screenProps.onClose then
		v26 = React.createElement(BuildSheetPage, { pageContent = v25 })
	else
		v26 = React.createElement(BuildFullscreenPage, { pageContent = v25 })
	end

	local createElement = React.createElement
	local fragment = React.Fragment

	local v29 = if state and targetWithGameInfo ~= nil then React.createElement(PrivateInvitesPickerHost, {
		universeId = targetWithGameInfo.universeId,
		onClose = v21,
		onInvitesSent = v23
	}) else nil

	local v30 = if state2 and targetWithGameInfo ~= nil and targetWithGameInfo.placeId ~= nil then React.createElement(require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryContainer"), {
		universeId = targetWithGameInfo.universeId,
		placeId = targetWithGameInfo.placeId,
		isOpen = true,
		onClose = v18,
		onAgentRollbackStarted = v19,
		testId = "build-publish-version-history"
	}) else nil
	return createElement(fragment, nil, {
		Page = v26,
		Picker = v29,
		VersionHistory = v30
	})
end

local function resolveSubPageDismiss(p2, p3)
	if FFlagBuildPublishNavigationSheet and p3 ~= nil and BuildNavigationParams.getShouldDismissOnBack(p2) then
		return p3
	end

	return p2.goBack
end

local function BuildTitleDescriptionContent(props)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local v7 = GameInfoUtils.useGameInfo(props.target.universeId)

	if not GameInfoUtils.isTitleDescriptionReady(v7) then
		return nil
	end

	local targetWithGameInfo = getTargetWithGameInfo(props.target, v7, loading)

	if targetWithGameInfo == nil then
		return nil
	end

	return React.createElement(TitleDescriptionPage, {
		universeId = targetWithGameInfo.universeId,
		titleText = targetWithGameInfo.experienceName or loading,
		descriptionText = targetWithGameInfo.description or "",
		onBack = props.onBack,
		testId = props.testId
	})
end

return {
	Screens = v5,
	SCREEN_BY_PAGE = v6,
	BuildPublishScreen = function(p2)
		return ConfigurationScreen(p2, "publish", "BuildPage.publish.Page")
	end,
	BuildSettingsScreen = function(p2)
		return ConfigurationScreen(p2, "settings", "BuildPage.settings.Page")
	end,
	BuildMonetizationScreen = function(props)
		local navigation = props.navigation
		local screenProps = props.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local v9 = screenProps.onClose

		if not FFlagBuildPublishNavigationSheet or v9 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
			v9 = navigation.goBack
		end

		local v10

		if FFlagBuildExperienceMonetizationNativeUI and screenProps.onClose == nil then
			v10 = props.onComposerActivated or v9
		else
			v10 = screenProps.onClose or v9
		end

		local createElement = React.createElement

		local v13 = if v8 ~= nil then v8.placeId else nil
		local v14 = if v8 ~= nil then v8.sessionId else nil
		local v15 = if v8 ~= nil then v8.universeId else nil
		local element = createElement(MonetizationPageContainer, {
			onClose = v9,
			onComposerActivated = v10,
			placeId = v13,
			sessionId = v14,
			universeId = v15
		})

		if screenProps.onClose then
			return (React.createElement(BuildSheetPage, { pageContent = element }))
		end

		return (React.createElement(BuildFullscreenPage, { pageContent = element }))
	end,
	BuildStatsScreen = function(p2)
		local stats = useLocalization({ stats = LocalizationStrings.BUILD_MENU_STATS }).stats
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local v9 = React.useCallback(function()
			if screenProps.onClose then
				screenProps.onClose()
			else
				navigation.goBack()
			end
		end, { navigation, screenProps.onClose })

		local v10 = React.useCallback(function(p3)
			if screenProps.onOpenChat == nil then
				navigation.navigate(BuildNavigationParams.BUILD_CHAT_SCREEN, {
					target = v8,
					initialPrompt = p3
				})
			else
				screenProps.onOpenChat(p3)
			end
		end, { navigation, screenProps.onOpenChat, v8 })

		local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/AnalyticsOverview")
		local v11

		if v8 ~= nil then
			v11 = React.createElement(OverflowMenuPageShell, {
				title = stats,
				testId = "BuildPage.stats.Page",
				onClose = v9,
				scrollPerformanceIntervalName = "LuaApp_Build_Stats_Scroll",
				content = React.createElement(module20, {
					universeId = v8.universeId,
					onOpenChat = v10
				})
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v11 })
		end

		return React.createElement(BuildFullscreenPage, { pageContent = v11 })
	end,
	BuildAudienceScreen = function(p2)
		local v7 = useLocalization({ audience = LocalizationStrings.BUILD_MENU_AUDIENCE })

		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v8 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v9 = v8 ~= nil and {
			universeId = v8.universeId,
			placeId = v8.placeId,
			sessionId = v8.sessionId,
			experienceName = v8.experienceName,
			gameIcon = v8.gameIcon,
			isNewGameTarget = v8.isNewGameTarget
		} or nil

		local v10 = React.useCallback(function()
			navigation.goBack()
		end, { navigation })
		local v11

		if v9 ~= nil then
			v11 = React.createElement(OverflowMenuPageShell, {
				title = v7.audience,
				testId = "BuildPage.audience.Page",
				onClose = v10,
				scrollPerformanceIntervalName = "LuaApp_Build_Audience_Scroll",
				content = React.createElement(AudienceConfigurationContent, { universeId = v9.universeId })
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v11 })
		end

		return React.createElement(BuildFullscreenPage, { pageContent = v11 })
	end,
	BuildPrivateInvitesPickerScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local v9 = React.useCallback(function()
			if screenProps.onClose then
				screenProps.onClose()
			else
				navigation.goBack()
			end
		end, { navigation, screenProps.onClose })

		if v8 == nil then
			return nil
		end

		return React.createElement(PrivateInvitesPickerContainer, {
			universeId = v8.universeId,
			onClose = v9,
			onInvitesSent = v9
		})
	end,
	BuildPlaytestInviteManagementScreen = function(p2)
		local pageTitle = useLocalization({
			pageTitle = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE
		}).pageTitle
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local state, setState = React.useState(false)

		local v9 = React.useCallback(function()
			navigation.goBack()
		end, { navigation })
		local v10 = React.useCallback(function()
			setState(true)
		end, {})
		local v11 = React.useCallback(function()
			setState(false)
		end, {})
		local v12

		if v8 ~= nil then
			v12 = React.createElement(OverflowMenuPageShell, {
				title = pageTitle,
				testId = "BuildPage.playtestInviteManagement.Page",
				onClose = v9,
				content = React.createElement(PrivateInvitesManagementContainer, {
					universeId = v8.universeId,
					onOpenInvitePicker = v10
				})
			})
		end

		local v13

		if screenProps.onClose then
			v13 = React.createElement(BuildSheetPage, { pageContent = v12 })
		else
			v13 = React.createElement(BuildFullscreenPage, { pageContent = v12 })
		end

		local createElement = React.createElement
		local fragment = React.Fragment

		local v16 = if state and v8 ~= nil then React.createElement(PrivateInvitesPickerHost, {
			universeId = v8.universeId,
			onClose = v11,
			onInvitesSent = v11
		}) else nil
		return createElement(fragment, nil, { Page = v13, Picker = v16 })
	end,
	BuildTitleDescriptionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local v9 = useOnScreenKeyboardVisible()
		local v10

		if v8 ~= nil then
			local createElement = React.createElement

			local v13 = screenProps.onClose

			if not FFlagBuildPublishNavigationSheet or v13 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
				v13 = navigation.goBack
			end

			v10 = createElement(BuildTitleDescriptionContent, {
				target = v8,
				onBack = v13,
				testId = "BuildPage.titleDescription.Page"
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v10 })
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v9,
			pageContent = v10
		})
	end,
	BuildVersionTitleDescriptionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local v7 = BuildNavigationParams.getTarget(navigation) or screenProps.target
		local v8 = v7 ~= nil and {
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = v7.sessionId,
			experienceName = v7.experienceName,
			gameIcon = v7.gameIcon,
			isNewGameTarget = v7.isNewGameTarget
		} or nil

		local v9 = useOnScreenKeyboardVisible()
		local v10

		if not (v8 == nil or v8.placeId == nil) then
			local createElement = React.createElement
			local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionTitleDescriptionPage/VersionTitleDescriptionPageContainer")
			local v11 = {
				placeId = v8.placeId,
				onBack = 0,
				testId = "BuildPage.versionTitleDescription.Page"
			}
			local v12 = screenProps.onClose

			if not FFlagBuildPublishNavigationSheet or v12 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
				v12 = navigation.goBack
			end

			v11.onBack = v12
			v10 = createElement(module20, v11)
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v10 })
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v9,
			pageContent = v10
		})
	end,
	BuildMediaSelectionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = BuildNavigationParams.getTarget(navigation)

		local v7 = screenProps.onClose

		if not FFlagBuildPublishNavigationSheet or v7 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
			v7 = navigation.goBack
		end

		local v8

		if not (target == nil or target.universeId == nil) then
			v8 = React.createElement(MediaSelectionPage, {
				onClose = v7,
				universeId = target.universeId
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v8 })
		end

		return React.createElement(BuildFullscreenPage, { pageContent = v8 })
	end
}
