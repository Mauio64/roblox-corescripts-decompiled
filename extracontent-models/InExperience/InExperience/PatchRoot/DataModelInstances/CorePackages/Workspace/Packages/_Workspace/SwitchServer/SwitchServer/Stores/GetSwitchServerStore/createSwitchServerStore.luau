local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local SwitchServer = script:FindFirstAncestor("SwitchServer")
local parent = SwitchServer.Parent

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local Signals = require(parent.Signals)

local SwitchServerTelemetry = require(SwitchServer.Telemetry.SwitchServerTelemetry)

local STANDARD_SERVER = CoreScriptsCommon.Constants.STANDARD_SERVER

local function fetchAndUpdateShouldSwitchServer(callback) -- 1 equivalent call inferred from this helper
	task.spawn(function()
		if
			RunService:IsStudio()
			or not game:GetEngineFeature("GameIdToExcludeAvailable")
			or Players.MaxPlayers == 1
		then
			return
		end

		local getServerType = RobloxReplicatedStorage:WaitForChild("GetServerType", 2)

		if not getServerType then
			return
		end

		local success, result = pcall(function()
			return getServerType:InvokeServer()
		end)

		if success then
			callback(result == STANDARD_SERVER)
		end
	end)
end

local function createSwitchServerStore()
	local signal, v = Signals.createSignal(false)
	fetchAndUpdateShouldSwitchServer(v) -- inferred equivalent call
	local signal2, v2 = Signals.createSignal(false)
	return {
		shouldEnableSwitchServer = signal,
		isConfirmationOpen = signal2,
		setConfirmationOpen = function(flag: boolean)
			if flag then
				SwitchServerTelemetry.sendSwitchServerButtonActions({ event_type = "click" })
			end

			v2(flag)
		end
	}
end

return createSwitchServerStore
