local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(script.Parent.PublishConfigurationContentView)

local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function usePublishConfigurationContentViewModel(t1: {[any]: any}) -- line: 27
	-- upvalues: useOpenWebView (copy), React (copy), ExperienceGuidelines (copy), SignalsReact (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), GameConfigurationActions (copy), FFlagMyStatsMediaSelector (copy)
	local v14 = useOpenWebView()
	local v15 = React.useMemo(function() -- line: 29
		-- upvalues: ExperienceGuidelines (copy), t1 (copy)
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(t1.universeId)
	end, { t1.universeId })
	local v16 = SignalsReact.useSignalState(v15.data)
	local v17 = GameConfigurationLabels.getContentRatingText(v16) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local v18 = React.useCallback(function() -- line: 36
		-- upvalues: v14 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v14(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v14,
		t1.universeId
	})
	local v19 = React.useCallback(function() -- line: 43
		-- upvalues: v14 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v14(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v14,
		t1.universeId
	})

	return {
		contentMaturityText = v17,
		onOpenIconAndThumbnails = if not FFlagMyStatsMediaSelector then v18 else t1.onOpenMediaSelectionPage,
		onOpenTitleDescriptionPage = t1.onOpenTitleDescriptionPage,
		onOpenContentMaturity = v19,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}
end

return usePublishConfigurationContentViewModel
