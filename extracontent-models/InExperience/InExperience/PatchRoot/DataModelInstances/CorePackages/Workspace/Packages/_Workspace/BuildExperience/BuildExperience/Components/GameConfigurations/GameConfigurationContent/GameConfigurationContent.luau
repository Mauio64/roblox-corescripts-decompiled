local CaptureService = game:GetService("CaptureService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local ArchiveGameDialog = require(BuildExperience.Components.BuildPillMenu.ArchiveGameDialog)
local BuildMaturityBanner = require(BuildExperience.Components.GameConfigurations.BuildMaturityBanner.BuildMaturityBanner)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local GameConfigurationList = require(script.Parent.Parent.GameConfigurationList.GameConfigurationList)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local v21 = SharedFlags.FFlagMyStatsMediaSelector and (CaptureService.PromptCaptureGalleryPermissionAsync and game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass"))

local function GameConfigurationContent(t1: {[any]: any}) -- line: 43
	-- upvalues: useOpenWebView (copy), useArchiveGameFlow (copy), React (copy), UniverseConfiguration (copy), ExperienceGuidelines (copy), SignalsReact (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), GameConfigurationActions (copy), v21 (copy), IconName (copy), View (copy), GameConfigurationList (copy), BuildMaturityBanner (copy), FoundationText (copy), ArchiveGameDialog (copy)
	local v24 = t1.testId or "game-configuration-content"
	local v25 = useOpenWebView()
	local v26 = useArchiveGameFlow()
	local v27 = React.useMemo(function() -- line: 47
		-- upvalues: UniverseConfiguration (copy), t1 (copy)
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t1.universeId)
	end, { t1.universeId })
	local v28 = React.useMemo(function() -- line: 50
		-- upvalues: ExperienceGuidelines (copy), t1 (copy)
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(t1.universeId)
	end, { t1.universeId })
	local v29 = SignalsReact.useSignalState(v27.data)
	local v30 = SignalsReact.useSignalState(v28.data)
	local v31 = if not v29 then LocalizationStrings.GAME_CONFIGURATION_LOADING else GameConfigurationLabels.getAudienceText(v29) or GameConfigurationLabels.UNKNOWN_AUDIENCE_TEXT
	local v32 = GameConfigurationLabels.getContentRatingText(v30) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local v33 = React.useCallback(function() -- line: 61
		-- upvalues: v25 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v25(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v25,
		t1.universeId
	})
	local v34 = React.useCallback(function() -- line: 68
		-- upvalues: v25 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v25(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v25,
		t1.universeId
	})
	local v35 = React.useMemo(function() -- line: 76
		-- upvalues: LocalizationStrings (copy), v21 (copy), IconName (copy), t1 (copy), v33 (copy)
		return {
			{
				id = "icon-thumbnails",
				title = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
				trailingIcon = if not v21 then IconName.ArrowUpRightFromSquare else nil,
				onActivated = if not v21 then v33 else t1.onOpenMediaSelectionPage
			},
			{
				id = "title-description",
				trailingIcon = nil,
				title = LocalizationStrings.GAME_CONFIGURATION_TITLE_AND_DESCRIPTION,
				description = t1.experienceName,
				onActivated = t1.onOpenTitleDescriptionPage
			}
		}
	end, {
		v33,
		t1.experienceName,
		t1.onOpenMediaSelectionPage,
		t1.onOpenTitleDescriptionPage
	})
	local v36 = React.useMemo(function() -- line: 98
		-- upvalues: LocalizationStrings (copy), v31 (copy), t1 (copy), v32 (copy), IconName (copy), v34 (copy)
		return {
			{
				id = "audience",
				trailingIcon = nil,
				title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE,
				description = v31,
				onActivated = t1.onOpenAudiencePage
			},
			{
				id = "content-rating",
				title = LocalizationStrings.GAME_CONFIGURATION_CONTENT_RATING,
				description = v32,
				trailingIcon = IconName.ArrowUpRightFromSquare,
				onActivated = v34
			}
		}
	end, {
		v31,
		v32,
		v34,
		t1.onOpenAudiencePage
	})
	local v37 = React.useMemo(function() -- line: 117
		-- upvalues: LocalizationStrings (copy), IconName (copy), v33 (copy)
		return {{
			id = "creator-hub",
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			description = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB_DESCRIPTION,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v33
		}}
	end, { v33 })
	local v38 = React.useCallback(function() -- line: 129
		-- upvalues: v26 (copy), t1 (copy)
		v26.requestArchive(t1.universeId)
	end, {
		v26.requestArchive,
		t1.universeId
	})

	return React.createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder,
		testId = v24
	}, {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
			body = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
			rows = v35,
			testId = `{ v24 }-game-details`
		}),
		Access = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			Configuration = React.createElement(GameConfigurationList, {
				layoutOrder = 1,
				title = LocalizationStrings.GAME_CONFIGURATION_ACCESS,
				body = LocalizationStrings.GAME_CONFIGURATION_ACCESS_BODY,
				rows = v36,
				testId = `{ v24 }-access`
			}),
			BuildMaturityBanner = React.createElement(BuildMaturityBanner)
		}),
		CreatorHub = React.createElement(GameConfigurationList, {
			layoutOrder = 3,
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			rows = v37,
			testId = `{ v24 }-creator-hub`
		}),
		ArchiveGame = React.createElement(View, {
			LayoutOrder = 4,
			tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
			onActivated = v38,
			stateLayer = {},
			testId = `{ v24 }-archive-game`
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-title-medium text-align-x-left content-default",
				Text = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME
			})
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v26.isOpen,
			onArchive = v26.confirm,
			onCancel = v26.cancel
		})
	})
end

return GameConfigurationContent
