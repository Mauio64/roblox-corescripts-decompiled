local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local BuildMaturityBanner = require(BuildExperience.Components.GameConfigurations.BuildMaturityBanner.BuildMaturityBanner)
local GameConfigurationList = require(BuildExperience.Components.GameConfigurations.GameConfigurationList.GameConfigurationList)

local View = Foundation.View

local IconName = Foundation.Enums.IconName

local function PublishConfigurationContentView(props)
	local testId = props.testId or "game-configuration-content"
	local v = useLocalization({
		contentBody = LocalizationStrings.PUBLISH_CONTENT_BODY,
		contentMaturity = LocalizationStrings.PUBLISH_CONTENT_MATURITY,
		contentTitle = LocalizationStrings.PUBLISH_CONTENT_TITLE,
		gameDetails = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
		gameDetailsBody = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
		iconAndThumbnails = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
		titleAndDescription = LocalizationStrings.GAME_CONFIGURATION_TITLE_AND_DESCRIPTION,
		versionInformationBody = LocalizationStrings.PUBLISH_VERSION_INFORMATION_BODY,
		versionInformationTitle = LocalizationStrings.PUBLISH_VERSION_INFORMATION_TITLE,
		versionHistory = LocalizationStrings.VERSION_HISTORY_TITLE,
		versionTitleDescription = LocalizationStrings.PUBLISH_VERSION_TITLE_DESCRIPTION
	})

	local contentBody = v.contentBody
	local contentMaturity = v.contentMaturity
	local contentTitle = v.contentTitle
	local gameDetails = v.gameDetails
	local gameDetailsBody = v.gameDetailsBody
	local iconAndThumbnails = v.iconAndThumbnails
	local titleAndDescription = v.titleAndDescription
	local versionInformationBody = v.versionInformationBody
	local versionInformationTitle = v.versionInformationTitle
	local versionHistory = v.versionHistory
	local versionTitleDescription = v.versionTitleDescription
	local isEditDisabled = FFlagBuildCheckGamePermissions and props.isEditDisabled
	local isIconAndThumbnailsDisabled = FFlagBuildCheckGamePermissions and props.isIconAndThumbnailsDisabled
	local rows = {
		{
			id = "icon-thumbnails",
			title = iconAndThumbnails,
			onActivated = props.onOpenIconAndThumbnails,
			isDisabled = isEditDisabled or isIconAndThumbnailsDisabled
		},
		{
			id = "title-description",
			title = titleAndDescription,
			onActivated = props.onOpenTitleDescriptionPage,
			isDisabled = isEditDisabled
		}
	}

	local rows2 = {
		{
			id = "content-rating",
			title = contentMaturity,
			description = props.contentMaturityText,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = props.onOpenContentMaturity,
			isDisabled = isEditDisabled
		}
	}

	local rows3 = {}
	table.insert(rows3, {
		id = "version-title-description",
		title = versionTitleDescription,
		onActivated = props.onOpenVersionTitleDescriptionPage
	})

	table.insert(rows3, {
		id = "version-history",
		title = versionHistory,
		onActivated = props.onOpenVersionHistory,
		isDisabled = isEditDisabled
	})

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = testId
	}

	local v3 = {
		VersionInformation = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = versionInformationTitle,
			body = versionInformationBody,
			rows = rows3,
			testId = `{testId}-version-information`
		}),
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 2,
			title = gameDetails,
			body = gameDetailsBody,
			rows = rows,
			testId = `{testId}-game-details`
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 3,
		tag = "col gap-medium size-full-0 auto-y",
		testId = `{testId}-content-section`
	}
	local v5 = {
		Configuration = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = contentTitle,
			body = contentBody,
			rows = rows2,
			testId = `{testId}-content`
		}),
		BuildMaturityBanner = 0
	}
	local buildMaturityBanner

	if props.buildMaturityBannerText ~= nil then
		buildMaturityBanner = React.createElement(BuildMaturityBanner, {
			text = props.buildMaturityBannerText
		})
	end

	v5.BuildMaturityBanner = buildMaturityBanner
	v3.Content = createElement2(View, v4, v5)
	return createElement(View, v2, v3)
end

return PublishConfigurationContentView
