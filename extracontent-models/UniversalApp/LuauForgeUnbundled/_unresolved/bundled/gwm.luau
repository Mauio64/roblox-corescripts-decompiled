require("@luauforge/bundled/gvc")
local module = require("@luauforge/bundled/gwn")
local module2 = require("@luauforge/bundled/gwo")

local function appendStep(p2, p3)
	local clone = table.clone(p2)
	table.insert(clone, p3)
	return clone
end

local function errorExit(data, clone, outcome)
	return {
		flowId = data.flowId,
		analyticsSessionId = data.analyticsSessionId,
		chosenFlow = data.chosenFlow,
		nodes = data.nodes,
		currentNodeId = data.currentNodeId,
		history = clone,
		flowInputs = data.flowInputs,
		flowState = data.flowState,
		analyticsStrings = data.analyticsStrings,
		isLoading = false,
		presentingError = false,
		exited = true,
		exitResult = { reason = "Error", flowId = data.flowId, outcome = outcome }
	}
end

local function mergeAnalytics(p2, items)
	if items == nil then
		return p2
	end

	if p2 == nil then
		return items
	end

	local clone = table.clone(p2)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

local function enterFragment(data, history, flowId, analyticsSessionId, p2, p3, p4, analyticsStrings)
	local v6 = not (data.entry == nil) and data.entry ~= ""
	local v7 = v6 and data.nodes[data.entry] ~= nil

	local v8 = not v6 and data.outcome == "Error"
	local v9 = module and not v6 and data.outcome == "RateLimited" and true or v8
	local v10

	if v6 then
		v10 = not v7 and { reason = "Error", flowId = flowId } or nil
	else
		local v11 = history[#history]

		local outcome = if module2 then (if v11 == nil then data.outcome else v11.outcome) else nil

		v10 = v9 and { reason = "Error", flowId = flowId, outcome = data.outcome }
			or { reason = "Completed", flowId = flowId, outcome = outcome }
	end

	local v11 = {
		flowId = flowId,
		analyticsSessionId = analyticsSessionId,
		chosenFlow = p2,
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
	local v12 = if v7 then data.entry else nil
	v11.currentNodeId = v12
	v11.history = history

	v11.flowInputs = data.flowInputs or p3
	v11.flowState = data.state or p4
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

	v11.analyticsStrings = analyticsStrings

	v11.presentingError = v9
	v11.exited = not (v7 or v9)
	v11.exitResult = v10
	return v11
end

local v5 = {}

function v5.init(data)
	return enterFragment(
		data,
		{},
		data.flowId,
		data.analyticsSessionId or "",
		data.chosenFlow,
		nil,
		nil,
		nil
	)
end

local function reduceReport(data, data2)
	assert(data2.type == "ReportOutcome", "reduceReport called with wrong action")

	local currentNodeId = data.currentNodeId

	if currentNodeId == nil then
		return data
	end

	local node = data.nodes[currentNodeId]
	local v6 = if node then node.transitions[data2.outcome] else nil

	local v7 = {
		flow = data.chosenFlow,
		node = currentNodeId,
		outcome = data2.outcome,
		data = data2.data
	}

	local history = data.history
	local clone = table.clone(history)
	table.insert(clone, v7)

	if v6 == nil then
		return errorExit(data, clone, data2.outcome)
	end

	if v6.kind == "Goto" then
		local node2 = v6.node

		if node2 == nil or data.nodes[node2] == nil then
			return errorExit(data, clone, data2.outcome)
		end

		return {
			flowId = data.flowId,
			analyticsSessionId = data.analyticsSessionId,
			chosenFlow = data.chosenFlow,
			nodes = data.nodes,
			currentNodeId = node2,
			history = clone,
			flowInputs = data.flowInputs,
			flowState = data.flowState,
			analyticsStrings = data.analyticsStrings,
			isLoading = false,
			presentingError = false,
			exited = false,
			exitResult = nil
		}
	elseif v6.kind == "Continue" then
		return {
			flowId = data.flowId,
			analyticsSessionId = data.analyticsSessionId,
			chosenFlow = data.chosenFlow,
			nodes = data.nodes,
			currentNodeId = data.currentNodeId,
			history = clone,
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
			history = clone,
			flowInputs = data.flowInputs,
			flowState = data.flowState,
			analyticsStrings = data.analyticsStrings,
			isLoading = false,
			presentingError = false,
			exited = true,
			exitResult = {
				reason = "Completed",
				flowId = data.flowId,
				outcome = data2.outcome
			}
		}
	end
end

local function reduceFragmentLoaded(data, response)
	local flowId = if response.flowId == "" then data.flowId else response.flowId

	local analyticsSessionId = response.analyticsSessionId

	if analyticsSessionId == nil or analyticsSessionId == "" then
		analyticsSessionId = data.analyticsSessionId
	end

	local v6 = if response.chosenFlow == "" then data.chosenFlow else response.chosenFlow
	return enterFragment(
		response,
		data.history,
		flowId,
		analyticsSessionId,
		v6,
		data.flowInputs,
		data.flowState,
		data.analyticsStrings
	)
end

function v5.reduce(data, data2)
	if data2.type == "DismissPresentation" then
		local clone = table.clone(data)
		clone.isLoading = false
		clone.presentingError = false
		clone.exited = false
		clone.exitResult = nil

		if data.currentNodeId ~= nil then
			local history = data.history
			local v6 = {
				flow = data.chosenFlow,
				node = data.currentNodeId,
				outcome = "Cancel"
			}
			local clone2 = table.clone(history)
			table.insert(clone2, v6)

			clone.history = clone2
		end

		if data2.nodeId == nil or data2.node == nil then
			clone.exited = true
			clone.exitResult = {
				reason = "Cancelled",
				flowId = data.flowId,
				outcome = "Cancel"
			}
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

return v5
