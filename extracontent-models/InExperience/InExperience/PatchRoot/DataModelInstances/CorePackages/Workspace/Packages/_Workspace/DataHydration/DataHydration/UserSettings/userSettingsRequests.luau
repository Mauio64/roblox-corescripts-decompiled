local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UserSettingsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function settingsAndOptionsUrl() -- line: 21
	-- upvalues: Http (copy)
	return `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings/settings-and-options`
end
local function settingsUpdateUrl() -- line: 25
	-- upvalues: Http (copy)
	return `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`
end

return {
	fetchSettingsAndOptions = function() -- line: 29
		-- upvalues: fetch (copy), Http (copy), HttpClient (copy), asPromise (copy)
		local v10 = fetch({
			method = "GET",
			analyticsKey = "user-settings.settings-and-options.get",
			url = `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings/settings-and-options`,
			network = HttpClient.createRequestInternalNetwork(),
			decode = function(p1) -- line: 35
				return p1
			end
		})

		return asPromise(v10)
	end,
	postUserSettings = function(t1: {[any]: any}) -- line: 42
		-- upvalues: fetch (copy), Http (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v12 = fetch({
			method = "POST",
			analyticsKey = "user-settings.update.post",
			url = `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`,
			body = t1,
			network = withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			decode = function(_) -- line: 49
				-- upvalues: t1 (copy)
				return t1
			end
		})

		return asPromise(v12)
	end
}
