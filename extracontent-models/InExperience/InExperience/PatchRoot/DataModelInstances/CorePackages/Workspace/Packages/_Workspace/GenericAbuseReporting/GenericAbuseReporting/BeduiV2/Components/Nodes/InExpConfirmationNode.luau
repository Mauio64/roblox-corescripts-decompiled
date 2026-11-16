local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local BlockingUtility = require(parent.BlockingUtility)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppLoggers = require(parent.RobloxAppLoggers)
local flaggedMutedError = RobloxAppLoggers.flaggedMutedError
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation
local View = Foundation.View

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextLink = require(GenericAbuseReporting.BeduiV2.Components.TextLink)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local useInExpFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useInExpFocusNavigationRefs)
local useInExpOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useInExpOpenLink)
local userBlock = require(GenericAbuseReporting.BeduiV2.Api.userBlock)
local userMute = require(GenericAbuseReporting.BeduiV2.Api.userMute)
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)

local blockUser = userBlock.blockUser
local isBlockedUser = userBlock.isBlockedUser
local isUserMuted = userMute.isUserMuted
local muteUser = userMute.muteUser
local telemetryEventType = analyticsService.TelemetryEventType
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useArTranslation = arTranslation.useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local function computeInitialMuteState(p): string -- 1 equivalent call inferred from this helper
	if not (p and p.userId) then
		return "Hidden"
	end

	local userId = tonumber(p.userId) or 0

	if userId == 0 or isUserMuted(userId) then
		return "Hidden"
	end

	return "Visible"
end

