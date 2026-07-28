local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local FocusBehaviors = require(GenericAbuseReportingParent.FocusBehaviors)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ReactFocusNavigation = require(GenericAbuseReportingParent.ReactFocusNavigation)
local FFlagAbuseReportSelectItemAddId = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportSelectItemAddId
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Empty = Foundation.Empty
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local List = Foundation.List
local ListItemInputType = Foundation.Enums.ListItemInputType
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
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

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local useListLoader = require(GenericAbuseReporting.BeduiV2.Loaders.useLoader).useListLoader
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagAbuseReportInExpPlayerListV3 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInExpPlayerListV3
local t1 = {
	chevron = nil,
	radio = ListItemInputType.Radio,
	toggle = ListItemInputType.Toggle,
	checkbox = ListItemInputType.Checkbox
}

local function ListNodeLoading(t2: {[any]: any}) -- line: 76
	-- upvalues: React (copy), Eyebrow (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local title = t2.title
	local eyebrow = t2.eyebrow
	local tokens = t2.tokens

	return React.createElement(t2.layout, {
		body = React.createElement(React.Fragment, nil, {
			Eyebrow = eyebrow and React.createElement(Eyebrow, {
				layoutOrder = 0,
				eyebrow = eyebrow
			}),
			Title = React.createElement(t2.titleSlot, {
				layoutOrder = 1,
				input = title
			}),
			SkeletonContainer = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				Skeleton1 = React.createElement(Skeleton, {
					radius = EnumsRadius.Medium,
					Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
				}),
				Skeleton2 = React.createElement(Skeleton, {
					radius = EnumsRadius.Medium,
					Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
				}),
				Skeleton3 = React.createElement(Skeleton, {
					radius = EnumsRadius.Medium,
					Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
				}),
				Skeleton4 = React.createElement(Skeleton, {
					radius = EnumsRadius.Medium,
					Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
				}),
				Skeleton5 = React.createElement(Skeleton, {
					radius = EnumsRadius.Medium,
					Size = UDim2.new(1, 0, 0, tokens.Size.Size_600)
				})
			})
		})
	})
end
local function ListNodeError(t3: {[any]: any}) -- line: 125
	-- upvalues: useArTranslation (copy), React (copy), Eyebrow (copy), TextWithTranslation (copy), Button (copy), ButtonVariant (copy), Foundation (copy)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(t3.layout, {
		body = React.createElement(React.Fragment, nil, {
			Eyebrow = t3.eyebrow and React.createElement(Eyebrow, {
				layoutOrder = 0,
				eyebrow = t3.eyebrow
			}),
			Title = React.createElement(t3.titleSlot, {
				layoutOrder = 1,
				input = t3.title
			}),
			ErrorText = React.createElement(TextWithTranslation, {
				tag = "size-full-0 auto-y text-body-small",
				layoutOrder = 2,
				input = translateIntoString(t3.errorText)
			}),
			RetryButton = React.createElement(Button, {
				LayoutOrder = 3,
				text = translateIntoString(t3.retryButtonText),
				variant = ButtonVariant.Standard,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				onActivated = t3.retry
			})
		})
	})
