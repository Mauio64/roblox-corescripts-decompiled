local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").Enum.RetrievalStatus
local ThirdPartyChatSettingsLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/ThirdPartyChatSettingsLoaded")

local v5 = {
	retrievalStatus = retrievalStatus.NotStarted,
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
			retrievalStatus = retrievalStatus.Done
		})
	end

	return data
end

local function handleThirdPartyChatSettingsLoaded(p2, p3)
	return checkRetrievals(Cryo.Dictionary.union(p2, {
		thirdPartyPrivacySettingsRetrieved = p3.status ~= Enum.ChatRestrictionStatus.Unknown,
		thirdPartyPrivacySettingsEnabled = p3.status == Enum.ChatRestrictionStatus.NotRestricted
	}))
end

local function handleGetMetadataSucceeded(p2, p3)
	local responseBody = p3.responseBody
	return checkRetrievals(Cryo.Dictionary.union(p2, {
		accountChatRetrieved = true,
		chatUserMessagesEnabled = responseBody.isChatUserMessagesEnabled,
		accountChatEnabled = responseBody.isChatEnabled,
		groupChatEnabled = responseBody.isChatEnabled and responseBody.isGroupChatEnabledByPrivacySetting == "enabled",
		privacySettingsEnabled = responseBody.isChatEnabledByPrivacySetting == "enabled",
		globalRulesEnabled = responseBody.isChatEnabledByGlobalRules == "enabled"
	}))
end

return Rodux.createReducer(v5, {
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded,
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = function(p2, p3)
		return handleGetMetadataSucceeded(p2, p3)
	end,
	Debug_GroupChatEnabledToggled = function(p2, p3)
		return Cryo.Dictionary.union(p2, {
			groupChatEnabled = not p2.groupChatEnabled
		})
	end
})
