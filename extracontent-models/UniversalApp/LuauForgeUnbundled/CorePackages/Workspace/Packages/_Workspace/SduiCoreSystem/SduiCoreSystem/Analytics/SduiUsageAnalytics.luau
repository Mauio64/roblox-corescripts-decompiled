local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "sdui_type_usage",
	description = "Per-page-load delta of SDUI component types and action types observed for a given (page, version). `components` and `actions` are comma-joined strings convertible to `repeated string` server-side.",
	lastUpdated = { 26, 4, 24 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = 10000
}

local v6 = {
	eventName = "sdui_param_usage",
	description = "Per-page-load delta of SDUI component-prop and action-param names observed for a given (page, version). `props` and `actionParams` are comma-joined strings convertible to `repeated string` server-side; each entry is shaped `componentType.propName` or `actionType.paramName`.",
	lastUpdated = { 26, 4, 24 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = 10000
}

local function joinSet(items)
	local v7 = {}

	for k, item in items do
		table.insert(v7, k)
	end

	table.sort(v7)
	return table.concat(v7, ",")
end

return {
	sendTypeUsageEvent = function(data)
		TelemetryService:LogEvent(v5, {
			customFields = {
				page = data.page,
				version = data.version,
				components = joinSet(data.componentTypes),
				actions = joinSet(data.actionTypes)
			},
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendParamUsageEvent = function(data)
		TelemetryService:LogEvent(v6, {
			customFields = {
				page = data.page,
				version = data.version,
				props = joinSet(data.props),
				actionParams = joinSet(data.actionParams)
			},
			standardizedFields = { "addOSInfo" }
		})
	end
}
