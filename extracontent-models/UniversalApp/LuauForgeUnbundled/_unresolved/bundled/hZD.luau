local v5 = {
	PolicyUpdate = "policy_update",
	ParentalControlsLaunch = "parental_controls_launch",
	SpendingSettings = "spending_settings"
}

local function fn(locale)
	local v6 = {
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

	if v6[locale] then
		return v6[locale]
	end

	local v7 = {}

	for k in locale:gmatch("([^%-_]+)") do
		table.insert(v7, k)
	end

	if v7[1] then
		return v7[1]
	end

	return "en"
end

return {
	ExternalWebDomainEnum = { Zendesk = "zendesk" },
	ExternalWebPageTypeEnum = v5,
	getZendeskUrl = function(p2)
		local v6 = "https://en.help.roblox.com/hc/"
		local locale = p2.locale
		local v7 = if locale then string.match(locale, "^[%w%-_]+$") and true or false else false

		local v8 = if v7 then v6 .. fn(p2.locale) else v6 .. "en-us"

		local articleid = p2.articleid
		local v9 = if articleid then string.match(articleid, "^[a-zA-Z0-9]+$") and true or false else false

		if v9 then
			v8 ..= "/articles/" .. p2.articleid
		end

		return v8
	end,
	getZendeskWebViewTitleKey = function(p2): string
		if p2 == v5.PolicyUpdate then
			return "Feature.Notifications.Webview.Title.PolicyUpdate"
		end

		if p2 == v5.ParentalControlsLaunch then
			return "Feature.Notifications.Webview.Title.ParentalControlsLaunch"
		end

		if p2 == v5.SpendingSettings then
			return "Feature.Notifications.Webview.Title.SpendingSettings"
		end

		return "CommonUI.Features.Label.Help"
	end,
	getExternalLocale = fn,
	isValidLocale = function(value)
		if value then
			return string.match(value, "^[%w%-_]+$") and true or false
		end

		return false
	end,
	isValidArticleId = function(value)
		if value then
			return string.match(value, "^[a-zA-Z0-9]+$") and true or false
		end

		return false
	end
}
