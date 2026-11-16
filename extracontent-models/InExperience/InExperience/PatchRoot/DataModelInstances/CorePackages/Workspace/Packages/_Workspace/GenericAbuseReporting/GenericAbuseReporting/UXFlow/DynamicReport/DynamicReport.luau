local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
require(GenericAbuseReporting.Enums.AbuseVector)
local BeduiAnalytics = require(GenericAbuseReporting.Bedui.Utils.BeduiAnalytics)
local ReportFlowHandler = require(GenericAbuseReporting.Bedui.ReportFlowHandler)
local useAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.useAnalyticsContext)
local useOnScreenKeyboardHeight = require(GenericAbuseReporting.Common.useOnScreenKeyboardHeight)
local useScrollbarOffset = require(GenericAbuseReporting.Common.useScrollbarOffset)

local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local TelemetryEventType = BeduiAnalytics.TelemetryEventType

local function DynamicReport(props)
	local absoluteSize = useLayerCollector().absoluteSize
	local v, v2 = React.useBinding(Vector2.new(0, 0))
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local v3 = useScrollbarOffset(state, state2)
	local v4 = useOnScreenKeyboardHeight()
	local isKeyboardShowing = v4.isKeyboardShowing
	local onScreenKeyboardHeight = v4.onScreenKeyboardHeight
	local keyboardPositionY = v4.keyboardPositionY

	local v5 = useLocalization({ reportTitle = "Feature.ReportAbuse.Label.Report" })

	local context = useAnalyticsContext()
	local isReportSubmitted = context.isReportSubmitted

	local v6 = useSelector(function(p)
		return if p.GlobalGuiInset then p.GlobalGuiInset.top else 0
	end)

	local v7 = React.useMemo(function()
		if not isKeyboardShowing then
			return 0
		end

		local v7 = keyboardPositionY - v6

		local v8 = absoluteSize.Y - v7

		if v8 <= 0 then
			return 0
		end

		return (math.min(v8, onScreenKeyboardHeight))
	end, { isKeyboardShowing, keyboardPositionY, onScreenKeyboardHeight, absoluteSize.Y, v6 })

	local v8 = React.useMemo(function()
		if isKeyboardShowing then
			return -v7
		end

		return 0
	end, { isKeyboardShowing, v7 })

	React.useEffect(function()
		sendAnalyticsEvent({
			eventType = TelemetryEventType.Rendered,
			context = { abuseVector = props.abuseVector }
		})
	end, { sendAnalyticsEvent, props.abuseVector })

	local onCloseClicked = React.useCallback(function()
		if not isReportSubmitted then
			sendAnalyticsEvent({ eventType = TelemetryEventType.Abandoned, context = context })
		end

		props.onClose()
	end, { isReportSubmitted, sendAnalyticsEvent, context, props.onClose })

	local createElement = React.createElement
	local v9 = {
		title = v5.reportTitle,
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y),
		position = 0,
		anchorPoint = 0,
		onCloseClicked = 0
	}
	local position

	if isKeyboardShowing then
		position = UDim2.new(0.5, 0, 1, v8)
	end

	v9.position = position
	local anchorPoint

	if isKeyboardShowing then
		anchorPoint = Vector2.new(0.5, 1)
	end

	v9.anchorPoint = anchorPoint
	v9.onCloseClicked = onCloseClicked

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v10 = {
		Size = v:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v7 - 100, (math.ceil(vector2.Y)))))
		end),
		scroll = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onAbsoluteWindowSizeChanged = 0
	}

	local scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = 0
	}
	local verticalScrollBarInset

	if FFlagAddThumbnailSelectorReport then
		verticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	end

	scroll.VerticalScrollBarInset = verticalScrollBarInset
	v10.scroll = scroll

	function v10.onAbsoluteCanvasSizeChanged(p)
		setState(p.AbsoluteCanvasSize)
	end
	function v10.onAbsoluteWindowSizeChanged(p)
		setState2(p.AbsoluteWindowSize)
	end

	local createElement4 = React.createElement
	local size

	if FFlagAddThumbnailSelectorReport then
		size = UDim2.new(0, 0, 0, 0)
	else
		size = UDim2.new(0, -v3, 0, 0)
	end

	return createElement(PartialPageModal, v9, {
		View = createElement2(View, { tag = "size-full-0 auto-y" }, {
			ScrollView = createElement3(ScrollView, v10, {
				Content = createElement4(View, {
					Size = size,
					onAbsoluteSizeChanged = function(p)
						v2(p.AbsoluteSize)
					end,
					tag = "auto-xy padding-x-xxsmall padding-top-medium"
				}, {
					ReportFlowHandler = React.createElement(ReportFlowHandler, {
						targetId = props.targetId,
						abuseVector = props.abuseVector,
						onSubmit = props.onSubmit,
						custom = props.custom
					})
				})
			})
		})
	})
end

return React.memo(DynamicReport)
