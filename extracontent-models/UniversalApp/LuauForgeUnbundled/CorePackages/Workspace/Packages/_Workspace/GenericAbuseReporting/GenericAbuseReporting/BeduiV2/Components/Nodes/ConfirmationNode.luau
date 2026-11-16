local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local toggle = Foundation.Toggle
local view = Foundation.View

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Eyebrow")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation
local useOpenLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useOpenLink")
local userBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Api/userBlock")

local blockUser = userBlock.blockUser
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local isBlockedUser = userBlock.isBlockedUser
local telemetryEventType = analyticsService.TelemetryEventType
local unblockUser = userBlock.unblockUser
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")
local FFlagAbuseReportOptimisticBlockToggle = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportOptimisticBlockToggle")
local fFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes

local function useBlockToggle(blockToggle)
	local state, setState = React.useState(blockToggle and "Loading" or "Hidden")
	local state2, setState2 = React.useState(false)
	local state3, setState3

	if FFlagAbuseReportOptimisticBlockToggle then
		state3, setState3 = React.useState(false)
	else
		state3 = nil
		setState3 = nil
	end

	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v5 = useRoactService(roactNetworking)

	React.useEffect(function()
		if blockToggle and blockToggle.userId then
			isBlockedUser(v5, blockToggle.userId):andThen(function(p2)
				setState(p2.responseBody and "Hidden" or "Visible")
			end):catch(function(p2)
				setState("Hidden")
				local v7 = {
					sub_event_type = telemetryEventType.Error,
					error_detail = 0
				}

				local v8 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("isBlockedUser failed", p2, {
					includeResponseBody = true
				}) else {
					error_message = "isBlockedUser: " .. Dash.pretty(p2, {
						depth = 10
					})
				}
				v7.error_detail = v8
				sendEvent(v7)
			end)
			sendEvent({ sub_event_type = telemetryEventType.IsUserBlockAvailable })
		else
			setState("Hidden")
		end
	end, { blockToggle and blockToggle.userId, sendEvent, v5 })

	return {
		blockToggleState = state,
		handleBlockToggleChange = React.useCallback(function()
			if blockToggle == nil or blockToggle.userId == nil then
				return
			end

			if FFlagAbuseReportOptimisticBlockToggle then
				if state3 then
					return
				end

				if setState3 then
					setState3(true)
				end

				setState2(not state2)
			end

			local v6

			if state2 then
				v6 = unblockUser(v5, blockToggle.userId):andThen(function()
					setState2(false)
				end):catch(function(p2)
					if FFlagAbuseReportOptimisticBlockToggle then
						setState2(true)
					end

					setState("Error")
					local v8 = {
						sub_event_type = telemetryEventType.Error,
						error_detail = 0
					}

					local v9 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("unblockUser failed", p2, {
						includeResponseBody = true
					}) else {
						error_message = "unblockUser: " .. Dash.pretty(p2, {
							depth = 10
						})
					}
					v8.error_detail = v9
					sendEvent(v8)
				end)
				sendEvent({ sub_event_type = telemetryEventType.DidUnblockUser })
			else
				v6 = blockUser(v5, blockToggle.userId):andThen(function()
					if not FFlagAbuseReportOptimisticBlockToggle then
						sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
					end

					setState2(true)
				end):catch(function(p2)
					if FFlagAbuseReportOptimisticBlockToggle then
						setState2(false)
					end

					setState("Error")
					local v8 = {
						sub_event_type = telemetryEventType.Error,
						error_detail = 0
					}

					local v9 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("blockUser failed", p2, {
						includeResponseBody = true
					}) else {
						error_message = "blockUser: " .. Dash.pretty(p2, {
							depth = 10
						})
					}
					v8.error_detail = v9
					sendEvent(v8)
				end)

				if FFlagAbuseReportOptimisticBlockToggle then
					sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
				end
			end

			if FFlagAbuseReportOptimisticBlockToggle then
				v6:finally(function()
					if setState3 then
						setState3(false)
					end
				end)
			end
		end, {
			sendEvent,
			v5,
			blockToggle and blockToggle.userId,
			state2,
			state3
		}),
		isBlocked = state2,
		isBlockRequestInFlight = state3
	}
end

