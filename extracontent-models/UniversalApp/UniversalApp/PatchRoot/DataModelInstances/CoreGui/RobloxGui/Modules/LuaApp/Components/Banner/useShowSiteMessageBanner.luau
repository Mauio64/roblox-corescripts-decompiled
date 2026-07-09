local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagDebugShowSiteMessageBanner = require(Modules.LuaApp.Flags.FFlagDebugShowSiteMessageBanner)

local function useShowSiteMessageBanner() -- line: 14
	-- upvalues: React (copy), useSelector (copy), useAppPolicy (copy), FFlagDebugShowSiteMessageBanner (copy)
	local v8 = React.useCallback(function(p1) -- line: 16
		return p1.SiteMessage and p1.SiteMessage.Text
	end, {})
	local v9 = useSelector(v8) ~= nil

	return useAppPolicy(function(p2) -- line: 22
		return p2.getSiteMessageBanner()
	end) and v9 or FFlagDebugShowSiteMessageBanner
end

return useShowSiteMessageBanner