local function useBlockMuteActions(blockToggle, muteToggle, onNext)
	local translateIntoString = useArTranslation().translateIntoString
	local v = React.useContext(voiceSpeakingSignals.VoiceChatServiceManagerContext)
	local state, setState = React.useState("Hidden")
	local state2, setState2 = React.useState(function()
		return computeInitialMuteState(muteToggle) -- inferred equivalent call
	end)

	local state3, setState3 = React.useState(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v2 = useRoactService(RoactNetworking)

	local useEffect = React.useEffect
	local function fn()
		if blockToggle and blockToggle.userId then
			isBlockedUser(v2, blockToggle.userId):andThen(function(p)
				setState(p.responseBody and "Hidden" or "Visible")
				setState3(true)
			end):catch(function(p)
				local v3 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
				local error_detail

				if FFlagAbuseReportImproveErrorEvents then
					error_detail = formatErrorDetailForAnalytics("isBlockedUser failed", p, {
						includeResponseBody = true
					})
				else
					error_detail = {
						error_message = "isBlockedUser: " .. Dash.pretty(p, { depth = 10 })
					}
				end

				v3.error_detail = error_detail
				sendEvent(v3)

				setState3(true)
			end)
			sendEvent({ sub_event_type = telemetryEventType.IsUserBlockAvailable })
		end
	end

	local v3

	if blockToggle then
		v3 = blockToggle.userId
	end

	useEffect(fn, { v3, v2, sendEvent })

	local ref = React.useRef(false)
	React.useEffect(function()
		if state2 == "Visible" and not ref.current then
			ref.current = true
			sendEvent({ sub_event_type = telemetryEventType.IsUserMuteAvailable })
		end
	end, { state2, sendEvent })

	local onActivated = React.useCallback(function()
		if not (muteToggle and muteToggle.userId) then
			return
		end

		local userId = tonumber(muteToggle.userId)

		if userId and LocalPlayer then
			setState2("Loading")

			if muteUser(userId, LocalPlayer, v) then
				sendEvent({ sub_event_type = telemetryEventType.DidMuteUser })
				onNext({ didBlockUser = false, didMuteUser = true })
			else
				local v4 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
				local error_detail

				if FFlagAbuseReportImproveErrorEvents then
					error_detail = {
						error_message = "muteUser failed",
						error_metadata = { target_user_id = tostring(userId) }
					}
				else
					error_detail = {
						error_message = `muteUser failed for userId: {userId}`
					}
				end

				v4.error_detail = error_detail
				sendEvent(v4)

				onNext({ didBlockUser = false, didMuteUser = false })
			end
		end
	end, { muteToggle, sendEvent, onNext, v })

	local v4 = React.useCallback(function(p: number)
		if not p or p == 0 then
			sendEvent({
				sub_event_type = telemetryEventType.Error,
				error_detail = { error_message = "AddPlayerToBlockList invalid userId" }
			})

			return
		end

		local playerByUserId = Players:GetPlayerByUserId(p)

		if playerByUserId and not BlockingUtility:AddPlayerToBlockList(playerByUserId) then
			local v4 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = {
					error_message = "AddPlayerToBlockList failed",
					error_metadata = { target_user_id = tostring(p) }
				}
			else
				error_detail = {
					error_message = `AddPlayerToBlockList failed for userId: {p}`
				}
			end

			v4.error_detail = error_detail
			sendEvent(v4)
		end
	end, { sendEvent })

	local onActivated2 = React.useCallback(function()
		if not (blockToggle and blockToggle.userId) then
			return
		end

		if FFlagAbuseReportImproveErrorEvents then
			setState("Loading")
			blockUser(v2, blockToggle.userId):andThen(function()
				setState("Hidden")
				local userId = tonumber(blockToggle.userId)

				if userId then
					local success, result = pcall(function(): nil
						v4(userId)
						return nil
					end)

					if not success then
						flaggedMutedError("AbuseReportInExpLocalBlockError", (tostring(result)))
					end
				end

				onNext({ didBlockUser = true, didMuteUser = false })
			end, function(p)
				setState("Error")
				sendEvent({
					sub_event_type = telemetryEventType.Error,
					error_detail = formatErrorDetailForAnalytics("blockUser failed", p, {
						includeResponseBody = true
					})
				})
			end)
			sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
		else
			setState("Loading")
			blockUser(v2, blockToggle.userId):andThen(function()
				sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
				local userId = tonumber(blockToggle.userId)

				if userId then
					v4(userId)
				end

				onNext({ didBlockUser = true, didMuteUser = false })
			end):catch(function()
				setState("Error")
				sendEvent({
					sub_event_type = telemetryEventType.Error,
					error_detail = {
						error_message = `blockUser failed for userId: {blockToggle.userId}`
					}
				})
			end)
		end
	end, { blockToggle, onNext, v4, v2, sendEvent })

	local hasLoadedActions = blockToggle == nil or state3

	return {
		actions = React.useMemo(function()
			local v5 = {}

			if not hasLoadedActions then
				return v5
			end

			if blockToggle and state ~= "Hidden" then
				table.insert(v5, {
					text = translateIntoString(blockToggle.label),
					variant = ButtonVariant.Alert,
					onActivated = onActivated2,
					isLoading = state == "Loading"
				})
			end

			if muteToggle and state2 ~= "Hidden" then
				table.insert(v5, {
					text = translateIntoString(muteToggle.label),
					variant = ButtonVariant.Alert,
					onActivated = onActivated,
					isLoading = state2 == "Loading"
				})
			end

			return v5
		end, {
			blockToggle,
			muteToggle,
			onActivated2,
			onActivated,
			translateIntoString,
			state,
			state2,
			hasLoadedActions
		}),
		blockState = state,
		muteState = state2,
		hasActions = blockToggle ~= nil or muteToggle ~= nil,
		hasLoadedActions = hasLoadedActions
	}
end

local function useDelayedTrue(duration: number)
	local state, setState = React.useState(false)
	React.useEffect(function()
		local thread = task.delay(duration, function()
			setState(true)
		end)
		return function()
			task.cancel(thread)
		end
	end, { duration })
	return state
end

local function InExpConfirmationNode(props)
	local translateIntoString = useArTranslation().translateIntoString
	local v = useInExpOpenLink()

	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v2 = useBlockMuteActions(props.blockToggle, props.muteToggle, props.onNext)
	local actions = v2.actions
	local blockState = v2.blockState
	local muteState = v2.muteState
	local hasActions = v2.hasActions
	local hasLoadedActions = v2.hasLoadedActions

	local v3 = useDelayedTrue(0.6)
	local isStoryMode = props.isStoryMode or v3 or not hasActions or hasLoadedActions

	local layout = useLayoutSlots().Layout

	React.useEffect(function()
		if sendEvent and isStoryMode and props.helpline and props.helpline.href then
			sendEvent({ sub_event_type = telemetryEventType.HelplineShown })
		end
	end, { props.helpline and props.helpline.href, isStoryMode })

	local onActivated = React.useCallback(function()
		if props.helpline and props.helpline.href then
			v(props.helpline.href)

			if sendEvent then
				sendEvent({ sub_event_type = telemetryEventType.HelplineOpened })
			end
		end
	end, { props.helpline, v })

	local onClose = React.useCallback(function()
		props.onNext({ didBlockUser = false, didMuteUser = false })
	end, { props.onNext })

	local ref = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, onClose)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v4 = {
		Content = React.createElement(layout, { body = nil, actions = nil }),
		ConfirmationDialog = 0
	}
	local confirmationDialog

	if isStoryMode then
		local createElement2 = React.createElement
		local root = Dialog.Root
		local v5 = {
			ref = ref,
			size = DialogSize.Small,
			hasBackdrop = not props.isStoryMode,
			disablePortal = props.isStoryMode and true or false,
			onClose = onClose
		}

		local children = {
			DialogTitle = React.createElement(Dialog.Title, {
				text = translateIntoString(props.title)
			}),
			DialogContent = 0,
			DialogActions = 0
		}

		local createElement3 = React.createElement
		local content = Dialog.Content

		local createElement4 = React.createElement

		local v6 = {
			Message = React.createElement(TextWithTranslation, {
				input = props.message,
				tag = "size-full-0 auto-y text-body-medium",
				layoutOrder = 2
			}),
			Helpline = props.helpline and React.createElement(
				View,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 3 },
				{
					Heading = React.createElement(TextWithTranslation, {
						input = props.helpline.heading,
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 1
					}),
					Link = React.createElement(TextLink, {
						text = translateIntoString(props.helpline.buttonText),
						tag = "auto-xy text-body-medium text-wrap text-align-x-left radius-small content-emphasis",
						onActivated = onActivated,
						layoutOrder = 2
					})
				}
			),
			ErrorMessage = 0,
			Footer = 0
		}
		local errorMessage

		if blockState == "Error" or muteState == "Error" then
			local createElement5 = React.createElement
			local input

			if blockState == "Error" and props.blockToggle then
				input = props.blockToggle.errorLabel
			else
				input = (muteState ~= "Error" or not props.muteToggle) and "" or props.muteToggle.errorLabel
			end

			errorMessage = createElement5(TextWithTranslation, {
				input = input,
				tag = "size-full-0 auto-y text-body-medium content-system-alert",
				layoutOrder = 4
			})
		end

		v6.ErrorMessage = errorMessage

		v6.Footer = props.footerItems
			and React.createElement(Footer, {
				footerItems = props.footerItems,
				additionalTag = "padding-top-medium",
				layoutOrder = 5
			})
		children.DialogContent = createElement3(content, { LayoutOrder = 2 }, {
			DialogContentView = createElement4(View, { tag = "col gap-small size-full-0 auto-y" }, v6)
		})

		children.DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = actions,
			orientation = Orientation.Vertical
		})
		confirmationDialog = createElement2(root, v5, children)
	end

	v4.ConfirmationDialog = confirmationDialog
	return createElement(fragment, nil, v4)
end

return React.memo(InExpConfirmationNode)
