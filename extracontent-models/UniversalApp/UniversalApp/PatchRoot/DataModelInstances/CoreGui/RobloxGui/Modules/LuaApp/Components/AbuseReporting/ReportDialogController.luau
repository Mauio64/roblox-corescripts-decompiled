local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local mutedError = require(Modules.LuaApp.mutedError)
local tutils = require(CorePackages.Packages.tutils)
local DsaIllegalContentReporting = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting)
local ReportDialogBody = require(Modules.LuaApp.Components.AbuseReporting.ReportDialogBody)
local submitAbuseReport = require(Modules.LuaApp.Components.AbuseReporting.submitAbuseReport)

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)
local ReportAnalytics = require(Modules.LuaApp.Components.AbuseReporting.ReportAnalytics)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local UIConfiguration = require(CorePackages.Workspace.Packages.ServerUI).UIConfiguration
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local isShowEUDSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowEUDSAIllegalContentReportingLink
local isInDSAFeaturesOverrideList = DsaIllegalContentReporting.isInDSAFeaturesOverrideList
local GetFFlagLuafiedReportErrorStates = SharedFlags.GetFFlagLuafiedReportErrorStates
local GetFFlagDSALuaGeoGateBEDUIDevMode = SharedFlags.GetFFlagDSALuaGeoGateBEDUIDevMode
local ActionTypes = ReportAnalytics.ActionTypes
local _ = {
	BEDUI_LOADING = "BEDUI_LOADING",
	BEDUI_ERROR = "BEDUI_ERROR",
	SUBMIT_LOADING = "SUBMIT_LOADING",
	SUBMIT_ERROR = "SUBMIT_ERROR",
	SUCCESS = "SUCCESS"
}

local function v21(s1: string) -- line: 50
	-- upvalues: Constants (copy)
	if s1 == Constants.REPORT_ENTRYPOINT.Profile or s1 == Constants.REPORT_ENTRYPOINT.Chat then
		return Constants.BEDUI_FETCH_CONTEXT.Profile
	end

	if s1 == Constants.REPORT_ENTRYPOINT.ExperienceDetails then
		return Constants.BEDUI_FETCH_CONTEXT.Experience
	end

	if s1 == Constants.REPORT_ENTRYPOINT.Item then
		return Constants.BEDUI_FETCH_CONTEXT.Item
	end

	if s1 == Constants.REPORT_ENTRYPOINT.Notification then
		return Constants.BEDUI_FETCH_CONTEXT.Notification
	end

	return ""
end

local v22 = UIConfiguration.new({
	enableLogging = false,
	maxRetryCount = 2,
	roduxKeyPath = "AbuseReporting"
})
local t1 = {
	BEDUILoading = false,
	BEDUIError = false,
	submitLoading = false,
	submitError = false,
	statusPrimaryText = "",
	statusSecondaryText = ""
}

local function v24(p1, t2: {[any]: any}) -- line: 81
	-- upvalues: GetFFlagLuafiedReportErrorStates (copy), t1 (copy), Constants (copy)
	if not GetFFlagLuafiedReportErrorStates() then
		return p1
	end

	local v28 = table.clone(t1)

	if t2.type == "BEDUI_LOADING" then
		v28.BEDUILoading = true

		return v28
	end

	if t2.type == "BEDUI_ERROR" then
		v28.BEDUIError = true
		v28.statusPrimaryText = Constants.BEDUI_FETCH_FAILURE_PRIMARY
		v28.statusSecondaryText = Constants.BEDUI_FETCH_FAILURE_SECONDARY

		return v28
	end

	if t2.type == "SUBMIT_LOADING" then
		v28.submitLoading = true

		return v28
	end

	if t2.type == "SUBMIT_ERROR" then
		v28.submitError = true
		v28.statusPrimaryText = Constants.REPORT_SUBMIT_FAILURE

		return v28
	end

	if t2.type == "SUCCESS" then
		return v28
	end

	error("Unknown Action: " .. t2.type)

	return v28
end

