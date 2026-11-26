require("@luauforge/bundled/igt")
require("@luauforge/bundled/igz")

local v5 = {}

local v6 = {
	debug = true,
	error = true,
	navigation = true,
	http = true,
	query = true,
	transaction = true,
	ui = true,
	user = true
}

local function toBreadcrumbType(p2)
	if p2 and v6[p2] then
		return p2
	end

	return "default"
end

local function toSeconds(p2)
	if p2 then
		return (math.floor(p2 / 1000))
	end

	return nil
end

function v5.fromSpan(data)
	local log_type = data.log_type
	local v7 = {
		type = not (log_type and v6[log_type]) and "default" or log_type,
		category = data.category,
		message = data.message,
		data = data.extra_metadata,
		level = data.level or "info",
		timestamp = 0
	}
	local start_timestamp = data.start_timestamp
	local v8 = if start_timestamp then math.floor(start_timestamp / 1000) else nil

	v7.timestamp = v8
	return v7
end

function v5.fromSpans(items)
	local result = {}

	for k, item in items do
		table.insert(result, v5.fromSpan(item))
	end

	return result
end

return v5
