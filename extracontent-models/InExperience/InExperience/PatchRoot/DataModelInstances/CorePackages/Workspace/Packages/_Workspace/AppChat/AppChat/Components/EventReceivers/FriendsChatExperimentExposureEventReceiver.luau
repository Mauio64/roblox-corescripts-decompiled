local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local FStringAppChatFriendsTabIxpLayer = require(AppChat.Flags.FStringAppChatFriendsTabIxpLayer)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)

local FFlagExpChatFriendsTabUsePolicy = SharedFlags.FFlagExpChatFriendsTabUsePolicy
local FFlagExpChatFriendsTabRequireDefaultChannels = SharedFlags.FFlagExpChatFriendsTabRequireDefaultChannels
local FFlagFriendsChatHasFriendsGate = SharedFlags.FFlagFriendsChatHasFriendsGate

local Players = game:GetService("Players")
local getAppPolicyStore

if FFlagExpChatFriendsTabUsePolicy then
	local UniversalAppPolicy = require(parent.UniversalAppPolicy)
	getAppPolicyStore = UniversalAppPolicy.GetAppPolicyStore
else
	getAppPolicyStore = nil
end

local v

if FFlagFriendsChatHasFriendsGate then
	local DataHydration = require(parent.DataHydration)
	v = DataHydration.Friends.FriendsStore.get()
else
	v = nil
end

local exposureHandler = IXPNavigationUtils.createExposureHandler(FStringAppChatFriendsTabIxpLayer)

local function FriendsChatExperimentExposureEventReceiver(): nil
	local friendsChatSettingsStore = GetFriendsChatSettingsStore(false)

	local v2 = React.useMemo(function()
		local TextChatService = game:GetService("TextChatService")
		return TextChatService.CreateDefaultTextChannels
	end, {})
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v3 = not FFlagExpChatFriendsTabUsePolicy
				or getAppPolicyStore(false).getAppPolicy(p).getCanSeeFriendsTab()
			local v4

			if FFlagFriendsChatHasFriendsGate then
				local localPlayer = Players.LocalPlayer

				if localPlayer then
					local friendsCount = v.GetFriendsCountByUserId((tostring(localPlayer.UserId)))
					local v5

					if friendsCount then
						v5 = friendsCount.data(p)
					end

					if v5 == nil then
						v4 = false
					else
						v4 = v5 > 0
					end
				else
					v4 = false
				end
			else
				v4 = true
			end

			local v5 = v3 and v4 and friendsChatSettingsStore.getChatEnabled(p)

			if v5 then
				if friendsChatSettingsStore.getChatUserMessagesEnabled(p) == false then
					return false
				end

				return not FFlagExpChatFriendsTabRequireDefaultChannels or v2
			end

			return v5
		end)
	end, { friendsChatSettingsStore, v2 })
	local v4 = SignalsReact.useSignalState(v3)

	React.useEffect(function()
		if v4 then
			exposureHandler()
		end
	end, { v4 })

	return nil
end

return FriendsChatExperimentExposureEventReceiver
