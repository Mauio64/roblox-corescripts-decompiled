local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Parent = script:FindFirstAncestor("ExpChatServer").Parent
local List = require(Parent.llama).List
local v5 = require(Parent.ExpChatShared).Logger:new("ExpChat/" .. script.Name)

local function canUsersTalkToEachOther(n1: number, n2: number) -- line: 11
	-- upvalues: TextChatService (copy), v5 (copy)
	if n1 == n2 then
		return false
	end

	local ok, result = pcall(function() -- line: 15
		-- upvalues: TextChatService (copy), n1 (copy), n2 (copy)
		return TextChatService:CanUsersWhisperAsync(n1, n2)
	end)
	local v15 = ok and result

	v5:debug("CanUsersChat: {}", (tostring(v15)))

	return v15
end
local function whisperChannelAlreadyExists(n3: number, n4: number) -- line: 25
	-- upvalues: TextChatService (copy)
	local v18 = string.format("RBXWhisper:%d_%d", n3 < n4 and n3 or n4, n4 < n3 and n3 or n4)

	return (TextChatService:FindFirstChild("TextChannels") or TextChatService):FindFirstChild(v18)
end
local function createWhisperChannel(n5: number, n6: number) -- line: 32
	-- upvalues: TextChatService (copy), List (copy)
	local v21 = string.format("RBXWhisper:%d_%d", n5 < n6 and n5 or n6, n6 < n5 and n5 or n6)
	local v22 = TextChatService:FindFirstChild("TextChannels") or TextChatService
	local TextChannel = Instance.new("TextChannel")

	TextChannel.Name = v21
	TextChannel.Parent = v22
	TextChannel:AddUserAsync(n5)
	TextChannel:AddUserAsync(n6)
	TextChannel.ChildRemoved:Connect(function(_) -- line: 44
		-- upvalues: List (copy), TextChannel (copy)
		if List.count(TextChannel:GetChildren(), function(p2) -- line: 45
			return p2:IsA("TextSource")
		end) < 2 then
			TextChannel:Destroy()
		end
	end)

	return TextChannel
end
local function createInstance(s1: string, s2: string, p3) -- line: 57
	local v27 = Instance.new(s1)

	v27.Name = s2
	v27.Parent = p3

	return v27
end
local function createDispatchRemoteFunction() -- line: 64
	-- upvalues: RobloxReplicatedStorage (copy), v5 (copy), TextChatService (copy), createWhisperChannel (copy)
	local ExperienceChat = RobloxReplicatedStorage:FindFirstChild("ExperienceChat")

	if not ExperienceChat then
		local v29 = RobloxReplicatedStorage

		ExperienceChat = Instance.new("Folder")
		ExperienceChat.Name = "ExperienceChat"
		ExperienceChat.Parent = v29
	end

	local WhisperChat = ExperienceChat:FindFirstChild("WhisperChat")

	if not WhisperChat then
		WhisperChat = Instance.new("RemoteFunction")
		WhisperChat.Name = "WhisperChat"
		WhisperChat.Parent = ExperienceChat
	end

	if WhisperChat:IsA("RemoteFunction") then
		function WhisperChat.OnServerInvoke(player, p4) -- line: 73
			-- upvalues: v5 (copy), TextChatService (copy), createWhisperChannel (copy)
			v5:trace("WhisperChat remote invoked with: {}", (tostring(p4)))

			local num = tonumber(p4)
			local UserId = player.UserId

			if num then
				local v36 = string.format("RBXWhisper:%d_%d", UserId < num and UserId or num, num < UserId and UserId or num)
				local v37 = (TextChatService:FindFirstChild("TextChannels") or TextChatService):FindFirstChild(v36)

				if v37 then
					v5:trace("Whisper TextChannel already exists")

					return v37
				end

				local v38

				if UserId == num then
					v38 = false
				else
					local ok, result = pcall(function() -- line: 15
						-- upvalues: TextChatService (copy), UserId (copy), num (copy)
						return TextChatService:CanUsersWhisperAsync(UserId, num)
					end)

					v38 = ok and result
					v5:debug("CanUsersChat: {}", (tostring(v38)))
				end

				if v38 then
					v5:trace("Creating whisper TextChannel")

					return (createWhisperChannel(UserId, num))
				end
			end

			return nil
		end
	end

	return WhisperChat
end

return createDispatchRemoteFunction
