local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/escapeRichText")

local function truncateCommentText(value, p2, p3, callback)
	if callback(escapeRichText(value)) <= p3 then
		return nil
	end

	local v5 = {}

	for k, v6 in utf8.graphemes(value) do
		table.insert(v5, v6)
	end

	local function candidate(p4)
		local v6 = not (p4 > 0) and "" or string.sub(value, 1, v5[p4])
		return escapeRichText((string.gsub(v6, "%s+$", ""))) .. p2
	end

	local v6 = #v5 - 1
	local v7 = 0

	while v7 < v6 do
		local v8 = (v7 + v6 + 1) // 2
		local v9 = not (v8 > 0) and "" or string.sub(value, 1, v5[v8])

		if callback(escapeRichText((string.gsub(v9, "%s+$", ""))) .. p2) <= p3 then
			v7 = v8
		else
			v6 = v8 - 1
		end
	end

	local v8 = not (v7 > 0) and "" or string.sub(value, 1, v5[v7])
	return escapeRichText((string.gsub(v8, "%s+$", ""))) .. p2
end

return truncateCommentText
