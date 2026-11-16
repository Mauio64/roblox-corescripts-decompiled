local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Dash = require(parent.Dash)

require(script.Parent.AbuseSheetFlowTypes)

local function getInitialState(runId: string, initialEnterTime: number, startNodeId: string)
	return {
		runId = runId,
		userId = not LocalPlayer and 0 or LocalPlayer.UserId,
		stack = {
			{ nodeId = startNodeId, store = {}, enterTime = initialEnterTime }
		},
		navigationState = "idle",
		submissionState = "idle",
		openTime = initialEnterTime
	}
end

local Reducer = {}
Reducer.getInitialState = getInitialState

function Reducer.getNewRunId()
	return HttpService:GenerateGUID(false)
end

function Reducer.selectStore(p)
	local store = {}

	for _, v in p.stack do
		if not v.store then
			continue
		end

		for k, v2 in v.store do
			store[k] = v2
		end
	end

	return store
end

function Reducer.reducer(p, p2)
	local v = nil

	if p2.type == "gotoNode" then
		if not (p2.payload and p2.payload.nodeId) then
			error(`gotoNode action requires payload.nodeId, got: {Dash.pretty(p2, { depth = 5 })}`)
		end

		local v2 = { nodeId = p2.payload.nodeId, store = {}, enterTime = p2.payload.enterTime }

		local clone = table.clone(p.stack)
		table.insert(clone, v2)

		return (Dash.join(p, {
			navigationState = "idle",
			lastNavigationDirection = "forward",
			stack = clone
		}))
	elseif p2.type == "replaceAndGotoNode" then
		local last = Dash.last(p.stack)

		if not last then
			error("Stack is empty, cannot replace and go to node")
		end

		local slice = Dash.slice(p.stack, 1, #p.stack - 1)
		table.insert(slice, {
			nodeId = p2.payload.nodeId,
			store = last.store,
			enterTime = p2.payload.enterTime
		})

		return (Dash.join(p, {
			navigationState = "idle",
			lastNavigationDirection = "forward",
			stack = slice
		}))
	elseif p2.type == "goBack" then
		if #p.stack <= 1 then
			warn("Cannot go back from stack with only one or zero items")
			return p
		end

		return (Dash.join(p, {
			lastNavigationDirection = "back",
			stack = Dash.slice(p.stack, 1, #p.stack - 1)
		}))
	elseif p2.type == "updateDataAndNavigateNext" then
		local last = Dash.last(p.stack)

		if not last then
			error("Stack is empty, cannot update data")
		end

		if not (p2.payload.expectedFromNodeId == last.nodeId and p.navigationState == "idle") then
			return p
		end

		local joined = Dash.join(last, {
			store = Dash.join(last.store, p2.payload.store)
		})

		local values = Dash.slice(p.stack, 1, #p.stack - 1)
		table.insert(values, joined)
		return (Dash.join(p, { stack = values, navigationState = "gotoNext" }))
	elseif p2.type == "navigateFailure" then
		local last = Dash.last(p.stack)

		if not last then
			error("Stack is empty, cannot navigate after failure")
		end

		if p2.payload.expectedFromNodeId ~= last.nodeId then
			return p
		end

		if p.navigationState == "idle" then
			return (Dash.join(p, { navigationState = "gotoFailure" }))
		end

		return p
	else
		if p2.type == "startedSubmission" then
			return (Dash.join(p, { submissionState = "submitting" }))
		end

		if p2.type == "completedSubmission" then
			return (Dash.join(p, { submissionState = "completed" }))
		end

		if p2.type == "submissionFailed" then
			return (Dash.join(p, { submissionState = "failed" }))
		end

		if p2.type == "reset" then
			return getInitialState(p2.payload.runId, p2.payload.initialEnterTime, p2.payload.startNodeId)
		end

		error("Unknown action type: " .. tostring(p2.type))

		return v
	end
end

return Reducer
