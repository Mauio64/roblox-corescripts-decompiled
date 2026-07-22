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
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local blockUser = userBlock.blockUser
local isBlockedUser = userBlock.isBlockedUser
local isUserMuted = userMute.isUserMuted
local muteUser = userMute.muteUser
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useArTranslation = arTranslation.useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagAbuseReportLinkOpenedAnalytics = SharedFlags.FFlagAbuseReportLinkOpenedAnalytics

local function computeInitialMuteState(p1) -- line: 86
	-- upvalues: isUserMuted (copy)
	if not p1 or not p1.userId then
		return "Hidden"
	end

	local v45 = tonumber(p1.userId) or 0

	if v45 == 0 or isUserMuted(v45) then
		return "Hidden"
	end

	return "Visible"
end
local function useBlockMuteActions(p2, p3, p4: ((...any) -> ...any)) -- line: 97
	-- upvalues: useArTranslation (copy), React (copy), voiceSpeakingSignals (copy), isUserMuted (copy), useAbuseReportAnalytics (copy), useRoactService (copy), RoactNetworking (copy), isBlockedUser (copy), TelemetryEventType (copy), Dash (copy), LocalPlayer (copy), muteUser (copy), Players (copy), BlockingUtility (copy), blockUser (copy), ButtonVariant (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v50 = React.useContext(voiceSpeakingSignals.VoiceChatServiceManagerContext)
	local v51, v52 = React.useState("Hidden")
	local v53, v54 = React.useState(function() -- line: 108
		-- upvalues: p3 (copy), isUserMuted (copy)
		local v83 = p3

		if not v83 or not v83.userId then
			return "Hidden"
		end

		local v84 = tonumber(v83.userId) or 0

		if v84 == 0 or isUserMuted(v84) then
			return "Hidden"
		end

		return "Visible"
	end)
	local v55, v56 = React.useState(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v58 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 116
		-- upvalues: p2 (copy), isBlockedUser (copy), v58 (copy), v52 (copy), v56 (copy), sendEvent (copy), TelemetryEventType (copy), Dash (copy)
		if p2 and p2.userId then
			isBlockedUser(v58, p2.userId):andThen(function(p5) -- line: 119
				-- upvalues: v52 (copy), v56 (copy)
				local responseBody = p5.responseBody

				v52(not responseBody and "Visible" or "Hidden")
				v56(true)
			end):catch(function(p6) -- line: 124
				-- upvalues: sendEvent (copy), TelemetryEventType (copy), Dash (copy), v56 (copy)
				sendEvent({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "isBlockedUser: " .. Dash.pretty(p6, {
							depth = 10
						})
					}
				})
				v56(true)
			end)
			sendEvent({
				sub_event_type = TelemetryEventType.IsUserBlockAvailable
			})
		end
	end, {
		if not p2 then nil else p2.userId,
		v58,
		sendEvent
	})

	local v59 = React.useRef(false)

	React.useEffect(function() -- line: 145
		-- upvalues: v53 (copy), v59 (copy), sendEvent (copy), TelemetryEventType (copy)
		if v53 == "Visible" and not v59.current then
			v59.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.IsUserMuteAvailable
			})
		end
	end, {
		v53,
		sendEvent
	})

	local v60 = React.useCallback(function() -- line: 152
		-- upvalues: p3 (copy), LocalPlayer (copy), v54 (copy), muteUser (copy), v50 (copy), sendEvent (copy), TelemetryEventType (copy), p4 (copy)
		if not p3 or not p3.userId then
			return
		end

		local num = tonumber(p3.userId)

		if num and LocalPlayer then
			v54("Loading")

			if muteUser(num, LocalPlayer, v50) then
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
		p4,
		v50
	})
	local v61 = React.useCallback(function(n1: number) -- line: 178
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
	local v62 = React.useCallback(function() -- line: 198
		-- upvalues: p2 (copy), v52 (copy), blockUser (copy), v58 (copy), sendEvent (copy), TelemetryEventType (copy), v61 (copy), p4 (copy)
		if not p2 or not p2.userId then
			return
		end

		v52("Loading")
		blockUser(v58, p2.userId):andThen(function() -- line: 204
			-- upvalues: sendEvent (copy), TelemetryEventType (copy), p2 (copy), v61 (copy), p4 (copy)
			sendEvent({
				sub_event_type = TelemetryEventType.DidBlockUser
			})

			local num = tonumber(p2.userId)

			if num then
				v61(num)
			end

			p4({
				didBlockUser = true,
				didMuteUser = false
			})
		end):catch(function() -- line: 212
			-- upvalues: v52 (copy), sendEvent (copy), TelemetryEventType (copy), p2 (copy)
			v52("Error")
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
		v61,
		v58,
		sendEvent
	})
	local v63 = p2 == nil or v55

	return {
		actions = React.useMemo(function() -- line: 226
			-- upvalues: v63 (copy), p2 (copy), v51 (copy), translateIntoString (copy), ButtonVariant (copy), v62 (copy), p3 (copy), v53 (copy), v60 (copy)
			local t1 = {}

			if not v63 then
				return t1
			end

			if p2 and v51 ~= "Hidden" then
				table.insert(t1, {
					text = translateIntoString(p2.label),
					variant = ButtonVariant.Alert,
					onActivated = v62,
					isLoading = v51 == "Loading"
				})
			end

			if p3 and v53 ~= "Hidden" then
				table.insert(t1, {
					text = translateIntoString(p3.label),
					variant = ButtonVariant.Alert,
					onActivated = v60,
					isLoading = v53 == "Loading"
				})
			end

			return t1
		end, {
			p2,
			p3,
			v62,
			v60,
			translateIntoString,
			v51,
			v53,
			v63
		}),
		blockState = v51,
		muteState = v53,
		hasActions = p2 ~= nil or p3 ~= nil,
		hasLoadedActions = v63
	}
end
local function useDelayedTrue(n2: number) -- line: 271
	-- upvalues: React (copy)
	local v65, v66 = React.useState(false)

	React.useEffect(function() -- line: 273
		-- upvalues: n2 (copy), v66 (copy)
		local thread = task.delay(n2, function() -- line: 274
			-- upvalues: v66 (copy)
			v66(true)
		end)

		return function() -- line: 277
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, { n2 })

	return v65
end
local function InExpConfirmationNode(t2: {[any]: any}) -- line: 289
	-- upvalues: useArTranslation (copy), useInExpOpenLink (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), useAbuseReportAnalytics (copy), useBlockMuteActions (copy), useDelayedTrue (copy), useLayoutSlots (copy), React (copy), TelemetryEventType (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Dialog (copy), DialogSize (copy), View (copy), TextWithTranslation (copy), TextLink (copy), Footer (copy), EnumsOrientation (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v69 = useInExpOpenLink()
	local sendEvent = nil

	if FFlagAbuseReportLinkOpenedAnalytics then
		sendEvent = useAbuseReportAnalytics().sendEvent
	end

	local v71 = useBlockMuteActions(t2.blockToggle, t2.muteToggle, t2.onNext)
	local actions = v71.actions
	local blockState = v71.blockState
	local muteState = v71.muteState
	local hasActions = v71.hasActions
	local hasLoadedActions = v71.hasLoadedActions
	local v77 = useDelayedTrue(0.6)
	local v78 = t2.isStoryMode or (v77 or (not hasActions or hasLoadedActions))
	local Layout = useLayoutSlots().Layout

	if FFlagAbuseReportLinkOpenedAnalytics then
		React.useEffect(function() -- line: 317
			-- upvalues: sendEvent (ref), v78 (copy), t2 (copy), TelemetryEventType (copy)
			if sendEvent and (v78 and t2.helpline and t2.helpline.href) then
				sendEvent({
					sub_event_type = TelemetryEventType.HelplineShown
				})
			end
		end, {
			t2.helpline and t2.helpline.href,
			v78
		})
	end

	local v80 = React.useCallback(function() -- line: 326
		-- upvalues: t2 (copy), v69 (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), sendEvent (ref), TelemetryEventType (copy)
		if t2.helpline and t2.helpline.href then
			v69(t2.helpline.href)

			if FFlagAbuseReportLinkOpenedAnalytics and sendEvent then
				sendEvent({
					sub_event_type = TelemetryEventType.HelplineOpened
				})
			end
		end
	end, {
		t2.helpline,
		v69
	})
	local v81 = React.useCallback(function() -- line: 335
		-- upvalues: t2 (copy)
		t2.onNext({
			didBlockUser = false,
			didMuteUser = false
		})
	end, { t2.onNext })
	local v82 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v81)

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Layout, {
			body = nil,
			actions = nil
		}),
		ConfirmationDialog = if not v78 then nil else React.createElement(Dialog.Root, {
			ref = v82,
			size = DialogSize.Small,
			hasBackdrop = not t2.isStoryMode,
			disablePortal = not not t2.isStoryMode,
			onClose = v81
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
							onActivated = v80
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
