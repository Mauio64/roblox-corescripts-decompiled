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

local FIntBuildPostPublishSnackbarAutoDismissSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildPostPublishSnackbarAutoDismissSeconds")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/FriendsOnlyShareDialog")
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
local FFlagBuildPublishNavigationSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPublishNavigationSheet")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildExperiencePlaytestCardPublishCta = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytestCardPublishCta")
local FFlagBuildExperienceActionOutcomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceActionOutcomeTelemetry")
local v5 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore") else nil
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local openGameDetails = GameDetail.OpenGameDetails

local Debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local ConfigurationActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/ConfigurationActionTelemetry")
local module32 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/sharePublishedExperience")
local sharePublishedExperience = module32.sharePublishedExperience
local useSharePublishedExperience = module32.useSharePublishedExperience
local action = ConfigurationActionTelemetry.Action
local context = ConfigurationActionTelemetry.Context
local failureReason = ConfigurationActionTelemetry.FailureReason
local stage = ConfigurationActionTelemetry.Stage

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

local function getPublishFailure(err, stage2)
	local v7 = if type(err) == "table" then err else nil

	if v7 == nil or v7.stage ~= GameConfigurationActions.PublishFailureStage.SetAudience then
		local v9 = if v7 == nil or v7.responseCode ~= 16 then failureReason.RequestFailed else failureReason.AccountTooNew
		return { reason = v9, stage = stage2, error = err }
	else
		local publishResult = v7.publishResult
		local v9

		if
			typeof(publishResult) == "table"
			and publishResult.status == "success"
			and typeof(publishResult.version) == "string"
		then
			v9 = publishResult.version ~= ""
		else
			v9 = false
		end

		local v10 = if v9 then failureReason.AudienceNotPublic else failureReason.RequestFailed
		local v8 = { reason = v10, stage = stage.SetAudience, error = 0 }

		if v7.cause ~= nil then
			err = v7.cause
		end

		v8.error = err
		return v8
	end
end

