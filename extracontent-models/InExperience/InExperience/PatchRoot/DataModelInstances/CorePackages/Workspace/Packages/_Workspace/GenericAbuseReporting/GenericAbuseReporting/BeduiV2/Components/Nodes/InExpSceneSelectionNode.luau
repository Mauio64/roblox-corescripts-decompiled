local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local inExpSceneSelectionAdapter = require(script.Parent.inExpSceneSelectionAdapter)
local getIsInExpSceneSelectionAvailable = require(script.Parent.getIsInExpSceneSelectionAvailable)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local submitSource = analyticsService.SubmitSource
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function InExpSceneSelectionNode(current)
	local state, setState = React.useState(current.loadingText)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v = useLayoutSlots()
	local layout = v.Layout
	local title = v.Title

	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(sendEvent)
	ref2.current = sendEvent

	React.useEffect(function()
		if getIsInExpSceneSelectionAvailable() then
			local connection = nil
			connection = inExpSceneSelectionAdapter.subscribeOnceToExitReason(function(p)
				connection = nil
				ref2.current({
					sub_event_type = telemetryEventType.SceneCaptureResult,
					scene_capture_detail = {
						exit_reason = p.reason,
						success = p.reason == "submit"
					}
				})

				local current2 = ref.current

				if p.reason == "submit" then
					if current2.onExternalSubmit then
						current2.onExternalSubmit(submitSource.SceneSelection)
					end

					if current2.onNext then
						current2.onNext()
					end
				elseif current2.goBack then
					current2.goBack()
				end
			end)

			if not pcall(inExpSceneSelectionAdapter.start) then
				ref2.current({
					sub_event_type = telemetryEventType.SceneCaptureResult,
					scene_capture_detail = { exit_reason = "start_failed", success = false }
				})

				if connection then
					connection:Disconnect()
					connection = nil
				end

				local current2 = ref.current

				if current2.onFailure then
					current2.onFailure()
				else
					setState(current2.errorText)
				end
			end

			return function()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		else
			ref2.current({
				sub_event_type = telemetryEventType.SceneCaptureResult,
				scene_capture_detail = { exit_reason = "unavailable", success = false }
			})

			local current2 = ref.current

			if current2.onFailure then
				current2.onFailure()
			else
				setState(current2.errorText)
			end
		end
	end, {})

	local createElement = React.createElement
	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v2 = {
		Title = React.createElement(title, { input = current.title, layoutOrder = 1 }),
		Message = 0
	}
	local message

	if state then
		message = React.createElement(TextWithTranslation, {
			input = state,
			tag = "size-full-0 auto-y text-body-small",
			layoutOrder = 2
		})
	end

	v2.Message = message
	return createElement(layout, {
		body = createElement2(fragment, nil, v2)
	})
end

return React.memo(InExpSceneSelectionNode)
