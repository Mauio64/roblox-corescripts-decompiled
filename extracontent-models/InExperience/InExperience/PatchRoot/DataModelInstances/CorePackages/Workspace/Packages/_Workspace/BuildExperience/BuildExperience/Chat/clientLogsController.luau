local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local chatConstants = require(script.Parent.chatConstants)
local clientLogsCollector = require(script.Parent.clientLogsCollector)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local StudioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState

local function getClientLogsReason(p)
	if typeof(p) ~= "table" then
		return nil
	end

	if typeof(p.reason) == "string" and p.reason ~= "" then
		return p.reason
	end

	return nil
end

local function fetchLatestSavedVersion(placeId: number?)
	if placeId == nil then
		return nil
	end

	local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
	local v, v2 = PlaceVersionHistory.getPlaceVersionHistoryStore().fetchPageHistory(placeId):await()

	if not v or typeof(v2) ~= "table" or typeof(v2.placeVersions) ~= "table" then
		return nil
	end

	local placeVersion = v2.placeVersions[1]

	if typeof(placeVersion) == "table" then
		return (tonumber(placeVersion.version))
	end

	return nil
end

local function createClientLogsController(data, p, callback)
	local function canHandleClientLogs() -- 2 equivalent calls inferred from this helper
		return callback == nil or callback()
	end

	local function submitClientLogsResult(data2)
		Debug.log("info", "ask_for_logs tool_result collecting", {
			sessionId = data2.sessionId,
			toolCallId = data2.toolCallId,
			turnId = data2.turnId,
			referenceId = data2.referenceId,
			reason = data2.reason
		})

		local lastTime = os.clock()

		local minimumPlaceVersion = fetchLatestSavedVersion(data.placeId)

		if not canHandleClientLogs() then -- inferred equivalent call
			p[data2.toolCallId] = nil
			return
		end

		local toolResultContent = clientLogsCollector.collectToolResultContent({
			universeId = data.universeId,
			placeId = data.placeId,
			minimumPlaceVersion = minimumPlaceVersion
		})

		local collectDurationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5)

		local submitActiveToolResult = data.submitActiveToolResult(
			toolResultContent,
			false,
			data2.turnId,
			data2.referenceId
		)

		if submitActiveToolResult == nil then
			Debug.log("warn", "ask_for_logs tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId,
				collectDurationMs = collectDurationMs
			})

			return
		end

		local lastTime2 = os.clock()
		local v = awaitRequestState(submitActiveToolResult.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local submitDurationMs = math.floor((os.clock() - lastTime2) * 1000 + 0.5)

		if v.status == "succeeded" then
			Debug.log("info", "ask_for_logs tool_result submitted", {
				sessionId = data2.sessionId,
				toolCallId = data2.toolCallId,
				turnId = data2.turnId,
				referenceId = data2.referenceId,
				collectDurationMs = collectDurationMs,
				submitDurationMs = submitDurationMs
			})
		else
			Debug.log("warn", "ask_for_logs tool_result submit failed", {
				sessionId = data2.sessionId,
				toolCallId = data2.toolCallId,
				turnId = data2.turnId,
				referenceId = data2.referenceId,
				collectDurationMs = collectDurationMs,
				submitDurationMs = submitDurationMs,
				state = Debug.formatRequestState(v)
			})
		end
	end

	return {
		syncClientLogsRequest = function(p2): boolean
			if not canHandleClientLogs() then -- inferred equivalent call
				return false
			end

			local clientLogsRequestInTurnState, v, turnId, referenceId = StudioClientLogsTool.findClientLogsRequestInTurnState(p2, p)

			if clientLogsRequestInTurnState == nil then
				return false
			end

			p[clientLogsRequestInTurnState] = true
			local v2 = {
				sessionId = p2.sessionId,
				toolCallId = clientLogsRequestInTurnState,
				turnId = turnId,
				referenceId = referenceId,
				reason = 0
			}
			local reason

			if typeof(v) == "table" and typeof(v.reason) == "string" and v.reason ~= "" then
				reason = v.reason
			end

			v2.reason = reason

			task.spawn(function()
				submitClientLogsResult(v2)
			end)
			return true
		end
	}
end

return createClientLogsController
