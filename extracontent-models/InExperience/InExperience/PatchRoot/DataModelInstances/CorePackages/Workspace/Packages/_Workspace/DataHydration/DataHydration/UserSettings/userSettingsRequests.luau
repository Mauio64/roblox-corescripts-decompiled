local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.UserSettingsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function settingsAndOptionsUrl() -- 1 equivalent call inferred from this helper
	return `{Http.Url.APIS_URL}user-settings-api/v1/user-settings`
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

local function settingsUpdateUrl() -- 1 equivalent call inferred from this helper
	return `{Http.Url.APIS_URL}user-settings-api/v1/user-settings`
end

local UserSettingsRequests = {}

function UserSettingsRequests.fetchSettingsAndOptions(p)
	local network = p and p.network or HttpClient.createRequestInternalNetwork()
	return asPromise((fetch({
		method = "GET",
		url = settingsAndOptionsUrl(), -- inferred equivalent call
		analyticsKey = "user-settings.settings-and-options.get",
		network = network,
		decode = function(p2)
			return normalizeCachedUserSettings(p2)
		end
	})))
end

function UserSettingsRequests.postUserSettings(body, p)
	local network = p and p.network or HttpClient.createRequestInternalNetwork()
	return asPromise((fetch({
		method = "POST",
		url = settingsUpdateUrl(), -- inferred equivalent call
		body = body,
		analyticsKey = "user-settings.update.post",
		network = withCsrfRetry(network),
		decode = function(_)
			return body
		end
	})))
end

return UserSettingsRequests
