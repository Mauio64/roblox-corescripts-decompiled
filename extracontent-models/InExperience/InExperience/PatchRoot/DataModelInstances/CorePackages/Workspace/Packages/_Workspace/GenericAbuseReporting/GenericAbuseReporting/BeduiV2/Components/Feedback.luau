local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local Motion = require(GenericAbuseReportingParent.Motion)
local React = require(GenericAbuseReportingParent.React)
local AlertSeverity = Foundation.Enums.AlertSeverity
local FeedbackAlert = Foundation.FeedbackAlert
local View = Foundation.View
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local TelemetryEventType = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService).TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local v12 = Motion.createState({
	groupTransparency = 1,
	sizeY = 0,
	position = UDim2.new(0, 0, -0.5, 0)
}, {
	default = Motion.transition(Motion.TransitionPreset.Default, {
		duration = 0.15
	})
})
local t1 = {
	error = AlertSeverity.Error,
	warning = AlertSeverity.Warning,
	info = AlertSeverity.Info,
	success = AlertSeverity.Success
}

local function Feedback(t2: {[any]: any}) -- line: 45
	-- upvalues: Motion (copy), v12 (copy), React (copy), useAbuseReportAnalytics (copy), t1 (copy), TelemetryEventType (copy), View (copy), FeedbackAlert (copy), AlertSeverity (copy)
	local v16 = Motion.usePresence()
	local v17, v18 = Motion.useMotion(v12)
	local v19 = React.useRef(0)
	local v20 = React.useRef(v16.isPresent)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	React.useEffect(function() -- line: 52
		-- upvalues: t1 (copy), t2 (copy), sendEvent (copy), TelemetryEventType (copy)
		if not t1[t2.severity] then
			sendEvent({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "feedback missing correct severity, received type: " .. tostring(t2.severity)
				}
			})
		end
	end, {
		t2.severity,
		sendEvent
	})
	React.useEffect(function() -- line: 63
		-- upvalues: v20 (copy), v16 (copy)
		v20.current = v16.isPresent
	end, { v16.isPresent })
	React.useEffect(function() -- line: 67
		-- upvalues: v16 (copy), v19 (copy), v18 (copy), t2 (copy)
		if v16.isPresent then
			if v19.current > 0 then
				v18({
					groupTransparency = 0,
					position = UDim2.new(0, 0, 0, 1),
					sizeY = v19.current + 2 + (t2.bottomMargin or 0)
				})

				return
			end
		else
			v18({
				groupTransparency = 1,
				sizeY = 0,
				position = UDim2.new(0, 0, -0.5, 0)
			}, {
				onAnimationComplete = function(p1) -- line: 82
					-- upvalues: v16 (copy)
					if p1 == true then
						v16.onExitComplete()
					end
				end
			})
		end
	end, {
		v16.isPresent,
		v18,
		v16.onExitComplete,
		t2.bottomMargin
	})

	local v22 = React.useCallback(function(p2) -- line: 91
		-- upvalues: v19 (copy), v20 (copy), v18 (copy), t2 (copy)
		local AbsoluteSizeY = p2.AbsoluteSize.Y

		if AbsoluteSizeY <= 0 or AbsoluteSizeY == v19.current then
			return
		end

		v19.current = AbsoluteSizeY

		if v20.current then
			v18({
				groupTransparency = 0,
				position = UDim2.new(0, 0, 0, 1),
				sizeY = AbsoluteSizeY + 2 + (t2.bottomMargin or 0)
			})
		end
	end, {
		v18,
		t2.bottomMargin
	})
	local maxWidth = t2.maxWidth

	return React.createElement(View, {
		ClipsDescendants = true,
		Size = v17.sizeY:map(function(n1: number) -- line: 110
			-- upvalues: maxWidth (copy)
			if maxWidth ~= nil then
				return UDim2.new(0, maxWidth, 0, n1)
			end

			return UDim2.new(1, 0, 0, n1)
		end),
		LayoutOrder = t2.layoutOrder
	}, {
		Content = React.createElement("CanvasGroup", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = v17.groupTransparency,
			Position = v17.position,
			[React.Change.AbsoluteSize] = v22
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1)
			}),
			Alert = React.createElement(FeedbackAlert, {
				severity = t1[t2.severity] or AlertSeverity.Info,
				title = t2.title,
				subtitle = t2.subtitle,
				onClose = t2.onClose
			})
		})
	})
end

return React.memo(Feedback)
