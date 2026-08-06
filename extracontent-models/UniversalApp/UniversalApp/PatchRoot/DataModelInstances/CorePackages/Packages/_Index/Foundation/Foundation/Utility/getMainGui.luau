local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)
local CoreGui = Wrappers.Services.CoreGui
local RunService = Wrappers.Services.RunService
local Players = Wrappers.Services.Players
local Flags = require(Foundation.Utility.Flags)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local u8 = false
local u9 = nil

local function getPlayerGui() -- line: 14
	-- upvalues: RunService (copy), Players (copy)
	if not RunService:IsClient() or (not Players.LocalPlayer or not RunService:IsRunning()) then
		return nil
	end

	return Players.LocalPlayer:WaitForChild("PlayerGui", 3)
end
local function getMainGui() -- line: 22
	-- upvalues: isPluginSecurity (copy), CoreGui (copy), Flags (copy), u9 (ref), RunService (copy), Players (copy), u8 (ref)
	if isPluginSecurity() then
		return CoreGui
	end

	if Flags.FoundationOverlayResilientMainGui then
		if u9 == nil then
			u9 = if not not RunService:IsClient() and (not not Players.LocalPlayer and RunService:IsRunning()) then Players.LocalPlayer:WaitForChild("PlayerGui", 3) else nil
		end

		return u9
	end

	if not u8 then
		u9 = if not not RunService:IsClient() and (not not Players.LocalPlayer and RunService:IsRunning()) then Players.LocalPlayer:WaitForChild("PlayerGui", 3) else nil
		u8 = true
	end

	if u9 then
		return u9
	end

	error("PlayerGui not found")
end

return getMainGui
