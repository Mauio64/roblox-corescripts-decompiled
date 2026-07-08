local function splitStringWithMarks(p1, p2) -- line: 19
	if type(p1) ~= "string" or type(p2) ~= "table" then
		return p1, ""
	end

	for _, v in ipairs(p2) do
		local start, stop = p1:find(v, nil, true)

		if start ~= nil then
			return p1:sub(1, start - 1), (p1:sub(stop + 1))
		end
	end

	return p1, ""
end
local function findFileNameFromPath(p3) -- line: 37
	if type(p3) ~= "string" then
		return ""
	end

	return string.match(p3, "([^.]*)$")
end
local function ProcessErrorStack(p4, p5) -- line: 45
	-- upvalues: splitStringWithMarks (copy)
	local t1 = {}
	local t2 = {}

	if not p5 then
		p5 = 0
	end

	if type(p4) ~= "string" then
		return t1, t2
	end

	for match in p4:gmatch("[^\r\n]+") do
		local v16, v17 = splitStringWithMarks(match, {
			", line ",
			", Line ",
			":"
		})
		local v18, v19 = splitStringWithMarks(v17, { " - " })

		if v19 == "" and v18 ~= "" then
			local v20, v21 = string.match(v18, "^(%d+)%s*(.*)")

			if v20 then
				v18 = v20

				if v21 ~= "" then
					v19 = v21
				end
			end
		end

		if v18 ~= "" and v16 ~= "" then
			local _, _, v24 = string.find(v16, "Script '(.*)'")

			if v24 ~= nil then
				v16 = v24
			end

			local v25 = t2[v16]

			if v25 == nil then
				p5 += 1
				v25 = p5
				t2[v16] = v25
			end

			if v19 == "" then
				v19 = if type(v16) == "string" then string.match(v16, "([^.]*)$") else ""
			end

			table.insert(t1, {
				line = v18,
				funcName = v19,
				sourceCode = tostring(v25)
			})
		end
	end

	local t3 = {}

	for k, v in pairs(t2) do
		t3[tostring(v)] = {
			path = k
		}
	end

	return t1, t3, p5
end

return ProcessErrorStack
