local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gRk")
local sendAXCounterV2 = module2.sendAXCounterV2
local sendAXStat = module2.sendAXStat
local module3 = require("@luauforge/deferred/gQK")

local module4 = require("@luauforge/deferred/gRl")
local module5 = require("@luauforge/deferred/gRr")
local module6 = require("@luauforge/deferred/gRs")
local module7 = require("@luauforge/deferred/gRv")
local module8 = require("@luauforge/deferred/gRx")

local function isTerminalStatus(p2): boolean
	return p2 == nil or p2.status ~= "Generating"
end

local function terminalFailureOutcome(p2): (string, string)
	if p2 == "FailedModeration" then
		return "moderation", "moderation"
	elseif p2 == "TimedOut" then
		return "timeout", "server_timeout"
	end

	return "infra", "failed_infra"
end

local function pollConfig()
	return {
		intervalSeconds = module3.FIntAXBackgroundGenerationPollIntervalSeconds,
		timeoutSeconds = module3.FIntAXBackgroundGenerationPollTimeoutSeconds,
		maxConsecutiveFailures = module3.FIntAXBackgroundGenerationMaxConsecutivePollFailures
	}
end

local function useBackgroundGenerationController(p2)
	local state, setState = module.useState("idle")
	local state2, setState2 = module.useState(nil)
	local state3, setState3 = module.useState(nil)
	local state4, setState4 = module.useState(nil)
	local state5, setState5 = module.useState(nil)
	local ref = module.useRef(false)
	module.useEffect(function()
		return function()
			ref.current = true
		end
	end, {})

	local v5 = module7()

	local ref2 = module.useRef(0)

	local function emitDuration(p3)
		sendAXStat({
			statName = module8.GENERATION_DURATION_STAT_NAME,
			deltaMs = (os.clock() - ref2.current) * 1000,
			metaData = { status = p3 }
		})
	end

	local function fail(p3, p4, limitPeriod)
		local v6 = { status = "error", errorType = p3, reason = p4 }

		if limitPeriod then
			v6.limitPeriod = limitPeriod
		end

		sendAXCounterV2(module8.GENERATION_OUTCOME_COUNTER_NAME, v6)
		emitDuration("error")
		setState("error")
		setState4(p3)
		setState5(limitPeriod)
	end

	local function succeed(presignedUrl)
		sendAXCounterV2(module8.GENERATION_OUTCOME_COUNTER_NAME, { status = "success" })
		emitDuration("success")
		setState("completed")
		setState4(nil)
		setState5(nil)
		setState2(presignedUrl)
	end

	local function pollGenerationStatus(generationId)
		local function fetchStatus()
			return module6(p2, generationId)
		end

		local function onResult(data)
			if data then
				if data.status == "Completed" then
					if not data.presignedUrl then
						fail("infra", "missing_presigned_url")
						return
					end

					setState3(generationId)
					succeed(data.presignedUrl)
				else
					local status = data.status
					local v6, v7

					if status == "FailedModeration" then
						v6 = "moderation"
						v7 = "moderation"
					elseif status == "TimedOut" then
						v6 = "timeout"
						v7 = "server_timeout"
					else
						v6 = "infra"
						v7 = "failed_infra"
					end

					if data.status == "TimedOut" then
						warn(`[BackgroundGeneration] Server-reported timeout for generationId={generationId}, ` .. `failureReason={data.failureReason or "nil"}`)
					end

					fail(v6, v7)
				end
			else
				warn(`[BackgroundGeneration] Malformed status response for generationId={generationId}`)
				fail("infra", "malformed_status")
			end
		end

		local function onFailure(p3)
			if p3.kind == "timeout" then
				warn(`[BackgroundGeneration] Client poll timeout for generationId={generationId}`)
				fail("timeout", "client_poll_timeout")
			elseif p3.kind == "internal" then
				warn(`[BackgroundGeneration] Internal poll failure for generationId={generationId}: {tostring(p3.error)}`)

				fail("infra", "poll_internal_error")
			else
				warn(`[BackgroundGeneration] Poll failed for generationId={generationId}: {tostring(p3.error)}`)
				fail("infra", "poll_failed")
			end
		end

		return v5(fetchStatus, isTerminalStatus, {
			intervalSeconds = module3.FIntAXBackgroundGenerationPollIntervalSeconds,
			timeoutSeconds = module3.FIntAXBackgroundGenerationPollTimeoutSeconds,
			maxConsecutiveFailures = module3.FIntAXBackgroundGenerationMaxConsecutivePollFailures
		}):andThen(onResult):catch(onFailure)
	end

	local function onGenerated(p3)
		local generationId = p3 and p3.generationId

		if generationId then
			return pollGenerationStatus(generationId)
		end

		warn("[BackgroundGeneration] Generation response missing generationId")
		fail("infra", "missing_generation_id")
	end

	local function onGenerateError(p3)
		if ref.current then
			return
		end

		local v6, v7 = module5(p3)

		if v6 then
			fail("rateLimited", "rate_limited", v7)
			return
		end

		warn(`[BackgroundGeneration] Generation request failed: {tostring(p3)}`)
		fail("infra", "generate_failed")
	end

	return {
		state = state,
		presignedUrl = state2,
		generationId = state3,
		errorType = state4,
		limitPeriod = state5,
		submit = module.useCallback(function(p3)
			ref2.current = os.clock()
			sendAXCounterV2(module8.GENERATION_OUTCOME_COUNTER_NAME, {
				status = "attempt"
			})
			setState("generating")
			setState2(nil)
			setState3(nil)
			setState4(nil)
			setState5(nil)

			module4(p2, { prompt = p3 }):andThen(onGenerated):catch(onGenerateError)
		end, { p2, v5 }),
		reset = module.useCallback(function()
			setState("idle")
			setState2(nil)
			setState3(nil)
			setState4(nil)
			setState5(nil)
		end, {})
	}
end

return useBackgroundGenerationController
