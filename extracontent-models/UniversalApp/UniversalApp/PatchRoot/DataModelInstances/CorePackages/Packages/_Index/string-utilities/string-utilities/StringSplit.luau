local function StringSplit(value, value2, value3)
	if #value == 0 then
		if string.find(value, value2) then
			return {}
		end

		return { "" }
	else
		value3 = value3 or -1

		if value3 == 1 then
			return { value }
		end

		value2 = value2 or "%s+"
		local v, v2 = string.find(value, value2)

		if not v then
			return { value }
		end

		if v2 < 1 then
			local v3, v4 = string.find(string.sub(value, 2), value2)
			v = v3 + 1
			v2 = v4 + 1
		end

		local v3 = string.sub(value, 1, v - 1)
		local v4 = string.sub(value, v2 + 1)

		if #v4 == 0 and v <= v2 then
			return { v3, v4 }
		end

		local stringSplit = StringSplit(v4, value2, value3 - 1)
		table.insert(stringSplit, 1, v3)
		return stringSplit
	end
end

return StringSplit
