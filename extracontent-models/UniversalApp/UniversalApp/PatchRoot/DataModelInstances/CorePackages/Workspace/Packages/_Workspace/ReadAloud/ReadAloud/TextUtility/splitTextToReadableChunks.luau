local ParentParent = script.Parent.Parent
local Properties = require(ParentParent.Properties)

return function(s1: string, n1: number?, n2: number?, s2: string?) -- line: 7
	-- upvalues: Properties (copy)
	local v7 = "()(" .. (s2 or Properties.ValidTextTerminators) .. ")"
	local v8 = n1 or Properties.PunctuationPauseDuration
	local v9 = n2 or Properties.TTSModelCharacterLimit
	local v10 = string.rep(".", v8) .. " "
	local t1 = {}
	local t2 = {}
	local n3 = 0
	local n4 = 1

	local function v15(n5: number) -- line: 21
		-- upvalues: s1 (copy), n4 (ref), v10 (copy), n3 (ref), v9 (copy), t2 (copy), t1 (copy), v8 (copy)
		local v20 = s1:sub(n4, n5)
		local v21 = #v20 + #v10

		if n3 + v21 > v9 and n3 > 0 then
			local v22 = table.concat(t2, v10)

			table.insert(t1, v22)
			table.clear(t2)
			n3 = 0
		end

		while v21 > v9 do
			local n6 = -1

			for i = v9, 1, -1 do
				if string.sub(v20, i, i):match("%s") then
					n6 = i

					break
				end
			end

			if n6 < 1 then
				table.insert(t1, v20:sub(1, v9))
				n4 += v9
			else
				table.insert(t1, v20:sub(1, n6))
				n4 += n6
			end

			v20 = s1:sub(n4, n5)
			v21 = #v20 + v8
		end

		n3 += v21
		table.insert(t2, v20)

		local start, _ = s1:find("%S", n5 + 1)

		n4 = start or n5 + 1
	end

	for match, v17 in (string.gmatch(s1, v7)) do
		if not (match < n4) then
			local v18 = match + 1

			if v17 == "\n" or s1:match("^%s+%a", v18) or s1:match("^%s*\n", v18) then
				v15(match)
			end
		end
	end

	if n4 <= #s1 then
		v15(#s1)

		if #t2 > 0 then
			table.insert(t1, (table.concat(t2, v10)))
		end
	end

	return t1
end
