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
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)

local function usePublishConfigurationContentViewModel(t1: {[any]: any}) -- line: 32
	-- upvalues: useOpenWebView (copy), ExperienceGuidelines (copy), React (copy), SignalsReact (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), FFlagEnableProvisionalRating (copy), UniverseActivation (copy), GameConfigurationActions (copy), refreshPublishEligibility (copy), FFlagMyStatsMediaSelector (copy)
	local v17 = useOpenWebView()
	local v18 = ExperienceGuidelines.getExperienceGuidelinesStore()
	local v19 = React.useMemo(function() -- line: 35
		-- upvalues: v18 (copy), t1 (copy)
		return v18.getAndFetchDetailedGuidelines(t1.universeId)
	end, {
		v18,
		t1.universeId
	})
	local v20 = SignalsReact.useSignalState(v19.data)
	local v21 = GameConfigurationLabels.getContentRatingText(v20) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = nil

	if FFlagEnableProvisionalRating then
		local v23 = UniverseActivation.getUniverseActivationStore()
		local v24 = React.useMemo(function() -- line: 46
			-- upvalues: v23 (copy), t1 (copy)
			return v23.getAndFetchEligibility(t1.universeId)
		end, {
			v23,
			t1.universeId
		})
		local v25 = SignalsReact.useSignalState(v24.data)
		local v26 = GameConfigurationLabels.getProvisionalRatingText(if not v25 then nil else v25.provisionalRating)
		local v27 = v25 ~= nil and v25.maturityRated == true

		if v26 ~= nil and not v27 then
			local v28 = GameConfigurationLabels.getProvisionalRatingDescriptor(if not v25 then nil else v25.provisionalRating)

			v21 = if v28 == nil then v26 else `{ v26 } - { v28 }`
		end

		if v25 ~= nil and not v27 and v25.provisionalRatingAllowed ~= true then
			GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
		end
	end

	local v29 = React.useCallback(function() -- line: 68
		-- upvalues: v17 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v17(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v17,
		t1.universeId
	})
	local v30 = React.useCallback(function() -- line: 75
		-- upvalues: v17 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy), refreshPublishEligibility (copy)
		v17(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, function() -- line: 79
			-- upvalues: refreshPublishEligibility (copy), t1 (copy)
			refreshPublishEligibility(t1.universeId)
		end)
	end, {
		v17,
		t1.universeId
	})

	return {
		buildMaturityBannerText = GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER,
		contentMaturityText = v21,
		onOpenIconAndThumbnails = if not FFlagMyStatsMediaSelector then v29 else t1.onOpenMediaSelectionPage,
		onOpenTitleDescriptionPage = t1.onOpenTitleDescriptionPage,
		onOpenContentMaturity = v30,
		onOpenVersionTitleDescriptionPage = t1.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = t1.onOpenVersionHistory,
		showVersionTitleDescription = FFlagEnableProvisionalRating,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}
end

return usePublishConfigurationContentViewModel
