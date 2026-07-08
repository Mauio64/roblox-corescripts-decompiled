local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String

function dedent(p1, ...) -- line: 18
	-- upvalues: Array (copy)
	local t1 = { ... }
	local s1 = ""

	if Array.isArray(p1) then
		for i = 1, #p1 do
			s1 ..= p1[i]

			if i <= #t1 then
				s1 ..= t1[i]
			end
		end
	else
		s1 = p1
	end

	local v9 = removeTrailingSpacesAndTabs(removeLeadingNewLines(s1))
	local s2 = ""

	for i = 1, string.len(v9) do
		local v12 = string.sub(v9, i, i)

		if v12 ~= " " and v12 ~= "\t" then
			return removeCommonIndent(v9, s2)
		end

		s2 ..= v12
	end

	return removeCommonIndent(v9, s2)
end
function removeLeadingNewLines(s3: string) -- line: 50
	-- upvalues: String (copy)
	local v14 = String.findOr(s3, { "\n*" })

	if v14 ~= nil and v14.index == 1 then
		s3 = string.sub(s3, string.len(v14.match) + 1)
	end

	return s3
end
function removeTrailingSpacesAndTabs(s4: string) -- line: 59
	-- upvalues: String (copy)
	local v16 = nil
	local n1 = 1

	repeat
		local v18 = String.findOr(s4, {
			" +",
			"\t+"
		}, n1)

		if v18 ~= nil then
			v16 = if v16 == nil or v16.index + string.len(v16.match) ~= v18.index then v18 else {
				index = v16.index,
				match = v16.match .. v18.match
			}
			n1 = v18.index + string.len(v18.match)
		end
	until v18 == nil or n1 > string.len(s4)

	if v16 ~= nil and v16.index + string.len(v16.match) == string.len(s4) + 1 then
		return (string.sub(s4, 1, v16.index - 1))
	end

	return s4
end
function removeCommonIndent(s5: string, s6: string) -- line: 90
	local v21 = string.gsub(s5, s6, "", 1)

	return (string.gsub(v21, "\n" .. s6, "\n"))
end

return {
	dedent = dedent
}
