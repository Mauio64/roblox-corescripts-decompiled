local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local FocusBehaviors = require(GenericAbuseReportingParent.FocusBehaviors)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ReactFocusNavigation = require(GenericAbuseReportingParent.ReactFocusNavigation)
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
local t1 = {
	chevron = nil,
	radio = ListItemInputType.Radio,
	toggle = ListItemInputType.Toggle,
	checkbox = ListItemInputType.Checkbox
}

local function ListNodeLoading(t2: {[any]: any}) -- line: 71
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
local function ListNodeError(t3: {[any]: any}) -- line: 120
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
local function ListNode(t4: {[any]: any}) -- line: 161
	-- upvalues: useTokens (copy), React (copy), useArTranslation (copy), useAbuseReportAnalytics (copy), useListLoader (copy), useLayoutSlots (copy), ReactFocusNavigation (copy), FocusBehaviors (copy), scrollToItem (copy), TelemetryEventType (copy), Dash (copy), ListNodeLoading (copy), ListNodeError (copy), Empty (copy), Eyebrow (copy), View (copy), List (copy), IconName (copy), t1 (copy), Footer (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v42 = useTokens()
	local v43, v44 = React.useState(t4.initialValue or nil)
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v47 = React.useRef(nil)
	local v48, v49 = React.useState(false)
	local v50, v51 = React.useState(false)
	local v52 = React.useRef(false)
	local v53 = React.useRef(false)
	local v54 = useListLoader(t4.items)
	local loading = v54.loading
	local error = v54.error
	local retry = v54.retry
	local data = v54.data
	local v59 = useLayoutSlots()
	local Layout = v59.Layout
	local v61 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v62 = React.useRef(nil)

	React.useEffect(function() -- line: 183
		-- upvalues: v47 (copy), v61 (copy), data (copy), FocusBehaviors (copy), v62 (copy)
		local current = v47.current

		if not current or not v61 then
			return
		end

		if not data or #data == 0 then
			return
		end

		local v74 = FocusBehaviors.mostRecentOrDefault(v62.current)

		v61:registerFocusBehavior(current, v74)

		return function() -- line: 195
			-- upvalues: v61 (copy), current (copy), v74 (copy)
			v61:deregisterFocusBehavior(current, v74)
		end
	end, {
		v61,
		data,
		v62
	})
	React.useEffect(function() -- line: 201
		-- upvalues: v47 (copy), v49 (copy), v51 (copy)
		local current = v47.current

		if not current then
			return
		end

		local ScrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if not ScrollingFrame then
			return
		end

		local function checkScrollbar() -- line: 214
			-- upvalues: ScrollingFrame (copy), v49 (copy)
			local v89 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

			v49(v89)
		end
		local function onScroll() -- line: 219
			-- upvalues: ScrollingFrame (copy), v51 (copy)
			if ScrollingFrame.CanvasPosition.Y > 0 then
				v51(true)
			end
		end

		local v79 = ScrollingFrame.AbsoluteCanvasSize.Y > ScrollingFrame.AbsoluteWindowSize.Y

		v49(v79)

		local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkScrollbar)
		local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkScrollbar)
		local connection3 = ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(onScroll)

		return function() -- line: 232
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { loading })

	local v63 = React.useRef({})
	local v64 = React.useRef(nil)

	React.useEffect(function() -- line: 242
		-- upvalues: v43 (copy), v64 (copy), v63 (copy), scrollToItem (copy), v47 (copy)
		if v43 then
			v64.current = v63.current[v43]
			scrollToItem(v47, v64)

			return
		end

		v64.current = nil
	end, { v43 })
	React.useEffect(function() -- line: 251
		-- upvalues: error (copy), v52 (copy), sendEvent (copy), TelemetryEventType (copy)
		if error and not v52.current then
			v52.current = true
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
	React.useEffect(function() -- line: 261
		-- upvalues: loading (copy), error (copy), data (copy), v53 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not loading and not error and ((data == nil or #data == 0) and not v53.current) then
			v53.current = true
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

	local v65 = t4.variant or "radio"
	local v66 = v65 == "chevron"
	local v67 = React.useCallback(function(n1: number) -- line: 278
		-- upvalues: data (copy), sendEvent (copy), TelemetryEventType (copy), v48 (copy), v50 (copy)
		if not data then
			return
		end

		sendEvent({
			sub_event_type = TelemetryEventType.SelectItem,
			select_item_detail = {
				selected_index = n1,
				list_length = #data,
				has_scroll = v48,
				did_scroll = v50
			}
		})
	end, {
		sendEvent,
		v48,
		v50,
		data
	})
	local v68 = React.useCallback(function(s1: string) -- line: 293
		-- upvalues: data (copy), v44 (copy), Dash (copy), v67 (copy)
		if not data then
			return
		end

		v44(s1)

		local n2 = 0

		Dash.forEach(data, function(p1, p2) -- line: 300
			-- upvalues: s1 (copy), n2 (ref)
			if p1.id == s1 then
				n2 = p2

				return
			end
		end)
		v67(n2)
	end, {
		v67,
		data
	})
	local v69 = React.useCallback(function() -- line: 309
		-- upvalues: data (copy), Dash (copy), v43 (copy), t4 (copy)
		if not data then
			return
		end

		local v86 = Dash.find(data, function(p3) -- line: 314
			-- upvalues: v43 (copy)
			return p3.id == v43
		end)

		if t4.onNext then
			t4.onNext(v43, v86)
		end
	end, {
		data,
		t4.onNext,
		v43
	})
	local Title = v59.Title

	if loading then
		return React.createElement(ListNodeLoading, {
			layout = Layout,
			titleSlot = Title,
			title = t4.title,
			eyebrow = t4.eyebrow,
			tokens = v42
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
			tokens = v42,
			retry = retry
		})
	end

	local v71 = React.createElement(React.Fragment, nil, if data ~= nil and #data ~= 0 then {
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
			}, { Dash.map(data, function(p4, n3: number) -- line: 381
				-- upvalues: React (copy), List (copy), IconName (copy), translateIntoString (copy), v66 (copy), v67 (copy), t4 (copy), v68 (copy), t1 (copy), v65 (copy), v43 (copy), v63 (copy), v62 (copy)
				return React.createElement(List.Item, {
					leading = if type(p4.leading) ~= "string" then p4.leading else IconName[p4.leading],
					title = translateIntoString(p4.label),
					description = if not p4.description then nil else translateIntoString(p4.description),
					onActivated = {
						onActivated = not v66 and function() -- line: 396
							-- upvalues: v68 (copy), p4 (copy)
							v68(p4.id)
						end or function() -- line: 390
							-- upvalues: v67 (copy), n3 (copy), t4 (copy), p4 (copy)
							v67(n3)

							if t4.onNext then
								t4.onNext(p4.id, p4)
							end
						end,
						inputType = t1[v65],
						isChecked = v43 == p4.id
					},
					LayoutOrder = n3,
					ref = function(p5) -- line: 403
						-- upvalues: v63 (copy), p4 (copy), n3 (copy), v62 (copy)
						v63.current[p4.id] = p5

						if n3 == 1 then
							v62.current = p5
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
	local v72 = if not t4.onNext or (v66 or v43 == nil) then nil else React.createElement(Button, {
		text = translateIntoString(t4.nextButtonText),
		variant = ButtonVariant.Emphasis,
		fillBehavior = FillBehavior.Fill,
		isLoading = t4.isSubmitting,
		isDisabled = t4.isSubmitting,
		onActivated = v69
	})

	return React.createElement(Layout, {
		ref = v47,
		body = v71,
		actions = v72
	})
end

return React.memo(ListNode)
