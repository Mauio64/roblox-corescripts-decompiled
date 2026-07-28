local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
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

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)
local userBlock = require(GenericAbuseReporting.BeduiV2.Api.userBlock)
local blockUser = userBlock.blockUser
local isBlockedUser = userBlock.isBlockedUser
local TelemetryEventType = analyticsService.TelemetryEventType
local unblockUser = userBlock.unblockUser
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2

local function useBlockToggle(p1) -- line: 71
	-- upvalues: React (copy), useAbuseReportAnalytics (copy), useRoactService (copy), RoactNetworking (copy), isBlockedUser (copy), TelemetryEventType (copy), Dash (copy), unblockUser (copy), blockUser (copy)
	local v34, v35 = React.useState(not p1 and "Hidden" or "Loading")
	local v36, v37 = React.useState(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v39 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 78
		-- upvalues: p1 (copy), isBlockedUser (copy), v39 (copy), v35 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
		if p1 and p1.userId then
			isBlockedUser(v39, p1.userId):andThen(function(p2) -- line: 81
				-- upvalues: v35 (copy)
				local responseBody = p2.responseBody

				v35(not responseBody and "Visible" or "Hidden")
			end):catch(function(p3) -- line: 85
				-- upvalues: v35 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
				v35("Hidden")
				sendEvent({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "isBlockedUser: " .. Dash.pretty(p3, {
							depth = 10
						})
					}
				})
			end)
			sendEvent({
				sub_event_type = TelemetryEventType.IsUserBlockAvailable
			})

			return
		end

		v35("Hidden")
	end, {
		p1 and p1.userId,
		sendEvent,
		v39
	})

	local v40 = React.useCallback(function() -- line: 100
		-- upvalues: p1 (copy), v36 (copy), unblockUser (copy), v39 (copy), v37 (copy), v35 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy), blockUser (copy)
		if p1 == nil or p1.userId == nil then
			return
		end

		if v36 then
			unblockUser(v39, p1.userId):andThen(function() -- line: 107
				-- upvalues: v37 (copy)
				v37(false)
			end):catch(function(p4) -- line: 110
				-- upvalues: v35 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
				v35("Error")
				sendEvent({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "unblockUser: " .. Dash.pretty(p4, {
							depth = 10
						})
					}
				})
			end)
			sendEvent({
				sub_event_type = TelemetryEventType.DidUnblockUser
			})

			return
		end

		blockUser(v39, p1.userId):andThen(function() -- line: 122
			-- upvalues: sendEvent (copy), TelemetryEventType (copy), v37 (copy)
			sendEvent({
				sub_event_type = TelemetryEventType.DidBlockUser
			})
			v37(true)
		end):catch(function(p5) -- line: 126
			-- upvalues: v35 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
			v35("Error")
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "blockUser: " .. Dash.pretty(p5, {
						depth = 10
					})
				}
			})
		end)
	end, {
		sendEvent,
		v39,
		p1 and p1.userId,
		v36
	})

	return {
		blockToggleState = v34,
		handleBlockToggleChange = v40,
		isBlocked = v36
	}
