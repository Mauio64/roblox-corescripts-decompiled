local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Foundation = require(BuildExperience.Parent.Foundation)
local React = require(BuildExperience.Parent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local GameConfigurationContent = require(BuildExperience.Components.GameConfigurations.GameConfigurationContent.GameConfigurationContent)
local PublishConfigurationContentContainer = require(BuildExperience.Components.PublishConfigurationContent.PublishConfigurationContentContainer)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local PublishFooter = require(BuildExperience.Components.GameConfigurations.PublishFooter.PublishFooter)
local PublishLatestPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishLatestPreviewCard)
local PublishPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishPreviewCard)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local View = Foundation.View
local t1 = {
	publish = LocalizationStrings.BUILD_MENU_PUBLISH,
	settings = LocalizationStrings.BUILD_MENU_SETTINGS
}
local t2 = {
	publish = "LuaApp_Build_Publish_Scroll",
	settings = "LuaApp_Build_Settings_Scroll"
}

local function getPublishPreview(b1: boolean) -- line: 61
	-- upvalues: PublishLatestPreviewCard (copy), PublishPreviewCard (copy)
	if b1 then
		return PublishLatestPreviewCard
	end

	return PublishPreviewCard
end
local function PublishPreview(t3: {[any]: any}) -- line: 65
	-- upvalues: PublishStatus (copy), PublishLatestPreviewCard (copy), PublishPreviewCard (copy), React (copy), LocalizationStrings (copy)
	local v22 = if not PublishStatus.usePublishStatus(t3.target).isPublishLatest then PublishPreviewCard else PublishLatestPreviewCard
	local target = t3.target

	return React.createElement(v22, {
		layoutOrder = 1,
		target = {
			universeId = target.universeId,
			placeId = target.placeId,
			experienceName = target.experienceName or LocalizationStrings.BUILD_MENU_LOADING,
			creatorName = target.creatorName,
			gameIcon = target.gameIcon
		},
		isCreatorVerified = target.isCreatorVerified
	})
end
local function BuildOverflowMenuPageComponent(t4: {[any]: any}) -- line: 83
	-- upvalues: LocalizationStrings (copy), React (copy), PublishPreview (copy), PublishConfigurationContentContainer (copy), GameConfigurationContent (copy), View (copy), FFlagEnableProvisionalRating (copy), OverflowMenuPageShell (copy), t1 (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), t2 (copy), PublishFooter (copy)
	local v25 = t4.testId or `BuildOverflowMenuPage.{ t4.page }`
	local v26 = t4.target.experienceName or LocalizationStrings.BUILD_MENU_LOADING
	local v27 = if t4.page ~= "publish" then nil else React.createElement(PublishPreview, {
		target = t4.target
	})
	local v28 = if t4.page ~= "publish" then React.createElement(GameConfigurationContent, {
		universeId = t4.target.universeId,
		placeId = t4.target.placeId,
		experienceName = v26,
		onOpenAudiencePage = t4.onOpenAudiencePage,
		onOpenTitleDescriptionPage = t4.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = t4.onOpenMediaSelectionPage,
		onOpenPlaytestPicker = t4.onOpenPlaytestPicker,
		onOpenPlaytestManagement = t4.onOpenPlaytestManagement
	}) else React.createElement(PublishConfigurationContentContainer, {
		layoutOrder = 2,
		universeId = t4.target.universeId,
		onOpenTitleDescriptionPage = t4.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = t4.onOpenMediaSelectionPage,
		onOpenVersionTitleDescriptionPage = t4.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = t4.onOpenVersionHistory
	})
	local v29 = if not v27 then v28 else React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y"
	}, {
		LeadingContent = v27,
		GameConfigurationContent = v28
	})
	local v30 = t4.showPreviewButton ~= false or FFlagEnableProvisionalRating

	return React.createElement(OverflowMenuPageShell, {
		title = t1[t4.page],
		testId = v25,
		onClose = t4.onClose,
		content = v29,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else t2[t4.page],
		footer = if t4.page ~= "publish" or not v30 then nil else React.createElement(PublishFooter, {
			target = {
				universeId = t4.target.universeId,
				placeId = t4.target.placeId,
				sessionId = t4.target.sessionId
			},
			testId = v25,
			showPreviewButton = t4.showPreviewButton
		})
	})
end

return BuildOverflowMenuPageComponent
