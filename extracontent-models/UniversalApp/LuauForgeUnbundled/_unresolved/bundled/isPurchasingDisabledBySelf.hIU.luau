local module = require("@luauforge/bundled/hIN")
local module2 = require("@luauforge/bundled/hIP")
local url = require("@luauforge/bundled/hIR").Url

local function decode(p2): boolean
	local enablePurchases = if typeof(p2) == "table" then p2.enablePurchases else nil

	if typeof(enablePurchases) ~= "table" or typeof(enablePurchases.options) ~= "table" then
		return false
	end

	for k, option in enablePurchases.options do
		if typeof(option) ~= "table" then
			continue
		end

		local v5 = if typeof(option.option) == "table" then option.option.optionValue else nil

		if option.requirement == "SelfUpdateSetting" and v5 ~= enablePurchases.currentValue then
			return true
		end
	end

	return false
end

local function isPurchasingDisabledBySelf(p2)
	return module.asPromise(module.fetch({
		network = p2,
		method = "GET",
		url = `{url.APIS_URL}user-settings-api/v1/user-settings/settings-and-options?requestedUserSettings=enablePurchases`,
		analyticsKey = "user-settings-api.v1.settings-and-options.enable-purchases",
		decode = decode,
		retry = false,
		headers = {}
	})):catch(function()
		return module2.resolve(false)
	end)
end

return isPurchasingDisabledBySelf
