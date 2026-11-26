local module = require("@luauforge/bundled/irC")

return function(value, p2, p3, p4)
	local v5 = "()(" .. (p4 or module.ValidTextTerminators) .. ")"
	local v6 = p2 or module.PunctuationPauseDuration
	local v7 = p3 or module.TTSModelCharacterLimit

	local v8 = string.rep(".", v6) .. " "

	local result = {}
	local v9 = {}
	local total = 0

	local v10 = 1
	local function fn(p5)
		local v11 = value:sub(v10, p5)
		local v12 = #v11 + #v8

		if v7 < total + v12 and total > 0 then
			local joined = table.concat(v9, v8)
			table.insert(result, joined)
			table.clear(v9)
			total = 0
		end

		while v7 < v12 do
			local v14 = -1

			for i = v7, 1, -1 do
				if string.sub(v11, i, i):match("%s") then
					v14 = i
					break
				end
			end

			if v14 < 1 then
				table.insert(result, v11:sub(1, v7))
				v10 += v7
			else
				table.insert(result, v11:sub(1, v14))
				v10 += v14
			end

			v11 = value:sub(v10, p5)
			v12 = #v11 + v6
		end

		total += v12
		table.insert(v9, v11)

		local v14, v15 = value:find("%S", p5 + 1)
		v10 = v14 or p5 + 1
	end

	local v11 = string.gmatch(value, v5)

	for k, v12 in v11 do
		if k < v10 then
			continue
		end

		local v13 = k + 1

		if not (v12 == "\n" or value:match("^%s+%a", v13) or value:match("^%s*\n", v13)) then
			continue
		end

		fn(k)
	end

	if v10 <= #value then
		fn(#value)

		if #v9 > 0 then
			table.insert(result, (table.concat(v9, v8)))
		end
	end

	return result
end
