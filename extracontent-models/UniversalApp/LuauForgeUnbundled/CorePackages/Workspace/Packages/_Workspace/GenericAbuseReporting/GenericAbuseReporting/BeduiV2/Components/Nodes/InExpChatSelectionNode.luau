local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local dialogSize = Foundation.Enums.DialogSize
local fillBehavior = Foundation.Enums.FillBehavior
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local list = Foundation.List
local listItemInputType = Foundation.Enums.ListItemInputType
local radius = Foundation.Enums.Radius
local sheet = Foundation.Sheet
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local useInExpCustomSubmit = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useInExpCustomSubmit")
local useInExpFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useInExpFocusNavigationRefs")

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local InExpDropdownWithPopover = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/InExpDropdownWithPopover")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local scrollToItem = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/scrollToItem")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation
local useGroupedListLoader = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/useLoader").useGroupedListLoader

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local defineFastFlag = game:DefineFastFlag("FixChatSelectorDropdownPadding", false)

local function useScrollToSelected(p2, p3)
	React.useEffect(function()
		if not p2 then
			return
		end

		local v5 = p3.current[p2]

		if not v5 then
			return
		end

		local scrollingFrame = v5:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not scrollingFrame then
			return
		end

		local flag = false

		local v6 = { current = scrollingFrame.Parent }
		local v7 = { current = v5 }

		local function performScroll()
			if flag then
				return
			end

			scrollToItem(v6, v7)
		end

		if v5.AbsoluteSize.Y > 0 then
			if not flag then
				scrollToItem(v6, v7)
			end
		else
			local absoluteSizeChangedConnection = nil
			absoluteSizeChangedConnection = v5:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if v5.AbsoluteSize.Y > 0 then
					absoluteSizeChangedConnection:Disconnect()

					if flag then
						return
					end

					scrollToItem(v6, v7)
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
	end, { p2 })
end

local REPORT_MESSAGE_NOT_SHOWN_ITEM_ID = useInExpCustomSubmit.REPORT_MESSAGE_NOT_SHOWN_ITEM_ID

local function LoadingContent()
	local v5 = useTokens()

	return React.createElement(sheet.Content, nil, {
		SkeletonContainer = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y" },
			Dash.map(table.create(5, true), function(p2, p3)
				return React.createElement(skeleton, {
					key = tostring(p3),
					radius = radius.Medium,
					Size = UDim2.new(1, 0, 0, v5.Size.Size_800)
				})
			end)
		)
	})
end

