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

local function useScrollToSelected(s1: string?, t1: {[any]: any}) -- line: 47
	-- upvalues: React (copy), scrollToItem (copy)
	React.useEffect(function() -- line: 48
		-- upvalues: s1 (copy), t1 (copy), scrollToItem (copy)
		if not s1 then
			return
		end

		local v80 = t1.current[s1]

		if not v80 then
			return
		end

		local ScrollingFrame = v80:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u82 = false
		local t2 = {
			current = ScrollingFrame.Parent
		}
		local t3 = {
			current = v80
		}

		local function performScroll() -- line: 70
			-- upvalues: u82 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
			if u82 then
				return
			end

			scrollToItem(t2, t3)
		end

		if v80.AbsoluteSize.Y > 0 then
			if not u82 then
				scrollToItem(t2, t3)
			end
		else
			local connection = nil

			connection = v80:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 82
				-- upvalues: v80 (copy), connection (ref), u82 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
				if v80.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u82 then
						return
					end

					scrollToItem(t2, t3)
				end
			end)
			task.delay(2, function() -- line: 89
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 96
			-- upvalues: u82 (ref)
			u82 = true
		end
	end, { s1 })
end

local REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = useInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID

local function LoadingContent() -- line: 137
	-- upvalues: useTokens (copy), React (copy), Sheet (copy), View (copy), Dash (copy), Skeleton (copy), EnumsRadius (copy)
	local v45 = useTokens()

	return React.createElement(Sheet.Content, nil, {
		SkeletonContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y"
		}, Dash.map(table.create(5, true), function(_: boolean, n1: number) -- line: 144
			-- upvalues: React (copy), Skeleton (copy), EnumsRadius (copy), v45 (copy)
			return React.createElement(Skeleton, {
				key = tostring(n1),
				radius = EnumsRadius.Medium,
				Size = UDim2.new(1, 0, 0, v45.Size.Size_800)
			})
		end))
	})
end
local function ErrorContent(t4: {[any]: any}) -- line: 155
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
				onActivated = t4.retry or function() -- line: 175
				end
			})
		})
	})
