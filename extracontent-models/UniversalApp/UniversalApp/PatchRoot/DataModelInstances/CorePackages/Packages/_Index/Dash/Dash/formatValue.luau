local parent = script.Parent

local function formatValue(value, value2: string?)
	local v = value2 or ""

	local v2, v3 = v:find("[A-Za-z#?]+")

	if v2 then
		local v4 = v:sub(v2, v3)

		local v5 = "%" .. v:sub(1, v2 - 1) .. v:sub(v3 + 1) .. "s"

		local pretty = require(parent.pretty)

		if v4 == "#?" then
			return v5:format(pretty(value, { multiline = true }))
		elseif v4 == "?" then
			return v5:format(pretty(value))
		end

		return ("%" .. v):format(value)
	else
		local v4

		if type(value) == "number" then
			local _, v5 = math.modf(value)
			v4 = v5 == 0 and "d" or "f"
		else
			v4 = "s"
		end

		return ("%" .. v .. v4):format((tostring(value)))
	end
end

return formatValue
