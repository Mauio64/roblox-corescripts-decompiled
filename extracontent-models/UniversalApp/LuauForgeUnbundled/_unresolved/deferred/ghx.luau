local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/ghy")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module3 = require("@luauforge/deferred/ghz")
local module4 = require("@luauforge/deferred/ghE")
require("@luauforge/deferred/ghD")
local module5 = require("@luauforge/deferred/ghO")

local getFFlagLuafiedReportFullFlow = SharedFlags.GetFFlagLuafiedReportFullFlow
local getFFlagVRAbuseReportLocales = SharedFlags.GetFFlagVRAbuseReportLocales

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module6 = require("@luauforge/deferred/gfc")
local module7 = require("@luauforge/bundled/dTM")

return (module6(function()
	local v5 = useNavigation()

	local v6, v7 = React.useReducer(module5.reportAnalyticsReducer, module5.EMPTY_LOGGING_STATE)

	local function onClose()
		module7.closeOverlay(v5)
	end

	local v8 = React.useCallback(function()
		module5.sendEventData(v6, module4.ANALYTICS_EVENT_NAMES.ABANDONED)
	end, { v7, v6 })

	local v9 = React.useCallback(function()
		v7({ type = module5.ActionTypes.SET_IS_SEEN_SUMMARY_PAGE })
	end, { v7, v6 })

	local param = v5.getParam("assetTypeName")
	local param2 = v5.getParam("itemId")
	local param3 = v5.getParam("itemCreatorName")
	local param4 = v5.getParam("itemName")

	local v10 = {
		reportEntryPoint = module4.REPORT_ENTRYPOINT.Item,
		assetTypeName = param,
		itemId = param2,
		itemName = param4,
		itemCreatorName = param3
	}

	if getFFlagLuafiedReportFullFlow() then
		return (React.createElement(module3, {
			reportData = v10,
			reportSurface = module4.BEDUI_SURFACES.VR,
			locale = not getFFlagVRAbuseReportLocales() and "en_us" or LocalizationService.RobloxLocaleId,
			submissionEntryPoint = module4.SAFETY_EVENT_SUBMISSION_ENTRY_POINT.VR,
			analyticsState = v6,
			analyticsDispatch = v7,
			onClose = onClose,
			onSummaryPageMounted = v9,
			onLogAbandon = v8
		}))
	end

	return (React.createElement(module, { onClose = onClose }))
end))
