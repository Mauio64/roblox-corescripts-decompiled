local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishConfigurationContent/PublishConfigurationContentView")
local ExperienceGuidelines = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceGuidelines")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local ContentMaturityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/ContentMaturityUtils")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")
local refreshPublishEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshPublishEligibility")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceConfigurationRowTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceConfigurationRowTelemetry")
local sendConfigurationRowClick = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendConfigurationRowClick")

local fFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function usePublishConfigurationContentViewModel(data)
	local v5 = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
		loading = LocalizationStrings.GAME_CONFIGURATION_LOADING,
		questionnaireRequiredBanner = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
	})

	local creatorHub = v5.creatorHub
	local loading = v5.loading
	local questionnaireRequiredBanner = v5.questionnaireRequiredBanner
	local v6 = useOpenWebView()
	local v7

	if FFlagBuildCheckGamePermissions then
		v7 = useGamePermissions({ universeId = data.universeId, isNewGame = data.isNewGame })
	end

	local experienceGuidelinesStore = ExperienceGuidelines.getExperienceGuidelinesStore()
	local v8 = React.useMemo(function()
		return experienceGuidelinesStore.getAndFetchDetailedGuidelines(data.universeId)
	end, { experienceGuidelinesStore, data.universeId })
	local v9 = SignalsReact.useSignalState(v8.data)

	local v10 = nil

	local universeActivationStore = UniverseActivation.getUniverseActivationStore()
	local v11 = React.useMemo(function()
		return universeActivationStore.getAndFetchEligibility(data.universeId)
	end, { universeActivationStore, data.universeId })
	local v12 = SignalsReact.useSignalState(v11.data)

	local contentUnrated = ContentMaturityUtils.isContentUnrated(data.universeId)
	local sealBroken = ContentMaturityUtils.isSealBroken(data.universeId)

	local provisionalRating = if v12 then v12.provisionalRating else nil

	if sealBroken and contentUnrated then
		v10 = questionnaireRequiredBanner
	end

	local v14 = GameConfigurationLabels.getContentMaturityText(v9, provisionalRating, contentUnrated and not sealBroken)
		or loading

	local v15 = React.useCallback(function()
		v6(GameConfigurationActions.getCreatorHubConfigureUrl(data.universeId), creatorHub)
	end, { creatorHub, v6, data.universeId })

	local v16 = React.useCallback(function()
		v6(GameConfigurationActions.getExperienceQuestionnaireUrl(data.universeId), creatorHub, function()
			refreshPublishEligibility(data.universeId)
		end)
	end, { creatorHub, v6, data.universeId })
	local v17

	if FFlagBuildExperienceConfigurationRowTelemetry then
		v17 = React.useCallback(function(p2)
			sendConfigurationRowClick(
				"publish",
				{
					universeId = data.universeId,
					placeId = data.placeId,
					sessionId = data.sessionId
				},
				p2
			)
		end, { data.universeId, data.placeId, data.sessionId })
	end

	if fFlagMyStatsMediaSelector then
		v15 = data.onOpenMediaSelectionPage
	end

	local v18 = {
		buildMaturityBannerText = v10,
		contentMaturityText = v14,
		onOpenIconAndThumbnails = v15,
		onOpenTitleDescriptionPage = data.onOpenTitleDescriptionPage,
		onOpenContentMaturity = v16,
		onOpenVersionTitleDescriptionPage = data.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = data.onOpenVersionHistory,
		onRowActivated = 0,
		isEditDisabled = 0,
		isIconAndThumbnailsDisabled = 0,
		layoutOrder = 0,
		testId = 0
	}

	if not FFlagBuildExperienceConfigurationRowTelemetry then
		v17 = nil
	end

	v18.onRowActivated = v17
	v18.isEditDisabled = FFlagBuildCheckGamePermissions and not v7.canEdit
	v18.isIconAndThumbnailsDisabled = FFlagBuildCheckGamePermissions and not (fFlagMyStatsMediaSelector or v7.canViewOnCreatorHub)
	v18.layoutOrder = data.layoutOrder
	v18.testId = data.testId
	return v18
end

return usePublishConfigurationContentViewModel
