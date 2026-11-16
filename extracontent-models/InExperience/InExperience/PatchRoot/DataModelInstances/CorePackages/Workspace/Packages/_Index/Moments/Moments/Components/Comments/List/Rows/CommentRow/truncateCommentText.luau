local Moments = script:FindFirstAncestor("Moments")

local escapeRichText = require(Moments.Utils.escapeRichText)

local function truncateCommentText(value: string, p: string, p2: number, callback)
	if callback(escapeRichText(value)) <= p2 then
		return nil
	end

	local v = {}

	for _, v2 in utf8.graphemes(value) do
		table.insert(v, v2)
	end

	local function candidate(p3: number) -- 2 equivalent calls inferred from this helper
		local v2 = not (p3 > 0) and "" or string.sub(value, 1, v[p3])
		return escapeRichText((string.gsub(v2, "%s+$", ""))) .. p
	end

	local v2 = #v - 1
	local v3 = 0

	while v3 < v2 do
		local v4 = (v3 + v2 + 1) // 2

		if callback(candidate(v4)) <= p2 then -- inferred equivalent call
			v3 = v4
		else
			v2 = v4 - 1
		end
	end

	return candidate(v3) -- inferred equivalent call
end

return truncateCommentText
