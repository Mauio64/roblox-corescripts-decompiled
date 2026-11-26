local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local inExpSceneSelectionAdapter = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/inExpSceneSelectionAdapter")
local getIsInExpSceneSelectionAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/getIsInExpSceneSelectionAvailable")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local submitSource = analyticsService.SubmitSource
local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function InExpSceneSelectionNode(current)
	local state, setState = React.useState(current.loadingText)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	local v5 = useLayoutSlots()
	local layout = v5.Layout
	local title = v5.Title

	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(sendEvent)
	ref2.current = sendEvent

	React.useEffect(function()
		if getIsInExpSceneSelectionAvailable() then
			local connection = nil
			connection = inExpSceneSelectionAdapter.subscribeOnceToExitReason(function(p2)
				connection = nil
				ref2.current({
					sub_event_type = telemetryEventType.SceneCaptureResult,
					scene_capture_detail = {
						exit_reason = p2.reason,
						success = p2.reason == "submit"
					}
				})

				local current2 = ref.current

				if p2.reason == "submit" then
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
					scene_capture_detail = {
						exit_reason = "start_failed",
						success = false
					}
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
	local v8 = {
		Title = React.createElement(title, { input = current.title, layoutOrder = 1 }),
		Message = 0
	}

	local v9 = if state then React.createElement(TextWithTranslation, {
		input = state,
		tag = "size-full-0 auto-y text-body-small",
		layoutOrder = 2
	}) else nil
	v8.Message = v9
	return createElement(layout, {
		body = createElement2(fragment, nil, v8)
	})
end

return React.memo(InExpSceneSelectionNode)
