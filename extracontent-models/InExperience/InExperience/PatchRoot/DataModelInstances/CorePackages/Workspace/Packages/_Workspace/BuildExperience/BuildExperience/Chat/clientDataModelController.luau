local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local chatConstants = require(script.Parent.chatConstants)
local clientDataModelCollector = require(script.Parent.clientDataModelCollector)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local StudioClientDataModelTools = CreatorAgentChat.StudioClientDataModelTools
local Debug = CreatorAgentChat.debug

local function createClientDataModelController(p, p2, callback)
	local v = callback or function(): boolean
		return true
	end

	local v2 = {}

	local function clearPending(p3: string) -- 3 equivalent calls inferred from this helper
		v2[p3] = nil
		p2[p3] = nil
	end

	local function collectResult(p3)
		if p3.toolName == StudioClientDataModelTools.SEARCH_TOOL_NAME then
			return clientDataModelCollector.searchClientDataModel(p3.rawInput)
		end

		return clientDataModelCollector.inspectClientInstance(p3.rawInput)
	end

	local function submitResult(data)
		if v() then
			Debug.log("info", `{data.toolName} tool_result collecting`, {
				sessionId = data.sessionId,
				toolCallId = data.toolCallId,
				turnId = data.turnId,
				referenceId = data.referenceId
			})

			local lastTime = os.clock()
			local success, result = pcall(collectResult, data)

			local formatResultContent = StudioClientDataModelTools.formatResultContent(not success and {
				status = "collection_failed",
				message = "The client DataModel could not be inspected."
			} or result)
			local collectDurationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v() then
				local submitActiveToolResult = p.submitActiveToolResult(
					formatResultContent,
					false,
					data.turnId,
					data.referenceId
				)

				if submitActiveToolResult == nil then
					clearPending(data.toolCallId) -- inferred equivalent call
					Debug.log("warn", `{data.toolName} tool_result submit aborted (no active session)`, {
						toolCallId = data.toolCallId,
						collectDurationMs = collectDurationMs
					})

					return
				else
					local lastTime2 = os.clock()

					local v3 = toolControllerUtils.awaitRequestState(
						submitActiveToolResult.state,
						os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
					)
					local submitDurationMs = math.floor((os.clock() - lastTime2) * 1000 + 0.5)
					v2[data.toolCallId] = nil

					if v3.status == "succeeded" then
						Debug.log("info", `{data.toolName} tool_result submitted`, {
							sessionId = data.sessionId,
							toolCallId = data.toolCallId,
							turnId = data.turnId,
							referenceId = data.referenceId,
							collectDurationMs = collectDurationMs,
							submitDurationMs = submitDurationMs
						})

						return
					end

					if v3.status == "pending" then
						submitActiveToolResult.dispose()
					else
						p2[data.toolCallId] = nil
					end

					Debug.log("warn", `{data.toolName} tool_result submit failed`, {
						sessionId = data.sessionId,
						toolCallId = data.toolCallId,
						turnId = data.turnId,
						referenceId = data.referenceId,
						collectDurationMs = collectDurationMs,
						submitDurationMs = submitDurationMs,
						state = Debug.formatRequestState(v3)
					})

					return
				end
			end
		end

		clearPending(data.toolCallId) -- inferred equivalent call
	end

	local function syncRequest(p3, toolName: string, callback2): boolean
		if not v() then
			return false
		end

		local toolCallId, rawInput, turnId, referenceId = callback2(p3, p2)

		if toolCallId == nil then
			return false
		end

		p2[toolCallId] = true
		v2[toolCallId] = true
		local v3 = {
			sessionId = p3.sessionId,
			toolCallId = toolCallId,
			toolName = toolName,
			rawInput = rawInput,
			turnId = turnId,
			referenceId = referenceId
		}

		local log = Debug.log
		local v4 = {
			sessionId = v3.sessionId,
			toolCallId = v3.toolCallId,
			toolName = v3.toolName,
			turnId = v3.turnId,
			referenceId = v3.referenceId,
			gameId = game.GameId,
			path = 0
		}
		local path

		if typeof(rawInput) == "table" then
			path = rawInput.path
		end

		v4.path = path
		log("info", "runtime client tool call accepted", v4)

		task.spawn(function()
			submitResult(v3)
		end)
		return true
	end

	return {
		revokePending = function()
			for k in v2 do
				clearPending(k) -- inferred equivalent call
			end
		end,
		syncClientDataModelRequests = function(p3)
			local v3 = syncRequest(
				p3,
				StudioClientDataModelTools.SEARCH_TOOL_NAME,
				StudioClientDataModelTools.findSearchRequestInTurnState
			)

			local v4 = syncRequest(
				p3,
				StudioClientDataModelTools.INSPECT_TOOL_NAME,
				StudioClientDataModelTools.findInspectRequestInTurnState
			)

			return v3 or v4
		end
	}
end

return createClientDataModelController
