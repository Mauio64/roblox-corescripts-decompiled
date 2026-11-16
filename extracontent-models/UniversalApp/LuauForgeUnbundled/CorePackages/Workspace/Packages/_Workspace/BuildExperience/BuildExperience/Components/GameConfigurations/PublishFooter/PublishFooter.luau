local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local GameDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/GameDetail")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Responsive")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local ExperienceGuidelines = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceGuidelines")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildPostPublishShareDismissible = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPostPublishShareDismissible")

local FIntBuildPostPublishSnackbarAutoDismissSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildPostPublishSnackbarAutoDismissSeconds")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/FriendsOnlyShareDialog")
local ContentMaturityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/ContentMaturityUtils")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")
local getGameDetailsNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getGameDetailsNavigation")
local refreshPublishEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/refreshPublishEligibility")
local useClosableFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useClosableFocusRoot")
local GetVersionInformationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetVersionInformationStore")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local button = Foundation.Button
local popover = Foundation.Popover
local snackbar = Foundation.Snackbar
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local privacyType = UniverseConfiguration.PrivacyType

local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local fFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local FFlagBuildPublishNavigationSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPublishNavigationSheet")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildExperiencePlaytestCardPublishCta = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytestCardPublishCta")
local v5 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore") else nil
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local openGameDetails = GameDetail.OpenGameDetails

local Debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local module31 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/sharePublishedExperience")
local sharePublishedExperience = module31.sharePublishedExperience
local useSharePublishedExperience = module31.useSharePublishedExperience
local universalShareSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ShareSheet").UniversalShareSheet

local v6 = {}

local function isPublishedVersion(p2): boolean
	if typeof(p2) ~= "table" then
		return false
	end

	return p2.status == "success" and typeof(p2.version) == "string" and p2.version ~= ""
end

local function buildPublicAudiences(options)
	local publicAudiences = {}

	for k, v7 in options or {} do
		if v7 ~= UniverseActivation.Audience.Public and v7 ~= UniverseActivation.Audience.Friends then
			table.insert(publicAudiences, v7)
		end
	end

	table.insert(publicAudiences, UniverseActivation.Audience.Public)
	return publicAudiences
end

local function PreviewButton(props)
	local preview = useLocalization({ preview = LocalizationStrings.GAME_CONFIGURATION_PREVIEW }).preview
	local v7 = useStore()
	local v8 = useNavigation()

	local onPreview = props.onPreview
	local v9 = React.useCallback(function()
		local rootNavigation = getRootNavigation(v8)
		openGameDetails(tostring(props.target.universeId), getGameDetailsNavigation(rootNavigation), {
			source = "BuildExperiencePublish"
		})(v7)

		if onPreview then
			onPreview()
		end
	end, { v8, props.target.universeId, v7, onPreview })

	return React.createElement(button, {
		text = preview,
		size = inputSize.Medium,
		variant = buttonVariant.Standard,
		fillBehavior = fillBehavior.Fill,
		onActivated = v9,
		width = UDim.new(1, 0),
		LayoutOrder = 2,
		testId = `{props.actionsTestId}-preview`
	})
end

