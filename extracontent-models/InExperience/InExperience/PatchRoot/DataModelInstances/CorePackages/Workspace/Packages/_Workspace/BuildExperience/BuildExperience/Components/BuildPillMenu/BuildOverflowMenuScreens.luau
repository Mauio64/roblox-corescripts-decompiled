local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local View = Foundation.View

local AudienceConfigurationContent = require(BuildExperience.Components.GameConfigurations.AudienceConfigurationContent.AudienceConfigurationContent)
local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)
local PrivateInvitesPickerHost = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerHost)

local PrivateInvitesManagementContainer = require(BuildExperience.Components.GameConfigurations.PrivateInvitesManagement.PrivateInvitesManagementContainer)
local BuildOverflowMenuPage = require(script.Parent.BuildOverflowMenuPage)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local TitleDescriptionPage = require(BuildExperience.Components.TitleDescriptionPage.TitleDescriptionPage)
local MediaSelectionPage = require(BuildExperience.Components.MediaSelectionPage.MediaSelectionPage)
local MonetizationPageContainer = require(BuildExperience.Components.MonetizationPage.MonetizationPageContainer)
local FFlagBuildPublishNavigationSheet = require(BuildExperience.Flags.FFlagBuildPublishNavigationSheet)
local FFlagBuildExperiencePageImpressions = require(BuildExperience.Flags.FFlagBuildExperiencePageImpressions)
local useBuildPageImpression = require(BuildExperience.Telemetry.useBuildPageImpression)
local BuildNavigationParams = require(BuildExperience.utils.BuildNavigationParams)
local GameInfoUtils = require(BuildExperience.utils.GameInfoUtils)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local useBuildPageLayout = require(BuildExperience.utils.useBuildPageLayout)
local useOnScreenKeyboardVisible = require(BuildExperience.utils.useOnScreenKeyboardVisible)

local useTokens = Foundation.Hooks.useTokens
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)
local FFlagBuildExperienceChatOpenId = require(BuildExperience.Flags.FFlagBuildExperienceChatOpenId)

