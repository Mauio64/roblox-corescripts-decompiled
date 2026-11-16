local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function createFriendsChatSettingsStore()
	local friendsChatMetadataStore = GetFriendsChatMetadataStore(false)

	local signal, v2 = Signals.createSignal(Enum.ChatRestrictionStatus.Unknown)

	local signal2, v3 = Signals.createSignal(nil)
	local signal3, v4 = Signals.createSignal(false)

	local function setThirdPartyChatRestrictionStatus(p)
		v2(p)

		if p ~= Enum.ChatRestrictionStatus.Unknown then
			v3(p)
		elseif friendsChatMetadataStore.getCachedFriendsChatMetadata(false).data(false) == nil then
			v3(nil)
		end
	end

	local function toggleDebugGroupChatEnabled()
		v4(not signal3(false))
	end

	local function clearDebugGroupChatToggle()
		v4(false)
	end

	local function reset()
		v2(Enum.ChatRestrictionStatus.Unknown)
		v3(nil)
		v4(false)
	end

	local getChatEnabled = Signals.createComputed(function(p): boolean
		local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)
		local v5 = signal(p)
		v5 = FFlagAppChatUseSignalsForChatSettings and v5 == Enum.ChatRestrictionStatus.Unknown and signal2(p) or v5

		return data ~= nil
			and v5 ~= Enum.ChatRestrictionStatus.Unknown
			and data.isChatEnabled == true
			and v5 == Enum.ChatRestrictionStatus.NotRestricted
	end)

	local getGroupChatEnabled = Signals.createComputed(function(p): boolean
		local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)

		return (data ~= nil and data.isChatEnabled == true and data.isGroupChatEnabledByPrivacySetting == "enabled") ~= signal3(p)
	end)

	local getChatUserMessagesEnabled = Signals.createComputed(function(p)
		local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)
		return if data then data.isChatUserMessagesEnabled else nil
	end)

	return {
		getThirdPartyChatRestrictionStatus = signal,
		getChatEnabled = getChatEnabled,
		getGroupChatEnabled = getGroupChatEnabled,
		getChatUserMessagesEnabled = getChatUserMessagesEnabled,
		getRetrievalStatus = Signals.createComputed(function(p)
			if friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p) == nil or signal2(p) == nil then
				return RetrievalStatus.NotStarted
			end

			return RetrievalStatus.Done
		end),
		getPrivacySettingsEnabled = Signals.createComputed(function(p): boolean
			local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)
			return data ~= nil and data.isChatEnabledByPrivacySetting == "enabled"
		end),
		getGlobalRulesEnabled = Signals.createComputed(function(p): boolean
			local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)
			return data ~= nil and data.isChatEnabledByGlobalRules == "enabled"
		end),
		getThirdPartyPrivacySettingsEnabled = Signals.createComputed(function(p): boolean
			return signal(p) == Enum.ChatRestrictionStatus.NotRestricted
		end),
		setThirdPartyChatRestrictionStatus = setThirdPartyChatRestrictionStatus,
		toggleDebugGroupChatEnabled = toggleDebugGroupChatEnabled,
		clearDebugGroupChatToggle = clearDebugGroupChatToggle,
		reset = reset,
		dispose = not SharedFlags.FFlagDebugFriendsChat and function() end or Signals.createEffect(function(p)
			local data = friendsChatMetadataStore.getCachedFriendsChatMetadata(p).data(p)

			local formatted = `Friends Chat eligibility: chatEnabled={tostring(getChatEnabled(p))}`
			local v5

			if data then
				v5 = data.isChatEnabled
			end

			local formatted2 = ` (accountChatEnabled={tostring(v5)},`
			local v6

			if data then
				v6 = data.isChatEnabledByPrivacySetting
			end

			local formatted3 = ` privacySetting={tostring(v6)},`
			local v7

			if data then
				v7 = data.isChatEnabledByGlobalRules
			end

			v:debug(formatted .. formatted2 .. formatted3 .. ` globalRules={tostring(v7)},` .. ` thirdPartyStatus={tostring(signal(p))});` .. ` chatUserMessagesEnabled={tostring(getChatUserMessagesEnabled(p))}`)
		end)
	}
end

return createFriendsChatSettingsStore
