local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local FFlagAbuseReportSelectItemAddId = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportSelectItemAddId
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local DialogSize = Foundation.Enums.DialogSize
local FillBehavior = Foundation.Enums.FillBehavior
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local List = Foundation.List
local ListItemInputType = Foundation.Enums.ListItemInputType
local EnumsRadius = Foundation.Enums.Radius
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local useInExpCustomSubmit = require(GenericAbuseReporting.BeduiV2.Hooks.useInExpCustomSubmit)
local useInExpFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useInExpFocusNavigationRefs)
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local InExpDropdownWithPopover = require(GenericAbuseReporting.BeduiV2.Components.InExpDropdownWithPopover)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local scrollToItem = require(GenericAbuseReporting.BeduiV2.Utils.scrollToItem)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local useGroupedListLoader = require(GenericAbuseReporting.BeduiV2.Loaders.useLoader).useGroupedListLoader
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local v38 = game:DefineFastFlag("FixChatSelectorDropdownPadding", false)

local function useScrollToSelected(s1: string?, t1: {[any]: any}) -- line: 49
	-- upvalues: React (copy), scrollToItem (copy)
	React.useEffect(function() -- line: 50
		-- upvalues: s1 (copy), t1 (copy), scrollToItem (copy)
		if not s1 then
			return
		end

		local v81 = t1.current[s1]

		if not v81 then
			return
		end

		local ScrollingFrame = v81:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u83 = false
		local t2 = {
			current = ScrollingFrame.Parent
		}
		local t3 = {
			current = v81
		}

		local function performScroll() -- line: 72
			-- upvalues: u83 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
			if u83 then
				return
			end

			scrollToItem(t2, t3)
		end

		if v81.AbsoluteSize.Y > 0 then
			if not u83 then
				scrollToItem(t2, t3)
			end
		else
			local connection = nil

			connection = v81:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 84
				-- upvalues: v81 (copy), connection (ref), u83 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
				if v81.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u83 then
						return
					end

					scrollToItem(t2, t3)
				end
			end)
			task.delay(2, function() -- line: 91
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 98
			-- upvalues: u83 (ref)
			u83 = true
		end
	end, { s1 })
end

local REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = useInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID

local function LoadingContent() -- line: 139
	-- upvalues: useTokens (copy), React (copy), Sheet (copy), View (copy), Dash (copy), Skeleton (copy), EnumsRadius (copy)
	local v46 = useTokens()

	return React.createElement(Sheet.Content, nil, {
		SkeletonContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y"
		}, Dash.map(table.create(5, true), function(_: boolean, n1: number) -- line: 146
			-- upvalues: React (copy), Skeleton (copy), EnumsRadius (copy), v46 (copy)
			return React.createElement(Skeleton, {
				key = tostring(n1),
				radius = EnumsRadius.Medium,
				Size = UDim2.new(1, 0, 0, v46.Size.Size_800)
			})
		end))
	})
end
local function ErrorContent(t4: {[any]: any}) -- line: 157
	-- upvalues: useArTranslation (copy), React (copy), Sheet (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(Sheet.Content, nil, {
		ErrorContainer = React.createElement(View, {
			tag = "align-x-center align-y-center gap-medium size-full"
		}, {
			ErrorText = React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy text-body-medium text-wrap text-align-x-left",
				Text = translateIntoString(t4.errorText)
			}),
			RetryButton = React.createElement(Button, {
				text = translateIntoString(t4.retryButtonText),
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fit,
				onActivated = t4.retry or function() -- line: 177
				end
			})
		})
	})
