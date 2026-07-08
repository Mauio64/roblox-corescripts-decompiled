local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local List = require(GenericAbuseReporting.Common.List)
local scrollToItem = require(GenericAbuseReporting.BeduiV2.Utils.scrollToItem)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes
local FFlagRemoveHardcodedStringsInReportNodes = SharedFlags.FFlagRemoveHardcodedStringsInReportNodes

local function ListNode(t1: {[any]: any}) -- line: 48
	-- upvalues: useTokens (copy), React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), scrollToItem (copy), Dash (copy), TelemetryEventType (copy), Eyebrow (copy), View (copy), List (copy), Button (copy), FFlagRemoveHardcodedStringsInReportNodes (copy), ButtonVariant (copy), FillBehavior (copy), FFlagSupportSubmissionOnAllReportNodes (copy)
	local v26 = useTokens()
	local v27, v28 = React.useState(t1.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v31 = React.useRef(nil)
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState(false)
	local v36 = useLayoutSlots()
	local Body = v36.Body
	local Actions = v36.Actions
	local Title = v36.Title

	React.useEffect(function() -- line: 63
		-- upvalues: v31 (copy), v33 (copy), v35 (copy)
		local current = v31.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 76
			-- upvalues: ScrollingFrame (copy), v33 (copy)
			local v57 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

			v33(v57)
		end
		local function onScroll() -- line: 81
			-- upvalues: ScrollingFrame (copy), v35 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v35(true)
			end
		end

		local v48 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		v33(v48)

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 94
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local v40 = React.useRef({})
	local v41 = React.useRef(nil)

	React.useEffect(function() -- line: 104
		-- upvalues: v27 (copy), v41 (copy), v40 (copy), scrollToItem (copy), v31 (copy)
		if v27 then
			v41.current = v40.current[v27]
			scrollToItem(v31, v41)

			return
		end

		v41.current = nil
	end, { v27 })

	local v42 = React.useCallback(function(s1: string) -- line: 113
		-- upvalues: v28 (copy), Dash (copy), t1 (copy), sendEvent (copy), TelemetryEventType (copy), v32 (copy), v34 (copy)
		v28(s1)

		local n1 = 0

		Dash.forEach(t1.items, function(p1, p2) -- line: 117
			-- upvalues: s1 (copy), n1 (ref)
			if p1.id == s1 then
				n1 = p2

				return
			end
		end)
		sendEvent({
			sub_event_type = TelemetryEventType.SelectItem,
			select_item_detail = {
				selected_index = n1,
				list_length = #t1.items,
				has_scroll = v32,
				did_scroll = v34
			}
		})
	end, {
		sendEvent,
		v32,
		v34,
		t1.items
	})
	local v43 = React.useCallback(function() -- line: 134
		-- upvalues: Dash (copy), t1 (copy), v27 (copy)
		local v54 = Dash.find(t1.items, function(p3) -- line: 135
			-- upvalues: v27 (copy)
			return p3.id == v27
		end)

		if t1.onNext then
			t1.onNext(v27, v54)
		end
	end, {
		t1.items,
		t1.onNext,
		v27
	})

	return React.createElement(React.Fragment, nil, {
		Content = if t1.items == nil then nil else React.createElement(Body, {
			ref = v31
		}, {
			Eyebrow = React.createElement(Eyebrow, {
				layoutOrder = 0,
				eyebrow = t1.eyebrow
			}),
			Title = React.createElement(Title, {
				layoutOrder = 1,
				input = t1.title
			}),
			ItemListContainer = React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, -v26.Padding.XLarge),
					PaddingRight = UDim.new(0, -v26.Padding.XLarge)
				}),
				ItemList = React.createElement(List.Root, {
					value = v27,
					onValueChanged = v42
				}, { Dash.map(t1.items, function(p4, n2: number) -- line: 168
					-- upvalues: React (copy), List (copy), translateIntoString (copy), t1 (copy), v40 (copy)
					return React.createElement(List.Item, {
						trailingAccessory = "Radio",
						hasMargin = true,
						value = p4.id,
						title = translateIntoString(p4.label),
						description = if not p4.description then nil else translateIntoString(p4.description),
						hasDivider = n2 ~= #t1.items,
						ref = function(p5) -- line: 176
							-- upvalues: v40 (copy), p4 (copy)
							v40.current[p4.id] = p5
						end
					})
				end) })
			})
		}),
		Actions = if not t1.onNext or v27 == nil then nil else React.createElement(Actions, nil, {
			Button = React.createElement(Button, {
				text = if not FFlagRemoveHardcodedStringsInReportNodes then not t1.nextButtonText and "Continue" or translateIntoString(t1.nextButtonText) else translateIntoString(t1.nextButtonText),
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isLoading = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
				isDisabled = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
				onActivated = v43
			})
		})
	})
end

return React.memo(ListNode)
