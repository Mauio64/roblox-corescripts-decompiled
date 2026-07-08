local t1 = {
	replaceNewlines = function(p1, p2) -- line: 18
		local v4 = p2 or " "

		return p1:gsub("\r\n", v4):gsub("\r", v4):gsub("\n", v4)
	end,
	truncateLength = function(p3, p4) -- line: 33
		local v7 = p4 or 140

		if v7 >= p3:len() then
			return p3
		end

		local s1 = ""
		local v9 = ("..."):len()

		for v10, v11 in utf8.graphemes(p3) do
			local v12 = p3:sub(v10, v11)

			if v7 < s1:len() + v12:len() + v9 then
				break
			end

			s1 ..= v12
		end

		local result, count = s1:gsub("%s+%S-$", "...", 1)

		if count > 0 then
			return result
		end

		return s1 .. "..."
	end
}

function t1.sanitizeDescription(p5) -- line: 73
	-- upvalues: t1 (copy)
	local v16 = t1.replaceNewlines(p5)

	return (t1.truncateLength(v16))
end

return t1
