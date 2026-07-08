local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local BlockingUtility = require(GenericAbuseReportingParent.BlockingUtility)
local Dash = require(GenericAbuseReportingParent.Dash)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
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
local blockUser = userBlock.blockUser
local isBlockedUser = userBlock.isBlockedUser
local isUserMuted = userMute.isUserMuted
local muteUser = userMute.muteUser
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useArTranslation = arTranslation.useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function computeInitialMuteState(p1) -- line: 81
	-- upvalues: isUserMuted (copy)
	if not p1 or not p1.userId then
		return "Hidden"
	end

	local v42 = tonumber(p1.userId) or 0

	if v42 == 0 or isUserMuted(v42) then
		return "Hidden"
	end

	return "Visible"
end
local function useBlockMuteActions(p2, p3, p4: ((...any) -> ...any)) -- line: 92
	-- upvalues: useArTranslation (copy), React (copy), isUserMuted (copy), useAbuseReportAnalytics (copy), useRoactService (copy), RoactNetworking (copy), isBlockedUser (copy), TelemetryEventType (copy), Dash (copy), LocalPlayer (copy), muteUser (copy), Players (copy), BlockingUtility (copy), blockUser (copy), ButtonVariant (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v47, v48 = React.useState("Hidden")
	local v49, v50 = React.useState(function() -- line: 102
		-- upvalues: p3 (copy), isUserMuted (copy)
		local v78 = p3

		if not v78 or not v78.userId then
			return "Hidden"
		end

		local v79 = tonumber(v78.userId) or 0

		if v79 == 0 or isUserMuted(v79) then
			return "Hidden"
		end

		return "Visible"
	end)
	local v51, v52 = React.useState(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v54 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 110
		-- upvalues: p2 (copy), isBlockedUser (copy), v54 (copy), v48 (copy), v52 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
		if p2 and p2.userId then
			isBlockedUser(v54, p2.userId):andThen(function(p5) -- line: 113
				-- upvalues: v48 (copy), v52 (copy)
				local responseBody = p5.responseBody

				v48(not responseBody and "Visible" or "Hidden")
				v52(true)
			end):catch(function(p6) -- line: 118
				-- upvalues: sendEvent (copy), TelemetryEventType (copy), Dash (copy), v52 (copy)
				sendEvent({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "isBlockedUser: " .. Dash.pretty(p6, {
							depth = 10
						})
					}
				})
				v52(true)
			end)
			sendEvent({
				sub_event_type = TelemetryEventType.IsUserBlockAvailable
			})
		end
	end, {
		if not p2 then nil else p2.userId,
		v54,
		sendEvent
	})

	local v55 = React.useRef(false)

	React.useEffect(function() -- line: 139
		-- upvalues: v49 (copy), v55 (copy), sendEvent (copy), TelemetryEventType (copy)
		if v49 == "Visible" and not v55.current then
			v55.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.IsUserMuteAvailable
			})
		end
	end, {
		v49,
		sendEvent
	})

	local v56 = React.useCallback(function() -- line: 146
		-- upvalues: p3 (copy), LocalPlayer (copy), v50 (copy), muteUser (copy), sendEvent (copy), TelemetryEventType (copy), p4 (copy)
		if not p3 or not p3.userId then
			return
		end

		local num = tonumber(p3.userId)

		if num and LocalPlayer then
			v50("Loading")

			if muteUser(num, LocalPlayer) then
				sendEvent({
					sub_event_type = TelemetryEventType.DidMuteUser
				})
				p4({
					didBlockUser = false,
					didMuteUser = true
				})

				return
			end

			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `muteUser failed for userId: { num }`
				}
			})
			p4({
				didBlockUser = false,
				didMuteUser = false
			})
		end
	end, {
		p3,
		sendEvent,
		p4
	})
	local v57 = React.useCallback(function(n1: number) -- line: 172
		-- upvalues: sendEvent (copy), TelemetryEventType (copy), Players (copy), BlockingUtility (copy)
		if not n1 or n1 == 0 then
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "AddPlayerToBlockList invalid userId"
				}
			})

			return
		end

		local PlayerByUserId = Players:GetPlayerByUserId(n1)

		if PlayerByUserId and not BlockingUtility:AddPlayerToBlockList(PlayerByUserId) then
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `AddPlayerToBlockList failed for userId: { n1 }`
				}
			})
		end
	end, { sendEvent })
	local v58 = React.useCallback(function() -- line: 192
		-- upvalues: p2 (copy), v48 (copy), blockUser (copy), v54 (copy), sendEvent (copy), TelemetryEventType (copy), v57 (copy), p4 (copy)
		if not p2 or not p2.userId then
			return
		end

		v48("Loading")
		blockUser(v54, p2.userId):andThen(function() -- line: 198
			-- upvalues: sendEvent (copy), TelemetryEventType (copy), p2 (copy), v57 (copy), p4 (copy)
			sendEvent({
				sub_event_type = TelemetryEventType.DidBlockUser
			})

			local num = tonumber(p2.userId)

			if num then
				v57(num)
			end

			p4({
				didBlockUser = true,
				didMuteUser = false
			})
		end):catch(function() -- line: 206
			-- upvalues: v48 (copy), sendEvent (copy), TelemetryEventType (copy), p2 (copy)
			v48("Error")
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `blockUser failed for userId: { p2.userId }`
				}
			})
		end)
	end, {
		p2,
		p4,
		v57,
		v54,
		sendEvent
	})
	local v59 = p2 == nil or v51

	return {
		actions = React.useMemo(function() -- line: 220
			-- upvalues: v59 (copy), p2 (copy), v47 (copy), translateIntoString (copy), ButtonVariant (copy), v58 (copy), p3 (copy), v49 (copy), v56 (copy)
			local t1 = {}

			if not v59 then
				return t1
			end

			if p2 and v47 ~= "Hidden" then
				table.insert(t1, {
					text = translateIntoString(p2.label),
					variant = ButtonVariant.Alert,
					onActivated = v58,
					isLoading = v47 == "Loading"
				})
			end

			if p3 and v49 ~= "Hidden" then
				table.insert(t1, {
					text = translateIntoString(p3.label),
					variant = ButtonVariant.Alert,
					onActivated = v56,
					isLoading = v49 == "Loading"
				})
			end

			return t1
		end, {
			p2,
			p3,
			v58,
			v56,
			translateIntoString,
			v47,
			v49,
			v59
		}),
		blockState = v47,
		muteState = v49,
		hasActions = p2 ~= nil or p3 ~= nil,
		hasLoadedActions = v59
	}
