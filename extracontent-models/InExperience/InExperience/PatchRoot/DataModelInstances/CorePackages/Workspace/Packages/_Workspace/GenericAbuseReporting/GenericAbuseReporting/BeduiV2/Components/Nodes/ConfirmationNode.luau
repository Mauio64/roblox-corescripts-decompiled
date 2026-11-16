local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local SharedFlags = require(parent.SharedFlags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Toggle = Foundation.Toggle
local View = Foundation.View

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)
local userBlock = require(GenericAbuseReporting.BeduiV2.Api.userBlock)

local blockUser = userBlock.blockUser
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local isBlockedUser = userBlock.isBlockedUser
local telemetryEventType = analyticsService.TelemetryEventType
local unblockUser = userBlock.unblockUser
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)
local FFlagAbuseReportOptimisticBlockToggle = require(GenericAbuseReporting.Flags.FFlagAbuseReportOptimisticBlockToggle)
local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes

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
	local v = useRoactService(RoactNetworking)

	React.useEffect(function()
		if blockToggle and blockToggle.userId then
			isBlockedUser(v, blockToggle.userId):andThen(function(p)
				setState(p.responseBody and "Hidden" or "Visible")
			end):catch(function(p)
				setState("Hidden")
				local v2 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
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

				v2.error_detail = error_detail
				sendEvent(v2)
			end)
			sendEvent({ sub_event_type = telemetryEventType.IsUserBlockAvailable })
		else
			setState("Hidden")
		end
	end, { blockToggle and blockToggle.userId, sendEvent, v })

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

			local v2

			if state2 then
				v2 = unblockUser(v, blockToggle.userId):andThen(function()
					setState2(false)
				end):catch(function(p)
					if FFlagAbuseReportOptimisticBlockToggle then
						setState2(true)
					end

					setState("Error")
					local v3 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
					local error_detail

					if FFlagAbuseReportImproveErrorEvents then
						error_detail = formatErrorDetailForAnalytics("unblockUser failed", p, {
							includeResponseBody = true
						})
					else
						error_detail = {
							error_message = "unblockUser: " .. Dash.pretty(p, { depth = 10 })
						}
					end

					v3.error_detail = error_detail
					sendEvent(v3)
				end)
				sendEvent({ sub_event_type = telemetryEventType.DidUnblockUser })
			else
				v2 = blockUser(v, blockToggle.userId):andThen(function()
					if not FFlagAbuseReportOptimisticBlockToggle then
						sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
					end

					setState2(true)
				end):catch(function(p)
					if FFlagAbuseReportOptimisticBlockToggle then
						setState2(false)
					end

					setState("Error")
					local v3 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
					local error_detail

					if FFlagAbuseReportImproveErrorEvents then
						error_detail = formatErrorDetailForAnalytics("blockUser failed", p, {
							includeResponseBody = true
						})
					else
						error_detail = {
							error_message = "blockUser: " .. Dash.pretty(p, { depth = 10 })
						}
					end

					v3.error_detail = error_detail
					sendEvent(v3)
				end)

				if FFlagAbuseReportOptimisticBlockToggle then
					sendEvent({ sub_event_type = telemetryEventType.DidBlockUser })
				end
			end

			if FFlagAbuseReportOptimisticBlockToggle then
				v2:finally(function()
					if setState3 then
						setState3(false)
					end
				end)
			end
		end, {
			sendEvent,
			v,
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
	local v = useOpenLink()
	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v2 = useBlockToggle(props.blockToggle)
	local blockToggleState = v2.blockToggleState
	local handleBlockToggleChange = v2.handleBlockToggleChange
	local isBlocked = v2.isBlocked
	local isBlockRequestInFlight = v2.isBlockRequestInFlight

	local v3 = useLayoutSlots()
	local title = v3.Title
	local layout = v3.Layout

	React.useEffect(function()
		if props.helpline and props.helpline.href then
			sendEvent({ sub_event_type = telemetryEventType.HelplineShown })
		end
	end, { props.helpline and props.helpline.href, sendEvent })

	local onActivated = React.useCallback(function()
		if props.onNext then
			props.onNext()
		end
	end, { props.onNext })

	local onActivated2 = React.useCallback(function()
		if props.helpline and props.helpline.href then
			v(translateIntoString(props.helpline.heading or ""), props.helpline.href)
			sendEvent({ sub_event_type = telemetryEventType.HelplineOpened })
		end
	end, {
		props.helpline and props.helpline.href,
		v,
		translateIntoString,
		props.helpline and props.helpline.heading,
		sendEvent
	})

	local v4 = {
		Eyebrow = React.createElement(Eyebrow, { eyebrow = props.eyebrow, layoutOrder = 0 }),
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
	local toggleContainer

	if props.blockToggle and blockToggleState == "Visible" then
		local createElement = React.createElement

		local v5 = {
			TextContainer = React.createElement(
				View,
				{ tag = "row flex-x-between gap-small size-full-0 auto-y", LayoutOrder = 1 },
				{
					Label = React.createElement(TextWithTranslation, {
						input = props.blockToggle.label or "",
						tag = "auto-xy text-title-large content-emphasis",
						layoutOrder = 1
					}),
					Toggle = React.createElement(Toggle, {
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
		local description

		if props.blockToggle.description then
			description = React.createElement(TextWithTranslation, {
				input = props.blockToggle.description or "",
				tag = "auto-xy text-body-small text-wrap",
				layoutOrder = 2
			})
		end

		v5.Description = description
		toggleContainer = createElement(
			View,
			{
				onActivated = handleBlockToggleChange,
				tag = "col gap-xsmall size-full-0 auto-y padding-large radius-medium bg-action-standard",
				LayoutOrder = 3,
				testId = "ConfirmationNode.BlockToggleContainer"
			},
			v5
		)
	end

	v4.ToggleContainer = toggleContainer
	local err

	if blockToggleState == "Error" and props.blockToggle then
		err = React.createElement(TextWithTranslation, {
			input = props.blockToggle.errorLabel or "",
			tag = "align-x-left size-full-0 auto-y padding-bottom-medium text-body-small content-system-alert",
			layoutOrder = 3
		})
	end

	v4.Error = err
	local informationContainer

	if props.helpline and props.helpline.heading and blockToggleState ~= "Loading" then
		local createElement = React.createElement

		local v5 = {
			InformationHeader = React.createElement(TextWithTranslation, {
				input = props.helpline.heading,
				tag = "auto-xy text-title-small content-emphasis",
				layoutOrder = 1
			}),
			ViewInformationButton = 0
		}
		local viewInformationButton

		if props.helpline and props.helpline.href then
			viewInformationButton = React.createElement(Button, {
				text = translateIntoString(props.helpline.buttonText),
				icon = "icons/navigation/externallink",
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0),
				onActivated = onActivated2,
				LayoutOrder = 2
			})
		end

		v5.ViewInformationButton = viewInformationButton
		informationContainer = createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 4
		}, v5)
	end

	v4.InformationContainer = informationContainer
	local footer

	if props.footerItems then
		footer = React.createElement(Footer, {
			footerItems = props.footerItems,
			additionalTag = "padding-top-medium",
			layoutOrder = 5
		})
	end

	v4.Footer = footer
	local actions

	if props.onNext then
		local createElement = React.createElement
		local v5 = {
			text = translateIntoString(props.nextButtonText),
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local isLoading

		if FFlagSupportSubmissionOnAllReportNodes then
			isLoading = props.isSubmitting
		else
			isLoading = false
		end

		v5.isLoading = isLoading
		local isDisabled

		if FFlagSupportSubmissionOnAllReportNodes then
			isDisabled = props.isSubmitting
		else
			isDisabled = false
		end

		v5.isDisabled = isDisabled
		v5.onActivated = onActivated
		actions = createElement(Button, v5)
	end

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v4),
		actions = actions
	})
end

return React.memo(ConfirmationNode)
