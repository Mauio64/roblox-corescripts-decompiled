local UserInputService = game:GetService("UserInputService")
local AppStorageService = game:GetService("AppStorageService")

local module = require("@luauforge/bundled/dFu")
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local module2 = require("@luauforge/bundled/dFw")

local defineFastFlag = game:DefineFastFlag("LuaAppChartsPreloadingEnabled", false)

local v5 = {}

function v5.IsLuaGamesPagePreloadingEnabled(p2)
	return defineFastFlag or not settings():GetFFlag("LuaAppGamesPagePreloadingDisabled")
end

game:DefineFastInt("LuaAppLoginRollout", 0)
game:DefineFastInt("LuaAppLoginRolloutIos", 0)
function v5.LuaAppLoginRolloutEnabledForDevice(): boolean
	local fastInt = game:GetFastInt("LuaAppLoginRollout")

	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		fastInt = game:GetFastInt("LuaAppLoginRolloutIos")
	end

	return (tonumber(AppStorageService:GetItem(localStorageKey.BrowserTrackerId)) or 99) % 100 < fastInt
end

function v5.LuaAppLoginUIEnabled()
	return v5.LuaAppLoginRolloutEnabledForDevice()
end

game:DefineFastInt("CrossDeviceLoginRollout2", 0)
function v5.CrossDeviceLoginRolloutEnabledForDevice(): boolean
	return (tonumber(AppStorageService:GetItem(localStorageKey.BrowserTrackerId)) or 99) % 100 < game:GetFastInt("CrossDeviceLoginRollout2")
end

game:DefineFastFlag("LuaAppEnableSinglePageSignUp", false)
function v5.SinglePageSignUpEnabled()
	return game:GetFastFlag("LuaAppEnableSinglePageSignUp") or v5.LuaAppLoginRolloutEnabledForDevice()
end

function v5.WeChatLoginEnabled(): boolean
	return tonumber(settings():GetFVariable("LuaAppLoginMethod")) == 2
end

function v5.GetDefaultAppPage()
	local v6 = module2()

	if #v6 > 0 then
		return v6
	end

	return module.Startup
end

function v5.GetGamesTabName(): string
	return "CommonUI.Features.Label.Discover"
end

function v5.LuaAuthEnabledForLuobu()
	return game:GetEngineFeature("LuobuLuaAuthEnabled")
end

return v5
