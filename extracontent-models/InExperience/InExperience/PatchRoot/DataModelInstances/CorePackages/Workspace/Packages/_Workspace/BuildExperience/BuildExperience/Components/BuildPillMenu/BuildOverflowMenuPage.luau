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

local function getPublishPreview(b1: boolean) -- line: 56
	-- upvalues: PublishLatestPreviewCard (copy), PublishPreviewCard (copy)
	if b1 then
		return PublishLatestPreviewCard
	end

	return PublishPreviewCard
end
local function PublishPreview(t3: {[any]: any}) -- line: 60
	-- upvalues: PublishStatus (copy), PublishLatestPreviewCard (copy), PublishPreviewCard (copy), React (copy), LocalizationStrings (copy)
	local v21 = if not PublishStatus.usePublishStatus(t3.target).isPublishLatest then PublishPreviewCard else PublishLatestPreviewCard
	local target = t3.target

	return React.createElement(v21, {
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
local function BuildOverflowMenuPageComponent(t4: {[any]: any}) -- line: 78
	-- upvalues: LocalizationStrings (copy), React (copy), PublishPreview (copy), PublishConfigurationContentContainer (copy), GameConfigurationContent (copy), View (copy), OverflowMenuPageShell (copy), t1 (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), t2 (copy), PublishFooter (copy)
	local v24 = t4.testId or `BuildOverflowMenuPage.{ t4.page }`
	local v25 = t4.target.experienceName or LocalizationStrings.BUILD_MENU_LOADING
	local v26 = if t4.page ~= "publish" then nil else React.createElement(PublishPreview, {
		target = t4.target
	})
	local v27 = if t4.page ~= "publish" then React.createElement(GameConfigurationContent, {
		universeId = t4.target.universeId,
		experienceName = v25,
		onOpenAudiencePage = t4.onOpenAudiencePage,
		onOpenTitleDescriptionPage = t4.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = t4.onOpenMediaSelectionPage
	}) else React.createElement(PublishConfigurationContentContainer, {
		layoutOrder = 2,
		universeId = t4.target.universeId,
		onOpenTitleDescriptionPage = t4.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = t4.onOpenMediaSelectionPage
	})
	local v28 = if not v26 then v27 else React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y"
	}, {
		LeadingContent = v26,
		GameConfigurationContent = v27
	})

	return React.createElement(OverflowMenuPageShell, {
		title = t1[t4.page],
		testId = v24,
		onClose = t4.onClose,
		content = v28,
		scrollPerformanceIntervalName = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else t2[t4.page],
		footer = if t4.page ~= "publish" then nil else React.createElement(PublishFooter, {
			target = {
				universeId = t4.target.universeId,
				placeId = t4.target.placeId,
				sessionId = t4.target.sessionId
			},
			testId = v24,
			showPreviewButton = t4.showPreviewButton
		})
	})
end

return BuildOverflowMenuPageComponent
