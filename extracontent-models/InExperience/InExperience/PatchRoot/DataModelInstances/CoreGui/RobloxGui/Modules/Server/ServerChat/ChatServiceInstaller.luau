local Chat = game:GetService("Chat")
local ServerScriptService = game:GetService("ServerScriptService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)
local SendChatAnalytics = require(RobloxGui.Modules.Server.SendChatAnalytics)

local function LoadScript(p1, p2) -- line: 11
	-- upvalues: ServerUtil (copy)
	local p1_2 = script.Parent:WaitForChild(p1)
	local Script = Instance.new("Script")

	Script.Name = p1

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		Script.Source = ServerUtil.getSourceForServerScript(p1_2)
	else
		Script.Source = p1_2.Source
	end

	Script.Parent = p2

	return Script
end
local function LoadModule(p3, p4, p5) -- line: 24
	-- upvalues: ServerUtil (copy)
	local p4_2 = p3:WaitForChild(p4)
	local ModuleScript = Instance.new("ModuleScript")

	ModuleScript.Name = p4

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		ModuleScript.Source = ServerUtil.getSourceForServerScript(p4_2)
	else
		ModuleScript.Source = p4_2.Source
	end

	ModuleScript.Parent = p5

	return ModuleScript
end
local function GetBoolValue(p6, p7, p8) -- line: 37
	local p7_2 = p6:FindFirstChild(p7)

	if p7_2 and p7_2:IsA("BoolValue") then
		return p7_2.Value
	end

	return p8
end
local function makeDefaultLocalizationTable(p9) -- line: 47
	local LocalizationTable = Instance.new("LocalizationTable")

	LocalizationTable.Name = "ChatLocalization"
	LocalizationTable.Archivable = false
	LocalizationTable.SourceLocaleId = "en-us"
	LocalizationTable:SetEntries(require(script.Parent:WaitForChild("DefaultChatLocalization")))
	LocalizationTable:SetIsExemptFromUGCAnalytics(true)
	LocalizationTable.Parent = p9
end
local function Install() -- line: 57
	-- upvalues: Chat (copy), makeDefaultLocalizationTable (copy), LoadScript (copy), ServerUtil (copy), ServerScriptService (copy), SendChatAnalytics (copy)
	local t1 = {}
	local ChatLocalization = Chat:FindFirstChild("ChatLocalization")

	if ChatLocalization then
		if ChatLocalization:IsA("LocalizationTable") then
			ChatLocalization:SetIsExemptFromUGCAnalytics(true)
		end
	else
		makeDefaultLocalizationTable(Chat)
	end

	local v28 = true
	local ChatServiceRunner = Chat:FindFirstChild("ChatServiceRunner")

	if not ChatServiceRunner then
		v28 = false
		ChatServiceRunner = LoadScript("ChatServiceRunner", Chat)

		local ChatService = script.Parent:WaitForChild("ChatService")
		local ModuleScript = Instance.new("ModuleScript")

		ModuleScript.Name = "ChatService"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			ModuleScript.Source = ServerUtil.getSourceForServerScript(ChatService)
		else
			ModuleScript.Source = ChatService.Source
		end

		ModuleScript.Parent = ChatServiceRunner

		local ChatChannel = script.Parent:WaitForChild("ChatChannel")
		local ModuleScript2 = Instance.new("ModuleScript")

		ModuleScript2.Name = "ChatChannel"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			ModuleScript2.Source = ServerUtil.getSourceForServerScript(ChatChannel)
		else
			ModuleScript2.Source = ChatChannel.Source
		end

		ModuleScript2.Parent = ChatServiceRunner

		local Speaker = script.Parent:WaitForChild("Speaker")
		local ModuleScript3 = Instance.new("ModuleScript")

		ModuleScript3.Name = "Speaker"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			ModuleScript3.Source = ServerUtil.getSourceForServerScript(Speaker)
		else
			ModuleScript3.Source = Speaker.Source
		end

		ModuleScript3.Parent = ChatServiceRunner

		local Util = script.Parent:WaitForChild("Util")
		local ModuleScript4 = Instance.new("ModuleScript")

		ModuleScript4.Name = "Util"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			ModuleScript4.Source = ServerUtil.getSourceForServerScript(Util)
		else
			ModuleScript4.Source = Util.Source
		end

		ModuleScript4.Parent = ChatServiceRunner
	else
		t1.ChatServiceRunner = "True"
	end

	local ChatModules = Chat:FindFirstChild("ChatModules")

	if not ChatModules then
		ChatModules = Instance.new("Folder")
		ChatModules.Name = "ChatModules"
		ChatModules.Archivable = false

		local BoolValue = Instance.new("BoolValue")

		BoolValue.Name = "InsertDefaultModules"
		BoolValue.Value = true
		BoolValue.Parent = ChatModules
		ChatModules.Parent = Chat
	end

	assert(ChatModules, "")

	local InsertDefaultModules = ChatModules:FindFirstChild("InsertDefaultModules")

	if not not InsertDefaultModules and (not not InsertDefaultModules:IsA("BoolValue") and InsertDefaultModules.Value) then
		if not ChatModules:FindFirstChild("Utility") then
			local Folder = Instance.new("Folder")

			Folder.Name = "Utility"
			Folder.Parent = ChatModules
		end

		local children = script.Parent.DefaultChatModules:GetChildren()

		for i = 1, #children do
			if children.className ~= "Folder" and not ChatModules:FindFirstChild(children[i].Name) then
				local DefaultChatModules = script.Parent.DefaultChatModules
				local Name = children[i].Name
				local Name2 = DefaultChatModules:WaitForChild(Name)
				local ModuleScript = Instance.new("ModuleScript")

				ModuleScript.Name = Name

				if ServerUtil.getFFlagServerCoreScriptSourceCode() then
					ModuleScript.Source = ServerUtil.getSourceForServerScript(Name2)
				else
					ModuleScript.Source = Name2.Source
				end

				ModuleScript.Parent = ChatModules
			elseif children.className ~= "Folder" then
				t1[children[i].Name] = "True"
			end
		end

		for _, child in pairs(script.Parent.DefaultChatModules.Utility:GetChildren()) do
			if not ChatModules.Utility:FindFirstChild(child.Name) then
				local Utility = script.Parent.DefaultChatModules.Utility
				local childName = child.Name
				local Utility2 = ChatModules.Utility
				local childName2 = Utility:WaitForChild(childName)
				local ModuleScript = Instance.new("ModuleScript")

				ModuleScript.Name = childName

				if ServerUtil.getFFlagServerCoreScriptSourceCode() then
					ModuleScript.Source = ServerUtil.getSourceForServerScript(childName2)
				else
					ModuleScript.Source = childName2.Source
				end

				ModuleScript.Parent = Utility2
			else
				t1[child.Name] = "True"
			end
		end
	end

	if not ServerScriptService:FindFirstChild("ChatServiceRunner") then
		local clone = ChatServiceRunner:Clone()

		clone.Archivable = false
		clone.Parent = ServerScriptService
	end

	ChatServiceRunner.Archivable = v28
	SendChatAnalytics("LoadServerDefaultChatForkedModules", t1)
end

return Install
