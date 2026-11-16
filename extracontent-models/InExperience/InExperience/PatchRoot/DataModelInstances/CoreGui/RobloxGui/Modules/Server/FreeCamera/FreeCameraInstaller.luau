local defineFastFlag = game:DefineFastFlag("AllowLuobuFreecamGroup", false)
local engineFeature = game:DefineFastFlag("FreeCameraToIAS", false)
	and game:GetEngineFeature("PlayerScriptStatusProperty")

local v = { 4358041 }

local v2 = { 7842878 }

local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

local function Install()
	local function WaitForChildOfClass(instance, className)
		local v3 = instance:FindFirstChildOfClass(className)

		while not v3 or v3.ClassName ~= className do
			v3 = instance.ChildAdded:Wait()
		end

		return v3
	end

	local function AddFreeCamera(p)
		local parent = WaitForChildOfClass(p, "PlayerGui")
		local v3

		if engineFeature then
			local playerModuleStatus = StarterPlayer.PlayerModuleStatus
			local v4 = (playerModuleStatus == 1 or playerModuleStatus == 2) and "FreeCameraIAS" or "FreeCamera"

			v3 = script.Parent:WaitForChild(v4)
		else
			v3 = script.Parent:WaitForChild("FreeCamera")
		end

		local freecam = Instance.new("ScreenGui")
		freecam.Name = "Freecam"
		freecam.ResetOnSpawn = false

		local freecamScript = Instance.new("LocalScript")
		freecamScript.Name = "FreecamScript"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			freecamScript.Source = ServerUtil.getSourceForServerScript(v3)
		else
			freecamScript.Source = v3.Source
		end

		freecamScript.Parent = freecam

		freecam.Parent = parent
	end

	local function ShouldAddFreeCam(data): boolean
		if RunService:IsStudio() then
			return true
		end

		if data.UserId <= 0 then
			return false
		end

		local success, canManageAsync = pcall(data.GetCanManageAsync, data)

		if success and canManageAsync then
			return true
		end

		for _, v3 in ipairs(v) do
			local success2, result = pcall(data.IsInGroup, data, v3)

			if success2 and result then
				return true
			end
		end

		if
			not defineFastFlag
			or not game:GetEngineFeature("LuobuModerationStatus")
			or PolicyService.IsLuobuServer ~= Enum.TriStateBoolean.True
		then
			return false
		end

		for _, v3 in ipairs(v2) do
			local success2, result = pcall(data.IsInGroup, data, v3)

			if success2 and result then
				return true
			end
		end

		return false
	end

	local function PlayerAdded(p)
		if ShouldAddFreeCam(p) then
			AddFreeCamera(p)
		end
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	for _, v3 in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerAdded)(v3)
	end
end

return Install
