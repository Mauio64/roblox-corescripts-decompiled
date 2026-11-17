local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local FFlagBuildExperienceDevProductRecovery = require(BuildExperience.Flags.FFlagBuildExperienceDevProductRecovery)

local FFlagBuildExperienceMonetizationFailureCauses = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationFailureCauses)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

require(script.Parent.chatTypes)
local chatConstants = require(script.Parent.chatConstants)
require(script.Parent.localToolOverlay)
local toolControllerUtils = require(script.Parent.toolControllerUtils)
local monetizationFailureCauses = require(BuildExperience.utils.monetizationFailureCauses)

local Debug = CreatorAgentChat.debug

local v = {
	outcome = "unverified",
	errorMessage = "The request timed out and its outcome is unknown. List again before retrying."
}

local function describeRejection(p) -- 5 equivalent calls inferred from this helper
	if typeof(p) == "table" and typeof(p.errorMessage) == "string" then
		return p.errorMessage
	end

	return (tostring(p))
end

local function awaitPromise(object, p: number?)
	local v2, v3 = object:timeout(p or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v):await()

	if v2 then
		if v3 == nil then
			return nil, "The request returned no result.", nil
		end

		return v3, nil, nil
	end

	if v3 == nil then
		return nil, "The request returned no result.", nil
	end

	return nil, describeRejection(v3), v3 -- inferred equivalent call
end

local function detailCodeForFailure(action: string, p) -- 1 equivalent call inferred from this helper
	if typeof(p) == "table" and p.outcome == "unverified" then
		return "outcome_unknown"
	end

	return action .. "_failed"
end

local function isRetryableFailure(action: string, p, data): boolean -- 1 equivalent call inferred from this helper
	if p ~= nil or typeof(data) ~= "table" then
		return false
	end

	if data.retryable == true then
		return true
	end

	local cause = data.cause
	return action == "create" and data.outcome == "failed" and typeof(cause) == "table" and cause.responseCode == 429
end

