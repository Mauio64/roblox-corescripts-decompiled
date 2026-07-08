local function StringSplit(p1, p2, p3) -- line: 7
	-- upvalues: StringSplit (copy)
	if #p1 == 0 then
		if string.find(p1, p2) then
			return {}
		end

		return { "" }
	end

	if not p3 then
		p3 = -1
	end

	if p3 == 1 then
		return { p1 }
	end

	if not p2 then
		p2 = "%s+"
	end

	local start, stop = string.find(p1, p2)

	if not start then
		return { p1 }
	end

	if stop < 1 then
		local start2, stop2 = string.find(string.sub(p1, 2), p2)

		start = start2 + 1
		stop = stop2 + 1
	end

	local v9 = string.sub(p1, 1, start - 1)
	local v10 = string.sub(p1, stop + 1)

	if #v10 == 0 and start <= stop then
		return {
			v9,
			v10
		}
	end

	local v11 = StringSplit(v10, p2, p3 - 1)

	table.insert(v11, 1, v9)

	return v11
end

return StringSplit
