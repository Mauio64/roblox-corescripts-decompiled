local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local ServerUtil = require(script.Parent.Parent.ServerUtil)

local function HasOldSoundScripts(): boolean -- 1 equivalent call inferred from this helper
	if ServerScriptService:FindFirstChild("SoundDispatcher") then
		return true
	end

	local starterCharacterScripts = StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts")

	if starterCharacterScripts and starterCharacterScripts:FindFirstChild("Sound") then
		return true
	end

	return false
end

local function LoadScript(name, ServerScriptService2)
	local child = script.Parent:WaitForChild(name)
	local Script = Instance.new("Script")
	Script.Name = name

	if ServerUtil.getFFlagServerCoreScriptSourceCode() then
		Script.Source = ServerUtil.getSourceForServerScript(child)
	else
		Script.Source = child.Source
	end

	Script.Parent = ServerScriptService2
	return Script
end

local function TryInstall()
	if not HasOldSoundScripts() then -- inferred equivalent call
		return
	end

	local v = ServerScriptService:FindFirstChild("SoundDispatcher")
	local archivable

	if v then
		archivable = true
	else
		v = LoadScript("SoundDispatcher", ServerScriptService)
		archivable = false
	end

	if not ServerScriptService:FindFirstChild("SoundDispatcher") then
		local clone = v:Clone()
		clone.Archivable = false
		clone.Parent = ServerScriptService
	end

	v.Archivable = archivable
end

return TryInstall
