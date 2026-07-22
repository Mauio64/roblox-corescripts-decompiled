local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local BuildMaturityBanner = require(BuildExperience.Components.GameConfigurations.BuildMaturityBanner.BuildMaturityBanner)
local GameConfigurationList = require(BuildExperience.Components.GameConfigurations.GameConfigurationList.GameConfigurationList)
local View = Foundation.View
local IconName = Foundation.Enums.IconName

local function PublishConfigurationContentView(t1: {[any]: any}) -- line: 26
	-- upvalues: LocalizationStrings (copy), IconName (copy), React (copy), View (copy), GameConfigurationList (copy), BuildMaturityBanner (copy)
	local v12 = t1.testId or "game-configuration-content"
	local t2 = {
		{
			id = "icon-thumbnails",
			title = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
			onActivated = t1.onOpenIconAndThumbnails
		},
		{
			id = "title-description",
			title = LocalizationStrings.GAME_CONFIGURATION_TITLE_AND_DESCRIPTION,
			onActivated = t1.onOpenTitleDescriptionPage
		}
	}
	local t3 = {{
		id = "content-rating",
		title = LocalizationStrings.PUBLISH_CONTENT_MATURITY,
		description = t1.contentMaturityText,
		trailingIcon = IconName.ArrowUpRightFromSquare,
		onActivated = t1.onOpenContentMaturity
	}}

	return React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		testId = v12
	}, {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
			body = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
			rows = t2,
			testId = `{ v12 }-game-details`
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			Configuration = React.createElement(GameConfigurationList, {
				layoutOrder = 1,
				title = LocalizationStrings.PUBLISH_CONTENT_TITLE,
				body = LocalizationStrings.PUBLISH_CONTENT_BODY,
				rows = t3,
				testId = `{ v12 }-content`
			}),
			BuildMaturityBanner = React.createElement(BuildMaturityBanner)
		})
	})
end

return PublishConfigurationContentView