end
local function InExpChatSelectionNode(t5: {[any]: any}) -- line: 189
	-- upvalues: React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), useGroupedListLoader (copy), scrollToItem (copy), TelemetryEventType (copy), Dash (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), LoadingContent (copy), ErrorContent (copy), Sheet (copy), View (copy), TextWithTranslation (copy), FoundationText (copy), v38 (copy), InExpDropdownWithPopover (copy), List (copy), Icon (copy), IconName (copy), IconVariant (copy), FFlagAbuseReportSelectItemAddId (copy), ListItemInputType (copy), Footer (copy), DialogSize (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v50, v51 = React.useState(t5.initialValue or nil)
	local v52 = React.useRef(nil)
	local v53, v54 = React.useState(nil)
	local v55, v56 = React.useState(true)
	local translateIntoString = useArTranslation().translateIntoString
	local v58 = React.useRef({})
	local v59 = React.useRef(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v61 = React.useRef(false)
	local v62 = React.useRef(false)
	local v63 = React.useRef(nil)
	local v64 = React.useRef(false)
	local v65 = React.useRef(false)
	local Layout = useLayoutSlots().Layout
	local v67 = useGroupedListLoader(t5.items)
	local v68 = v67.data or {}

	React.useEffect(function() -- line: 50
		-- upvalues: v50 (copy), v58 (copy), scrollToItem (copy)
		if not v50 then
			return
		end

		local v90 = v58.current[v50]

		if not v90 then
			return
		end

		local ScrollingFrame = v90:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u92 = false
		local t6 = {
			current = ScrollingFrame.Parent
		}
		local t7 = {
			current = v90
		}

		local function performScroll() -- line: 72
			-- upvalues: u92 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
			if u92 then
				return
			end

			scrollToItem(t6, t7)
		end

		if v90.AbsoluteSize.Y > 0 then
			if not u92 then
				scrollToItem(t6, t7)
			end
		else
			local connection = nil

			connection = v90:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 84
				-- upvalues: v90 (copy), connection (ref), u92 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
				if v90.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u92 then
						return
					end

					scrollToItem(t6, t7)
				end
			end)
			task.delay(2, function() -- line: 91
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 98
			-- upvalues: u92 (ref)
			u92 = true
		end
	end, { v50 })
	React.useEffect(function() -- line: 213
		-- upvalues: v63 (copy), v61 (copy), v62 (copy)
		local current = v63.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 224
			-- upvalues: v61 (copy), ScrollingFrame (copy)
			v61.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y
		end
		local function onScroll() -- line: 228
			-- upvalues: ScrollingFrame (copy), v62 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v62.current = true
			end
		end

		v61.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 241
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v67.loading })
	React.useEffect(function() -- line: 248
		-- upvalues: v67 (copy), v64 (copy), sendEvent (copy), TelemetryEventType (copy)
		if v67.error and not v64.current then
			v64.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "inExpChatSelection: load failed: " .. v67.error
				}
			})
		end
	end, {
		v67.error,
		sendEvent
	})

	local v69 = #v68 > 1
	local v70 = React.useMemo(function() -- line: 259
		-- upvalues: v53 (copy), v50 (copy), v68 (copy)
		if v53 then
			return v53
		end

		if v50 then
			for _, v in ipairs(v68) do
				for _, v2 in ipairs(v.items) do
					if v2.id == v50 then
						return v.id
					end
				end
			end
		end

		return v68[1] and v68[1].id or nil
	end, {
		v53,
		v50,
		v68
	})
	local v71 = React.useMemo(function() -- line: 275
		-- upvalues: v68 (copy), Dash (copy), v70 (copy), t5 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy)
		if #v68 == 0 then
			return {}
		end

		local v108 = Dash.find(v68, function(p1) -- line: 279
			-- upvalues: v70 (copy)
			return p1.id == v70
		end)
		local v109 = if not t5.reportMessageNotShownText or t5.reportMessageNotShownText == "" then {} else {{
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}}

		for _, v in ipairs(v108 and v108.items or {}) do
			table.insert(v109, v)
		end

		return v109
	end, {
		v68,
		v70,
		t5.reportMessageNotShownText
	})
	local v72 = v71[#v71] and v71[#v71].id or nil

	React.useEffect(function() -- line: 300
		-- upvalues: v50 (copy), v72 (copy), v58 (copy), scrollToItem (copy), v63 (copy)
		if v50 then
			return
		end

		if not v72 then
			return
		end

		local v112 = v58.current[v72]

		if not v112 then
			return
		end

		local u113 = false

		local function performScroll() -- line: 315
			-- upvalues: u113 (ref), scrollToItem (copy), v63 (copy), v112 (copy)
			if u113 then
				return
			end

			scrollToItem(v63, {
				current = v112
			})
		end

		if v112.AbsoluteSize.Y > 0 then
			if not u113 then
				scrollToItem(v63, {
					current = v112
				})
			end
		else
			local connection = nil

			connection = v112:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 326
				-- upvalues: v112 (copy), connection (ref), u113 (ref), scrollToItem (copy), v63 (copy)
				if v112.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u113 then
						return
					end

					scrollToItem(v63, {
						current = v112
					})
				end
			end)
			task.delay(2, function() -- line: 334
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 341
			-- upvalues: u113 (ref)
			u113 = true
		end
	end, {
		v72,
		v50
	})
	React.useEffect(function() -- line: 346
		-- upvalues: v67 (copy), v71 (copy), v65 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not v67.loading and (not v67.error and #v71 == 0 and not v65.current) then
			v65.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.EmptyState
			})
		end
	end, {
		v67.loading,
		v67.error,
		v71,
		sendEvent
	})

	local v73 = React.useCallback(function() -- line: 360
		-- upvalues: v59 (copy), v56 (copy)
		v59.current = true
		v56(false)
	end, {})
	local v74 = React.useCallback(function() -- line: 365
		-- upvalues: v56 (copy)
		v56(false)
	end, {})
	local v75, v76 = React.useState(false)
	local v77 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v74, not v75)
	local v78 = React.useMemo(function() -- line: 380
		-- upvalues: Dash (copy), v68 (copy)
		return Dash.map(v68, function(t8: {[any]: any}) -- line: 381
			return {
				id = t8.id,
				text = t8.label
			}
		end)
	end, { v68 })
	local v79 = React.useCallback(function() -- line: 386
		-- upvalues: v51 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), v52 (copy), t5 (copy), v73 (copy)
		v51(REPORT_MESSAGE_NOT_SHOWN_ITEM_ID)
		v52.current = {
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}
		v73()
	end, { v73 })
	local v80 = if not v67.loading then if not v67.error then if #v71 ~= 0 then React.createElement(Sheet.Content, {
		isContentFullBleed = true,
		ref = v63
	}, {
		ChannelDropdown = if not v38 or not v69 then if not v69 then nil else React.createElement(InExpDropdownWithPopover, {
			LayoutOrder = 1,
			value = v70,
			items = v78,
			onOpenChange = v76,
			onItemChanged = function(p2) -- line: 459
				-- upvalues: v70 (copy), v51 (copy), v54 (copy), sendEvent (copy), TelemetryEventType (copy), v68 (copy)
				local v120 = v70 or ""
				local str = tostring(p2)

				v51(nil)
				v54(str)
				sendEvent({
					sub_event_type = TelemetryEventType.TextChannelSwitch,
					text_channel_switch_detail = {
						previous_channel_name = v120,
						new_channel_name = str,
						channel_count = #v68
					}
				})
			end
		}) else React.createElement(View, {
			tag = "auto-xy padding-x-xlarge padding-top-xsmall",
			LayoutOrder = 1
		}, React.createElement(InExpDropdownWithPopover, {
			LayoutOrder = 1,
			value = v70,
			items = v78,
			onOpenChange = v76,
			onItemChanged = function(p3) -- line: 438
				-- upvalues: v70 (copy), v51 (copy), v54 (copy), sendEvent (copy), TelemetryEventType (copy), v68 (copy)
				local v117 = v70 or ""
				local str = tostring(p3)

				v51(nil)
				v54(str)
				sendEvent({
					sub_event_type = TelemetryEventType.TextChannelSwitch,
					text_channel_switch_detail = {
						previous_channel_name = v117,
						new_channel_name = str,
						channel_count = #v68
					}
				})
			end
		})),
		ItemList = React.createElement(List.Root, {
			LayoutOrder = 2,
			hasDivider = {
				hasDivider = true,
				isInset = false
			},
			isContained = {
				isContained = false,
				hasMargin = true
			}
		}, { Dash.map(v71, function(p4, n2: number) -- line: 486
			-- upvalues: React (copy), Icon (copy), IconName (copy), IconVariant (copy), List (copy), translateIntoString (copy), v51 (copy), v52 (copy), sendEvent (copy), TelemetryEventType (copy), FFlagAbuseReportSelectItemAddId (copy), v71 (copy), v61 (copy), v62 (copy), ListItemInputType (copy), v50 (copy), v58 (copy)
			local v124 = nil

			if p4.meta and (p4.meta.presetId and p4.meta.presetId ~= "") then
				v124 = React.createElement(Icon, {
					name = IconName.LightningBolt,
					variant = IconVariant.Filled
				})
			end

			return React.createElement(List.Item, {
				description = translateIntoString(p4.label),
				trailing = v124,
				onActivated = {
					onActivated = function() -- line: 499
						-- upvalues: v51 (copy), p4 (copy), v52 (copy), sendEvent (copy), TelemetryEventType (copy), n2 (copy), FFlagAbuseReportSelectItemAddId (copy), v71 (copy), v61 (copy), v62 (copy)
						v51(p4.id)
						v52.current = p4
						sendEvent({
							sub_event_type = TelemetryEventType.SelectItem,
							select_item_detail = {
								selected_index = n2,
								selected_id = if not FFlagAbuseReportSelectItemAddId then nil else p4.id,
								list_length = #v71,
								has_scroll = v61.current,
								did_scroll = v62.current
							}
						})
					end,
					inputType = ListItemInputType.Radio,
					isChecked = v50 == p4.id
				},
				LayoutOrder = n2,
				ref = function(p5) -- line: 517
					-- upvalues: v58 (copy), p4 (copy)
					v58.current[p4.id] = p5
				end,
				key = p4.id
			})
		end) }),
		Footer = t5.footerItems and React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 3,
			footerItems = t5.footerItems
		})
	}) else React.createElement(Sheet.Content, nil, {
		Empty = React.createElement(View, {
			tag = "col align-x-center align-y-center gap-medium size-full"
		}, {
			Empty = React.createElement(TextWithTranslation, {
				tag = "auto-xy",
				LayoutOrder = 1,
				input = t5.emptyText
			}),
			ReportAMessageNotShown = React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy padding-small text-wrap text-align-x-center radius-medium",
				LayoutOrder = 2,
				Text = `<u>{ translateIntoString(t5.reportMessageNotShownText) }</u>`,
				onActivated = v79
			})
		})
	}) else React.createElement(ErrorContent, {
		retry = v67.retry,
		errorText = t5.errorText,
		retryButtonText = t5.retryButtonText
	}) else React.createElement(LoadingContent)

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Layout, {
			body = nil,
			actions = nil
		}),
		ChatSelectionSheet = React.createElement(Sheet.Root, {
			centerSheetHeight = 1,
			preferCenterSheet = true,
			ref = v77,
			isOpen = v55,
			size = DialogSize.Medium,
			snapPoints = { 0.9 },
			onClose = function() -- line: 542
				-- upvalues: v59 (copy), t5 (copy), v50 (copy), v52 (copy)
				if v59.current then
					v59.current = false

					if t5.onNext then
						t5.onNext(v50, v52.current)

						return
					end
				elseif t5.goBack then
					t5.goBack()
				end
			end
		}, {
			SheetHeader = React.createElement(Sheet.Header, nil, {
				Title = React.createElement(FoundationText, {
					tag = "align-x-left auto-xy text-title-large text-truncate-end content-emphasis",
					Text = translateIntoString(t5.title)
				})
			}),
			SheetContent = v80,
			SheetActions = if v67.loading or (v67.error or (v50 == nil or v50 == REPORT_MESSAGE_NOT_SHOWN_ITEM_ID and not (#v71 > 0))) then nil else React.createElement(Sheet.Actions, nil, {
				Button = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					text = translateIntoString(t5.nextButtonText),
					isLoading = t5.isSubmitting,
					isDisabled = t5.isSubmitting,
					fillBehavior = FillBehavior.Fill,
					onActivated = v73
				})
			})
		})
	})
end

return React.memo(InExpChatSelectionNode)
