local module = require("@luauforge/bundled/gvb")

require("@luauforge/bundled/gvc")
local module2 = require("@luauforge/bundled/gwm")
local module3 = require("@luauforge/bundled/gwp")
local module4 = require("@luauforge/bundled/gwq")
local module5 = require("@luauforge/bundled/gvL")
local module6 = require("@luauforge/bundled/gvo")

local fFlagLuaAppAmpWizardSendAnalyticsSessionId = require("@luauforge/bundled/gvp").FFlagLuaAppAmpWizardSendAnalyticsSessionId

local eventNames = module3.EventNames

local function buildEventContext(data, surface, rootFlow)
	local currentNodeId = data.currentNodeId
	local v5 = if currentNodeId ~= nil then data.nodes[currentNodeId] else nil
	local eventContext = {
		flowId = data.flowId,
		chosenFlow = data.chosenFlow,
		rootFlow = rootFlow,
		surface = surface,
		node = currentNodeId,
		nodeType = 0,
		analyticsSessionId = 0
	}

	local v6 = if v5 ~= nil then v5.type else nil
	eventContext.nodeType = v6
	local v7 = if fFlagLuaAppAmpWizardSendAnalyticsSessionId and data.analyticsSessionId ~= "" then data.analyticsSessionId else nil
	eventContext.analyticsSessionId = v7
	return eventContext
end

local function mergeParams(p2, items)
	local clone = table.clone(p2)

	if items ~= nil then
		for k, item in items do
			clone[k] = item
		end
	end

	return clone
end

local function noopSend(p2, p3) end

