local function toEconomyCurrencyUrl(value: string)
	local v = string.gsub(value:lower(), "/m.", "/www.")
	local v2 = string.gsub(v, "http:", "https:")
	return string.gsub(v2, "https://www.", "https://economy.") .. "v1/user/currency"
end

return toEconomyCurrencyUrl
