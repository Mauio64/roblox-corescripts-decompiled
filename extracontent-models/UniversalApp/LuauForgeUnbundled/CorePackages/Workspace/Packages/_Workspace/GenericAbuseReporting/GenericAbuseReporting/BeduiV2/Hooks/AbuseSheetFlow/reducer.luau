local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")

local function getInitialState(runId, initialEnterTime, startNodeId)
	return {
		runId = runId,
		userId = not localPlayer and 0 or localPlayer.UserId,
		stack = {
			{ nodeId = startNodeId, store = {}, enterTime = initialEnterTime }
		},
		navigationState = "idle",
		submissionState = "idle",
		openTime = initialEnterTime
	}
end

return {
	getInitialState = getInitialState,
	getNewRunId = function()
		return HttpService:GenerateGUID(false)
	end,
	selectStore = function(p2)
		local store = {}

		for k, v5 in p2.stack do
			if not v5.store then
				continue
			end

			for k2, v6 in v5.store do
				store[k2] = v6
			end
		end

		return store
	end,
	reducer = function(p2, p3)
		local v5 = nil

		if p3.type == "gotoNode" then
			if not (p3.payload and p3.payload.nodeId) then
				error(`gotoNode action requires payload.nodeId, got: {module.pretty(p3, { depth = 5 })}`)
			end

			local v6 = {
				nodeId = p3.payload.nodeId,
				store = {},
				enterTime = p3.payload.enterTime
			}

			local clone = table.clone(p2.stack)
			table.insert(clone, v6)

			return (Dash.join(p2, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = clone
			}))
		elseif p3.type == "replaceAndGotoNode" then
			local last = Dash.last(p2.stack)

			if not last then
				error("Stack is empty, cannot replace and go to node")
			end

			local slice = Dash.slice(p2.stack, 1, #p2.stack - 1)
			table.insert(slice, {
				nodeId = p3.payload.nodeId,
				store = last.store,
				enterTime = p3.payload.enterTime
			})

			return (Dash.join(p2, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = slice
			}))
		elseif p3.type == "goBack" then
			if #p2.stack <= 1 then
				warn("Cannot go back from stack with only one or zero items")
				return p2
			end

			return (Dash.join(p2, {
				lastNavigationDirection = "back",
				stack = Dash.slice(p2.stack, 1, #p2.stack - 1)
			}))
		elseif p3.type == "updateDataAndNavigateNext" then
			local last = Dash.last(p2.stack)

			if not last then
				error("Stack is empty, cannot update data")
			end

			if not (p3.payload.expectedFromNodeId == last.nodeId and p2.navigationState == "idle") then
				return p2
			end

			local joined = Dash.join(last, {
				store = Dash.join(last.store, p3.payload.store)
			})

			local values = Dash.slice(p2.stack, 1, #p2.stack - 1)
			table.insert(values, joined)
			return (Dash.join(p2, { stack = values, navigationState = "gotoNext" }))
		elseif p3.type == "navigateFailure" then
			local last = Dash.last(p2.stack)

			if not last then
				error("Stack is empty, cannot navigate after failure")
			end

			if p3.payload.expectedFromNodeId ~= last.nodeId then
				return p2
			end

			if p2.navigationState == "idle" then
				return (Dash.join(p2, { navigationState = "gotoFailure" }))
			end

			return p2
		else
			if p3.type == "startedSubmission" then
				return (Dash.join(p2, { submissionState = "submitting" }))
			end

			if p3.type == "completedSubmission" then
				return (Dash.join(p2, { submissionState = "completed" }))
			end

			if p3.type == "submissionFailed" then
				return (Dash.join(p2, { submissionState = "failed" }))
			end

			if p3.type == "reset" then
				return getInitialState(
					p3.payload.runId,
					p3.payload.initialEnterTime,
					p3.payload.startNodeId
				)
			end

			error("Unknown action type: " .. tostring(p3.type))

			return v5
		end
	end
}
