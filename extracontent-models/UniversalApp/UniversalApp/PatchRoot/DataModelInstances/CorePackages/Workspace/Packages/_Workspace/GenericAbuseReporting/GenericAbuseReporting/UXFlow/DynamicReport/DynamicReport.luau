local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local UIBlox = require(GenericAbuseReportingParent.UIBlox)
local useLocalization = require(GenericAbuseReportingParent.Localization).Hooks.useLocalization
local useSelector = require(GenericAbuseReportingParent.RoactUtils).Hooks.RoactRodux.useSelector
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

local function DynamicReport(t1: {[any]: any}) -- line: 45
	-- upvalues: useLayerCollector (copy), React (copy), useScrollbarOffset (copy), useOnScreenKeyboardHeight (copy), useLocalization (copy), useAnalyticsContext (copy), useSelector (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), PartialPageModal (copy), View (copy), ScrollView (copy), FFlagAddThumbnailSelectorReport (copy), ReportFlowHandler (copy)
	local absoluteSize = useLayerCollector().absoluteSize
	local v24, v25 = React.useBinding(Vector2.new(0, 0))
	local v26, v27 = React.useState(Vector2.new(0, 0))
	local v28, v29 = React.useState(Vector2.new(0, 0))
	local v30 = useScrollbarOffset(v26, v28)
	local v31 = useOnScreenKeyboardHeight()
	local isKeyboardShowing = v31.isKeyboardShowing
	local onScreenKeyboardHeight = v31.onScreenKeyboardHeight
	local keyboardPositionY = v31.keyboardPositionY
	local v35 = useLocalization({
		reportTitle = "Feature.ReportAbuse.Label.Report"
	})
	local v36 = useAnalyticsContext()
	local isReportSubmitted = v36.isReportSubmitted
	local v38 = useSelector(function(p1) -- line: 64
		if p1.GlobalGuiInset then
			return p1.GlobalGuiInset.top
		end

		return 0
	end)
	local v39 = React.useMemo(function() -- line: 69
		-- upvalues: isKeyboardShowing (copy), keyboardPositionY (copy), v38 (copy), absoluteSize (copy), onScreenKeyboardHeight (copy)
		if not isKeyboardShowing then
			return 0
		end

		local v43 = keyboardPositionY - v38
		local v44 = absoluteSize.Y - v43

		if v44 <= 0 then
			return 0
		end

		return (math.min(v44, onScreenKeyboardHeight))
	end, {
		isKeyboardShowing,
		keyboardPositionY,
		onScreenKeyboardHeight,
		absoluteSize.Y,
		v38
	})
	local v40 = React.useMemo(function() -- line: 92
		-- upvalues: isKeyboardShowing (copy), v39 (copy)
		if not isKeyboardShowing then
			return 0
		end

		return -v39
	end, {
		isKeyboardShowing,
		v39
	})

	React.useEffect(function() -- line: 100
		-- upvalues: sendAnalyticsEvent (copy), TelemetryEventType (copy), t1 (copy)
		sendAnalyticsEvent({
			eventType = TelemetryEventType.Rendered,
			context = {
				abuseVector = t1.abuseVector
			}
		})
	end, {
		sendAnalyticsEvent,
		t1.abuseVector
	})

	local v41 = React.useCallback(function() -- line: 109
		-- upvalues: isReportSubmitted (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v36 (copy), t1 (copy)
		if not isReportSubmitted then
			sendAnalyticsEvent({
				eventType = TelemetryEventType.Abandoned,
				context = v36
			})
		end

		t1.onClose()
	end, {
		isReportSubmitted,
		sendAnalyticsEvent,
		v36,
		t1.onClose
	})

	return React.createElement(PartialPageModal, {
		title = v35.reportTitle,
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y),
		position = if not isKeyboardShowing then nil else UDim2.new(0.5, 0, 1, v40),
		anchorPoint = if not isKeyboardShowing then nil else Vector2.new(0.5, 1),
		onCloseClicked = v41
	}, {
		View = React.createElement(View, {
			tag = "size-full-0 auto-y"
		}, {
			ScrollView = React.createElement(ScrollView, {
				Size = v24:map(function(vector2: Vector2) -- line: 130
					-- upvalues: absoluteSize (copy), v39 (copy)
					return UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v39 - 100, (math.ceil(vector2.Y)))))
				end),
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = if not FFlagAddThumbnailSelectorReport then nil else Enum.ScrollBarInset.ScrollBar
				},
				onAbsoluteCanvasSizeChanged = function(p2) -- line: 146
					-- upvalues: v27 (copy)
					v27(p2.AbsoluteCanvasSize)
				end,
				onAbsoluteWindowSizeChanged = function(p3) -- line: 149
					-- upvalues: v29 (copy)
					v29(p3.AbsoluteWindowSize)
				end
			}, {
				Content = React.createElement(View, {
					tag = "auto-xy padding-x-xxsmall padding-top-medium",
					Size = if not FFlagAddThumbnailSelectorReport then UDim2.new(0, -v30, 0, 0) else UDim2.new(0, 0, 0, 0),
					onAbsoluteSizeChanged = function(p4) -- line: 157
						-- upvalues: v25 (copy)
						v25(p4.AbsoluteSize)
					end
				}, {
					ReportFlowHandler = React.createElement(ReportFlowHandler, {
						targetId = t1.targetId,
						abuseVector = t1.abuseVector,
						onSubmit = t1.onSubmit,
						custom = t1.custom
					})
				})
			})
		})
	})
end

return React.memo(DynamicReport)
