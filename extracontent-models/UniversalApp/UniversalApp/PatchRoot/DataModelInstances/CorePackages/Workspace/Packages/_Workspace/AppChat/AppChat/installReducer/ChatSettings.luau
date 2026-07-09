local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local RetrievalStatus = require(AppChatParent.Http).Enum.RetrievalStatus
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local t1 = {
	accountChatRetrieved = false,
	accountChatEnabled = false,
	chatEnabled = false,
	groupChatEnabled = false,
	privacySettingsEnabled = false,
	globalRulesEnabled = false,
	thirdPartyPrivacySettingsRetrieved = false,
	thirdPartyPrivacySettingsEnabled = false,
	retrievalStatus = RetrievalStatus.NotStarted
}

local function checkRetrievals(t2: {[any]: any}) -- line: 35
	-- upvalues: Cryo (copy), RetrievalStatus (copy)
	if t2.accountChatRetrieved and t2.thirdPartyPrivacySettingsRetrieved then
		return Cryo.Dictionary.union(t2, {
			chatEnabled = t2.accountChatEnabled and t2.thirdPartyPrivacySettingsEnabled,
			retrievalStatus = RetrievalStatus.Done
		})
	end

	return t2
end
local function handleThirdPartyChatSettingsLoaded(t3: {[any]: any}, p1) -- line: 45
	-- upvalues: checkRetrievals (copy), Cryo (copy)
	return checkRetrievals(Cryo.Dictionary.union(t3, {
		thirdPartyPrivacySettingsRetrieved = p1.status ~= Enum.ChatRestrictionStatus.Unknown,
		thirdPartyPrivacySettingsEnabled = p1.status == Enum.ChatRestrictionStatus.NotRestricted
	}))
end
local function handleGetMetadataSucceeded(t4: {[any]: any}, p2) -- line: 52
	-- upvalues: checkRetrievals (copy), Cryo (copy)
	local responseBody = p2.responseBody

	return checkRetrievals(Cryo.Dictionary.union(t4, {
		accountChatRetrieved = true,
		chatUserMessagesEnabled = responseBody.isChatUserMessagesEnabled,
		accountChatEnabled = responseBody.isChatEnabled,
		groupChatEnabled = responseBody.isChatEnabled and responseBody.isGroupChatEnabledByPrivacySetting == "enabled",
		privacySettingsEnabled = responseBody.isChatEnabledByPrivacySetting == "enabled",
		globalRulesEnabled = responseBody.isChatEnabledByGlobalRules == "enabled"
	}))
end

return Rodux.createReducer(t1, {
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded,
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = function(t5: {[any]: any}, p3) -- line: 66
		-- upvalues: handleGetMetadataSucceeded (copy)
		return handleGetMetadataSucceeded(t5, p3)
	end,
	Debug_GroupChatEnabledToggled = function(t6: {[any]: any}, _) -- line: 70
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t6, {
			groupChatEnabled = not t6.groupChatEnabled
		})
	end
})