end
local function ListNode(t4: {[any]: any}) -- line: 166
	-- upvalues: useTokens (copy), React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useListLoader (copy), useLayoutSlots (copy), ReactFocusNavigation (copy), FocusBehaviors (copy), scrollToItem (copy), TelemetryEventType (copy), FFlagAbuseReportSelectItemAddId (copy), Dash (copy), ListNodeLoading (copy), ListNodeError (copy), Empty (copy), Eyebrow (copy), View (copy), List (copy), FFlagAbuseReportInExpPlayerListV3 (copy), IconName (copy), t1 (copy), Footer (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v44 = useTokens()
	local v45, v46 = React.useState(t4.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v49 = React.useRef(nil)
	local v50, v51 = React.useState(false)
	local v52, v53 = React.useState(false)
	local v54 = React.useRef(false)
	local v55 = React.useRef(false)
	local v56 = useListLoader(t4.items)
	local loading = v56.loading
	local error = v56.error
	local retry = v56.retry
	local data = v56.data
	local v61 = useLayoutSlots()
	local Layout = v61.Layout
	local v63 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v64 = React.useRef(nil)

	React.useEffect(function() -- line: 188
		-- upvalues: v49 (copy), v63 (copy), data (copy), FocusBehaviors (copy), v64 (copy)
		local current = v49.current

		if not current or not v63 then
			return
		end

		if not data or #data == 0 then
			return
		end

		local v76 = FocusBehaviors.mostRecentOrDefault(v64.current)

		v63:registerFocusBehavior(current, v76)

		return function() -- line: 200
			-- upvalues: v63 (copy), current (copy), v76 (copy)
			v63:deregisterFocusBehavior(current, v76)
		end
	end, {
		v63,
		data,
		v64
	})
	React.useEffect(function() -- line: 206
		-- upvalues: v49 (copy), v51 (copy), v53 (copy)
		local current = v49.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 219
			-- upvalues: ScrollingFrame (copy), v51 (copy)
			local v93 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

			v51(v93)
		end
		local function onScroll() -- line: 224
			-- upvalues: ScrollingFrame (copy), v53 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v53(true)
			end
		end

		local v81 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		v51(v81)

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 237
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { loading })

	local v65 = React.useRef({})
	local v66 = React.useRef(nil)

	React.useEffect(function() -- line: 247
		-- upvalues: v45 (copy), v66 (copy), v65 (copy), scrollToItem (copy), v49 (copy)
		if v45 then
			v66.current = v65.current[v45]
			scrollToItem(v49, v66)

			return
		end

		v66.current = nil
	end, { v45 })
	React.useEffect(function() -- line: 256
		-- upvalues: error (copy), v54 (copy), sendEvent (copy), TelemetryEventType (copy)
		if error and not v54.current then
			v54.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "list: async load failed: " .. error
				}
			})
		end
	end, {
		error,
		sendEvent
	})
	React.useEffect(function() -- line: 266
		-- upvalues: loading (copy), error (copy), data (copy), v55 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not loading and not error and ((data == nil or #data == 0) and not v55.current) then
			v55.current = true
			sendEvent({
				sub_event_type = TelemetryEventType.EmptyState
			})
		end
	end, {
		loading,
		error,
		data,
		sendEvent
	})

	local v67 = t4.variant or "radio"
	local v68 = v67 == "chevron"
	local v69 = React.useCallback(function(n1: number, s1: string?) -- line: 283
		-- upvalues: data (copy), sendEvent (copy), TelemetryEventType (copy), FFlagAbuseReportSelectItemAddId (copy), v50 (copy), v52 (copy)
		if not data then
			return
		end

		sendEvent({
			sub_event_type = TelemetryEventType.SelectItem,
			select_item_detail = {
				selected_index = n1,
				selected_id = if not FFlagAbuseReportSelectItemAddId then nil else s1,
				list_length = #data,
				has_scroll = v50,
				did_scroll = v52
			}
		})
	end, {
		sendEvent,
		v50,
		v52,
		data
	})
	local v70 = React.useCallback(function(s2: string) -- line: 299
		-- upvalues: data (copy), v46 (copy), Dash (copy), v69 (copy), FFlagAbuseReportSelectItemAddId (copy)
		if not data then
			return
		end

		v46(s2)

		local n2 = 0

		Dash.forEach(data, function(p1, p2) -- line: 306
			-- upvalues: s2 (copy), n2 (ref)
			if p1.id == s2 then
				n2 = p2

				return
			end
		end)
		v69(n2, if not FFlagAbuseReportSelectItemAddId then nil else s2)
	end, {
		v69,
		data
	})
	local v71 = React.useCallback(function() -- line: 315
		-- upvalues: data (copy), Dash (copy), v45 (copy), t4 (copy)
		if not data then
			return
		end

		local v89 = Dash.find(data, function(p3) -- line: 320
			-- upvalues: v45 (copy)
			return p3.id == v45
		end)

		if t4.onNext then
			t4.onNext(v45, v89)
		end
	end, {
		data,
		t4.onNext,
		v45
	})
	local Title = v61.Title

	if loading then
		return React.createElement(ListNodeLoading, {
			layout = Layout,
			titleSlot = Title,
			title = t4.title,
			eyebrow = t4.eyebrow,
			tokens = v44
		})
	end

	if error then
		return React.createElement(ListNodeError, {
			layout = Layout,
			titleSlot = Title,
			title = t4.title,
			eyebrow = t4.eyebrow,
			errorText = t4.errorText,
			retryButtonText = t4.retryButtonText,
			tokens = v44,
			retry = retry
		})
	end

	local v73 = React.createElement(React.Fragment, nil, if data ~= nil and #data ~= 0 then {
		Eyebrow = React.createElement(Eyebrow, {
			layoutOrder = 0,
			eyebrow = t4.eyebrow
		}),
		Title = React.createElement(Title, {
			layoutOrder = 1,
			input = t4.title,
			subtitle = t4.subtitle
		}),
		ItemListContainer = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			ItemList = React.createElement(List.Root, {
				hasDivider = {
					hasDivider = true,
					isInset = false
				},
				isContained = {
					isContained = false,
					hasMargin = true
				}
			}, { Dash.map(data, function(p4, n3: number) -- line: 387
				-- upvalues: FFlagAbuseReportInExpPlayerListV3 (copy), t4 (copy), React (copy), List (copy), IconName (copy), translateIntoString (copy), v68 (copy), v69 (copy), FFlagAbuseReportSelectItemAddId (copy), v70 (copy), t1 (copy), v67 (copy), v45 (copy), v65 (copy), v64 (copy)
				local v92 = if not FFlagAbuseReportInExpPlayerListV3 or not t4.renderTrailingAccessory then nil else t4.renderTrailingAccessory(p4)

				return React.createElement(List.Item, {
					leading = if type(p4.leading) ~= "string" then p4.leading else IconName[p4.leading],
					title = translateIntoString(p4.label),
					description = if not p4.description then nil else translateIntoString(p4.description),
					trailing = v92,
					onActivated = {
						onActivated = not v68 and function() -- line: 410
							-- upvalues: v70 (copy), p4 (copy)
							v70(p4.id)
						end or function() -- line: 401
							-- upvalues: v69 (copy), n3 (copy), FFlagAbuseReportSelectItemAddId (copy), p4 (copy), t4 (copy)
							v69(n3, if not FFlagAbuseReportSelectItemAddId then nil else p4.id)

							if t4.onNext then
								t4.onNext(p4.id, p4)
							end
						end,
						inputType = t1[v67],
						isChecked = v45 == p4.id
					},
					LayoutOrder = n3,
					ref = function(p5) -- line: 417
						-- upvalues: v65 (copy), p4 (copy), n3 (copy), v64 (copy)
						v65.current[p4.id] = p5

						if n3 == 1 then
							v64.current = p5
						end
					end
				})
			end) })
		}),
		Footer = t4.footerItems and React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 3,
			footerItems = t4.footerItems
		})
	} else {
		Empty = React.createElement(Empty, {
			text = if not t4.emptyText then nil else translateIntoString(t4.emptyText)
		})
	})
	local v74 = if not t4.onNext or (v68 or v45 == nil) then nil else React.createElement(Button, {
		text = translateIntoString(t4.nextButtonText),
		variant = ButtonVariant.Emphasis,
		fillBehavior = FillBehavior.Fill,
		isLoading = t4.isSubmitting,
		isDisabled = t4.isSubmitting,
		onActivated = v71
	})

	return React.createElement(Layout, {
		ref = v49,
		body = v73,
		actions = v74
	})
end

return React.memo(ListNode)
