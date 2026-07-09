local HttpClient = script:FindFirstAncestor("HttpClient")
local HttpClientParent = HttpClient.Parent
local DataHydration = require(HttpClientParent.Dev.DataHydration)
local lib = require(HttpClient)
local fetch = lib.fetch
local asPromise = lib.asPromise

local function settingsUrl(s1: string, s2: string) -- line: 46
	return `{ s1 }/account-settings/v1/settings/{ s2 }`
end
local function createAccountSettingsStore(t1: {[any]: any}?) -- line: 50
	-- upvalues: DataHydration (copy), fetch (copy), asPromise (copy)
	local v12 = t1 or {}
	local v13 = v12.urlBase or "https://apis.roblox.com"
	local network = v12.network
	local v15 = DataHydration.createDataCache()
	local v16 = DataHydration.createDataResolver({
		supportsMultiGet = false,
		cache = v15,
		fetchFn = function(s3: string, _) -- line: 59
			-- upvalues: fetch (copy), v13 (copy), network (copy), asPromise (copy)
			local v19 = fetch({
				method = "GET",
				analyticsKey = "account-settings.get",
				url = `{ v13 }/account-settings/v1/settings/{ s3 }`,
				network = network,
				decode = function(p2) -- line: 65
					return p2
				end
			})

			return asPromise(v19)
		end
	})

	return {
		getSettings = function(s4: string) -- line: 90
			-- upvalues: v16 (copy)
			return (v16.getAndFetchItem(s4))
		end,
		updateSettings = function(s5: string, t2: {[any]: any}) -- line: 73
			-- upvalues: fetch (copy), v13 (copy), network (copy), asPromise (copy), v15 (copy)
			local v22 = fetch({
				method = "PATCH",
				analyticsKey = "account-settings.patch",
				url = `{ v13 }/account-settings/v1/settings/{ s5 }`,
				body = t2,
				network = network,
				decode = function(p3) -- line: 80
					return p3
				end
			})

			return asPromise(v22):andThen(function(t3: {[any]: any}) -- line: 84
				-- upvalues: v15 (copy), s5 (copy)
				v15.updateItem(s5, t3)

				return t3
			end)
		end,
		clear = v16.clear,
		dispose = v16.dispose
	}
end

return createAccountSettingsStore
