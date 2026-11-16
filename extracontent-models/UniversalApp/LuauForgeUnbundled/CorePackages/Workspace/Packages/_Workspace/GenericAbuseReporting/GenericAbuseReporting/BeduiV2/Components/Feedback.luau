local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local alertSeverity = Foundation.Enums.AlertSeverity
local feedbackAlert = Foundation.FeedbackAlert
local view = Foundation.View

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
local telemetryEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService").TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local state = Motion.createState(
	{ groupTransparency = 1, position = UDim2.new(0, 0, -0.5, 0), sizeY = 0 },
	{
		default = Motion.transition(Motion.TransitionPreset.Default, {
			duration = 0.15
		})
	}
)

local v5 = {
	error = alertSeverity.Error,
	warning = alertSeverity.Warning,
	info = alertSeverity.Info,
	success = alertSeverity.Success
}

local function Feedback(props)
	local v6 = Motion.usePresence()
	local v7, v8 = Motion.useMotion(state)
	local ref = React.useRef(0)
	local ref2 = React.useRef(v6.isPresent)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	React.useEffect(function()
		if not v5[props.severity] then
			local v10 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v11 = if FFlagAbuseReportImproveErrorEvents then {
				error_message = "feedback missing correct severity",
				error_metadata = { received_severity = props.severity }
			} else {
				error_message = "feedback missing correct severity, received type: " .. tostring(props.severity)
			}
			v10.error_detail = v11
			sendEvent(v10)
		end
	end, { props.severity, sendEvent })

	React.useEffect(function()
		ref2.current = v6.isPresent
	end, { v6.isPresent })

	React.useEffect(function()
		if v6.isPresent then
			if ref.current > 0 then
				v8({
					groupTransparency = 0,
					position = UDim2.new(0, 0, 0, 1),
					sizeY = ref.current + 2 + (props.bottomMargin or 0)
				})
			end
		else
			v8({ groupTransparency = 1, position = UDim2.new(0, 0, -0.5, 0), sizeY = 0 }, {
				onAnimationComplete = function(p2)
					if p2 == true then
						v6.onExitComplete()
					end
				end
			})
		end
	end, { v6.isPresent, v8, v6.onExitComplete, props.bottomMargin })

	local v9 = React.useCallback(function(p2)
		local y = p2.AbsoluteSize.Y

		if y <= 0 or y == ref.current then
			return
		end

		ref.current = y

		if ref2.current then
			v8({
				groupTransparency = 0,
				position = UDim2.new(0, 0, 0, 1),
				sizeY = y + 2 + (props.bottomMargin or 0)
			})
		end
	end, { v8, props.bottomMargin })

	local maxWidth = props.maxWidth
	return React.createElement(view, {
		Size = v7.sizeY:map(function(p2)
			if maxWidth == nil then
				return UDim2.new(1, 0, 0, p2)
			end

			return UDim2.new(0, maxWidth, 0, p2)
		end),
		ClipsDescendants = true,
		LayoutOrder = props.layoutOrder
	}, {
		Content = React.createElement("CanvasGroup", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = v7.groupTransparency,
			Position = v7.position,
			[React.Change.AbsoluteSize] = v9
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1)
			}),
			Alert = React.createElement(feedbackAlert, {
				severity = v5[props.severity] or alertSeverity.Info,
				title = props.title,
				subtitle = props.subtitle,
				onClose = props.onClose
			})
		})
	})
end

return React.memo(Feedback)