end
local function useDelayedTrue(n2: number) -- line: 265
	-- upvalues: React (copy)
	local v61, v62 = React.useState(false)

	React.useEffect(function() -- line: 267
		-- upvalues: n2 (copy), v62 (copy)
		local thread = task.delay(n2, function() -- line: 268
			-- upvalues: v62 (copy)
			v62(true)
		end)

		return function() -- line: 271
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, { n2 })

	return v61
end
local function InExpConfirmationNode(t2: {[any]: any}) -- line: 283
	-- upvalues: useArTranslation (copy), useInExpOpenLink (copy), useBlockMuteActions (copy), useDelayedTrue (copy), useLayoutSlots (copy), React (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Dialog (copy), DialogSize (copy), View (copy), TextWithTranslation (copy), TextLink (copy), Footer (copy), EnumsOrientation (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v65 = useInExpOpenLink()
	local v66 = useBlockMuteActions(t2.blockToggle, t2.muteToggle, t2.onNext)
	local actions = v66.actions
	local blockState = v66.blockState
	local muteState = v66.muteState
	local hasActions = v66.hasActions
	local hasLoadedActions = v66.hasLoadedActions
	local v72 = useDelayedTrue(0.6)
	local v73 = t2.isStoryMode or (v72 or (not hasActions or hasLoadedActions))
	local Layout = useLayoutSlots().Layout
	local v75 = React.useCallback(function() -- line: 302
		-- upvalues: t2 (copy), v65 (copy)
		if t2.helpline and t2.helpline.href then
			v65(t2.helpline.href)
		end
	end, {
		t2.helpline,
		v65
	})
	local v76 = React.useCallback(function() -- line: 308
		-- upvalues: t2 (copy)
		t2.onNext({
			didBlockUser = false,
			didMuteUser = false
		})
	end, { t2.onNext })
	local v77 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v76)

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Layout, {
			body = nil,
			actions = nil
		}),
		ConfirmationDialog = if not v73 then nil else React.createElement(Dialog.Root, {
			ref = v77,
			size = DialogSize.Small,
			hasBackdrop = not t2.isStoryMode,
			disablePortal = not not t2.isStoryMode,
			onClose = v76
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				text = translateIntoString(t2.title)
			}),
			DialogContent = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				DialogContentView = React.createElement(View, {
					tag = "col gap-small size-full-0 auto-y"
				}, {
					Message = React.createElement(TextWithTranslation, {
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 2,
						input = t2.message
					}),
					Helpline = t2.helpline and React.createElement(View, {
						tag = "col gap-small size-full-0 auto-y",
						LayoutOrder = 3
					}, {
						Heading = React.createElement(TextWithTranslation, {
							tag = "size-full-0 auto-y text-body-medium",
							layoutOrder = 1,
							input = t2.helpline.heading
						}),
						Link = React.createElement(TextLink, {
							tag = "auto-xy text-body-medium text-wrap text-align-x-left radius-small content-emphasis",
							layoutOrder = 2,
							text = translateIntoString(t2.helpline.buttonText),
							onActivated = v75
						})
					}),
					ErrorMessage = if blockState ~= "Error" and muteState ~= "Error" then nil else React.createElement(TextWithTranslation, {
						tag = "size-full-0 auto-y text-body-medium content-system-alert",
						layoutOrder = 4,
						input = if blockState ~= "Error" or not t2.blockToggle then (muteState ~= "Error" or not t2.muteToggle) and "" or t2.muteToggle.errorLabel else t2.blockToggle.errorLabel
					}),
					Footer = t2.footerItems and React.createElement(Footer, {
						additionalTag = "padding-top-medium",
						layoutOrder = 5,
						footerItems = t2.footerItems
					})
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 4,
				actions = actions,
				orientation = EnumsOrientation.Vertical
			})
		})
	})
end

return React.memo(InExpConfirmationNode)
