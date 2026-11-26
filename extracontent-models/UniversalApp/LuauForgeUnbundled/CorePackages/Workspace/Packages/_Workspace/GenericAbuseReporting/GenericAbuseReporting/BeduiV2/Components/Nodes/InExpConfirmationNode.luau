local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local BlockingUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/BlockingUtility")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Loggers").flaggedMutedError
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation
local view = Foundation.View

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local arTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local TextLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/TextLink")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useInExpFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useInExpFocusNavigationRefs")
local useInExpOpenLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useInExpOpenLink")
local userBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Api/userBlock")
local userMute = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Api/userMute")
local voiceSpeakingSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/voiceSpeakingSignals")

local blockUser = userBlock.blockUser
local isBlockedUser = userBlock.isBlockedUser
local isUserMuted = userMute.isUserMuted
local muteUser = userMute.muteUser
local telemetryEventType = analyticsService.TelemetryEventType
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useArTranslation = arTranslation.useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local function computeInitialMuteState(p2): string
	if not (p2 and p2.userId) then
		return "Hidden"
	end

	local userId = tonumber(p2.userId) or 0

	if userId == 0 or isUserMuted(userId) then
		return "Hidden"
	end

	return "Visible"
end

local function useBlockMuteActions(blockToggle, muteToggle, onNext)
	local translateIntoString = useArTranslation().translateIntoString
	local v5 = React.useContext(voiceSpeakingSignals.VoiceChatServiceManagerContext)
	local state, setState = React.useState("Hidden")
	local state2, setState2 = React.useState(function(): string
		local v6 = muteToggle

		if not (v6 and v6.userId) then
			return "Hidden"
		end

		local userId = tonumber(v6.userId) or 0

		if userId == 0 or isUserMuted(userId) then
			return "Hidden"
		end

		return "Visible"
	end)

	local state3, setState3 = React.useState(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v6 = useRoactService(roactNetworking)

	local function fn()
		if blockToggle and blockToggle.userId then
			isBlockedUser(v6, blockToggle.userId):andThen(function(p2)
				setState(p2.responseBody and "Hidden" or "Visible")
				setState3(true)
			end):catch(function(p2)
				local v8 = {
					sub_event_type = telemetryEventType.Error,
					error_detail = 0
				}

				local v9 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("isBlockedUser failed", p2, {
					includeResponseBody = true
				}) else {
					error_message = "isBlockedUser: " .. Dash.pretty(p2, {
						depth = 10
					})
				}
				v8.error_detail = v9
				sendEvent(v8)

				setState3(true)
			end)
			sendEvent({ sub_event_type = telemetryEventType.IsUserBlockAvailable })
		end
	end

	React.useEffect(fn, { if blockToggle then blockToggle.userId else nil, v6, sendEvent })

	local ref = React.useRef(false)
	React.useEffect(function()
		if state2 == "Visible" and not ref.current then
			ref.current = true
			sendEvent({ sub_event_type = telemetryEventType.IsUserMuteAvailable })
		end
	end, { state2, sendEvent })

	local v9 = React.useCallback(function()
		if not (muteToggle and muteToggle.userId) then
			return
		end

		local userId = tonumber(muteToggle.userId)

		if userId and localPlayer then
			setState2("Loading")

			if muteUser(userId, localPlayer, v5) then
				sendEvent({ sub_event_type = telemetryEventType.DidMuteUser })
				onNext({ didBlockUser = false, didMuteUser = true })
			else
				local v11 = {
					sub_event_type = telemetryEventType.Error,
					error_detail = 0
				}

				local v12 = if FFlagAbuseReportImproveErrorEvents then {
					error_message = "muteUser failed",
					error_metadata = { target_user_id = tostring(userId) }
				} else {
					error_message = `muteUser failed for userId: {userId}`
				}
				v11.error_detail = v12
				sendEvent(v11)

				onNext({ didBlockUser = false, didMuteUser = false })
			end
		end
	end, { muteToggle, sendEvent, onNext, v5 })

	local v10 = React.useCallback(function(p2)
		if not p2 or p2 == 0 then
			sendEvent({
				sub_event_type = telemetryEventType.Error,
				error_detail = { error_message = "AddPlayerToBlockList invalid userId" }
			})

			return
		end

		local playerByUserId = Players:GetPlayerByUserId(p2)

		if playerByUserId and not BlockingUtility:AddPlayerToBlockList(playerByUserId) then
			local v12 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v13 = if FFlagAbuseReportImproveErrorEvents then {
				error_message = "AddPlayerToBlockList failed",
				error_metadata = { target_user_id = tostring(p2) }
			} else {
				error_message = `AddPlayerToBlockList failed for userId: {p2}`
			}
			v12.error_detail = v13
			sendEvent(v12)
		end
	end, { sendEvent })

	local v11 = React.useCallback(function()
		if not (blockToggle and blockToggle.userId) then
			return
		end

		if FFlagAbuseReportImproveErrorEvents then
			setState("Loading")
			blockUser(v6, blockToggle.userId):andThen(function()
				setState("Hidden")
				local userId = tonumber(blockToggle.userId)

				if userId then
					local success, result = pcall(function(): nil
						v10(userId)
						return nil
					end)

					if not success then
						flaggedMutedError("AbuseReportInExpLocalBlockError", (tostring(result)))
					end
				end

				onNext({ didBlockUser = true, didMuteUser = false })
			end, function(p2)
				setState("Error")
				sendEvent({
					sub_event_type = telemetryEventType.Error,
					error_detail = formatErrorDetailForAnalytics("blockUser failed", p2, {
						includeResponseBody = true
					})
				})
			end)
			sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
		else
			setState("Loading")
			blockUser(v6, blockToggle.userId):andThen(function()
				sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
				local userId = tonumber(blockToggle.userId)

				if userId then
					v10(userId)
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
	end, { blockToggle, onNext, v10, v6, sendEvent })

	local v12 = blockToggle == nil or state3

	return {
		actions = React.useMemo(function()
			local v13 = {}

			if not v12 then
				return v13
			end

			if blockToggle and state ~= "Hidden" then
				table.insert(v13, {
					text = translateIntoString(blockToggle.label),
					variant = buttonVariant.Alert,
					onActivated = v11,
					isLoading = state == "Loading"
				})
			end

			if muteToggle and state2 ~= "Hidden" then
				table.insert(v13, {
					text = translateIntoString(muteToggle.label),
					variant = buttonVariant.Alert,
					onActivated = v9,
					isLoading = state2 == "Loading"
				})
			end

			return v13
		end, {
			blockToggle,
			muteToggle,
			v11,
			v9,
			translateIntoString,
			state,
			state2,
			v12
		}),
		blockState = state,
		muteState = state2,
		hasActions = blockToggle ~= nil or muteToggle ~= nil,
		hasLoadedActions = v12
	}
end

local function useDelayedTrue(duration)
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
	local v5 = useInExpOpenLink()

	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v6 = useBlockMuteActions(props.blockToggle, props.muteToggle, props.onNext)
	local actions = v6.actions
	local blockState = v6.blockState
	local muteState = v6.muteState
	local hasActions = v6.hasActions
	local hasLoadedActions = v6.hasLoadedActions

	local v7 = useDelayedTrue(0.6)
	local isStoryMode = props.isStoryMode or v7 or not hasActions or hasLoadedActions

	local layout = useLayoutSlots().Layout

	React.useEffect(function()
		if sendEvent and isStoryMode and props.helpline and props.helpline.href then
			sendEvent({ sub_event_type = telemetryEventType.HelplineShown })
		end
	end, { props.helpline and props.helpline.href, isStoryMode })

	local v8 = React.useCallback(function()
		if props.helpline and props.helpline.href then
			v5(props.helpline.href)

			if sendEvent then
				sendEvent({ sub_event_type = telemetryEventType.HelplineOpened })
			end
		end
	end, { props.helpline, v5 })

	local v9 = React.useCallback(function()
		props.onNext({ didBlockUser = false, didMuteUser = false })
	end, { props.onNext })

	local v10 = useInExpFocusNavigationRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, v9)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v12 = {
		Content = React.createElement(layout, { body = nil, actions = nil }),
		ConfirmationDialog = 0
	}
	local v13

	if isStoryMode then
		local createElement2 = React.createElement
		local root = dialog.Root
		local v14 = {
			ref = v10,
			size = dialogSize.Small,
			hasBackdrop = not props.isStoryMode,
			disablePortal = props.isStoryMode and true or false,
			onClose = v9
		}

		local children = {
			DialogTitle = React.createElement(dialog.Title, {
				text = translateIntoString(props.title)
			}),
			DialogContent = 0,
			DialogActions = 0
		}

		local createElement3 = React.createElement
		local content = dialog.Content

		local createElement4 = React.createElement

		local v19 = {
			Message = React.createElement(TextWithTranslation, {
				input = props.message,
				tag = "size-full-0 auto-y text-body-medium",
				layoutOrder = 2
			}),
			Helpline = props.helpline and React.createElement(
				view,
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
						onActivated = v8,
						layoutOrder = 2
					})
				}
			),
			ErrorMessage = 0,
			Footer = 0
		}
		local v20

		if blockState == "Error" or muteState == "Error" then
			local createElement5 = React.createElement
			local v23 = if blockState == "Error" and props.blockToggle then props.blockToggle.errorLabel else (muteState ~= "Error" or not props.muteToggle) and "" or props.muteToggle.errorLabel
			v20 = createElement5(TextWithTranslation, {
				input = v23,
				tag = "size-full-0 auto-y text-body-medium content-system-alert",
				layoutOrder = 4
			})
		end

		v19.ErrorMessage = v20

		v19.Footer = props.footerItems
			and React.createElement(module9, {
				footerItems = props.footerItems,
				additionalTag = "padding-top-medium",
				layoutOrder = 5
			})
		children.DialogContent = createElement3(content, { LayoutOrder = 2 }, {
			DialogContentView = createElement4(view, {
				tag = "col gap-small size-full-0 auto-y"
			}, v19)
		})

		children.DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 4,
			actions = actions,
			orientation = orientation.Vertical
		})
		v13 = createElement2(root, v14, children)
	end

	v12.ConfirmationDialog = v13
	return createElement(fragment, nil, v12)
end

return React.memo(InExpConfirmationNode)
