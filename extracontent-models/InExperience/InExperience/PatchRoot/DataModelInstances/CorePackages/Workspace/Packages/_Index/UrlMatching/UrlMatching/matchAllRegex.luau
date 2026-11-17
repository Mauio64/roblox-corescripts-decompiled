local parent = script.Parent.Parent

require(parent.RegExp)
local function matchAllRegex(input: string, object)
	local v = object:exec(input)

	if not v then
		return {}
	end

	local index = v.index
	local matchedText = v[1]
	local capturedGroups = {}

	if #v > 1 then
		for i = 2, #v do
			table.insert(capturedGroups, v[i])
		end
	end

	local v2 = utf8.offset(input, index)
	local v3 = input:sub(v2 + #matchedText)
	return {
		{ index = v2, input = input, matchedText = matchedText, capturedGroups = capturedGroups },
		unpack((matchAllRegex(v3, object)))
	}
end

return matchAllRegex