local function ErrorContent(props)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(sheet.Content, nil, {
		ErrorContainer = React.createElement(
			view,
			{ tag = "align-x-center align-y-center gap-medium size-full" },
			{
				ErrorText = React.createElement(text, {
					Text = translateIntoString(props.errorText),
					RichText = true,
					tag = "auto-xy text-body-medium text-wrap text-align-x-left"
				}),
				RetryButton = React.createElement(button, {
					text = translateIntoString(props.retryButtonText),
					variant = buttonVariant.Standard,
					fillBehavior = fillBehavior.Fit,
					onActivated = props.retry or function() end
				})
			}
		)
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

	local v5 = useGroupedListLoader(props.items)
	local data = v5.data or {}
	React.useEffect(function()
		if not state then
			return
		end

		local v6 = ref2.current[state]

		if not v6 then
			return
		end

		local scrollingFrame = v6:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not scrollingFrame then
			return
		end

		local flag = false

		local v7 = { current = scrollingFrame.Parent }
		local v8 = { current = v6 }

		local function performScroll()
			if flag then
				return
			end

			scrollToItem(v7, v8)
		end

		if v6.AbsoluteSize.Y > 0 then
			if not flag then
				scrollToItem(v7, v8)
			end
		else
			local absoluteSizeChangedConnection = nil
			absoluteSizeChangedConnection = v6:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if v6.AbsoluteSize.Y > 0 then
					absoluteSizeChangedConnection:Disconnect()

					if flag then
						return
					end

					scrollToItem(v7, v8)
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

	React.useEffect(function()
		local current = ref6.current

		if not current then
			return
		end

		local scrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not scrollingFrame then
			return
		end

		local function checkScrollbar()
			ref4.current = scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y
		end

		local function onScroll()
			if scrollingFrame.CanvasPosition.Y > 0 then
				ref5.current = true
			end
		end

		ref4.current = scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y

		local absoluteCanvasSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)

		local absoluteWindowSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local canvasPositionChangedConnection = scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { v5.loading })

	React.useEffect(function()
		if v5.error and not ref7.current then
			ref7.current = true
			local v7 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v8 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics(
				"inExpChatSelection: load failed",
				v5.error
			) else {
				error_message = "inExpChatSelection: load failed: " .. v5.error
			}
			v7.error_detail = v8
			sendEvent(v7)
		end
	end, { v5.error, sendEvent })

	local v6 = #data > 1
	local v7 = React.useMemo(function()
		if state2 then
			return state2
		end

		if not state then
			return data[1] and data[1].id or nil
		end

		for i, v8 in ipairs(data) do
			for j, item in ipairs(v8.items) do
				if item.id == state then
					return v8.id
				end
			end
		end

		return data[1] and data[1].id or nil
	end, { state2, state, data })

	local v8 = React.useMemo(function()
		if #data == 0 then
			return {}
		end

		local v9 = Dash.find(data, function(p2): boolean
			return p2.id == v7
		end)

		local result = props.reportMessageNotShownText and props.reportMessageNotShownText ~= "" and {
			{
				id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
				label = props.reportMessageNotShownText
			}
		} or {}

		for i, v10 in ipairs(v9 and v9.items or {}) do
			table.insert(result, v10)
		end

		return result
	end, { data, v7, props.reportMessageNotShownText })

	local id = if v8[#v8] then v8[#v8].id or nil else nil
	React.useEffect(function()
		if state or not id then
			return
		end

		local v9 = ref2.current[id]

		if not v9 then
			return
		end

		local flag = false

		local function performScroll()
			if flag then
				return
			end

			scrollToItem(ref6, { current = v9 })
		end

		if v9.AbsoluteSize.Y > 0 then
			if not flag then
				scrollToItem(ref6, { current = v9 })
			end
		else
			local absoluteSizeChangedConnection = nil
			absoluteSizeChangedConnection = v9:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if v9.AbsoluteSize.Y > 0 then
					absoluteSizeChangedConnection:Disconnect()

					if flag then
						return
					end

					scrollToItem(ref6, { current = v9 })
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
		if not v5.loading and not v5.error and #v8 == 0 and not ref8.current then
			ref8.current = true
			sendEvent({ sub_event_type = telemetryEventType.EmptyState })
		end
	end, { v5.loading, v5.error, v8, sendEvent })

	local v9 = React.useCallback(function()
		ref3.current = true
		setState3(false)
	end, {})

	local v10 = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(false)

	local v11 = useInExpFocusNavigationRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, v10, not state4)

	local v12 = React.useMemo(function()
		return Dash.map(data, function(p2)
			return { id = p2.id, text = p2.label }
		end)
	end, { data })

	local v13 = React.useCallback(function()
		setState(REPORT_MESSAGE_NOT_SHOWN_ITEM_ID)
		ref.current = {
			id = REPORT_MESSAGE_NOT_SHOWN_ITEM_ID,
			label = props.reportMessageNotShownText
		}
		v9()
	end, { v9 })
	local v14

	if v5.loading then
		v14 = React.createElement(LoadingContent)
	elseif v5.error then
		v14 = React.createElement(ErrorContent, {
			retry = v5.retry,
			errorText = props.errorText,
			retryButtonText = props.retryButtonText
		})
	elseif #v8 == 0 then
		v14 = React.createElement(sheet.Content, nil, {
			Empty = React.createElement(
				view,
				{ tag = "col align-x-center align-y-center gap-medium size-full" },
				{
					Empty = React.createElement(TextWithTranslation, {
						input = props.emptyText,
						tag = "auto-xy",
						LayoutOrder = 1
					}),
					ReportAMessageNotShown = React.createElement(text, {
						Text = `<u>{translateIntoString(props.reportMessageNotShownText)}</u>`,
						RichText = true,
						tag = "auto-xy padding-small text-wrap text-align-x-center radius-medium",
						onActivated = v13,
						LayoutOrder = 2
					})
				}
			)
		})
	else
		local createElement = React.createElement
		local content = sheet.Content
		local v17

		if defineFastFlag and v6 then
			v17 = React.createElement(
				view,
				{ tag = "auto-xy padding-x-xlarge padding-top-xsmall", LayoutOrder = 1 },
				React.createElement(InExpDropdownWithPopover, {
					value = v7,
					items = v12,
					LayoutOrder = 1,
					onOpenChange = setState4,
					onItemChanged = function(p2)
						local v19 = tostring(p2)
						setState(nil)
						setState2(v19)
						sendEvent({
							sub_event_type = telemetryEventType.TextChannelSwitch,
							text_channel_switch_detail = {
								previous_channel_name = v7 or "",
								new_channel_name = v19,
								channel_count = #data
							}
						})
					end
				})
			)
		elseif v6 then
			v17 = React.createElement(InExpDropdownWithPopover, {
				value = v7,
				items = v12,
				LayoutOrder = 1,
				onOpenChange = setState4,
				onItemChanged = function(p2)
					local v19 = tostring(p2)
					setState(nil)
					setState2(v19)
					sendEvent({
						sub_event_type = telemetryEventType.TextChannelSwitch,
						text_channel_switch_detail = {
							previous_channel_name = v7 or "",
							new_channel_name = v19,
							channel_count = #data
						}
					})
				end
			})
		end

		v14 = createElement(content, { isContentFullBleed = true, ref = ref6 }, {
			ChannelDropdown = v17,
			ItemList = React.createElement(list.Root, {
				hasDivider = { hasDivider = true, isInset = false },
				isContained = { isContained = false, hasMargin = true },
				LayoutOrder = 2
			}, { Dash.map(v8, function(props2, p2)
					local v18 = if props2.meta and props2.meta.presetId and props2.meta.presetId ~= "" then React.createElement(icon, {
						name = iconName.LightningBolt,
						variant = iconVariant.Filled
					}) else nil

					return React.createElement(list.Item, {
						description = translateIntoString(props2.label),
						trailing = v18,
						onActivated = {
							onActivated = function()
								setState(props2.id)
								ref.current = props2
								sendEvent({
									sub_event_type = telemetryEventType.SelectItem,
									select_item_detail = {
										selected_index = p2,
										selected_id = props2.id,
										list_length = #v8,
										has_scroll = ref4.current,
										did_scroll = ref5.current
									}
								})
							end,
							inputType = listItemInputType.Radio,
							isChecked = state == props2.id
						},
						LayoutOrder = p2,
						ref = function(p3)
							ref2.current[props2.id] = p3
						end,
						key = props2.id
					})
				end) }),
			Footer = props.footerItems and React.createElement(module10, {
				footerItems = props.footerItems,
				additionalTag = "padding-top-medium",
				layoutOrder = 3
			})
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v16 = {
		Content = React.createElement(layout, { body = nil, actions = nil }),
		ChatSelectionSheet = 0
	}
	local createElement2 = React.createElement
	local root = sheet.Root
	local v17 = {
		ref = v11,
		isOpen = state3,
		centerSheetHeight = 1,
		size = dialogSize.Medium,
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
	local v18 = {
		SheetHeader = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				tag = "align-x-left auto-xy text-title-large text-truncate-end content-emphasis",
				Text = translateIntoString(props.title)
			})
		}),
		SheetContent = v14,
		SheetActions = 0
	}

	local v19 = if not (v5.loading or v5.error) and state ~= nil and (state ~= REPORT_MESSAGE_NOT_SHOWN_ITEM_ID or #v8 > 0) then React.createElement(sheet.Actions, nil, {
		Button = React.createElement(button, {
			variant = buttonVariant.Emphasis,
			text = translateIntoString(props.nextButtonText),
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting,
			fillBehavior = fillBehavior.Fill,
			onActivated = v9
		})
	}) else nil
	v18.SheetActions = v19
	v16.ChatSelectionSheet = createElement2(root, v17, v18)
	return createElement(fragment, nil, v16)
end

return React.memo(InExpChatSelectionNode)
