local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/GameConfigurationContent/GameConfigurationContent")

local PublishConfigurationContentContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishConfigurationContent/PublishConfigurationContentContainer")
local OverflowMenuPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/OverflowMenuPageShell")
local PublishFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishFooter/PublishFooter")
local PublishLatestPreviewCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishLatestPreviewCard")
local PublishPreviewCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishPreviewCard")
local PublishStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/PublishStatus")

local view = Foundation.View

local v5 = {
	publish = "LuaApp_Build_Publish_Scroll",
	settings = "LuaApp_Build_Settings_Scroll"
}

local function getPublishPreview(p2)
	if p2 then
		return PublishLatestPreviewCard
	end

	return PublishPreviewCard
end

local function PublishPreview(p2)
	local v6 = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING })

	local v7 = if PublishStatus.usePublishStatus(p2.target).isPublishLatest then PublishLatestPreviewCard else PublishPreviewCard
	local target = p2.target

	return React.createElement(v7, {
		target = {
			universeId = target.universeId,
			placeId = target.placeId,
			experienceName = target.experienceName or v6.loading,
			creatorName = target.creatorName,
			gameIcon = target.gameIcon
		},
		isCreatorVerified = target.isCreatorVerified,
		layoutOrder = 1
	})
end

local function BuildOverflowMenuPageComponent(props)
	local v6 = useLocalization({
		loading = LocalizationStrings.BUILD_MENU_LOADING,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH,
		settings = LocalizationStrings.BUILD_MENU_SETTINGS
	})

	local testId = props.testId or `BuildOverflowMenuPage.{props.page}`
	local experienceName = props.target.experienceName or v6.loading
	local v7

	if props.page == "publish" then
		v7 = React.createElement(PublishPreview, { target = props.target })
	end

	local v8

	if props.page == "publish" then
		local createElement = React.createElement
		local v10 = {
			universeId = props.target.universeId,
			onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage,
			onOpenMediaSelectionPage = props.onOpenMediaSelectionPage,
			onOpenVersionTitleDescriptionPage = props.onOpenVersionTitleDescriptionPage,
			onOpenVersionHistory = props.onOpenVersionHistory,
			isNewGame = 0,
			layoutOrder = 2
		}
		local v11 = if FFlagBuildCheckGamePermissions then props.target.isNewGameTarget else nil
		v10.isNewGame = v11
		v8 = createElement(PublishConfigurationContentContainer, v10)
	else
		local createElement = React.createElement
		local v10 = {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			experienceName = experienceName,
			onOpenAudiencePage = props.onOpenAudiencePage,
			onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage,
			onOpenMediaSelectionPage = props.onOpenMediaSelectionPage,
			onOpenMonetizationPage = 0,
			onOpenPlaytestPicker = 0,
			onOpenPlaytestManagement = 0,
			isNewGame = 0
		}

		local v11 = if FFlagBuildExperienceMonetizationNativeUI then props.onOpenMonetizationPage else nil
		v10.onOpenMonetizationPage = v11

		v10.onOpenPlaytestPicker = props.onOpenPlaytestPicker
		v10.onOpenPlaytestManagement = props.onOpenPlaytestManagement
		local v12 = if FFlagBuildCheckGamePermissions then props.target.isNewGameTarget else nil
		v10.isNewGame = v12
		v8 = createElement(module6, v10)
	end

	if v7 then
		v8 = React.createElement(view, { tag = "col gap-large size-full-0 auto-y" }, {
			LeadingContent = v7,
			GameConfigurationContent = v8
		})
	end

	local createElement = React.createElement
	local v11 = if props.page == "publish" then v6.publish else v6.settings
	local v10 = {
		title = v11,
		testId = testId,
		onClose = props.onClose,
		content = v8,
		scrollPerformanceIntervalName = v5[props.page],
		footer = 0
	}
	local v12

	if props.page == "publish" then
		local createElement2 = React.createElement
		local v15 = {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = props.target.sessionId,
			isNewGameTarget = 0
		}
		local v16 = if FFlagBuildCheckGamePermissions then props.target.isNewGameTarget else nil
		v15.isNewGameTarget = v16
		v12 = createElement2(PublishFooter, {
			target = v15,
			testId = testId,
			showPreviewButton = props.showPreviewButton
		})
	end

	v10.footer = v12
	return createElement(OverflowMenuPageShell, v10)
end

return BuildOverflowMenuPageComponent
