local Foundation = script:FindFirstAncestor("Foundation")

local Wrappers = require(Foundation.Utility.Wrappers)
local CoreGui = Wrappers.Services.CoreGui
local RunService = Wrappers.Services.RunService
local Players = Wrappers.Services.Players

local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)

local v = nil

local function getPlayerGui() -- 1 equivalent call inferred from this helper
	if RunService:IsClient() and Players.LocalPlayer and RunService:IsRunning() then
		return Players.LocalPlayer:WaitForChild("PlayerGui", 3)
	end

	return nil
end

local function getMainGui()
	if isPluginSecurity() then
		return CoreGui
	end

	if v == nil then
		v = getPlayerGui() -- inferred equivalent call
	end

	return v
end

return getMainGui
