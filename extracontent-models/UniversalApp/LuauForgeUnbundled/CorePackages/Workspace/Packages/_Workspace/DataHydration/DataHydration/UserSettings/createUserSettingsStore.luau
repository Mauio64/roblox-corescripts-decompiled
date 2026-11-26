require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local userSettingsRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserSettings/userSettingsRequests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserSettings/UserSettingsStoreTypes")

local function resolveLocalUserId(p2)
	return localUserIdStore.getCurrentUserId(p2)
end

local function createUserSettingsStore(options)
	local v5 = {
		network = (options or {}).network
	}

	local v6 = createDataCache()
	local v7 = createDataResolver({
		cache = v6,
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			return userSettingsRequests.fetchSettingsAndOptions(v5)
		end
	})

	local function writeAccountThemeToCache(p2, p3)
		v6.updateItem(p2, {
			accountTheme = { currentValue = p3 }
		})
	end

	return {
		getAndFetchUserSettings = function(p2)
			return v7.getAndFetchItem(resolveLocalUserId(p2))
		end,
		getUserSettings = function(p2)
			return v7.getCachedItem(resolveLocalUserId(p2))
		end,
		fetchUserSettings = function()
			return v7.fetchItem(resolveLocalUserId(false))
		end,
		getAccountTheme = function(p2)
			local data = v7.getCachedItem(resolveLocalUserId(p2)).data(p2)
			local accountTheme = data and data.accountTheme
			return accountTheme and accountTheme.currentValue
		end,
		getAndFetchAccountTheme = function(p2)
			local data = v7.getAndFetchItem(resolveLocalUserId(p2)).data(p2)
			local accountTheme = data and data.accountTheme
			return accountTheme and accountTheme.currentValue
		end,
		getAccountThemeStatus = function(p2)
			return v7.getCachedItem(resolveLocalUserId(p2)).status(p2)
		end,
		updateAccountTheme = function(p2)
			local currentUserId = localUserIdStore.getCurrentUserId(false)

			local data = v7.getCachedItem(resolveLocalUserId(false)).data(false)
			local accountTheme = data and data.accountTheme
			local currentValue = accountTheme and accountTheme.currentValue

			v6.updateItem(currentUserId, {
				accountTheme = { currentValue = p2 }
			})

			return userSettingsRequests.postUserSettings({ accountTheme = p2 }, v5):catch(function(p3)
				if localUserIdStore.getCurrentUserId(false) ~= currentUserId then
					return Promise.reject(p3)
				end

				if currentValue == nil then
					v7.fetchItem(resolveLocalUserId(false))
				else
					v6.updateItem(currentUserId, {
						accountTheme = { currentValue = currentValue }
					})
				end

				return Promise.reject(p3)
			end)
		end,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createUserSettingsStore
