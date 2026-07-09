local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local t1 = {}

local function mapValues(p1, p2) -- line: 12
	local t2 = {}

	for k, v in pairs(p1) do
		t2[k] = p2(v, k)
	end

	return t2
end
local function transformInput(p3, p4) -- line: 20
	-- upvalues: mapValues (copy)
	if type(p4._collectionFormat) ~= "table" then
		return p3
	end

	return (mapValues(p3, function(p5, p6) -- line: 24
		-- upvalues: p4 (copy)
		if p4._collectionFormat[p6] == "csv" then
			return table.concat(p5, ",")
		end

		return p5
	end))
end
local function getBody(p7, p8) -- line: 33
	-- upvalues: HttpService (copy)
	local t3

	if type(p8) == "table" then
		t3 = {}

		for _, v in ipairs(p8) do
			t3[v] = p7[v]

			if t3[v] == nil then
				t3[v] = "##NULL##TOKEN##"
			end
		end
	else
		if type(p8) ~= "string" then
			return nil
		end

		t3 = p7[p8]
	end

	local json = HttpService:JSONEncode(t3)

	return (string.gsub(json, "\"##NULL##TOKEN##\"", "null"))
end

function t1.endpoint(p9, p10) -- line: 55
	-- upvalues: ArgCheck (copy), mapValues (copy), UrlBuilder (copy), getBody (copy)
	return function(p11, p12) -- line: 56
		-- upvalues: ArgCheck (copy), p9 (copy), p10 (copy), mapValues (copy), UrlBuilder (copy), getBody (copy)
		ArgCheck.matchesInterface(p12, p9.input, "input", p10)

		local input = p9.input
		local v31 = if type(input._collectionFormat) == "table" then mapValues(p12, function(p13, p14) -- line: 24
			-- upvalues: input (copy)
			if input._collectionFormat[p14] == "csv" then
				return table.concat(p13, ",")
			end

			return p13
		end) else p12
		local v32 = UrlBuilder.fromString(p9.url)(v31)
		local t4 = {}

		if p9.body then
			t4.postBody = getBody(v31, p9.body)
		end

		return p11(v32, p9.method, t4):andThen(function(p15) -- line: 64
			-- upvalues: ArgCheck (copy), p9 (copy), p10 (copy)
			ArgCheck.matchesInterface(p15.responseBody, p9.output, "output", p10)

			return p15
		end)
	end
end
function t1.new(p16) -- line: 71
	-- upvalues: mapValues (copy), t1 (copy)
	local definitions = p16.definitions

	return (mapValues(p16.endpoints, function(p17) -- line: 74
		-- upvalues: t1 (copy), definitions (copy)
		return t1.endpoint(p17, definitions)
	end))
end

return t1
