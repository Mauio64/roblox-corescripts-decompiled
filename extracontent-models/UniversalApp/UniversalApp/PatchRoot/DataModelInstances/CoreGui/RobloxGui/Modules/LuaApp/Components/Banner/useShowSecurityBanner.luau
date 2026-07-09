local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GetFFlagDebugShowAccountSecurityPromptBanner = require(Modules.LuaApp.Flags.GetFFlagDebugShowAccountSecurityPromptBanner)
local GetFFlagLuaAppAccountSecurityPromptEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppAccountSecurityPromptEnabled)
local GetFFlagLuaAppAccountSecurityPromptRollout = require(Modules.LuaApp.Flags.GetFFlagLuaAppAccountSecurityPromptRollout)

local function useShowSecurityBanner() -- line: 19
	-- upvalues: React (copy), useSelector (copy), useLocalUserId (copy), GetFFlagLuaAppAccountSecurityPromptEnabled (copy), GetFFlagLuaAppAccountSecurityPromptRollout (copy), GetFFlagDebugShowAccountSecurityPromptBanner (copy)
	local v10 = React.useCallback(function(p1) -- line: 21
		return p1.AccountSecurityPrompt and p1.AccountSecurityPrompt.promptType
	end, {})
	local v11 = useSelector(v10) ~= nil
	local v12 = useLocalUserId()

	return GetFFlagLuaAppAccountSecurityPromptEnabled() and GetFFlagLuaAppAccountSecurityPromptRollout(v12) and v11 or GetFFlagDebugShowAccountSecurityPromptBanner()
end

return useShowSecurityBanner
