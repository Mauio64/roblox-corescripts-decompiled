local ParentParent = script.Parent.Parent

require(ParentParent.RegExp)

local function matchAllRegex(s1: string, p1) -- line: 6
	-- upvalues: matchAllRegex (copy)
	local v5 = p1:exec(s1)

	if not v5 then
		return {}
	end

	local index = v5.index
	local v7 = v5[1]
	local t1 = {}

	if #v5 > 1 then
		for i = 2, #v5 do
			table.insert(t1, v5[i])
		end
	end

	local v10 = utf8.offset(s1, index)
	local v11 = s1:sub(v10 + #v7)
	local v12 = matchAllRegex(v11, p1)

	return {
		{
			index = v10,
			input = s1,
			matchedText = v7,
			capturedGroups = t1
		},
		unpack(v12)
	}
end

return matchAllRegex
