local Chat = game:GetService("Chat")
local Players = game:GetService("Players")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)
local SendChatAnalytics = require(RobloxGui.Modules.Server.SendChatAnalytics)
local v7 = game:DefineFastFlag("ChatWindowInstallerCheckClassName", false)
local ok, result = pcall(function() -- line: 18
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u10 = ok and result

local function LoadLocalScript(p1, p2, p3) -- line: 24
	-- upvalues: v7 (copy), ServerUtil (copy)
	local p2_2 = p1:WaitForChild(p2)

	if v7 and p2_2.ClassName ~= "ModuleScript" then
		return p2_2:Clone()
	end

	local LocalScript = Instance.new("LocalScript")

	LocalScript.Name = p2

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		LocalScript.Source = ServerUtil.getSourceForServerScript(p2_2)
	else
		LocalScript.Source = p2_2.Source
	end

	LocalScript.Parent = p3

	return LocalScript
end
local function LoadModule(p4, p5, p6) -- line: 42
	-- upvalues: v7 (copy), ServerUtil (copy)
	local p5_2 = p4:WaitForChild(p5)

	if v7 and p5_2.ClassName ~= "ModuleScript" then
		return p5_2:Clone()
	end

	local ModuleScript = Instance.new("ModuleScript")

	ModuleScript.Name = p5

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		ModuleScript.Source = ServerUtil.getSourceForServerScript(p5_2)
	else
		ModuleScript.Source = p5_2.Source
	end

	ModuleScript.Parent = p6

	return ModuleScript
end
local function GetBoolValue(p7, p8, p9) -- line: 60
	local p8_2 = p7:FindFirstChild(p8)

	if p8_2 and p8_2:IsA("BoolValue") then
		return p8_2.Value
	end

	return p9
end
local function Install() -- line: 70
	-- upvalues: Chat (copy), LoadLocalScript (copy), LoadModule (copy), u10 (ref), StarterPlayerScripts (copy), Players (copy), SendChatAnalytics (copy)
	local t1 = {}
	local v30 = true
	local ChatScript = Chat:FindFirstChild("ChatScript")

	if not ChatScript then
		v30 = false
		ChatScript = LoadLocalScript(script.Parent, "ChatScript", Chat)

		local v32 = LoadModule(script.Parent, "ChatMain", ChatScript)

		LoadModule(script.Parent, "ChannelsBar", v32)
		LoadModule(script.Parent, "ChatBar", v32)
		LoadModule(script.Parent, "ChatChannel", v32)
		LoadModule(script.Parent, "MessageLogDisplay", v32)
		LoadModule(script.Parent, "ChatWindow", v32)
		LoadModule(script.Parent, "MessageLabelCreator", v32)
		LoadModule(script.Parent, "CommandProcessor", v32)
		LoadModule(script.Parent, "ChannelsTab", v32)
		LoadModule(script.Parent.Parent.Parent.Common, "ObjectPool", v32)
		LoadModule(script.Parent, "MessageSender", v32)
		LoadModule(script.Parent, "CurveUtil", v32)

		if u10 then
			local BoolValue = Instance.new("BoolValue")

			BoolValue.Name = "ChatTranslationEnabled"
			BoolValue.Value = false
			BoolValue.Parent = v32
		end
	else
		t1.ChatScript = "True"
	end

	local v34 = true
	local BubbleChat = Chat:FindFirstChild("BubbleChat")

	if not BubbleChat then
		v34 = false
		BubbleChat = LoadLocalScript(script.Parent.BubbleChat, "BubbleChat", Chat)
	else
		t1.BubbleChat = "True"
	end

	local ClientChatModules = Chat:FindFirstChild("ClientChatModules")

	if not ClientChatModules then
		ClientChatModules = Instance.new("Folder")
		ClientChatModules.Name = "ClientChatModules"
		ClientChatModules.Archivable = false
		ClientChatModules.Parent = Chat
	else
		t1.ClientChatModules = "True"
	end

	if not ClientChatModules:FindFirstChild("ChatSettings") then
		LoadModule(script.Parent.DefaultClientChatModules, "ChatSettings", ClientChatModules)
	else
		t1.ChatSettings = "True"
	end

	if not ClientChatModules:FindFirstChild("ChatConstants") then
		LoadModule(script.Parent.DefaultClientChatModules, "ChatConstants", ClientChatModules)
	else
		t1.ChatConstants = "True"
	end

	if not ClientChatModules:FindFirstChild("ChatLocalization") then
		LoadModule(script.Parent.DefaultClientChatModules, "ChatLocalization", ClientChatModules)
	else
		t1.ChatLocalization = "True"
	end

	local MessageCreatorModules = ClientChatModules:FindFirstChild("MessageCreatorModules")

	if not MessageCreatorModules then
		MessageCreatorModules = Instance.new("Folder")
		MessageCreatorModules.Name = "MessageCreatorModules"
		MessageCreatorModules.Archivable = false

		local BoolValue = Instance.new("BoolValue")

		BoolValue.Name = "InsertDefaultModules"
		BoolValue.Value = true
		BoolValue.Parent = MessageCreatorModules
		MessageCreatorModules.Parent = ClientChatModules
	end

	local InsertDefaultModules = MessageCreatorModules:FindFirstChild("InsertDefaultModules")

	if not not InsertDefaultModules and (not not InsertDefaultModules:IsA("BoolValue") and InsertDefaultModules.Value) then
		local children = script.Parent.DefaultClientChatModules.MessageCreatorModules:GetChildren()

		for i = 1, #children do
			if not MessageCreatorModules:FindFirstChild(children[i].Name) then
				LoadModule(script.Parent.DefaultClientChatModules.MessageCreatorModules, children[i].Name, MessageCreatorModules)
			else
				t1[children[i].Name] = "True"
			end
		end
	end

	local CommandModules = ClientChatModules:FindFirstChild("CommandModules")

	if not CommandModules then
		CommandModules = Instance.new("Folder")
		CommandModules.Name = "CommandModules"
		CommandModules.Archivable = false

		local BoolValue = Instance.new("BoolValue")

		BoolValue.Name = "InsertDefaultModules"
		BoolValue.Value = true
		BoolValue.Parent = CommandModules
		CommandModules.Parent = ClientChatModules
	end

	local InsertDefaultModules2 = CommandModules:FindFirstChild("InsertDefaultModules")

	if not not InsertDefaultModules2 and (not not InsertDefaultModules2:IsA("BoolValue") and InsertDefaultModules2.Value) then
		local children = script.Parent.DefaultClientChatModules.CommandModules:GetChildren()

		for i = 1, #children do
			if not CommandModules:FindFirstChild(children[i].Name) then
				LoadModule(script.Parent.DefaultClientChatModules.CommandModules, children[i].Name, CommandModules)
			else
				t1[children[i].Name] = "True"
			end
		end
	end

	if not StarterPlayerScripts:FindFirstChild("ChatScript") then
		local clone = ChatScript:Clone()

		clone.Parent = StarterPlayerScripts
		clone.Archivable = false

		local players = Players:GetPlayers()

		for _, v in pairs(players) do
			if v:FindFirstChildOfClass("PlayerGui") then
				local v51 = LoadLocalScript(script.Parent, "ChatInstallVerifier", v.PlayerGui)
				local StringValue = Instance.new("StringValue")

				StringValue.Name = "ScriptToVerify"
				StringValue.Value = "ChatScript"
				StringValue.Parent = v51
			end
		end
	end

	ChatScript.Archivable = v30

	if not StarterPlayerScripts:FindFirstChild("BubbleChat") then
		local clone = BubbleChat:Clone()

		clone.Parent = StarterPlayerScripts
		clone.Archivable = false

		local players = Players:GetPlayers()

		for _, v in pairs(players) do
			if v:FindFirstChildOfClass("PlayerGui") then
				local v57 = LoadLocalScript(script.Parent, "ChatInstallVerifier", v.PlayerGui)
				local StringValue = Instance.new("StringValue")

				StringValue.Name = "ScriptToVerify"
				StringValue.Value = "BubbleChat"
				StringValue.Parent = v57
			end
		end
	end

	BubbleChat.Archivable = v34
	SendChatAnalytics("LoadClientDefaultChatForkedModules", t1)
end

return Install
