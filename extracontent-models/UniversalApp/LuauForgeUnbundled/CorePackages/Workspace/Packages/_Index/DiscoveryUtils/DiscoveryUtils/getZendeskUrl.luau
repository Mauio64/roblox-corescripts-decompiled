local v5 = {
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

local function fn(value)
	if v5[value] then
		return v5[value]
	end

	local v6 = {}

	for k in value:gmatch("([^%-_]+)") do
		table.insert(v6, k)
	end

	if v6[1] then
		return v6[1]
	end

	return "en-us"
end

local function getZendeskUrl(value, value2, value3)
	return `{value or "https://en.help.roblox.com/hc"}/{(not value2 or string.match(value2, "^[%w%-_]+$") == nil) and "en-us" or fn(value2)}/{(not value3 or string.match(value3, "^[a-zA-Z0-9]+$") == nil) and "" or `articles/{value3}`}`
end

return getZendeskUrl
