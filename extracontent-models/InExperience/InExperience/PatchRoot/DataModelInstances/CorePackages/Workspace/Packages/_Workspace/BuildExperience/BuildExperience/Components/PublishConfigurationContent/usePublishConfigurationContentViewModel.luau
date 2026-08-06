local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(script.Parent.PublishConfigurationContentView)

local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)

local function usePublishConfigurationContentViewModel(t1: {[any]: any}) -- line: 34
	-- upvalues: useOpenWebView (copy), ExperienceGuidelines (copy), React (copy), SignalsReact (copy), FFlagEnableProvisionalRating (copy), UniverseActivation (copy), ContentMaturityUtils (copy), FFlagBuildRehydrateOnPublish (copy), LocalizationStrings (copy), GameConfigurationLabels (copy), GameConfigurationActions (copy), refreshPublishEligibility (copy), FFlagMyStatsMediaSelector (copy)
	local v19 = useOpenWebView()
	local v20 = ExperienceGuidelines.getExperienceGuidelinesStore()
	local v21 = React.useMemo(function() -- line: 37
		-- upvalues: v20 (copy), t1 (copy)
		return v20.getAndFetchDetailedGuidelines(t1.universeId)
	end, {
		v20,
		t1.universeId
	})
	local v22 = SignalsReact.useSignalState(v21.data)
	local GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = nil
	local v24 = nil
	local v25 = false

	if FFlagEnableProvisionalRating then
		local v26 = UniverseActivation.getUniverseActivationStore()
		local v27 = React.useMemo(function() -- line: 48
			-- upvalues: v26 (copy), t1 (copy)
			return v26.getAndFetchEligibility(t1.universeId)
		end, {
			v26,
			t1.universeId
		})
		local v28 = SignalsReact.useSignalState(v27.data)
		local v29 = ContentMaturityUtils.isContentUnrated(t1.universeId)
		local v30 = ContentMaturityUtils.isSealBroken(t1.universeId)

		v24 = if not v28 then nil else v28.provisionalRating
		v25 = v29 and (not FFlagBuildRehydrateOnPublish or not v30)

		if v30 and v29 then
			GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
		end
	end

	local v31 = GameConfigurationLabels.getContentMaturityText(v22, v24, v25) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local v32 = React.useCallback(function() -- line: 69
		-- upvalues: v19 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v19(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v19,
		t1.universeId
	})
	local v33 = React.useCallback(function() -- line: 76
		-- upvalues: v19 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy), refreshPublishEligibility (copy)
		v19(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, function() -- line: 80
			-- upvalues: refreshPublishEligibility (copy), t1 (copy)
			refreshPublishEligibility(t1.universeId)
		end)
	end, {
		v19,
		t1.universeId
	})

	return {
		buildMaturityBannerText = GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER,
		contentMaturityText = v31,
		onOpenIconAndThumbnails = if not FFlagMyStatsMediaSelector then v32 else t1.onOpenMediaSelectionPage,
		onOpenTitleDescriptionPage = t1.onOpenTitleDescriptionPage,
		onOpenContentMaturity = v33,
		onOpenVersionTitleDescriptionPage = t1.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = t1.onOpenVersionHistory,
		showVersionTitleDescription = FFlagEnableProvisionalRating,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}
end

return usePublishConfigurationContentViewModel
