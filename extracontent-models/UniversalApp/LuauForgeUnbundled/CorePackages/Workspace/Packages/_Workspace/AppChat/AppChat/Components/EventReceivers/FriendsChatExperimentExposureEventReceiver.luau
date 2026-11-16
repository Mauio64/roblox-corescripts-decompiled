local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local FStringAppChatFriendsTabIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatFriendsTabIxpLayer")
local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")
local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")

local fFlagExpChatFriendsTabUsePolicy = SharedFlags.FFlagExpChatFriendsTabUsePolicy
local fFlagExpChatFriendsTabRequireDefaultChannels = SharedFlags.FFlagExpChatFriendsTabRequireDefaultChannels
local fFlagFriendsChatHasFriendsGate = SharedFlags.FFlagFriendsChatHasFriendsGate

local Players = game:GetService("Players")

local getAppPolicyStore = if fFlagExpChatFriendsTabUsePolicy then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").GetAppPolicyStore else nil
local v5

if fFlagFriendsChatHasFriendsGate then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").Friends.FriendsStore.get()
else
	v5 = nil
end

local exposureHandler = IXPNavigationUtils.createExposureHandler(FStringAppChatFriendsTabIxpLayer)

local function FriendsChatExperimentExposureEventReceiver(): nil
	local v6 = GetFriendsChatSettingsStore(false)

	local v7 = React.useMemo(function()
		local TextChatService = game:GetService("TextChatService")
		return TextChatService.CreateDefaultTextChannels
	end, {})
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local v9 = not fFlagExpChatFriendsTabUsePolicy
				or getAppPolicyStore(false).getAppPolicy(p2).getCanSeeFriendsTab()
			local v10

			if fFlagFriendsChatHasFriendsGate then
				local localPlayer = Players.LocalPlayer

				if localPlayer then
					local friendsCount = v5.GetFriendsCountByUserId((tostring(localPlayer.UserId)))
					local v11 = if friendsCount then friendsCount.data(p2) else nil
					v10 = not (v11 == nil) and v11 > 0
				else
					v10 = false
				end
			else
				v10 = true
			end

			local v11 = v9 and v10 and v6.getChatEnabled(p2)

			if v11 then
				if v6.getChatUserMessagesEnabled(p2) == false then
					v11 = false
				else
					v11 = not fFlagExpChatFriendsTabRequireDefaultChannels or v7
				end
			end

			return v11
		end)
	end, { v6, v7 })
	local v9 = SignalsReact.useSignalState(v8)

	React.useEffect(function()
		if v9 then
			exposureHandler()
		end
	end, { v9 })

	return nil
end

return FriendsChatExperimentExposureEventReceiver