end
local function InExpChatSelectionNode(t5: {[any]: any}) -- line: 187
	-- upvalues: React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), useGroupedListLoader (copy), scrollToItem (copy), TelemetryEventType (copy), Dash (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), LoadingContent (copy), ErrorContent (copy), Sheet (copy), View (copy), TextWithTranslation (copy), FoundationText (copy), InExpDropdownWithPopover (copy), List (copy), Icon (copy), IconName (copy), IconVariant (copy), FFlagAbuseReportSelectItemAddId (copy), ListItemInputType (copy), Footer (copy), DialogSize (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v49, v50 = React.useState(t5.initialValue or nil)
	local v51 = React.useRef(nil)
	local v52, v53 = React.useState(nil)
	local v54, v55 = React.useState(true)
	local translateIntoString = useArTranslation().translateIntoString
	local v57 = React.useRef({})
	local v58 = React.useRef(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v60 = React.useRef(false)
	local v61 = React.useRef(false)
	local v62 = React.useRef(nil)
	local v63 = React.useRef(false)
	local v64 = React.useRef(false)
	local Layout = useLayoutSlots().Layout
	local v66 = useGroupedListLoader(t5.items)
	local v67 = v66.data or {}

	React.useEffect(function() -- line: 48
		-- upvalues: v49 (copy), v57 (copy), scrollToItem (copy)
		if not v49 then
			return
		end

		local v89 = v57.current[v49]

		if not v89 then
			return
		end

		local ScrollingFrame = v89:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u91 = false
		local t6 = {
			current = ScrollingFrame.Parent
		}
		local t7 = {
			current = v89
		}

		local function performScroll() -- line: 70
			-- upvalues: u91 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
			if u91 then
				return
			end

			scrollToItem(t6, t7)
		end

		if v89.AbsoluteSize.Y > 0 then
			if not u91 then
				scrollToItem(t6, t7)
			end
		else
			local connection = nil

			connection = v89:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 82
				-- upvalues: v89 (copy), connection (ref), u91 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
				if v89.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u91 then
						return
					end

					scrollToItem(t6, t7)
				end
			end)
			task.delay(2, function() -- line: 89
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 96
			-- upvalues: u91 (ref)
			u91 = true
		end
	end, { v49 })
	React.useEffect(function() -- line: 211
		-- upvalues: v62 (copy), v60 (copy), v61 (copy)
		local current = v62.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 222
			-- upvalues: v60 (copy), ScrollingFrame (copy)
			v60.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y
		end
		local function onScroll() -- line: 226
			-- upvalues: ScrollingFrame (copy), v61 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v61.current = true
			end
		end

		v60.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 239
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v66.loading })
	React.useEffect(function() -- line: 246
		-- upvalues: v66 (copy), v63 (copy), sendEvent (copy), TelemetryEventType (copy)
		if v66.error and not v63.current then
			v63.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "inExpChatSelection: load failed: " .. v66.error
				}
			})
		end
	end, {
		v66.error,
		sendEvent
	})

	local v68 = #v67 > 1
	local v69 = React.useMemo(function() -- line: 257
		-- upvalues: v52 (copy), v49 (copy), v67 (copy)
		if v52 then
			return v52
		end

		if v49 then
			for _, v in ipairs(v67) do
				for _, v2 in ipairs(v.items) do
					if v2.id == v49 then
						return v.id
					end
				end
			end
		end

		return v67[1] and v67[1].id or nil
	end, {
		v52,
		v49,
		v67
	})
	local v70 = React.useMemo(function() -- line: 273
		-- upvalues: v67 (copy), Dash (copy), v69 (copy), t5 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy)
		if #v67 == 0 then
			return {}
		end

		local v107 = Dash.find(v67, function(p1) -- line: 277
			-- upvalues: v69 (copy)
			return p1.id == v69
		end)
		local v108 = if not t5.reportMessageNotShownText or t5.reportMessageNotShownText == "" then {} else {{
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}}

		for _, v in ipairs(v107 and v107.items or {}) do
			table.insert(v108, v)
		end

		return v108
	end, {
		v67,
		v69,
		t5.reportMessageNotShownText
	})
	local v71 = v70[#v70] and v70[#v70].id or nil

	React.useEffect(function() -- line: 298
		-- upvalues: v49 (copy), v71 (copy), v57 (copy), scrollToItem (copy), v62 (copy)
		if v49 then
			return
		end

		if not v71 then
			return
		end

		local v111 = v57.current[v71]

		if not v111 then
			return
		end

		local u112 = false

		local function performScroll() -- line: 313
			-- upvalues: u112 (ref), scrollToItem (copy), v62 (copy), v111 (copy)
			if u112 then
				return
			end

			scrollToItem(v62, {
				current = v111
			})
		end

		if v111.AbsoluteSize.Y > 0 then
			if not u112 then
				scrollToItem(v62, {
					current = v111
				})
			end
		else
			local connection = nil

			connection = v111:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 324
				-- upvalues: v111 (copy), connection (ref), u112 (ref), scrollToItem (copy), v62 (copy)
				if v111.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u112 then
						return
					end

					scrollToItem(v62, {
						current = v111
					})
				end
			end)
			task.delay(2, function() -- line: 332
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 339
			-- upvalues: u112 (ref)
			u112 = true
		end
	end, {
		v71,
		v49
	})
	React.useEffect(function() -- line: 344
		-- upvalues: v66 (copy), v70 (copy), v64 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not v66.loading and (not v66.error and #v70 == 0 and not v64.current) then
			v64.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.EmptyState
			})
		end
	end, {
		v66.loading,
		v66.error,
		v70,
		sendEvent
	})

	local v72 = React.useCallback(function() -- line: 358
		-- upvalues: v58 (copy), v55 (copy)
		v58.current = true
		v55(false)
	end, {})
	local v73 = React.useCallback(function() -- line: 363
		-- upvalues: v55 (copy)
		v55(false)
	end, {})
	local v74, v75 = React.useState(false)
	local v76 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v73, not v74)
	local v77 = React.useMemo(function() -- line: 378
		-- upvalues: Dash (copy), v67 (copy)
		return Dash.map(v67, function(t8: {[any]: any}) -- line: 379
			return {
				id = t8.id,
				text = t8.label
			}
		end)
	end, { v67 })
	local v78 = React.useCallback(function() -- line: 384
		-- upvalues: v50 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), v51 (copy), t5 (copy), v72 (copy)
		v50(REPORT_MESSAGE_NOT_SHOWN_ITEM_ID)
		v51.current = {
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}
		v72()
	end, { v72 })
	local v79 = if not v66.loading then if not v66.error then if #v70 ~= 0 then React.createElement(Sheet.Content, {
		isContentFullBleed = true,
		ref = v62
	}, {
		ChannelDropdown = if not v68 then nil else React.createElement(InExpDropdownWithPopover, {
			LayoutOrder = 1,
			value = v69,
			items = v77,
			onOpenChange = v75,
			onItemChanged = function(p2) -- line: 430
				-- upvalues: v69 (copy), v50 (copy), v53 (copy), sendEvent (copy), TelemetryEventType (copy), v67 (copy)
				local v116 = v69 or ""
				local str = tostring(p2)

				v50(nil)
				v53(str)
				sendEvent({
					sub_event_type = TelemetryEventType.TextChannelSwitch,
					text_channel_switch_detail = {
						previous_channel_name = v116,
						new_channel_name = str,
						channel_count = #v67
					}
				})
			end
		}),
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
		}, { Dash.map(v70, function(p3, n2: number) -- line: 457
			-- upvalues: React (copy), Icon (copy), IconName (copy), IconVariant (copy), List (copy), translateIntoString (copy), v50 (copy), v51 (copy), sendEvent (copy), TelemetryEventType (copy), FFlagAbuseReportSelectItemAddId (copy), v70 (copy), v60 (copy), v61 (copy), ListItemInputType (copy), v49 (copy), v57 (copy)
			local v120 = nil

			if p3.meta and (p3.meta.presetId and p3.meta.presetId ~= "") then
				v120 = React.createElement(Icon, {
					name = IconName.LightningBolt,
					variant = IconVariant.Filled
				})
			end

			return React.createElement(List.Item, {
				description = translateIntoString(p3.label),
				trailing = v120,
				onActivated = {
					onActivated = function() -- line: 470
						-- upvalues: v50 (copy), p3 (copy), v51 (copy), sendEvent (copy), TelemetryEventType (copy), n2 (copy), FFlagAbuseReportSelectItemAddId (copy), v70 (copy), v60 (copy), v61 (copy)
						v50(p3.id)
						v51.current = p3
						sendEvent({
							sub_event_type = TelemetryEventType.SelectItem,
							select_item_detail = {
								selected_index = n2,
								selected_id = if not FFlagAbuseReportSelectItemAddId then nil else p3.id,
								list_length = #v70,
								has_scroll = v60.current,
								did_scroll = v61.current
							}
						})
					end,
					inputType = ListItemInputType.Radio,
					isChecked = v49 == p3.id
				},
				LayoutOrder = n2,
				ref = function(p4) -- line: 488
					-- upvalues: v57 (copy), p3 (copy)
					v57.current[p3.id] = p4
				end,
				key = p3.id
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
				onActivated = v78
			})
		})
	}) else React.createElement(ErrorContent, {
		retry = v66.retry,
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
			ref = v76,
			isOpen = v54,
			size = DialogSize.Medium,
			snapPoints = { 0.9 },
			onClose = function() -- line: 513
				-- upvalues: v58 (copy), t5 (copy), v49 (copy), v51 (copy)
				if v58.current then
					v58.current = false

					if t5.onNext then
						t5.onNext(v49, v51.current)

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
			SheetContent = v79,
			SheetActions = if v66.loading or (v66.error or (v49 == nil or v49 == REPORT_MESSAGE_NOT_SHOWN_ITEM_ID and not (#v70 > 0))) then nil else React.createElement(Sheet.Actions, nil, {
				Button = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					text = translateIntoString(t5.nextButtonText),
					isLoading = t5.isSubmitting,
					isDisabled = t5.isSubmitting,
					fillBehavior = FillBehavior.Fill,
					onActivated = v72
				})
			})
		})
	})
end

return React.memo(InExpChatSelectionNode)