local function PublishFooter(props)
	local v7 = useLocalization({
		accountTooNewError = LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ACCOUNT_TOO_NEW_ERROR,
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB,
		linkCopied = LocalizationStrings.GAME_CONFIGURATION_LINK_COPIED,
		publish = LocalizationStrings.GAME_CONFIGURATION_PUBLISH,
		publishAudienceError = LocalizationStrings.GAME_CONFIGURATION_PUBLISH_AUDIENCE_ERROR,
		publishError = LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ERROR,
		publishSuccess = LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS,
		share = LocalizationStrings.GAME_CONFIGURATION_SHARE,
		updateRating = LocalizationStrings.GAME_CONFIGURATION_UPDATE_RATING
	})

	local accountTooNewError = v7.accountTooNewError
	local creatorHub = v7.creatorHub
	local linkCopied = v7.linkCopied
	local v8 = v7.publish
	local publishAudienceError = v7.publishAudienceError
	local publishError = v7.publishError
	local publishSuccess = v7.publishSuccess
	local share = v7.share
	local updateRating = v7.updateRating
	local v9 = useSharePublishedExperience(props.target.universeId)
	local v10 = SignalsReact.useSignalState(PlaceVersionHistory.getPlaceVersionHistoryStore)
	local v11 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)

	local v12 = SignalsReact.useSignalState(v11.getAndFetchConfiguration(props.target.universeId).data)
	local v13 = React.useMemo(function()
		return v11.getAndFetchSummary(props.target.universeId).data
	end, { v11, props.target.universeId })
	local v14 = SignalsReact.useSignalState(v13)
	local audience = GameConfigurationLabels.getAudience(v12)

	local v15 = SignalsReact.useSignalState(UniverseActivation.getUniverseActivationStore)
	local v16 = v15
	local v17 = React.useMemo(function()
		return v15.getAndFetchEligibility(props.target.universeId)
	end, { v15, props.target.universeId })
	local v18 = SignalsReact.useSignalState(v17.data)
	local v19 = React.useMemo(function()
		return ContentMaturityUtils.isSealBroken(props.target.universeId)
			and ContentMaturityUtils.isContentUnrated(props.target.universeId)
	end, { v18, props.target.universeId })
	local v20 = useOpenWebView()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(nil)
	local v21

	if state2 == publishSuccess and props.target.placeId ~= nil and audience ~= nil then
		v21 = audience ~= privacyType.Private
	else
		v21 = false
	end

	local v22 = React.useCallback(function()
		setState2("")
		setState3(nil)
	end, {})

	if FFlagBuildPostPublishShareDismissible then
		React.useEffect(function()
			if state2 == "" then
				return nil
			end

			local thread = task.delay(FIntBuildPostPublishSnackbarAutoDismissSeconds, setState2, "")
			return function()
				task.cancel(thread)
			end
		end, { state2 })
	end

	local v23 = React.useCallback(function()
		if props.target.placeId == nil then
			return
		end

		setState3(nil)

		if fFlagEnableShareSheet then
			local placeId = props.target.placeId

			local v25 = if fFlagShareSheetFriendsSort then universalShareSheet.RecipientSource.OneToOneFriends else nil
			v9(placeId, v25)
		else
			local v24 = sharePublishedExperience(props.target.placeId)

			if v24 ~= nil and v24.copiedToClipboard and linkCopied ~= nil then
				setState2(linkCopied)
			end
		end
	end, { linkCopied, props.target.placeId, v9 })

	local v24 = React.useCallback(function()
		if FFlagBuildPostPublishShareDismissible then
			setState2("")
		end

		if audience == privacyType.FriendsOnly then
			setState3("friends")
		elseif audience == privacyType.Public then
			v23()
		end
	end, { audience, v23 })

	local v25 = React.useCallback(function()
		setState3(nil)
	end, {})

	local v26 = React.useCallback(function()
		v20(GameConfigurationActions.getExperienceQuestionnaireUrl(props.target.universeId), creatorHub, function()
			refreshPublishEligibility(props.target.universeId)
		end)
	end, { creatorHub, v20, props.target.universeId })

	local function fn()
		if state then
			return
		end

		local placeId = props.target.placeId

		if placeId == nil then
			return
		end

		local v27 = nil
		local v28 = nil
		local function selectVersionNotes(p2)
			local draft = GetVersionInformationStore().getDraft()
			local v29 = if p2 ~= nil then p2.placeVersions[1] else nil

			if draft == nil or draft.placeId ~= placeId then
				if v29 ~= nil then
					v27 = v29.title
					v28 = v29.description
				end
			else
				v27 = if draft.title ~= "" then draft.title else nil
				v28 = if draft.description ~= "" then draft.description else nil
			end
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = props.target.universeId,
			placeId = placeId,
			conversationId = props.target.sessionId
		})

		setState(true)
		v22()
		local v29 = "save_and_publish"
		local v30 = false
		local function recordSuccessfulPublish(p2)
			local v31

			if typeof(p2) == "table" and p2.status == "success" and typeof(p2.version) == "string" then
				v31 = p2.version ~= ""
			else
				v31 = false
			end

			if not v31 then
				return
			end

			v5(false).reportMenuPublish(props.target.universeId, props.target.sessionId, p2.version, v30)
		end
		local function publish(p2)
			v29 = "save_and_publish"
			local v31 = p2 or v14

			if FFlagBuildAdUpsell then
				v30 = true
			end

			local publishExperience = GameConfigurationActions.publishExperience
			local v32 = {
				universeId = props.target.universeId,
				placeId = placeId,
				title = v27,
				description = v28,
				isActive = v31 ~= nil and v31.isActive == true,
				audiences = 0
			}
			local v35 = if v31 then v31.audiences else nil
			v32.audiences = buildPublicAudiences(v35)
			return publishExperience(v32)
		end

		local function startPublish()
			if v16 == nil then
				return publish()
			end

			v29 = "refresh_eligibility"
			return v16.refreshEligibility(props.target.universeId):andThen(function()
				if
					ContentMaturityUtils.isSealBroken(props.target.universeId)
					and ContentMaturityUtils.isContentUnrated(props.target.universeId)
				then
					return ExperienceGuidelines.getExperienceGuidelinesStore().refreshDetailedGuidelines(props.target.universeId):andThen(
						function()
							return v6
						end,
						function(p2)
							Debug.log("warn", "build_experience content maturity refresh failed", {
								errorMessage = tostring(p2),
								universeId = props.target.universeId
							})

							return v6
						end
					)
				end

				v29 = "refresh_summary"

				return v11.refreshSummary(props.target.universeId):andThen(function(p2)
					return publish(p2)
				end)
			end)
		end

		local draft = GetVersionInformationStore().getDraft()
		local v31

		if draft == nil or draft.placeId ~= placeId then
			v31 = v10.fetchPageHistory(placeId):andThen(selectVersionNotes, function()
				local draft2 = GetVersionInformationStore().getDraft()

				if draft2 == nil or draft2.placeId ~= placeId then
					return
				end

				v27 = if draft2.title ~= "" then draft2.title else nil
				v28 = if draft2.description ~= "" then draft2.description else nil
			end):andThen(startPublish)
		else
			local draft2 = GetVersionInformationStore().getDraft()

			if draft2 ~= nil and draft2.placeId == placeId then
				v27 = if draft2.title ~= "" then draft2.title else nil
				v28 = if draft2.description ~= "" then draft2.description else nil
			end

			if v16 == nil then
				v31 = publish()
			else
				v29 = "refresh_eligibility"
				v31 = v16.refreshEligibility(props.target.universeId):andThen(function()
					if
						ContentMaturityUtils.isSealBroken(props.target.universeId)
						and ContentMaturityUtils.isContentUnrated(props.target.universeId)
					then
						return ExperienceGuidelines.getExperienceGuidelinesStore().refreshDetailedGuidelines(props.target.universeId):andThen(
							function()
								return v6
							end,
							function(p2)
								Debug.log("warn", "build_experience content maturity refresh failed", {
									errorMessage = tostring(p2),
									universeId = props.target.universeId
								})

								return v6
							end
						)
					end

					v29 = "refresh_summary"

					return v11.refreshSummary(props.target.universeId):andThen(function(p2)
						return publish(p2)
					end)
				end)
			end
		end

		v31:andThen(function(p2)
			if p2 == v6 then
				return
			end

			local v32

			if typeof(p2) == "table" and p2.status == "success" and typeof(p2.version) == "string" then
				v32 = p2.version ~= ""
			else
				v32 = false
			end

			if not v32 then
				error({
					errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={tostring(p2.status)}, version={tostring(p2.version)}`
				})
			end

			if FFlagBuildAdUpsell then
				local v33

				if typeof(p2) == "table" and p2.status == "success" and typeof(p2.version) == "string" then
					v33 = p2.version ~= ""
				else
					v33 = false
				end

				if v33 then
					v5(false).reportMenuPublish(
						props.target.universeId,
						props.target.sessionId,
						p2.version,
						v30
					)
				end
			end

			GetVersionInformationStore().clearDraft(placeId)
			v10.fetchHistory(placeId)

			if FFlagBuildExperiencePlaytestCardPublishCta then
				v10.fetchLiveVersion(placeId)
			end

			setState2(publishSuccess)
		end):catch(function(data)
			local v32 = typeof(data) == "table"

			local v33 = v32 and data.stage == GameConfigurationActions.PublishFailureStage.SetAudience
			local v34

			if v33 then
				local publishResult = data.publishResult

				if
					typeof(publishResult) == "table"
					and publishResult.status == "success"
					and typeof(publishResult.version) == "string"
				then
					v34 = publishResult.version ~= ""
				else
					v34 = false
				end
			else
				v34 = v33
			end

			local v35 = v32 and data.responseCode == 16
			local v36 = if v34 then publishAudienceError else publishError

			if v35 then
				v36 = accountTooNewError
			end

			if v34 then
				GetVersionInformationStore().clearDraft(placeId)
				v10.fetchHistory(placeId)

				if FFlagBuildExperiencePlaytestCardPublishCta then
					v10.fetchLiveVersion(placeId)
				end
			end

			local log = Debug.log
			local v40 = if v32 and data.errorMessage ~= nil then tostring(data.errorMessage) else tostring(data)
			local v39 = {
				errorMessage = v40,
				placeId = placeId,
				responseCode = 0,
				stage = 0,
				universeId = 0
			}

			local v41 = if v32 then data.responseCode else nil
			v39.responseCode = v41

			local v42 = if v33 then GameConfigurationActions.PublishFailureStage.SetAudience else v29
			v39.stage = v42

			v39.universeId = props.target.universeId
			log("warn", "build_experience publish failed", v39)

			setState2(v36)
		end):finally(function()
			setState(false)
		end)
	end

	local v29 = React.useCallback(fn, {
		if FFlagBuildAdUpsell then audience else nil,
		v22,
		state,
		v10,
		props.target.placeId,
		props.target.sessionId,
		props.target.universeId,
		v16,
		v11,
		v14,
		accountTooNewError,
		publishAudienceError,
		publishError,
		publishSuccess
	})

	local formatted = `{props.testId}.actions`

	local v30 = if FFlagBuildCheckGamePermissions then useGamePermissions({
		universeId = props.target.universeId,
		isNewGame = props.target.isNewGameTarget
	}) else nil

	local v31 = not FFlagBuildCheckGamePermissions or v30.canPublish

	local ref = if FFlagBuildPostPublishShareDismissible then React.useRef(nil) else nil

	local v32 = if FFlagBuildPostPublishShareDismissible then Foundation.Hooks.useTokens() else nil
	local v33

	if FFlagBuildPostPublishShareDismissible then
		v33 = useClosableFocusRoot({
			surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
			isOpen = state2 ~= "",
			onClose = v22
		})
	end

	local v34 = if FFlagBuildPostPublishShareDismissible then Responsive.usePreferredInput() == Responsive.Input.Directional else nil

	local createElement = React.createElement

	if not FFlagBuildPostPublishShareDismissible then
		v33 = nil
	end

	local v36 = {
		LayoutOrder = 1,
		ref = v33,
		title = state2,
		action = v21 and { text = share, onActivated = v24 } or nil,
		onClose = 0,
		testId = 0
	}
	local v37

	if FFlagBuildPostPublishShareDismissible then
		if not v34 then
			v37 = v22
		end
	elseif not v21 then
		v37 = v22
	end

	v36.onClose = v37

	v36.testId = `{props.testId}.publish-snackbar`
	local element = createElement(snackbar, v36)

	local createElement2 = React.createElement

	local v41 = if FFlagBuildPostPublishShareDismissible then React.createElement(popover.Root, {
		isOpen = state2 ~= "",
		testId = `{props.testId}.publish-snackbar-popover`
	}, {
		Anchor = React.createElement(popover.Anchor, { anchorRef = ref }),
		Content = React.createElement(popover.Content, {
			align = popoverAlign.Center,
			backgroundStyle = v32.Color.None,
			hasArrow = false,
			selectionGroup = false,
			side = popoverSide.Top
		}, { Snackbar = element })
	}) else nil

	local v42 = if not FFlagBuildPostPublishShareDismissible and state2 ~= "" then React.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-large"
		},
		{ PublishSnackbar = element }
	) else nil

	local createElement3 = React.createElement

	if not FFlagBuildPostPublishShareDismissible then
		ref = nil
	end

	local createElement4 = React.createElement

	if v19 then
		v8 = updateRating
	end

	local v47 = {
		text = v8,
		size = inputSize.Medium,
		variant = buttonVariant.Emphasis,
		fillBehavior = fillBehavior.Fill,
		isDisabled = props.target.placeId == nil or not v31,
		isLoading = state,
		onActivated = 0,
		width = 0,
		LayoutOrder = 1,
		testId = 0
	}

	if not v19 then
		v26 = v29
	end

	v47.onActivated = v26
	v47.width = UDim.new(1, 0)

	v47.testId = `{formatted}-publish`
	local v45 = { Publish = createElement4(button, v47), Preview = 0 }

	local v48 = if props.showPreviewButton ~= false then React.createElement(PreviewButton, {
		target = props.target,
		actionsTestId = formatted,
		onPreview = props.onPreview
	}) else nil
	v45.Preview = v48
	local v40 = {
		PublishSnackbar = v41,
		PublishSnackbarWrapper = v42,
		Actions = createElement3(
			view,
			{
				LayoutOrder = 2,
				ref = ref,
				tag = "row gap-small size-full-0 auto-y padding-y-medium",
				testId = formatted
			},
			v45
		),
		FriendsOnlyShareDialog = 0
	}

	local v49 = if state3 == "friends" and audience == privacyType.FriendsOnly then React.createElement(module17, {
		onCancel = v25,
		onShare = v23
	}) else nil
	v40.FriendsOnlyShareDialog = v49
	return createElement2(view, {
		LayoutOrder = 3,
		tag = {
			["col gap-small size-full-0 auto-y"] = true,
			["bg-surface-0"] = not FFlagBuildPublishNavigationSheet
		}
	}, v40)
end

return PublishFooter
