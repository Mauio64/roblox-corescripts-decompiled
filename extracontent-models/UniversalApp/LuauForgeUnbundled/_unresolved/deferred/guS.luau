local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/ghy")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module3 = require("@luauforge/deferred/ghz")
require("@luauforge/deferred/ghD")
local module4 = require("@luauforge/deferred/ghE")
local module5 = require("@luauforge/deferred/ghO")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local getFFlagLuafiedReportFullFlow = SharedFlags.GetFFlagLuafiedReportFullFlow
local getFFlagVRAbuseReportLocales = SharedFlags.GetFFlagVRAbuseReportLocales

local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

return function()
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7, v8 = React.useReducer(module5.reportAnalyticsReducer, module5.EMPTY_LOGGING_STATE)

	local param = v6.getParam("reportData")

	local function onClose()
		if param and param.onCloseCallback then
			param.onCloseCallback()
		end

		v5(RobloxAppToastsRodux())
	end

	local v9 = React.useCallback(function()
		module5.sendEventData(v7, module4.ANALYTICS_EVENT_NAMES.ABANDONED)
	end, { v8, v7 })

	local v10 = React.useCallback(function()
		v8({ type = module5.ActionTypes.SET_IS_SEEN_SUMMARY_PAGE })
	end, { v8, v7 })

	if not getFFlagLuafiedReportFullFlow() and (not param or param.reportEntryPoint ~= "Notification") then
		return (React.createElement(module, { onClose = onClose }))
	end

	local createElement = React.createElement
	local v13 = if param and param.reportSurface then param.reportSurface else module4.BEDUI_SURFACES.VR
	local v12 = {
		reportSurface = v13,
		locale = not getFFlagVRAbuseReportLocales() and "en_us" or LocalizationService.RobloxLocaleId,
		reportData = param,
		submissionEntryPoint = 0,
		analyticsState = 0,
		analyticsDispatch = 0,
		onClose = 0,
		onSummaryPageMounted = 0,
		onLogAbandon = 0
	}

	local v14 = if param and param.submissionEntryPoint then param.submissionEntryPoint else module4.SAFETY_EVENT_SUBMISSION_ENTRY_POINT.VR
	v12.submissionEntryPoint = v14

	v12.analyticsState = v7
	v12.analyticsDispatch = v8
	v12.onClose = onClose
	v12.onSummaryPageMounted = v10
	v12.onLogAbandon = v9
	return (createElement(module3, v12))
end
