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

local SubmitSource = analyticsService.SubmitSource
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagAbuseReportSceneSelectionSubmitTracking = require(GenericAbuseReporting.Flags.FFlagAbuseReportSceneSelectionSubmitTracking)

local function InExpSceneSelectionNode(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), getIsInExpSceneSelectionAvailable (copy), TelemetryEventType (copy), inExpSceneSelectionAdapter (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy), TextWithTranslation (copy)
	local v17, v18 = React.useState(t1.loadingText)
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local v20 = useLayoutSlots()
	local Layout = v20.Layout
	local Title = v20.Title
	local v23 = React.useRef(t1)

	v23.current = t1

	local v24 = React.useRef(sendEvent)

	v24.current = sendEvent
	React.useEffect(function() -- line: 53
		-- upvalues: getIsInExpSceneSelectionAvailable (copy), v24 (copy), TelemetryEventType (copy), v18 (copy), v23 (copy), inExpSceneSelectionAdapter (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy)
		if not getIsInExpSceneSelectionAvailable() then
			v24.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = "unavailable",
					success = false
				}
			})
			v18(v23.current.errorText)

			return
		end

		local u25 = nil

		u25 = inExpSceneSelectionAdapter.subscribeOnceToExitReason(function(p1) -- line: 71
			-- upvalues: u25 (ref), v24 (copy), TelemetryEventType (copy), v23 (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy)
			u25 = nil
			v24.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = p1.reason,
					success = p1.reason == "submit"
				}
			})

			local current = v23.current

			if p1.reason == "submit" then
				if FFlagAbuseReportSceneSelectionSubmitTracking and current.onExternalSubmit then
					current.onExternalSubmit(SubmitSource.SceneSelection)
				end

				if current.onNext then
					current.onNext()

					return
				end
			elseif current.goBack then
				current.goBack()
			end
		end)

		if not pcall(inExpSceneSelectionAdapter.start) then
			v24.current({
				sub_event_type = TelemetryEventType.SceneCaptureResult,
				scene_capture_detail = {
					exit_reason = "start_failed",
					success = false
				}
			})
			v18(v23.current.errorText)

			if u25 then
				u25:Disconnect()
				u25 = nil
			end
		end

		return function() -- line: 111
			-- upvalues: u25 (ref)
			if u25 then
				u25:Disconnect()
				u25 = nil
			end
		end
	end, {})

	return React.createElement(Layout, {
		body = React.createElement(React.Fragment, nil, {
			Title = React.createElement(Title, {
				layoutOrder = 1,
				input = t1.title
			}),
			Message = if not v17 then nil else React.createElement(TextWithTranslation, {
				tag = "size-full-0 auto-y text-body-small",
				layoutOrder = 2,
				input = v17
			})
		})
	})
end

return React.memo(InExpSceneSelectionNode)
