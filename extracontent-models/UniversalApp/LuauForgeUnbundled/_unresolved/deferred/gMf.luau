local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module2 = require("@luauforge/bundled/dFs")
local tutils = require(CorePackages.Packages.tutils)
local module3 = require("@luauforge/deferred/gMg")

local module4 = require("@luauforge/deferred/gMh")
local module5 = require("@luauforge/deferred/gMs")
require("@luauforge/deferred/gMj")
local module6 = require("@luauforge/deferred/gMk")
local module7 = require("@luauforge/deferred/gMu")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local uiConfiguration = require("@luauforge/deferred/gMv").UIConfiguration
local module8 = require("@luauforge/bundled/dFm")

local isShowEUDSAIllegalContentReportingLink = module3.isShowEUDSAIllegalContentReportingLink
local isInDSAFeaturesOverrideList = module3.isInDSAFeaturesOverrideList

local getFFlagLuafiedReportErrorStates = SharedFlags.GetFFlagLuafiedReportErrorStates
local getFFlagDSALuaGeoGateBEDUIDevMode = SharedFlags.GetFFlagDSALuaGeoGateBEDUIDevMode

local actionTypes = module7.ActionTypes

local v5 = {
	BEDUI_LOADING = "BEDUI_LOADING",
	BEDUI_ERROR = "BEDUI_ERROR",
	SUBMIT_LOADING = "SUBMIT_LOADING",
	SUBMIT_ERROR = "SUBMIT_ERROR",
	SUCCESS = "SUCCESS"
}

local function fn(reportEntryPoint)
	if
		reportEntryPoint == module6.REPORT_ENTRYPOINT.Profile
		or reportEntryPoint == module6.REPORT_ENTRYPOINT.Chat
	then
		return module6.BEDUI_FETCH_CONTEXT.Profile
	end

	if reportEntryPoint == module6.REPORT_ENTRYPOINT.ExperienceDetails then
		return module6.BEDUI_FETCH_CONTEXT.Experience
	end

	if reportEntryPoint == module6.REPORT_ENTRYPOINT.Item then
		return module6.BEDUI_FETCH_CONTEXT.Item
	end

	if reportEntryPoint == module6.REPORT_ENTRYPOINT.Notification then
		return module6.BEDUI_FETCH_CONTEXT.Notification
	end

	return ""
end

local v6 = uiConfiguration.new({
	enableLogging = false,
	maxRetryCount = 2,
	roduxKeyPath = "AbuseReporting"
})

local v7 = {
	BEDUILoading = false,
	BEDUIError = false,
	submitLoading = false,
	submitError = false,
	statusPrimaryText = "",
	statusSecondaryText = ""
}

local function fn2(p2, p3)
	if not getFFlagLuafiedReportErrorStates() then
		return p2
	end

	local clone = table.clone(v7)

	if p3.type == "BEDUI_LOADING" then
		clone.BEDUILoading = true
		return clone
	end

	if p3.type == "BEDUI_ERROR" then
		clone.BEDUIError = true
		clone.statusPrimaryText = module6.BEDUI_FETCH_FAILURE_PRIMARY
		clone.statusSecondaryText = module6.BEDUI_FETCH_FAILURE_SECONDARY
	else
		if p3.type == "SUBMIT_LOADING" then
			clone.submitLoading = true
			return clone
		end

		if p3.type == "SUBMIT_ERROR" then
			clone.submitError = true
			clone.statusPrimaryText = module6.REPORT_SUBMIT_FAILURE
		else
			if p3.type == "SUCCESS" then
				return clone
			end

			error("Unknown Action: " .. p3.type)
		end
	end

	return clone
end

