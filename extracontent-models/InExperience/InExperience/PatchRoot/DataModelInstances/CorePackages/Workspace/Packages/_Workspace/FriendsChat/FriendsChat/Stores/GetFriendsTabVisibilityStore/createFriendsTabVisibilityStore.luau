local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)

local GetFriendsChatSettingsStore = require(parent.AppChat.GetFriendsChatSettingsStore)
local getLocalUserId = require(script.Parent.Parent.Parent.Utils.getLocalUserId)
local FFlagExpChatFriendsRespectWindowEnabled = require(FriendsChat.Flags.FFlagExpChatFriendsRespectWindowEnabled)

local FFlagExpChatFriendsTabUsePolicy = SharedFlags.FFlagExpChatFriendsTabUsePolicy
local FFlagExpChatCanShowFriendsTab = SharedFlags.FFlagExpChatCanShowFriendsTab
local FFlagExpChatFriendsTabRequireDefaultChannels = SharedFlags.FFlagExpChatFriendsTabRequireDefaultChannels
local FFlagFriendsChatHasFriendsGate = SharedFlags.FFlagFriendsChatHasFriendsGate

local TextChatService = game:GetService("TextChatService")
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

local function createFriendsTabVisibilityStore()
	local friendsChatSettingsStore = GetFriendsChatSettingsStore(false)

	local createDefaultTextChannels = TextChatService.CreateDefaultTextChannels

	local enabledChangedConnection = nil
	local v2

	if FFlagExpChatFriendsRespectWindowEnabled then
		local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
		local v3
		v2, v3 = Signals.createSignal(chatWindowConfiguration == nil or chatWindowConfiguration.Enabled)

		if chatWindowConfiguration then
			enabledChangedConnection = chatWindowConfiguration:GetPropertyChangedSignal("Enabled"):Connect(function()
				v3(chatWindowConfiguration.Enabled)
			end)
		end
	else
		v2 = nil
	end

	return {
		getIsFriendsTabVisible = Signals.createComputed(function(p)
			if FFlagExpChatFriendsRespectWindowEnabled and not v2(p) then
				return false
			end

			local v3 = not FFlagExpChatFriendsTabUsePolicy
				or getAppPolicyStore(false).getAppPolicy(p).getCanSeeFriendsTab()
			local v4

			if FFlagFriendsChatHasFriendsGate and FFlagExpChatCanShowFriendsTab then
				local localUserId = getLocalUserId()

				if localUserId == nil then
					v4 = false
				else
					local friendsCount = v.GetFriendsCountByUserId((tostring(localUserId)))
					local v5

					if friendsCount then
						v5 = friendsCount.data(p)
					end

					if v5 == nil then
						v4 = false
					else
						v4 = v5 > 0
					end
				end
			else
				v4 = true
			end

			local v5 = FFlagExpChatCanShowFriendsTab and v3 and v4 and friendsChatSettingsStore.getChatEnabled(p)

			if v5 then
				if friendsChatSettingsStore.getChatUserMessagesEnabled(p) == false then
					return false
				end

				return not FFlagExpChatFriendsTabRequireDefaultChannels or createDefaultTextChannels
			end

			return v5
		end),
		dispose = function()
			if enabledChangedConnection then
				enabledChangedConnection:Disconnect()
				enabledChangedConnection = nil
			end
		end
	}
end

return createFriendsTabVisibilityStore
