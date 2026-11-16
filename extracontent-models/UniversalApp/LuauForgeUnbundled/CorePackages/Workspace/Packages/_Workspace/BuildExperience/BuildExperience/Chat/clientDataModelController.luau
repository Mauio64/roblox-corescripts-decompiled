local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local clientDataModelCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientDataModelCollector")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local studioClientDataModelTools = CreatorAgentChat.StudioClientDataModelTools
local Debug = CreatorAgentChat.debug

local function createClientDataModelController(p2, p3, p4)
	local v5 = p4 or function(): boolean
		return true
	end

	local v6 = {}

	local function clearPending(p5)
		v6[p5] = nil
		p3[p5] = nil
	end

	local function collectResult(p5)
		if p5.toolName == studioClientDataModelTools.SEARCH_TOOL_NAME then
			return clientDataModelCollector.searchClientDataModel(p5.rawInput)
		end

		return clientDataModelCollector.inspectClientInstance(p5.rawInput)
	end

	local function submitResult(data)
		if v5() then
			Debug.log("info", `{data.toolName} tool_result collecting`, {
				sessionId = data.sessionId,
				toolCallId = data.toolCallId,
				turnId = data.turnId,
				referenceId = data.referenceId
			})

			local lastTime = os.clock()
			local success, result = pcall(collectResult, data)

			local formatResultContent = studioClientDataModelTools.formatResultContent(not success and {
				status = "collection_failed",
				message = "The client DataModel could not be inspected."
			} or result)
			local v7 = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v5() then
				local submitActiveToolResult = p2.submitActiveToolResult(
					formatResultContent,
					false,
					data.turnId,
					data.referenceId
				)

				if submitActiveToolResult == nil then
					local toolCallId = data.toolCallId
					v6[toolCallId] = nil
					p3[toolCallId] = nil

					Debug.log("warn", `{data.toolName} tool_result submit aborted (no active session)`, {
						toolCallId = data.toolCallId,
						collectDurationMs = v7
					})

					return
				else
					local lastTime2 = os.clock()

					local v8 = toolControllerUtils.awaitRequestState(
						submitActiveToolResult.state,
						os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
					)
					local v9 = math.floor((os.clock() - lastTime2) * 1000 + 0.5)
					v6[data.toolCallId] = nil

					if v8.status == "succeeded" then
						Debug.log("info", `{data.toolName} tool_result submitted`, {
							sessionId = data.sessionId,
							toolCallId = data.toolCallId,
							turnId = data.turnId,
							referenceId = data.referenceId,
							collectDurationMs = v7,
							submitDurationMs = v9
						})

						return
					end

					if v8.status == "pending" then
						submitActiveToolResult.dispose()
					else
						p3[data.toolCallId] = nil
					end

					Debug.log("warn", `{data.toolName} tool_result submit failed`, {
						sessionId = data.sessionId,
						toolCallId = data.toolCallId,
						turnId = data.turnId,
						referenceId = data.referenceId,
						collectDurationMs = v7,
						submitDurationMs = v9,
						state = Debug.formatRequestState(v8)
					})

					return
				end
			end
		end

		local toolCallId = data.toolCallId
		v6[toolCallId] = nil
		p3[toolCallId] = nil
	end

	local function syncRequest(p5, p6, callback): boolean
		if not v5() then
			return false
		end

		local v7, v8, v9, v10 = callback(p5, p3)

		if v7 == nil then
			return false
		end

		p3[v7] = true
		v6[v7] = true
		local v11 = {
			sessionId = p5.sessionId,
			toolCallId = v7,
			toolName = p6,
			rawInput = v8,
			turnId = v9,
			referenceId = v10
		}

		local log = Debug.log
		local v14 = {
			sessionId = v11.sessionId,
			toolCallId = v11.toolCallId,
			toolName = v11.toolName,
			turnId = v11.turnId,
			referenceId = v11.referenceId,
			gameId = game.GameId,
			path = 0
		}
		local v15 = if typeof(v8) == "table" then v8.path else nil
		v14.path = v15
		log("info", "runtime client tool call accepted", v14)

		task.spawn(function()
			submitResult(v11)
		end)
		return true
	end

	return {
		revokePending = function()
			for k in v6 do
				v6[k] = nil
				p3[k] = nil
			end
		end,
		syncClientDataModelRequests = function(p5)
			local v7 = syncRequest(
				p5,
				studioClientDataModelTools.SEARCH_TOOL_NAME,
				studioClientDataModelTools.findSearchRequestInTurnState
			)

			local v8 = syncRequest(
				p5,
				studioClientDataModelTools.INSPECT_TOOL_NAME,
				studioClientDataModelTools.findInspectRequestInTurnState
			)

			return v7 or v8
		end
	}
end

return createClientDataModelController
