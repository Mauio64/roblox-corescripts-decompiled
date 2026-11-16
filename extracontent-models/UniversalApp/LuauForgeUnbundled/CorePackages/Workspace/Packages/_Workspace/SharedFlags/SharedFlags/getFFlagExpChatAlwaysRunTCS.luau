local Chat = game:GetService("Chat")
game:DefineFastFlag("DebugExpChatAlwaysRunTCS", false)

local defineFastFlag = game:DefineFastFlag("ExpChatMigrationReplicationFix", false)

local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local v5 = Chat.IsAutoMigrated

local RunService = game:GetService("RunService")

if RunService:IsServer() then
	RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)

	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function()
		RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)
		v5 = Chat.IsAutoMigrated
	end)
else
	v5 = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
	RobloxReplicatedStorage:GetAttributeChangedSignal("ChatMigratedToExpChat"):Connect(function()
		v5 = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
		Chat.IsAutoMigrated = v5
	end)
end

local function IsChatAutoMigrated()
	if game:GetEngineFeature("ChatServiceCompatibilityForAll") then
		return true
	end

	if defineFastFlag and game:GetEngineFeature("TCSMigrationReplicationFix") then
		return Chat.IsAutoMigrated
	end

	return v5
end

return function()
	local v6

	if game:GetEngineFeature("ChatServiceCompatibilityForAll") then
		v6 = true
	elseif defineFastFlag and game:GetEngineFeature("TCSMigrationReplicationFix") then
		v6 = Chat.IsAutoMigrated
	else
		v6 = v5
	end

	return v6 or game:GetFastFlag("DebugExpChatAlwaysRunTCS")
end
