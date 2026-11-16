local HttpService = game:GetService("HttpService")

local defineFastString = game:DefineFastString("MrRouterEnvName", "")

local v5 = {}

function v5.generateTraceparent()
	local lower = HttpService:GenerateGUID(false):gsub("-", ""):lower()
	local lower2 = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 16):lower()
	return string.format("00-%s-%s-01", lower, lower2)
end

function v5.mergeMrRouterInTracestate(value, p2)
	local v6 = "mrrouter-env=" .. p2

	local v7 = {}

	if value and #value > 0 then
		for k in value:gmatch(" *([^,]+)") do
			table.insert(v7, k)
		end
	end

	local function isMrRouterEntry(value2): boolean
		return value2:sub(1, 13) == "mrrouter-env="
	end

	local v8 = nil

	for i, v10 in ipairs(v7) do
		if v10:sub(1, 13) == "mrrouter-env=" then
			v8 = i
			break
		end
	end

	if v8 == nil then
		table.insert(v7, v6)
		return table.concat(v7, ",")
	end

	local v10 = {}

	for i, v11 in ipairs(v7) do
		if v11:sub(1, 13) ~= "mrrouter-env=" then
			table.insert(v10, v11)
		end
	end

	table.insert(v10, v8, v6)
	return table.concat(v10, ",")
end

function v5.injectMrRouterHeaders(p2)
	if #defineFastString == 0 then
		return p2
	end

	local v6 = not p2 and {} or table.clone(p2)

	if not v6.Traceparent then
		v6.Traceparent = v5.generateTraceparent()
	end

	v6.Tracestate = v5.mergeMrRouterInTracestate(v6.Tracestate, defineFastString)
	return v6
end

return v5
