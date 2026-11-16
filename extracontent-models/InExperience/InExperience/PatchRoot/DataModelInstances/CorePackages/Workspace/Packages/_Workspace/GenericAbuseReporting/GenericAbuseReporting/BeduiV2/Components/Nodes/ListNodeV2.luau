local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local FocusBehaviors = require(parent.FocusBehaviors)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Empty = Foundation.Empty
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local List = Foundation.List
local ListItemInputType = Foundation.Enums.ListItemInputType
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local scrollToItem = require(GenericAbuseReporting.BeduiV2.Utils.scrollToItem)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation
local useLoader = require(GenericAbuseReporting.BeduiV2.Loaders.useLoader)
local useListLoader = useLoader.useListLoader

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local SharedFlags = require(parent.SharedFlags)
local FFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportListNodeFullBleed = require(GenericAbuseReporting.Flags.FFlagAbuseReportListNodeFullBleed)
local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local v = {
	chevron = nil,
	radio = ListItemInputType.Radio,
	toggle = ListItemInputType.Toggle,
	checkbox = ListItemInputType.Checkbox
}

local function ListNodeLoading(props)
	local title = props.title
	local eyebrow = props.eyebrow
	local tokens = props.tokens
	return React.createElement(props.layout, {
		body = React.createElement(React.Fragment, nil, {
			Eyebrow = eyebrow and React.createElement(Eyebrow, {
				eyebrow = eyebrow,
				layoutOrder = 0
			}),
			Title = React.createElement(props.titleSlot, { input = title, layoutOrder = 1 }),
			SkeletonContainer = React.createElement(
				View,
				{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
				{
					Skeleton1 = React.createElement(Skeleton, {
						radius = Radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton2 = React.createElement(Skeleton, {
						radius = Radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton3 = React.createElement(Skeleton, {
						radius = Radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton4 = React.createElement(Skeleton, {
						radius = Radius.Medium,
						Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
					}),
					Skeleton5 = React.createElement(Skeleton, {
						radius = Radius.Medium,
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
			Eyebrow = props.eyebrow and React.createElement(Eyebrow, {
				eyebrow = props.eyebrow,
				layoutOrder = 0
			}),
			Title = React.createElement(props.titleSlot, { input = props.title, layoutOrder = 1 }),
			ErrorText = React.createElement(TextWithTranslation, {
				input = translateIntoString(props.errorText),
				tag = "size-full-0 auto-y text-body-small",
				layoutOrder = 2
			}),
			RetryButton = React.createElement(Button, {
				text = translateIntoString(props.retryButtonText),
				variant = ButtonVariant.Standard,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				onActivated = props.retry,
				LayoutOrder = 3
			})
		})
	})
end

local function ListNode(props)
	local tokens = useTokens()
	local state, setState = React.useState(props.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)

	local v2 = useListLoader(props.items)
	local loading = v2.loading
	local err = v2.error
	local retry = v2.retry
	local data = v2.data

	local v3 = useLayoutSlots()
	local layout = v3.Layout
	local contentInset = v3.ContentInset

	local v4 = data ~= nil and #data > 0

	local v5 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local ref4 = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if not (current and v5) or (not data or #data == 0) then
			return
		end

		local mostRecentOrDefault = FocusBehaviors.mostRecentOrDefault(ref4.current)
		v5:registerFocusBehavior(current, mostRecentOrDefault)

		return function()
			v5:deregisterFocusBehavior(current, mostRecentOrDefault)
		end
	end, { v5, data, ref4 })

	React.useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		local scrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not scrollingFrame then
			return
		end

		local function checkScrollbar() -- 1 equivalent call inferred from this helper
			setState2(scrollingFrame.AbsoluteCanvasSize.Y > scrollingFrame.AbsoluteWindowSize.Y)
		end

		local function onScroll()
			if scrollingFrame.CanvasPosition.Y > 0 then
				setState3(true)
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
			local v6 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = formatErrorDetailForAnalytics("list: async load failed", err)
			else
				error_detail = {
					error_message = "list: async load failed: " .. err
				}
			end

			v6.error_detail = error_detail
			sendEvent(v6)
		end
	end, { err, sendEvent })

	React.useEffect(function()
		if not loading and not err and (data == nil or #data == 0) and not ref3.current then
			ref3.current = true
			sendEvent({ sub_event_type = telemetryEventType.EmptyState })
		end
	end, { loading, err, data, sendEvent })

	local variant = props.variant or "radio"
	local v6 = variant == "chevron"
	local v7 = React.useCallback(function(selected_index: number, selected_id: string)
		if not data then
			return
		end

		sendEvent({
			sub_event_type = telemetryEventType.SelectItem,
			select_item_detail = {
				selected_index = selected_index,
				selected_id = selected_id,
				list_length = #data,
				has_scroll = state2,
				did_scroll = state3
			}
		})
	end, { sendEvent, state2, state3, data })

	local v8 = React.useCallback(function(p: string)
		if not data then
			return
		end

		setState(p)
		local v8 = 0
		Dash.forEach(data, function(p2, p3)
			if p2.id ~= p then
				return
			end

			v8 = p3
		end)
		v7(v8, p)
	end, { v7, data })

	local onActivated = React.useCallback(function()
		if not data then
			return
		end

		local v9 = Dash.find(data, function(p): boolean
			return p.id == state
		end)

		if props.onNext then
			props.onNext(state, v9)
		end
	end, { data, props.onNext, state })

	local title = v3.Title

	if loading then
		return React.createElement(ListNodeLoading, {
			layout = layout,
			titleSlot = title,
			title = props.title,
			eyebrow = props.eyebrow,
			tokens = tokens
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
			tokens = tokens,
			retry = retry
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local children

	if data == nil or #data == 0 then
		children = { Empty = 0 }
		local createElement2 = React.createElement
		local text

		if props.emptyText then
			text = translateIntoString(props.emptyText)
		end

		children.Empty = createElement2(Empty, { text = text })
	else
		children = {
			Eyebrow = 0,
			Title = 0,
			Header = 0,
			ItemListContainer = 0,
			Footer = 0
		}
		local eyebrow

		if not FFlagAbuseReportListNodeFullBleed then
			eyebrow = React.createElement(Eyebrow, { eyebrow = props.eyebrow, layoutOrder = 0 })
		end

		children.Eyebrow = eyebrow
		local title2

		if not FFlagAbuseReportListNodeFullBleed then
			title2 = React.createElement(title, {
				input = props.title,
				subtitle = props.subtitle,
				layoutOrder = 1
			})
		end

		children.Title = title2
		local header

		if FFlagAbuseReportListNodeFullBleed then
			header = React.createElement(contentInset, { layoutOrder = 0 }, {
				Eyebrow = props.eyebrow and React.createElement(Eyebrow, {
					eyebrow = props.eyebrow,
					layoutOrder = 0
				}),
				Title = React.createElement(title, {
					input = props.title,
					subtitle = props.subtitle,
					layoutOrder = 1
				})
			})
		end

		children.Header = header

		children.ItemListContainer = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			ItemList = React.createElement(List.Root, {
				hasDivider = { hasDivider = true, isInset = false },
				isContained = { isContained = false, hasMargin = true }
			}, { Dash.map(data, function(props2, layoutOrder: number)
					local trailing

					if FFlagAbuseReportInExpPlayerListV3 and props.renderTrailingAccessory then
						trailing = props.renderTrailingAccessory(props2)
					end

					local createElement2 = React.createElement
					local item = List.Item
					local leading

					if type(props2.leading) == "string" then
						leading = IconName[props2.leading]
					else
						leading = props2.leading
					end

					local v9 = {
						leading = leading,
						title = translateIntoString(props2.label),
						description = 0,
						trailing = 0,
						onActivated = 0,
						LayoutOrder = 0,
						ref = 0
					}
					local description

					if props2.description then
						description = translateIntoString(props2.description)
					end

					v9.description = description
					v9.trailing = trailing
					local onActivated2

					if v6 then
						onActivated2 = function()
							v7(layoutOrder, props2.id)

							if props.onNext then
								props.onNext(props2.id, props2)
							end
						end
					else
						onActivated2 = function()
							v8(props2.id)
						end
					end

					v9.onActivated = {
						onActivated = onActivated2,
						inputType = v[variant],
						isChecked = state == props2.id
					}

					v9.LayoutOrder = layoutOrder
					function v9.ref(current)
						ref5.current[props2.id] = current

						if layoutOrder == 1 then
							ref4.current = current
						end
					end

					return createElement2(item, v9)
				end) })
		})
		local footer

		if FFlagAbuseReportListNodeFullBleed then
			footer = props.footerItems
				and React.createElement(
					contentInset,
					{ layoutOrder = 3 },
					React.createElement(Footer, {
						footerItems = props.footerItems,
						additionalTag = "padding-top-medium"
					})
				)
		else
			footer = props.footerItems
				and React.createElement(Footer, {
					footerItems = props.footerItems,
					additionalTag = "padding-top-medium",
					layoutOrder = 3
				})
		end

		children.Footer = footer
	end

	local element = createElement(fragment, nil, children)
	local actions

	if props.onNext and not v6 and state ~= nil then
		actions = React.createElement(Button, {
			text = translateIntoString(props.nextButtonText),
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting,
			onActivated = onActivated
		})
	end

	return React.createElement(layout, {
		ref = ref,
		body = element,
		actions = actions,
		isContentFullBleed = FFlagAbuseReportListNodeFullBleed and v4
	})
end

return React.memo(ListNode)
