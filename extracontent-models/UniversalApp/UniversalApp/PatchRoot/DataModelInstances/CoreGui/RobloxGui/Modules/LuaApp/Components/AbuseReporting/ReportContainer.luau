local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)
local ReportComingSoonPrompt = require(Modules.LuaApp.Components.AbuseReporting.ReportComingSoonPrompt)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local ReportDialogController = require(Modules.LuaApp.Components.AbuseReporting.ReportDialogController)

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)
local ReportAnalytics = require(Modules.LuaApp.Components.AbuseReporting.ReportAnalytics)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local GetFFlagLuafiedReportFullFlow = SharedFlags.GetFFlagLuafiedReportFullFlow
local GetFFlagVRAbuseReportLocales = SharedFlags.GetFFlagVRAbuseReportLocales
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch

return function() -- line: 21
	-- upvalues: useDispatch (copy), useNavigation (copy), React (copy), ReportAnalytics (copy), NavigateBack (copy), Constants (copy), GetFFlagLuafiedReportFullFlow (copy), ReportDialogController (copy), GetFFlagVRAbuseReportLocales (copy), LocalizationService (copy), ReportComingSoonPrompt (copy)
	local v15 = useDispatch()
	local v16 = useNavigation()
	local v17, v18 = React.useReducer(ReportAnalytics.reportAnalyticsReducer, ReportAnalytics.EMPTY_LOGGING_STATE)
	local v19 = v16.getParam("reportData")

	local function v20() -- line: 29
		-- upvalues: v19 (copy), v15 (copy), NavigateBack (copy)
		if v19 and v19.onCloseCallback then
			v19.onCloseCallback()
		end

		v15(NavigateBack())
	end

	local v21 = React.useCallback(function() -- line: 37
		-- upvalues: ReportAnalytics (copy), v17 (copy), Constants (copy)
		ReportAnalytics.sendEventData(v17, Constants.ANALYTICS_EVENT_NAMES.ABANDONED)
	end, {
		v18,
		v17
	})
	local v22 = React.useCallback(function() -- line: 41
		-- upvalues: v18 (copy), ReportAnalytics (copy)
		v18({
			type = ReportAnalytics.ActionTypes.SET_IS_SEEN_SUMMARY_PAGE
		})
	end, {
		v18,
		v17
	})

	if GetFFlagLuafiedReportFullFlow() or v19 and v19.reportEntryPoint == "Notification" then
		return (React.createElement(ReportDialogController, {
			reportSurface = if not v19 or not v19.reportSurface then Constants.BEDUI_SURFACES.VR else v19.reportSurface,
			locale = not GetFFlagVRAbuseReportLocales() and "en_us" or LocalizationService.RobloxLocaleId,
			reportData = v19,
			submissionEntryPoint = if not v19 or not v19.submissionEntryPoint then Constants.SAFETY_EVENT_SUBMISSION_ENTRY_POINT.VR else v19.submissionEntryPoint,
			analyticsState = v17,
			analyticsDispatch = v18,
			onClose = v20,
			onSummaryPageMounted = v22,
			onLogAbandon = v21
		}))
	end

	return (React.createElement(ReportComingSoonPrompt, {
		onClose = v20
	}))
end
