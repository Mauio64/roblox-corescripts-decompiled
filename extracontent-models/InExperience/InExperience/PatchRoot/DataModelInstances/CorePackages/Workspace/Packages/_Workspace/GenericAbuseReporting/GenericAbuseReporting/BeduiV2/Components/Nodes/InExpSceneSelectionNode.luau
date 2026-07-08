local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local inExpSceneSelectionAdapter = require(script.Parent.inExpSceneSelectionAdapter)
local getIsInExpSceneSelectionAvailable = require(script.Parent.getIsInExpSceneSelectionAvailable)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function InExpSceneSelectionNode(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), getIsInExpSceneSelectionAvailable (copy), TelemetryEventType (copy), inExpSceneSelectionAdapter (copy), TextWithTranslation (copy)
	local v15, v16 = React.useState(t1.loadingText)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v18 = useLayoutSlots()
	local Layout = v18.Layout
	local Title = v18.Title
	local v21 = React.useRef(t1)

	v21.current = t1

	local v22 = React.useRef(sendEvent)

	v22.current = sendEvent
	React.useEffect(function() -- line: 46
		-- upvalues: getIsInExpSceneSelectionAvailable (copy), v22 (copy), TelemetryEventType (copy), v16 (copy), v21 (copy), inExpSceneSelectionAdapter (copy)
		if not getIsInExpSceneSelectionAvailable() then
			v22.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = "unavailable",
					success = false
				}
			})
			v16(v21.current.errorText)

			return
		end

		local u23 = nil

		u23 = inExpSceneSelectionAdapter.subscribeOnceToExitReason(function(p1) -- line: 64
			-- upvalues: u23 (ref), v22 (copy), TelemetryEventType (copy), v21 (copy)
			u23 = nil
			v22.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = p1.reason,
					success = p1.reason == "submit"
				}
			})

			local current = v21.current

			if p1.reason == "submit" then
				if current.onNext then
					current.onNext()

					return
				end
			elseif current.goBack then
				current.goBack()
			end
		end)

		if not pcall(inExpSceneSelectionAdapter.start) then
			v22.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = "start_failed",
					success = false
				}
			})
			v16(v21.current.errorText)

			if u23 then
				u23:Disconnect()
				u23 = nil
			end
		end

		return function() -- line: 101
			-- upvalues: u23 (ref)
			if u23 then
				u23:Disconnect()
				u23 = nil
			end
		end
	end, {})

	return React.createElement(Layout, {
		body = React.createElement(React.Fragment, nil, {
			Title = React.createElement(Title, {
				layoutOrder = 1,
				input = t1.title
			}),
			Message = if not v15 then nil else React.createElement(TextWithTranslation, {
				tag = "size-full-0 auto-y text-body-small",
				layoutOrder = 2,
				input = v15
			})
		})
	})
end

return React.memo(InExpSceneSelectionNode)
