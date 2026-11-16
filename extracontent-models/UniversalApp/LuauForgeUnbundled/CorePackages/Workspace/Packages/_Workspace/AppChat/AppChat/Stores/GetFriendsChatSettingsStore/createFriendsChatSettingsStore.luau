local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").Enum.RetrievalStatus
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetFriendsChatMetadataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatMetadataStore")
local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createFriendsChatSettingsStore")

local function createFriendsChatSettingsStore()
	local v6 = GetFriendsChatMetadataStore(false)

	local signal, v7 = Signals.createSignal(Enum.ChatRestrictionStatus.Unknown)

	local signal2, v8 = Signals.createSignal(nil)
	local signal3, v9 = Signals.createSignal(false)

	local function setThirdPartyChatRestrictionStatus(p2)
		v7(p2)

		if p2 ~= Enum.ChatRestrictionStatus.Unknown then
			v8(p2)
		elseif v6.getCachedFriendsChatMetadata(false).data(false) == nil then
			v8(nil)
		end
	end

	local function toggleDebugGroupChatEnabled()
		v9(not signal3(false))
	end

	local function clearDebugGroupChatToggle()
		v9(false)
	end

	local function reset()
		v7(Enum.ChatRestrictionStatus.Unknown)
		v8(nil)
		v9(false)
	end

	local computed = Signals.createComputed(function(p2): boolean
		local data = v6.getCachedFriendsChatMetadata(p2).data(p2)
		local v10 = signal(p2)
		v10 = FFlagAppChatUseSignalsForChatSettings and v10 == Enum.ChatRestrictionStatus.Unknown and signal2(p2) or v10

		return data ~= nil
			and v10 ~= Enum.ChatRestrictionStatus.Unknown
			and data.isChatEnabled == true
			and v10 == Enum.ChatRestrictionStatus.NotRestricted
	end)

	local computed2 = Signals.createComputed(function(p2): boolean
		local data = v6.getCachedFriendsChatMetadata(p2).data(p2)

		return (data ~= nil and data.isChatEnabled == true and data.isGroupChatEnabledByPrivacySetting == "enabled") ~= signal3(p2)
	end)

	local computed3 = Signals.createComputed(function(p2)
		local data = v6.getCachedFriendsChatMetadata(p2).data(p2)

		if data then
			return data.isChatUserMessagesEnabled
		end

		return nil
	end)

	return {
		getThirdPartyChatRestrictionStatus = signal,
		getChatEnabled = computed,
		getGroupChatEnabled = computed2,
		getChatUserMessagesEnabled = computed3,
		getRetrievalStatus = Signals.createComputed(function(p2)
			if v6.getCachedFriendsChatMetadata(p2).data(p2) == nil or signal2(p2) == nil then
				return retrievalStatus.NotStarted
			end

			return retrievalStatus.Done
		end),
		getPrivacySettingsEnabled = Signals.createComputed(function(p2): boolean
			local data = v6.getCachedFriendsChatMetadata(p2).data(p2)
			return data ~= nil and data.isChatEnabledByPrivacySetting == "enabled"
		end),
		getGlobalRulesEnabled = Signals.createComputed(function(p2): boolean
			local data = v6.getCachedFriendsChatMetadata(p2).data(p2)
			return data ~= nil and data.isChatEnabledByGlobalRules == "enabled"
		end),
		getThirdPartyPrivacySettingsEnabled = Signals.createComputed(function(p2): boolean
			return signal(p2) == Enum.ChatRestrictionStatus.NotRestricted
		end),
		setThirdPartyChatRestrictionStatus = setThirdPartyChatRestrictionStatus,
		toggleDebugGroupChatEnabled = toggleDebugGroupChatEnabled,
		clearDebugGroupChatToggle = clearDebugGroupChatToggle,
		reset = reset,
		dispose = not SharedFlags.FFlagDebugFriendsChat and function() end or Signals.createEffect(function(p2)
			local data = v6.getCachedFriendsChatMetadata(p2).data(p2)

			local formatted = `Friends Chat eligibility: chatEnabled={tostring(computed(p2))}`
			local v12 = if data then data.isChatEnabled else nil
			local formatted2 = ` (accountChatEnabled={tostring(v12)},`
			local v14 = if data then data.isChatEnabledByPrivacySetting else nil
			local formatted3 = ` privacySetting={tostring(v14)},`
			local v16 = if data then data.isChatEnabledByGlobalRules else nil
			v5:debug(formatted .. formatted2 .. formatted3 .. ` globalRules={tostring(v16)},` .. ` thirdPartyStatus={tostring(signal(p2))});` .. ` chatUserMessagesEnabled={tostring(computed3(p2))}`)
		end)
	}
end

return createFriendsChatSettingsStore
