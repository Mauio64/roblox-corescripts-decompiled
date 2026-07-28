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

local function ListNode(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), scrollToItem (copy), Dash (copy), TelemetryEventType (copy), Eyebrow (copy), View (copy), List (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), FFlagSupportSubmissionOnAllReportNodes (copy)
	local v25 = useTokens()
	local v26, v27 = React.useState(t1.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v30 = React.useRef(nil)
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(false)
	local v35 = useLayoutSlots()
	local Body = v35.Body
	local Actions = v35.Actions
	local Title = v35.Title

	React.useEffect(function() -- line: 62
		-- upvalues: v30 (copy), v32 (copy), v34 (copy)
		local current = v30.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 75
			-- upvalues: ScrollingFrame (copy), v32 (copy)
			local v56 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

			v32(v56)
		end
		local function onScroll() -- line: 80
			-- upvalues: ScrollingFrame (copy), v34 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v34(true)
			end
		end

		local v47 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		v32(v47)

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 93
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local v39 = React.useRef({})
	local v40 = React.useRef(nil)

	React.useEffect(function() -- line: 103
		-- upvalues: v26 (copy), v40 (copy), v39 (copy), scrollToItem (copy), v30 (copy)
		if v26 then
			v40.current = v39.current[v26]
			scrollToItem(v30, v40)

			return
		end

		v40.current = nil
	end, { v26 })

	local v41 = React.useCallback(function(s1: string) -- line: 112
		-- upvalues: v27 (copy), Dash (copy), t1 (copy), sendEvent (copy), TelemetryEventType (copy), v31 (copy), v33 (copy)
		v27(s1)

		local n1 = 0

		Dash.forEach(t1.items, function(p1, p2) -- line: 116
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
				has_scroll = v31,
				did_scroll = v33
			}
		})
	end, {
		sendEvent,
		v31,
		v33,
		t1.items
	})
	local v42 = React.useCallback(function() -- line: 133
		-- upvalues: Dash (copy), t1 (copy), v26 (copy)
		local v53 = Dash.find(t1.items, function(p3) -- line: 134
			-- upvalues: v26 (copy)
			return p3.id == v26
		end)

		if t1.onNext then
			t1.onNext(v26, v53)
		end
	end, {
		t1.items,
		t1.onNext,
		v26
	})

	return React.createElement(React.Fragment, nil, {
		Content = if t1.items == nil then nil else React.createElement(Body, {
			ref = v30
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
					PaddingLeft = UDim.new(0, -v25.Padding.XLarge),
					PaddingRight = UDim.new(0, -v25.Padding.XLarge)
				}),
				ItemList = React.createElement(List.Root, {
					value = v26,
					onValueChanged = v41
				}, { Dash.map(t1.items, function(p4, n2: number) -- line: 167
					-- upvalues: React (copy), List (copy), translateIntoString (copy), t1 (copy), v39 (copy)
					return React.createElement(List.Item, {
						trailingAccessory = "Radio",
						hasMargin = true,
						value = p4.id,
						title = translateIntoString(p4.label),
						description = if not p4.description then nil else translateIntoString(p4.description),
						hasDivider = n2 ~= #t1.items,
						ref = function(p5) -- line: 175
							-- upvalues: v39 (copy), p4 (copy)
							v39.current[p4.id] = p5
						end
					})
				end) })
			})
		}),
		Actions = if not t1.onNext or v26 == nil then nil else React.createElement(Actions, nil, {
			Button = React.createElement(Button, {
				text = translateIntoString(t1.nextButtonText),
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isLoading = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
				isDisabled = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
				onActivated = v42
			})
		})
	})
end

return React.memo(ListNode)
