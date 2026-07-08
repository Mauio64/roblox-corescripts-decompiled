local function StringTrim(p1, p2, p3) -- line: 3
	if not p2 then
		p2 = "%s"
	end

	if #p2 == 0 then
		return p1
	end

	if not p3 then
		p3 = {
			left = true,
			right = true
		}
	end

	if p3.left then
		local v5 = string.find(p1, "[^" .. p2 .. "]")

		if not v5 then
			return ""
		end

		p1 = string.sub(p1, v5)
	end

	if p3.right then
		local v6 = string.find(p1, "[" .. p2 .. "]+$")

		if not v6 then
			return p1
		end

		p1 = string.sub(p1, 1, v6 - 1)
	end

	return p1
end

return StringTrim
