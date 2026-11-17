local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local GameDetail = require(parent.GameDetail)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local ExperienceGuidelines = require(parent.DataHydration.ExperienceGuidelines)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FIntBuildPostPublishSnackbarAutoDismissSeconds = require(BuildExperience.Flags.FIntBuildPostPublishSnackbarAutoDismissSeconds)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local getGameDetailsNavigation = require(BuildExperience.utils.getGameDetailsNavigation)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local useClosableFocusRoot = require(BuildExperience.utils.useClosableFocusRoot)
local GetVersionInformationStore = require(BuildExperience.Stores.GetVersionInformationStore)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local Button = Foundation.Button
local Popover = Foundation.Popover
local Snackbar = Foundation.Snackbar
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local PrivacyType = UniverseConfiguration.PrivacyType

local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local FFlagBuildPublishNavigationSheet = require(BuildExperience.Flags.FFlagBuildPublishNavigationSheet)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildExperiencePlaytestCardPublishCta = require(BuildExperience.Flags.FFlagBuildExperiencePlaytestCardPublishCta)
local FFlagBuildExperienceActionOutcomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceActionOutcomeTelemetry)
local GetAdUpsellEventStore

if FFlagBuildAdUpsell then
	GetAdUpsellEventStore = require(BuildExperience.Stores.GetAdUpsellEventStore)
else
	GetAdUpsellEventStore = nil
end

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local OpenGameDetails = GameDetail.OpenGameDetails

local Debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local ConfigurationActionTelemetry = require(BuildExperience.Telemetry.ConfigurationActionTelemetry)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience)
local sharePublishedExperience2 = sharePublishedExperience.sharePublishedExperience
local useSharePublishedExperience = sharePublishedExperience.useSharePublishedExperience
local Action = ConfigurationActionTelemetry.Action
local Context = ConfigurationActionTelemetry.Context
local FailureReason = ConfigurationActionTelemetry.FailureReason
local Stage = ConfigurationActionTelemetry.Stage

local v = {}

local function isPublishedVersion(p): boolean -- 4 equivalent calls inferred from this helper
	if typeof(p) ~= "table" then
		return false
	end

	return p.status == "success" and typeof(p.version) == "string" and p.version ~= ""
end

local function buildPublicAudiences(options)
	local publicAudiences = {}

	for _, v2 in options or {} do
		if v2 ~= UniverseActivation.Audience.Public and v2 ~= UniverseActivation.Audience.Friends then
			table.insert(publicAudiences, v2)
		end
	end

	table.insert(publicAudiences, UniverseActivation.Audience.Public)
	return publicAudiences
end

local function getPublishFailure(err, stage)
	local v2

	if type(err) == "table" then
		v2 = err
	end

	if v2 == nil or v2.stage ~= GameConfigurationActions.PublishFailureStage.SetAudience then
		local reason

		if v2 == nil or v2.responseCode ~= 16 then
			reason = FailureReason.RequestFailed
		else
			reason = FailureReason.AccountTooNew
		end

		return { reason = reason, stage = stage, error = err }
	else
		local publishedVersion = isPublishedVersion(v2.publishResult) -- inferred equivalent call
		local reason

		if publishedVersion then
			reason = FailureReason.AudienceNotPublic
		else
			reason = FailureReason.RequestFailed
		end

		local v3 = { reason = reason, stage = Stage.SetAudience, error = 0 }

		if v2.cause ~= nil then
			err = v2.cause
		end

		v3.error = err
		return v3
	end
end

local function PreviewButton(props)
	local preview = useLocalization({ preview = LocalizationStrings.GAME_CONFIGURATION_PREVIEW }).preview
	local v2 = useStore()
	local v3 = useNavigation()

	local onPreview = props.onPreview
	local onActivated = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			local v4 = { context = Context.PublishFooter }
			sendBuildExperienceEvent("PREVIEW_CLICK", props.telemetryIds, v4)
		end

		local rootNavigation = getRootNavigation(v3)
		OpenGameDetails(tostring(props.target.universeId), getGameDetailsNavigation(rootNavigation), {
			source = "BuildExperiencePublish"
		})(v2)

		if onPreview then
			onPreview()
		end
	end, { v3, props.target.universeId, v2, onPreview, props.telemetryIds })

	return React.createElement(Button, {
		text = preview,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = onActivated,
		width = UDim.new(1, 0),
		LayoutOrder = 2,
		testId = `{props.actionsTestId}-preview`
	})
end

