local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local MemStorageService = game:GetService("MemStorageService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local FetchTheme = require(Modules.LuaApp.Thunks.FetchTheme)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local ThemeContext = require(CorePackages.Workspace.Packages.Style).ThemeContext
local v18 = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature).GetSystemThemeEnabled()
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local _ = {
	ThemeUpdate = "ThemeUpdate"
}
local v21 = Roact.Component:extend("ThemeUpdater")

function v21.init(p1) -- line: 32
	-- upvalues: v18 (copy), NotificationService (copy), LuaAppBacktraceReporter (copy), MemStorageService (copy), MemStorageKeys (copy), AppStorageUtilities (copy), FetchTheme (copy), Players (copy)
	local RobloxEventReceiver = p1.props.RobloxEventReceiver
	local networking = p1.props.networking

	function p1.changeTheme(p2) -- line: 36
		-- upvalues: v18 (copy), p1 (copy), NotificationService (copy), LuaAppBacktraceReporter (copy)
		if v18 then
			return
		end

		if p1.props.themeOverride then
			p2 = p1.props.themeOverride
		end

		NotificationService.SelectedTheme = p2
		p1.props.themeContext.setTheme(p2)
		LuaAppBacktraceReporter:updateSharedAttributes({
			AppTheme = p2
		})
	end
	function p1.updateTheme() -- line: 54
		-- upvalues: MemStorageService (copy), MemStorageKeys (copy), p1 (copy), AppStorageUtilities (copy), FetchTheme (copy), networking (copy), Players (copy)
		local function cacheAndChangeTheme(s1: string) -- line: 55
			-- upvalues: MemStorageService (copy), MemStorageKeys (copy), p1 (copy), AppStorageUtilities (copy)
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, s1)
			p1.changeTheme(s1)
			AppStorageUtilities.setAuthenticatedTheme(s1)
			AppStorageUtilities.flush()
		end

		if p1.props.themeOverride then
			return cacheAndChangeTheme(p1.props.themeOverride)
		end

		return FetchTheme(networking, Players.LocalPlayer.UserId):andThen(function(p3) -- line: 67
			-- upvalues: MemStorageService (copy), MemStorageKeys (copy), p1 (copy), AppStorageUtilities (copy)
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, p3)
			p1.changeTheme(p3)
			AppStorageUtilities.setAuthenticatedTheme(p3)
			AppStorageUtilities.flush()
		end)
	end

	p1.tokens = {
		RobloxEventReceiver:observeEvent("UserThemeTypeChangeNotification", function(p4, p5) -- line: 73
			-- upvalues: p1 (copy)
			if (p4.Type or p5) == "ThemeUpdate" then
				p1.updateTheme()
			end
		end),
		MemStorageService:Bind(MemStorageKeys.ThemeUpdate, function(p6) -- line: 79
			-- upvalues: p1 (copy)
			p1.changeTheme(p6)
		end)
	}
end
function v21.render(_) -- line: 85
end
function v21.willUnmount(p8) -- line: 87
	for _, v in pairs(p8.tokens) do
		v:disconnect()
	end
end

return RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService
})(function(p9) -- line: 93
	-- upvalues: useAppPolicy (copy), React (copy), ThemeContext (copy), Roact (copy), v21 (copy), Cryo (copy)
	local v30 = useAppPolicy(function(p10) -- line: 96
		return p10.getForceTheme()
	end)
	local v31 = React.useContext(ThemeContext)

	return Roact.createElement(v21, Cryo.Dictionary.join(p9, {
		themeOverride = v30,
		themeContext = v31
	}))
end)