local screens = {
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

local v = { publish = screens.BuildPublish, settings = screens.BuildSettings }

if FFlagBuildExperienceMonetizationNativeUI then
	v.monetization = screens.BuildMonetization
end

if FFlagBuildExperienceAnalytics then
	v.stats = screens.BuildStats
end

local function normalizeTarget(data)
	if data == nil then
		return nil
	end

	local v2 = {
		universeId = data.universeId,
		placeId = data.placeId,
		sessionId = data.sessionId,
		experienceName = data.experienceName,
		gameIcon = data.gameIcon,
		isNewGameTarget = data.isNewGameTarget,
		chatOpenId = 0
	}
	local chatOpenId

	if FFlagBuildExperienceChatOpenId then
		chatOpenId = data.chatOpenId
	end

	v2.chatOpenId = chatOpenId
	return v2
end

local function getTargetWithGameInfo(target, p, loading: string)
	if target == nil then
		return nil
	end

	local v2

	if GameInfoUtils.isGameInfoReady(p) then
		v2 = p
	end

	local creator

	if v2 then
		creator = v2.creator
	end

	local gameInfoName = GameInfoUtils.getGameInfoName(p)
	local v3 = {
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
	local placeId = target.placeId

	if not placeId then
		if v2 then
			placeId = tonumber(v2.rootPlaceId)
		else
			placeId = nil
		end
	end

	v3.placeId = placeId
	v3.sessionId = target.sessionId
	v3.experienceName = gameInfoName
	v3.description = v2 and (v2.description or "") or loading

	if creator and creator.name ~= "" then
		loading = creator.name
	end

	v3.creatorName = loading
	v3.gameIcon = target.gameIcon
	local isCreatorVerified

	if creator then
		isCreatorVerified = creator.hasVerifiedBadge == true
	else
		isCreatorVerified = false
	end

	v3.isCreatorVerified = isCreatorVerified
	v3.isNewGameTarget = target.isNewGameTarget
	return v3
end

local function BuildFullscreenPage(p)
	local v2 = useBuildPageLayout()

	return React.createElement(FullscreenPageWithSafeArea, {
		BackgroundColor3 = v2.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v2.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v2.shouldIncludeBottomBar and p.hideBottomBar ~= true,
		includeStatusBar = true
	}, { Page = p.pageContent })
end

local function BuildSheetPage(p)
	local v2 = useTokens()

	return React.createElement(
		View,
		{
			BackgroundColor3 = v2.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v2.Color.Surface.Surface_0.Transparency,
			tag = "size-full"
		},
		{ Page = p.pageContent }
	)
end

local function ConfigurationScreen(p, page: string, testId: string)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression(page, target)
	end

	local useGameInfo = GameInfoUtils.useGameInfo
	local v2

	if target then
		v2 = target.universeId
	end

	local v3 = useGameInfo(v2)
	local targetWithGameInfo = getTargetWithGameInfo(target, v3, loading)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	if FFlagBuildExperiencePageImpressions then
		local v4

		if state2 then
			if targetWithGameInfo == nil then
				v4 = false
			else
				v4 = targetWithGameInfo.placeId ~= nil
			end
		else
			v4 = state2
		end

		useBuildPageImpression("version-history", targetWithGameInfo, v4)
	end

	local onClose = React.useCallback(function()
		if screenProps.onClose then
			screenProps.onClose()
		else
			navigation.goBack()
		end
	end, { navigation, screenProps.onClose })
	local onOpenAudiencePage = React.useCallback(function()
		if screenProps.onOpenAudiencePage then
			screenProps.onOpenAudiencePage()
		else
			navigation.navigate(screens.BuildAudience, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenAudiencePage, targetWithGameInfo })
	local onOpenTitleDescriptionPage = React.useCallback(function()
		if not GameInfoUtils.isTitleDescriptionReady(v3) then
			return
		end

		if screenProps.onOpenTitleDescriptionPage then
			screenProps.onOpenTitleDescriptionPage()
		else
			navigation.navigate(screens.BuildTitleDescription, { target = targetWithGameInfo })
		end
	end, { v3, navigation, screenProps.onOpenTitleDescriptionPage, targetWithGameInfo })
	local onOpenMediaSelectionPage = React.useCallback(function()
		if screenProps.onOpenMediaSelectionPage then
			screenProps.onOpenMediaSelectionPage()
		else
			navigation.navigate(screens.BuildMediaSelection, { target = targetWithGameInfo })
		end
	end, { navigation, screenProps.onOpenMediaSelectionPage, targetWithGameInfo })
	local onOpenVersionTitleDescriptionPage = React.useCallback(function()
		if targetWithGameInfo == nil or targetWithGameInfo.placeId == nil then
			return
		end

		if screenProps.onOpenVersionTitleDescriptionPage then
			screenProps.onOpenVersionTitleDescriptionPage()
		else
			navigation.navigate(screens.BuildVersionTitleDescription, {
				target = targetWithGameInfo
			})
		end
	end, { navigation, screenProps.onOpenVersionTitleDescriptionPage, targetWithGameInfo })
	local onOpenVersionHistory = React.useCallback(function()
		if targetWithGameInfo == nil or targetWithGameInfo.placeId == nil then
			return
		end

		if screenProps.onOpenVersionHistory then
			screenProps.onOpenVersionHistory()
		else
			setState2(true)
		end
	end, { screenProps.onOpenVersionHistory, targetWithGameInfo })
	local onOpenMonetizationPage

	if FFlagBuildExperienceMonetizationNativeUI then
		onOpenMonetizationPage = React.useCallback(function()
			navigation.navigate(screens.BuildMonetization, { target = targetWithGameInfo })
		end, { navigation, targetWithGameInfo })
	end

	local onClose2 = React.useCallback(function()
		setState2(false)
	end, {})
	local onAgentRollbackStarted = React.useCallback(function()
		setState2(false)
		onClose()
	end, { onClose })
	local onOpenPlaytestPicker = React.useCallback(function()
		setState(true)
	end, {})
	local onClose3 = React.useCallback(function()
		setState(false)
	end, {})
	local v4 = React.useCallback(function()
		navigation.navigate(screens.BuildPlaytestInviteManagement, { target = targetWithGameInfo })
	end, { navigation, targetWithGameInfo })

	local onInvitesSent = React.useCallback(function()
		setState(false)
		v4()
	end, { v4 })
	local v5 = page == "settings"
	local pageContent

	if targetWithGameInfo ~= nil then
		local createElement = React.createElement
		local v6 = {
			page = page,
			target = targetWithGameInfo,
			testId = testId,
			onClose = onClose,
			onOpenAudiencePage = onOpenAudiencePage,
			onOpenTitleDescriptionPage = onOpenTitleDescriptionPage,
			onOpenMediaSelectionPage = onOpenMediaSelectionPage,
			onOpenMonetizationPage = nil,
			onOpenVersionTitleDescriptionPage = nil,
			onOpenVersionHistory = nil,
			onOpenPlaytestPicker = nil,
			onOpenPlaytestManagement = nil,
			showPreviewButton = 0
		}

		if not (FFlagBuildExperienceMonetizationNativeUI and v5) then
			onOpenMonetizationPage = nil
		end

		v6.onOpenMonetizationPage = onOpenMonetizationPage

		v6.onOpenVersionTitleDescriptionPage = onOpenVersionTitleDescriptionPage
		v6.onOpenVersionHistory = onOpenVersionHistory

		if not v5 then
			onOpenPlaytestPicker = nil
		end

		v6.onOpenPlaytestPicker = onOpenPlaytestPicker
		local onOpenPlaytestManagement

		if v5 then
			onOpenPlaytestManagement = v4
		end

		v6.onOpenPlaytestManagement = onOpenPlaytestManagement
		v6.showPreviewButton = screenProps.showPreviewButton
		pageContent = createElement(BuildOverflowMenuPage, v6)
	end

	local page2

	if screenProps.onClose then
		page2 = React.createElement(BuildSheetPage, { pageContent = pageContent })
	else
		page2 = React.createElement(BuildFullscreenPage, { pageContent = pageContent })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local picker

	if state and targetWithGameInfo ~= nil then
		picker = React.createElement(PrivateInvitesPickerHost, {
			universeId = targetWithGameInfo.universeId,
			onClose = onClose3,
			onInvitesSent = onInvitesSent
		})
	end

	local versionHistory

	if state2 and targetWithGameInfo ~= nil and targetWithGameInfo.placeId ~= nil then
		local createElement2 = React.createElement
		local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
		versionHistory = createElement2(VersionHistoryContainer, {
			universeId = targetWithGameInfo.universeId,
			placeId = targetWithGameInfo.placeId,
			isOpen = true,
			onClose = onClose2,
			onAgentRollbackStarted = onAgentRollbackStarted,
			testId = "build-publish-version-history"
		})
	end

	return createElement(fragment, nil, {
		Page = page2,
		Picker = picker,
		VersionHistory = versionHistory
	})
end

local function resolveSubPageDismiss(navigation, onClose) -- 4 equivalent calls inferred from this helper
	if
		FFlagBuildPublishNavigationSheet
		and onClose ~= nil
		and BuildNavigationParams.getShouldDismissOnBack(navigation)
	then
		return onClose
	end

	return navigation.goBack
end

local function BuildTitleDescriptionContent(props)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local v2 = GameInfoUtils.useGameInfo(props.target.universeId)

	if not GameInfoUtils.isTitleDescriptionReady(v2) then
		return nil
	end

	local targetWithGameInfo = getTargetWithGameInfo(props.target, v2, loading)

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

local BuildOverflowMenuScreens = {}
BuildOverflowMenuScreens.Screens = screens
BuildOverflowMenuScreens.SCREEN_BY_PAGE = v

function BuildOverflowMenuScreens.BuildPublishScreen(p)
	return ConfigurationScreen(p, "publish", "BuildPage.publish.Page")
end

function BuildOverflowMenuScreens.BuildSettingsScreen(p)
	return ConfigurationScreen(p, "settings", "BuildPage.settings.Page")
end

function BuildOverflowMenuScreens.BuildMonetizationScreen(props)
	local navigation = props.navigation
	local screenProps = props.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("monetization", target)
	end

	local subPageDismiss = resolveSubPageDismiss(navigation, screenProps.onClose) -- inferred equivalent call
	local onComposerActivated

	if FFlagBuildExperienceMonetizationNativeUI and screenProps.onClose == nil then
		onComposerActivated = props.onComposerActivated or subPageDismiss
	else
		onComposerActivated = screenProps.onClose or subPageDismiss
	end

	local createElement = React.createElement
	local placeId

	if target ~= nil then
		placeId = target.placeId
	end

	local sessionId

	if target ~= nil then
		sessionId = target.sessionId
	end

	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	local element = createElement(MonetizationPageContainer, {
		onClose = subPageDismiss,
		onComposerActivated = onComposerActivated,
		placeId = placeId,
		sessionId = sessionId,
		universeId = universeId
	})

	if screenProps.onClose then
		return (React.createElement(BuildSheetPage, { pageContent = element }))
	end

	return (React.createElement(BuildFullscreenPage, { pageContent = element }))
end

function BuildOverflowMenuScreens.BuildStatsScreen(p)
	local stats = useLocalization({ stats = LocalizationStrings.BUILD_MENU_STATS }).stats
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("stats", target)
	end

	local onClose = React.useCallback(function()
		if screenProps.onClose then
			screenProps.onClose()
		else
			navigation.goBack()
		end
	end, { navigation, screenProps.onClose })

	local onOpenChat = React.useCallback(function(initialPrompt: string)
		if screenProps.onOpenChat == nil then
			navigation.navigate(BuildNavigationParams.BUILD_CHAT_SCREEN, {
				target = target,
				initialPrompt = initialPrompt
			})
		else
			screenProps.onOpenChat(initialPrompt)
		end
	end, { navigation, screenProps.onOpenChat, target })

	local AnalyticsOverview = require(BuildExperience.Components.Analytics.Overview.AnalyticsOverview)
	local pageContent

	if target ~= nil then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v2 = {
			universeId = target.universeId,
			placeId = 0,
			conversationId = 0,
			onOpenChat = 0
		}
		local placeId

		if FFlagBuildExperienceEventContextTelemetry then
			placeId = target.placeId
		end

		v2.placeId = placeId
		local conversationId

		if FFlagBuildExperienceEventContextTelemetry then
			conversationId = target.sessionId
		end

		v2.conversationId = conversationId
		v2.onOpenChat = onOpenChat
		pageContent = createElement(OverflowMenuPageShell, {
			title = stats,
			testId = "BuildPage.stats.Page",
			onClose = onClose,
			scrollPerformanceIntervalName = "LuaApp_Build_Stats_Scroll",
			content = createElement2(AnalyticsOverview, v2)
		})
	end

	if screenProps.onClose then
		return React.createElement(BuildSheetPage, { pageContent = pageContent })
	end

	return React.createElement(BuildFullscreenPage, { pageContent = pageContent })
end

function BuildOverflowMenuScreens.BuildAudienceScreen(p)
	local v2 = useLocalization({ audience = LocalizationStrings.BUILD_MENU_AUDIENCE })

	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("audience", target)
	end

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local pageContent

	if target ~= nil then
		pageContent = React.createElement(OverflowMenuPageShell, {
			title = v2.audience,
			testId = "BuildPage.audience.Page",
			onClose = onClose,
			scrollPerformanceIntervalName = "LuaApp_Build_Audience_Scroll",
			content = React.createElement(AudienceConfigurationContent, {
				universeId = target.universeId
			})
		})
	end

	if screenProps.onClose then
		return React.createElement(BuildSheetPage, { pageContent = pageContent })
	end

	return React.createElement(BuildFullscreenPage, { pageContent = pageContent })
end

function BuildOverflowMenuScreens.BuildPrivateInvitesPickerScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	local v2 = React.useCallback(function()
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
		onClose = v2,
		onInvitesSent = v2
	})
end

function BuildOverflowMenuScreens.BuildPlaytestInviteManagementScreen(p)
	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.PRIVATE_INVITES_PAGE_TITLE }).pageTitle
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)
	local state, setState = React.useState(false)

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local onOpenInvitePicker = React.useCallback(function()
		setState(true)
	end, {})
	local v2 = React.useCallback(function()
		setState(false)
	end, {})
	local pageContent

	if target ~= nil then
		pageContent = React.createElement(OverflowMenuPageShell, {
			title = pageTitle,
			testId = "BuildPage.playtestInviteManagement.Page",
			onClose = onClose,
			content = React.createElement(PrivateInvitesManagementContainer, {
				universeId = target.universeId,
				onOpenInvitePicker = onOpenInvitePicker
			})
		})
	end

	local page

	if screenProps.onClose then
		page = React.createElement(BuildSheetPage, { pageContent = pageContent })
	else
		page = React.createElement(BuildFullscreenPage, { pageContent = pageContent })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local picker

	if state and target ~= nil then
		picker = React.createElement(PrivateInvitesPickerHost, {
			universeId = target.universeId,
			onClose = v2,
			onInvitesSent = v2
		})
	end

	return createElement(fragment, nil, { Page = page, Picker = picker })
