local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.Signals)

local LocalUserIdStore = require(DataHydrationParent.UserLib).Stores.LocalUserIdStore
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local userSettingsRequests = require(script.Parent.userSettingsRequests)

require(script.Parent.UserSettingsStoreTypes)

local function resolveLocalUserId(p1) -- line: 22
	-- upvalues: LocalUserIdStore (copy)
	return LocalUserIdStore.getCurrentUserId(p1)
end
local function createUserSettingsStore() -- line: 26
	-- upvalues: createDataCache (copy), createDataResolver (copy), userSettingsRequests (copy), resolveLocalUserId (copy), LocalUserIdStore (copy)
	local v10 = createDataCache()
	local v11 = createDataResolver({
		supportsMultiGet = false,
		cache = v10,
		fetchFn = function(_: string, _) -- line: 31
			-- upvalues: userSettingsRequests (copy)
			return userSettingsRequests.fetchSettingsAndOptions()
		end
	})

	return {
		getAndFetchUserSettings = function(p3) -- line: 36
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.getAndFetchItem(resolveLocalUserId(p3))
		end,
		getUserSettings = function(p4) -- line: 40
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.getCachedItem(resolveLocalUserId(p4))
		end,
		fetchUserSettings = function() -- line: 44
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.fetchItem(resolveLocalUserId(false))
		end,
		getAccountTheme = function(p5) -- line: 48
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			local v17 = v11.getCachedItem(resolveLocalUserId(p5)).data(p5)
			local v18 = v17 and v17.accountTheme

			return v18 and v18.currentValue
		end,
		getAndFetchAccountTheme = function(p6) -- line: 54
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			local v20 = v11.getAndFetchItem(resolveLocalUserId(p6)).data(p6)
			local v21 = v20 and v20.accountTheme

			return v21 and v21.currentValue
		end,
		updateAccountTheme = function(s2: string) -- line: 60
			-- upvalues: userSettingsRequests (copy), LocalUserIdStore (copy), v10 (copy)
			return userSettingsRequests.postUserSettings({
				accountTheme = s2
			}):andThen(function() -- line: 61
				-- upvalues: LocalUserIdStore (copy), v10 (copy), s2 (copy)
				local v23 = LocalUserIdStore.getCurrentUserId(false)

				v10.updateItem(v23, {
					accountTheme = {
						currentValue = s2
					}
				})
			end)
		end,
		clear = v11.clear,
		dispose = v11.dispose
	}
end

return createUserSettingsStore
