local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String
local getBlockStringIndentation = nil

function isBlank(s1: string) -- line: 51
	for i = 1, #s1 do
		local v14 = string.sub(s1, i, i)

		if v14 ~= " " and v14 ~= "\t" then
			return false
		end
	end

	return true
end
function getBlockStringIndentation(s2: string) -- line: 62
	-- upvalues: String (copy)
	local v16 = true
	local v17 = true
	local n1 = 0
	local v19 = nil
	local n2 = 1
	local v21 = string.len(s2)

	while n2 <= v21 do
		local v22 = String.charCodeAt(s2, n2)

		if v22 == 13 and String.charCodeAt(s2, n2 + 1) == 10 then
			n2 += 1
		end

		if v22 == 10 then
			v16 = false
			v17 = true
			n1 = 0
		elseif v22 == 9 or v22 == 32 then
			n1 += 1
		else
			if v17 and v16 ~= true and (v19 == nil or n1 < v19) then
				v19 = n1
			end

			v17 = false
		end

		n2 += 1
	end

	return v19 and v19 or 0
end

return {
	getBlockStringIndentation = getBlockStringIndentation,
	dedentBlockStringValue = function(s3: string) -- line: 22
		-- upvalues: String (copy), getBlockStringIndentation (ref), Array (copy)
		local v7 = String.split(s3, {
			"\r\n",
			"\n",
			"\r"
		})
		local v8 = getBlockStringIndentation(s3)

		if v8 ~= 0 then
			for i = 2, #v7 do
				v7[i] = String.slice(v7[i], v8 + 1)
			end
		end

		local n3 = 0

		while n3 < #v7 and isBlank(v7[n3 + 1]) do
			n3 += 1
		end

		local v11 = #v7

		while n3 < v11 and isBlank(v7[v11 - 1 + 1]) do
			v11 -= 1
		end

		return Array.join(Array.slice(v7, n3 + 1, v11 + 1), "\n")
	end,
	printBlockString = function(s4: string, s5: string?, b1: boolean?) -- line: 102
		local v26 = s5 or ""
		local v27 = b1 ~= nil and b1
		local v28 = string.find(s4, "\n") == nil
		local v29 = string.sub(s4, 1, 1) == " " or string.sub(s4, 1, 1) == "\t"
		local v30 = string.sub(s4, #s4, #s4) == "\""
		local v31 = string.sub(s4, #s4, #s4) == "\\"
		local v32 = v28 ~= true or (v30 or (v31 or v27))
		local s6 = ""

		if v32 and (v28 and v29) ~= true then
			s6 ..= "\n" .. v26
		end

		local v34 = s6 .. (v26 ~= "" and string.gsub(s4, "\n", "\n" .. v26) or s4)

		if v32 then
			v34 ..= "\n"
		end

		return "\"\"\"" .. string.gsub(v34, "\"\"\"", "\\\"\"\"") .. "\"\"\""
	end
}
