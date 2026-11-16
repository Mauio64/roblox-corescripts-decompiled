local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

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
local Radius = Foundation.Enums.Radius
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
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
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation
local useLoader = require(GenericAbuseReporting.BeduiV2.Loaders.useLoader)
local useGroupedListLoader = useLoader.useGroupedListLoader

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local defineFastFlag = game:DefineFastFlag("FixChatSelectorDropdownPadding", false)

local function useScrollToSelected(state: string?, ref) -- 1 equivalent call inferred from this helper
	React.useEffect(function()
		if not state then
			return
		end

		local current = ref.current[state]

		if not current then
			return
		end

		local scrollingFrame = current:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not scrollingFrame then
			return
		end

		local flag = false

		local v = { current = scrollingFrame.Parent }
		local v2 = { current = current }

		local function performScroll() -- 2 equivalent calls inferred from this helper
			if flag then
				return
			end

			scrollToItem(v, v2)
		end

		if current.AbsoluteSize.Y > 0 then
			performScroll() -- inferred equivalent call
		else
			local absoluteSizeChangedConnection = nil
			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if current.AbsoluteSize.Y > 0 then
					absoluteSizeChangedConnection:Disconnect()
					performScroll() -- inferred equivalent call
				end
			end)

			task.delay(2, function()
				if absoluteSizeChangedConnection.Connected then
					absoluteSizeChangedConnection:Disconnect()
				end
			end)
		end

		return function()
			flag = true
		end
	end, { state })
end

local REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = useInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID

local function LoadingContent()
	local v = useTokens()

	return React.createElement(Sheet.Content, nil, {
		SkeletonContainer = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y" },
			Dash.map(table.create(5, true), function(_: boolean, p: number)
				return React.createElement(Skeleton, {
					key = tostring(p),
					radius = Radius.Medium,
					Size = UDim2.new(1, 0, 0, v.Size.Size_800)
				})
			end)
		)
	})
end

local function ErrorContent(props)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(Sheet.Content, nil, {
		ErrorContainer = React.createElement(View, {
			tag = "align-x-center align-y-center gap-medium size-full"
		}, {
			ErrorText = React.createElement(Text, {
				Text = translateIntoString(props.errorText),
				RichText = true,
				tag = "auto-xy text-body-medium text-wrap text-align-x-left"
			}),
			RetryButton = React.createElement(Button, {
				text = translateIntoString(props.retryButtonText),
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fit,
				onActivated = props.retry or function() end
			})
		})
	})
end

