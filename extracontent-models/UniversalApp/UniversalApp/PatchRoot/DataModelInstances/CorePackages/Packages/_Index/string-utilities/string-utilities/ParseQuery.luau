local RunService = game:GetService("RunService")
local StringSplit = require(script.Parent.StringSplit)

function assertIsType(p1, p2, p3) -- line: 5
	-- upvalues: RunService (copy)
	if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ then
		assert(p2 == typeof(p1), string.format("expects %s to be a %s! it was: %s", p3, p2, (typeof(p1))))
	end
end

local function urlDecode(p4) -- line: 14
	assertIsType(p4, "string", "input")

	local v9 = string.gsub(p4, "%%(%x%x)", function(p5) -- line: 16
		return (string.char((tonumber(p5, 16))))
	end)

	return (string.gsub(v9, "+", " "))
end
local function ParseQuery(p6, p7) -- line: 36
	-- upvalues: StringSplit (copy), urlDecode (copy)
	if p6 ~= nil then
		assertIsType(p6, "string", "input")
	end

	if p7 ~= nil then
		assertIsType(p7, "function", "listKeyMapper")
	end

	local v12 = type(p7) == "function"
	local t1 = {}

	if p6 and #p6 > 0 then
		local v14 = StringSplit(p6, "[&;]")

		for _, v in ipairs(v14) do
			if v and #v > 0 then
				local v17, v18 = unpack(string.split(v, "="))

				if v18 == nil then
					v18 = ""
				end

				local v19 = urlDecode(v17)
				local v20 = urlDecode(v18)

				if v12 then
					if t1[v19] ~= nil then
						local v21 = p7(v19)

						if v21 == nil then
							v21 = v19
						end

						if type(t1[v21]) ~= "table" then
							t1[v21] = { t1[v19] }
						end

						table.insert(t1[v21], v20)

						if v19 ~= v21 then
							t1[v19] = v20
						end
					else
						t1[v19] = v20
					end
				else
					if t1[v19] == nil then
						t1[v19] = {}
					end

					table.insert(t1[v19], v20)
				end
			end
		end
	end

	return t1
end

return ParseQuery
