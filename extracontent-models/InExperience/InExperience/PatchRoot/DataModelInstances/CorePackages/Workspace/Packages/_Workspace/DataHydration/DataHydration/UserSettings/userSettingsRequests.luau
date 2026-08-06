local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)
local HttpClient = require(DataHydrationParent.HttpClient)
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UserSettingsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local FFlagUserSettingsFetchCachedEndpoint = require(script.Parent.FFlagUserSettingsFetchCachedEndpoint)

local function settingsAndOptionsUrl() -- line: 26
	-- upvalues: FFlagUserSettingsFetchCachedEndpoint (copy), Http (copy)
	local v12 = not FFlagUserSettingsFetchCachedEndpoint and "user-settings-api/v1/user-settings/settings-and-options" or "user-settings-api/v1/user-settings"

	return `{ Http.Url.APIS_URL }{ v12 }`
end
local function normalizeCachedUserSettings(p1) -- line: 31
	if typeof(p1) ~= "table" then
		return {}
	end

	local t1 = {}

	for v15, v16 in p1 do
		t1[v15] = {
			currentValue = v16
		}
	end

	return t1
end
local function settingsUpdateUrl() -- line: 42
	-- upvalues: Http (copy)
	return `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`
end

return {
	fetchSettingsAndOptions = function(t2: {[any]: any}?) -- line: 46
		-- upvalues: HttpClient (copy), fetch (copy), FFlagUserSettingsFetchCachedEndpoint (copy), Http (copy), normalizeCachedUserSettings (copy), asPromise (copy)
		local v18 = t2 and t2.network or HttpClient.createRequestInternalNetwork()
		local v19 = fetch
		local t3 = {
			method = "GET",
			analyticsKey = "user-settings.settings-and-options.get"
		}
		local v21 = not FFlagUserSettingsFetchCachedEndpoint and "user-settings-api/v1/user-settings/settings-and-options" or "user-settings-api/v1/user-settings"

		t3.url = `{ Http.Url.APIS_URL }{ v21 }`
		t3.network = v18

		function t3.decode(p2) -- line: 53
			-- upvalues: FFlagUserSettingsFetchCachedEndpoint (copy), normalizeCachedUserSettings (copy)
			if FFlagUserSettingsFetchCachedEndpoint then
				return (normalizeCachedUserSettings(p2))
			end

			return p2
		end

		local v22 = v19(t3)

		return asPromise(v22)
	end,
	postUserSettings = function(t4: {[any]: any}, t5: {[any]: any}?) -- line: 63
		-- upvalues: HttpClient (copy), fetch (copy), Http (copy), withCsrfRetry (copy), asPromise (copy)
		local v25 = t5 and t5.network or HttpClient.createRequestInternalNetwork()
		local v26 = fetch({
			method = "POST",
			analyticsKey = "user-settings.update.post",
			url = `{ Http.Url.APIS_URL }user-settings-api/v1/user-settings`,
			body = t4,
			network = withCsrfRetry(v25),
			decode = function(_) -- line: 71
				-- upvalues: t4 (copy)
				return t4
			end
		})

		return asPromise(v26)
	end
}
