local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

require(AmpV2Wizard.Types)
local walkerReducer = require(AmpV2Wizard.walkerReducer)
local WizardEventNames = require(AmpV2Wizard.WizardEventNames)
local FFlagAmpV2WizardAnalytics = require(AmpV2Wizard.FFlagAmpV2WizardAnalytics)
local FFlagAmpV2WizardAuthorizationModal = require(AmpV2Wizard.FFlagAmpV2WizardAuthorizationModal)
local VpcEntryAnalytics = require(AmpV2Wizard.VpcEntryAnalytics)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAmpWizardSendAnalyticsSessionId = SharedFlags.FFlagLuaAppAmpWizardSendAnalyticsSessionId

local EventNames = WizardEventNames.EventNames

local function buildEventContext(data, surface: string, rootFlow: string?)
	local currentNodeId = data.currentNodeId
	local v

	if currentNodeId ~= nil then
		v = data.nodes[currentNodeId]
	end

	local eventContext = {
		flowId = data.flowId,
		chosenFlow = data.chosenFlow,
		rootFlow = rootFlow,
		surface = surface,
		node = currentNodeId,
		nodeType = 0,
		analyticsSessionId = 0
	}
	local nodeType

	if v ~= nil then
		nodeType = v.type
	end

	eventContext.nodeType = nodeType
	local analyticsSessionId

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId and data.analyticsSessionId ~= "" then
		analyticsSessionId = data.analyticsSessionId
	end

	eventContext.analyticsSessionId = analyticsSessionId
	return eventContext
end

local function mergeParams(p, items) -- 3 equivalent calls inferred from this helper
	local clone = table.clone(p)

	if items ~= nil then
		for k, item in items do
			clone[k] = item
		end
	end

	return clone
end

local function noopSend(_: string, _) end

