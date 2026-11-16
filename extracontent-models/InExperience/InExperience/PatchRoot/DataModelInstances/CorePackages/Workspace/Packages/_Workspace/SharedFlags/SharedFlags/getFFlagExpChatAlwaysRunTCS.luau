local Chat = game:GetService("Chat")
game:DefineFastFlag("DebugExpChatAlwaysRunTCS", false)

local defineFastFlag = game:DefineFastFlag("ExpChatMigrationReplicationFix", false)

local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local isAutoMigrated = Chat.IsAutoMigrated

local RunService = game:GetService("RunService")

if RunService:IsServer() then
	RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)

	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function()
		RobloxReplicatedStorage:SetAttribute("ChatMigratedToExpChat", Chat.IsAutoMigrated)
		isAutoMigrated = Chat.IsAutoMigrated
	end)
else
	isAutoMigrated = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
	RobloxReplicatedStorage:GetAttributeChangedSignal("ChatMigratedToExpChat"):Connect(function()
		isAutoMigrated = RobloxReplicatedStorage:GetAttribute("ChatMigratedToExpChat") == true
		Chat.IsAutoMigrated = isAutoMigrated
	end)
end

local function IsChatAutoMigrated() -- 1 equivalent call inferred from this helper
	if game:GetEngineFeature("ChatServiceCompatibilityForAll") then
		return true
	end

	if defineFastFlag and game:GetEngineFeature("TCSMigrationReplicationFix") then
		return Chat.IsAutoMigrated
	end

	return isAutoMigrated
end

return function()
	return IsChatAutoMigrated() or game:GetFastFlag("DebugExpChatAlwaysRunTCS") -- inferred equivalent call
end
