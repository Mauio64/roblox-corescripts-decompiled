local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)

local AlertSeverity = Foundation.Enums.AlertSeverity
local FeedbackAlert = Foundation.FeedbackAlert
local View = Foundation.View

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)

local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local state = Motion.createState({
	groupTransparency = 1,
	position = UDim2.new(0, 0, -0.5, 0),
	sizeY = 0
}, {
	default = Motion.transition(Motion.TransitionPreset.Default, { duration = 0.15 })
})

local v = {
	error = AlertSeverity.Error,
	warning = AlertSeverity.Warning,
	info = AlertSeverity.Info,
	success = AlertSeverity.Success
}

local function Feedback(props)
	local v2 = Motion.usePresence()
	local v3, v4 = Motion.useMotion(state)
	local ref = React.useRef(0)
	local ref2 = React.useRef(v2.isPresent)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	React.useEffect(function()
		if not v[props.severity] then
			local v5 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = {
					error_message = "feedback missing correct severity",
					error_metadata = { received_severity = props.severity }
				}
			else
				error_detail = {
					error_message = "feedback missing correct severity, received type: " .. tostring(props.severity)
				}
			end

			v5.error_detail = error_detail
			sendEvent(v5)
		end
	end, { props.severity, sendEvent })

	React.useEffect(function()
		ref2.current = v2.isPresent
	end, { v2.isPresent })

	React.useEffect(function()
		if v2.isPresent then
			if ref.current > 0 then
				v4({
					groupTransparency = 0,
					position = UDim2.new(0, 0, 0, 1),
					sizeY = ref.current + 2 + (props.bottomMargin or 0)
				})
			end
		else
			v4({ groupTransparency = 1, position = UDim2.new(0, 0, -0.5, 0), sizeY = 0 }, {
				onAnimationComplete = function(p)
					if p == true then
						v2.onExitComplete()
					end
				end
			})
		end
	end, { v2.isPresent, v4, v2.onExitComplete, props.bottomMargin })

	local v5 = React.useCallback(function(p)
		local y = p.AbsoluteSize.Y

		if y <= 0 or y == ref.current then
			return
		end

		ref.current = y

		if ref2.current then
			v4({
				groupTransparency = 0,
				position = UDim2.new(0, 0, 0, 1),
				sizeY = y + 2 + (props.bottomMargin or 0)
			})
		end
	end, { v4, props.bottomMargin })

	local maxWidth = props.maxWidth
	return React.createElement(View, {
		Size = v3.sizeY:map(function(p: number)
			if maxWidth == nil then
				return UDim2.new(1, 0, 0, p)
			end

			return UDim2.new(0, maxWidth, 0, p)
		end),
		ClipsDescendants = true,
		LayoutOrder = props.layoutOrder
	}, {
		Content = React.createElement("CanvasGroup", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = v3.groupTransparency,
			Position = v3.position,
			[React.Change.AbsoluteSize] = v5
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1)
			}),
			Alert = React.createElement(FeedbackAlert, {
				severity = v[props.severity] or AlertSeverity.Info,
				title = props.title,
				subtitle = props.subtitle,
				onClose = props.onClose
			})
		})
	})
end

return React.memo(Feedback)
