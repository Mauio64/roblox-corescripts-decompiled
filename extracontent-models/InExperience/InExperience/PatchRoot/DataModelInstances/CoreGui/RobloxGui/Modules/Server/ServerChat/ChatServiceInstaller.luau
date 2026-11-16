local Chat = game:GetService("Chat")
local ServerScriptService = game:GetService("ServerScriptService")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)
local SendChatAnalytics = require(RobloxGui.Modules.Server.SendChatAnalytics)

local function LoadScript(name, Chat2)
	local child = script.Parent:WaitForChild(name)
	local Script = Instance.new("Script")
	Script.Name = name

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		Script.Source = ServerUtil.getSourceForServerScript(child)
	else
		Script.Source = child.Source
	end

	Script.Parent = Chat2
	return Script
end

local function LoadModule(instance, name, parent) -- 6 equivalent calls inferred from this helper
	local child = instance:WaitForChild(name)
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

local function GetBoolValue(chatModules, childName, p) -- 1 equivalent call inferred from this helper
	local boolValue = chatModules:FindFirstChild(childName)

	if boolValue and boolValue:IsA("BoolValue") then
		return boolValue.Value
	end

	return p
end

local function makeDefaultLocalizationTable(Chat2)
	local chatLocalization = Instance.new("LocalizationTable")
	chatLocalization.Name = "ChatLocalization"
	chatLocalization.Archivable = false
	chatLocalization.SourceLocaleId = "en-us"
	chatLocalization:SetEntries(require(script.Parent:WaitForChild("DefaultChatLocalization")))
	chatLocalization:SetIsExemptFromUGCAnalytics(true)
	chatLocalization.Parent = Chat2
end

local function Install()
	local v = {}
	local chatLocalization = Chat:FindFirstChild("ChatLocalization")

	if chatLocalization then
		if chatLocalization:IsA("LocalizationTable") then
			chatLocalization:SetIsExemptFromUGCAnalytics(true)
		end
	else
		makeDefaultLocalizationTable(Chat)
	end

	local archivable = true
	local v2 = Chat:FindFirstChild("ChatServiceRunner")

	if v2 then
		v.ChatServiceRunner = "True"
	else
		archivable = false
		v2 = LoadScript("ChatServiceRunner", Chat)

		LoadModule(script.Parent, "ChatService", v2) -- inferred equivalent call
		LoadModule(script.Parent, "ChatChannel", v2) -- inferred equivalent call
		LoadModule(script.Parent, "Speaker", v2) -- inferred equivalent call
		LoadModule(script.Parent, "Util", v2) -- inferred equivalent call
	end

	local chatModules = Chat:FindFirstChild("ChatModules")

	if not chatModules then
		chatModules = Instance.new("Folder")
		chatModules.Name = "ChatModules"
		chatModules.Archivable = false

		local insertDefaultModules = Instance.new("BoolValue")
		insertDefaultModules.Name = "InsertDefaultModules"
		insertDefaultModules.Value = true
		insertDefaultModules.Parent = chatModules

		chatModules.Parent = Chat
	end

	assert(chatModules, "")

	if GetBoolValue(chatModules, "InsertDefaultModules", false) then -- inferred equivalent call
		if not chatModules:FindFirstChild("Utility") then
			local utility = Instance.new("Folder")
			utility.Name = "Utility"
			utility.Parent = chatModules
		end

		local children = script.Parent.DefaultChatModules:GetChildren()

		for i = 1, #children do
			if children.className == "Folder" or chatModules:FindFirstChild(children[i].Name) then
				if children.className ~= "Folder" then
					v[children[i].Name] = "True"
				end
			else
				LoadModule(script.Parent.DefaultChatModules, children[i].Name, chatModules) -- inferred equivalent call
			end
		end

		for _, child in pairs(script.Parent.DefaultChatModules.Utility:GetChildren()) do
			if chatModules.Utility:FindFirstChild(child.Name) then
				v[child.Name] = "True"
			else
				LoadModule(script.Parent.DefaultChatModules.Utility, child.Name, chatModules.Utility) -- inferred equivalent call
			end
		end
	end

	if not ServerScriptService:FindFirstChild("ChatServiceRunner") then
		local clone = v2:Clone()
		clone.Archivable = false
		clone.Parent = ServerScriptService
	end

	v2.Archivable = archivable
	SendChatAnalytics("LoadServerDefaultChatForkedModules", v)
end

return Install
