local function StringTrim(value, value2, p)
	value2 = value2 or "%s"

	if #value2 == 0 then
		return value
	end

	p = p or { left = true, right = true }

	if p.left then
		local v = string.find(value, "[^" .. value2 .. "]")

		if not v then
			return ""
		end

		value = string.sub(value, v)
	end

	if not p.right then
		return value
	end

	local v = string.find(value, "[" .. value2 .. "]+$")

	if not v then
		return value
	end

	value = string.sub(value, 1, v - 1)

	return value
end

return StringTrim
