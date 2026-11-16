local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Chrome = script:FindFirstAncestor("Chrome")
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local FFlagRespawnChromeShortcutTelemetry = require(Chrome.Flags.FFlagRespawnChromeShortcutTelemetry)

local v = false
local v2 = Signal.new()
local respawnPageOpenSignal = MappedSignal.new(v2, function()
	return v
end)

task.defer(function()
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	SettingsHub.CurrentPageSignal:connect(function(p)
		v = p == SettingsHub.Instance.ResetCharacterPage.Page.Name
		v2:fire()
	end)
end)

local function respawnPage(p)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	local resetCharacterPage = SettingsHub.Instance.ResetCharacterPage
	local function switchToRespawnPage() -- 1 equivalent call inferred from this helper
		local used_shortcut

		if p then
			used_shortcut = p.usedShortcut
		end

		SettingsHub.Instance:SwitchToPage(resetCharacterPage, true, nil, nil, nil, {
			used_shortcut = used_shortcut
		})
	end

	if SettingsHub:GetVisibility() then
		if v then
			SettingsHub:SetVisibility(false)
			return
		end

		if not FFlagRespawnChromeShortcutTelemetry then
			SettingsHub.Instance:SwitchToPage(resetCharacterPage, true)
			return
		end
	else
		if not FFlagRespawnChromeShortcutTelemetry then
			SettingsHub:SetVisibility(true, false, resetCharacterPage)

			return
		end

		SettingsHub:SetVisibility(true)
	end

	switchToRespawnPage() -- inferred equivalent call
end

return { respawnPageOpenSignal = respawnPageOpenSignal, respawnPage = respawnPage }