end

function BuildOverflowMenuScreens.BuildTitleDescriptionScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("title-description", target)
	end

	local hideBottomBar = useOnScreenKeyboardVisible()
	local pageContent

	if target ~= nil then
		pageContent = React.createElement(BuildTitleDescriptionContent, {
			target = target,
			onBack = resolveSubPageDismiss(navigation, screenProps.onClose), -- inferred equivalent call
			testId = "BuildPage.titleDescription.Page"
		})
	end

	if screenProps.onClose then
		return React.createElement(BuildSheetPage, { pageContent = pageContent })
	end

	return React.createElement(BuildFullscreenPage, {
		hideBottomBar = hideBottomBar,
		pageContent = pageContent
	})
end

function BuildOverflowMenuScreens.BuildVersionTitleDescriptionScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = normalizeTarget(BuildNavigationParams.getTarget(navigation) or screenProps.target)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("version-title-description", target)
	end

	local hideBottomBar = useOnScreenKeyboardVisible()
	local pageContent

	if not (target == nil or target.placeId == nil) then
		local createElement = React.createElement
		local VersionTitleDescriptionPageContainer = require(BuildExperience.Components.VersionTitleDescriptionPage.VersionTitleDescriptionPageContainer)
		pageContent = createElement(VersionTitleDescriptionPageContainer, {
			placeId = target.placeId,
			onBack = resolveSubPageDismiss(navigation, screenProps.onClose), -- inferred equivalent call
			testId = "BuildPage.versionTitleDescription.Page"
		})
	end

	if screenProps.onClose then
		return React.createElement(BuildSheetPage, { pageContent = pageContent })
	end

	return React.createElement(BuildFullscreenPage, {
		hideBottomBar = hideBottomBar,
		pageContent = pageContent
	})
end

function BuildOverflowMenuScreens.BuildMediaSelectionScreen(p)
	local navigation = p.navigation
	local screenProps = p.screenProps or {}
	local target = BuildNavigationParams.getTarget(navigation)

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("media-selection", target)
	end

	local subPageDismiss = resolveSubPageDismiss(navigation, screenProps.onClose) -- inferred equivalent call
	local pageContent

	if not (target == nil or target.universeId == nil) then
		pageContent = React.createElement(MediaSelectionPage, {
			onClose = subPageDismiss,
			universeId = target.universeId
		})
	end

	if screenProps.onClose then
		return React.createElement(BuildSheetPage, { pageContent = pageContent })
	end

	return React.createElement(BuildFullscreenPage, { pageContent = pageContent })
end

return BuildOverflowMenuScreens
