local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local FFlagBuildExperienceDevProductRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductRecovery")

local FFlagBuildExperienceMonetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationFailureCauses")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")
local monetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/monetizationFailureCauses")

local Debug = CreatorAgentChat.debug

local v5 = {
	outcome = "unverified",
	errorMessage = "The request timed out and its outcome is unknown. List again before retrying."
}

local function describeRejection(p2)
	if typeof(p2) == "table" and typeof(p2.errorMessage) == "string" then
		return p2.errorMessage
	end

	return (tostring(p2))
end

local function awaitPromise(object, p2)
	local v6, v7 = object:timeout(p2 or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v5):await()

	if v6 then
		if v7 == nil then
			return nil, "The request returned no result.", nil
		end

		return v7, nil, nil
	end

	if v7 == nil then
		return nil, "The request returned no result.", nil
	end

	return
		nil,
		if typeof(v7) == "table" and typeof(v7.errorMessage) == "string" then v7.errorMessage else tostring(v7),
		v7
end

local function detailCodeForFailure(p2, p3)
	if typeof(p3) == "table" and p3.outcome == "unverified" then
		return "outcome_unknown"
	end

	return p2 .. "_failed"
end

local function isRetryableFailure(p2, p3, data): boolean
	if p3 ~= nil or typeof(data) ~= "table" then
		return false
	end

	if data.retryable == true then
		return true
	end

	local cause = data.cause
	return p2 == "create"
		and data.outcome == "failed"
		and typeof(cause) == "table"
		and cause.responseCode == 429
end

