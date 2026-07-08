local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local ArchiveGameDialog = require(BuildExperience.Components.BuildPillMenu.ArchiveGameDialog)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local GameConfigurationList = require(script.Parent.Parent.GameConfigurationList.GameConfigurationList)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local v17 = game:DefineFastFlag("MyStatsMediaSelector", false)

local function GameConfigurationContent(t1: {[any]: any}) -- line: 43
	-- upvalues: useOpenWebView (copy), useArchiveGameFlow (copy), React (copy), UniverseConfiguration (copy), ExperienceGuidelines (copy), SignalsReact (copy), GameConfigurationLabels (copy), GameConfigurationActions (copy), v17 (copy), IconName (copy), View (copy), GameConfigurationList (copy), FoundationText (copy), ArchiveGameDialog (copy)
	local v20 = t1.testId or "game-configuration-content"
	local v21 = useOpenWebView()
	local v22 = useArchiveGameFlow()
	local v23 = React.useMemo(function() -- line: 47
		-- upvalues: UniverseConfiguration (copy), t1 (copy)
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t1.universeId)
	end, { t1.universeId })
	local v24 = React.useMemo(function() -- line: 50
		-- upvalues: ExperienceGuidelines (copy), t1 (copy)
		return ExperienceGuidelines.getExperienceGuidelinesStore().getAndFetchDetailedGuidelines(t1.universeId)
	end, { t1.universeId })
	local v25 = SignalsReact.useSignalState(v23.data)
	local v26 = SignalsReact.useSignalState(v24.data)
	local v27 = not v25 and "Loading..." or (GameConfigurationLabels.getAudienceText(v25) or GameConfigurationLabels.UNKNOWN_AUDIENCE_TEXT)
	local v28 = GameConfigurationLabels.getContentRatingText(v26) or "Loading..."
	local v29 = React.useCallback(function() -- line: 60
		-- upvalues: v21 (copy), GameConfigurationActions (copy), t1 (copy)
		v21(GameConfigurationActions.getCreatorHubConfigureUrl(t1.universeId), "Creator Hub")
	end, {
		v21,
		t1.universeId
	})
	local v30 = React.useCallback(function() -- line: 64
		-- upvalues: v21 (copy), GameConfigurationActions (copy), t1 (copy)
		v21(GameConfigurationActions.getExperienceQuestionnaireUrl(t1.universeId), "Creator Hub")
	end, {
		v21,
		t1.universeId
	})
	local v31 = React.useMemo(function() -- line: 69
		-- upvalues: v17 (copy), IconName (copy), t1 (copy), v29 (copy)
		return {
			{
				id = "icon-thumbnails",
				title = "Icon & Thumbnails",
				trailingIcon = if not v17 then IconName.ArrowUpRightFromSquare else nil,
				onActivated = if not v17 then v29 else t1.onOpenMediaSelectionPage
			},
			{
				id = "title-description",
				title = "Title & Description",
				trailingIcon = nil,
				description = t1.experienceName,
				onActivated = t1.onOpenTitleDescriptionPage
			}
		}
	end, {
		v29,
		t1.experienceName,
		t1.onOpenMediaSelectionPage,
		t1.onOpenTitleDescriptionPage
	})
	local v32 = React.useMemo(function() -- line: 91
		-- upvalues: v27 (copy), t1 (copy), v28 (copy), IconName (copy), v30 (copy)
		return {
			{
				id = "audience",
				title = "Audience",
				trailingIcon = nil,
				description = v27,
				onActivated = t1.onOpenAudiencePage
			},
			{
				id = "content-rating",
				title = "Content rating",
				description = v28,
				trailingIcon = IconName.ArrowUpRightFromSquare,
				onActivated = v30
			}
		}
	end, {
		v27,
		v28,
		v30,
		t1.onOpenAudiencePage
	})
	local v33 = React.useMemo(function() -- line: 110
		-- upvalues: IconName (copy), v29 (copy)
		return {{
			id = "creator-hub",
			title = "Creator Hub",
			description = "Manage all settings on Creator Hub",
			trailingIcon = IconName.ArrowUpRightFromSquare,
			onActivated = v29
		}}
	end, { v29 })
	local v34 = React.useCallback(function() -- line: 122
		-- upvalues: v22 (copy), t1 (copy)
		v22.requestArchive(t1.universeId)
	end, {
		v22.requestArchive,
		t1.universeId
	})

	return React.createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder,
		testId = v20
	}, {
		GameDetails = React.createElement(GameConfigurationList, {
			layoutOrder = 1,
			title = "Game Details",
			body = "Manage how your game appears to others.",
			rows = v31,
			testId = `{ v20 }-game-details`
		}),
		Access = React.createElement(GameConfigurationList, {
			layoutOrder = 2,
			title = "Access",
			body = "Choose who can play after you publish this experience.",
			rows = v32,
			testId = `{ v20 }-access`
		}),
		CreatorHub = React.createElement(GameConfigurationList, {
			layoutOrder = 3,
			title = "Creator Hub",
			rows = v33,
			testId = `{ v20 }-creator-hub`
		}),
		ArchiveGame = React.createElement(View, {
			LayoutOrder = 4,
			tag = "row align-y-center size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
			onActivated = v34,
			stateLayer = {},
			testId = `{ v20 }-archive-game`
		}, {
			Label = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = "Archive game",
				tag = "fill auto-y text-title-medium text-align-x-left content-default"
			})
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v22.isOpen,
			onArchive = v22.confirm,
			onCancel = v22.cancel
		})
	})
end

return GameConfigurationContent