local function InExpChatSelectionNode(props)
	local state, setState = React.useState(props.initialValue or nil)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(true)
	local translateIntoString = useArTranslation().translateIntoString
	local ref2 = React.useRef({})
	local ref3 = React.useRef(false)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(false)
	local ref8 = React.useRef(false)

	local layout = useLayoutSlots().Layout

	local v = useGroupedListLoader(props.items)
	local data = v.data or {}
	useScrollToSelected(state, ref2) -- inferred equivalent call
	React.useEffect(function()
		local current = ref6.current

		if not current then
			return
		end

		local scrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not scrollingFrame then
			return
		end

		local function checkScrollbar() -- 1 equivalent call inferred from this helper
			ref4.current = scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y
		end

		local function onScroll()
			if scrollingFrame.CanvasPosition.Y > 0 then
				ref5.current = true
			end
		end

		checkScrollbar() -- inferred equivalent call
		local absoluteCanvasSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)

		local absoluteWindowSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local canvasPositionChangedConnection = scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { v.loading })

	React.useEffect(function()
		if v.error and not ref7.current then
			ref7.current = true
			local v2 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = formatErrorDetailForAnalytics("inExpChatSelection: load failed", v.error)
			else
				error_detail = {
					error_message = "inExpChatSelection: load failed: " .. v.error
				}
			end

			v2.error_detail = error_detail
			sendEvent(v2)
		end
	end, { v.error, sendEvent })

	local v2 = #data > 1
	local v3 = React.useMemo(function()
		if state2 then
			return state2
		end

		if not state then
			return data[1] and data[1].id or nil
		end

		for _, v3 in ipairs(data) do
			for _, item in ipairs(v3.items) do
				if item.id == state then
					return v3.id
				end
			end
		end

		return data[1] and data[1].id or nil
	end, { state2, state, data })

	local v4 = React.useMemo(function()
		if #data == 0 then
			return {}
		end

		local v4 = Dash.find(data, function(p): boolean
			return p.id == v3
		end)

		local result = props.reportMessageNotShownText and props.reportMessageNotShownText ~= "" and {
			{ id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID, label = props.reportMessageNotShownText }
		} or {}

		for _, v5 in ipairs(v4 and v4.items or {}) do
			table.insert(result, v5)
		end

		return result
	end, { data, v3, props.reportMessageNotShownText })
	local id

	if v4[#v4] then
		id = v4[#v4].id or nil
	else
		id = nil
	end

	React.useEffect(function()
		if state or not id then
			return
		end

		local current = ref2.current[id]

		if not current then
			return
		end

		local flag = false

		local function performScroll() -- 2 equivalent calls inferred from this helper
			if flag then
				return
			end

			scrollToItem(ref6, { current = current })
		end

		if current.AbsoluteSize.Y > 0 then
			performScroll() -- inferred equivalent call
		else
			local absoluteSizeChangedConnection = nil
			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if current.AbsoluteSize.Y > 0 then
					absoluteSizeChangedConnection:Disconnect()
					performScroll() -- inferred equivalent call
				end
			end)

			task.delay(2, function()
				if absoluteSizeChangedConnection.Connected then
					absoluteSizeChangedConnection:Disconnect()
				end
			end)
		end

		return function()
			flag = true
		end
	end, { id, state })

	React.useEffect(function()
		if not v.loading and not v.error and #v4 == 0 and not ref8.current then
			ref8.current = true
			sendEvent({ sub_event_type = telemetryEventType.EmptyState })
		end
	end, { v.loading, v.error, v4, sendEvent })

	local onActivated = React.useCallback(function()
		ref3.current = true
		setState3(false)
	end, {})

	local v5 = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(false)

	local ref9 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v5, not state4)

	local items = React.useMemo(function()
		return Dash.map(data, function(p)
			return { id = p.id, text = p.label }
		end)
	end, { data })

	local onActivated2 = React.useCallback(function()
		setState(REPORT_MESSAGE_NOT_SHOWN_ITEM_ID)
		ref.current = {
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = props.reportMessageNotShownText
		}
		onActivated()
	end, { onActivated })
	local sheetContent

	if v.loading then
		sheetContent = React.createElement(LoadingContent)
	elseif v.error then
		sheetContent = React.createElement(ErrorContent, {
			retry = v.retry,
			errorText = props.errorText,
			retryButtonText = props.retryButtonText
		})
	elseif #v4 == 0 then
		sheetContent = React.createElement(Sheet.Content, nil, {
			Empty = React.createElement(View, {
				tag = "col align-x-center align-y-center gap-medium size-full"
			}, {
				Empty = React.createElement(TextWithTranslation, {
					input = props.emptyText,
					tag = "auto-xy",
					LayoutOrder = 1
				}),
				ReportAMessageNotShown = React.createElement(Text, {
					Text = `<u>{translateIntoString(props.reportMessageNotShownText)}</u>`,
					RichText = true,
					tag = "auto-xy padding-small text-wrap text-align-x-center radius-medium",
					onActivated = onActivated2,
					LayoutOrder = 2
				})
			})
		})
	else
		local createElement = React.createElement
		local content = Sheet.Content
		local channelDropdown

		if defineFastFlag and v2 then
			channelDropdown = React.createElement(
				View,
				{ tag = "auto-xy padding-x-xlarge padding-top-xsmall", LayoutOrder = 1 },
				React.createElement(InExpDropdownWithPopover, {
					value = v3,
					items = items,
					LayoutOrder = 1,
					onOpenChange = setState4,
					onItemChanged = function(p)
						local new_channel_name = tostring(p)
						setState(nil)
						setState2(new_channel_name)
						sendEvent({
							sub_event_type = telemetryEventType.TextChannelSwitch,
							text_channel_switch_detail = {
								previous_channel_name = v3 or "",
								new_channel_name = new_channel_name,
								channel_count = #data
							}
						})
					end
				})
			)
		elseif v2 then
			channelDropdown = React.createElement(InExpDropdownWithPopover, {
				value = v3,
				items = items,
				LayoutOrder = 1,
				onOpenChange = setState4,
				onItemChanged = function(p)
					local new_channel_name = tostring(p)
					setState(nil)
					setState2(new_channel_name)
					sendEvent({
						sub_event_type = telemetryEventType.TextChannelSwitch,
						text_channel_switch_detail = {
							previous_channel_name = v3 or "",
							new_channel_name = new_channel_name,
							channel_count = #data
						}
					})
				end
			})
		end

		sheetContent = createElement(content, { isContentFullBleed = true, ref = ref6 }, {
			ChannelDropdown = channelDropdown,
			ItemList = React.createElement(List.Root, {
				hasDivider = { hasDivider = true, isInset = false },
				isContained = { isContained = false, hasMargin = true },
				LayoutOrder = 2
			}, { Dash.map(v4, function(props2, p: number)
					local trailing

					if props2.meta and props2.meta.presetId and props2.meta.presetId ~= "" then
						trailing = React.createElement(Icon, {
							name = IconName.LightningBolt,
							variant = IconVariant.Filled
						})
					end

					return React.createElement(List.Item, {
						description = translateIntoString(props2.label),
						trailing = trailing,
						onActivated = {
							onActivated = function()
								setState(props2.id)
								ref.current = props2
								sendEvent({
									sub_event_type = telemetryEventType.SelectItem,
									select_item_detail = {
										selected_index = p,
										selected_id = props2.id,
										list_length = #v4,
										has_scroll = ref4.current,
										did_scroll = ref5.current
									}
								})
							end,
							inputType = ListItemInputType.Radio,
							isChecked = state == props2.id
						},
						LayoutOrder = p,
						ref = function(p2)
							ref2.current[props2.id] = p2
						end,
						key = props2.id
					})
				end) }),
			Footer = props.footerItems and React.createElement(Footer, {
				footerItems = props.footerItems,
				additionalTag = "padding-top-medium",
				layoutOrder = 3
			})
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v6 = {
		Content = React.createElement(layout, { body = nil, actions = nil }),
		ChatSelectionSheet = 0
	}
	local createElement2 = React.createElement
	local root = Sheet.Root
	local v7 = {
		ref = ref9,
		isOpen = state3,
		centerSheetHeight = 1,
		size = DialogSize.Medium,
		preferCenterSheet = true,
		snapPoints = { 0.9 },
		onClose = function()
			if ref3.current then
				ref3.current = false

				if props.onNext then
					props.onNext(state, ref.current)
				end
			elseif props.goBack then
				props.goBack()
			end
		end
	}
	local v8 = {
		SheetHeader = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				tag = "align-x-left auto-xy text-title-large text-truncate-end content-emphasis",
				Text = translateIntoString(props.title)
			})
		}),
		SheetContent = sheetContent,
		SheetActions = 0
	}
	local sheetActions

	if not (v.loading or v.error or state == nil or state == REPORT_MESSAGE_NOT_SHOWN_ITEM_ID and not (#v4 > 0)) then
		sheetActions = React.createElement(Sheet.Actions, nil, {
			Button = React.createElement(Button, {
				variant = ButtonVariant.Emphasis,
				text = translateIntoString(props.nextButtonText),
				isLoading = props.isSubmitting,
				isDisabled = props.isSubmitting,
				fillBehavior = FillBehavior.Fill,
				onActivated = onActivated
			})
		})
	end

	v8.SheetActions = sheetActions
	v6.ChatSelectionSheet = createElement2(root, v7, v8)
	return createElement(fragment, nil, v6)
end

return React.memo(InExpChatSelectionNode)
