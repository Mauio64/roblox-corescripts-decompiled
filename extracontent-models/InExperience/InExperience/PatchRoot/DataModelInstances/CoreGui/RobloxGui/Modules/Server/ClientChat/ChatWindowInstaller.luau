local Chat = game:GetService("Chat")

local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

local SendChatAnalytics = require(RobloxGui.Modules.Server.SendChatAnalytics)

local defineFastFlag = game:DefineFastFlag("ChatWindowInstallerCheckClassName", false)

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v = success and result

local function LoadLocalScript(instance, name, parent)
	local child = instance:WaitForChild(name)

	if defineFastFlag and child.ClassName ~= "ModuleScript" then
		return child:Clone()
	end

	local localScript = Instance.new("LocalScript")
	localScript.Name = name

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		localScript.Source = ServerUtil.getSourceForServerScript(child)
	else
		localScript.Source = child.Source
	end

	localScript.Parent = parent
	return localScript
end

local function LoadModule(instance, name, parent)
	local child = instance:WaitForChild(name)

	if defineFastFlag and child.ClassName ~= "ModuleScript" then
		return child:Clone()
	end

	local moduleScript = Instance.new("ModuleScript")
	moduleScript.Name = name

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		moduleScript.Source = ServerUtil.getSourceForServerScript(child)
	else
		moduleScript.Source = child.Source
	end

	moduleScript.Parent = parent
	return moduleScript
end

local function GetBoolValue(instance, childName, p) -- 2 equivalent calls inferred from this helper
	local boolValue = instance:FindFirstChild(childName)

	if boolValue and boolValue:IsA("BoolValue") then
		return boolValue.Value
	end

	return p
end

