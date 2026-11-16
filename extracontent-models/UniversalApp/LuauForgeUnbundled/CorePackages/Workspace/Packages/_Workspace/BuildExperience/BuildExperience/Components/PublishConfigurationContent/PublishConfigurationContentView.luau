local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/BuildMaturityBanner/BuildMaturityBanner")
local GameConfigurationList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/GameConfigurationList/GameConfigurationList")

local view = Foundation.View

local iconName = Foundation.Enums.IconName

local function PublishConfigurationContentView(props)
	local testId = props.testId or "game-configuration-content"
	local v5 = useLocalization({
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

	local contentBody = v5.contentBody
	local contentMaturity = v5.contentMaturity
	local contentTitle = v5.contentTitle
	local gameDetails = v5.gameDetails
	local gameDetailsBody = v5.gameDetailsBody
	local iconAndThumbnails = v5.iconAndThumbnails
	local titleAndDescription = v5.titleAndDescription
	local versionInformationBody = v5.versionInformationBody
	local versionInformationTitle = v5.versionInformationTitle
	local versionHistory = v5.versionHistory
	local versionTitleDescription = v5.versionTitleDescription
	local isEditDisabled = FFlagBuildCheckGamePermissions and props.isEditDisabled
	local isIconAndThumbnailsDisabled = FFlagBuildCheckGamePermissions and props.isIconAndThumbnailsDisabled
	local v6 = {
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

	local v7 = {
		{
			id = "content-rating",
			title = contentMaturity,
			description = props.contentMaturityText,
			trailingIcon = iconName.ArrowUpRightFromSquare,
			onActivated = props.onOpenContentMaturity,
			isDisabled = isEditDisabled
		}
	}

	local v8 = {}
	table.insert(v8, {
		id = "version-title-description",
		title = versionTitleDescription,
		onActivated = props.onOpenVersionTitleDescriptionPage
	})

	table.insert(v8, {
		id = "version-history",
		title = versionHistory,
		onActivated = props.onOpenVersionHistory,
		isDisabled = isEditDisabled
	})

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = testId
	}

	local v11 = {
		VersionInformation = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = versionInformationTitle,
			body = versionInformationBody,
			rows = v8,
			testId = `{testId}-version-information`
		}),
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 2,
			title = gameDetails,
			body = gameDetailsBody,
			rows = v6,
			testId = `{testId}-game-details`
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		LayoutOrder = 3,
		tag = "col gap-medium size-full-0 auto-y",
		testId = `{testId}-content-section`
	}
	local v14 = {
		Configuration = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = contentTitle,
			body = contentBody,
			rows = v7,
			testId = `{testId}-content`
		}),
		BuildMaturityBanner = 0
	}

	local v15 = if props.buildMaturityBannerText ~= nil then React.createElement(module5, {
		text = props.buildMaturityBannerText
	}) else nil
	v14.BuildMaturityBanner = v15
	v11.Content = createElement2(view, v13, v14)
	return createElement(view, v10, v11)
end

return PublishConfigurationContentView