return function(t3: {[any]: any}) -- line: 108
	-- upvalues: useDispatch (copy), React (copy), v24 (copy), t1 (copy), ActionTypes (copy), v21 (copy), Constants (copy), GetFFlagDSALuaGeoGateBEDUIDevMode (copy), isShowEUDSAIllegalContentReportingLink (copy), isInDSAFeaturesOverrideList (copy), v22 (copy), mutedError (copy), tutils (copy), SetCurrentToastMessage (copy), ReportAnalytics (copy), submitAbuseReport (copy), GetFFlagLuafiedReportErrorStates (copy), ReportDialogBody (copy)
	local v30 = useDispatch()
	local v31, v32 = React.useState(nil)
	local v33, v34 = React.useState(nil)
	local v35, v36 = React.useState({})
	local v37, v38 = React.useState({})
	local v39, v40 = React.useReducer(v24, (table.clone(t1)))
	local reportEntryPoint = t3.reportData.reportEntryPoint

	React.useEffect(function() -- line: 120
		-- upvalues: v40 (copy), t3 (copy), ActionTypes (copy), reportEntryPoint (copy), v21 (copy), Constants (copy), GetFFlagDSALuaGeoGateBEDUIDevMode (copy), isShowEUDSAIllegalContentReportingLink (copy), isInDSAFeaturesOverrideList (copy), v30 (copy), v22 (copy), v32 (copy), v34 (copy), mutedError (copy), tutils (copy)
		v40({
			type = "BEDUI_LOADING"
		})
		t3.analyticsDispatch({
			type = ActionTypes.SET_BASIC_INFO,
			dialogEntryPoint = reportEntryPoint,
			platform = t3.reportSurface
		})

		local v42 = v21(reportEntryPoint)

		if v42 ~= "" then
			local V1 = Constants.BEDUI_VERSIONS.V1

			if GetFFlagDSALuaGeoGateBEDUIDevMode() then
				if isShowEUDSAIllegalContentReportingLink() then
					V1 = Constants.BEDUI_VERSIONS.DEV
				end
			elseif isInDSAFeaturesOverrideList() then
				V1 = Constants.BEDUI_VERSIONS.DEV
			end

			v30(v22:fetch(Constants.BEDUI_BASE_URL, {
				version = V1,
				surface = t3.reportSurface,
				context = v42,
				locale = t3.locale
			})):andThen(function(p2) -- line: 152
				-- upvalues: v32 (copy), v34 (copy), v40 (copy)
				local responseBody = p2.responseBody

				if responseBody then
					v32(responseBody.components)
					v34(responseBody.components.listSelection)
				end

				v40({
					type = "SUCCESS"
				})
			end):catch(function(p3) -- line: 160
				-- upvalues: mutedError (copy), tutils (copy), v40 (copy)
				mutedError("(Abuse Reporting [VR]) BEDUI fetch failed: " .. tutils.toString(p3))
				v40({
					type = "BEDUI_ERROR"
				})
			end)
		end
	end, {
		reportEntryPoint,
		t3.reportSurface,
		t3.locale,
		v30
	})

	return React.createElement(ReportDialogBody, {
		currentList = v33,
		selectionData = v35,
		BEDUIComponents = v31,
		reportData = t3.reportData,
		reportSurface = t3.reportSurface,
		prevListNodes = v37,
		analyticsDispatch = t3.analyticsDispatch,
		onSelect = function(t4: {[any]: any}, s2: string, s3: string, p4) -- line: 174
			-- upvalues: v38 (copy), v33 (copy), v36 (copy), v34 (copy), t3 (copy), ActionTypes (copy)
			v38(function(p5) -- line: 180
				-- upvalues: v33 (copy)
				local v53 = table.clone(p5)

				table.insert(v53, v33)

				return v53
			end)
			v36(function(p6) -- line: 185
				-- upvalues: t4 (copy), s2 (copy), s3 (copy)
				local v55 = table.clone(p6)

				table.insert(v55, {
					tagValues = t4,
					heading = s2,
					humanReadableText = s3
				})

				return v55
			end)
			v34(p4)
			t3.analyticsDispatch({
				type = ActionTypes.INCREMENT_SELECTION_ITEM
			})
		end,
		onSubmitReport = function() -- line: 218
			-- upvalues: v30 (copy), SetCurrentToastMessage (copy), Constants (copy), ReportAnalytics (copy), t3 (copy), v40 (copy), v31 (copy), v35 (copy), submitAbuseReport (copy), GetFFlagLuafiedReportErrorStates (copy), mutedError (copy), tutils (copy)
			v40({
				type = "SUBMIT_LOADING"
			})

			local url = v31.submission.url

			if #v35 > 0 and url then
				v30(submitAbuseReport(v35, url, t3.reportData, t3.submissionEntryPoint)):andThen(function() -- line: 231
					-- upvalues: GetFFlagLuafiedReportErrorStates (copy), v40 (copy), v30 (copy), SetCurrentToastMessage (copy), Constants (copy), ReportAnalytics (copy), t3 (copy)
					if GetFFlagLuafiedReportErrorStates() then
						v40({
							type = "SUCCESS"
						})
						v30(SetCurrentToastMessage(Constants.SUCCESS_TOAST_DATA))
						ReportAnalytics.sendEventData(t3.analyticsState, Constants.ANALYTICS_EVENT_NAMES.SUBMITTED)
						t3.onClose()
					end
				end):catch(function(p7) -- line: 237
					-- upvalues: mutedError (copy), tutils (copy), v40 (copy)
					mutedError("(Abuse Reporting [VR]) Report submission failed" .. tutils.toString(p7))
					v40({
						type = "SUBMIT_ERROR"
					})
				end):finally(function() -- line: 241
					-- upvalues: t3 (copy)
					if t3.reportData and t3.reportData.onSubmitReportCallback then
						t3.reportData.onSubmitReportCallback()
					end
				end)

				if not GetFFlagLuafiedReportErrorStates() then
					v30(SetCurrentToastMessage(Constants.SUCCESS_TOAST_DATA))
					ReportAnalytics.sendEventData(t3.analyticsState, Constants.ANALYTICS_EVENT_NAMES.SUBMITTED)
					t3.onClose()
				end
			end
		end,
		onSummaryPageMounted = t3.onSummaryPageMounted,
		onLogAbandon = t3.onLogAbandon,
		onBack = function() -- line: 200
			-- upvalues: v37 (copy), v34 (copy), v38 (copy), v35 (copy), v36 (copy), t3 (copy), ActionTypes (copy), v40 (copy)
			if #v37 > 0 then
				v34(v37[#v37])
				v38(function(p8) -- line: 204
					local v57 = table.clone(p8)

					table.remove(v57)

					return v57
				end)
				table.remove(v35)
				v36(v35)
				t3.analyticsDispatch({
					type = ActionTypes.INCREMENT_BACK_BUTTON_CLICK
				})
				v40({
					type = "SUCCESS"
				})
			end
		end,
		onClose = t3.onClose,
		loadingState = v39
	})
end