local function PublishFooter(props)
	local v2 = useLocalization({
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

	local accountTooNewError = v2.accountTooNewError
	local creatorHub = v2.creatorHub
	local linkCopied = v2.linkCopied
	local publish = v2.publish
	local publishAudienceError = v2.publishAudienceError
	local publishError = v2.publishError
	local publishSuccess = v2.publishSuccess
	local share = v2.share
	local text = v2.updateRating
	local v3 = useSharePublishedExperience(props.target.universeId)
	local v4 = SignalsReact.useSignalState(PlaceVersionHistory.getPlaceVersionHistoryStore)
	local v5 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)

	local v6 = SignalsReact.useSignalState(v5.getAndFetchConfiguration(props.target.universeId).data)
	local v7 = React.useMemo(function()
		return v5.getAndFetchSummary(props.target.universeId).data
	end, { v5, props.target.universeId })
	local v8 = SignalsReact.useSignalState(v7)
	local audience = GameConfigurationLabels.getAudience(v6)

	local v9 = SignalsReact.useSignalState(UniverseActivation.getUniverseActivationStore)
	local v10 = v9
	local v11 = React.useMemo(function()
		return v9.getAndFetchEligibility(props.target.universeId)
	end, { v9, props.target.universeId })
	local v12 = SignalsReact.useSignalState(v11.data)
	local v13 = React.useMemo(function()
		return ContentMaturityUtils.isSealBroken(props.target.universeId)
			and ContentMaturityUtils.isContentUnrated(props.target.universeId)
	end, { v12, props.target.universeId })
	local v14 = useOpenWebView()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(nil)
	local v15

	if state2 == publishSuccess and props.target.placeId ~= nil and audience ~= nil then
		v15 = audience ~= PrivacyType.Private
	else
		v15 = false
	end

	local telemetryIds

	if FFlagBuildExperienceActionOutcomeTelemetry then
		telemetryIds = React.useMemo(function()
			return {
				universeId = props.target.universeId,
				placeId = props.target.placeId,
				conversationId = props.target.sessionId
			}
		end, { props.target.universeId, props.target.placeId, props.target.sessionId })
	else
		telemetryIds = nil
	end

	local onClose = React.useCallback(function()
		setState2("")
		setState3(nil)
	end, {})
	React.useEffect(function()
		if state2 == "" then
			return nil
		end

		local thread = task.delay(FIntBuildPostPublishSnackbarAutoDismissSeconds, setState2, "")
		return function()
			task.cancel(thread)
		end
	end, { state2 })

	local onShare = React.useCallback(function()
		if props.target.placeId == nil then
			return
		end

		setState3(nil)

		if FFlagEnableShareSheet then
			v3(props.target.placeId)
			return
		end

		local v16 = sharePublishedExperience2(props.target.placeId)

		if v16 ~= nil and v16.copiedToClipboard and linkCopied ~= nil then
			setState2(linkCopied)
		end
	end, { linkCopied, props.target.placeId, v3 })

	local onActivated = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			ConfigurationActionTelemetry.sendClick(Action.Share, telemetryIds, Context.PublishSnackbar, {
				audience = tostring(audience)
			})
		end

		setState2("")

		if audience == PrivacyType.FriendsOnly then
			setState3("friends")
		elseif audience == PrivacyType.Public then
			onShare()
		end
	end, { audience, onShare, telemetryIds })

	local onCancel = React.useCallback(function()
		setState3(nil)
	end, {})

	local onActivated2 = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			ConfigurationActionTelemetry.sendClick(Action.UpdateRating, telemetryIds, Context.PublishFooter)
		end

		v14(GameConfigurationActions.getExperienceQuestionnaireUrl(props.target.universeId), creatorHub, function()
			refreshPublishEligibility(props.target.universeId)
		end)
	end, { creatorHub, v14, props.target.universeId, telemetryIds })

	local useCallback = React.useCallback
	local function fn()
		if state then
			return
		end

		local placeId = props.target.placeId

		if placeId == nil then
			return
		end

		local title = nil
		local description = nil
		local function selectVersionNotes(p)
			local draft = GetVersionInformationStore().getDraft()
			local v16

			if p ~= nil then
				v16 = p.placeVersions[1]
			end

			if draft == nil or draft.placeId ~= placeId then
				if v16 ~= nil then
					title = v16.title
					description = v16.description
				end
			else
				local v17

				if draft.title ~= "" then
					v17 = draft.title
				end

				title = v17
				local v18

				if draft.description ~= "" then
					v18 = draft.description
				end

				description = v18
			end
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = props.target.universeId,
			placeId = placeId,
			conversationId = props.target.sessionId
		})

		setState(true)
		onClose()
		local stage = Stage.SaveAndPublish
		local v16 = false
		local function recordSuccessfulPublish(p) -- 1 equivalent call inferred from this helper
			if not isPublishedVersion(p) then -- inferred equivalent call
				return
			end

			GetAdUpsellEventStore(false).reportMenuPublish(
				props.target.universeId,
				props.target.sessionId,
				p.version,
				v16
			)
		end
		local function publish2(p)
			stage = Stage.SaveAndPublish
			local v17 = p or v8

			if FFlagBuildAdUpsell then
				v16 = true
			end

			local publishExperience = GameConfigurationActions.publishExperience
			local v18 = {
				universeId = props.target.universeId,
				placeId = placeId,
				title = title,
				description = description,
				isActive = v17 ~= nil and v17.isActive == true,
				audiences = 0
			}
			local v19

			if v17 then
				v19 = v17.audiences
			end

			v18.audiences = buildPublicAudiences(v19)
			return publishExperience(v18)
		end

		local function startPublish() -- 1 equivalent call inferred from this helper
			if v10 == nil then
				return publish2()
			end

			stage = Stage.RefreshEligibility
			return v10.refreshEligibility(props.target.universeId):andThen(function()
				if
					ContentMaturityUtils.isSealBroken(props.target.universeId)
					and ContentMaturityUtils.isContentUnrated(props.target.universeId)
				then
					return ExperienceGuidelines.getExperienceGuidelinesStore().refreshDetailedGuidelines(props.target.universeId):andThen(
						function()
							return v
						end,
						function(p)
							Debug.log("warn", "build_experience content maturity refresh failed", {
								errorMessage = tostring(p),
								universeId = props.target.universeId
							})

							return v
						end
					)
				end

				stage = Stage.RefreshSummary

				return v5.refreshSummary(props.target.universeId):andThen(function(p)
					return publish2(p)
				end)
			end)
		end

		local draft = GetVersionInformationStore().getDraft()
		local v17

		if draft == nil or draft.placeId ~= placeId then
			v17 = v4.fetchPageHistory(placeId):andThen(selectVersionNotes, function()
				local draft2 = GetVersionInformationStore().getDraft()

				if draft2 == nil or draft2.placeId ~= placeId then
					return
				end

				local v18

				if draft2.title ~= "" then
					v18 = draft2.title
				end

				title = v18
				local v19

				if draft2.description ~= "" then
					v19 = draft2.description
				end

				description = v19
			end):andThen(startPublish)
		else
			local draft2 = GetVersionInformationStore().getDraft()

			if draft2 ~= nil and draft2.placeId == placeId then
				title = if draft2.title ~= "" then draft2.title else nil

				if draft2.description == "" then
					description = nil
				else
					description = draft2.description
				end
			end

			v17 = startPublish() -- inferred equivalent call
		end

		v17:andThen(function(p)
			if p == v then
				if FFlagBuildExperienceActionOutcomeTelemetry then
					ConfigurationActionTelemetry.sendFailure(Action.Publish, telemetryIds, {
						reason = FailureReason.RatingRequired,
						stage = stage,
						error = nil
					})
				end
			else
				if not isPublishedVersion(p) then -- inferred equivalent call
					error({
						errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={tostring(p.status)}, version={tostring(p.version)}`
					})
				end

				if FFlagBuildExperienceActionOutcomeTelemetry then
					ConfigurationActionTelemetry.sendSuccess(Action.Publish, telemetryIds, nil, {
						version = tostring(p.version)
					})
				end

				if FFlagBuildAdUpsell then
					recordSuccessfulPublish(p) -- inferred equivalent call
				end

				GetVersionInformationStore().clearDraft(placeId)
				v4.fetchHistory(placeId)

				if FFlagBuildExperiencePlaytestCardPublishCta then
					v4.fetchLiveVersion(placeId)
				end

				setState2(publishSuccess)
			end
		end):catch(function(data)
			local v18 = typeof(data) == "table"

			local v19 = v18
				and data.stage == GameConfigurationActions.PublishFailureStage.SetAudience
				and isPublishedVersion(data.publishResult) -- inferred equivalent call

			local v20 = v18 and data.responseCode == 16
			local v21

			if v19 then
				v21 = publishAudienceError
			else
				v21 = publishError
			end

			if v20 then
				v21 = accountTooNewError
			end

			if v19 then
				GetVersionInformationStore().clearDraft(placeId)
				v4.fetchHistory(placeId)

				if FFlagBuildExperiencePlaytestCardPublishCta then
					v4.fetchLiveVersion(placeId)
				end
			end

			local publishFailure = getPublishFailure(data, stage)
			local log = Debug.log
			local errorMessage

			if v18 and data.errorMessage ~= nil then
				errorMessage = tostring(data.errorMessage)
			else
				errorMessage = tostring(data)
			end

			local v22 = {
				errorMessage = errorMessage,
				placeId = placeId,
				responseCode = 0,
				stage = 0,
				universeId = 0
			}
			local responseCode

			if v18 then
				responseCode = data.responseCode
			end

			v22.responseCode = responseCode
			v22.stage = publishFailure.stage
			v22.universeId = props.target.universeId
			log("warn", "build_experience publish failed", v22)

			if FFlagBuildExperienceActionOutcomeTelemetry then
				ConfigurationActionTelemetry.sendFailure(Action.Publish, telemetryIds, publishFailure)
			end

			setState2(v21)
		end):finally(function()
			setState(false)
		end)
	end

	local v16

	if FFlagBuildAdUpsell then
		v16 = audience
	end

	local v17 = useCallback(fn, {
		v16,
		onClose,
		state,
		v4,
		props.target.placeId,
		props.target.sessionId,
		props.target.universeId,
		v10,
		v5,
		v8,
		accountTooNewError,
		publishAudienceError,
		publishError,
		publishSuccess,
		telemetryIds
	})

	local formatted = `{props.testId}.actions`
	local v18

	if FFlagBuildCheckGamePermissions then
		v18 = useGamePermissions({
			universeId = props.target.universeId,
			isNewGame = props.target.isNewGameTarget
		})
	end

	local v19 = not FFlagBuildCheckGamePermissions or v18.canPublish
	local ref = React.useRef(nil)
	local v20 = Foundation.Hooks.useTokens()
	local ref2 = useClosableFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = state2 ~= "",
		onClose = onClose
	})

	local v21 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local createElement = React.createElement
	local v22 = {
		LayoutOrder = 1,
		ref = ref2,
		title = state2,
		action = v15 and { text = share, onActivated = onActivated } or nil,
		onClose = 0,
		testId = 0
	}
	local onClose2

	if not v21 then
		onClose2 = onClose
	end

	v22.onClose = onClose2
	v22.testId = `{props.testId}.publish-snackbar`
	local element = createElement(Snackbar, v22)

	local createElement2 = React.createElement

	local v23 = {
		PublishSnackbar = React.createElement(Popover.Root, {
			isOpen = state2 ~= "",
			testId = `{props.testId}.publish-snackbar-popover`
		}, {
			Anchor = React.createElement(Popover.Anchor, { anchorRef = ref }),
			Content = React.createElement(Popover.Content, {
				align = PopoverAlign.Center,
				backgroundStyle = v20.Color.None,
				hasArrow = false,
				selectionGroup = false,
				side = PopoverSide.Top
			}, { Snackbar = element })
		}),
		Actions = 0,
		FriendsOnlyShareDialog = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	if not v13 then
		text = publish
	end

	local v24 = {
		text = text,
		size = InputSize.Medium,
		variant = ButtonVariant.Emphasis,
		fillBehavior = FillBehavior.Fill,
		isDisabled = props.target.placeId == nil or not v19,
		isLoading = state,
		onActivated = 0,
		width = 0,
		LayoutOrder = 1,
		testId = 0
	}

	if not v13 then
		onActivated2 = v17
	end

	v24.onActivated = onActivated2
	v24.width = UDim.new(1, 0)

	v24.testId = `{formatted}-publish`
	local v25 = { Publish = createElement4(Button, v24), Preview = 0 }
	local preview

	if props.showPreviewButton ~= false then
		preview = React.createElement(PreviewButton, {
			target = props.target,
			actionsTestId = formatted,
			onPreview = props.onPreview,
			telemetryIds = telemetryIds
		})
	end

	v25.Preview = preview
	v23.Actions = createElement3(
		View,
		{
			LayoutOrder = 2,
			ref = ref,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = formatted
		},
		v25
	)
	local friendsOnlyShareDialog

	if state3 == "friends" and audience == PrivacyType.FriendsOnly then
		friendsOnlyShareDialog = React.createElement(FriendsOnlyShareDialog, {
			onCancel = onCancel,
			onShare = onShare
		})
	end

	v23.FriendsOnlyShareDialog = friendsOnlyShareDialog
	return createElement2(View, {
		LayoutOrder = 3,
		tag = {
			["col gap-small size-full-0 auto-y"] = true,
			["bg-surface-0"] = not FFlagBuildPublishNavigationSheet
		}
	}, v23)
end

return PublishFooter
