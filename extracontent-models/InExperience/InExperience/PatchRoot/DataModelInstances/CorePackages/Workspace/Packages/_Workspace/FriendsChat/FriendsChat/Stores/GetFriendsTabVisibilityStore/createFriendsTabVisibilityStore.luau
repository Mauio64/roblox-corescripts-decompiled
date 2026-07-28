local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local GetFriendsChatSettingsStore = require(Parent.AppChat.GetFriendsChatSettingsStore)

local function createFriendsTabVisibilityStore() -- line: 12
	-- upvalues: GetFriendsChatSettingsStore (copy), Signals (copy)
	local v5 = GetFriendsChatSettingsStore(false)

	return {
		getIsFriendsTabVisible = Signals.createComputed(function(p1) -- line: 15
			-- upvalues: v5 (copy)
			return v5.getChatEnabled(p1) and v5.getChatUserMessagesEnabled(p1) ~= false
		end)
	}
end

return createFriendsTabVisibilityStore
