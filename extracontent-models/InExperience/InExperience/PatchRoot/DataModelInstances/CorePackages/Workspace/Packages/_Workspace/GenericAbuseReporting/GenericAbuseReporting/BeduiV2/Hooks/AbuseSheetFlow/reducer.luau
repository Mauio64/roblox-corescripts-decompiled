local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Dash = require(GenericAbuseReportingParent.Dash)

require(script.Parent.AbuseSheetFlowTypes)

local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)

local function getInitialState(s1: string, n1: number, s2: string) -- line: 36
	-- upvalues: LocalPlayer (copy), FFlagAbuseReportMenuV2 (copy)
	return {
		navigationState = "idle",
		submissionState = "idle",
		pendingInlineAlert = nil,
		runId = s1,
		userId = not LocalPlayer and 0 or LocalPlayer.UserId,
		stack = {{
			nodeId = not FFlagAbuseReportMenuV2 and "root" or s2,
			store = {},
			enterTime = n1
		}},
		openTime = n1
	}
end

return {
	getInitialState = getInitialState,
	getNewRunId = function() -- line: 89
		-- upvalues: HttpService (copy)
		return HttpService:GenerateGUID(false)
	end,
	selectStore = function(t1: {[any]: any}) -- line: 93
		local t2 = {}

		for _, v15 in t1.stack do
			if v15.store then
				for v16, v17 in v15.store do
					t2[v16] = v17
				end
			end
		end

		return t2
	end,
	reducer = function(t3: {[any]: any}, t4: {[any]: any}) -- line: 105
		-- upvalues: Dash (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), getInitialState (copy)
		local v20 = nil

		if t4.type == "gotoNode" then
			if not t4.payload or not t4.payload.nodeId then
				error(`gotoNode action requires payload.nodeId, got: { Dash.pretty(t4, {
					depth = 5
				}) }`)
			end

			local t5 = {
				nodeId = t4.payload.nodeId,
				store = {},
				enterTime = t4.payload.enterTime
			}
			local v22 = table.clone(t3.stack)

			table.insert(v22, t5)
			v20 = Dash.join(t3, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = v22
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v20.pendingInlineAlert = t4.payload.inlineAlert

				return v20
			end
		elseif t4.type == "replaceAndGotoNode" then
			local v23 = Dash.last(t3.stack)

			if not v23 then
				error("Stack is empty, cannot replace and go to node")
			end

			local v24 = Dash.slice(t3.stack, 1, #t3.stack - 1)

			table.insert(v24, {
				nodeId = t4.payload.nodeId,
				store = v23.store,
				enterTime = t4.payload.enterTime
			})
			v20 = Dash.join(t3, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = v24
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v20.pendingInlineAlert = t4.payload.inlineAlert

				return v20
			end
		elseif t4.type == "goBack" then
			if #t3.stack <= 1 then
				warn("Cannot go back from stack with only one or zero items")

				return t3
			end

			v20 = Dash.join(t3, {
				lastNavigationDirection = "back",
				stack = Dash.slice(t3.stack, 1, #t3.stack - 1)
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v20.pendingInlineAlert = nil

				return v20
			end
		else
			if t4.type == "updateDataAndNavigateNext" then
				local v25 = Dash.last(t3.stack)

				if not v25 then
					error("Stack is empty, cannot update data")
				end

				if FFlagAbuseReportMenuV2 then
					if t4.payload.expectedFromNodeId and t4.payload.expectedFromNodeId ~= v25.nodeId then
						return t3
					end

					if t3.navigationState ~= "idle" then
						return t3
					end
				end

				local v26 = Dash.join(v25, {
					store = Dash.join(v25.store, t4.payload.store)
				})
				local v27 = Dash.slice(t3.stack, 1, #t3.stack - 1)

				table.insert(v27, v26)

				return (Dash.join(t3, {
					navigationState = "gotoNext",
					stack = v27
				}))
			end

			if t4.type == "startedSubmission" then
				return (Dash.join(t3, {
					submissionState = "submitting"
				}))
			end

			if t4.type == "completedSubmission" then
				return (Dash.join(t3, {
					submissionState = "completed"
				}))
			end

			if t4.type == "submissionFailed" then
				return (Dash.join(t3, {
					submissionState = "failed"
				}))
			end

			if t4.type == "reset" then
				v20 = getInitialState(t4.payload.runId, t4.payload.initialEnterTime, t4.payload.startNodeId)

				if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
					v20.pendingInlineAlert = t4.payload.inlineAlert

					return v20
				end
			elseif FFlagAbuseReportMenuV2 and t4.type == "clearInlineAlert" then
				v20 = table.clone(t3)

				if not FFlagAbuseReportInlineAlertStateOutsideReducer then
					v20.pendingInlineAlert = nil

					return v20
				end
			else
				error("Unknown action type: " .. tostring(t4.type))
			end
		end

		return v20
	end
}
