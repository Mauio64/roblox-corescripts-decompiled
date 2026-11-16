local HttpService = game:GetService("HttpService")

local telemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/MockableProxyServices").TelemetryService
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/LoggingProtocol")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Display")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")

local v5 = {
	Delivered = 1,
	Started = 2,
	StepShown = 3,
	StepAdvanced = 4,
	Skipped = 5,
	Completed = 6,
	Abandoned = 7,
	Interrupted = 8,
	Restarted = 9
}

local v6 = {
	TooltipHiddenTimeout = 1,
	UserChanged = 2,
	HostUnmounted = 3,
	BreakpointLost = 4,
	DeepLink = 5
}

local v7 = { Collapsed = 1, Open = 2 }
local v8 = { Pointer = 1, Touch = 2, Gamepad = 3 }

local v9 = {
	"delivered",
	"started",
	"step_shown",
	"step_advanced",
	"skipped",
	"completed",
	"abandoned",
	"interrupted",
	"restarted"
}

local v10 = {
	[v6.TooltipHiddenTimeout] = "tooltip_hidden_timeout",
	[v6.UserChanged] = "user_changed",
	[v6.HostUnmounted] = "host_unmounted",
	[v6.BreakpointLost] = "breakpoint_lost",
	[v6.DeepLink] = "deep_link"
}

local v11 = {
	eventName = "splitPaneTourEvent",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SplitPaneTourEventTelemetryThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 10, 13 },
	description = "Split Pane educational tour lifecycle, from delivery through its ending."
}

local v12 = {
	eventName = "SplitPane_TourEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 13 },
	description = "Split Pane educational tour lifecycle events by type and end reason."
}

local v13 = { "addSessionId", "addOSInfo" }

local run = nil

local function getInputMode(): number
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)

	if preferredInputType == Responsive.Input.Directional then
		return 3
	end

	if preferredInputType == Responsive.Input.Touch then
		return 2
	end

	return 1
end

local function getPaneState(p2): number
	if p2 then
		return 1
	end

	return 2
end

local function getOrCreateRun()
	if run == nil then
		run = {
			id = HttpService:GenerateGUID(false),
			hasStarted = false,
			didTourOpenPane = false
		}
	end

	return run
end

local function log(event_type, p2)
	if run == nil then
		run = {
			id = HttpService:GenerateGUID(false),
			hasStarted = false,
			didTourOpenPane = false
		}
	end

	local v14 = run

	local displayStore = Display.GetDisplayStore(false)
	local platformScale = displayStore.getPlatformScale(false)
	local clone = table.clone(p2)
	clone.tour_run_id = v14.id
	clone.event_type = event_type
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
	local v15

	if preferredInputType == Responsive.Input.Directional then
		v15 = v8.Gamepad
	else
		v15 = if preferredInputType == Responsive.Input.Touch then v8.Touch else v8.Pointer
	end

	clone.input_mode = v15
	clone.start_pane_state = v14.startPaneState
	clone.viewport_width = math.round((displayStore.getDesignSpaceViewportWidth(false)))
	clone.viewport_height = math.round(displayStore.getViewportSize(false).Y / (not (platformScale and platformScale > 0) and 1 or platformScale))

	telemetryService:LogEvent(v11, { standardizedFields = v13, customFields = clone })

	telemetryService:LogCounter(v12, {
		customFields = {
			event_type = v9[event_type],
			end_reason = p2.end_reason == nil and "none" or v10[p2.end_reason]
		}
	}, 1)
end

local function getStepDurationMs()
	local stepShownAt = if run ~= nil then run.stepShownAt else nil

	if stepShownAt == nil then
		return nil
	end

	return (math.round((os.clock() - stepShownAt) * 1000))
end

local v14 = { EndReason = v6 }

function v14.logDelivered(p2)
	if run ~= nil and run.hasStarted then
		return
	end

	run = nil
	log(1, { total_steps = p2 })
end

function v14.logStepShown(p2, p3, p4)
	if run == nil then
		run = {
			id = HttpService:GenerateGUID(false),
			hasStarted = false,
			didTourOpenPane = false
		}
	end

	local v15 = run

	if p2 == 1 and not v15.hasStarted then
		v15.hasStarted = true
		local v16 = if p4 then v7.Collapsed else v7.Open

		v15.startPaneState = v16
		log(2, { step_index = 1, total_steps = p3 })
	elseif p2 == 1 and v15.interruptedAtStep ~= nil then
		log(9, {
			step_index = 1,
			total_steps = p3,
			interrupted_at_step = v15.interruptedAtStep
		})
	end

	v15.interruptedAtStep = nil
	v15.stepShownAt = os.clock()
	log(3, { step_index = p2, total_steps = p3 })
end

function v14.logStepAdvanced(p2, p3, p4)
	if p4 then
		if run == nil then
			run = {
				id = HttpService:GenerateGUID(false),
				hasStarted = false,
				didTourOpenPane = false
			}
		end

		run.didTourOpenPane = true
	end

	local stepShownAt = if run ~= nil then run.stepShownAt else nil
	local v18 = if stepShownAt ~= nil then math.round((os.clock() - stepShownAt) * 1000) else nil

	log(4, { step_index = p2, total_steps = p3, step_duration_ms = v18 })
end

function v14.logInterrupted(interruptedAtStep, p2)
	if run == nil or not run.hasStarted then
		return
	end

	local v15 = run
	v15.interruptedAtStep = interruptedAtStep
	v15.stepShownAt = nil
	log(8, {
		step_index = interruptedAtStep,
		total_steps = p2,
		interrupted_at_step = interruptedAtStep
	})
end

function v14.logUserEnded(p2, p3, p4, p5)
	local stepShownAt = if run ~= nil then run.stepShownAt else nil
	local v18 = if stepShownAt ~= nil then math.round((os.clock() - stepShownAt) * 1000) else nil
	local v19 = if p5 then v7.Collapsed else v7.Open

	if run == nil then
		run = {
			id = HttpService:GenerateGUID(false),
			hasStarted = false,
			didTourOpenPane = false
		}
	end

	log(p2 and 6 or 5, {
		step_index = p3,
		total_steps = p4,
		step_duration_ms = v18,
		end_pane_state = v19,
		did_tour_open_pane = run.didTourOpenPane
	})

	run = nil
end

function v14.logAbandoned(end_reason, step_index, total_steps, p2)
	if run == nil then
		return
	end

	if not (step_index > 0) then
		step_index = nil
	end

	local v18 = if p2 then v7.Collapsed else v7.Open

	log(7, {
		step_index = step_index,
		total_steps = total_steps,
		end_pane_state = v18,
		end_reason = end_reason,
		did_tour_open_pane = run.didTourOpenPane,
		interrupted_at_step = run.interruptedAtStep
	})

	run = nil
end

return v14
