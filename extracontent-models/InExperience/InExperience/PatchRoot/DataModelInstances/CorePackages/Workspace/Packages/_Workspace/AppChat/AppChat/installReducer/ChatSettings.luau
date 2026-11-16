local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)

local v = {
	retrievalStatus = RetrievalStatus.NotStarted,
	accountChatRetrieved = false,
	accountChatEnabled = false,
	chatEnabled = false,
	groupChatEnabled = false,
	privacySettingsEnabled = false,
	globalRulesEnabled = false,
	thirdPartyPrivacySettingsRetrieved = false,
	thirdPartyPrivacySettingsEnabled = false
}

local function checkRetrievals(data)
	if data.accountChatRetrieved and data.thirdPartyPrivacySettingsRetrieved then
		return Cryo.Dictionary.union(data, {
			chatEnabled = data.accountChatEnabled and data.thirdPartyPrivacySettingsEnabled,
			retrievalStatus = RetrievalStatus.Done
		})
	end

	return data
end

local function handleThirdPartyChatSettingsLoaded(p, p2)
	return checkRetrievals(Cryo.Dictionary.union(p, {
		thirdPartyPrivacySettingsRetrieved = p2.status ~= Enum.ChatRestrictionStatus.Unknown,
		thirdPartyPrivacySettingsEnabled = p2.status == Enum.ChatRestrictionStatus.NotRestricted
	}))
end

local function handleGetMetadataSucceeded(p, p2)
	local responseBody = p2.responseBody
	return checkRetrievals(Cryo.Dictionary.union(p, {
		accountChatRetrieved = true,
		chatUserMessagesEnabled = responseBody.isChatUserMessagesEnabled,
		accountChatEnabled = responseBody.isChatEnabled,
		groupChatEnabled = responseBody.isChatEnabled and responseBody.isGroupChatEnabledByPrivacySetting == "enabled",
		privacySettingsEnabled = responseBody.isChatEnabledByPrivacySetting == "enabled",
		globalRulesEnabled = responseBody.isChatEnabledByGlobalRules == "enabled"
	}))
end

return Rodux.createReducer(v, {
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded,
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = function(p, p2)
		return handleGetMetadataSucceeded(p, p2)
	end,
	Debug_GroupChatEnabledToggled = function(p, _)
		return Cryo.Dictionary.union(p, {
			groupChatEnabled = not p.groupChatEnabled
		})
	end
})
