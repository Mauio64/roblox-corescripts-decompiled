local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("SplitPane").Parent

local MockableProxyServices = require(parent.MockableProxyServices)
local TelemetryService = MockableProxyServices.TelemetryService
local LoggingProtocol = require(parent.LoggingProtocol)
local Display = require(parent.Display)
local Responsive = require(parent.Responsive)

local _ = {
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

local endReason = {
	TooltipHiddenTimeout = 1,
	UserChanged = 2,
	HostUnmounted = 3,
	BreakpointLost = 4,
	DeepLink = 5
}

local v = { Collapsed = 1, Open = 2 }
local v2 = { Pointer = 1, Touch = 2, Gamepad = 3 }

local v3 = {
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

local v4 = {
	[endReason.TooltipHiddenTimeout] = "tooltip_hidden_timeout",
	[endReason.UserChanged] = "user_changed",
	[endReason.HostUnmounted] = "host_unmounted",
	[endReason.BreakpointLost] = "breakpoint_lost",
	[endReason.DeepLink] = "deep_link"
}

local v5 = {
	eventName = "splitPaneTourEvent",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SplitPaneTourEventTelemetryThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 10, 13 },
	description = "Split Pane educational tour lifecycle, from delivery through its ending."
}

local v6 = {
	eventName = "SplitPane_TourEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 13 },
	description = "Split Pane educational tour lifecycle events by type and end reason."
}

local standardizedFields = { "addSessionId", "addOSInfo" }

local run = nil

local function getInputMode(): number
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)

	if preferredInputType == Responsive.Input.Directional then
		return 3
	end

	return if preferredInputType == Responsive.Input.Touch then 2 else 1
end

local function getPaneState(flag: boolean): number
	return if flag then 1 else 2
end

local function getOrCreateRun() -- 4 equivalent calls inferred from this helper
	if run == nil then
		run = {
			id = HttpService:GenerateGUID(false),
			hasStarted = false,
			didTourOpenPane = false
		}
	end

	return run
end

local function log(event_type: number, p)
	local run2 = getOrCreateRun() -- inferred equivalent call
	local displayStore = Display.GetDisplayStore(false)
	local platformScale = displayStore.getPlatformScale(false)
	local clone = table.clone(p)
	clone.tour_run_id = run2.id
	clone.event_type = event_type
	local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
	local input_mode

	if preferredInputType == Responsive.Input.Directional then
		input_mode = v2.Gamepad
	elseif preferredInputType == Responsive.Input.Touch then
		input_mode = v2.Touch
	else
		input_mode = v2.Pointer
	end

	clone.input_mode = input_mode
	clone.start_pane_state = run2.startPaneState
	clone.viewport_width = math.round((displayStore.getDesignSpaceViewportWidth(false)))
	clone.viewport_height = math.round(displayStore.getViewportSize(false).Y / (not (platformScale and platformScale > 0) and 1 or platformScale))

	TelemetryService:LogEvent(v5, { standardizedFields = standardizedFields, customFields = clone })

	TelemetryService:LogCounter(v6, {
		customFields = {
			event_type = v3[event_type],
			end_reason = p.end_reason == nil and "none" or v4[p.end_reason]
		}
	}, 1)
end

local function getStepDurationMs() -- 2 equivalent calls inferred from this helper
	local stepShownAt

	if run ~= nil then
		stepShownAt = run.stepShownAt
	end

	if stepShownAt == nil then
		return nil
	end

	return (math.round((os.clock() - stepShownAt) * 1000))
end

local SplitPaneEducationalTourTelemetry = { EndReason = endReason }

function SplitPaneEducationalTourTelemetry.logDelivered(total_steps: number)
	if run ~= nil and run.hasStarted then
		return
	end

	run = nil
	log(1, { total_steps = total_steps })
end

function SplitPaneEducationalTourTelemetry.logStepShown(step_index: number, total_steps: number, flag: boolean)
	local run2 = getOrCreateRun() -- inferred equivalent call

	if step_index == 1 and not run2.hasStarted then
		run2.hasStarted = true
		local startPaneState = if flag then v.Collapsed else v.Open

		run2.startPaneState = startPaneState
		log(2, { step_index = 1, total_steps = total_steps })
	elseif step_index == 1 and run2.interruptedAtStep ~= nil then
		log(9, {
			step_index = 1,
			total_steps = total_steps,
			interrupted_at_step = run2.interruptedAtStep
		})
	end

	run2.interruptedAtStep = nil
	run2.stepShownAt = os.clock()
	log(3, { step_index = step_index, total_steps = total_steps })
end

function SplitPaneEducationalTourTelemetry.logStepAdvanced(step_index: number, total_steps: number, flag: boolean)
	if flag then
		local run = getOrCreateRun() -- inferred equivalent call
		run.didTourOpenPane = true
	end

	log(4, {
		step_index = step_index,
		total_steps = total_steps,
		step_duration_ms = getStepDurationMs() -- inferred equivalent call
	})
end

function SplitPaneEducationalTourTelemetry.logInterrupted(interruptedAtStep: number, total_steps: number)
	if run == nil or not run.hasStarted then
		return
	end

	local v7 = run
	v7.interruptedAtStep = interruptedAtStep
	v7.stepShownAt = nil
	log(8, {
		step_index = interruptedAtStep,
		total_steps = total_steps,
		interrupted_at_step = interruptedAtStep
	})
end

function SplitPaneEducationalTourTelemetry.logUserEnded(flag: boolean, step_index: number, total_steps: number, flag2: boolean)
	local v7 = {
		step_index = step_index,
		total_steps = total_steps,
		step_duration_ms = getStepDurationMs(), -- inferred equivalent call
		end_pane_state = 0,
		did_tour_open_pane = 0
	}
	local end_pane_state = if flag2 then v.Collapsed else v.Open

	v7.end_pane_state = end_pane_state
	v7.did_tour_open_pane = getOrCreateRun().didTourOpenPane -- inferred equivalent call
	log(flag and 6 or 5, v7)

	run = nil
end

function SplitPaneEducationalTourTelemetry.logAbandoned(end_reason: number, step_index: number, total_steps: number, flag: boolean)
	if run == nil then
		return
	end

	if not (step_index > 0) then
		step_index = nil
	end

	local end_pane_state = if flag then v.Collapsed else v.Open

	log(7, {
		step_index = step_index,
		total_steps = total_steps,
		end_pane_state = end_pane_state,
		end_reason = end_reason,
		did_tour_open_pane = run.didTourOpenPane,
		interrupted_at_step = run.interruptedAtStep
	})

	run = nil
end

return SplitPaneEducationalTourTelemetry
