local scriptParent = script.Parent

local function formatValue(p1, s1: string?) -- line: 19
	-- upvalues: scriptParent (copy)
	local v5 = s1 or ""
	local start, stop = v5:find("[A-Za-z#?]+")

	if start then
		local v8 = v5:sub(start, stop)
		local v9 = "%" .. v5:sub(1, start - 1) .. v5:sub(stop + 1) .. "s"
		local pretty = require(scriptParent.pretty)

		if v8 == "#?" then
			return v9:format(pretty(p1, {
				multiline = true
			}))
		end

		if v8 == "?" then
			return v9:format(pretty(p1))
		end

		return ("%" .. v5):format(p1)
	end

	local s2 = "s"

	if type(p1) == "number" then
		local _, fraction = math.modf(p1)

		s2 = fraction ~= 0 and "f" or "d"
	end

	return ("%" .. v5 .. s2):format((tostring(p1)))
end

return formatValue
