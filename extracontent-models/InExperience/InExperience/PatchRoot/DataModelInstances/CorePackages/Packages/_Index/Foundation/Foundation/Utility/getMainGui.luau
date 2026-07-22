local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)
local CoreGui = Wrappers.Services.CoreGui
local RunService = Wrappers.Services.RunService
local Players = Wrappers.Services.Players
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local u7 = false
local u8 = nil

local function getPlayerGui() -- line: 13
	-- upvalues: RunService (copy), Players (copy)
	if not RunService:IsClient() or (not Players.LocalPlayer or not RunService:IsRunning()) then
		return nil
	end

	return Players.LocalPlayer:WaitForChild("PlayerGui", 3)
end
local function getMainGui() -- line: 21
	-- upvalues: isPluginSecurity (copy), CoreGui (copy), u7 (ref), u8 (ref), RunService (copy), Players (copy)
	if isPluginSecurity() then
		return CoreGui
	end

	if not u7 then
		u8 = if not not RunService:IsClient() and (not not Players.LocalPlayer and RunService:IsRunning()) then Players.LocalPlayer:WaitForChild("PlayerGui", 3) else nil
		u7 = true
	end

	if u8 then
		return u8
	end

	error("PlayerGui not found")
end

return getMainGui
