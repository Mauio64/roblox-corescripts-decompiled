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
local FFlagBuildExperiencePageImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePageImpressions")
local useBuildPageImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useBuildPageImpression")
local BuildNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/BuildNavigationParams")
local GameInfoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameInfoUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local useBuildPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useBuildPageLayout")
local useOnScreenKeyboardVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOnScreenKeyboardVisible")

local useTokens = Foundation.Hooks.useTokens
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")
local FFlagBuildExperienceChatOpenId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenId")

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

	local v7 = {
		universeId = data.universeId,
		placeId = data.placeId,
		sessionId = data.sessionId,
		experienceName = data.experienceName,
		gameIcon = data.gameIcon,
		isNewGameTarget = data.isNewGameTarget,
		chatOpenId = 0
	}
	local v8 = if FFlagBuildExperienceChatOpenId then data.chatOpenId else nil
	v7.chatOpenId = v8
	return v7
end

local function getTargetWithGameInfo(target, p2, loading)
	if target == nil then
		return nil
	end

	local v7 = if GameInfoUtils.isGameInfoReady(p2) then p2 else nil
	local creator = if v7 then v7.creator else nil
	local gameInfoName = GameInfoUtils.getGameInfoName(p2)
	local v8 = {
		universeId = target.universeId,
		placeId = 0,
		sessionId = 0,
		experienceName = 0,
		description = 0,
		creatorName = 0,
		gameIcon = 0,
		isCreatorVerified = 0,
		isNewGameTarget = 0
	}
	local v9 = target.placeId

	if not v9 then
		v9 = if v7 then tonumber(v7.rootPlaceId) else nil
	end

	v8.placeId = v9
	v8.sessionId = target.sessionId
	v8.experienceName = gameInfoName
	v8.description = v7 and (v7.description or "") or loading

	if creator and creator.name ~= "" then
		loading = creator.name
	end

	v8.creatorName = loading
	v8.gameIcon = target.gameIcon
	local v10 = if creator then creator.hasVerifiedBadge == true else false
	v8.isCreatorVerified = v10
	v8.isNewGameTarget = target.isNewGameTarget
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
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression(p3, target)
	end

	local useGameInfo = GameInfoUtils.useGameInfo
	local v7 = if target then target.universeId else nil
	local v8 = useGameInfo(v7)
	local targetWithGameInfo = getTargetWithGameInfo(target, v8, loading)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	if FFlagBuildExperiencePageImpressions then
		local v11

		if state2 then
			v11 = not (targetWithGameInfo == nil) and targetWithGameInfo.placeId ~= nil
		else
			v11 = state2
		end

		useBuildPageImpression("version-history", targetWithGameInfo, v11)
	end

	local v9 = React.useCallback(function()
		if screenProps.onClose then
			screenProps.onClose()
		else
			navigation.goBack()
		end
	end, { navigation, screenProps.onClose })
	local v10 = React.useCallback(function()
		if screenProps.onOpenAudiencePage then
			screenProps.onOpenAudiencePage()
		else
			navigation.navigate(v5.BuildAudience, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenAudiencePage, targetWithGameInfo })
	local v11 = React.useCallback(function()
		if not GameInfoUtils.isTitleDescriptionReady(v8) then
			return
		end

		if screenProps.onOpenTitleDescriptionPage then
			screenProps.onOpenTitleDescriptionPage()
		else
			navigation.navigate(v5.BuildTitleDescription, {
				target = targetWithGameInfo
			})
		end
	end, { v8, navigation, screenProps.onOpenTitleDescriptionPage, targetWithGameInfo })
	local v12 = React.useCallback(function()
		if screenProps.onOpenMediaSelectionPage then
			screenProps.onOpenMediaSelectionPage()
		else
			navigation.navigate(v5.BuildMediaSelection, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenMediaSelectionPage, targetWithGameInfo })
	local v13 = React.useCallback(function()
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
	local v14 = React.useCallback(function()
		if targetWithGameInfo == nil or targetWithGameInfo.placeId == nil then
			return
		end

		if screenProps.onOpenVersionHistory then
			screenProps.onOpenVersionHistory()
		else
			setState2(true)
		end
	end, { screenProps.onOpenVersionHistory, targetWithGameInfo })
	local v15

	if FFlagBuildExperienceMonetizationNativeUI then
		v15 = React.useCallback(function()
			navigation.navigate(v5.BuildMonetization, { target = targetWithGameInfo })
		end, { navigation, targetWithGameInfo })
	end

	local v16 = React.useCallback(function()
		setState2(false)
	end, {})
	local v17 = React.useCallback(function()
		setState2(false)
		v9()
	end, { v9 })
	local v18 = React.useCallback(function()
		setState(true)
	end, {})
	local v19 = React.useCallback(function()
		setState(false)
	end, {})
	local v20 = React.useCallback(function()
		navigation.navigate(v5.BuildPlaytestInviteManagement, {
			target = targetWithGameInfo
		})
	end, { navigation, targetWithGameInfo })

	local v21 = React.useCallback(function()
		setState(false)
		v20()
	end, { v20 })
	local v22 = p3 == "settings"
	local v23

	if targetWithGameInfo ~= nil then
		local createElement = React.createElement
		local v25 = {
			page = p3,
			target = targetWithGameInfo,
			testId = p4,
			onClose = v9,
			onOpenAudiencePage = v10,
			onOpenTitleDescriptionPage = v11,
			onOpenMediaSelectionPage = v12,
			onOpenMonetizationPage = nil,
			onOpenVersionTitleDescriptionPage = nil,
			onOpenVersionHistory = nil,
			onOpenPlaytestPicker = nil,
			onOpenPlaytestManagement = nil,
			showPreviewButton = 0
		}

		if not (FFlagBuildExperienceMonetizationNativeUI and v22) then
			v15 = nil
		end

		v25.onOpenMonetizationPage = v15

		v25.onOpenVersionTitleDescriptionPage = v13
		v25.onOpenVersionHistory = v14

		if not v22 then
			v18 = nil
		end

		v25.onOpenPlaytestPicker = v18
		v25.onOpenPlaytestManagement = if v22 then v20 else nil
		v25.showPreviewButton = screenProps.showPreviewButton
		v23 = createElement(BuildOverflowMenuPage, v25)
	end

	local v24

	if screenProps.onClose then
		v24 = React.createElement(BuildSheetPage, { pageContent = v23 })
	else
		v24 = React.createElement(BuildFullscreenPage, { pageContent = v23 })
	end

	local createElement = React.createElement
	local fragment = React.Fragment

	local v27 = if state and targetWithGameInfo ~= nil then React.createElement(PrivateInvitesPickerHost, {
		universeId = targetWithGameInfo.universeId,
		onClose = v19,
		onInvitesSent = v21
	}) else nil

	local v28 = if state2 and targetWithGameInfo ~= nil and targetWithGameInfo.placeId ~= nil then React.createElement(require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryContainer"), {
		universeId = targetWithGameInfo.universeId,
		placeId = targetWithGameInfo.placeId,
		isOpen = true,
		onClose = v16,
		onAgentRollbackStarted = v17,
		testId = "build-publish-version-history"
	}) else nil
	return createElement(fragment, nil, {
		Page = v24,
		Picker = v27,
		VersionHistory = v28
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
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("monetization", target)
		end

		local v7 = screenProps.onClose

		if not FFlagBuildPublishNavigationSheet or v7 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
			v7 = navigation.goBack
		end

		local v8

		if FFlagBuildExperienceMonetizationNativeUI and screenProps.onClose == nil then
			v8 = props.onComposerActivated or v7
		else
			v8 = screenProps.onClose or v7
		end

		local createElement = React.createElement

		local v11 = if target ~= nil then target.placeId else nil
		local v12 = if target ~= nil then target.sessionId else nil
		local v13 = if target ~= nil then target.universeId else nil
		local element = createElement(MonetizationPageContainer, {
			onClose = v7,
			onComposerActivated = v8,
			placeId = v11,
			sessionId = v12,
			universeId = v13
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
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("stats", target)
		end

		local v7 = React.useCallback(function()
			if screenProps.onClose then
				screenProps.onClose()
			else
				navigation.goBack()
			end
		end, { navigation, screenProps.onClose })

		local v8 = React.useCallback(function(p3)
			if screenProps.onOpenChat == nil then
				navigation.navigate(BuildNavigationParams.BUILD_CHAT_SCREEN, {
					target = target,
					initialPrompt = p3
				})
			else
				screenProps.onOpenChat(p3)
			end
		end, { navigation, screenProps.onOpenChat, target })

		local module24 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/AnalyticsOverview")
		local v9

		if target ~= nil then
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v12 = {
				universeId = target.universeId,
				placeId = 0,
				conversationId = 0,
				onOpenChat = 0
			}
			local v13 = if FFlagBuildExperienceEventContextTelemetry then target.placeId else nil
			v12.placeId = v13
			local v14 = if FFlagBuildExperienceEventContextTelemetry then target.sessionId else nil
			v12.conversationId = v14
			v12.onOpenChat = v8
			v9 = createElement(OverflowMenuPageShell, {
				title = stats,
				testId = "BuildPage.stats.Page",
				onClose = v7,
				scrollPerformanceIntervalName = "LuaApp_Build_Stats_Scroll",
				content = createElement2(module24, v12)
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v9 })
		end

		return React.createElement(BuildFullscreenPage, { pageContent = v9 })
	end,
	BuildAudienceScreen = function(p2)
		local v7 = useLocalization({ audience = LocalizationStrings.BUILD_MENU_AUDIENCE })

		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("audience", target)
		end

		local v8 = React.useCallback(function()
			navigation.goBack()
		end, { navigation })
		local v9

		if target ~= nil then
			v9 = React.createElement(OverflowMenuPageShell, {
				title = v7.audience,
				testId = "BuildPage.audience.Page",
				onClose = v8,
				scrollPerformanceIntervalName = "LuaApp_Build_Audience_Scroll",
				content = React.createElement(AudienceConfigurationContent, {
					universeId = target.universeId
				})
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v9 })
		end

		return React.createElement(BuildFullscreenPage, { pageContent = v9 })
	end,
	BuildPrivateInvitesPickerScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		local v7 = React.useCallback(function()
			if screenProps.onClose then
				screenProps.onClose()
			else
				navigation.goBack()
			end
		end, { navigation, screenProps.onClose })

		if target == nil then
			return nil
		end

		return React.createElement(PrivateInvitesPickerContainer, {
			universeId = target.universeId,
			onClose = v7,
			onInvitesSent = v7
		})
	end,
	BuildPlaytestInviteManagementScreen = function(p2)
		local pageTitle = useLocalization({
			pageTitle = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE
		}).pageTitle
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)
		local state, setState = React.useState(false)

		local v7 = React.useCallback(function()
			navigation.goBack()
		end, { navigation })
		local v8 = React.useCallback(function()
			setState(true)
		end, {})
		local v9 = React.useCallback(function()
			setState(false)
		end, {})
		local v10

		if target ~= nil then
			v10 = React.createElement(OverflowMenuPageShell, {
				title = pageTitle,
				testId = "BuildPage.playtestInviteManagement.Page",
				onClose = v7,
				content = React.createElement(PrivateInvitesManagementContainer, {
					universeId = target.universeId,
					onOpenInvitePicker = v8
				})
			})
		end

		local v11

		if screenProps.onClose then
			v11 = React.createElement(BuildSheetPage, { pageContent = v10 })
		else
			v11 = React.createElement(BuildFullscreenPage, { pageContent = v10 })
		end

		local createElement = React.createElement
		local fragment = React.Fragment

		local v14 = if state and target ~= nil then React.createElement(PrivateInvitesPickerHost, {
			universeId = target.universeId,
			onClose = v9,
			onInvitesSent = v9
		}) else nil
		return createElement(fragment, nil, { Page = v11, Picker = v14 })
	end,
	BuildTitleDescriptionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("title-description", target)
		end

		local v7 = useOnScreenKeyboardVisible()
		local v8

		if target ~= nil then
			local createElement = React.createElement

			local v11 = screenProps.onClose

			if not FFlagBuildPublishNavigationSheet or v11 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
				v11 = navigation.goBack
			end

			v8 = createElement(BuildTitleDescriptionContent, {
				target = target,
				onBack = v11,
				testId = "BuildPage.titleDescription.Page"
			})
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v8 })
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v7,
			pageContent = v8
		})
	end,
	BuildVersionTitleDescriptionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("version-title-description", target)
		end

		local v7 = useOnScreenKeyboardVisible()
		local v8

		if not (target == nil or target.placeId == nil) then
			local createElement = React.createElement
			local module24 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionTitleDescriptionPage/VersionTitleDescriptionPageContainer")
			local v9 = {
				placeId = target.placeId,
				onBack = 0,
				testId = "BuildPage.versionTitleDescription.Page"
			}
			local v10 = screenProps.onClose

			if not FFlagBuildPublishNavigationSheet or v10 == nil or not BuildNavigationParams.getShouldDismissOnBack(navigation) then
				v10 = navigation.goBack
			end

			v9.onBack = v10
			v8 = createElement(module24, v9)
		end

		if screenProps.onClose then
			return React.createElement(BuildSheetPage, { pageContent = v8 })
		end

		return React.createElement(BuildFullscreenPage, {
			hideBottomBar = v7,
			pageContent = v8
		})
	end,
	BuildMediaSelectionScreen = function(p2)
		local navigation = p2.navigation
		local screenProps = p2.screenProps or {}
		local target = BuildNavigationParams.getTarget(navigation)

		if FFlagBuildExperiencePageImpressions then
			useBuildPageImpression("media-selection", target)
		end

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
