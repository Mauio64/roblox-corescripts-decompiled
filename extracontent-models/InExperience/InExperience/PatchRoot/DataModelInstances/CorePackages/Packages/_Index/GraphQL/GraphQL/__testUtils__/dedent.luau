local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String

function dedent(list, ...)
	local v = { ... }

	local v2 = ""

	if Array.isArray(list) then
		for i = 1, #list do
			v2 ..= list[i]

			if i <= #v then
				v2 ..= v[i]
			end
		end
	else
		v2 = list
	end

	local v3 = removeTrailingSpacesAndTabs(removeLeadingNewLines(v2))
	local v4 = ""

	for i = 1, string.len(v3) do
		local v5 = string.sub(v3, i, i)

		if v5 ~= " " and v5 ~= "\t" then
			break
		end

		v4 ..= v5
	end

	return removeCommonIndent(v3, v4)
end

function removeLeadingNewLines(value: string)
	local v = String.findOr(value, { "\n*" })

	if v ~= nil and v.index == 1 then
		value = string.sub(value, string.len(v.match) + 1)
	end

	return value
end

function removeTrailingSpacesAndTabs(value: string)
	local v = 1
	local v2 = nil

	repeat
		local v3 = String.findOr(value, { " +", "\t+" }, v)

		if v3 ~= nil then
			v2 = v2 ~= nil and v2.index + string.len(v2.match) == v3.index and {
				index = v2.index,
				match = v2.match .. v3.match
			} or v3

			v = v3.index + string.len(v3.match)
		end
	until v3 == nil or string.len(value) < v

	if v2 == nil or v2.index + string.len(v2.match) ~= string.len(value) + 1 then
		return value
	end

	return (string.sub(value, 1, v2.index - 1))
end

function removeCommonIndent(value: string, p: string)
	local v = string.gsub(value, p, "", 1)
	return (string.gsub(v, "\n" .. p, "\n"))
end

return { dedent = dedent }
