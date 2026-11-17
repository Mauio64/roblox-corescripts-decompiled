local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(script.Parent.PublishConfigurationContentView)
local ExperienceGuidelines = require(parent.DataHydration.ExperienceGuidelines)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceConfigurationRowTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceConfigurationRowTelemetry)
local sendConfigurationRowClick = require(BuildExperience.Telemetry.sendConfigurationRowClick)

local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function usePublishConfigurationContentViewModel(data)
	local v = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
		loading = LocalizationStrings.GAME_CONFIGURATION_LOADING,
		questionnaireRequiredBanner = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
	})

	local creatorHub = v.creatorHub
	local loading = v.loading
	local questionnaireRequiredBanner = v.questionnaireRequiredBanner
	local v2 = useOpenWebView()
	local v3

	if FFlagBuildCheckGamePermissions then
		v3 = useGamePermissions({ universeId = data.universeId, isNewGame = data.isNewGame })
	end

	local experienceGuidelinesStore = ExperienceGuidelines.getExperienceGuidelinesStore()
	local v4 = React.useMemo(function()
		return experienceGuidelinesStore.getAndFetchDetailedGuidelines(data.universeId)
	end, { experienceGuidelinesStore, data.universeId })
	local v5 = SignalsReact.useSignalState(v4.data)

	local buildMaturityBannerText = nil

	local universeActivationStore = UniverseActivation.getUniverseActivationStore()
	local v6 = React.useMemo(function()
		return universeActivationStore.getAndFetchEligibility(data.universeId)
	end, { universeActivationStore, data.universeId })
	local v7 = SignalsReact.useSignalState(v6.data)

	local contentUnrated = ContentMaturityUtils.isContentUnrated(data.universeId)
	local sealBroken = ContentMaturityUtils.isSealBroken(data.universeId)
	local provisionalRating

	if v7 then
		provisionalRating = v7.provisionalRating
	end

	if sealBroken and contentUnrated then
		buildMaturityBannerText = questionnaireRequiredBanner
	end

	local contentMaturityText = GameConfigurationLabels.getContentMaturityText(
			v5,
			provisionalRating,
			contentUnrated and not sealBroken
		)
		or loading

	local onOpenIconAndThumbnails = React.useCallback(function()
		v2(GameConfigurationActions.getCreatorHubConfigureUrl(data.universeId), creatorHub)
	end, { creatorHub, v2, data.universeId })

	local onOpenContentMaturity = React.useCallback(function()
		v2(GameConfigurationActions.getExperienceQuestionnaireUrl(data.universeId), creatorHub, function()
			refreshPublishEligibility(data.universeId)
		end)
	end, { creatorHub, v2, data.universeId })
	local onRowActivated

	if FFlagBuildExperienceConfigurationRowTelemetry then
		onRowActivated = React.useCallback(function(p: string)
			sendConfigurationRowClick(
				"publish",
				{ universeId = data.universeId, placeId = data.placeId, sessionId = data.sessionId },
				p
			)
		end, { data.universeId, data.placeId, data.sessionId })
	end

	if FFlagMyStatsMediaSelector then
		onOpenIconAndThumbnails = data.onOpenMediaSelectionPage
	end

	local v8 = {
		buildMaturityBannerText = buildMaturityBannerText,
		contentMaturityText = contentMaturityText,
		onOpenIconAndThumbnails = onOpenIconAndThumbnails,
		onOpenTitleDescriptionPage = data.onOpenTitleDescriptionPage,
		onOpenContentMaturity = onOpenContentMaturity,
		onOpenVersionTitleDescriptionPage = data.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = data.onOpenVersionHistory,
		onRowActivated = 0,
		isEditDisabled = 0,
		isIconAndThumbnailsDisabled = 0,
		layoutOrder = 0,
		testId = 0
	}

	if not FFlagBuildExperienceConfigurationRowTelemetry then
		onRowActivated = nil
	end

	v8.onRowActivated = onRowActivated
	v8.isEditDisabled = FFlagBuildCheckGamePermissions and not v3.canEdit
	v8.isIconAndThumbnailsDisabled = FFlagBuildCheckGamePermissions
		and not (FFlagMyStatsMediaSelector or v3.canViewOnCreatorHub)
	v8.layoutOrder = data.layoutOrder
	v8.testId = data.testId
	return v8
end

return usePublishConfigurationContentViewModel
