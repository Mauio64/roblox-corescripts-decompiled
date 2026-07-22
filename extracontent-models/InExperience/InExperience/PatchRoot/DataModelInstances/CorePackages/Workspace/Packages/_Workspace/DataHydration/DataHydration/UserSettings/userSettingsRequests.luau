local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UserSettingsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function settingsAndOptionsUrl() -- line: 23
	-- upvalues: Http (copy)
	return `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings/settings-and-options`
end
local function settingsUpdateUrl() -- line: 27
	-- upvalues: Http (copy)
	return `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`
end

return {
	fetchSettingsAndOptions = function(t1: {[any]: any}?) -- line: 31
		-- upvalues: HttpClient (copy), fetch (copy), Http (copy), asPromise (copy)
		local v11 = t1 and t1.network or HttpClient.createRequestInternalNetwork()
		local v12 = fetch({
			method = "GET",
			analyticsKey = "user-settings.settings-and-options.get",
			url = `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings/settings-and-options`,
			network = v11,
			decode = function(p1) -- line: 38
				return p1
			end
		})

		return asPromise(v12)
	end,
	postUserSettings = function(t2: {[any]: any}, t3: {[any]: any}?) -- line: 45
		-- upvalues: HttpClient (copy), fetch (copy), Http (copy), withCsrfRetry (copy), asPromise (copy)
		local v15 = t3 and t3.network or HttpClient.createRequestInternalNetwork()
		local v16 = fetch({
			method = "POST",
			analyticsKey = "user-settings.update.post",
			url = `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`,
			body = t2,
			network = withCsrfRetry(v15),
			decode = function(_) -- line: 53
				-- upvalues: t2 (copy)
				return t2
			end
		})

		return asPromise(v16)
	end
}
