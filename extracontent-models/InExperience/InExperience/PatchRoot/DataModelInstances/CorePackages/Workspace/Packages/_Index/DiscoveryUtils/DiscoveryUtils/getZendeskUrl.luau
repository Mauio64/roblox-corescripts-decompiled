local t1 = {
	["zh-cn"] = "zh-cn",
	zh_cn = "zh-cn",
	["zh-cjv"] = "zh-cn",
	zh_cjv = "zh-cn",
	["zh-hans"] = "zh-cn",
	zh_hans = "zh-cn",
	["zh-tw"] = "zh-tw",
	zh_tw = "zh-tw",
	["zh-hant"] = "zh-tw",
	zh_hant = "zh-tw",
	["en-us"] = "en-us",
	en_us = "en-us",
	en = "en-us",
	["en-gb"] = "en-gb",
	en_gb = "en-gb",
	["fr-ca"] = "fr-ca",
	fr_ca = "fr-ca",
	nb = "no",
	["nb-no"] = "no",
	nb_no = "no"
}

local function v2(s1: string) -- line: 24
	-- upvalues: t1 (copy)
	if t1[s1] then
		return t1[s1]
	end

	local t2 = {}

	for match in s1:gmatch("([^%-_]+)") do
		table.insert(t2, match)
	end

	if t2[1] then
		return t2[1]
	end

	return "en-us"
end
local function getZendeskUrl(s2: string?, s3: string?, s4: string?) -- line: 52
	-- upvalues: v2 (copy)
	return `{ s2 or "https://en.help.roblox.com/hc" }/{ not (s3 and string.match(s3, "^[%w%-_]+$") ~= nil) and "en-us" or v2(s3) }/{ not (s4 and string.match(s4, "^[a-zA-Z0-9]+$") ~= nil) and "" or `articles/{ s4 }` }`
end

return getZendeskUrl
