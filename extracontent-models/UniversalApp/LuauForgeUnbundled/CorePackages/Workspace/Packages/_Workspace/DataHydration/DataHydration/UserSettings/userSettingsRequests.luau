local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserSettings/UserSettingsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function settingsAndOptionsUrl()
	return `{module.Url.APIS_URL}user-settings-api/v1/user-settings`
end

local function normalizeCachedUserSettings(items)
	if typeof(items) ~= "table" then
		return {}
	end

	local result = {}

	for k, item in items do
		result[k] = { currentValue = item }
	end

	return result
end

local function settingsUpdateUrl()
	return `{module.Url.APIS_URL}user-settings-api/v1/user-settings`
end

return {
	fetchSettingsAndOptions = function(p2)
		local network = p2 and p2.network or HttpClient.createRequestInternalNetwork()
		return asPromise((fetch({
			method = "GET",
			url = `{module.Url.APIS_URL}user-settings-api/v1/user-settings`,
			analyticsKey = "user-settings.settings-and-options.get",
			network = network,
			decode = function(p3)
				return normalizeCachedUserSettings(p3)
			end
		})))
	end,
	postUserSettings = function(p2, p3)
		local network = p3 and p3.network or HttpClient.createRequestInternalNetwork()
		return asPromise((fetch({
			method = "POST",
			url = `{module.Url.APIS_URL}user-settings-api/v1/user-settings`,
			body = p2,
			analyticsKey = "user-settings.update.post",
			network = withCsrfRetry(network),
			decode = function(p4)
				return p2
			end
		})))
	end
}
