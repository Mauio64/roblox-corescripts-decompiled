local Chat = game:GetService("Chat")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)
local v8 = game:DefineFastFlag("EnableModerateChatUseChatService", false) and game:GetEngineFeature("EnableChatModerationModeLoggingRefactor")

return function() -- line: 24
	-- upvalues: createSignal (copy), GetChatStatusStore (copy), v8 (copy), Chat (copy), RobloxReplicatedStorage (copy), createComputed (copy)
	local v9, v10 = createSignal(false)
	local v11, v12 = createSignal(false)
	local v13 = GetChatStatusStore(false)
	local ModerateChatSettingUpdated = nil
	local connection = nil

	if v8 then
		connection = Chat:GetPropertyChangedSignal("ModerationMode"):Connect(function() -- line: 52
			-- upvalues: v10 (copy), Chat (copy), v12 (copy)
			v10(Chat.ModerationMode ~= "Unsupported")
			v12(Chat.ModerationMode == "Enabled")
		end)
		v10(Chat.ModerationMode ~= "Unsupported")
		v12(Chat.ModerationMode == "Enabled")
	else
		coroutine.wrap(function() -- line: 59
			-- upvalues: ModerateChatSettingUpdated (ref), RobloxReplicatedStorage (copy), v10 (copy), v12 (copy)
			ModerateChatSettingUpdated = RobloxReplicatedStorage:WaitForChild("ModerateChatSettingUpdated", 10)

			if ModerateChatSettingUpdated then
				ModerateChatSettingUpdated.OnClientEvent:Connect(function(b1: boolean) -- line: 62
					-- upvalues: v10 (copy), v12 (copy)
					v10(true)
					v12(b1)
				end)
			end
		end)()
	end

	local v16 = createComputed(function(p1) -- line: 71
		-- upvalues: v9 (copy), v13 (copy)
		return v9(p1) and v13.getChatStatus(p1) == "Enabled"
	end)
	local v17 = createComputed(function(p2) -- line: 74
		-- upvalues: v11 (copy), v13 (copy)
		return v11(p2) and v13.getChatStatus(p2) == "Enabled"
	end)

	return {
		getIsSettingVisible = v16,
		getIsSettingEnabled = v17,
		setIsSettingEnabled = function(b2: boolean) -- line: 31
			-- upvalues: v8 (copy), Chat (copy), ModerateChatSettingUpdated (ref)
			if v8 then
				Chat:RequestModerationModeEnabled(b2)

				return
			end

			if ModerateChatSettingUpdated then
				ModerateChatSettingUpdated:FireServer(b2)
			end
		end,
		initialize = function() -- line: 41
			-- upvalues: v8 (copy), Chat (copy), ModerateChatSettingUpdated (ref)
			if v8 then
				Chat:RequestModerationModeEnabled(false)

				return
			end

			if ModerateChatSettingUpdated then
				ModerateChatSettingUpdated:FireServer(false)
			end
		end,
		cleanup = function() -- line: 83
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	}
end
