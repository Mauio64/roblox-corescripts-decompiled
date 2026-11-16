local CaptureService = game:GetService("CaptureService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(parent.DataHydration)
local ExperienceGuidelines = require(parent.DataHydration.ExperienceGuidelines)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local ArchiveGameDialog = require(BuildExperience.Components.GameConfigurations.ArchiveGameDialog)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
local BuildMaturityBanner = require(BuildExperience.Components.GameConfigurations.BuildMaturityBanner.BuildMaturityBanner)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local GameConfigurationList = require(script.Parent.Parent.GameConfigurationList.GameConfigurationList)
local PrivatePlaytesters = require(parent.DataHydration.PrivatePlaytesters)
local getPrivatePlaytestersStore = PrivatePlaytesters.getPrivatePlaytestersStore
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName

local engineFeature = SharedFlags.FFlagMyStatsMediaSelector
	and CaptureService.PromptCaptureGalleryPermissionAsync
	and game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

local PrivacyType = UniverseConfiguration.PrivacyType

local signal = Signals.createSignal(nil)

local function GameConfigurationContent(props)
	local testId = props.testId or "game-configuration-content"
	local v = useLocalization({
		access = LocalizationStrings.GAME_CONFIGURATION_ACCESS,
		accessAndSharing = LocalizationStrings.GAME_CONFIGURATION_ACCESS_AND_SHARING,
		accessBody = LocalizationStrings.GAME_CONFIGURATION_ACCESS_BODY,
		archiveGame = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME,
		audience = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE,
		contentRating = LocalizationStrings.GAME_CONFIGURATION_CONTENT_RATING,
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
		creatorHubDescription = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB_DESCRIPTION,
		gameConfiguration = LocalizationStrings.GAME_CONFIGURATION_GAME_CONFIGURATION,
		gameConfigurationBody = LocalizationStrings.GAME_CONFIGURATION_GAME_CONFIGURATION_BODY,
		salesOptions = LocalizationStrings.GAME_CONFIGURATION_SALES_OPTIONS,
		friendsOnlyAudience = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY,
		gameDetails = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
		gameDetailsBody = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
		iconAndThumbnails = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
		loading = LocalizationStrings.GAME_CONFIGURATION_LOADING,
		privateAudience = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE,
		privateInvitesRowDescription = LocalizationStrings.PRIVATE_INVITES_ROW_DESCRIPTION,
		privateInvitesRowLoadError = LocalizationStrings.PRIVATE_INVITES_ROW_LOAD_ERROR,
		privateInvitesRowTitle = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE,
		privateInvitesRowTitleEmpty = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE_EMPTY,
		privateInvitesShareLink = LocalizationStrings.PRIVATE_INVITES_SHARE_LINK,
		publicAudience = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC,
		questionnaireRequiredBanner = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER,
		titleAndDescription = LocalizationStrings.GAME_CONFIGURATION_TITLE_AND_DESCRIPTION,
		unknownAudience = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_UNKNOWN
	})

	local v2 = React.useContext(Localization.LocalizationRoactContext)
	local title = v.access
	local accessAndSharing = v.accessAndSharing
	local accessBody = v.accessBody
	local archiveGame = v.archiveGame
	local audience = v.audience
	local contentRating = v.contentRating
	local creatorHub = v.creatorHub
	local creatorHubDescription = v.creatorHubDescription
	local description = v.friendsOnlyAudience
	local gameDetails = v.gameDetails
	local gameDetailsBody = v.gameDetailsBody
	local iconAndThumbnails = v.iconAndThumbnails
	local description2 = v.loading
	local privateAudience = v.privateAudience
	local privateInvitesRowDescription = v.privateInvitesRowDescription
	local privateInvitesRowLoadError = v.privateInvitesRowLoadError
	local privateInvitesRowTitle = v.privateInvitesRowTitle
	local privateInvitesRowTitleEmpty = v.privateInvitesRowTitleEmpty
	local privateInvitesShareLink = v.privateInvitesShareLink
	local publicAudience = v.publicAudience
	local questionnaireRequiredBanner = v.questionnaireRequiredBanner
	local titleAndDescription = v.titleAndDescription
	local unknownAudience = v.unknownAudience
	local v3

	if FFlagBuildCheckGamePermissions then
		v3 = useGamePermissions({ universeId = props.universeId, isNewGame = props.isNewGame })
	end

	local v4 = not FFlagBuildCheckGamePermissions or v3.canPublish
	local v5 = not FFlagBuildCheckGamePermissions or v3.canMonetize
	local v6 = not FFlagBuildCheckGamePermissions or v3.canViewOnCreatorHub
	local v7 = useOpenWebView()
	local v8 = useArchiveGameFlow()
	local v9

	if FFlagBuildExperiencePrivateInvites then
		v9 = useExperienceShareFlow(props.universeId, props.placeId)
	end

	local onShare

	if v9 == nil then
		onShare = nil
	else
		onShare = v9.onShare
	end

	local v10 = React.useMemo(function()
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(props.universeId)
	end, { props.universeId })

	local v11 = React.useMemo(function()
		if FFlagBuildExperiencePrivateInvites then
			return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(props.universeId)
		end

		return nil
	end, { props.universeId })
	local v12 = React.useMemo(function()
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(props.universeId)
	end, { props.universeId })
	local v13 = SignalsReact.useSignalState(v10.data)

	local useSignalState = SignalsReact.useSignalState
	local v14 = if v11 == nil then signal else v11.data
	local v15 = useSignalState(v14)
	local v16 = SignalsReact.useSignalState(v12.data)
	local v17

	if v15 == nil then
		v17 = false
	else
		v17 = v15.creatorType == "Group"
	end

	local v18

	if v13 then
		v18 = GameConfigurationLabels.getAudience(v13)
	end

	if v13 == nil then
		description = description2
	elseif v18 == PrivacyType.Private then
		description = privateAudience
	elseif v18 == PrivacyType.Public then
		description = publicAudience
	elseif v18 ~= PrivacyType.FriendsOnly then
		description = GameConfigurationLabels.getAudienceText(v13) or unknownAudience
	end

	local text = nil
	local v19 = React.useMemo(function()
		return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(props.universeId)
	end, { props.universeId })
	local v20 = SignalsReact.useSignalState(v19.data)
	local v21 = React.useMemo(function()
		return ContentMaturityUtils.isSealBroken(props.universeId)
	end, { v20, props.universeId })
	local v22 = React.useMemo(function()
		return ContentMaturityUtils.isContentUnrated(props.universeId)
	end, { v20, props.universeId })
	local provisionalRating

	if v20 then
		provisionalRating = v20.provisionalRating
	end

	if v21 and v22 then
		text = questionnaireRequiredBanner
	end

	local description3 = GameConfigurationLabels.getContentMaturityText(v16, provisionalRating, v22 and not v21)
		or description2

	local onActivated = React.useCallback(function()
		v7(GameConfigurationActions.getCreatorHubConfigureUrl(props.universeId), creatorHub)
	end, { creatorHub, v7, props.universeId })

	local onActivated2 = React.useCallback(function()
		v7(GameConfigurationActions.getExperienceQuestionnaireUrl(props.universeId), creatorHub, function()
			refreshPublishEligibility(props.universeId)
		end)
	end, { creatorHub, v7, props.universeId })

	local rows = React.useMemo(function()
		local v23 = {
			id = "icon-thumbnails",
			title = iconAndThumbnails,
			trailingIcon = 0,
			onActivated = 0,
			isDisabled = 0
		}
		local trailingIcon

		if not engineFeature then
			trailingIcon = IconName.ArrowUpRightFromSquare
		end

		v23.trailingIcon = trailingIcon
		local onActivated3

		if engineFeature then
			onActivated3 = props.onOpenMediaSelectionPage
		else
			onActivated3 = onActivated
		end

		v23.onActivated = onActivated3

		v23.isDisabled = not (engineFeature or v6)
		return {
			v23,
			{
				id = "title-description",
				title = titleAndDescription,
				description = props.experienceName,
				trailingIcon = nil,
				onActivated = props.onOpenTitleDescriptionPage
			}
		}
	end, {
		v6,
		onActivated,
		props.experienceName,
		props.onOpenMediaSelectionPage,
		props.onOpenTitleDescriptionPage,
		iconAndThumbnails,
		titleAndDescription
	})

	local onOpenPlaytestPicker = props.onOpenPlaytestPicker
	local onOpenPlaytestManagement = props.onOpenPlaytestManagement
	local v23 = FFlagBuildExperiencePrivateInvites

	if v23 then
		if onOpenPlaytestPicker == nil or onOpenPlaytestManagement == nil then
			v23 = false
		else
			v23 = not v17
		end
	end

	local v24 = React.useMemo(function()
		if v23 then
			return getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(props.universeId)
		end

		return nil
	end, { v23, props.universeId })

	local v25 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v24 == nil then
				return 0
			end

			return #v24.players(p)
		end)
	end, { v24 })
	local v26 = SignalsReact.useSignalState(v25)

	local v27 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v24 == nil then
				return "NotReady"
			end

			return (v24.status(p))
		end)
	end, { v24 })
	local v28 = SignalsReact.useSignalState(v27)

	local MAX_INVITES = getPrivatePlaytestersStore(false).MAX_INVITES
	local v29

	if v23 then
		if v28 == "Ready" then
			local description4

			if v26 > 0 then
				description4 = v2:Format(LocalizationStrings.PRIVATE_INVITES_SENT, {
					INVITED_COUNT = v26,
					MAX_INVITES = MAX_INVITES
				})
			end

			v29 = v26 > 0 and {
				id = "playtest",
				title = privateInvitesRowTitle,
				description = description4,
				trailingIcon = nil,
				onActivated = onOpenPlaytestManagement
			} or {
				id = "playtest",
				title = privateInvitesRowTitleEmpty,
				description = privateInvitesRowDescription,
				trailingIcon = nil,
				onActivated = onOpenPlaytestPicker
			}
		else
			v29 = {
				id = "playtest",
				title = privateInvitesRowTitle,
				description = 0,
				trailingIcon = nil,
				onActivated = nil
			}

			if v28 == "Failed" then
				description2 = privateInvitesRowLoadError
			end

			v29.description = description2
		end
	else
		v29 = nil
	end

	local rows2 = React.useMemo(function()
		local v30 = {
			{
				id = "audience",
				title = audience,
				description = description,
				trailingIcon = nil,
				onActivated = props.onOpenAudiencePage,
				isDisabled = not v4
			}
		}

		if v29 ~= nil then
			table.insert(v30, v29)

			table.insert(v30, {
				id = "playtest-share-link",
				title = privateInvitesShareLink,
				trailingIcon = nil,
				onActivated = onShare
			})
		end

		table.insert(v30, {
			id = "content-rating",
			title = contentRating,
			description = description3,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = onActivated2
		})

		return v30
	end, {
		description,
		v4,
		description3,
		onActivated2,
		v29,
		onShare,
		props.onOpenAudiencePage,
		audience,
		contentRating,
		privateInvitesShareLink
	})

	local rows3 = React.useMemo(function()
		return {
			{
				id = "creator-hub",
				title = creatorHub,
				description = creatorHubDescription,
				trailingIcon = IconName.ArrowUpRightFromSquare,
				onActivated = onActivated,
				isDisabled = not v6
			}
		}
	end, { v6, creatorHub, creatorHubDescription, onActivated })

	local rows4 = {}

	if FFlagBuildExperienceMonetizationNativeUI then
		table.insert(rows4, {
			id = "sales-options",
			title = v.salesOptions,
			onActivated = props.onOpenMonetizationPage,
			isDisabled = not v5
		})
	end

	local v30 = FFlagBuildExperienceMonetizationNativeUI

	local onActivated3 = React.useCallback(function()
		v8.requestArchive(props.universeId)
	end, { v8.requestArchive, props.universeId })

	local createElement = React.createElement
	local v31 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		testId = testId
	}

	local children = {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = gameDetails,
			body = gameDetailsBody,
			rows = rows,
			testId = `{testId}-game-details`
		}),
		Access = 0,
		GameConfiguration = 0,
		CreatorHub = 0,
		ArchiveGame = 0,
		ArchiveDialog = 0,
		ShareOverlays = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	if v23 then
		title = accessAndSharing
	end

	local v32 = {
		Configuration = createElement3(GameConfigurationList, {
			layoutOrder = 1,
			title = title,
			body = accessBody,
			rows = rows2,
			testId = `{testId}-access`
		}),
		BuildMaturityBanner = 0
	}
	local buildMaturityBanner

	if text ~= nil then
		buildMaturityBanner = React.createElement(BuildMaturityBanner, { text = text })
	end

	v32.BuildMaturityBanner = buildMaturityBanner
	children.Access = createElement2(View, {
		LayoutOrder = 2,
		tag = "col gap-medium size-full-0 auto-y"
	}, v32)
	local gameConfiguration

	if v30 then
		gameConfiguration = React.createElement(GameConfigurationList, {
			layoutOrder = 3,
			title = v.gameConfiguration,
			body = v.gameConfigurationBody,
			rows = rows4,
			testId = `{testId}-game-configuration`
		})
	end

	children.GameConfiguration = gameConfiguration

	children.CreatorHub = React.createElement(GameConfigurationList, {
		layoutOrder = v30 and 4 or 3,
		title = creatorHub,
		rows = rows3,
		testId = `{testId}-creator-hub`
	})

	children.ArchiveGame = React.createElement(View, {
		LayoutOrder = v30 and 5 or 4,
		onActivated = onActivated3,
		stateLayer = {},
		tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
		testId = `{testId}-archive-game`
	}, {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = archiveGame,
			tag = "fill auto-y text-title-medium text-align-x-left content-default"
		})
	})

	children.ArchiveDialog = React.createElement(ArchiveGameDialog, {
		isOpen = v8.isOpen,
		onArchive = v8.confirm,
		onCancel = v8.cancel
	})
	local shareOverlays

	if FFlagBuildExperiencePrivateInvites and v9 ~= nil then
		shareOverlays = React.createElement(ExperienceShareOverlays, {
			activeDialog = v9.activeDialog,
			hasShareError = v9.hasShareError,
			onCancel = v9.onCancelDialog,
			onConfirmFriends = v9.onConfirmFriends,
			onConfirmPlaytesters = v9.onConfirmPlaytesters
		})
	end

	children.ShareOverlays = shareOverlays
	return createElement(View, v31, children)
end

return GameConfigurationContent
