local v = {
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

local function fn(value: string)
	if v[value] then
		return v[value]
	end

	local v2 = {}

	for k in value:gmatch("([^%-_]+)") do
		table.insert(v2, k)
	end

	return if v2[1] then v2[1] else "en-us"
end

local function fn2(value: string?) -- 1 equivalent call inferred from this helper
	return value and string.match(value, "^[a-zA-Z0-9]+$") ~= nil
end

local function getZendeskUrl(value: string?, value2: string?, value3: string?)
	return `{value or "https://en.help.roblox.com/hc"}/{(not value2 or string.match(value2, "^[%w%-_]+$") == nil) and "en-us" or fn(value2)}/{not fn2(value3) and "" or `articles/{value3}`}` -- inferred equivalent call
end

return getZendeskUrl