local function ConfirmationNode(props)
	local translateIntoString = useArTranslation().translateIntoString
	local v5 = useOpenLink()
	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v6 = useBlockToggle(props.blockToggle)
	local blockToggleState = v6.blockToggleState
	local handleBlockToggleChange = v6.handleBlockToggleChange
	local isBlocked = v6.isBlocked
	local isBlockRequestInFlight = v6.isBlockRequestInFlight

	local v7 = useLayoutSlots()
	local title = v7.Title
	local layout = v7.Layout

	React.useEffect(function()
		if props.helpline and props.helpline.href then
			sendEvent({ sub_event_type = telemetryEventType.HelplineShown })
		end
	end, { props.helpline and props.helpline.href, sendEvent })

	local v8 = React.useCallback(function()
		if props.onNext then
			props.onNext()
		end
	end, { props.onNext })

	local v9 = React.useCallback(function()
		if props.helpline and props.helpline.href then
			v5(translateIntoString(props.helpline.heading or ""), props.helpline.href)
			sendEvent({ sub_event_type = telemetryEventType.HelplineOpened })
		end
	end, {
		props.helpline and props.helpline.href,
		v5,
		translateIntoString,
		props.helpline and props.helpline.heading,
		sendEvent
	})

	local v10 = {
		Eyebrow = React.createElement(module7, {
			eyebrow = props.eyebrow,
			layoutOrder = 0
		}),
		Title = React.createElement(title, {
			input = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1
		}),
		Message = React.createElement(TextWithTranslation, {
			input = props.message,
			tag = "size-full-0 auto-y text-body-small",
			layoutOrder = 2
		}),
		ToggleContainer = 0,
		Error = 0,
		InformationContainer = 0,
		Footer = 0
	}
	local v11

	if props.blockToggle and blockToggleState == "Visible" then
		local createElement = React.createElement

		local v14 = {
			TextContainer = React.createElement(
				view,
				{
					tag = "row flex-x-between gap-small size-full-0 auto-y",
					LayoutOrder = 1
				},
				{
					Label = React.createElement(TextWithTranslation, {
						input = props.blockToggle.label or "",
						tag = "auto-xy text-title-large content-emphasis",
						layoutOrder = 1
					}),
					Toggle = React.createElement(toggle, {
						isChecked = isBlocked,
						isDisabled = isBlockRequestInFlight,
						onActivated = handleBlockToggleChange,
						label = "",
						Selectable = false,
						LayoutOrder = 2,
						testId = "ConfirmationNode.BlockToggle"
					})
				}
			),
			Description = 0
		}

		local v15 = if props.blockToggle.description then React.createElement(TextWithTranslation, {
			input = props.blockToggle.description or "",
			tag = "auto-xy text-body-small text-wrap",
			layoutOrder = 2
		}) else nil
		v14.Description = v15
		v11 = createElement(
			view,
			{
				onActivated = handleBlockToggleChange,
				tag = "col gap-xsmall size-full-0 auto-y padding-large radius-medium bg-action-standard",
				LayoutOrder = 3,
				testId = "ConfirmationNode.BlockToggleContainer"
			},
			v14
		)
	end

	v10.ToggleContainer = v11

	local v12 = if blockToggleState == "Error" and props.blockToggle then React.createElement(TextWithTranslation, {
		input = props.blockToggle.errorLabel or "",
		tag = "align-x-left size-full-0 auto-y padding-bottom-medium text-body-small content-system-alert",
		layoutOrder = 3
	}) else nil
	v10.Error = v12
	local v13

	if props.helpline and props.helpline.heading and blockToggleState ~= "Loading" then
		local createElement = React.createElement

		local v16 = {
			InformationHeader = React.createElement(TextWithTranslation, {
				input = props.helpline.heading,
				tag = "auto-xy text-title-small content-emphasis",
				layoutOrder = 1
			}),
			ViewInformationButton = 0
		}

		local v17 = if props.helpline and props.helpline.href then React.createElement(button, {
			text = translateIntoString(props.helpline.buttonText),
			icon = "icons/navigation/externallink",
			variant = buttonVariant.Standard,
			width = UDim.new(1, 0),
			onActivated = v9,
			LayoutOrder = 2
		}) else nil
		v16.ViewInformationButton = v17
		v13 = createElement(view, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 4
		}, v16)
	end

	v10.InformationContainer = v13

	local v14 = if props.footerItems then React.createElement(module8, {
		footerItems = props.footerItems,
		additionalTag = "padding-top-medium",
		layoutOrder = 5
	}) else nil
	v10.Footer = v14
	local v15

	if props.onNext then
		local createElement = React.createElement
		local v17 = {
			text = translateIntoString(props.nextButtonText),
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local v18 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else false
		v17.isLoading = v18
		local v19 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else false
		v17.isDisabled = v19
		v17.onActivated = v8
		v15 = createElement(button, v17)
	end

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v10),
		actions = v15
	})
end

return React.memo(ConfirmationNode)
