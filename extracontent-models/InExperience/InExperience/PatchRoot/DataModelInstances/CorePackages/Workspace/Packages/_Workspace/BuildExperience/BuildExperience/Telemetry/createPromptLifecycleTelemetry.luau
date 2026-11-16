local BuildExperience = script:FindFirstAncestor("BuildExperience")

local chatConstants = require(BuildExperience.Chat.chatConstants)
local reportPromptFirstResponseLatency = require(BuildExperience.Telemetry.reportPromptFirstResponseLatency)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local v = { FirstResponse = "first_response", MidTurn = "mid_turn" }

local function createPromptLifecycleTelemetry(callback)
	local now = nil
	local v2 = nil
	local v3 = nil
	local v4 = false
	local v5 = false
	local v6 = false
	local thread = nil

	local function cancelStallTimer() -- 2 equivalent calls inferred from this helper
		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end
	end

	local function getMsSince(p: number?) -- 6 equivalent calls inferred from this helper
		if p == nil then
			return 0
		end

		return (math.max(0, (math.round((os.clock() - p) * 1000))))
	end

	local function getLifecycleParameters()
		local lifecycleParameters = {
			elapsedMs = tostring(getMsSince(now)), -- inferred equivalent call
			receivedResponse = tostring(v3 ~= nil),
			stalled = tostring(v4)
		}

		if v3 ~= nil then
			lifecycleParameters.firstResponseMs = tostring(v3)
		end

		return lifecycleParameters
	end

	local function reportStall(p: number)
		v4 = true

		local lifecycleParameters = getLifecycleParameters()
		lifecycleParameters.stage = v3 == nil and "first_response" or "mid_turn"

		lifecycleParameters.idleMs = tostring(getMsSince(v2)) -- inferred equivalent call
		lifecycleParameters.thresholdSeconds = tostring(p)

		sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
	end

	local function scheduleStallCheck(duration: number)
		thread = task.delay(duration, function()
			thread = nil

			if v6 or v5 or v2 == nil then
				return
			end

			local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
			local v7 = PROMPT_STALL_SECONDS - (os.clock() - v2)

			if v7 > 0 then
				scheduleStallCheck(v7)
				return
			end

			v4 = true

			local lifecycleParameters = getLifecycleParameters()
			local stage

			if v3 == nil then
				stage = v.FirstResponse
			else
				stage = v.MidTurn
			end

			lifecycleParameters.stage = stage

			lifecycleParameters.idleMs = tostring(getMsSince(v2)) -- inferred equivalent call
			lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS)

			sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
		end)
	end

	local function finish() -- 1 equivalent call inferred from this helper
		v6 = true
		cancelStallTimer() -- inferred equivalent call
	end

	return {
		start = function()
			if now ~= nil or v6 then
				return
			end

			now = os.clock()
			v2 = now
			sendBuildExperienceEvent("SEND_PROMPT_START", callback())

			local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
			thread = task.delay(PROMPT_STALL_SECONDS, function()
				thread = nil

				if v6 or v5 or v2 == nil then
					return
				end

				local PROMPT_STALL_SECONDS2 = chatConstants.PROMPT_STALL_SECONDS
				local v7 = PROMPT_STALL_SECONDS2 - (os.clock() - v2)

				if v7 > 0 then
					scheduleStallCheck(v7)
					return
				end

				v4 = true

				local lifecycleParameters = getLifecycleParameters()
				local stage

				if v3 == nil then
					stage = v.FirstResponse
				else
					stage = v.MidTurn
				end

				lifecycleParameters.stage = stage

				lifecycleParameters.idleMs = tostring(getMsSince(v2)) -- inferred equivalent call
				lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS2)

				sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
			end)
		end,
		markActivity = function(p)
			if now == nil or v6 then
				return
			end

			v2 = os.clock()
			v5 = p.isWaitingOnUser

			if p.hasResponse and v3 == nil then
				local msSince = getMsSince(now) -- inferred equivalent call
				v3 = msSince

				reportPromptFirstResponseLatency(msSince, v4)
			end

			if v5 then
				cancelStallTimer() -- inferred equivalent call
			elseif thread == nil then
				local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
				thread = task.delay(PROMPT_STALL_SECONDS, function()
					thread = nil

					if v6 or v5 or v2 == nil then
						return
					end

					local PROMPT_STALL_SECONDS2 = chatConstants.PROMPT_STALL_SECONDS
					local v7 = PROMPT_STALL_SECONDS2 - (os.clock() - v2)

					if v7 > 0 then
						scheduleStallCheck(v7)
						return
					end

					v4 = true

					local lifecycleParameters = getLifecycleParameters()
					local stage

					if v3 == nil then
						stage = v.FirstResponse
					else
						stage = v.MidTurn
					end

					lifecycleParameters.stage = stage

					lifecycleParameters.idleMs = tostring(getMsSince(v2)) -- inferred equivalent call
					lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS2)

					sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
				end)
			end
		end,
		reportUserStop = function()
			if now == nil or v6 then
				return
			end

			sendBuildExperienceEvent("SEND_PROMPT_STOPPED", callback(), getLifecycleParameters())
			finish() -- inferred equivalent call
		end,
		finish = finish,
		getLifecycleParameters = getLifecycleParameters
	}
end

return createPromptLifecycleTelemetry
