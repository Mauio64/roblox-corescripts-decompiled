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
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local GameConfigurationList = require(script.Parent.Parent.GameConfigurationList.GameConfigurationList)
local getPrivatePlaytestersStore = require(BuildExperienceParent.DataHydration.PrivatePlaytesters).getPrivatePlaytestersStore
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local v27 = SharedFlags.FFlagMyStatsMediaSelector and (CaptureService.PromptCaptureGalleryPermissionAsync and game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass"))
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)

local function GameConfigurationContent(t1: {[any]: any}) -- line: 61
	-- upvalues: useOpenWebView (copy), useArchiveGameFlow (copy), FFlagBuildExperiencePrivateInvites (copy), useExperienceShareFlow (copy), React (copy), UniverseConfiguration (copy), ExperienceGuidelines (copy), SignalsReact (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), FFlagEnableProvisionalRating (copy), UniverseActivation (copy), GameConfigurationActions (copy), v27 (copy), IconName (copy), getPrivatePlaytestersStore (copy), Signals (copy), View (copy), GameConfigurationList (copy), BuildMaturityBanner (copy), FoundationText (copy), ArchiveGameDialog (copy), ExperienceShareOverlays (copy)
	local v31 = t1.testId or "game-configuration-content"
	local v32 = useOpenWebView()
	local v33 = useArchiveGameFlow()
	local v34 = if not FFlagBuildExperiencePrivateInvites then nil else useExperienceShareFlow(t1.universeId, t1.placeId)
	local v35 = if v34 == nil then nil else v34.onShare
	local v36 = React.useMemo(function() -- line: 73
		-- upvalues: UniverseConfiguration (copy), t1 (copy)
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t1.universeId)
	end, { t1.universeId })
	local v37 = React.useMemo(function() -- line: 76
		-- upvalues: ExperienceGuidelines (copy), t1 (copy)
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(t1.universeId)
	end, { t1.universeId })
	local v38 = SignalsReact.useSignalState(v36.data)
	local v39 = SignalsReact.useSignalState(v37.data)
	local v40 = if not v38 then LocalizationStrings.GAME_CONFIGURATION_LOADING else GameConfigurationLabels.getAudienceText(v38) or GameConfigurationLabels.UNKNOWN_AUDIENCE_TEXT
	local v41 = GameConfigurationLabels.getContentRatingText(v39) or LocalizationStrings.GAME_CONFIGURATION_LOADING
	local GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = nil

	if FFlagEnableProvisionalRating then
		local v43 = React.useMemo(function() -- line: 89
			-- upvalues: UniverseActivation (copy), t1 (copy)
			return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(t1.universeId)
		end, { t1.universeId })
		local v44 = SignalsReact.useSignalState(v43.data)

		if v44 ~= nil and v44.maturityRated ~= true and v44.provisionalRatingAllowed ~= true then
			GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER = LocalizationStrings.GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
		end
	end

	local v45 = React.useCallback(function() -- line: 102
		-- upvalues: v32 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v32(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v32,
		t1.universeId
	})
	local v46 = React.useCallback(function() -- line: 109
		-- upvalues: v32 (copy), GameConfigurationActions (copy), t1 (copy), LocalizationStrings (copy)
		v32(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB)
	end, {
		v32,
		t1.universeId
	})
	local v47 = React.useMemo(function() -- line: 117
		-- upvalues: LocalizationStrings (copy), v27 (copy), IconName (copy), t1 (copy), v45 (copy)
		return {
			{
				id = "icon-thumbnails",
				title = LocalizationStrings.GAME_CONFIGURATION_ICON_AND_THUMBNAILS,
				trailingIcon = if not v27 then IconName.ArrowUpRightFromSquare else nil,
				onActivated = if not v27 then v45 else t1.onOpenMediaSelectionPage
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
		v45,
		t1.experienceName,
		t1.onOpenMediaSelectionPage,
		t1.onOpenTitleDescriptionPage
	})
	local onOpenPlaytestPicker = t1.onOpenPlaytestPicker
	local onOpenPlaytestManagement = t1.onOpenPlaytestManagement
	local v50 = FFlagBuildExperiencePrivateInvites and (onOpenPlaytestPicker ~= nil and onOpenPlaytestManagement ~= nil)
	local v51 = React.useMemo(function() -- line: 145
		-- upvalues: v50 (copy), getPrivatePlaytestersStore (copy), t1 (copy)
		if not v50 then
			return nil
		end

		return getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(t1.universeId)
	end, {
		v50,
		t1.universeId
	})
	local v52 = React.useMemo(function() -- line: 152
		-- upvalues: Signals (copy), v51 (copy)
		return Signals.createComputed(function(p1) -- line: 153
			-- upvalues: v51 (copy)
			if v51 ~= nil then
				return #v51.players(p1)
			end

			return 0
		end)
	end, { v51 })
	local v53 = SignalsReact.useSignalState(v52)
	local v54 = React.useMemo(function() -- line: 159
		-- upvalues: Signals (copy), v51 (copy)
		return Signals.createComputed(function(p2) -- line: 160
			-- upvalues: v51 (copy)
			if v51 ~= nil then
				return (v51.status(p2))
			end

			return "NotReady"
		end)
	end, { v51 })
	local v55 = SignalsReact.useSignalState(v54)
	local MAX_INVITES = getPrivatePlaytestersStore(false).MAX_INVITES
	local u57 = nil

	if v50 then
		u57 = if v55 ~= "Ready" then {
			id = "playtest",
			trailingIcon = nil,
			onActivated = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE,
			description = if v55 ~= "Failed" then LocalizationStrings.GAME_CONFIGURATION_LOADING else LocalizationStrings.PRIVATE_INVITES_ROW_LOAD_ERROR
		} else if not (v53 > 0) then {
			id = "playtest",
			trailingIcon = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE_EMPTY,
			description = LocalizationStrings.PRIVATE_INVITES_ROW_DESCRIPTION,
			onActivated = onOpenPlaytestPicker
		} else {
			id = "playtest",
			trailingIcon = nil,
			title = LocalizationStrings.PRIVATE_INVITES_ROW_TITLE,
			description = LocalizationStrings.formatPrivateInvitesSent(v53, MAX_INVITES),
			onActivated = onOpenPlaytestManagement
		}
	end

	local v58 = React.useMemo(function() -- line: 205
		-- upvalues: LocalizationStrings (copy), v40 (copy), t1 (copy), u57 (ref), v35 (copy), v41 (copy), IconName (copy), v46 (copy)
		local t2 = {{
			id = "audience",
			trailingIcon = nil,
			title = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE,
			description = v40,
			onActivated = t1.onOpenAudiencePage
		}}

		if u57 ~= nil then
			table.insert(t2, u57)
			table.insert(t2, {
				id = "playtest-share-link",
				trailingIcon = nil,
				title = LocalizationStrings.PRIVATE_INVITES_SHARE_LINK,
				onActivated = v35
			})
		end

		table.insert(t2, {
			id = "content-rating",
			title = LocalizationStrings.GAME_CONFIGURATION_CONTENT_RATING,
			description = v41,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v46
		})

		return t2
	end, {
		v40,
		v41,
		v46,
		u57,
		v35,
		t1.onOpenAudiencePage
	})
	local v59 = React.useMemo(function() -- line: 246
		-- upvalues: LocalizationStrings (copy), IconName (copy), v45 (copy)
		return {{
			id = "creator-hub",
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			description = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB_DESCRIPTION,
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v45
		}}
	end, { v45 })
	local v60 = React.useCallback(function() -- line: 258
		-- upvalues: v33 (copy), t1 (copy)
		v33.requestArchive(t1.universeId)
	end, {
		v33.requestArchive,
		t1.universeId
	})

	return React.createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder,
		testId = v31
	}, {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS,
			body = LocalizationStrings.GAME_CONFIGURATION_GAME_DETAILS_BODY,
			rows = v47,
			testId = `{ v31 }-game-details`
		}),
		Access = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			Configuration = React.createElement(GameConfigurationList, {
				layoutOrder = 1,
				title = if not v50 then LocalizationStrings.GAME_CONFIGURATION_ACCESS else LocalizationStrings.GAME_CONFIGURATION_ACCESS_AND_SHARING,
				body = LocalizationStrings.GAME_CONFIGURATION_ACCESS_BODY,
				rows = v58,
				testId = `{ v31 }-access`
			}),
			BuildMaturityBanner = if GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER == nil then nil else React.createElement(BuildMaturityBanner, {
				text = GAME_CONFIGURATION_QUESTIONNAIRE_REQUIRED_BANNER
			})
		}),
		CreatorHub = React.createElement(GameConfigurationList, {
			layoutOrder = 3,
			title = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
			rows = v59,
			testId = `{ v31 }-creator-hub`
		}),
		ArchiveGame = React.createElement(View, {
			LayoutOrder = 4,
			tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
			onActivated = v60,
			stateLayer = {},
			testId = `{ v31 }-archive-game`
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-title-medium text-align-x-left content-default",
				Text = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME
			})
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v33.isOpen,
			onArchive = v33.confirm,
			onCancel = v33.cancel
		}),
		ShareOverlays = if not FFlagBuildExperiencePrivateInvites or v34 == nil then nil else React.createElement(ExperienceShareOverlays, {
			activeDialog = v34.activeDialog,
			hasShareError = v34.hasShareError,
			onCancel = v34.onCancelDialog,
			onConfirmFriends = v34.onConfirmFriends,
			onConfirmPlaytesters = v34.onConfirmPlaytesters
		})
	})
end

return GameConfigurationContent
