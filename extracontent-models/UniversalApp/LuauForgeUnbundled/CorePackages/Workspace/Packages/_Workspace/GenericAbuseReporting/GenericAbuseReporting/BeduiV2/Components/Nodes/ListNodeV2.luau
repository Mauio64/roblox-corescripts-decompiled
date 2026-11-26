local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local FocusBehaviors = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusBehaviors")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local empty = Foundation.Empty
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local list = Foundation.List
local listItemInputType = Foundation.Enums.ListItemInputType
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Eyebrow")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local scrollToItem = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/scrollToItem")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation
local useListLoader = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/useLoader").useListLoader

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local fFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportListNodeFullBleed = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportListNodeFullBleed")
local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local v5 = {
	chevron = nil,
	radio = listItemInputType.Radio,
	toggle = listItemInputType.Toggle,
	checkbox = listItemInputType.Checkbox
}

local function ListNodeLoading(props)
	local title = props.title
	local eyebrow = props.eyebrow
	local tokens = props.tokens
	return React.createElement(props.layout, {
		body = React.createElement(React.Fragment, nil, {
			Eyebrow = eyebrow and React.createElement(module8, {
				eyebrow = eyebrow,
				layoutOrder = 0
			}),
			Title = React.createElement(props.titleSlot, {
				input = title,
				layoutOrder = 1
			}),
			SkeletonContainer = React.createElement(
				view,
				{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
				{
					Skeleton1 = React.createElement(skeleton, {
						radius = radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton2 = React.createElement(skeleton, {
						radius = radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton3 = React.createElement(skeleton, {
						radius = radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton4 = React.createElement(skeleton, {
						radius = radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton5 = React.createElement(skeleton, {
						radius = radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					})
				}
			)
		})
	})
end

local function ListNodeError(props)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(props.layout, {
		body = React.createElement(React.Fragment, nil, {
			Eyebrow = props.eyebrow and React.createElement(module8, {
				eyebrow = props.eyebrow,
				layoutOrder = 0
			}),
			Title = React.createElement(props.titleSlot, {
				input = props.title,
				layoutOrder = 1
			}),
			ErrorText = React.createElement(TextWithTranslation, {
				input = translateIntoString(props.errorText),
				tag = "size-full-0 auto-y text-body-small",
				layoutOrder = 2
			}),
			RetryButton = React.createElement(button, {
				text = translateIntoString(props.retryButtonText),
				variant = buttonVariant.Standard,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				onActivated = props.retry,
				LayoutOrder = 3
			})
		})
	})
end

local function ListNode(props)
	local v6 = useTokens()
	local state, setState = React.useState(props.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)

	local v7 = useListLoader(props.items)
	local loading = v7.loading
	local err = v7.error
	local retry = v7.retry
	local data = v7.data

	local v8 = useLayoutSlots()
	local layout = v8.Layout
	local contentInset = v8.ContentInset

	local v9 = data ~= nil and #data > 0

	local v11 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local ref4 = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if not (current and v11) or (not data or #data == 0) then
			return
		end

		local mostRecentOrDefault = FocusBehaviors.mostRecentOrDefault(ref4.current)
		v11:registerFocusBehavior(current, mostRecentOrDefault)

		return function()
			v11:deregisterFocusBehavior(current, mostRecentOrDefault)
		end
	end, { v11, data, ref4 })

	React.useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		local scrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not scrollingFrame then
			return
		end

		local function checkScrollbar()
			setState2(scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y)
		end

		local function onScroll()
			if scrollingFrame.CanvasPosition.Y > 0 then
				setState3(true)
			end
		end

		setState2(scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y)

		local absoluteCanvasSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)

		local absoluteWindowSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local canvasPositionChangedConnection = scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { loading })

	local ref5 = React.useRef({})
	local ref6 = React.useRef(nil)

	React.useEffect(function()
		if not state then
			ref6.current = nil

			return
		end

		ref6.current = ref5.current[state]
		scrollToItem(ref, ref6)
	end, { state })

	React.useEffect(function()
		if err and not ref2.current then
			ref2.current = true
			local v13 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v14 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("list: async load failed", err) else {
				error_message = "list: async load failed: " .. err
			}
			v13.error_detail = v14
			sendEvent(v13)
		end
	end, { err, sendEvent })

	React.useEffect(function()
		if not loading and not err and (data == nil or #data == 0) and not ref3.current then
			ref3.current = true
			sendEvent({ sub_event_type = telemetryEventType.EmptyState })
		end
	end, { loading, err, data, sendEvent })

	local variant = props.variant or "radio"
	local v12 = variant == "chevron"
	local v13 = React.useCallback(function(p2, p3)
		if not data then
			return
		end

		sendEvent({
			sub_event_type = telemetryEventType.SelectItem,
			select_item_detail = {
				selected_index = p2,
				selected_id = p3,
				list_length = #data,
				has_scroll = state2,
				did_scroll = state3
			}
		})
	end, { sendEvent, state2, state3, data })

	local v14 = React.useCallback(function(p2)
		if not data then
			return
		end

		setState(p2)
		local v15 = 0
		Dash.forEach(data, function(p3, p4)
			if p3.id ~= p2 then
				return
			end

			v15 = p4
		end)
		v13(v15, p2)
	end, { v13, data })

	local v15 = React.useCallback(function()
		if not data then
			return
		end

		local v16 = Dash.find(data, function(p2): boolean
			return p2.id == state
		end)

		if props.onNext then
			props.onNext(state, v16)
		end
	end, { data, props.onNext, state })

	local title = v8.Title

	if loading then
		return React.createElement(ListNodeLoading, {
			layout = layout,
			titleSlot = title,
			title = props.title,
			eyebrow = props.eyebrow,
			tokens = v6
		})
	end

	if err then
		return React.createElement(ListNodeError, {
			layout = layout,
			titleSlot = title,
			title = props.title,
			eyebrow = props.eyebrow,
			errorText = props.errorText,
			retryButtonText = props.retryButtonText,
			tokens = v6,
			retry = retry
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local children

	if data == nil or #data == 0 then
		children = { Empty = 0 }
		local createElement2 = React.createElement
		local v19 = if props.emptyText then translateIntoString(props.emptyText) else nil
		children.Empty = createElement2(empty, { text = v19 })
	else
		children = {
			Eyebrow = 0,
			Title = 0,
			Header = 0,
			ItemListContainer = 0,
			Footer = 0
		}

		local v17 = if not FFlagAbuseReportListNodeFullBleed then React.createElement(module8, {
			eyebrow = props.eyebrow,
			layoutOrder = 0
		}) else nil
		children.Eyebrow = v17

		local v18 = if not FFlagAbuseReportListNodeFullBleed then React.createElement(title, {
			input = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1
		}) else nil
		children.Title = v18

		local v19 = if FFlagAbuseReportListNodeFullBleed then React.createElement(contentInset, {
			layoutOrder = 0
		}, {
			Eyebrow = props.eyebrow and React.createElement(module8, {
				eyebrow = props.eyebrow,
				layoutOrder = 0
			}),
			Title = React.createElement(title, {
				input = props.title,
				subtitle = props.subtitle,
				layoutOrder = 1
			})
		}) else nil
		children.Header = v19

		children.ItemListContainer = React.createElement(
			view,
			{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
			{
				ItemList = React.createElement(list.Root, {
					hasDivider = { hasDivider = true, isInset = false },
					isContained = { isContained = false, hasMargin = true }
				}, { Dash.map(data, function(props2, layoutOrder)
						local v20

						if fFlagAbuseReportInExpPlayerListV3 and props.renderTrailingAccessory then
							v20 = props.renderTrailingAccessory(props2)
						end

						local createElement2 = React.createElement
						local item = list.Item
						local v22 = if type(props2.leading) == "string" then iconName[props2.leading] else props2.leading
						local v21 = {
							leading = v22,
							title = translateIntoString(props2.label),
							description = 0,
							trailing = 0,
							onActivated = 0,
							LayoutOrder = 0,
							ref = 0
						}
						local v23 = if props2.description then translateIntoString(props2.description) else nil
						v21.description = v23
						v21.trailing = v20
						local v25

						if v12 then
							v25 = function()
								v13(layoutOrder, props2.id)

								if props.onNext then
									props.onNext(props2.id, props2)
								end
							end
						else
							v25 = function()
								v14(props2.id)
							end
						end

						v21.onActivated = {
							onActivated = v25,
							inputType = v5[variant],
							isChecked = state == props2.id
						}

						v21.LayoutOrder = layoutOrder
						function v21.ref(current)
							ref5.current[props2.id] = current

							if layoutOrder == 1 then
								ref4.current = current
							end
						end

						return createElement2(item, v21)
					end) })
			}
		)

		local v20 = if FFlagAbuseReportListNodeFullBleed then props.footerItems and React.createElement(
			contentInset,
			{ layoutOrder = 3 },
			React.createElement(module9, {
				footerItems = props.footerItems,
				additionalTag = "padding-top-medium"
			})
		) else props.footerItems and React.createElement(module9, {
			footerItems = props.footerItems,
			additionalTag = "padding-top-medium",
			layoutOrder = 3
		})
		children.Footer = v20
	end

	local element = createElement(fragment, nil, children)

	local v17 = if props.onNext and not v12 and state ~= nil then React.createElement(button, {
		text = translateIntoString(props.nextButtonText),
		variant = buttonVariant.Emphasis,
		fillBehavior = fillBehavior.Fill,
		isLoading = props.isSubmitting,
		isDisabled = props.isSubmitting,
		onActivated = v15
	}) else nil

	return React.createElement(layout, {
		ref = ref,
		body = element,
		actions = v17,
		isContentFullBleed = FFlagAbuseReportListNodeFullBleed and v9
	})
end

return React.memo(ListNode)
