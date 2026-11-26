local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local scrollView = Foundation.ScrollView
local view = Foundation.View
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local BeduiAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/BeduiAnalytics")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/ReportFlowHandler")
local useAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useAnalyticsContext")
local useOnScreenKeyboardHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/useOnScreenKeyboardHeight")
local useScrollbarOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/useScrollbarOffset")

local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local telemetryEventType = BeduiAnalytics.TelemetryEventType

local function DynamicReport(props)
	local absoluteSize = useLayerCollector().absoluteSize
	local v5, v6 = React.useBinding(Vector2.new(0, 0))
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local v7 = useScrollbarOffset(state, state2)
	local v8 = useOnScreenKeyboardHeight()
	local isKeyboardShowing = v8.isKeyboardShowing
	local onScreenKeyboardHeight = v8.onScreenKeyboardHeight
	local keyboardPositionY = v8.keyboardPositionY

	local v9 = useLocalization({ reportTitle = "Feature.ReportAbuse.Label.Report" })

	local v10 = useAnalyticsContext()
	local isReportSubmitted = v10.isReportSubmitted

	local v11 = useSelector(function(p2)
		if p2.GlobalGuiInset then
			return p2.GlobalGuiInset.top
		end

		return 0
	end)

	local v12 = React.useMemo(function()
		if not isKeyboardShowing then
			return 0
		end

		local v13 = keyboardPositionY - v11

		local v14 = absoluteSize.Y - v13

		if v14 <= 0 then
			return 0
		end

		return (math.min(v14, onScreenKeyboardHeight))
	end, {
		isKeyboardShowing,
		keyboardPositionY,
		onScreenKeyboardHeight,
		absoluteSize.Y,
		v11
	})

	local v13 = React.useMemo(function()
		if isKeyboardShowing then
			return -v12
		end

		return 0
	end, { isKeyboardShowing, v12 })

	React.useEffect(function()
		sendAnalyticsEvent({
			eventType = telemetryEventType.Rendered,
			context = { abuseVector = props.abuseVector }
		})
	end, { sendAnalyticsEvent, props.abuseVector })

	local v14 = React.useCallback(function()
		if not isReportSubmitted then
			sendAnalyticsEvent({
				eventType = telemetryEventType.Abandoned,
				context = v10
			})
		end

		props.onClose()
	end, { isReportSubmitted, sendAnalyticsEvent, v10, props.onClose })

	local createElement = React.createElement
	local v16 = {
		title = v9.reportTitle,
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y),
		position = 0,
		anchorPoint = 0,
		onCloseClicked = 0
	}
	local v17 = if isKeyboardShowing then UDim2.new(0.5, 0, 1, v13) else nil
	v16.position = v17
	local v18 = if isKeyboardShowing then Vector2.new(0.5, 1) else nil
	v16.anchorPoint = v18
	v16.onCloseClicked = v14

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v24 = {
		Size = v5:map(function(p2)
			return UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v12 - 100, (math.ceil(p2.Y)))))
		end),
		scroll = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onAbsoluteWindowSizeChanged = 0
	}

	local v25 = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = 0
	}

	local v26 = if fFlagAddThumbnailSelectorReport then Enum.ScrollBarInset.ScrollBar else nil
	v25.VerticalScrollBarInset = v26
	v24.scroll = v25

	function v24.onAbsoluteCanvasSizeChanged(p2)
		setState(p2.AbsoluteCanvasSize)
	end
	function v24.onAbsoluteWindowSizeChanged(p2)
		setState2(p2.AbsoluteWindowSize)
	end

	local createElement4 = React.createElement

	local v30 = if fFlagAddThumbnailSelectorReport then UDim2.new(0, 0, 0, 0) else UDim2.new(0, -v7, 0, 0)
	return createElement(partialPageModal, v16, {
		View = createElement2(view, { tag = "size-full-0 auto-y" }, {
			ScrollView = createElement3(scrollView, v24, {
				Content = createElement4(view, {
					Size = v30,
					onAbsoluteSizeChanged = function(p2)
						v6(p2.AbsoluteSize)
					end,
					tag = "auto-xy padding-x-xxsmall padding-top-medium"
				}, {
					ReportFlowHandler = React.createElement(module6, {
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
