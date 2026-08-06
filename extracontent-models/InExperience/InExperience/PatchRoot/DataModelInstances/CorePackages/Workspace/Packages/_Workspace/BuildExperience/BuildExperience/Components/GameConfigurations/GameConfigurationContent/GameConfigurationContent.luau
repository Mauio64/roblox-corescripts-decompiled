local CaptureService = game:GetService("CaptureService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local ArchiveGameDialog = require(BuildExperience.Components.GameConfigurations.ArchiveGameDialog)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
local BuildMaturityBanner = require(BuildExperience.Components.GameConfigurations.BuildMaturityBanner.BuildMaturityBanner)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local GameConfigurationList = require(script.Parent.Parent.GameConfigurationList.GameConfigurationList)
local getPrivatePlaytestersStore = require(BuildExperienceParent.DataHydration.PrivatePlaytesters).getPrivatePlaytestersStore
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local v29 = SharedFlags.FFlagMyStatsMediaSelector and (CaptureService.PromptCaptureGalleryPermissionAsync and game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass"))
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)

local function GameConfigurationContent(t1: {[any]: any}) -- line: 64
	-- upvalues: useOpenWebView (copy), useArchiveGameFlow (copy), FFlagBuildExperiencePrivateInvites (copy), useExperienceShareFlow (copy), React (copy), UniverseConfiguration (copy), ExperienceGuidelines (copy), SignalsReact (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), FFlagEnableProvisionalRating (copy), UniverseActivation (copy), ContentMaturityUtils (copy), FFlagBuildRehydrateOnPublish (copy), GameConfigurationActions (copy), refreshPublishEligibility (copy), v29 (copy), IconName (copy), getPrivatePlaytestersStore (copy), Signals (copy), View (copy), GameConfigurationList (copy), BuildMaturityBanner (copy), FoundationText (copy), ArchiveGameDialog (copy), ExperienceShareOverlays (copy)
	local v34 = t1.testId or "game-configuration-content"
	local v35 = useOpenWebView()
	local v36 = useArchiveGameFlow()
	local v37 = if not FFlagBuildExperiencePrivateInvites then nil else useExperienceShareFlow(t1.universeId, t1.placeId)
	local v38 = if v37 == nil then nil else v37.onShare
	local v39 = React.useMemo(function() -- line: 76
		-- upvalues: UniverseConfiguration (copy), t1 (copy)
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t1.universeId)
	end, { t1.universeId })
	local v40 = React.useMemo(function() -- line: 79
		-- upvalues: ExperienceGuidelines (copy), t1 (copy)
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(t1.universeId)
	end, { t1.universeId })
	local v41 = SignalsReact.useSignalState(v39.data)
	local v42 = SignalsReact.useSignalState(v40.data)
	local v43 = if not v41 then LocalizationStrings.GAME_CONFIGURATION_LOADING else GameConfigurationLabels.getAudienceText(v41) or GameConfigurationLabels.UNKNOWN_AUDIENCE_TEXT
	local GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = nil
	local v45 = nil
	local v46 = false

	if FFlagEnableProvisionalRating then
		local v47 = React.useMemo(function() -- line: 92
			-- upvalues: UniverseActivation (copy), t1 (copy)
			return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(t1.universeId)
		end, { t1.universeId })
		local v48 = SignalsReact.useSignalState(v47.data)
		local v49 = React.useMemo(function() -- line: 96
			-- upvalues: ContentMaturityUtils (copy), t1 (copy)
			return ContentMaturityUtils.isSealBroken(t1.universeId)
		end, {
			v48,
			t1.universeId
		})
		local v50 = React.useMemo(function() -- line: 99
			-- upvalues: ContentMaturityUtils (copy), t1 (copy)
			return ContentMaturityUtils.isContentUnrated(t1.universeId)
		end, {
			v48,
			t1.universeId
		})

		if FFlagBuildRehydrateOnPublish then
			v45 = if not v48 then nil else v48.provisionalRating
			v46 = v50 and not v49
		end

		if v49 and v50 then
			GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
		end
	end

	local v51 = GameConfigurationLabels.getContentMaturityText(v42, v45, v46) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local v52 = React.useCallback(function() -- line: 117
		-- upvalues: v35 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v35(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v35,
		t1.universeId
	})
	local v53 = React.useCallback(function() -- line: 124
		-- upvalues: FFlagBuildRehydrateOnPublish (copy), v35 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy), refreshPublishEligibility (copy)
		if FFlagBuildRehydrateOnPublish then
			v35(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, function() -- line: 129
				-- upvalues: refreshPublishEligibility (copy), t1 (copy)
				refreshPublishEligibility(t1.universeId)
			end)

			return
		end

		v35(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v35,
		t1.universeId
	})
	local v54 = React.useMemo(function() -- line: 142
		-- upvalues: LocalizationStrings (copy), v29 (copy), IconName (copy), t1 (copy), v52 (copy)
		return {
			{
				id = "icon-thumbnails",
				title = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
				trailingIcon = if not v29 then IconName.ArrowUpRightFromSquare else nil,
				onActivated = if not v29 then v52 else t1.onOpenMediaSelectionPage
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
		v52,
		t1.experienceName,
		t1.onOpenMediaSelectionPage,
		t1.onOpenTitleDescriptionPage
	})
	local onOpenPlaytestPicker = t1.onOpenPlaytestPicker
	local onOpenPlaytestManagement = t1.onOpenPlaytestManagement
	local v57 = FFlagBuildExperiencePrivateInvites and (onOpenPlaytestPicker ~= nil and onOpenPlaytestManagement ~= nil)
	local v58 = React.useMemo(function() -- line: 170
		-- upvalues: v57 (copy), getPrivatePlaytestersStore (copy), t1 (copy)
		if not v57 then
			return nil
		end

		return getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(t1.universeId)
	end, {
		v57,
		t1.universeId
	})
	local v59 = React.useMemo(function() -- line: 177
		-- upvalues: Signals (copy), v58 (copy)
		return Signals.createComputed(function(p1) -- line: 178
			-- upvalues: v58 (copy)
			if v58 ~= nil then
				return #v58.players(p1)
			end

			return 0
		end)
	end, { v58 })
	local v60 = SignalsReact.useSignalState(v59)
	local v61 = React.useMemo(function() -- line: 184
		-- upvalues: Signals (copy), v58 (copy)
		return Signals.createComputed(function(p2) -- line: 185
			-- upvalues: v58 (copy)
			if v58 ~= nil then
				return (v58.status(p2))
			end

			return "NotReady"
		end)
	end, { v58 })
	local v62 = SignalsReact.useSignalState(v61)
	local MAX_INVITES = getPrivatePlaytestersStore(false).MAX_INVITES
	local u64 = nil

	if v57 then
		u64 = if v62 ~= "Ready" then {
			id = "playtest",
			trailingIcon = nil,
			onActivated = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE,
			description = if v62 ~= "Failed" then LocalizationStrings.GAME_CONFIGURATION_LOADING else LocalizationStrings.PRIVATE_INVITES_ROW_LOAD_ERROR
		} else if not (v60 > 0) then {
			id = "playtest",
			trailingIcon = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE_EMPTY,
			description = LocalizationStrings.PRIVATE_INVITES_ROW_DESCRIPTION,
			onActivated = onOpenPlaytestPicker
		} else {
			id = "playtest",
			trailingIcon = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE,
			description = LocalizationStrings.formatPrivateInvitesSent(v60, MAX_INVITES),
			onActivated = onOpenPlaytestManagement
		}
	end

	local v65 = React.useMemo(function() -- line: 230
		-- upvalues: LocalizationStrings (copy), v43 (copy), t1 (copy), u64 (ref), v38 (copy), v51 (copy), IconName (copy), v53 (copy)
		local t2 = {{
			id = "audience",
			trailingIcon = nil,
			title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE,
			description = v43,
			onActivated = t1.onOpenAudiencePage
		}}

		if u64 ~= nil then
			table.insert(t2, u64)
			table.insert(t2, {
				id = "playtest-share-link",
				trailingIcon = nil,
				title = LocalizationStrings.PRIVATE_INVITES_SHARE_LINK,
				onActivated = v38
			})
		end

		table.insert(t2, {
			id = "content-rating",
			title = LocalizationStrings.GAME_CONFIGURATION_CONTENT_RATING,
			description = v51,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v53
		})

		return t2
	end, {
		v43,
		v51,
		v53,
		u64,
		v38,
		t1.onOpenAudiencePage
	})
	local v66 = React.useMemo(function() -- line: 271
		-- upvalues: LocalizationStrings (copy), IconName (copy), v52 (copy)
		return {{
			id = "creator-hub",
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			description = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB_DESCRIPTION,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v52
		}}
	end, { v52 })
	local v67 = React.useCallback(function() -- line: 283
		-- upvalues: v36 (copy), t1 (copy)
		v36.requestArchive(t1.universeId)
	end, {
		v36.requestArchive,
		t1.universeId
	})

	return React.createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder,
		testId = v34
	}, {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
			body = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
			rows = v54,
			testId = `{ v34 }-game-details`
		}),
		Access = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			Configuration = React.createElement(GameConfigurationList, {
				layoutOrder = 1,
				title = if not v57 then LocalizationStrings.GAME_CONFIGURATION_ACCESS else LocalizationStrings.GAME_CONFIGURATION_ACCESS_AND_SHARING,
				body = LocalizationStrings.GAME_CONFIGURATION_ACCESS_BODY,
				rows = v65,
				testId = `{ v34 }-access`
			}),
			BuildMaturityBanner = if GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER == nil then nil else React.createElement(BuildMaturityBanner, {
				text = GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
			})
		}),
		CreatorHub = React.createElement(GameConfigurationList, {
			layoutOrder = 3,
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			rows = v66,
			testId = `{ v34 }-creator-hub`
		}),
		ArchiveGame = React.createElement(View, {
			LayoutOrder = 4,
			tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
			onActivated = v67,
			stateLayer = {},
			testId = `{ v34 }-archive-game`
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-title-medium text-align-x-left content-default",
				Text = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME
			})
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v36.isOpen,
			onArchive = v36.confirm,
			onCancel = v36.cancel
		}),
		ShareOverlays = if not FFlagBuildExperiencePrivateInvites or v37 == nil then nil else React.createElement(ExperienceShareOverlays, {
			activeDialog = v37.activeDialog,
			hasShareError = v37.hasShareError,
			onCancel = v37.onCancelDialog,
			onConfirmFriends = v37.onConfirmFriends,
			onConfirmPlaytesters = v37.onConfirmPlaytesters
		})
	})
end

return GameConfigurationContent