local function PreviewButton(props)
	local preview = useLocalization({ preview = LocalizationStrings.GAME_CONFIGURATION_PREVIEW }).preview
	local v7 = useStore()
	local v8 = useNavigation()

	local onPreview = props.onPreview
	local v9 = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			local v10 = { context = context.PublishFooter }
			sendBuildExperienceEvent("PREVIEW_CLICK", props.telemetryIds, v10)
		end

		local rootNavigation = getRootNavigation(v8)
		openGameDetails(tostring(props.target.universeId), getGameDetailsNavigation(rootNavigation), {
			source = "BuildExperiencePublish"
		})(v7)

		if onPreview then
			onPreview()
		end
	end, { v8, props.target.universeId, v7, onPreview, props.telemetryIds })

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
	local publish = v7.publish
	local publishAudienceError = v7.publishAudienceError
	local publishError = v7.publishError
	local publishSuccess = v7.publishSuccess
	local share = v7.share
	local v8 = v7.updateRating
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

	local v22

	if FFlagBuildExperienceActionOutcomeTelemetry then
		v22 = React.useMemo(function()
			return {
				universeId = props.target.universeId,
				placeId = props.target.placeId,
				conversationId = props.target.sessionId
			}
		end, { props.target.universeId, props.target.placeId, props.target.sessionId })
	else
		v22 = nil
	end

	local v23 = React.useCallback(function()
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

	local v24 = React.useCallback(function()
		if props.target.placeId == nil then
			return
		end

		setState3(nil)

		if fFlagEnableShareSheet then
			v9(props.target.placeId)
			return
		end

		local v25 = sharePublishedExperience(props.target.placeId)

		if v25 ~= nil and v25.copiedToClipboard and linkCopied ~= nil then
			setState2(linkCopied)
		end
	end, { linkCopied, props.target.placeId, v9 })

	local v25 = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			ConfigurationActionTelemetry.sendClick(action.Share, v22, context.PublishSnackbar, {
				audience = tostring(audience)
			})
		end

		setState2("")

		if audience == privacyType.FriendsOnly then
			setState3("friends")
		elseif audience == privacyType.Public then
			v24()
		end
	end, { audience, v24, v22 })

	local v26 = React.useCallback(function()
		setState3(nil)
	end, {})

	local v27 = React.useCallback(function()
		if FFlagBuildExperienceActionOutcomeTelemetry then
			ConfigurationActionTelemetry.sendClick(action.UpdateRating, v22, context.PublishFooter)
		end

		v20(GameConfigurationActions.getExperienceQuestionnaireUrl(props.target.universeId), creatorHub, function()
			refreshPublishEligibility(props.target.universeId)
		end)
	end, { creatorHub, v20, props.target.universeId, v22 })

	local function fn()
		if state then
			return
		end

		local placeId = props.target.placeId

		if placeId == nil then
			return
		end

		local v28 = nil
		local v29 = nil
		local function selectVersionNotes(p2)
			local draft = GetVersionInformationStore().getDraft()
			local v30 = if p2 ~= nil then p2.placeVersions[1] else nil

			if draft == nil or draft.placeId ~= placeId then
				if v30 ~= nil then
					v28 = v30.title
					v29 = v30.description
				end
			else
				v28 = if draft.title ~= "" then draft.title else nil
				v29 = if draft.description ~= "" then draft.description else nil
			end
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = props.target.universeId,
			placeId = placeId,
			conversationId = props.target.sessionId
		})

		setState(true)
		v23()
		local v30 = stage.SaveAndPublish
		local v31 = false
		local function recordSuccessfulPublish(p2)
			local v32

			if typeof(p2) == "table" and p2.status == "success" and typeof(p2.version) == "string" then
				v32 = p2.version ~= ""
			else
				v32 = false
			end

			if not v32 then
				return
			end

			v5(false).reportMenuPublish(props.target.universeId, props.target.sessionId, p2.version, v31)
		end
		local function publish2(p2)
			v30 = stage.SaveAndPublish
			local v32 = p2 or v14

			if FFlagBuildAdUpsell then
				v31 = true
			end

			local publishExperience = GameConfigurationActions.publishExperience
			local v33 = {
				universeId = props.target.universeId,
				placeId = placeId,
				title = v28,
				description = v29,
				isActive = v32 ~= nil and v32.isActive == true,
				audiences = 0
			}
			local v36 = if v32 then v32.audiences else nil
			v33.audiences = buildPublicAudiences(v36)
			return publishExperience(v33)
		end

		local function startPublish()
			if v16 == nil then
				return publish2()
			end

			v30 = stage.RefreshEligibility
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

				v30 = stage.RefreshSummary

				return v11.refreshSummary(props.target.universeId):andThen(function(p2)
					return publish2(p2)
				end)
			end)
		end

		local draft = GetVersionInformationStore().getDraft()
		local v32

		if draft == nil or draft.placeId ~= placeId then
			v32 = v10.fetchPageHistory(placeId):andThen(selectVersionNotes, function()
				local draft2 = GetVersionInformationStore().getDraft()

				if draft2 == nil or draft2.placeId ~= placeId then
					return
				end

				v28 = if draft2.title ~= "" then draft2.title else nil
				v29 = if draft2.description ~= "" then draft2.description else nil
			end):andThen(startPublish)
		else
			local draft2 = GetVersionInformationStore().getDraft()

			if draft2 ~= nil and draft2.placeId == placeId then
				v28 = if draft2.title ~= "" then draft2.title else nil
				v29 = if draft2.description ~= "" then draft2.description else nil
			end

			if v16 == nil then
				v32 = publish2()
			else
				v30 = stage.RefreshEligibility
				v32 = v16.refreshEligibility(props.target.universeId):andThen(function()
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

					v30 = stage.RefreshSummary

					return v11.refreshSummary(props.target.universeId):andThen(function(p2)
						return publish2(p2)
					end)
				end)
			end
		end

		v32:andThen(function(p2)
			if p2 == v6 then
				if FFlagBuildExperienceActionOutcomeTelemetry then
					ConfigurationActionTelemetry.sendFailure(action.Publish, v22, {
						reason = failureReason.RatingRequired,
						stage = v30,
						error = nil
					})
				end
			else
				local v33

				if typeof(p2) == "table" and p2.status == "success" and typeof(p2.version) == "string" then
					v33 = p2.version ~= ""
				else
					v33 = false
				end

				if not v33 then
					error({
						errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={tostring(p2.status)}, version={tostring(p2.version)}`
					})
				end

				if FFlagBuildExperienceActionOutcomeTelemetry then
					ConfigurationActionTelemetry.sendSuccess(action.Publish, v22, nil, {
						version = tostring(p2.version)
					})
				end

				if FFlagBuildAdUpsell then
					local v34

					if
						typeof(p2) == "table"
						and p2.status == "success"
						and typeof(p2.version) == "string"
					then
						v34 = p2.version ~= ""
					else
						v34 = false
					end

					if v34 then
						v5(false).reportMenuPublish(
							props.target.universeId,
							props.target.sessionId,
							p2.version,
							v31
						)
					end
				end

				GetVersionInformationStore().clearDraft(placeId)
				v10.fetchHistory(placeId)

				if FFlagBuildExperiencePlaytestCardPublishCta then
					v10.fetchLiveVersion(placeId)
				end

				setState2(publishSuccess)
			end
		end):catch(function(data)
			local v33 = typeof(data) == "table"

			local v34 = v33 and data.stage == GameConfigurationActions.PublishFailureStage.SetAudience

			if v34 then
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
			end

			local v35 = v33 and data.responseCode == 16
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

			local publishFailure = getPublishFailure(data, v30)
			local log = Debug.log
			local v40 = if v33 and data.errorMessage ~= nil then tostring(data.errorMessage) else tostring(data)
			local v39 = {
				errorMessage = v40,
				placeId = placeId,
				responseCode = 0,
				stage = 0,
				universeId = 0
			}

			local v41 = if v33 then data.responseCode else nil
			v39.responseCode = v41
			v39.stage = publishFailure.stage
			v39.universeId = props.target.universeId
			log("warn", "build_experience publish failed", v39)

			if FFlagBuildExperienceActionOutcomeTelemetry then
				ConfigurationActionTelemetry.sendFailure(action.Publish, v22, publishFailure)
			end

			setState2(v36)
		end):finally(function()
			setState(false)
		end)
	end

	local v30 = React.useCallback(fn, {
		if FFlagBuildAdUpsell then audience else nil,
		v23,
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
		publishSuccess,
		v22
	})

	local formatted = `{props.testId}.actions`

	local v31 = if FFlagBuildCheckGamePermissions then useGamePermissions({
		universeId = props.target.universeId,
		isNewGame = props.target.isNewGameTarget
	}) else nil

	local v32 = not FFlagBuildCheckGamePermissions or v31.canPublish
	local ref = React.useRef(nil)
	local v33 = Foundation.Hooks.useTokens()
	local v34 = useClosableFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = state2 ~= "",
		onClose = v23
	})

	local v35 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local element = React.createElement(snackbar, {
		LayoutOrder = 1,
		ref = v34,
		title = state2,
		action = v21 and { text = share, onActivated = v25 } or nil,
		onClose = if not v35 then v23 else nil,
		testId = `{props.testId}.publish-snackbar`
	})

	local createElement2 = React.createElement

	local v41 = {
		PublishSnackbar = React.createElement(popover.Root, {
			isOpen = state2 ~= "",
			testId = `{props.testId}.publish-snackbar-popover`
		}, {
			Anchor = React.createElement(popover.Anchor, { anchorRef = ref }),
			Content = React.createElement(popover.Content, {
				align = popoverAlign.Center,
				backgroundStyle = v33.Color.None,
				hasArrow = false,
				selectionGroup = false,
				side = popoverSide.Top
			}, { Snackbar = element })
		}),
		Actions = 0,
		FriendsOnlyShareDialog = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	if not v19 then
		v8 = publish
	end

	local v46 = {
		text = v8,
		size = inputSize.Medium,
		variant = buttonVariant.Emphasis,
		fillBehavior = fillBehavior.Fill,
		isDisabled = props.target.placeId == nil or not v32,
		isLoading = state,
		onActivated = 0,
		width = 0,
		LayoutOrder = 1,
		testId = 0
	}

	if not v19 then
		v27 = v30
	end

	v46.onActivated = v27
	v46.width = UDim.new(1, 0)

	v46.testId = `{formatted}-publish`
	local v44 = { Publish = createElement4(button, v46), Preview = 0 }

	local v47 = if props.showPreviewButton ~= false then React.createElement(PreviewButton, {
		target = props.target,
		actionsTestId = formatted,
		onPreview = props.onPreview,
		telemetryIds = v22
	}) else nil
	v44.Preview = v47
	v41.Actions = createElement3(
		view,
		{
			LayoutOrder = 2,
			ref = ref,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = formatted
		},
		v44
	)

	local v48 = if state3 == "friends" and audience == privacyType.FriendsOnly then React.createElement(module16, {
		onCancel = v26,
		onShare = v24
	}) else nil
	v41.FriendsOnlyShareDialog = v48
	return createElement2(view, {
		LayoutOrder = 3,
		tag = {
			["col gap-small size-full-0 auto-y"] = true,
			["bg-surface-0"] = not FFlagBuildPublishNavigationSheet
		}
	}, v41)
end

return PublishFooter
