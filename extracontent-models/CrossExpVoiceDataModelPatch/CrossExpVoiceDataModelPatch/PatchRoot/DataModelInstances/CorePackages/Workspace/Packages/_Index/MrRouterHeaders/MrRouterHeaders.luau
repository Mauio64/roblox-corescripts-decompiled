local HttpService = game:GetService("HttpService")

local defineFastString = game:DefineFastString("MrRouterEnvName", "")

local MrRouterHeaders = {}

function MrRouterHeaders.generateTraceparent()
	local lower = HttpService:GenerateGUID(false):gsub("-", ""):lower()
	local lower2 = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 16):lower()
	return string.format("00-%s-%s-01", lower, lower2)
end

function MrRouterHeaders.mergeMrRouterInTracestate(value: string?, p: string)
	local v = "mrrouter-env=" .. p

	local v2 = {}

	if value and #value > 0 then
		for k in value:gmatch(" *([^,]+)") do
			table.insert(v2, k)
		end
	end

	local function isMrRouterEntry(value2: string): boolean -- 2 equivalent calls inferred from this helper
		return value2:sub(1, 13) == "mrrouter-env="
	end

	local v3 = nil

	for i, v4 in ipairs(v2) do
		if isMrRouterEntry(v4) then -- inferred equivalent call
			v3 = i
			break
		end
	end

	if v3 == nil then
		table.insert(v2, v)
		return table.concat(v2, ",")
	end

	local v4 = {}

	for _, v5 in ipairs(v2) do
		if not isMrRouterEntry(v5) then -- inferred equivalent call
			table.insert(v4, v5)
		end
	end

	table.insert(v4, v3, v)
	return table.concat(v4, ",")
end

function MrRouterHeaders.injectMrRouterHeaders(p)
	if #defineFastString == 0 then
		return p
	end

	local v = not p and {} or table.clone(p)

	if not v.Traceparent then
		v.Traceparent = MrRouterHeaders.generateTraceparent()
	end

	v.Tracestate = MrRouterHeaders.mergeMrRouterInTracestate(v.Tracestate, defineFastString)
	return v
end

MrRouterHeaders["jest.config"] = script["jest.config"]

return MrRouterHeaders
