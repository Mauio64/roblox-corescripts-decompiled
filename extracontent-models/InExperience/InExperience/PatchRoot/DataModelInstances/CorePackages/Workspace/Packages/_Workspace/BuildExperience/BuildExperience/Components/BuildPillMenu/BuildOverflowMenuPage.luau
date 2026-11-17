local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceConfigurationRowTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceConfigurationRowTelemetry)

local GameConfigurationContent = require(BuildExperience.Components.GameConfigurations.GameConfigurationContent.GameConfigurationContent)

local PublishConfigurationContentContainer = require(BuildExperience.Components.PublishConfigurationContent.PublishConfigurationContentContainer)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local PublishFooter = require(BuildExperience.Components.GameConfigurations.PublishFooter.PublishFooter)
local PublishLatestPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishLatestPreviewCard)
local PublishPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishPreviewCard)
local PublishStatus = require(BuildExperience.Chat.PublishStatus)

local View = Foundation.View

local v = { publish = "LuaApp_Build_Publish_Scroll", settings = "LuaApp_Build_Settings_Scroll" }

local function getPublishPreview(isPublishLatest: boolean) -- 1 equivalent call inferred from this helper
	if isPublishLatest then
		return PublishLatestPreviewCard
	end

	return PublishPreviewCard
end

local function PublishPreview(p)
	local v2 = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING })

	local publishPreview = getPublishPreview(PublishStatus.usePublishStatus(p.target).isPublishLatest) -- inferred equivalent call
	local target = p.target

	return React.createElement(publishPreview, {
		target = {
			universeId = target.universeId,
			placeId = target.placeId,
			experienceName = target.experienceName or v2.loading,
			creatorName = target.creatorName,
			gameIcon = target.gameIcon
		},
		isCreatorVerified = target.isCreatorVerified,
		layoutOrder = 1
	})
end

local function BuildOverflowMenuPageComponent(props)
	local v2 = useLocalization({
		loading = LocalizationStrings.BUILD_MENU_LOADING,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH,
		settings = LocalizationStrings.BUILD_MENU_SETTINGS
	})

	local testId = props.testId or `BuildOverflowMenuPage.{props.page}`
	local experienceName = props.target.experienceName or v2.loading
	local leadingContent

	if props.page == "publish" then
		leadingContent = React.createElement(PublishPreview, { target = props.target })
	end

	local v3

	if props.page == "publish" then
		local createElement = React.createElement
		local v4 = {
			universeId = props.target.universeId,
			placeId = 0,
			sessionId = 0,
			onOpenTitleDescriptionPage = 0,
			onOpenMediaSelectionPage = 0,
			onOpenVersionTitleDescriptionPage = 0,
			onOpenVersionHistory = 0,
			isNewGame = 0,
			layoutOrder = 2
		}
		local placeId

		if FFlagBuildExperienceConfigurationRowTelemetry then
			placeId = props.target.placeId
		end

		v4.placeId = placeId
		local sessionId

		if FFlagBuildExperienceConfigurationRowTelemetry then
			sessionId = props.target.sessionId
		end

		v4.sessionId = sessionId
		v4.onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage
		v4.onOpenMediaSelectionPage = props.onOpenMediaSelectionPage
		v4.onOpenVersionTitleDescriptionPage = props.onOpenVersionTitleDescriptionPage
		v4.onOpenVersionHistory = props.onOpenVersionHistory
		local isNewGame

		if FFlagBuildCheckGamePermissions then
			isNewGame = props.target.isNewGameTarget
		end

		v4.isNewGame = isNewGame
		v3 = createElement(PublishConfigurationContentContainer, v4)
	else
		local createElement = React.createElement
		local v4 = {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = 0,
			experienceName = 0,
			onOpenAudiencePage = 0,
			onOpenTitleDescriptionPage = 0,
			onOpenMediaSelectionPage = 0,
			onOpenMonetizationPage = 0,
			onOpenPlaytestPicker = 0,
			onOpenPlaytestManagement = 0,
			isNewGame = 0
		}
		local sessionId

		if FFlagBuildExperienceConfigurationRowTelemetry then
			sessionId = props.target.sessionId
		end

		v4.sessionId = sessionId
		v4.experienceName = experienceName
		v4.onOpenAudiencePage = props.onOpenAudiencePage
		v4.onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage
		v4.onOpenMediaSelectionPage = props.onOpenMediaSelectionPage
		local onOpenMonetizationPage

		if FFlagBuildExperienceMonetizationNativeUI then
			onOpenMonetizationPage = props.onOpenMonetizationPage
		end

		v4.onOpenMonetizationPage = onOpenMonetizationPage

		v4.onOpenPlaytestPicker = props.onOpenPlaytestPicker
		v4.onOpenPlaytestManagement = props.onOpenPlaytestManagement
		local isNewGame

		if FFlagBuildCheckGamePermissions then
			isNewGame = props.target.isNewGameTarget
		end

		v4.isNewGame = isNewGame
		v3 = createElement(GameConfigurationContent, v4)
	end

	if leadingContent then
		v3 = React.createElement(View, { tag = "col gap-large size-full-0 auto-y" }, {
			LeadingContent = leadingContent,
			GameConfigurationContent = v3
		})
	end

	local createElement = React.createElement
	local title

	if props.page == "publish" then
		title = v2.publish
	else
		title = v2.settings
	end

	local v4 = {
		title = title,
		testId = testId,
		onClose = props.onClose,
		content = v3,
		scrollPerformanceIntervalName = v[props.page],
		footer = 0
	}
	local footer

	if props.page == "publish" then
		local createElement2 = React.createElement
		local target = {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = props.target.sessionId,
			isNewGameTarget = 0
		}
		local isNewGameTarget

		if FFlagBuildCheckGamePermissions then
			isNewGameTarget = props.target.isNewGameTarget
		end

		target.isNewGameTarget = isNewGameTarget
		footer = createElement2(PublishFooter, {
			target = target,
			testId = testId,
			showPreviewButton = props.showPreviewButton
		})
	end

	v4.footer = footer
	return createElement(OverflowMenuPageShell, v4)
end

return BuildOverflowMenuPageComponent