end
local function ConfirmationNode(t1: {[any]: any}) -- line: 149
	-- upvalues: useArTranslation (copy), useOpenLink (copy), useAbuseReportAnalytics (copy), useBlockToggle (copy), useLayoutSlots (copy), FFlagAbuseReportMenuV2 (copy), React (copy), TelemetryEventType (copy), Eyebrow (copy), TextWithTranslation (copy), View (copy), Toggle (copy), Button (copy), ButtonVariant (copy), Footer (copy), FillBehavior (copy), FFlagSupportSubmissionOnAllReportNodes (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v43 = useOpenLink()
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local blockToggle = t1.blockToggle
	local v46 = useBlockToggle(blockToggle)
	local blockToggleState = v46.blockToggleState
	local handleBlockToggleChange = v46.handleBlockToggleChange
	local isBlocked = v46.isBlocked
	local v50 = useLayoutSlots()
	local Body = v50.Body
	local Actions = v50.Actions
	local Title = v50.Title
	local Layout = nil

	if FFlagAbuseReportMenuV2 then
		Layout = v50.Layout
	end

	React.useEffect(function() -- line: 170
		-- upvalues: t1 (copy), sendEvent (copy), TelemetryEventType (copy)
		if t1.helpline and t1.helpline.href then
			sendEvent({
				sub_event_type = TelemetryEventType.HelplineShown
			})
		end
	end, {
		t1.helpline and t1.helpline.href,
		sendEvent
	})

	local v55 = React.useCallback(function() -- line: 176
		-- upvalues: t1 (copy)
		if t1.onNext then
			t1.onNext()
		end
	end, { t1.onNext })
	local v56 = React.useCallback(function() -- line: 183
		-- upvalues: t1 (copy), v43 (copy), translateIntoString (copy), sendEvent (copy), TelemetryEventType (copy)
		if t1.helpline and t1.helpline.href then
			v43(translateIntoString(t1.helpline.heading or ""), t1.helpline.href)
			sendEvent({
				sub_event_type = TelemetryEventType.HelplineOpened
			})
		end
	end, {
		t1.helpline and t1.helpline.href,
		v43,
		translateIntoString,
		t1.helpline and t1.helpline.heading,
		sendEvent
	})
	local t2 = {
		Eyebrow = React.createElement(Eyebrow, {
			layoutOrder = 0,
			eyebrow = t1.eyebrow
		}),
		Title = React.createElement(Title, {
			layoutOrder = 1,
			input = t1.title,
			subtitle = t1.subtitle
		}),
		Message = React.createElement(TextWithTranslation, {
			tag = "size-full-0 auto-y text-body-small",
			layoutOrder = 2,
			input = t1.message
		}),
		ToggleContainer = if not t1.blockToggle or blockToggleState ~= "Visible" then nil else React.createElement(View, {
			tag = "size-full-0 auto-y col padding-large radius-medium gap-xsmall bg-action-standard",
			LayoutOrder = 3,
			onActivated = handleBlockToggleChange
		}, {
			TextContainer = React.createElement(View, {
				tag = "auto-y size-full-0 row gap-small flex-x-between",
				LayoutOrder = 1
			}, {
				Label = React.createElement(TextWithTranslation, {
					tag = "text-title-large content-emphasis auto-xy",
					layoutOrder = 1,
					input = t1.blockToggle.label or ""
				}),
				Toggle = React.createElement(Toggle, {
					label = "",
					Selectable = false,
					LayoutOrder = 2,
					isChecked = isBlocked,
					onActivated = handleBlockToggleChange
				})
			}),
			Description = if not t1.blockToggle.description then nil else React.createElement(TextWithTranslation, {
				tag = "text-body-small auto-xy text-wrap",
				layoutOrder = 2,
				input = t1.blockToggle.description or ""
			})
		}),
		Error = if blockToggleState ~= "Error" or not t1.blockToggle then nil else React.createElement(TextWithTranslation, {
			tag = "size-full-0 auto-y content-system-alert text-body-small padding-bottom-medium align-x-left",
			layoutOrder = 3,
			input = t1.blockToggle.errorLabel or ""
		}),
		InformationContainer = if not t1.helpline or (not t1.helpline.heading or blockToggleState == "Loading") then nil else React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium",
			LayoutOrder = 4
		}, {
			InformationHeader = React.createElement(TextWithTranslation, {
				tag = "text-title-small content-emphasis auto-xy",
				layoutOrder = 1,
				input = t1.helpline.heading
			}),
			ViewInformationButton = if not t1.helpline or not t1.helpline.href then nil else React.createElement(Button, {
				icon = "icons/navigation/externallink",
				LayoutOrder = 2,
				text = translateIntoString(t1.helpline.buttonText),
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0),
				onActivated = v56
			})
		}),
		Footer = if not FFlagAbuseReportMenuV2 or not t1.footerItems then nil else React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 5,
			footerItems = t1.footerItems
		})
	}
	local v58 = if not t1.onNext then nil else React.createElement(Button, {
		text = translateIntoString(t1.nextButtonText),
		variant = ButtonVariant.Emphasis,
		fillBehavior = FillBehavior.Fill,
		isLoading = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
		isDisabled = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
		onActivated = v55
	})

	if FFlagAbuseReportMenuV2 then
		return React.createElement(Layout, {
			body = React.createElement(React.Fragment, nil, t2),
			actions = v58
		})
	end

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Body, nil, t2),
		Actions = if not v58 then nil else React.createElement(Actions, nil, {
			Button = v58
		})
	})
end

return React.memo(ConfirmationNode)
