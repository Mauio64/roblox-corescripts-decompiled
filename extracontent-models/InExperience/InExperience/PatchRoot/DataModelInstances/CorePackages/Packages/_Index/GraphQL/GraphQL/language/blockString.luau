local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String

local getBlockStringIndentation

local function dedentBlockStringValue(p: string)
	local parts = String.split(p, { "\r\n", "\n", "\r" })

	local v = getBlockStringIndentation(p)

	if v ~= 0 then
		for i = 2, #parts do
			parts[i] = String.slice(parts[i], v + 1)
		end
	end

	local count = 0

	while count < #parts and isBlank(parts[count + 1]) do
		count += 1
	end

	local count2 = #parts

	while count < count2 and isBlank(parts[count2 - 1 + 1]) do
		count2 -= 1
	end

	return Array.join(Array.slice(parts, count + 1, count2 + 1), "\n")
end

function isBlank(value: string): boolean
	for i = 1, #value do
		local v = string.sub(value, i, i)

		if v ~= " " and v ~= "\t" then
			return false
		end
	end

	return true
end

getBlockStringIndentation = function(value: string)
	local v = string.len(value)
	local v2 = 1
	local count = 0
	local v3 = true
	local v4 = true
	local v5 = nil

	while v2 <= v do
		local charCodeAt = String.charCodeAt(value, v2)

		if charCodeAt == 13 and String.charCodeAt(value, v2 + 1) == 10 then
			v2 += 1
		end

		if charCodeAt == 10 then
			count = 0
			v3 = true
			v4 = false
		elseif charCodeAt == 9 or charCodeAt == 32 then
			count += 1
		else
			if v3 and v4 ~= true and (v5 == nil or count < v5) then
				v5 = count
			end

			v3 = false
		end

		v2 += 1
	end

	return v5 and v5 or 0
end

return {
	getBlockStringIndentation = getBlockStringIndentation,
	dedentBlockStringValue = dedentBlockStringValue,
	printBlockString = function(value: string, value2: string?, flag: boolean?)
		local v = value2 or ""

		if flag == nil then
			flag = false
		end

		local v2 = string.find(value, "\n") == nil
		local v3 = string.sub(value, 1, 1) == " " or string.sub(value, 1, 1) == "\t"
		local v4 = string.sub(value, #value, #value) == "\""
		local v5 = string.sub(value, #value, #value) == "\\"
		local v6 = v2 ~= true or (v4 or v5 or flag)
		local v7 = ""

		if v6 and (v2 and v3) ~= true then
			v7 ..= "\n" .. v
		end

		value = v ~= "" and string.gsub(value, "\n", "\n" .. v) or value
		local v8 = v7 .. value

		if v6 then
			v8 ..= "\n"
		end

		return "\"\"\"" .. string.gsub(v8, "\"\"\"", "\\\"\"\"") .. "\"\"\""
	end
}
