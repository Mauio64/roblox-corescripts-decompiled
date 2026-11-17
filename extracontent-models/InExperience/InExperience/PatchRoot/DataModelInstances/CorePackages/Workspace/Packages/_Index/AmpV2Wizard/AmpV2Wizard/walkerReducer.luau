local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")

require(AmpV2Wizard.Types)
local FFlagAmpV2WizardRateLimitedOutcome = require(AmpV2Wizard.FFlagAmpV2WizardRateLimitedOutcome)
local FFlagAmpV2WizardTerminalOutcome = require(AmpV2Wizard.FFlagAmpV2WizardTerminalOutcome)

local function appendStep(history, p) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(history)
	table.insert(clone, p)
	return clone
end

local function errorExit(data, history, outcome: string?)
	return {
		flowId = data.flowId,
		analyticsSessionId = data.analyticsSessionId,
		chosenFlow = data.chosenFlow,
		nodes = data.nodes,
		currentNodeId = data.currentNodeId,
		history = history,
		flowInputs = data.flowInputs,
		flowState = data.flowState,
		analyticsStrings = data.analyticsStrings,
		isLoading = false,
		presentingError = false,
		exited = true,
		exitResult = { reason = "Error", flowId = data.flowId, outcome = outcome }
	}
end

local function mergeAnalytics(p, items)
	if items == nil then
		return p
	end

	if p == nil then
		return items
	end

	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

