local UserInputService = game:GetService("UserInputService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local GetFStringDebugDefaultPageOverride = require(Modules.LuaApp.Flags.GetFStringDebugDefaultPageOverride)
local v9 = game:DefineFastFlag("LuaAppChartsPreloadingEnabled", false)
local t1 = {
	IsLuaGamesPagePreloadingEnabled = function(_) -- line: 14
		-- upvalues: v9 (copy)
		return v9 or not settings():GetFFlag("LuaAppGamesPagePreloadingDisabled")
	end
}

game:DefineFastInt("LuaAppLoginRollout", 0)
game:DefineFastInt("LuaAppLoginRolloutIos", 0)

function t1.LuaAppLoginRolloutEnabledForDevice() -- line: 20
	-- upvalues: UserInputService (copy), AppStorageService (copy), LocalStorageKey (copy)
	local FastInt = game:GetFastInt("LuaAppLoginRollout")

	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		FastInt = game:GetFastInt("LuaAppLoginRolloutIos")
	end

	return FastInt > (tonumber(AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)) or 99) % 100
end
function t1.LuaAppLoginUIEnabled() -- line: 31
	-- upvalues: t1 (copy)
	return t1.LuaAppLoginRolloutEnabledForDevice()
end

game:DefineFastInt("CrossDeviceLoginRollout2", 0)

function t1.CrossDeviceLoginRolloutEnabledForDevice() -- line: 36
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	return (tonumber(AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)) or 99) % 100 < game:GetFastInt("CrossDeviceLoginRollout2")
end

game:DefineFastFlag("LuaAppEnableSinglePageSignUp", false)

function t1.SinglePageSignUpEnabled() -- line: 42
	-- upvalues: t1 (copy)
	return game:GetFastFlag("LuaAppEnableSinglePageSignUp") or t1.LuaAppLoginRolloutEnabledForDevice()
end
function t1.WeChatLoginEnabled() -- line: 46
	return tonumber(settings():GetFVariable("LuaAppLoginMethod")) == 2
end
function t1.GetDefaultAppPage() -- line: 50
	-- upvalues: GetFStringDebugDefaultPageOverride (copy), AppPage (copy)
	local v13 = GetFStringDebugDefaultPageOverride()

	if #v13 > 0 then
		return v13
	end

	return AppPage.Startup
end
function t1.GetGamesTabName() -- line: 61
	return "CommonUI.Features.Label.Discover"
end
function t1.LuaAuthEnabledForLuobu() -- line: 65
	return game:GetEngineFeature("LuobuLuaAuthEnabled")
end

return t1