return function(props)
	local v8 = useDispatch()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState({})

	local v9, v10 = React.useReducer(fn2, table.clone(v7))

	local reportEntryPoint = props.reportData.reportEntryPoint
	React.useEffect(function()
		v10({ type = "BEDUI_LOADING" })

		props.analyticsDispatch({
			type = actionTypes.SET_BASIC_INFO,
			dialogEntryPoint = reportEntryPoint,
			platform = props.reportSurface
		})

		local v11 = fn(reportEntryPoint)

		if v11 ~= "" then
			local v12 = module6.BEDUI_VERSIONS.V1

			if getFFlagDSALuaGeoGateBEDUIDevMode() then
				if isShowEUDSAIllegalContentReportingLink() then
					v12 = module6.BEDUI_VERSIONS.DEV
				end
			elseif isInDSAFeaturesOverrideList() then
				v12 = module6.BEDUI_VERSIONS.DEV
			end

			v8(v6:fetch(module6.BEDUI_BASE_URL, {
				version = v12,
				surface = props.reportSurface,
				context = v11,
				locale = props.locale
			})):andThen(function(p2)
				local responseBody = p2.responseBody

				if responseBody then
					setState(responseBody.components)
					setState2(responseBody.components.listSelection)
				end

				v10({ type = "SUCCESS" })
			end):catch(function(p2)
				module2("(Abuse Reporting [VR]) BEDUI fetch failed: " .. tutils.toString(p2))
				v10({ type = "BEDUI_ERROR" })
			end)
		end
	end, { reportEntryPoint, props.reportSurface, props.locale, v8 })

	local function onSelect(p2, p3, p4, p5)
		setState4(function(p6)
			local clone = table.clone(p6)
			table.insert(clone, state2)
			return clone
		end)

		setState3(function(p6)
			local clone = table.clone(p6)
			table.insert(clone, { tagValues = p2, heading = p3, humanReadableText = p4 })

			return clone
		end)

		setState2(p5)

		props.analyticsDispatch({ type = actionTypes.INCREMENT_SELECTION_ITEM })
	end

	local function onBack()
		if #state4 > 0 then
			setState2(state4[#state4])

			setState4(function(p2)
				local clone = table.clone(p2)
				table.remove(clone)
				return clone
			end)

			table.remove(state3)
			setState3(state3)

			props.analyticsDispatch({ type = actionTypes.INCREMENT_BACK_BUTTON_CLICK })
			v10({ type = "SUCCESS" })
		end
	end

	local function onSubmitReport()
		v10({ type = "SUBMIT_LOADING" })

		local url = state.submission.url

		if #state3 > 0 and url then
			v8(module5(state3, url, props.reportData, props.submissionEntryPoint)):andThen(function()
				if getFFlagLuafiedReportErrorStates() then
					v10({ type = "SUCCESS" })
					v8(module8(module6.SUCCESS_TOAST_DATA))
					module7.sendEventData(props.analyticsState, module6.ANALYTICS_EVENT_NAMES.SUBMITTED)
					props.onClose()
				end
			end):catch(function(p2)
				module2("(Abuse Reporting [VR]) Report submission failed" .. tutils.toString(p2))
				v10({ type = "SUBMIT_ERROR" })
			end):finally(function()
				if props.reportData and props.reportData.onSubmitReportCallback then
					props.reportData.onSubmitReportCallback()
				end
			end)

			if not getFFlagLuafiedReportErrorStates() then
				v8(module8(module6.SUCCESS_TOAST_DATA))
				module7.sendEventData(props.analyticsState, module6.ANALYTICS_EVENT_NAMES.SUBMITTED)
				props.onClose()
			end
		end
	end

	return React.createElement(module4, {
		currentList = state2,
		selectionData = state3,
		BEDUIComponents = state,
		reportData = props.reportData,
		reportSurface = props.reportSurface,
		prevListNodes = state4,
		analyticsDispatch = props.analyticsDispatch,
		onSelect = onSelect,
		onSubmitReport = onSubmitReport,
		onSummaryPageMounted = props.onSummaryPageMounted,
		onLogAbandon = props.onLogAbandon,
		onBack = onBack,
		onClose = props.onClose,
		loadingState = v9
	})
end
