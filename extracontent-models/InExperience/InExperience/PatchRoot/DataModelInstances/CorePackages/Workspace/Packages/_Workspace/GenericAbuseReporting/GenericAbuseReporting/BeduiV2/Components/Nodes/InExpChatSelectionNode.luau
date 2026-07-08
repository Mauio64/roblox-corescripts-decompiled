local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
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

local function useScrollToSelected(s1: string?, t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), scrollToItem (copy)
	React.useEffect(function() -- line: 46
		-- upvalues: s1 (copy), t1 (copy), scrollToItem (copy)
		if not s1 then
			return
		end

		local v79 = t1.current[s1]

		if not v79 then
			return
		end

		local ScrollingFrame = v79:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u81 = false
		local t2 = {
			current = ScrollingFrame.Parent
		}
		local t3 = {
			current = v79
		}

		local function performScroll() -- line: 68
			-- upvalues: u81 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
			if u81 then
				return
			end

			scrollToItem(t2, t3)
		end

		if v79.AbsoluteSize.Y > 0 then
			if not u81 then
				scrollToItem(t2, t3)
			end
		else
			local connection = nil

			connection = v79:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 80
				-- upvalues: v79 (copy), connection (ref), u81 (ref), scrollToItem (copy), t2 (copy), t3 (copy)
				if v79.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u81 then
						return
					end

					scrollToItem(t2, t3)
				end
			end)
			task.delay(2, function() -- line: 87
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 94
			-- upvalues: u81 (ref)
			u81 = true
		end
	end, { s1 })
end

local REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = useInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID

local function LoadingContent() -- line: 135
	-- upvalues: useTokens (copy), React (copy), Sheet (copy), View (copy), Dash (copy), Skeleton (copy), EnumsRadius (copy)
	local v44 = useTokens()

	return React.createElement(Sheet.Content, nil, {
		SkeletonContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y"
		}, Dash.map(table.create(5, true), function(_: boolean, n1: number) -- line: 142
			-- upvalues: React (copy), Skeleton (copy), EnumsRadius (copy), v44 (copy)
			return React.createElement(Skeleton, {
				key = tostring(n1),
				radius = EnumsRadius.Medium,
				Size = UDim2.new(1, 0, 0, v44.Size.Size_800)
			})
		end))
	})
end
local function ErrorContent(t4: {[any]: any}) -- line: 153
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
				onActivated = t4.retry or function() -- line: 173
				end
			})
		})
	})
