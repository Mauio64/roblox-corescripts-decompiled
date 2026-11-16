local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local parent = script:FindFirstAncestor("ExpChatServer").Parent
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local markTextChannelAsDefault = ExpChatShared.markTextChannelAsDefault

local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local function canUsersTalkToEachOther(userId: number, p: number) -- 1 equivalent call inferred from this helper
	if userId == p then
		return false
	end

	local success, result = pcall(function()
		return TextChatService:CanUsersWhisperAsync(userId, p)
	end)

	local v2 = success and result
	v:debug("CanUsersChat: {}", (tostring(v2)))

	return v2
end

local function whisperChannelAlreadyExists(p: number, p2: number)
	local v2 = p < p2 and p or p2
	p2 = p2 < p and p or p2
	local v3 = string.format("RBXWhisper:%d_%d", v2, p2)

	return (TextChatService:FindFirstChild("TextChannels") or TextChatService):FindFirstChild(v3)
end

local function createWhisperChannel(userId: number, p: number)
	local name = string.format("RBXWhisper:%d_%d", userId < p and userId or p, p < userId and userId or p)

	local textChannels = TextChatService:FindFirstChild("TextChannels") or TextChatService
	local textChannel = Instance.new("TextChannel")
	textChannel.Name = name

	markTextChannelAsDefault(textChannel)
	textChannel.Parent = textChannels

	textChannel:AddUserAsync(userId)
	textChannel:AddUserAsync(p)

	textChannel.ChildRemoved:Connect(function(_)
		if list.count(textChannel:GetChildren(), function(textSource)
			return textSource:IsA("TextSource")
		end) < 2 then
			textChannel:Destroy()
		end
	end)

	return textChannel
end

local function createInstance(className: string, name: string, parent2)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = parent2
	return instance
end

local function createDispatchRemoteFunction()
	local experienceChat = RobloxReplicatedStorage:FindFirstChild("ExperienceChat")

	if not experienceChat then
		experienceChat = Instance.new("Folder")
		experienceChat.Name = "ExperienceChat"
		experienceChat.Parent = RobloxReplicatedStorage
	end

	local whisperChat = experienceChat:FindFirstChild("WhisperChat")

	if not whisperChat then
		whisperChat = Instance.new("RemoteFunction")
		whisperChat.Name = "WhisperChat"
		whisperChat.Parent = experienceChat
	end

	if whisperChat:IsA("RemoteFunction") then
		whisperChat.OnServerInvoke = function(p, p2)
			v:trace("WhisperChat remote invoked with: {}", (tostring(p2)))
			local v2 = tonumber(p2)
			local userId = p.UserId

			if not v2 then
				return nil
			end

			local v3 = string.format("RBXWhisper:%d_%d", userId < v2 and userId or v2, v2 < userId and userId or v2)

			local child = (TextChatService:FindFirstChild("TextChannels") or TextChatService):FindFirstChild(v3)

			if child then
				v:trace("Whisper TextChannel already exists")
				return child
			end

			if canUsersTalkToEachOther(userId, v2) then -- inferred equivalent call
				v:trace("Creating whisper TextChannel")
				return createWhisperChannel(userId, v2)
			end

			return nil
		end
	end

	return whisperChat
end

return createDispatchRemoteFunction