local function useWizardWalker(data)
	local api = data.api
	local target = data.target
	local rootFlow = data.rootFlow
	local surface = data.surface
	local onExit = data.onExit
	local onEvent = data.onEvent

	local v5 = noopSend

	if module4 then
		v5 = data.sendEvent or require("@luauforge/bundled/gwr").default
	end

	local v6, v7 = module.useReducer(module2.reduce, data.initialFragment, module2.init)

	local ref = module.useRef(v6)
	ref.current = v6

	local ref2 = module.useRef(false)

	local v8 = if v6.currentNodeId then v6.nodes[v6.currentNodeId] else nil

	local ref3 = nil
	local ref4, v9

	if module5 then
		ref3 = module.useRef(nil)
		ref4 = module.useRef(0)

		if v8 ~= nil then
			if v8.type == "VerificationMethodSelection" and v6.currentNodeId ~= nil then
				ref3.current = {
					nodeId = v6.currentNodeId,
					node = v8,
					flow = v6.chosenFlow
				}
			elseif v8.behavior == nil or v8.behavior.presentsOverPrevious ~= true then
				ref3.current = nil
			end
		end

		v9 = module.useCallback(function()
			local current = ref.current
			local v10 = if current.currentNodeId then current.nodes[current.currentNodeId] else nil

			if current.exited or v10 == nil or v10.type ~= "SessionPolling" then
				return
			end

			local current2 = ref3.current

			if current2 ~= nil and current2.flow ~= current.chosenFlow then
				current2 = nil
			end

			ref4.current += 1
			ref2.current = false

			local v13 = if current2 then current2.nodeId else nil
			local v14 = if current2 then current2.node else nil
			local v12 = { type = "DismissPresentation", nodeId = v13, node = v14 }

			ref.current = module2.reduce(current, v12)
			v7(v12)
		end, {})
	else
		ref4 = nil
	end

	local eventContext = buildEventContext(v6, surface, rootFlow)

	local v10 = module.useCallback(function(p2, items)
		local eventContext2 = buildEventContext(ref.current, surface, rootFlow)
		local clone = table.clone(eventContext2)

		if items ~= nil then
			for k, item in items do
				clone[k] = item
			end
		end

		v5(p2, clone)
	end, { v5, surface, rootFlow })

	local ref5 = module.useRef(data.initialFragment.resumeSourcePage ~= nil)

	module.useEffect(function()
		if ref5.current or ref.current.currentNodeId == nil then
			return
		end

		ref5.current = true
		v10(eventNames.FlowStart)

		if fFlagLuaAppAmpWizardSendAnalyticsSessionId then
			local current = ref.current
			module6.sendWizardLaunch(
				current.analyticsStrings,
				current.analyticsSessionId,
				surface,
				rootFlow,
				current.chosenFlow,
				data.initialFragment.entry
			)
		end
	end, {})

	module.useEffect(function()
		if v6.currentNodeId == nil then
			return
		end

		v10(eventNames.NodeShown)
	end, { v6.currentNodeId, v6.chosenFlow })

	local exited = v6.exited
	local exitResult = v6.exitResult
	local ref6 = module.useRef(false)
	module.useEffect(function()
		if not exited or ref6.current then
			return
		end

		ref6.current = true

		if exitResult == nil then
			return
		end

		if ref5.current then
			v10(eventNames.FlowExit, {
				reason = exitResult.reason,
				outcome = exitResult.outcome
			})
		end

		if onExit then
			onExit(exitResult)
		end
	end, { exited, exitResult, onExit, v10 })

	local v11 = module.useCallback(function(p2, p3)
		local current = ref.current
		local currentNodeId = current.currentNodeId

		if currentNodeId == nil or current.exited or current.isLoading or ref2.current then
			return
		end

		local node = current.nodes[currentNodeId]

		if module5 and p2 == "Poll" and (node == nil or node.type ~= "SessionPolling") then
			return
		end

		local v12 = if node then node.transitions[p2] else nil
		local eventContext2 = buildEventContext(current, surface, rootFlow)

		local nodeOutcome = eventNames.NodeOutcome

		local v15 = if v12 then v12.kind else nil
		local v14 = { outcome = p2, transitionKind = v15 }
		local clone = table.clone(eventContext2)

		if v14 ~= nil then
			for k, v16 in v14 do
				clone[k] = v16
			end
		end

		v5(nodeOutcome, clone)

		if onEvent then
			local v17 = {
				flowId = current.flowId,
				node = currentNodeId,
				outcome = p2,
				transitionKind = 0
			}

			local v18 = if v12 then v12.kind else nil
			v17.transitionKind = v18
			onEvent(v17)
		end

		v7({ type = "ReportOutcome", outcome = p2, data = p3 })

		if v12 ~= nil and v12.kind == "Continue" then
			ref2.current = true

			local clone2 = table.clone(current.history)
			table.insert(clone2, {
				flow = current.chosenFlow,
				node = currentNodeId,
				outcome = p2,
				data = p3
			})

			local current2 = if ref4 then ref4.current else nil
			api.continue({
				flowId = current.flowId,
				state = current.flowState,
				target = target,
				rootFlow = rootFlow,
				flowInputs = current.flowInputs,
				history = clone2,
				payload = p3
			}):andThen(function(p4)
				if ref4 and ref4.current ~= current2 then
					return
				end

				ref2.current = false
				v7({ type = "FragmentLoaded", response = p4 })
			end):catch(function(p4)
				if ref4 and ref4.current ~= current2 then
					return
				end

				ref2.current = false
				local continueFailed = eventNames.ContinueFailed
				local v18 = { errorMessage = tostring(p4) }
				local clone3 = table.clone(eventContext2)

				if v18 ~= nil then
					for k, v19 in v18 do
						clone3[k] = v19
					end
				end

				v5(continueFailed, clone3)
				v7({ type = "ContinueFailed", message = tostring(p4) })
			end)
		end
	end, { api, target, rootFlow, surface, onEvent, v5, ref4 })

	local v12 = module.useCallback(function()
		v7({ type = "AcknowledgeError" })
	end, {})

	return {
		dismissPresentation = v9,
		currentNode = v8,
		currentNodeId = v6.currentNodeId,
		isLoading = v6.isLoading,
		exited = exited,
		presentingError = v6.presentingError,
		acknowledgeError = v12,
		analyticsStrings = v6.analyticsStrings,
		analyticsSessionId = v6.analyticsSessionId,
		report = v11,
		eventContext = eventContext,
		logEvent = v10
	}
end

return useWizardWalker
