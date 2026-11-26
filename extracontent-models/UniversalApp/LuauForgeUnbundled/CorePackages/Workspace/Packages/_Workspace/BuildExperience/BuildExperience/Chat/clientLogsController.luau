local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local clientLogsCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientLogsCollector")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local studioClientLogsTool = CreatorAgentChat.StudioClientLogsTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState

local function getClientLogsReason(p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	if typeof(p2.reason) == "string" and p2.reason ~= "" then
		return p2.reason
	end

	return nil
end

local function fetchLatestSavedVersion(placeId)
	if placeId == nil then
		return nil
	end

	local v5, v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory").getPlaceVersionHistoryStore().fetchPageHistory(placeId):await()

	if not v5 or typeof(v6) ~= "table" or typeof(v6.placeVersions) ~= "table" then
		return nil
	end

	local placeVersion = v6.placeVersions[1]

	if typeof(placeVersion) == "table" then
		return (tonumber(placeVersion.version))
	end

	return nil
end

local function createClientLogsController(data, p2, callback)
	local function canHandleClientLogs()
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

		local v5 = fetchLatestSavedVersion(data.placeId)

		if callback ~= nil and not callback() then
			p2[data2.toolCallId] = nil
			return
		end

		local toolResultContent = clientLogsCollector.collectToolResultContent({
			universeId = data.universeId,
			placeId = data.placeId,
			minimumPlaceVersion = v5
		})

		local v6 = math.floor((os.clock() - lastTime) * 1000 + 0.5)

		local submitActiveToolResult = data.submitActiveToolResult(
			toolResultContent,
			false,
			data2.turnId,
			data2.referenceId
		)

		if submitActiveToolResult == nil then
			Debug.log("warn", "ask_for_logs tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId,
				collectDurationMs = v6
			})

			return
		end

		local lastTime2 = os.clock()
		local v7 = awaitRequestState(
			submitActiveToolResult.state,
			os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
		)
		local v8 = math.floor((os.clock() - lastTime2) * 1000 + 0.5)

		if v7.status == "succeeded" then
			Debug.log("info", "ask_for_logs tool_result submitted", {
				sessionId = data2.sessionId,
				toolCallId = data2.toolCallId,
				turnId = data2.turnId,
				referenceId = data2.referenceId,
				collectDurationMs = v6,
				submitDurationMs = v8
			})
		else
			Debug.log("warn", "ask_for_logs tool_result submit failed", {
				sessionId = data2.sessionId,
				toolCallId = data2.toolCallId,
				turnId = data2.turnId,
				referenceId = data2.referenceId,
				collectDurationMs = v6,
				submitDurationMs = v8,
				state = Debug.formatRequestState(v7)
			})
		end
	end

	return {
		syncClientLogsRequest = function(p3): boolean
			if callback ~= nil and not callback() then
				return false
			end

			local clientLogsRequestInTurnState, v5, v6, v7 = studioClientLogsTool.findClientLogsRequestInTurnState(
				p3,
				p2
			)

			if clientLogsRequestInTurnState == nil then
				return false
			end

			p2[clientLogsRequestInTurnState] = true
			local v8 = {
				sessionId = p3.sessionId,
				toolCallId = clientLogsRequestInTurnState,
				turnId = v6,
				referenceId = v7,
				reason = 0
			}
			local v9 = if typeof(v5) == "table" and typeof(v5.reason) == "string" and v5.reason ~= "" then v5.reason else nil

			v8.reason = v9

			task.spawn(function()
				submitClientLogsResult(v8)
			end)
			return true
		end
	}
end

return createClientLogsController
