local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local FStringAppChatFriendsTabIxpLayer = require(AppChat.Flags.FStringAppChatFriendsTabIxpLayer)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
local v8 = require(AppChat.Utils.IXPNavigationUtils).createExposureHandler(FStringAppChatFriendsTabIxpLayer)

local function FriendsChatExperimentExposureEventReceiver() -- line: 14
	-- upvalues: GetFriendsChatSettingsStore (copy), React (copy), Signals (copy), SignalsReact (copy), v8 (copy)
	local v10 = GetFriendsChatSettingsStore(false)
	local v11 = React.useMemo(function() -- line: 16
		-- upvalues: Signals (copy), v10 (copy)
		return Signals.createComputed(function(p1) -- line: 17
			-- upvalues: v10 (copy)
			return v10.getChatEnabled(p1) and v10.getChatUserMessagesEnabled(p1) ~= false
		end)
	end, { v10 })
	local v12 = SignalsReact.useSignalState(v11)

	React.useEffect(function() -- line: 24
		-- upvalues: v12 (copy), v8 (copy)
		if v12 then
			v8()
		end
	end, { v12 })

	return nil
end

return FriendsChatExperimentExposureEventReceiver
