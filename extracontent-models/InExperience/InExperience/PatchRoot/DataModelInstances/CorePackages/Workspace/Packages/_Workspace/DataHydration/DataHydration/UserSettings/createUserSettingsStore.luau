local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.Signals)

local Promise = require(DataHydrationParent.Promise)

require(DataHydrationParent.HttpClient)

local LocalUserIdStore = require(DataHydrationParent.LocalUserIdStore).LocalUserIdStore
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local userSettingsRequests = require(script.Parent.userSettingsRequests)

require(script.Parent.UserSettingsStoreTypes)

local function resolveLocalUserId(p1) -- line: 29
	-- upvalues: LocalUserIdStore (copy)
	return LocalUserIdStore.getCurrentUserId(p1)
end
local function createUserSettingsStore(t1: {[any]: any}?) -- line: 33
	-- upvalues: createDataCache (copy), createDataResolver (copy), userSettingsRequests (copy), resolveLocalUserId (copy), LocalUserIdStore (copy), Promise (copy)
	local t2 = {
		network = (t1 or {}).network
	}
	local v13 = createDataCache()
	local v14 = createDataResolver({
		supportsMultiGet = false,
		cache = v13,
		fetchFn = function(_: string, _) -- line: 41
			-- upvalues: userSettingsRequests (copy), t2 (copy)
			return userSettingsRequests.fetchSettingsAndOptions(t2)
		end
	})

	local function writeAccountThemeToCache(s2: string, s3: string) -- line: 74
		-- upvalues: v13 (copy)
		v13.updateItem(s2, {
			accountTheme = {
				currentValue = s3
			}
		})
	end

	return {
		getAndFetchUserSettings = function(p3) -- line: 46
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			return v14.getAndFetchItem(resolveLocalUserId(p3))
		end,
		getUserSettings = function(p4) -- line: 50
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			return v14.getCachedItem(resolveLocalUserId(p4))
		end,
		fetchUserSettings = function() -- line: 54
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			return v14.fetchItem(resolveLocalUserId(false))
		end,
		getAccountTheme = function(p5) -- line: 58
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			local v21 = v14.getCachedItem(resolveLocalUserId(p5)).data(p5)
			local v22 = v21 and v21.accountTheme

			return v22 and v22.currentValue
		end,
		getAndFetchAccountTheme = function(p6) -- line: 64
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			local v24 = v14.getAndFetchItem(resolveLocalUserId(p6)).data(p6)
			local v25 = v24 and v24.accountTheme

			return v25 and v25.currentValue
		end,
		getAccountThemeStatus = function(p7) -- line: 70
			-- upvalues: v14 (copy), resolveLocalUserId (copy)
			return v14.getCachedItem(resolveLocalUserId(p7)).status(p7)
		end,
		updateAccountTheme = function(s4: string) -- line: 82
			-- upvalues: LocalUserIdStore (copy), v14 (copy), resolveLocalUserId (copy), v13 (copy), userSettingsRequests (copy), t2 (copy), Promise (copy)
			local v30 = LocalUserIdStore.getCurrentUserId(false)
			local v31 = v14.getCachedItem(resolveLocalUserId(false)).data(false)
			local v32 = v31 and v31.accountTheme
			local v33 = v32 and v32.currentValue

			v13.updateItem(v30, {
				accountTheme = {
					currentValue = s4
				}
			})

			return userSettingsRequests.postUserSettings({
				accountTheme = s4
			}, t2):catch(function(p8) -- line: 92
				-- upvalues: LocalUserIdStore (copy), v30 (copy), Promise (copy), v33 (copy), v13 (copy), v14 (copy), resolveLocalUserId (copy)
				if LocalUserIdStore.getCurrentUserId(false) ~= v30 then
					return Promise.reject(p8)
				end

				if v33 ~= nil then
					local v35 = v30
					local v36 = v33

					v13.updateItem(v35, {
						accountTheme = {
							currentValue = v36
						}
					})
				else
					v14.fetchItem(resolveLocalUserId(false))
				end

				return Promise.reject(p8)
			end)
		end,
		clear = v14.clear,
		dispose = v14.dispose
	}
end

return createUserSettingsStore