local function enterFragment(data, history, flowId: string, analyticsSessionId: string, chosenFlow: string, p, p2, analyticsStrings)
	local v

	if data.entry == nil then
		v = false
	else
		v = data.entry ~= ""
	end

	local v2 = v and data.nodes[data.entry] ~= nil

	local v3 = not v and data.outcome == "Error"
	local presentingError = FFlagAmpV2WizardRateLimitedOutcome and not v and data.outcome == "RateLimited" and true
		or v3
	local exitResult

	if v then
		exitResult = not v2 and { reason = "Error", flowId = flowId } or nil
	else
		local v4 = history[#history]
		local outcome

		if FFlagAmpV2WizardTerminalOutcome then
			outcome = if v4 == nil then data.outcome else v4.outcome
		end

		exitResult = presentingError and {
				reason = "Error",
				flowId = flowId,
				outcome = data.outcome
			}
			or { reason = "Completed", flowId = flowId, outcome = outcome }
	end

	local v4 = {
		flowId = flowId,
		analyticsSessionId = analyticsSessionId,
		chosenFlow = chosenFlow,
		nodes = data.nodes,
		currentNodeId = 0,
		history = 0,
		flowInputs = 0,
		flowState = 0,
		analyticsStrings = 0,
		isLoading = false,
		presentingError = 0,
		exited = 0,
		exitResult = 0
	}
	local currentNodeId

	if v2 then
		currentNodeId = data.entry
	end

	v4.currentNodeId = currentNodeId
	v4.history = history

	v4.flowInputs = data.flowInputs or p
	v4.flowState = data.state or p2
	local analytics = data.analytics

	if analytics ~= nil then
		if analyticsStrings == nil then
			analyticsStrings = analytics
		else
			analyticsStrings = table.clone(analyticsStrings)

			for k, analytic in analytics do
				analyticsStrings[k] = analytic
			end
		end
	end

	v4.analyticsStrings = analyticsStrings

	v4.presentingError = presentingError
	v4.exited = not (v2 or presentingError)
	v4.exitResult = exitResult
	return v4
end

local WalkerReducer = {}

function WalkerReducer.init(data)
	return enterFragment(data, {}, data.flowId, data.analyticsSessionId or "", data.chosenFlow, nil, nil, nil)
end

local function reduceReport(data, data2)
	assert(data2.type == "ReportOutcome", "reduceReport called with wrong action")

	local currentNodeId = data.currentNodeId

	if currentNodeId == nil then
		return data
	end

	local node = data.nodes[currentNodeId]
	local v

	if node then
		v = node.transitions[data2.outcome]
	end

	local v2 = {
		flow = data.chosenFlow,
		node = currentNodeId,
		outcome = data2.outcome,
		data = data2.data
	}

	local history = appendStep(data.history, v2) -- inferred equivalent call

	if v == nil then
		return errorExit(data, history, data2.outcome)
	end

	if v.kind == "Goto" then
		local node2 = v.node

		if node2 == nil or data.nodes[node2] == nil then
			return errorExit(data, history, data2.outcome)
		end

		return {
			flowId = data.flowId,
			analyticsSessionId = data.analyticsSessionId,
			chosenFlow = data.chosenFlow,
			nodes = data.nodes,
			currentNodeId = node2,
			history = history,
			flowInputs = data.flowInputs,
			flowState = data.flowState,
			analyticsStrings = data.analyticsStrings,
			isLoading = false,
			presentingError = false,
			exited = false,
			exitResult = nil
		}
	elseif v.kind == "Continue" then
		return {
			flowId = data.flowId,
			analyticsSessionId = data.analyticsSessionId,
			chosenFlow = data.chosenFlow,
			nodes = data.nodes,
			currentNodeId = data.currentNodeId,
			history = history,
			flowInputs = data.flowInputs,
			flowState = data.flowState,
			analyticsStrings = data.analyticsStrings,
			isLoading = true,
			presentingError = false,
			exited = false,
			exitResult = nil
		}
	else
		return {
			flowId = data.flowId,
			analyticsSessionId = data.analyticsSessionId,
			chosenFlow = data.chosenFlow,
			nodes = data.nodes,
			currentNodeId = data.currentNodeId,
			history = history,
			flowInputs = data.flowInputs,
			flowState = data.flowState,
			analyticsStrings = data.analyticsStrings,
			isLoading = false,
			presentingError = false,
			exited = true,
			exitResult = { reason = "Completed", flowId = data.flowId, outcome = data2.outcome }
		}
	end
end

local function reduceFragmentLoaded(data, response)
	local flowId

	if response.flowId == "" then
		flowId = data.flowId
	else
		flowId = response.flowId
	end

	local analyticsSessionId = response.analyticsSessionId

	if analyticsSessionId == nil or analyticsSessionId == "" then
		analyticsSessionId = data.analyticsSessionId
	end

	local v

	if response.chosenFlow == "" then
		v = data.chosenFlow
	else
		v = response.chosenFlow
	end

	return enterFragment(
		response,
		data.history,
		flowId,
		analyticsSessionId,
		v,
		data.flowInputs,
		data.flowState,
		data.analyticsStrings
	)
end

function WalkerReducer.reduce(data, data2)
	if data2.type == "DismissPresentation" then
		local clone = table.clone(data)
		clone.isLoading = false
		clone.presentingError = false
		clone.exited = false
		clone.exitResult = nil

		if data.currentNodeId ~= nil then
			clone.history = appendStep(data.history, { -- inferred equivalent call
				flow = data.chosenFlow,
				node = data.currentNodeId,
				outcome = "Cancel"
			})
		end

		if data2.nodeId == nil or data2.node == nil then
			clone.exited = true
			clone.exitResult = { reason = "Cancelled", flowId = data.flowId, outcome = "Cancel" }
		else
			clone.nodes = table.clone(data.nodes)
			clone.nodes[data2.nodeId] = data2.node
			clone.currentNodeId = data2.nodeId
		end

		return clone
	else
		if data2.type == "ReportOutcome" then
			return reduceReport(data, data2)
		end

		if data2.type == "FragmentLoaded" then
			return reduceFragmentLoaded(data, data2.response)
		end

		if data2.type == "ContinueFailed" then
			return {
				flowId = data.flowId,
				analyticsSessionId = data.analyticsSessionId,
				chosenFlow = data.chosenFlow,
				nodes = data.nodes,
				currentNodeId = data.currentNodeId,
				history = data.history,
				flowInputs = data.flowInputs,
				flowState = data.flowState,
				analyticsStrings = data.analyticsStrings,
				isLoading = false,
				presentingError = false,
				exited = true,
				exitResult = { reason = "Error", flowId = data.flowId }
			}
		end

		if not (data2.type == "AcknowledgeError" and data.presentingError) then
			return data
		end

		local clone = table.clone(data)
		clone.presentingError = false
		clone.exited = true
		return clone
	end
end

return WalkerReducer
