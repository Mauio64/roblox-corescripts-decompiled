local AppsFlyerUtil = {}

function AppsFlyerUtil.replaceNewlines(value, value2)
	value2 = value2 or " "

	return value:gsub("\r\n", value2):gsub("\r", value2):gsub("\n", value2)
end

function AppsFlyerUtil.truncateLength(value, value2)
	local v = value2 or 140

	if value:len() <= v then
		return value
	end

	local v2 = ("..."):len()
	local v3 = ""

	for k, v4 in utf8.graphemes(value) do
		local v5 = value:sub(k, v4)

		if v < v3:len() + v5:len() + v2 then
			break
		end

		v3 ..= v5
	end

	local v4, v5 = v3:gsub("%s+%S-$", "...", 1)

	if v5 > 0 then
		return v4
	end

	return v3 .. "..."
end

function AppsFlyerUtil.sanitizeDescription(p)
	local v = AppsFlyerUtil.replaceNewlines(p)
	return (AppsFlyerUtil.truncateLength(v))
end

return AppsFlyerUtil
