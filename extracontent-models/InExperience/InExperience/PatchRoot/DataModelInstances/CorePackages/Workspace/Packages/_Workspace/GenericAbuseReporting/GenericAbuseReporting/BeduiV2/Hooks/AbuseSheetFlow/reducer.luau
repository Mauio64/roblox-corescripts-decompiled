local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Dash = require(GenericAbuseReportingParent.Dash)

require(script.Parent.AbuseSheetFlowTypes)

local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)

local function getInitialState(s1: string, n1: number, s2: string) -- line: 41
	-- upvalues: LocalPlayer (copy), FFlagAbuseReportMenuV2 (copy)
	return {
		navigationState = "idle",
		submissionState = "idle",
		pendingInlineAlert = nil,
		runId = s1,
		userId = not LocalPlayer and 0 or LocalPlayer.UserId,
		stack = {{
			nodeId = not FFlagAbuseReportMenuV2 and "root" or s2,
			data = {},
			context = {},
			store = {},
			enterTime = n1
		}},
		openTime = n1
	}
end

return {
	getInitialState = getInitialState,
	getNewRunId = function() -- line: 98
		-- upvalues: HttpService (copy)
		return HttpService:GenerateGUID(false)
	end,
	selectContext = function(t1: {[any]: any}) -- line: 102
		local t2 = {}

		for _, v16 in t1.stack do
			if v16.context then
				for v17, v18 in v16.context do
					t2[v17] = v18
				end
			end
		end

		return t2
	end,
	selectFormData = function(t3: {[any]: any}) -- line: 114
		local t4 = {}

		for _, v22 in t3.stack do
			if v22.data then
				for v23, v24 in v22.data do
					t4[v23] = v24
				end
			end
		end

		return t4
	end,
	selectStore = function(t5: {[any]: any}) -- line: 126
		local t6 = {}

		for _, v28 in t5.stack do
			if v28.store then
				for v29, v30 in v28.store do
					t6[v29] = v30
				end
			end
		end

		return t6
	end,
	reducer = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 138
		-- upvalues: Dash (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagAbuseReportConfigStoreResolver (copy), getInitialState (copy)
		local v33 = nil

		if t8.type == "gotoNode" then
			if not t8.payload or not t8.payload.nodeId then
				error(`gotoNode action requires payload.nodeId, got: { Dash.pretty(t8, {
					depth = 5
				}) }`)
			end

			local t9 = {
				nodeId = t8.payload.nodeId,
				data = {},
				context = {},
				store = {},
				enterTime = t8.payload.enterTime
			}
			local v35 = table.clone(t7.stack)

			table.insert(v35, t9)
			v33 = Dash.join(t7, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = v35
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v33.pendingInlineAlert = t8.payload.inlineAlert

				return v33
			end
		elseif t8.type == "replaceAndGotoNode" then
			local v36 = Dash.last(t7.stack)

			if not v36 then
				error("Stack is empty, cannot replace and go to node")
			end

			local v37 = Dash.slice(t7.stack, 1, #t7.stack - 1)

			table.insert(v37, {
				nodeId = t8.payload.nodeId,
				data = if FFlagAbuseReportConfigStoreResolver then {} else v36.data,
				context = if FFlagAbuseReportConfigStoreResolver then {} else v36.context,
				store = if not FFlagAbuseReportConfigStoreResolver then {} else v36.store,
				enterTime = t8.payload.enterTime
			})
			v33 = Dash.join(t7, {
				navigationState = "idle",
				lastNavigationDirection = "forward",
				stack = v37
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v33.pendingInlineAlert = t8.payload.inlineAlert

				return v33
			end
		elseif t8.type == "goBack" then
			if #t7.stack <= 1 then
				warn("Cannot go back from stack with only one or zero items")

				return t7
			end

			v33 = Dash.join(t7, {
				lastNavigationDirection = "back",
				stack = Dash.slice(t7.stack, 1, #t7.stack - 1)
			})

			if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
				v33.pendingInlineAlert = nil

				return v33
			end
		else
			if t8.type == "updateDataAndNavigateNext" then
				local v38 = Dash.last(t7.stack)

				if not v38 then
					error("Stack is empty, cannot update data")
				end

				if FFlagAbuseReportMenuV2 then
					if t8.payload.expectedFromNodeId and t8.payload.expectedFromNodeId ~= v38.nodeId then
						return t7
					end

					if t7.navigationState ~= "idle" then
						return t7
					end
				end

				local v39 = Dash.join(v38, {
					data = if FFlagAbuseReportConfigStoreResolver then {} else Dash.join(v38.data, t8.payload.data),
					context = if FFlagAbuseReportConfigStoreResolver then {} else Dash.join(v38.context, t8.payload.context),
					store = if not FFlagAbuseReportConfigStoreResolver then {} else Dash.join(v38.store, t8.payload.store)
				})
				local v40 = Dash.slice(t7.stack, 1, #t7.stack - 1)

				table.insert(v40, v39)

				return (Dash.join(t7, {
					navigationState = "gotoNext",
					stack = v40
				}))
			end

			if t8.type == "startedSubmission" then
				return (Dash.join(t7, {
					submissionState = "submitting"
				}))
			end

			if t8.type == "completedSubmission" then
				return (Dash.join(t7, {
					submissionState = "completed"
				}))
			end

			if t8.type == "submissionFailed" then
				return (Dash.join(t7, {
					submissionState = "failed"
				}))
			end

			if t8.type == "reset" then
				v33 = getInitialState(t8.payload.runId, t8.payload.initialEnterTime, t8.payload.startNodeId)

				if FFlagAbuseReportMenuV2 and not FFlagAbuseReportInlineAlertStateOutsideReducer then
					v33.pendingInlineAlert = t8.payload.inlineAlert

					return v33
				end
			elseif FFlagAbuseReportMenuV2 and t8.type == "clearInlineAlert" then
				v33 = table.clone(t7)

				if not FFlagAbuseReportInlineAlertStateOutsideReducer then
					v33.pendingInlineAlert = nil

					return v33
				end
			else
				error("Unknown action type: " .. tostring(t8.type))
			end
		end

		return v33
	end
}
