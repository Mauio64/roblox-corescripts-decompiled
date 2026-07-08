local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local ServerUtil = require(script.Parent.Parent.ServerUtil)

local function HasOldSoundScripts() -- line: 11
	-- upvalues: ServerScriptService (copy), StarterPlayer (copy)
	if ServerScriptService:FindFirstChild("SoundDispatcher") then
		return true
	end

	local StarterCharacterScripts = StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts")

	if StarterCharacterScripts and StarterCharacterScripts:FindFirstChild("Sound") then
		return true
	end

	return false
end
local function LoadScript(p1, p2) -- line: 24
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
local function TryInstall() -- line: 37
	-- upvalues: ServerScriptService (copy), StarterPlayer (copy), LoadScript (copy)
	local v12

	if ServerScriptService:FindFirstChild("SoundDispatcher") then
		v12 = true
	else
		local StarterCharacterScripts = StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts")

		v12 = not not StarterCharacterScripts and not not StarterCharacterScripts:FindFirstChild("Sound")
	end

	if not v12 then
		return
	end

	local v14 = true
	local SoundDispatcher = ServerScriptService:FindFirstChild("SoundDispatcher")

	if not SoundDispatcher then
		v14 = false
		SoundDispatcher = LoadScript("SoundDispatcher", ServerScriptService)
	end

	if not ServerScriptService:FindFirstChild("SoundDispatcher") then
		local clone = SoundDispatcher:Clone()

		clone.Archivable = false
		clone.Parent = ServerScriptService
	end

	SoundDispatcher.Archivable = v14
end

return TryInstall
