local t1 = {
	Zendesk = "zendesk"
}
local t2 = {
	PolicyUpdate = "policy_update",
	ParentalControlsLaunch = "parental_controls_launch",
	SpendingSettings = "spending_settings"
}

local function v3(s1: string) -- line: 17
	local t3 = {
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

	if t3[s1] then
		return t3[s1]
	end

	local t4 = {}

	for match in s1:gmatch("([^%-_]+)") do
		table.insert(t4, match)
	end

	if t4[1] then
		return t4[1]
	end

	return "en"
end

return {
	ExternalWebDomainEnum = t1,
	ExternalWebPageTypeEnum = t2,
	getZendeskUrl = function(t5: {[any]: any}) -- line: 72
		-- upvalues: v3 (copy)
		local s2 = "https://en.help.roblox.com/hc/"
		local locale = t5.locale
		local v13 = if not (not not locale and not not string.match(locale, "^[%w%-_]+$")) then s2 .. "en-us" else s2 .. v3(t5.locale)
		local articleid = t5.articleid

		if not not articleid and not not string.match(articleid, "^[a-zA-Z0-9]+$") then
			v13 ..= "/articles/" .. t5.articleid
		end

		return v13
	end,
	getZendeskWebViewTitleKey = function(s3: string?) -- line: 86
		-- upvalues: t2 (copy)
		if s3 == t2.PolicyUpdate then
			return "Feature.Notifications.Webview.Title.PolicyUpdate"
		end

		if s3 == t2.ParentalControlsLaunch then
			return "Feature.Notifications.Webview.Title.ParentalControlsLaunch"
		end

		if s3 == t2.SpendingSettings then
			return "Feature.Notifications.Webview.Title.SpendingSettings"
		end

		return "CommonUI.Features.Label.Help"
	end,
	getExternalLocale = v3,
	isValidLocale = function(s4: string?) -- line: 56
		if s4 then
			return not not string.match(s4, "^[%w%-_]+$")
		end

		return false
	end,
	isValidArticleId = function(s5: string?) -- line: 64
		if s5 then
			return not not string.match(s5, "^[a-zA-Z0-9]+$")
		end

		return false
	end
}
