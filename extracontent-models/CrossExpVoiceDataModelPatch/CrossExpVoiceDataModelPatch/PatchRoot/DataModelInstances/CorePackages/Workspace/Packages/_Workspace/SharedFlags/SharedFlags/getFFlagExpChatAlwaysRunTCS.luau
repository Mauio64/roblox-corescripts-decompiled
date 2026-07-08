local Chat = game:GetService("Chat")

game:DefineFastFlag("DebugExpChatAlwaysRunTCS", false)

local v2 = game:DefineFastFlag("ExpChatMigrationReplicationFix", false)
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local IsAutoMigrated = Chat.IsAutoMigrated

if game:GetService("RunService"):IsServer() then
	RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)
	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function() -- line: 17
		-- upvalues: RobloxReplicatedStorage (copy), Chat (copy), IsAutoMigrated (ref)
		RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)
		IsAutoMigrated = Chat.IsAutoMigrated
	end)
else
	IsAutoMigrated = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
	RobloxReplicatedStorage:GetAttributeChangedSignal("ChatMigratedToExpChat"):Connect(function() -- line: 23
		-- upvalues: IsAutoMigrated (ref), RobloxReplicatedStorage (copy), Chat (copy)
		IsAutoMigrated = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
		Chat.IsAutoMigrated = IsAutoMigrated
	end)
end

local function IsChatAutoMigrated() -- line: 29
	-- upvalues: v2 (copy), Chat (copy), IsAutoMigrated (ref)
	if game:GetEngineFeature("ChatServiceCompatibilityForAll") then
		return true
	end

	if v2 and game:GetEngineFeature("TCSMigrationReplicationFix") then
		return Chat.IsAutoMigrated
	end

	return IsAutoMigrated
end

return function() -- line: 41
	-- upvalues: v2 (copy), Chat (copy), IsAutoMigrated (ref)
	return not not game:GetEngineFeature("ChatServiceCompatibilityForAll") or (if not v2 or not game:GetEngineFeature("TCSMigrationReplicationFix") then IsAutoMigrated else Chat.IsAutoMigrated) or game:GetFastFlag("DebugExpChatAlwaysRunTCS")
end