local function Install()
	local v2 = {}

	local archivable = true
	local v3 = Chat:FindFirstChild("ChatScript")

	if v3 then
		v2.ChatScript = "True"
	else
		archivable = false
		v3 = LoadLocalScript(script.Parent, "ChatScript", Chat)
		local parent = LoadModule(script.Parent, "ChatMain", v3)

		LoadModule(script.Parent, "ChannelsBar", parent)
		LoadModule(script.Parent, "ChatBar", parent)
		LoadModule(script.Parent, "ChatChannel", parent)
		LoadModule(script.Parent, "MessageLogDisplay", parent)
		LoadModule(script.Parent, "ChatWindow", parent)
		LoadModule(script.Parent, "MessageLabelCreator", parent)
		LoadModule(script.Parent, "CommandProcessor", parent)
		LoadModule(script.Parent, "ChannelsTab", parent)
		LoadModule(script.Parent.Parent.Parent.Common, "ObjectPool", parent)
		LoadModule(script.Parent, "MessageSender", parent)
		LoadModule(script.Parent, "CurveUtil", parent)

		if v then
			local chatTranslationEnabled = Instance.new("BoolValue")
			chatTranslationEnabled.Name = "ChatTranslationEnabled"
			chatTranslationEnabled.Value = false
			chatTranslationEnabled.Parent = parent
		end
	end

	local archivable2 = true
	local v4 = Chat:FindFirstChild("BubbleChat")

	if v4 then
		v2.BubbleChat = "True"
	else
		v4 = LoadLocalScript(script.Parent.BubbleChat, "BubbleChat", Chat)
		archivable2 = false
	end

	local clientChatModules = Chat:FindFirstChild("ClientChatModules")

	if clientChatModules then
		v2.ClientChatModules = "True"
	else
		clientChatModules = Instance.new("Folder")
		clientChatModules.Name = "ClientChatModules"
		clientChatModules.Archivable = false

		clientChatModules.Parent = Chat
	end

	if clientChatModules:FindFirstChild("ChatSettings") then
		v2.ChatSettings = "True"
	else
		LoadModule(script.Parent.DefaultClientChatModules, "ChatSettings", clientChatModules)
	end

	if clientChatModules:FindFirstChild("ChatConstants") then
		v2.ChatConstants = "True"
	else
		LoadModule(script.Parent.DefaultClientChatModules, "ChatConstants", clientChatModules)
	end

	if clientChatModules:FindFirstChild("ChatLocalization") then
		v2.ChatLocalization = "True"
	else
		LoadModule(script.Parent.DefaultClientChatModules, "ChatLocalization", clientChatModules)
	end

	local messageCreatorModules = clientChatModules:FindFirstChild("MessageCreatorModules")

	if not messageCreatorModules then
		messageCreatorModules = Instance.new("Folder")
		messageCreatorModules.Name = "MessageCreatorModules"
		messageCreatorModules.Archivable = false

		local insertDefaultModules = Instance.new("BoolValue")
		insertDefaultModules.Name = "InsertDefaultModules"
		insertDefaultModules.Value = true
		insertDefaultModules.Parent = messageCreatorModules

		messageCreatorModules.Parent = clientChatModules
	end

	if GetBoolValue(messageCreatorModules, "InsertDefaultModules", false) then -- inferred equivalent call
		local children = script.Parent.DefaultClientChatModules.MessageCreatorModules:GetChildren()

		for i = 1, #children do
			if messageCreatorModules:FindFirstChild(children[i].Name) then
				v2[children[i].Name] = "True"
			else
				LoadModule(
					script.Parent.DefaultClientChatModules.MessageCreatorModules,
					children[i].Name,
					messageCreatorModules
				)
			end
		end
	end

	local commandModules = clientChatModules:FindFirstChild("CommandModules")

	if not commandModules then
		commandModules = Instance.new("Folder")
		commandModules.Name = "CommandModules"
		commandModules.Archivable = false

		local insertDefaultModules = Instance.new("BoolValue")
		insertDefaultModules.Name = "InsertDefaultModules"
		insertDefaultModules.Value = true
		insertDefaultModules.Parent = commandModules

		commandModules.Parent = clientChatModules
	end

	if GetBoolValue(commandModules, "InsertDefaultModules", false) then -- inferred equivalent call
		local children = script.Parent.DefaultClientChatModules.CommandModules:GetChildren()

		for i = 1, #children do
			if commandModules:FindFirstChild(children[i].Name) then
				v2[children[i].Name] = "True"
			else
				LoadModule(script.Parent.DefaultClientChatModules.CommandModules, children[i].Name, commandModules)
			end
		end
	end

	if not StarterPlayerScripts:FindFirstChild("ChatScript") then
		local clone = v3:Clone()
		clone.Parent = StarterPlayerScripts
		clone.Archivable = false

		local players = Players:GetPlayers()

		for _, player in pairs(players) do
			if not player:FindFirstChildOfClass("PlayerGui") then
				continue
			end

			local parent = LoadLocalScript(script.Parent, "ChatInstallVerifier", player.PlayerGui)
			local scriptToVerify = Instance.new("StringValue")
			scriptToVerify.Name = "ScriptToVerify"
			scriptToVerify.Value = "ChatScript"
			scriptToVerify.Parent = parent
		end
	end

	v3.Archivable = archivable

	if not StarterPlayerScripts:FindFirstChild("BubbleChat") then
		local clone = v4:Clone()
		clone.Parent = StarterPlayerScripts
		clone.Archivable = false

		local players = Players:GetPlayers()

		for _, player in pairs(players) do
			if not player:FindFirstChildOfClass("PlayerGui") then
				continue
			end

			local parent = LoadLocalScript(script.Parent, "ChatInstallVerifier", player.PlayerGui)
			local scriptToVerify = Instance.new("StringValue")
			scriptToVerify.Name = "ScriptToVerify"
			scriptToVerify.Value = "BubbleChat"
			scriptToVerify.Parent = parent
		end
	end

	v4.Archivable = archivable2
	SendChatAnalytics("LoadClientDefaultChatForkedModules", v2)
end

return Install