end
local function InExpChatSelectionNode(t5: {[any]: any}) -- line: 185
	-- upvalues: React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), useGroupedListLoader (copy), scrollToItem (copy), TelemetryEventType (copy), Dash (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), LoadingContent (copy), ErrorContent (copy), Sheet (copy), View (copy), TextWithTranslation (copy), FoundationText (copy), InExpDropdownWithPopover (copy), List (copy), Icon (copy), IconName (copy), IconVariant (copy), ListItemInputType (copy), Footer (copy), DialogSize (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v48, v49 = React.useState(t5.initialValue or nil)
	local v50 = React.useRef(nil)
	local v51, v52 = React.useState(nil)
	local v53, v54 = React.useState(true)
	local translateIntoString = useArTranslation().translateIntoString
	local v56 = React.useRef({})
	local v57 = React.useRef(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v59 = React.useRef(false)
	local v60 = React.useRef(false)
	local v61 = React.useRef(nil)
	local v62 = React.useRef(false)
	local v63 = React.useRef(false)
	local Layout = useLayoutSlots().Layout
	local v65 = useGroupedListLoader(t5.items)
	local v66 = v65.data or {}

	React.useEffect(function() -- line: 46
		-- upvalues: v48 (copy), v56 (copy), scrollToItem (copy)
		if not v48 then
			return
		end

		local v88 = v56.current[v48]

		if not v88 then
			return
		end

		local ScrollingFrame = v88:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not ScrollingFrame then
			return
		end

		local u90 = false
		local t6 = {
			current = ScrollingFrame.Parent
		}
		local t7 = {
			current = v88
		}

		local function performScroll() -- line: 68
			-- upvalues: u90 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
			if u90 then
				return
			end

			scrollToItem(t6, t7)
		end

		if v88.AbsoluteSize.Y > 0 then
			if not u90 then
				scrollToItem(t6, t7)
			end
		else
			local connection = nil

			connection = v88:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 80
				-- upvalues: v88 (copy), connection (ref), u90 (ref), scrollToItem (copy), t6 (copy), t7 (copy)
				if v88.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u90 then
						return
					end

					scrollToItem(t6, t7)
				end
			end)
			task.delay(2, function() -- line: 87
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 94
			-- upvalues: u90 (ref)
			u90 = true
		end
	end, { v48 })
	React.useEffect(function() -- line: 209
		-- upvalues: v61 (copy), v59 (copy), v60 (copy)
		local current = v61.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 220
			-- upvalues: v59 (copy), ScrollingFrame (copy)
			v59.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y
		end
		local function onScroll() -- line: 224
			-- upvalues: ScrollingFrame (copy), v60 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v60.current = true
			end
		end

		v59.current = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 237
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v65.loading })
	React.useEffect(function() -- line: 244
		-- upvalues: v65 (copy), v62 (copy), sendEvent (copy), TelemetryEventType (copy)
		if v65.error and not v62.current then
			v62.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "inExpChatSelection: load failed: " .. v65.error
				}
			})
		end
	end, {
		v65.error,
		sendEvent
	})

	local v67 = #v66 > 1
	local v68 = React.useMemo(function() -- line: 255
		-- upvalues: v51 (copy), v48 (copy), v66 (copy)
		if v51 then
			return v51
		end

		if v48 then
			for _, v in ipairs(v66) do
				for _, v2 in ipairs(v.items) do
					if v2.id == v48 then
						return v.id
					end
				end
			end
		end

		return v66[1] and v66[1].id or nil
	end, {
		v51,
		v48,
		v66
	})
	local v69 = React.useMemo(function() -- line: 271
		-- upvalues: v66 (copy), Dash (copy), v68 (copy), t5 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy)
		if #v66 == 0 then
			return {}
		end

		local v106 = Dash.find(v66, function(p1) -- line: 275
			-- upvalues: v68 (copy)
			return p1.id == v68
		end)
		local v107 = if not t5.reportMessageNotShownText or t5.reportMessageNotShownText == "" then {} else {{
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}}

		for _, v in ipairs(v106 and v106.items or {}) do
			table.insert(v107, v)
		end

		return v107
	end, {
		v66,
		v68,
		t5.reportMessageNotShownText
	})
	local v70 = v69[#v69] and v69[#v69].id or nil

	React.useEffect(function() -- line: 296
		-- upvalues: v48 (copy), v70 (copy), v56 (copy), scrollToItem (copy), v61 (copy)
		if v48 then
			return
		end

		if not v70 then
			return
		end

		local v110 = v56.current[v70]

		if not v110 then
			return
		end

		local u111 = false

		local function performScroll() -- line: 311
			-- upvalues: u111 (ref), scrollToItem (copy), v61 (copy), v110 (copy)
			if u111 then
				return
			end

			scrollToItem(v61, {
				current = v110
			})
		end

		if v110.AbsoluteSize.Y > 0 then
			if not u111 then
				scrollToItem(v61, {
					current = v110
				})
			end
		else
			local connection = nil

			connection = v110:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 322
				-- upvalues: v110 (copy), connection (ref), u111 (ref), scrollToItem (copy), v61 (copy)
				if v110.AbsoluteSize.Y > 0 then
					connection:Disconnect()

					if u111 then
						return
					end

					scrollToItem(v61, {
						current = v110
					})
				end
			end)
			task.delay(2, function() -- line: 330
				-- upvalues: connection (ref)
				if connection.Connected then
					connection:Disconnect()
				end
			end)
		end

		return function() -- line: 337
			-- upvalues: u111 (ref)
			u111 = true
		end
	end, {
		v70,
		v48
	})
	React.useEffect(function() -- line: 342
		-- upvalues: v65 (copy), v69 (copy), v63 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not v65.loading and (not v65.error and #v69 == 0 and not v63.current) then
			v63.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.EmptyState
			})
		end
	end, {
		v65.loading,
		v65.error,
		v69,
		sendEvent
	})

	local v71 = React.useCallback(function() -- line: 356
		-- upvalues: v57 (copy), v54 (copy)
		v57.current = true
		v54(false)
	end, {})
	local v72 = React.useCallback(function() -- line: 361
		-- upvalues: v54 (copy)
		v54(false)
	end, {})
	local v73, v74 = React.useState(false)
	local v75 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v72, not v73)
	local v76 = React.useMemo(function() -- line: 376
		-- upvalues: Dash (copy), v66 (copy)
		return Dash.map(v66, function(t8: {[any]: any}) -- line: 377
			return {
				id = t8.id,
				text = t8.label
			}
		end)
	end, { v66 })
	local v77 = React.useCallback(function() -- line: 382
		-- upvalues: v49 (copy), REPORT_MESSAGE_NOT_SHOWN_ITEM_ID (copy), v50 (copy), t5 (copy), v71 (copy)
		v49(REPORT_MESSAGE_NOT_SHOWN_ITEM_ID)
		v50.current = {
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = t5.reportMessageNotShownText
		}
		v71()
	end, { v71 })
	local v78 = if not v65.loading then if not v65.error then if #v69 ~= 0 then React.createElement(Sheet.Content, {
		isContentFullBleed = true,
		ref = v61
	}, {
		ChannelDropdown = if not v67 then nil else React.createElement(InExpDropdownWithPopover, {
			LayoutOrder = 1,
			value = v68,
			items = v76,
			onOpenChange = v74,
			onItemChanged = function(p2) -- line: 428
				-- upvalues: v68 (copy), v49 (copy), v52 (copy), sendEvent (copy), TelemetryEventType (copy), v66 (copy)
				local v115 = v68 or ""
				local str = tostring(p2)

				v49(nil)
				v52(str)
				sendEvent({
					sub_event_type = TelemetryEventType.TextChannelSwitch,
					text_channel_switch_detail = {
						previous_channel_name = v115,
						new_channel_name = str,
						channel_count = #v66
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
		}, { Dash.map(v69, function(p3, n2: number) -- line: 455
			-- upvalues: React (copy), Icon (copy), IconName (copy), IconVariant (copy), List (copy), translateIntoString (copy), v49 (copy), v50 (copy), sendEvent (copy), TelemetryEventType (copy), v69 (copy), v59 (copy), v60 (copy), ListItemInputType (copy), v48 (copy), v56 (copy)
			local v119 = nil

			if p3.meta and (p3.meta.presetId and p3.meta.presetId ~= "") then
				v119 = React.createElement(Icon, {
					name = IconName.LightningBolt,
					variant = IconVariant.Filled
				})
			end

			return React.createElement(List.Item, {
				description = translateIntoString(p3.label),
				trailing = v119,
				onActivated = {
					onActivated = function() -- line: 468
						-- upvalues: v49 (copy), p3 (copy), v50 (copy), sendEvent (copy), TelemetryEventType (copy), n2 (copy), v69 (copy), v59 (copy), v60 (copy)
						v49(p3.id)
						v50.current = p3
						sendEvent({
							sub_event_type = TelemetryEventType.SelectItem,
							select_item_detail = {
								selected_index = n2,
								list_length = #v69,
								has_scroll = v59.current,
								did_scroll = v60.current
							}
						})
					end,
					inputType = ListItemInputType.Radio,
					isChecked = v48 == p3.id
				},
				LayoutOrder = n2,
				ref = function(p4) -- line: 485
					-- upvalues: v56 (copy), p3 (copy)
					v56.current[p3.id] = p4
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
				onActivated = v77
			})
		})
	}) else React.createElement(ErrorContent, {
		retry = v65.retry,
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
			ref = v75,
			isOpen = v53,
			size = DialogSize.Medium,
			snapPoints = { 0.9 },
			onClose = function() -- line: 510
				-- upvalues: v57 (copy), t5 (copy), v48 (copy), v50 (copy)
				if v57.current then
					v57.current = false

					if t5.onNext then
						t5.onNext(v48, v50.current)

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
			SheetContent = v78,
			SheetActions = if v65.loading or (v65.error or (v48 == nil or v48 == REPORT_MESSAGE_NOT_SHOWN_ITEM_ID and not (#v69 > 0))) then nil else React.createElement(Sheet.Actions, nil, {
				Button = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					text = translateIntoString(t5.nextButtonText),
					isLoading = t5.isSubmitting,
					isDisabled = t5.isSubmitting,
					fillBehavior = FillBehavior.Fill,
					onActivated = v71
				})
			})
		})
	})
end

return React.memo(InExpChatSelectionNode)
