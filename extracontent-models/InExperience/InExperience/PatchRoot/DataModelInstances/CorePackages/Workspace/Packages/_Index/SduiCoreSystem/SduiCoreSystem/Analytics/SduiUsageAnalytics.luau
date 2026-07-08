local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	eventName = "sdui_type_usage",
	description = "Per-page-load delta of SDUI component types and action types observed for a given (page, version). `components` and `actions` are comma-joined strings convertible to `repeated string` server-side.",
	throttlingPercentage = 10000,
	lastUpdated = {
		26,
		4,
		24
	},
	backends = {
		"Points",
		"EventIngest"
	}
}
local t2 = {
	eventName = "sdui_param_usage",
	description = "Per-page-load delta of SDUI component-prop and action-param names observed for a given (page, version). `props` and `actionParams` are comma-joined strings convertible to `repeated string` server-side; each entry is shaped `componentType.propName` or `actionType.paramName`.",
	throttlingPercentage = 10000,
	lastUpdated = {
		26,
		4,
		24
	},
	backends = {
		"Points",
		"EventIngest"
	}
}

local function joinSet(t3: {[any]: any}) -- line: 40
	local t4 = {}

	for v7, _ in t3 do
		table.insert(t4, v7)
	end

	table.sort(t4)

	return table.concat(t4, ",")
end

return {
	sendTypeUsageEvent = function(t5: {[any]: any}) -- line: 63
		-- upvalues: TelemetryService (copy), t1 (copy), joinSet (copy)
		TelemetryService:LogEvent(t1, {
			customFields = {
				page = t5.page,
				version = t5.version,
				components = joinSet(t5.componentTypes),
				actions = joinSet(t5.actionTypes)
			},
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendParamUsageEvent = function(t6: {[any]: any}) -- line: 75
		-- upvalues: TelemetryService (copy), t2 (copy), joinSet (copy)
		TelemetryService:LogEvent(t2, {
			customFields = {
				page = t6.page,
				version = t6.version,
				props = joinSet(t6.props),
				actionParams = joinSet(t6.actionParams)
			},
			standardizedFields = { "addOSInfo" }
		})
	end
}
