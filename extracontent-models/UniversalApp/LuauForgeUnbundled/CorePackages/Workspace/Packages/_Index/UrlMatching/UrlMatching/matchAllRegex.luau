require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/RegExp")
local function matchAllRegex(value, object)
	local v5 = object:exec(value)

	if not v5 then
		return {}
	end

	local index = v5.index
	local v6 = v5[1]
	local v7 = {}

	if #v5 > 1 then
		for i = 2, #v5 do
			table.insert(v7, v5[i])
		end
	end

	local v8 = utf8.offset(value, index)
	local v9 = value:sub(v8 + #v6)
	return {
		{ index = v8, input = value, matchedText = v6, capturedGroups = v7 },
		unpack((matchAllRegex(v9, object)))
	}
end

return matchAllRegex
