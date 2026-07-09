local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local chatConstants = require(script.Parent.chatConstants)
local clientLogsCollector = require(script.Parent.clientLogsCollector)
local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState

local function getClientLogsReason(p1) -- line: 34
	if typeof(p1) ~= "table" then
		return nil
	end

	if typeof(p1.reason) == "string" and p1.reason ~= "" then
		return p1.reason
	end

	return nil
end
local function createClientLogsController(p2, t1: {[any]: any}) -- line: 41
	-- upvalues: debug (copy), clientLogsCollector (copy), awaitRequestState (copy), chatConstants (copy), StudioClientLogsTool (copy)
	local function submitClientLogsResult(t2: {[any]: any}) -- line: 45
		-- upvalues: debug (copy), clientLogsCollector (copy), p2 (copy), awaitRequestState (copy), chatConstants (copy)
		debug.log("info", "ask_for_logs tool_result collecting", {
			sessionId = t2.sessionId,
			toolCallId = t2.toolCallId,
			turnId = t2.turnId,
			referenceId = t2.referenceId,
			reason = t2.reason
		})

		local elapsed = os.clock()
		local v17 = clientLogsCollector.collectToolResultContent()
		local v18 = math.floor((os.clock() - elapsed) * 1000 + 0.5)
		local v19 = p2.submitActiveToolResult(v17, false, t2.turnId, t2.referenceId)

		if v19 == nil then
			debug.log("warn", "ask_for_logs tool_result submit aborted (no active session)", {
				toolCallId = t2.toolCallId,
				collectDurationMs = v18
			})

			return
		end

		local elapsed2 = os.clock()
		local v21 = awaitRequestState(v19.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v22 = math.floor((os.clock() - elapsed2) * 1000 + 0.5)

		if v21.status ~= "succeeded" then
			debug.log("warn", "ask_for_logs tool_result submit failed", {
				sessionId = t2.sessionId,
				toolCallId = t2.toolCallId,
				turnId = t2.turnId,
				referenceId = t2.referenceId,
				collectDurationMs = v18,
				submitDurationMs = v22,
				state = debug.formatRequestState(v21)
			})

			return
		end

		debug.log("info", "ask_for_logs tool_result submitted", {
			sessionId = t2.sessionId,
			toolCallId = t2.toolCallId,
			turnId = t2.turnId,
			referenceId = t2.referenceId,
			collectDurationMs = v18,
			submitDurationMs = v22
		})
	end

	return {
		syncClientLogsRequest = function(p3) -- line: 93
			-- upvalues: StudioClientLogsTool (copy), t1 (copy), submitClientLogsResult (copy)
			local v24, v25, v26, v27 = StudioClientLogsTool.findClientLogsRequestInTurnState(p3, t1)

			if v24 == nil then
				return false
			end

			t1[v24] = true

			local t3 = {
				sessionId = p3.sessionId,
				toolCallId = v24,
				turnId = v26,
				referenceId = v27,
				reason = if typeof(v25) == "table" then if typeof(v25.reason) ~= "string" or v25.reason == "" then nil else v25.reason else nil
			}

			task.spawn(function() -- line: 108
				-- upvalues: submitClientLogsResult (copy), t3 (copy)
				submitClientLogsResult(t3)
			end)

			return true
		end
	}
end

return createClientLogsController
