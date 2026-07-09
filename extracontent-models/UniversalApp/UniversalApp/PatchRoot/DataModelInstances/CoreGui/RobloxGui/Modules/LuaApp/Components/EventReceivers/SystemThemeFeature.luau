game:DefineFastFlag("SystemThemeLuaEnabled10", false)

local t1 = {}

if game:GetFastFlag("SystemThemeLuaEnabled10") then
	local CorePackages = game:GetService("CorePackages")
	local Utils = require(CorePackages.Workspace.Packages.SystemTheme).Utils

	t1.ClearThemeOverride = Utils.ClearThemeOverride
	t1.GetSystemThemeEnabled = Utils.GetSystemThemeEnabled
	t1.GetSystemThemeEnum = Utils.GetSystemThemeEnum
	t1.GetSystemThemeService = Utils.GetSystemThemeService
	t1.SetDarkThemeOverride = Utils.SetDarkThemeOverride
	t1.DeviceLevelThemeLocalStorageKey = "DeviceLevelTheme"

	return t1
end

local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

function t1.GetSystemThemeEnabled() -- line: 23
	return game:GetService("SystemThemeService") and game:GetService("SystemThemeService"):isSystemThemeAvailable()
end
function t1.GetSystemThemeService() -- line: 27
	return game:GetService("SystemThemeService") or nil
end
function t1.GetSystemThemeEnum() -- line: 31
	-- upvalues: Modules (copy)
	return game:GetService("SystemThemeService") and (not not game:GetService("SystemThemeService"):isSystemThemeAvailable() and require(Modules.LuaApp.Components.EventReceivers.SystemThemeEnum)) or nil
end

t1.DeviceLevelThemeLocalStorageKey = "DeviceLevelTheme"

function t1.SetDarkThemeOverride() -- line: 46
	-- upvalues: t1 (copy), MessageBusService (copy), MessageId (copy)
	if t1.GetSystemThemeEnabled() then
		MessageBusService:Publish(MessageId, {
			ThemeOverride = "dark"
		})
	end
end
function t1.ClearThemeOverride() -- line: 55
	-- upvalues: t1 (copy), MessageBusService (copy), MessageId (copy)
	if t1.GetSystemThemeEnabled() then
		MessageBusService:Publish(MessageId, {
			ThemeOverride = nil
		})
	end
end

return t1
