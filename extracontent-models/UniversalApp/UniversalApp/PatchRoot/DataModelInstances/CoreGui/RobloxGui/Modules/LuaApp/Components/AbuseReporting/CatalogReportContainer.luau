local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)
local ReportComingSoonPrompt = require(Modules.LuaApp.Components.AbuseReporting.ReportComingSoonPrompt)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local ReportDialogController = require(Modules.LuaApp.Components.AbuseReporting.ReportDialogController)
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local ReportAnalytics = require(Modules.LuaApp.Components.AbuseReporting.ReportAnalytics)
local GetFFlagLuafiedReportFullFlow = SharedFlags.GetFFlagLuafiedReportFullFlow
local GetFFlagVRAbuseReportLocales = SharedFlags.GetFFlagVRAbuseReportLocales
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

return (withOverlayFocusHandling(function() -- line: 20
	-- upvalues: useNavigation (copy), React (copy), ReportAnalytics (copy), NavigationUtils (copy), Constants (copy), GetFFlagLuafiedReportFullFlow (copy), ReportDialogController (copy), GetFFlagVRAbuseReportLocales (copy), LocalizationService (copy), ReportComingSoonPrompt (copy)
	local v15 = useNavigation()
	local v16, v17 = React.useReducer(ReportAnalytics.reportAnalyticsReducer, ReportAnalytics.EMPTY_LOGGING_STATE)

	local function v18() -- line: 25
		-- upvalues: NavigationUtils (copy), v15 (copy)
		NavigationUtils.closeOverlay(v15)
	end

	local v19 = React.useCallback(function() -- line: 29
		-- upvalues: ReportAnalytics (copy), v16 (copy), Constants (copy)
		ReportAnalytics.sendEventData(v16, Constants.ANALYTICS_EVENT_NAMES.ABANDONED)
	end, {
		v17,
		v16
	})
	local v20 = React.useCallback(function() -- line: 33
		-- upvalues: v17 (copy), ReportAnalytics (copy)
		v17({
			type = ReportAnalytics.ActionTypes.SET_IS_SEEN_SUMMARY_PAGE
		})
	end, {
		v17,
		v16
	})
	local v21 = v15.getParam("assetTypeName")
	local v22 = v15.getParam("itemId")
	local v23 = v15.getParam("itemCreatorName")
	local v24 = v15.getParam("itemName")
	local t1 = {
		reportEntryPoint = Constants.REPORT_ENTRYPOINT.Item,
		assetTypeName = v21,
		itemId = v22,
		itemName = v24,
		itemCreatorName = v23
	}

	if GetFFlagLuafiedReportFullFlow() then
		return (React.createElement(ReportDialogController, {
			reportData = t1,
			reportSurface = Constants.BEDUI_SURFACES.VR,
			locale = not GetFFlagVRAbuseReportLocales() and "en_us" or LocalizationService.RobloxLocaleId,
			submissionEntryPoint = Constants.SAFETY_EVENT_SUBMISSION_ENTRY_POINT.VR,
			analyticsState = v16,
			analyticsDispatch = v17,
			onClose = v18,
			onSummaryPageMounted = v20,
			onLogAbandon = v19
		}))
	end

	return (React.createElement(ReportComingSoonPrompt, {
		onClose = v18
	}))
end))
