local function template(s1: string, t1: {[any]: any}) -- line: 7
	return (s1:gsub("{(.-)}", function(p1) -- line: 8
		-- upvalues: t1 (copy)
		return (tostring(t1[p1] or "{" .. p1 .. "}"))
	end))
end
local function useMockedLocalization(t2: {[any]: any}, t3: {[any]: any}) -- line: 13
	local t4 = {}

	for v8, v9 in t2 do
		if type(v9) == "string" then
			local t5 = {}

			t4[v8] = (t3[v9] or v9 .. "-translated"):gsub("{(.-)}", function(p2) -- line: 8
				-- upvalues: t5 (copy)
				return (tostring(t5[p2] or "{" .. p2 .. "}"))
			end)
		elseif type(v9) == "table" then
			local v11 = v9[1]
			local t6 = {}

			for v13, v14 in v9 do
				if type(v13) ~= "number" then
					t6[v13] = v14
				end
			end

			t4[v8] = (t3[v11] or v11 .. "-translated"):gsub("{(.-)}", function(p3) -- line: 8
				-- upvalues: t6 (copy)
				return (tostring(t6[p3] or "{" .. p3 .. "}"))
			end)
		end
	end

	return t4
end

return useMockedLocalization