local function useWizardWalker(data)
	local api = data.api
	local target = data.target
	local rootFlow = data.rootFlow
	local surface = data.surface
	local onExit = data.onExit
	local onEvent = data.onEvent

	local v = noopSend

	if FFlagAmpV2WizardAnalytics then
		v = data.sendEvent

		if not v then
			local WizardAnalytics = require(AmpV2Wizard.WizardAnalytics)
			v = WizardAnalytics.default
		end
	end

	local current3, v2 = React.useReducer(walkerReducer.reduce, data.initialFragment, walkerReducer.init)

	local ref = React.useRef(current3)
	ref.current = current3

	local ref2 = React.useRef(false)
	local v3

	if current3.currentNodeId then
		v3 = current3.nodes[current3.currentNodeId]
	end

	local ref3 = nil
	local ref4, dismissPresentation

	if FFlagAmpV2WizardAuthorizationModal then
		ref3 = React.useRef(nil)
		ref4 = React.useRef(0)

		if v3 ~= nil then
			if v3.type == "VerificationMethodSelection" and current3.currentNodeId ~= nil then
				ref3.current = {
					nodeId = current3.currentNodeId,
					node = v3,
					flow = current3.chosenFlow
				}
			elseif v3.behavior == nil or v3.behavior.presentsOverPrevious ~= true then
				ref3.current = nil
			end
		end

		dismissPresentation = React.useCallback(function()
			local current = ref.current
			local v4

			if current.currentNodeId then
				v4 = current.nodes[current.currentNodeId]
			end

			if current.exited or v4 == nil or v4.type ~= "SessionPolling" then
				return
			end

			local current2 = ref3.current

			if current2 ~= nil and current2.flow ~= current.chosenFlow then
				current2 = nil
			end

			ref4.current += 1
			ref2.current = false
			local nodeId

			if current2 then
				nodeId = current2.nodeId
			end

			local node

			if current2 then
				node = current2.node
			end

			local v5 = { type = "DismissPresentation", nodeId = nodeId, node = node }

			ref.current = walkerReducer.reduce(current, v5)
			v2(v5)
		end, {})
	else
		ref4 = nil
	end

	local eventContext = buildEventContext(current3, surface, rootFlow)

	local logEvent = React.useCallback(function(p: string, items)
		v(p, mergeParams(buildEventContext(ref.current, surface, rootFlow), items)) -- inferred equivalent call
	end, { v, surface, rootFlow })

	local ref5 = React.useRef(data.initialFragment.resumeSourcePage ~= nil)

	React.useEffect(function()
		if ref5.current or ref.current.currentNodeId == nil then
			return
		end

		ref5.current = true
		logEvent(EventNames.FlowStart)

		if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
			local current = ref.current
			VpcEntryAnalytics.sendWizardLaunch(
				current.analyticsStrings,
				current.analyticsSessionId,
				surface,
				rootFlow,
				current.chosenFlow,
				data.initialFragment.entry
			)
		end
	end, {})

	React.useEffect(function()
		if current3.currentNodeId == nil then
			return
		end

		logEvent(EventNames.NodeShown)
	end, { current3.currentNodeId, current3.chosenFlow })

	local exited = current3.exited
	local exitResult = current3.exitResult
	local ref6 = React.useRef(false)
	React.useEffect(function()
		if not exited or ref6.current then
			return
		end

		ref6.current = true

		if exitResult == nil then
			return
		end

		if ref5.current then
			logEvent(EventNames.FlowExit, {
				reason = exitResult.reason,
				outcome = exitResult.outcome
			})
		end

		if onExit then
			onExit(exitResult)
		end
	end, { exited, exitResult, onExit, logEvent })

	local report = React.useCallback(function(outcome: string, payload)
		local current = ref.current
		local currentNodeId = current.currentNodeId

		if currentNodeId == nil or current.exited or current.isLoading or ref2.current then
			return
		end

		local node = current.nodes[currentNodeId]

		if
			FFlagAmpV2WizardAuthorizationModal
			and outcome == "Poll"
			and (node == nil or node.type ~= "SessionPolling")
		then
			return
		end

		local v4

		if node then
			v4 = node.transitions[outcome]
		end

		local eventContext2 = buildEventContext(current, surface, rootFlow)

		local nodeOutcome = EventNames.NodeOutcome
		local transitionKind

		if v4 then
			transitionKind = v4.kind
		end

		v(nodeOutcome, mergeParams(eventContext2, { -- inferred equivalent call
			outcome = outcome,
			transitionKind = transitionKind
		}))

		if onEvent then
			local v5 = {
				flowId = current.flowId,
				node = currentNodeId,
				outcome = outcome,
				transitionKind = 0
			}
			local transitionKind2

			if v4 then
				transitionKind2 = v4.kind
			end

			v5.transitionKind = transitionKind2
			onEvent(v5)
		end

		v2({ type = "ReportOutcome", outcome = outcome, data = payload })

		if v4 ~= nil and v4.kind == "Continue" then
			ref2.current = true

			local clone = table.clone(current.history)
			table.insert(clone, {
				flow = current.chosenFlow,
				node = currentNodeId,
				outcome = outcome,
				data = payload
			})
			local current2

			if ref4 then
				current2 = ref4.current
			else
				current2 = nil
			end

			api.continue({
				flowId = current.flowId,
				state = current.flowState,
				target = target,
				rootFlow = rootFlow,
				flowInputs = current.flowInputs,
				history = clone,
				payload = payload
			}):andThen(function(response)
				if ref4 and ref4.current ~= current2 then
					return
				end

				ref2.current = false
				v2({ type = "FragmentLoaded", response = response })
			end):catch(function(p)
				if ref4 and ref4.current ~= current2 then
					return
				end

				ref2.current = false
				v(EventNames.ContinueFailed, mergeParams(eventContext2, { -- inferred equivalent call
					errorMessage = tostring(p)
				}))
				v2({ type = "ContinueFailed", message = tostring(p) })
			end)
		end
	end, { api, target, rootFlow, surface, onEvent, v, ref4 })

	local acknowledgeError = React.useCallback(function()
		v2({ type = "AcknowledgeError" })
	end, {})

	return {
		dismissPresentation = dismissPresentation,
		currentNode = v3,
		currentNodeId = current3.currentNodeId,
		isLoading = current3.isLoading,
		exited = exited,
		presentingError = current3.presentingError,
		acknowledgeError = acknowledgeError,
		analyticsStrings = current3.analyticsStrings,
		analyticsSessionId = current3.analyticsSessionId,
		report = report,
		eventContext = eventContext,
		logEvent = logEvent
	}
end

return useWizardWalker
