local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local DataHydration = require(AppChatParent.DataHydration)

require(AppChatParent.Signals)

local UserLib = require(AppChatParent.UserLib)
local v6 = require(AppChat.Logger):new(script.Name)

local function resolveLocalUserId(p1) -- line: 24
	-- upvalues: UserLib (copy)
	return UserLib.Stores.LocalUserIdStore.getCurrentUserId(p1)
end
local function createFriendsChatMetadataStore() -- line: 28
	-- upvalues: DataHydration (copy), AppChatNetworking (copy), v6 (copy), resolveLocalUserId (copy), UserLib (copy)
	local v10 = DataHydration.createDataCache()
	local v11 = DataHydration.createDataResolver({
		supportsMultiGet = false,
		cache = v10,
		fetchFn = function(_: string) -- line: 33
			-- upvalues: AppChatNetworking (copy)
			return AppChatNetworking.http.GetMetadata():andThen(function(p2) -- line: 34
				return p2.responseBody
			end)
		end,
		logError = function(p3) -- line: 38
			-- upvalues: v6 (copy)
			v6:warning(`Failed to fetch Friends Chat metadata: { tostring(p3) }`)
		end
	})

	return {
		getFriendsChatMetadata = function(p4) -- line: 43
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.getAndFetchItem(resolveLocalUserId(p4))
		end,
		getCachedFriendsChatMetadata = function(p5) -- line: 47
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.getCachedItem(resolveLocalUserId(p5))
		end,
		fetchFriendsChatMetadata = function() -- line: 51
			-- upvalues: v11 (copy), resolveLocalUserId (copy)
			return v11.fetchItem(resolveLocalUserId(false))
		end,
		updateFriendsChatMetadata = function(p6) -- line: 55
			-- upvalues: v10 (copy), UserLib (copy)
			v10.replaceItem(UserLib.Stores.LocalUserIdStore.getCurrentUserId(false), p6)
		end,
		clear = v11.clear,
		dispose = v11.dispose
	}
end

return createFriendsChatMetadataStore
