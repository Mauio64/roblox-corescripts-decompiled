local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local reportPromptFirstResponseLatency = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/reportPromptFirstResponseLatency")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local v5 = { FirstResponse = "first_response", MidTurn = "mid_turn" }

local function createPromptLifecycleTelemetry(callback)
	local now = nil
	local v6 = nil
	local v7 = nil
	local v8 = false
	local v9 = false
	local v10 = false
	local thread = nil

	local function cancelStallTimer()
		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end
	end

	local function getMsSince(p2)
		if p2 == nil then
			return 0
		end

		return (math.max(0, (math.round((os.clock() - p2) * 1000))))
	end

	local function getLifecycleParameters()
		local v11 = now
		local lifecycleParameters = {
			elapsedMs = tostring(v11 == nil and 0 or math.max(0, (math.round((os.clock() - v11) * 1000)))),
			receivedResponse = tostring(v7 ~= nil),
			stalled = tostring(v8)
		}

		if v7 ~= nil then
			lifecycleParameters.firstResponseMs = tostring(v7)
		end

		return lifecycleParameters
	end

	local function reportStall(p2)
		v8 = true

		local lifecycleParameters = getLifecycleParameters()
		lifecycleParameters.stage = v7 == nil and "first_response" or "mid_turn"

		local v11 = v6
		lifecycleParameters.idleMs = tostring(v11 == nil and 0 or math.max(0, (math.round((os.clock() - v11) * 1000))))
		lifecycleParameters.thresholdSeconds = tostring(p2)

		sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
	end

	local function scheduleStallCheck(duration)
		thread = task.delay(duration, function()
			thread = nil

			if v10 or v9 or v6 == nil then
				return
			end

			local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
			local v11 = PROMPT_STALL_SECONDS - (os.clock() - v6)

			if v11 > 0 then
				scheduleStallCheck(v11)
				return
			end

			v8 = true

			local lifecycleParameters = getLifecycleParameters()
			local v12 = if v7 == nil then v5.FirstResponse else v5.MidTurn
			lifecycleParameters.stage = v12

			local v13 = v6
			lifecycleParameters.idleMs = tostring(v13 == nil and 0 or math.max(0, (math.round((os.clock() - v13) * 1000))))
			lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS)

			sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
		end)
	end

	return {
		start = function()
			if now ~= nil or v10 then
				return
			end

			now = os.clock()
			v6 = now
			sendBuildExperienceEvent("SEND_PROMPT_START", callback())

			local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
			thread = task.delay(PROMPT_STALL_SECONDS, function()
				thread = nil

				if v10 or v9 or v6 == nil then
					return
				end

				local PROMPT_STALL_SECONDS2 = chatConstants.PROMPT_STALL_SECONDS
				local v11 = PROMPT_STALL_SECONDS2 - (os.clock() - v6)

				if v11 > 0 then
					scheduleStallCheck(v11)
					return
				end

				v8 = true

				local lifecycleParameters = getLifecycleParameters()
				local v12 = if v7 == nil then v5.FirstResponse else v5.MidTurn
				lifecycleParameters.stage = v12

				local v13 = v6
				lifecycleParameters.idleMs = tostring(v13 == nil and 0 or math.max(0, (math.round((os.clock() - v13) * 1000))))
				lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS2)

				sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
			end)
		end,
		markActivity = function(p2)
			if now == nil or v10 then
				return
			end

			v6 = os.clock()
			v9 = p2.isWaitingOnUser

			if p2.hasResponse and v7 == nil then
				local v11 = now
				local v12 = v11 == nil and 0 or math.max(0, (math.round((os.clock() - v11) * 1000)))

				v7 = v12

				reportPromptFirstResponseLatency(v12, v8)
			end

			if v9 then
				if thread ~= nil then
					task.cancel(thread)
					thread = nil
				end
			elseif thread == nil then
				local PROMPT_STALL_SECONDS = chatConstants.PROMPT_STALL_SECONDS
				thread = task.delay(PROMPT_STALL_SECONDS, function()
					thread = nil

					if v10 or v9 or v6 == nil then
						return
					end

					local PROMPT_STALL_SECONDS2 = chatConstants.PROMPT_STALL_SECONDS
					local v11 = PROMPT_STALL_SECONDS2 - (os.clock() - v6)

					if v11 > 0 then
						scheduleStallCheck(v11)
						return
					end

					v8 = true

					local lifecycleParameters = getLifecycleParameters()
					local v12 = if v7 == nil then v5.FirstResponse else v5.MidTurn
					lifecycleParameters.stage = v12

					local v13 = v6
					lifecycleParameters.idleMs = tostring(v13 == nil and 0 or math.max(0, (math.round((os.clock() - v13) * 1000))))
					lifecycleParameters.thresholdSeconds = tostring(PROMPT_STALL_SECONDS2)

					sendBuildExperienceEvent("SEND_PROMPT_STALLED", callback(), lifecycleParameters)
				end)
			end
		end,
		reportUserStop = function()
			if now == nil or v10 then
				return
			end

			sendBuildExperienceEvent("SEND_PROMPT_STOPPED", callback(), getLifecycleParameters())
			v10 = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end,
		finish = function()
			v10 = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end,
		getLifecycleParameters = getLifecycleParameters
	}
end

return createPromptLifecycleTelemetry
