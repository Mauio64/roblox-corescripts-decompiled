local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.Signals)

local Promise = require(DataHydrationParent.Promise)
local UserLib = require(DataHydrationParent.UserLib)

require(DataHydrationParent.HttpClient)

local LocalUserIdStore = UserLib.Stores.LocalUserIdStore
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local userSettingsRequests = require(script.Parent.userSettingsRequests)

require(script.Parent.UserSettingsStoreTypes)

local function resolveLocalUserId(p1) -- line: 30
	-- upvalues: LocalUserIdStore (copy)
	return LocalUserIdStore.getCurrentUserId(p1)
end
local function createUserSettingsStore(t1: {[any]: any}?) -- line: 34
	-- upvalues: createDataCache (copy), createDataResolver (copy), userSettingsRequests (copy), resolveLocalUserId (copy), LocalUserIdStore (copy), Promise (copy)
	local t2 = {
		network = (t1 or {}).network
	}
	local v14 = createDataCache()
	local v15 = createDataResolver({
		supportsMultiGet = false,
		cache = v14,
		fetchFn = function(_: string, _) -- line: 42
			-- upvalues: userSettingsRequests (copy), t2 (copy)
			return userSettingsRequests.fetchSettingsAndOptions(t2)
		end
	})

	local function writeAccountThemeToCache(s2: string, s3: string) -- line: 75
		-- upvalues: v14 (copy)
		v14.updateItem(s2, {
			accountTheme = {
				currentValue = s3
			}
		})
	end

	return {
		getAndFetchUserSettings = function(p3) -- line: 47
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			return v15.getAndFetchItem(resolveLocalUserId(p3))
		end,
		getUserSettings = function(p4) -- line: 51
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			return v15.getCachedItem(resolveLocalUserId(p4))
		end,
		fetchUserSettings = function() -- line: 55
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			return v15.fetchItem(resolveLocalUserId(false))
		end,
		getAccountTheme = function(p5) -- line: 59
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			local v22 = v15.getCachedItem(resolveLocalUserId(p5)).data(p5)
			local v23 = v22 and v22.accountTheme

			return v23 and v23.currentValue
		end,
		getAndFetchAccountTheme = function(p6) -- line: 65
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			local v25 = v15.getAndFetchItem(resolveLocalUserId(p6)).data(p6)
			local v26 = v25 and v25.accountTheme

			return v26 and v26.currentValue
		end,
		getAccountThemeStatus = function(p7) -- line: 71
			-- upvalues: v15 (copy), resolveLocalUserId (copy)
			return v15.getCachedItem(resolveLocalUserId(p7)).status(p7)
		end,
		updateAccountTheme = function(s4: string) -- line: 83
			-- upvalues: LocalUserIdStore (copy), v15 (copy), resolveLocalUserId (copy), v14 (copy), userSettingsRequests (copy), t2 (copy), Promise (copy)
			local v31 = LocalUserIdStore.getCurrentUserId(false)
			local v32 = v15.getCachedItem(resolveLocalUserId(false)).data(false)
			local v33 = v32 and v32.accountTheme
			local v34 = v33 and v33.currentValue

			v14.updateItem(v31, {
				accountTheme = {
					currentValue = s4
				}
			})

			return userSettingsRequests.postUserSettings({
				accountTheme = s4
			}, t2):catch(function(p8) -- line: 93
				-- upvalues: LocalUserIdStore (copy), v31 (copy), Promise (copy), v34 (copy), v14 (copy), v15 (copy), resolveLocalUserId (copy)
				if LocalUserIdStore.getCurrentUserId(false) ~= v31 then
					return Promise.reject(p8)
				end

				if v34 ~= nil then
					local v36 = v31
					local v37 = v34

					v14.updateItem(v36, {
						accountTheme = {
							currentValue = v37
						}
					})
				else
					v15.fetchItem(resolveLocalUserId(false))
				end

				return Promise.reject(p8)
			end)
		end,
		clear = v15.clear,
		dispose = v15.dispose
	}
end

return createUserSettingsStore
