local RunService = game:GetService("RunService")
local StringSplit = require(script.Parent.StringSplit)

function assertIsType(p, p2, p3)
	if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ then
		assert(typeof(p) == p2, string.format("expects %s to be a %s! it was: %s", p3, p2, (typeof(p))))
	end
end

local function urlDecode(value)
	assertIsType(value, "string", "input")
	local v = string.gsub(value, "%%(%x%x)", function(p)
		return (string.char((tonumber(p, 16))))
	end)

	return (string.gsub(v, "+", " "))
end

local function ParseQuery(list, callback)
	if list ~= nil then
		assertIsType(list, "string", "input")
	end

	if callback ~= nil then
		assertIsType(callback, "function", "listKeyMapper")
	end

	local v = type(callback) == "function"
	local query = {}

	if not (list and #list > 0) then
		return query
	end

	local stringSplit = StringSplit(list, "[&;]")

	for _, v2 in ipairs(stringSplit) do
		if not (v2 and #v2 > 0) then
			continue
		end

		local v3, v4 = unpack(string.split(v2, "="))
		local v5 = v4 == nil and "" or v4

		local v6 = urlDecode(v3)
		local v7 = urlDecode(v5)

		if v then
			if query[v6] == nil then
				query[v6] = v7
			else
				local v8 = callback(v6)

				if v8 == nil then
					v8 = v6
				end

				if type(query[v8]) ~= "table" then
					query[v8] = { query[v6] }
				end

				table.insert(query[v8], v7)

				if v6 ~= v8 then
					query[v6] = v7
				end
			end
		else
			if query[v6] == nil then
				query[v6] = {}
			end

			table.insert(query[v6], v7)
		end
	end

	return query
end

return ParseQuery
