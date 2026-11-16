local CaptureService = game:GetService("CaptureService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local ExperienceGuidelines = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceGuidelines")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")
local ArchiveGameDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/ArchiveGameDialog")
local ExperienceShareOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/ExperienceShareOverlays")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/BuildMaturityBanner/BuildMaturityBanner")
local ContentMaturityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/ContentMaturityUtils")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
local refreshPublishEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshPublishEligibility")
local useArchiveGameFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useArchiveGameFlow")
local useExperienceShareFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useExperienceShareFlow")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local GameConfigurationList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/GameConfigurationList/GameConfigurationList")
local getPrivatePlaytestersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PrivatePlaytesters").getPrivatePlaytestersStore
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName

local engineFeature = SharedFlags.FFlagMyStatsMediaSelector
	and CaptureService.PromptCaptureGalleryPermissionAsync
	and game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

local privacyType = UniverseConfiguration.PrivacyType

local signal = Signals.createSignal(nil)

local function GameConfigurationContent(props)
	local testId = props.testId or "game-configuration-content"
	local v5 = useLocalization({
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

	local v6 = React.useContext(Localization.LocalizationRoactContext)
	local v7 = v5.access
	local accessAndSharing = v5.accessAndSharing
	local accessBody = v5.accessBody
	local archiveGame = v5.archiveGame
	local audience = v5.audience
	local contentRating = v5.contentRating
	local creatorHub = v5.creatorHub
	local creatorHubDescription = v5.creatorHubDescription
	local v8 = v5.friendsOnlyAudience
	local gameDetails = v5.gameDetails
	local gameDetailsBody = v5.gameDetailsBody
	local iconAndThumbnails = v5.iconAndThumbnails
	local v9 = v5.loading
	local privateAudience = v5.privateAudience
	local privateInvitesRowDescription = v5.privateInvitesRowDescription
	local privateInvitesRowLoadError = v5.privateInvitesRowLoadError
	local privateInvitesRowTitle = v5.privateInvitesRowTitle
	local privateInvitesRowTitleEmpty = v5.privateInvitesRowTitleEmpty
	local privateInvitesShareLink = v5.privateInvitesShareLink
	local publicAudience = v5.publicAudience
	local questionnaireRequiredBanner = v5.questionnaireRequiredBanner
	local titleAndDescription = v5.titleAndDescription
	local unknownAudience = v5.unknownAudience
	local v10

	if FFlagBuildCheckGamePermissions then
		v10 = useGamePermissions({ universeId = props.universeId, isNewGame = props.isNewGame })
	end

	local v11 = not FFlagBuildCheckGamePermissions or v10.canPublish
	local v12 = not FFlagBuildCheckGamePermissions or v10.canMonetize
	local v13 = not FFlagBuildCheckGamePermissions or v10.canViewOnCreatorHub
	local v14 = useOpenWebView()
	local v15 = useArchiveGameFlow()

	local v16 = if FFlagBuildExperiencePrivateInvites then useExperienceShareFlow(props.universeId, props.placeId) else nil

	local onShare = if v16 ~= nil then v16.onShare else nil
	local v17 = React.useMemo(function()
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(props.universeId)
	end, { props.universeId })

	local v18 = React.useMemo(function()
		if FFlagBuildExperiencePrivateInvites then
			return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(props.universeId)
		end

		return nil
	end, { props.universeId })
	local v19 = React.useMemo(function()
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(props.universeId)
	end, { props.universeId })
	local v20 = SignalsReact.useSignalState(v17.data)

	local useSignalState = SignalsReact.useSignalState
	local v21 = if v18 == nil then signal else v18.data
	local v22 = useSignalState(v21)
	local v23 = SignalsReact.useSignalState(v19.data)
	local v24 = not (v22 == nil) and v22.creatorType == "Group"
	local v25 = if v20 then GameConfigurationLabels.getAudience(v20) else nil

	if v20 == nil then
		v8 = v9
	elseif v25 == privacyType.Private then
		v8 = privateAudience
	elseif v25 == privacyType.Public then
		v8 = publicAudience
	elseif v25 ~= privacyType.FriendsOnly then
		v8 = GameConfigurationLabels.getAudienceText(v20) or unknownAudience
	end

	local v26 = nil
	local v27 = React.useMemo(function()
		return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(props.universeId)
	end, { props.universeId })
	local v28 = SignalsReact.useSignalState(v27.data)
	local v29 = React.useMemo(function()
		return ContentMaturityUtils.isSealBroken(props.universeId)
	end, { v28, props.universeId })
	local v30 = React.useMemo(function()
		return ContentMaturityUtils.isContentUnrated(props.universeId)
	end, { v28, props.universeId })

	local provisionalRating = if v28 then v28.provisionalRating else nil

	if v29 and v30 then
		v26 = questionnaireRequiredBanner
	end

	local v32 = GameConfigurationLabels.getContentMaturityText(v23, provisionalRating, v30 and not v29) or v9

	local v33 = React.useCallback(function()
		v14(GameConfigurationActions.getCreatorHubConfigureUrl(props.universeId), creatorHub)
	end, { creatorHub, v14, props.universeId })

	local v34 = React.useCallback(function()
		v14(GameConfigurationActions.getExperienceQuestionnaireUrl(props.universeId), creatorHub, function()
			refreshPublishEligibility(props.universeId)
		end)
	end, { creatorHub, v14, props.universeId })

	local v35 = React.useMemo(function()
		local v37 = {
			id = "icon-thumbnails",
			title = iconAndThumbnails,
			trailingIcon = 0,
			onActivated = 0,
			isDisabled = 0
		}

		local v38 = if not engineFeature then iconName.ArrowUpRightFromSquare else nil
		v37.trailingIcon = v38

		local v39 = if engineFeature then props.onOpenMediaSelectionPage else v33
		v37.onActivated = v39

		v37.isDisabled = not (engineFeature or v13)
		return {
			v37,
			{
				id = "title-description",
				title = titleAndDescription,
				description = props.experienceName,
				trailingIcon = nil,
				onActivated = props.onOpenTitleDescriptionPage
			}
		}
	end, {
		v13,
		v33,
		props.experienceName,
		props.onOpenMediaSelectionPage,
		props.onOpenTitleDescriptionPage,
		iconAndThumbnails,
		titleAndDescription
	})

	local onOpenPlaytestPicker = props.onOpenPlaytestPicker
	local onOpenPlaytestManagement = props.onOpenPlaytestManagement
	local v36 = FFlagBuildExperiencePrivateInvites

	if v36 then
		v36 = not (onOpenPlaytestPicker == nil or onOpenPlaytestManagement == nil) and not v24
	end

	local v37 = React.useMemo(function()
		if v36 then
			return getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(props.universeId)
		end

		return nil
	end, { v36, props.universeId })

	local v38 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v37 == nil then
				return 0
			end

			return #v37.players(p2)
		end)
	end, { v37 })
	local v39 = SignalsReact.useSignalState(v38)

	local v40 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v37 == nil then
				return "NotReady"
			end

			return (v37.status(p2))
		end)
	end, { v37 })
	local v41 = SignalsReact.useSignalState(v40)

	local MAX_INVITES = getPrivatePlaytestersStore(false).MAX_INVITES
	local v42

	if v36 then
		if v41 == "Ready" then
			local v43 = if v39 > 0 then v6:Format(LocalizationStrings.PRIVATE_INVITES_SENT, {
				INVITED_COUNT = v39,
				MAX_INVITES = MAX_INVITES
			}) else nil

			v42 = v39 > 0 and {
				id = "playtest",
				title = privateInvitesRowTitle,
				description = v43,
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
			v42 = {
				id = "playtest",
				title = privateInvitesRowTitle,
				description = 0,
				trailingIcon = nil,
				onActivated = nil
			}

			if v41 == "Failed" then
				v9 = privateInvitesRowLoadError
			end

			v42.description = v9
		end
	else
		v42 = nil
	end

	local v43 = React.useMemo(function()
		local v44 = {
			{
				id = "audience",
				title = audience,
				description = v8,
				trailingIcon = nil,
				onActivated = props.onOpenAudiencePage,
				isDisabled = not v11
			}
		}

		if v42 ~= nil then
			table.insert(v44, v42)

			table.insert(v44, {
				id = "playtest-share-link",
				title = privateInvitesShareLink,
				trailingIcon = nil,
				onActivated = onShare
			})
		end

		table.insert(v44, {
			id = "content-rating",
			title = contentRating,
			description = v32,
			trailingIcon = iconName.ArrowUpRightFromSquare,
			onActivated = v34
		})

		return v44
	end, {
		v8,
		v11,
		v32,
		v34,
		v42,
		onShare,
		props.onOpenAudiencePage,
		audience,
		contentRating,
		privateInvitesShareLink
	})

	local v44 = React.useMemo(function()
		return {
			{
				id = "creator-hub",
				title = creatorHub,
				description = creatorHubDescription,
				trailingIcon = iconName.ArrowUpRightFromSquare,
				onActivated = v33,
				isDisabled = not v13
			}
		}
	end, { v13, creatorHub, creatorHubDescription, v33 })

	local v45 = {}

	if FFlagBuildExperienceMonetizationNativeUI then
		table.insert(v45, {
			id = "sales-options",
			title = v5.salesOptions,
			onActivated = props.onOpenMonetizationPage,
			isDisabled = not v12
		})
	end

	local v46 = FFlagBuildExperienceMonetizationNativeUI

	local v47 = React.useCallback(function()
		v15.requestArchive(props.universeId)
	end, { v15.requestArchive, props.universeId })

	local createElement = React.createElement
	local v49 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		testId = testId
	}

	local children = {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = gameDetails,
			body = gameDetailsBody,
			rows = v35,
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

	if v36 then
		v7 = accessAndSharing
	end

	local v52 = {
		Configuration = createElement3(GameConfigurationList, {
			layoutOrder = 1,
			title = v7,
			body = accessBody,
			rows = v43,
			testId = `{testId}-access`
		}),
		BuildMaturityBanner = 0
	}

	local v55 = if v26 ~= nil then React.createElement(module14, { text = v26 }) else nil
	v52.BuildMaturityBanner = v55
	children.Access = createElement2(
		view,
		{ LayoutOrder = 2, tag = "col gap-medium size-full-0 auto-y" },
		v52
	)

	local v56 = if v46 then React.createElement(GameConfigurationList, {
		layoutOrder = 3,
		title = v5.gameConfiguration,
		body = v5.gameConfigurationBody,
		rows = v45,
		testId = `{testId}-game-configuration`
	}) else nil
	children.GameConfiguration = v56

	children.CreatorHub = React.createElement(GameConfigurationList, {
		layoutOrder = v46 and 4 or 3,
		title = creatorHub,
		rows = v44,
		testId = `{testId}-creator-hub`
	})

	children.ArchiveGame = React.createElement(view, {
		LayoutOrder = v46 and 5 or 4,
		onActivated = v47,
		stateLayer = {},
		tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
		testId = `{testId}-archive-game`
	}, {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = archiveGame,
			tag = "fill auto-y text-title-medium text-align-x-left content-default"
		})
	})

	children.ArchiveDialog = React.createElement(ArchiveGameDialog, {
		isOpen = v15.isOpen,
		onArchive = v15.confirm,
		onCancel = v15.cancel
	})

	local v57 = if FFlagBuildExperiencePrivateInvites and v16 ~= nil then React.createElement(ExperienceShareOverlays, {
		activeDialog = v16.activeDialog,
		hasShareError = v16.hasShareError,
		onCancel = v16.onCancelDialog,
		onConfirmFriends = v16.onConfirmFriends,
		onConfirmPlaytesters = v16.onConfirmPlaytesters
	}) else nil
	children.ShareOverlays = v57
	return createElement(view, v49, children)
end

return GameConfigurationContent