local function createMonetizationToolController(data, p2, p3, data2, callback)
	local tool = data.tool
	local TOOL_NAME = tool.TOOL_NAME
	local v6 = nil
	local v7 = {}
	local count = 0
	local v8 = {}
	local count2 = 0

	local function isGenerationCurrent(p4): boolean
		return count == p4
	end

	local function isFlowCurrent(p4)
		local v9

		if v6 == p4 then
			local generation = p4.generation
			v9 = count == generation
		else
			v9 = false
		end

		return v9
	end

	local function isAutomaticWorkCurrent(p4, p5): boolean
		return count == p4 and count2 == p5
	end

	local function awaitReply(p4, p5)
		local timeout = HttpClient.asPromise(p4):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		v8[timeout] = p5
		local v9, v10 = timeout:awaitStatus()
		v8[timeout] = nil
		return v9, v10
	end

	local function cancelReplies(p4)
		for k, v9 in table.clone(v8) do
			if not (p4 == nil or v9 == p4) then
				continue
			end

			v8[k] = nil
			k:cancel()
		end
	end

	local function invalidateAutomaticWork()
		count2 += 1

		for k in v7 do
			p3[k] = nil
		end

		table.clear(v7)
		cancelReplies("automatic")
	end

	local function invalidateAsyncWork()
		count += 1
		count2 += 1

		for k in v7 do
			p3[k] = nil
		end

		table.clear(v7)
		cancelReplies("automatic")

		cancelReplies("afterDecision")
	end

	local function proposalFromFlow(data3, p4, p5)
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
			isApproved = p4,
			isRejected = p5,
			isPending = 0,
			hasError = 0,
			errorCause = 0,
			canRetry = 0
		}

		local v9 = if FFlagBuildExperienceDevProductRecovery then data3.isPending else nil
		result.isPending = v9

		local v10 = if FFlagBuildExperienceDevProductRecovery then not (data3.resultError == nil) and not p5 else nil
		result.hasError = v10

		local v11 = if FFlagBuildExperienceDevProductRecovery and FFlagBuildExperienceMonetizationFailureCauses and data3.resultError ~= nil and not p5 then monetizationFailureCauses.classify(data3.resultError) or data3.canRetry == true and "rateLimited" or nil else nil
		result.errorCause = v11

		local v12 = if FFlagBuildExperienceDevProductRecovery then data3.canRetry == true and not p5 else nil
		result.canRetry = v12

		if data.cardFields ~= nil then
			for k, v13 in data.cardFields(input) do
				result[k] = v13
			end
		end

		return result
	end

	local function submitAutomaticResult(p4, p5, formatResultContent, p6, p7, p8)
		if count ~= p7 or count2 ~= p8 then
			return
		end

		local submitActiveToolResult = p2.submitActiveToolResult(
			formatResultContent,
			p6,
			p5.turnId,
			p5.referenceId
		)

		if submitActiveToolResult == nil then
			v7[p4] = nil

			if count == p7 then
				p3[p4] = nil
			end
		else
			local timeout = HttpClient.asPromise(submitActiveToolResult):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS)
			v8[timeout] = "automatic"
			local v9, v10 = timeout:awaitStatus()
			v8[timeout] = nil

			if count ~= p7 or count2 ~= p8 then
				return
			end

			v7[p4] = nil

			if v9 == Promise.Status.Resolved then
				p3[p4] = true
				return
			end

			p3[p4] = nil
			local log = Debug.log
			local v12 = TOOL_NAME .. " automatic submit failed"
			local v14 = if typeof(v10) == "table" and typeof(v10.errorMessage) == "string" then v10.errorMessage else tostring(v10)

			log("warn", v12, { toolCallId = p4, status = v9, reason = v14 })
		end
	end

	local function runList(p4, p5, p6, p7)
		if count ~= p6 or count2 ~= p7 then
			return
		end

		local v9 = nil
		local v10

		if p2.universeId == nil then
			v10 = monetizationFailureCauses.MESSAGES.noUniverse
		else
			local list, v11 = data.list(p2.universeId)
			local v12, v13 = list:timeout(v11 or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v5):await()

			if v12 then
				if v13 == nil then
					v10 = "The request returned no result."
				else
					v9 = v13
				end
			elseif v13 == nil then
				v10 = "The request returned no result."
			elseif typeof(v13) == "table" and typeof(v13.errorMessage) == "string" then
				v10 = v13.errorMessage
			else
				v10 = tostring(v13)
			end
		end

		if count ~= p6 or count2 ~= p7 then
			return
		end

		local v11 = { status = "ok", action = "list" }

		if v9 == nil then
			v11 = {
				status = "error",
				action = "list",
				detailCode = "list_failed",
				message = v10 or "The list request failed."
			}
		else
			for k, v12 in v9 do
				v11[k] = v12
			end
		end

		local formatResultContent, v12 = tool.formatResultContent(v11)
		submitAutomaticResult(p4, p5, formatResultContent, v12 or v9 == nil, p6, p7)
	end

	local function recoverFailedSubmission(state, p4, p5)
		local v9

		if v6 == state then
			local generation = state.generation
			v9 = count == generation
		else
			v9 = false
		end

		if not v9 then
			data2.removeDevProductAction(state.toolCallId)
		elseif state.toolCallPresent then
			if FFlagBuildExperienceDevProductRecovery and FFlagBuildExperienceMonetizationFailureCauses and state.attempted and toolControllerUtils.isConversationGone(p5) then
				state.isPending = false
				state.canRetry = false
				p3[state.toolCallId] = true
				data2.markSubmitted(state.toolCallId)
				data2.setDevProductTool(proposalFromFlow(state, true, false))
				data2.removeDevProductAction(state.toolCallId)
				v6 = nil

				if callback ~= nil then
					callback(p4, p5)
				end
			else
				state.submitted = false

				if callback == nil then
					return
				end

				data2.setDevProductTool(proposalFromFlow(state, false, false))
				callback(p4, p5)
			end
		else
			data2.removeDevProductTool(state.toolCallId)
			data2.removeDevProductAction(state.toolCallId)
			v6 = nil
		end
	end

	local function submitResult(data3, p4, p5, p6)
		local v9

		if v6 == data3 then
			local generation = data3.generation
			v9 = count == generation
		else
			v9 = false
		end

		if not v9 then
			return
		end

		local submitActiveToolResult = p2.submitActiveToolResult(p4, p5, data3.turnId, data3.referenceId)
		local v10, v11

		if submitActiveToolResult == nil then
			v10 = "no session"
		else
			local timeout = HttpClient.asPromise(submitActiveToolResult):timeout(chatConstants.CAS_RPC_TIMEOUT_SECONDS)
			v8[timeout] = "afterDecision"
			v10, v11 = timeout:awaitStatus()
			v8[timeout] = nil
		end

		local v12

		if v6 == data3 then
			local generation = data3.generation
			v12 = count == generation
		else
			v12 = false
		end

		if not v12 then
			return
		end

		if v10 == Promise.Status.Resolved then
			p3[data3.toolCallId] = true
			data2.markSubmitted(data3.toolCallId)
			data2.removeDevProductAction(data3.toolCallId)

			if v6 == data3 then
				v6 = nil
			end
		else
			local v14 = if typeof(v11) == "table" then v11.responseCode else nil
			recoverFailedSubmission(data3, p6, v14)

			local log = Debug.log
			local v16 = TOOL_NAME .. " tool_result submit failed"
			local v17 = {
				sessionId = data3.sessionId,
				toolCallId = data3.toolCallId,
				action = data3.input.action,
				status = v10,
				reason = 0
			}
			local v18 = if typeof(v11) == "table" and typeof(v11.errorMessage) == "string" then v11.errorMessage else tostring(v11)

			v17.reason = v18
			log("warn", v16, v17)
		end
	end

	local function submitApproval(state)
		local v9

		if v6 == state then
			local generation = state.generation
			v9 = count == generation
		else
			v9 = false
		end

		if not v9 then
			return
		end

		if not state.attempted then
			state.attempted = true
			local v10 = nil
			local v11 = nil
			local v12 = nil
			local v13

			if state.universeId == nil then
				v13 = monetizationFailureCauses.MESSAGES.noUniverse
			else
				local v14 = data.mutate(state.universeId, state.input)

				if v14 == nil then
					v13 = "The write was not sent."
				else
					local v15 = if state.input.imageAssetId ~= nil then chatConstants.CAS_RPC_TIMEOUT_SECONDS * 2 else nil
					local v16
					v16, v11 = v14:timeout(v15 or chatConstants.CAS_RPC_TIMEOUT_SECONDS, v5):await()

					if v16 then
						if v11 == nil then
							v13 = "The request returned no result."
						else
							v10 = v11
						end

						v11 = nil
					elseif v11 == nil then
						v13 = "The request returned no result."
						v11 = nil
					elseif (typeof)(v11) == "table" and typeof(v11.errorMessage) == "string" then
						v13 = v11.errorMessage
					else
						v13 = tostring(v11)
					end
				end
			end

			local v14

			if v6 == state then
				local generation = state.generation
				v14 = count == generation
			else
				v14 = false
			end

			if not v14 then
				return
			end

			if v10 == nil and (typeof)(v11) == "table" then
				v10 = v11[data.resultKey]
			end

			if v13 ~= nil then
				local action = state.input.action
				v12 = (typeof)(v11) == "table" and v11.outcome == "unverified" and "outcome_unknown"
					or action .. "_failed"
			end

			state.result = v10
			state.resultError = v13
			state.resultDetailCode = v12

			if FFlagBuildExperienceDevProductRecovery and FFlagBuildExperienceMonetizationFailureCauses and v13 ~= nil then
				local action = state.input.action
				local v15

				if v10 == nil and (typeof)(v11) == "table" then
					if v11.retryable == true then
						v15 = true
					else
						local cause = v11.cause

						if action == "create" and v11.outcome == "failed" and typeof(cause) == "table" then
							v15 = cause.responseCode == 429
						else
							v15 = false
						end
					end
				else
					v15 = false
				end

				if v15 then
					state.attempted = false
					state.submitted = false
					state.isPending = false
					state.canRetry = true
					data2.setDevProductTool(proposalFromFlow(state, false, false))
					return
				end
			end
		end

		if FFlagBuildExperienceDevProductRecovery then
			state.isPending = false

			if data2.getOptimisticLocalTools(false).devProductByToolCallId[state.toolCallId] ~= nil then
				data2.setDevProductTool(proposalFromFlow(state, true, false))
			end
		end

		local v10 = { action = state.input.action }
		v10[data.resultKey] = state.result

		if state.resultError == nil then
			v10.status = "ok"
		else
			v10.status = "error"
			v10.detailCode = state.resultDetailCode
			v10.message = state.resultError
		end

		local formatResultContent, v11 = tool.formatResultContent(v10)
		submitResult(state, formatResultContent, v11 or state.resultError ~= nil, nil)
	end

	local function submitRejection(data3, p4)
		local v9

		if v6 == data3 then
			local generation = data3.generation
			v9 = count == generation
		else
			v9 = false
		end

		if not v9 then
			return
		end

		if not data3.attempted then
			submitResult(data3, tool.formatRejectionContent(data3.input.action, p4), false, p4)
			return
		end

		data2.setDevProductTool(proposalFromFlow(data3, true, false))
		submitApproval(data3)
	end

	local function settle(state, isPending, p4): boolean
		local v9

		if v6 == state then
			local generation = state.generation
			v9 = count == generation
		else
			v9 = false
		end

		if not v9 or state.submitted then
			return false
		end

		state.submitted = true

		if FFlagBuildExperienceDevProductRecovery then
			state.isPending = isPending
			state.canRetry = false
		end

		data2.setDevProductTool(proposalFromFlow(state, isPending, not isPending))
		task.spawn(function()
			if isPending then
				submitApproval(state)
			else
				submitRejection(state, p4)
			end
		end)
		return true
	end

	local function clearMutationFlow()
		local v9 = v6

		if v9 ~= nil then
			data2.removeDevProductTool(v9.toolCallId)
			data2.removeDevProductAction(v9.toolCallId)
		end

		v6 = nil
	end

	return {
		syncRequests = function(p4): boolean
			if v6 ~= nil then
				v6.toolCallPresent = p4.toolCalls[v6.toolCallId] ~= nil
			end

			for k in v7 do
				if p4.toolCalls[k] == nil then
					count2 += 1

					for k2 in v7 do
						p3[k2] = nil
					end

					table.clear(v7)
					cancelReplies("automatic")
					break
				end
			end

			local requestInTurnState, v10, v11, v12 = tool.findRequestInTurnState(p4, p3)

			if requestInTurnState == nil then
				if v6 == nil or v6.submitted or v6.attempted then
					return false
				end

				count += 1
				count2 += 1

				for k in v7 do
					p3[k] = nil
				end

				table.clear(v7)
				cancelReplies("automatic")

				cancelReplies("afterDecision")

				local v13 = v6

				if v13 ~= nil then
					data2.removeDevProductTool(v13.toolCallId)
					data2.removeDevProductAction(v13.toolCallId)
				end

				v6 = nil

				return false
			else
				if v7[requestInTurnState] then
					return true
				end

				local v13 = { turnId = v11, referenceId = v12 }

				local input, v14 = tool.parseInput(v10)

				if input ~= nil and input.createAndGoLive == true then
					input = nil
					v14 = "createAndGoLive is not supported yet. Create without it and ask the creator to activate the product separately."
				end

				if input == nil then
					v7[requestInTurnState] = true
					local v15 = count
					local v16 = count2
					task.spawn(function()
						submitAutomaticResult(
							requestInTurnState,
							v13,
							tool.formatResultContent({
								status = "error",
								action = "unknown",
								detailCode = "invalid_arguments",
								message = v14
							}),
							true,
							v15,
							v16
						)
					end)
					return true
				elseif tool.getActionKind(input.action) == "read" then
					p3[requestInTurnState] = true
					v7[requestInTurnState] = true
					local v15 = count
					local v16 = count2
					task.spawn(runList, requestInTurnState, v13, v15, v16)
					return true
				else
					if
						v6 ~= nil and (v6.submitted or v6.attempted)
						or v6 ~= nil and requestInTurnState == v6.toolCallId
					then
						return true
					end

					if v6 ~= nil then
						count += 1
						count2 += 1

						for k in v7 do
							p3[k] = nil
						end

						table.clear(v7)
						cancelReplies("automatic")

						cancelReplies("afterDecision")

						local v15 = v6

						if v15 ~= nil then
							data2.removeDevProductTool(v15.toolCallId)
							data2.removeDevProductAction(v15.toolCallId)
						end

						v6 = nil
					end

					local v15 = {
						sessionId = p4.sessionId,
						toolCallId = requestInTurnState,
						callOrder = toolControllerUtils.getToolCallOrder(p4, requestInTurnState),
						turnId = v11,
						referenceId = v12,
						universeId = p2.universeId,
						input = input,
						submitted = false,
						attempted = false,
						toolCallPresent = true,
						isPending = false,
						generation = count
					}

					v6 = v15
					data2.setDevProductTool(proposalFromFlow(v15, false, false))
					data2.setDevProductAction(requestInTurnState, function()
						settle(v15, true, nil)
					end, function()
						settle(v15, false, nil)
					end)
					Debug.log("info", TOOL_NAME .. " proposal displayed", {
						toolCallId = requestInTurnState,
						turnId = v11,
						action = input.action
					})

					return true
				end
			end
		end,
		stopPending = function()
			local v9 = v6

			if v9 == nil or not (v9.submitted or v9.attempted) then
				local v10 = v6 ~= nil or next(v7) ~= nil or next(v8) ~= nil

				if v10 then
					count += 1
					count2 += 1

					for k in v7 do
						p3[k] = nil
					end

					table.clear(v7)
					cancelReplies("automatic")

					cancelReplies("afterDecision")
				end

				if v9 == nil then
					return v10
				end

				v9.submitted = true
				p3[v9.toolCallId] = nil
				local v11 = v6

				if v11 ~= nil then
					data2.removeDevProductTool(v11.toolCallId)
					data2.removeDevProductAction(v11.toolCallId)
				end

				v6 = nil

				return v10
			else
				local v10 = next(v7) ~= nil

				if not v10 then
					return v10
				end

				count2 += 1

				for k in v7 do
					p3[k] = nil
				end

				table.clear(v7)
				cancelReplies("automatic")

				return v10
			end
		end,
		trySubmitComposerText = function(p4)
			return v6 ~= nil and settle(v6, false, p4)
		end
	}
end

return createMonetizationToolController
