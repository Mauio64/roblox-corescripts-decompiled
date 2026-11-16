local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.Signals)
local Promise = require(parent.Promise)
require(parent.HttpClient)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local userSettingsRequests = require(script.Parent.userSettingsRequests)
require(script.Parent.UserSettingsStoreTypes)

local function resolveLocalUserId(p) -- 2 equivalent calls inferred from this helper
	return localUserIdStore.getCurrentUserId(p)
end

local function createUserSettingsStore(options)
	local v = {
		network = (options or {}).network
	}

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(_: string, _)
			return userSettingsRequests.fetchSettingsAndOptions(v)
		end
	})

	local function getAndFetchUserSettings(p) -- 1 equivalent call inferred from this helper
		return dataResolver.getAndFetchItem(resolveLocalUserId(p))
	end

	local function getUserSettings(p) -- 2 equivalent calls inferred from this helper
		return dataResolver.getCachedItem(resolveLocalUserId(p))
	end

	local function fetchUserSettings() -- 1 equivalent call inferred from this helper
		return dataResolver.fetchItem(resolveLocalUserId(false))
	end

	local function getAccountTheme(p) -- 1 equivalent call inferred from this helper
		local data = getUserSettings(p).data(p) -- inferred equivalent call
		local accountTheme = data and data.accountTheme
		return accountTheme and accountTheme.currentValue
	end

	local function getAndFetchAccountTheme(p)
		local data = getAndFetchUserSettings(p).data(p) -- inferred equivalent call
		local accountTheme = data and data.accountTheme
		return accountTheme and accountTheme.currentValue
	end

	local function getAccountThemeStatus(p)
		return getUserSettings(p).status(p) -- inferred equivalent call
	end

	local function writeAccountThemeToCache(localUserId: string, currentValue: string) -- 2 equivalent calls inferred from this helper
		dataCache.updateItem(localUserId, {
			accountTheme = { currentValue = currentValue }
		})
	end

	local function updateAccountTheme(accountTheme2: string)
		local localUserId = resolveLocalUserId(false) -- inferred equivalent call
		local accountTheme = getAccountTheme(false) -- inferred equivalent call
		writeAccountThemeToCache(localUserId, accountTheme2) -- inferred equivalent call
		return userSettingsRequests.postUserSettings({ accountTheme = accountTheme2 }, v):catch(function(p)
			if resolveLocalUserId(false) ~= localUserId then -- inferred equivalent call
				return Promise.reject(p)
			end

			if accountTheme == nil then
				fetchUserSettings() -- inferred equivalent call
			else
				writeAccountThemeToCache(localUserId, accountTheme) -- inferred equivalent call
			end

			return Promise.reject(p)
		end)
	end

	return {
		getAndFetchUserSettings = getAndFetchUserSettings,
		getUserSettings = getUserSettings,
		fetchUserSettings = fetchUserSettings,
		getAccountTheme = getAccountTheme,
		getAndFetchAccountTheme = getAndFetchAccountTheme,
		getAccountThemeStatus = getAccountThemeStatus,
		updateAccountTheme = updateAccountTheme,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createUserSettingsStore
