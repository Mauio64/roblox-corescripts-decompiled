local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Foundation = require(BuildExperience.Parent.Foundation)
local React = require(BuildExperience.Parent.React)
local GameConfigurationContent = require(BuildExperience.Components.GameConfigurations.GameConfigurationContent.GameConfigurationContent)
local OverflowMenuPageShell = require(script.Parent.OverflowMenuPageShell)
local PublishFooter = require(BuildExperience.Components.GameConfigurations.PublishFooter.PublishFooter)
local PublishPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishPreviewCard)

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local View = Foundation.View
local t1 = {
	publish = "Publish",
	settings = "Settings"
}

local function BuildOverflowMenuPageComponent(t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy), PublishPreviewCard (copy), GameConfigurationContent (copy), View (copy), OverflowMenuPageShell (copy), t1 (copy), PublishFooter (copy)
	local v12 = t2.testId or `BuildOverflowMenuPage.{ t2.page }`
	local v13 = t2.target.experienceName or "Loading..."
	local v14 = if t2.page ~= "publish" then nil else React.createElement(PublishPreviewCard, {
		layoutOrder = 1,
		target = {
			universeId = t2.target.universeId,
			placeId = t2.target.placeId,
			experienceName = v13,
			creatorName = t2.target.creatorName,
			gameIcon = t2.target.gameIcon
		},
		isCreatorVerified = t2.target.isCreatorVerified,
		testId = `{ v12 }.PreviewCard`
	})
	local v15 = React.createElement(GameConfigurationContent, {
		universeId = t2.target.universeId,
		experienceName = v13,
		onOpenAudiencePage = t2.onOpenAudiencePage,
		onOpenTitleDescriptionPage = t2.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = t2.onOpenMediaSelectionPage,
		layoutOrder = if not v14 then nil else 2
	})
	local v16 = if not v14 then v15 else React.createElement(View, {
		tag = "col size-full-0 auto-y"
	}, {
		LeadingContent = v14,
		GameConfigurationContent = v15
	})

	return React.createElement(OverflowMenuPageShell, {
		title = t1[t2.page],
		testId = v12,
		onClose = t2.onClose,
		content = v16,
		footer = if t2.page ~= "publish" then nil else React.createElement(PublishFooter, {
			target = {
				universeId = t2.target.universeId,
				placeId = t2.target.placeId
			},
			testId = v12,
			showPreviewButton = t2.showPreviewButton
		})
	})
end

return BuildOverflowMenuPageComponent