local function createMonetizationToolController(data, p, p2, data2, callback)
	local tool = data.tool
	local TOOL_NAME = tool.TOOL_NAME
	local v2 = nil
	local v3 = {}
	local count = 0
	local v4 = {}
	local count2 = 0

	local function isGenerationCurrent(generation: number): boolean -- 3 equivalent calls inferred from this helper
		return count == generation
	end

	local function isFlowCurrent(p3) -- 7 equivalent calls inferred from this helper
		return v2 == p3 and isGenerationCurrent(p3.generation) -- inferred equivalent call
	end

	local function isAutomaticWorkCurrent(p3: number, p4: number) -- 4 equivalent calls inferred from this helper
		return isGenerationCurrent(p3) and count2 == p4 -- inferred equivalent call
	end

	local function awaitReply(submitActiveToolResult, p3: string) -- 1 equivalent call inferred from this helper
		local timeout = HttpClient.asPromise(submitActiveToolResult):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		v4[timeout] = p3
		local v5, v6 = timeout:awaitStatus()
		v4[timeout] = nil
		return v5, v6
	end

	local function cancelReplies(p3: string?)
		for k, v5 in table.clone(v4) do
			if not (p3 == nil or v5 == p3) then
				continue
			end

			v4[k] = nil
			k:cancel()
		end
	end

	local function invalidateAutomaticWork() -- 3 equivalent calls inferred from this helper
		count2 += 1

		for k in v3 do
			p2[k] = nil
		end

		table.clear(v3)
		cancelReplies("automatic")
	end

	local function invalidateAsyncWork() -- 3 equivalent calls inferred from this helper
		count += 1
		invalidateAutomaticWork() -- inferred equivalent call
		cancelReplies("afterDecision")
	end

	local function proposalFromFlow(data3, isApproved: boolean, isRejected: boolean)
		local input = data3.input
		local result = {
			toolCallId = data3.toolCallId,
			callOrder = data3.callOrder,
			action = input.action,
			name = input.name,
			description = input.description,
			priceInRobux = input.priceInRobux,
			itemKind = data.itemKind,
			itemId = data.itemIdOf(input),
			isApproved = isApproved,
			isRejected = isRejected,
			isPending = 0,
			hasError = 0,
			errorCause = 0,
			canRetry = 0
		}
		local isPending

		if FFlagBuildExperienceDevProductRecovery then
			isPending = data3.isPending
		end

		result.isPending = isPending
		local hasError

		if FFlagBuildExperienceDevProductRecovery then
			if data3.resultError == nil then
				hasError = false
			else
				hasError = not isRejected
			end
		end

		result.hasError = hasError
		local errorCause

		if
			FFlagBuildExperienceDevProductRecovery
			and FFlagBuildExperienceMonetizationFailureCauses
			and data3.resultError ~= nil
			and not isRejected
		then
			errorCause = monetizationFailureCauses.classify(data3.resultError)
				or data3.canRetry == true and "rateLimited"
				or nil
		end

		result.errorCause = errorCause
		local canRetry

		if FFlagBuildExperienceDevProductRecovery then
			if data3.canRetry == true then
				canRetry = not isRejected
			else
				canRetry = false
			end
		end

		result.canRetry = canRetry

		if data.cardFields ~= nil then
			for k, v5 in data.cardFields(input) do
				result[k] = v5
			end
		end

		return result
	end

	local function submitAutomaticResult(toolCallId: string, p3, formatResultContent, flag: boolean, p4: number, p5: number)
		if not isAutomaticWorkCurrent(p4, p5) then -- inferred equivalent call
			return
		end

		local submitActiveToolResult = p.submitActiveToolResult(formatResultContent, flag, p3.turnId, p3.referenceId)

		if submitActiveToolResult == nil then
			v3[toolCallId] = nil

			if isGenerationCurrent(p4) then -- inferred equivalent call
				p2[toolCallId] = nil
			end
		else
			local status, v5 = awaitReply(submitActiveToolResult, "automatic") -- inferred equivalent call

			if not isAutomaticWorkCurrent(p4, p5) then -- inferred equivalent call
				return
			end

			v3[toolCallId] = nil

			if status == Promise.Status.Resolved then
				p2[toolCallId] = true
				return
			end

			p2[toolCallId] = nil
			Debug.log("warn", TOOL_NAME .. " automatic submit failed", {
				toolCallId = toolCallId,
				status = status,
				reason = describeRejection(v5) -- inferred equivalent call
			})
		end
	end

	local function runList(toolCallId: string, p3, p4: number, p5: number)
		if not isAutomaticWorkCurrent(p4, p5) then -- inferred equivalent call
			return
		end

		local v5 = nil
		local v6

		if p.universeId == nil then
			v6 = monetizationFailureCauses.MESSAGES.noUniverse
		else
			local list, v7 = data.list(p.universeId)
			local v8, v9 = list:timeout(v7 or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v):await()

			if v8 then
				if v9 == nil then
					v6 = "The request returned no result."
				else
					v5 = v9
				end
			elseif v9 == nil then
				v6 = "The request returned no result."
			else
				v6 = describeRejection(v9) -- inferred equivalent call
			end
		end

		if not isAutomaticWorkCurrent(p4, p5) then -- inferred equivalent call
			return
		end

		local v7 = { status = "ok", action = "list" }

		if v5 == nil then
			v7 = {
				status = "error",
				action = "list",
				detailCode = "list_failed",
				message = v6 or "The list request failed."
			}
		else
			for k, v8 in v5 do
				v7[k] = v8
			end
		end

		local formatResultContent, v8 = tool.formatResultContent(v7)
		submitAutomaticResult(toolCallId, p3, formatResultContent, v8 or v5 == nil, p4, p5)
	end

	local function recoverFailedSubmission(state, p3: string?, p4: number?)
		if not isFlowCurrent(state) then -- inferred equivalent call
			data2.removeDevProductAction(state.toolCallId)
		elseif state.toolCallPresent then
			if
				FFlagBuildExperienceDevProductRecovery
				and FFlagBuildExperienceMonetizationFailureCauses
				and state.attempted
				and toolControllerUtils.isConversationGone(p4)
			then
				state.isPending = false
				state.canRetry = false
				p2[state.toolCallId] = true
				data2.markSubmitted(state.toolCallId)
				data2.setDevProductTool(proposalFromFlow(state, true, false))
				data2.removeDevProductAction(state.toolCallId)
				v2 = nil

				if callback ~= nil then
					callback(p3, p4)
				end
			else
				state.submitted = false

				if callback == nil then
					return
				end

				data2.setDevProductTool(proposalFromFlow(state, false, false))
				callback(p3, p4)
			end
		else
			data2.removeDevProductTool(state.toolCallId)
			data2.removeDevProductAction(state.toolCallId)
			v2 = nil
		end
	end

	local function submitResult(data3, p3, flag: boolean, p4: string?)
		if not isFlowCurrent(data3) then -- inferred equivalent call
			return
		end

		local submitActiveToolResult = p.submitActiveToolResult(p3, flag, data3.turnId, data3.referenceId)
		local status, v5

		if submitActiveToolResult == nil then
			status = "no session"
		else
			local timeout = HttpClient.asPromise(submitActiveToolResult):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS)
			v4[timeout] = "afterDecision"
			status, v5 = timeout:awaitStatus()
			v4[timeout] = nil
		end

		if not isFlowCurrent(data3) then -- inferred equivalent call
			return
		end

		if status == Promise.Status.Resolved then
			p2[data3.toolCallId] = true
			data2.markSubmitted(data3.toolCallId)
			data2.removeDevProductAction(data3.toolCallId)

			if v2 == data3 then
				v2 = nil
			end
		else
			local v6

			if typeof(v5) == "table" then
				v6 = v5.responseCode
			end

			recoverFailedSubmission(data3, p4, v6)

			Debug.log("warn", TOOL_NAME .. " tool_result submit failed", {
				sessionId = data3.sessionId,
				toolCallId = data3.toolCallId,
				action = data3.input.action,
				status = status,
				reason = describeRejection(v5) -- inferred equivalent call
			})
		end
	end

	local function submitApproval(state)
		if not isFlowCurrent(state) then -- inferred equivalent call
			return
		end

		if not state.attempted then
			state.attempted = true
			local v5 = nil
			local v6 = nil
			local resultDetailCode = nil
			local resultError

			if state.universeId == nil then
				resultError = monetizationFailureCauses.MESSAGES.noUniverse
			else
				local v7 = data.mutate(state.universeId, state.input)

				if v7 == nil then
					resultError = "The write was not sent."
				else
					local v8

					if state.input.imageAssetId ~= nil then
						v8 = chatConstants.CAS_RPC_TIMEOUT_SECONDS * 2
					end

					local v9
					v9, v6 = v7:timeout(v8 or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v):await()

					if v9 then
						if v6 == nil then
							resultError = "The request returned no result."
						else
							v5 = v6
						end

						v6 = nil
					elseif v6 == nil then
						resultError = "The request returned no result."
						v6 = nil
					else
						resultError = describeRejection(v6) -- inferred equivalent call
					end
				end
			end

			if not isFlowCurrent(state) then -- inferred equivalent call
				return
			end

			if v5 == nil and typeof(v6) == "table" then
				v5 = v6[data.resultKey]
			end

			if resultError ~= nil then
				resultDetailCode = detailCodeForFailure(state.input.action, v6) -- inferred equivalent call
			end

			state.result = v5
			state.resultError = resultError
			state.resultDetailCode = resultDetailCode

			if
				FFlagBuildExperienceDevProductRecovery
				and FFlagBuildExperienceMonetizationFailureCauses
				and resultError ~= nil
				and isRetryableFailure(state.input.action, v5, v6) -- inferred equivalent call
			then
				state.attempted = false
				state.submitted = false
				state.isPending = false
				state.canRetry = true
				data2.setDevProductTool(proposalFromFlow(state, false, false))
				return
			end
		end

		if FFlagBuildExperienceDevProductRecovery then
			state.isPending = false

			if data2.getOptimisticLocalTools(false).devProductByToolCallId[state.toolCallId] ~= nil then
				data2.setDevProductTool(proposalFromFlow(state, true, false))
			end
		end

		local v5 = { action = state.input.action }
		v5[data.resultKey] = state.result

		if state.resultError == nil then
			v5.status = "ok"
		else
			v5.status = "error"
			v5.detailCode = state.resultDetailCode
			v5.message = state.resultError
		end

		local formatResultContent, v6 = tool.formatResultContent(v5)
		submitResult(state, formatResultContent, v6 or state.resultError ~= nil, nil)
	end

	local function submitRejection(p3, p4: string?)
		if not isFlowCurrent(p3) then -- inferred equivalent call
			return
		end

		if not p3.attempted then
			submitResult(p3, tool.formatRejectionContent(p3.input.action, p4), false, p4)
			return
		end

		data2.setDevProductTool(proposalFromFlow(p3, true, false))
		submitApproval(p3)
	end

	local function settle(p3, isPending: boolean, p4: string?): boolean
		if not isFlowCurrent(p3) or p3.submitted then -- inferred equivalent call
			return false
		end

		p3.submitted = true

		if FFlagBuildExperienceDevProductRecovery then
			p3.isPending = isPending
			p3.canRetry = false
		end

		data2.setDevProductTool(proposalFromFlow(p3, isPending, not isPending))
		task.spawn(function()
			if isPending then
				submitApproval(p3)
			else
				submitRejection(p3, p4)
			end
		end)
		return true
	end

	local function clearMutationFlow() -- 3 equivalent calls inferred from this helper
		local v5 = v2

		if v5 ~= nil then
			data2.removeDevProductTool(v5.toolCallId)
			data2.removeDevProductAction(v5.toolCallId)
		end

		v2 = nil
	end

	return {
		syncRequests = function(p3): boolean
			if v2 ~= nil then
				v2.toolCallPresent = p3.toolCalls[v2.toolCallId] ~= nil
			end

			for k in v3 do
				if p3.toolCalls[k] == nil then
					invalidateAutomaticWork() -- inferred equivalent call
					break
				end
			end

			local requestInTurnState, v5, turnId, referenceId = tool.findRequestInTurnState(p3, p2)

			if requestInTurnState == nil then
				if v2 ~= nil and not (v2.submitted or v2.attempted) then
					invalidateAsyncWork() -- inferred equivalent call
					clearMutationFlow() -- inferred equivalent call
				end

				return false
			else
				if v3[requestInTurnState] then
					return true
				end

				local v6 = { turnId = turnId, referenceId = referenceId }

				local input, message = tool.parseInput(v5)

				if input ~= nil and input.createAndGoLive == true then
					input = nil
					message = "createAndGoLive is not supported yet. Create without it and ask the creator to activate the product separately."
				end

				if input == nil then
					v3[requestInTurnState] = true
					local v7 = count
					local v8 = count2
					task.spawn(function()
						submitAutomaticResult(
							requestInTurnState,
							v6,
							tool.formatResultContent({
								status = "error",
								action = "unknown",
								detailCode = "invalid_arguments",
								message = message
							}),
							true,
							v7,
							v8
						)
					end)
					return true
				elseif tool.getActionKind(input.action) == "read" then
					p2[requestInTurnState] = true
					v3[requestInTurnState] = true
					local v7 = count
					local v8 = count2
					task.spawn(runList, requestInTurnState, v6, v7, v8)
					return true
				else
					if
						v2 ~= nil and (v2.submitted or v2.attempted)
						or v2 ~= nil and requestInTurnState == v2.toolCallId
					then
						return true
					end

					if v2 ~= nil then
						invalidateAsyncWork() -- inferred equivalent call
						clearMutationFlow() -- inferred equivalent call
					end

					local v7 = {
						sessionId = p3.sessionId,
						toolCallId = requestInTurnState,
						callOrder = toolControllerUtils.getToolCallOrder(p3, requestInTurnState),
						turnId = turnId,
						referenceId = referenceId,
						universeId = p.universeId,
						input = input,
						submitted = false,
						attempted = false,
						toolCallPresent = true,
						isPending = false,
						generation = count
					}

					v2 = v7
					data2.setDevProductTool(proposalFromFlow(v7, false, false))
					data2.setDevProductAction(requestInTurnState, function()
						settle(v7, true, nil)
					end, function()
						settle(v7, false, nil)
					end)
					Debug.log("info", TOOL_NAME .. " proposal displayed", {
						toolCallId = requestInTurnState,
						turnId = turnId,
						action = input.action
					})

					return true
				end
			end
		end,
		stopPending = function()
			local v5 = v2

			if v5 == nil or not (v5.submitted or v5.attempted) then
				local v6 = v2 ~= nil or next(v3) ~= nil or next(v4) ~= nil

				if v6 then
					invalidateAsyncWork() -- inferred equivalent call
				end

				if v5 ~= nil then
					v5.submitted = true
					p2[v5.toolCallId] = nil
					clearMutationFlow() -- inferred equivalent call
				end

				return v6
			else
				local v6 = next(v3) ~= nil

				if v6 then
					invalidateAutomaticWork() -- inferred equivalent call
				end

				return v6
			end
		end,
		trySubmitComposerText = function(p3: string)
			return v2 ~= nil and settle(v2, false, p3)
		end
	}
end

return createMonetizationToolController
