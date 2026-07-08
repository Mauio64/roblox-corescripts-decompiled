local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Chrome = script:FindFirstAncestor("Chrome")
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local FFlagRespawnChromeShortcutTelemetry = require(Chrome.Flags.FFlagRespawnChromeShortcutTelemetry)
local u8 = false
local v9 = Signal.new()
local v10 = MappedSignal.new(v9, function() -- line: 17
	-- upvalues: u8 (ref)
	return u8
end)

task.defer(function() -- line: 21
	-- upvalues: RobloxGui (copy), u8 (ref), v9 (copy)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	SettingsHub.CurrentPageSignal:connect(function(p1) -- line: 23
		-- upvalues: u8 (ref), SettingsHub (copy), v9 (copy)
		u8 = p1 == SettingsHub.Instance.ResetCharacterPage.Page.Name
		v9:fire()
	end)
end)

return {
	respawnPageOpenSignal = v10,
	respawnPage = function(t1: {[any]: any}?) -- line: 33
		-- upvalues: RobloxGui (copy), u8 (ref), FFlagRespawnChromeShortcutTelemetry (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local ResetCharacterPage = SettingsHub.Instance.ResetCharacterPage

		local function switchToRespawnPage() -- line: 36
			-- upvalues: t1 (copy), SettingsHub (copy), ResetCharacterPage (copy)
			local t2 = {
				used_shortcut = if not t1 then nil else t1.usedShortcut
			}

			SettingsHub.Instance:SwitchToPage(ResetCharacterPage, true, nil, nil, nil, t2)
		end

		if SettingsHub:GetVisibility() then
			if u8 then
				SettingsHub:SetVisibility(false)

				return
			end

			if FFlagRespawnChromeShortcutTelemetry then
				local t3 = {
					used_shortcut = if not t1 then nil else t1.usedShortcut
				}

				SettingsHub.Instance:SwitchToPage(ResetCharacterPage, true, nil, nil, nil, t3)

				return
			end

			SettingsHub.Instance:SwitchToPage(ResetCharacterPage, true)

			return
		end

		if FFlagRespawnChromeShortcutTelemetry then
			SettingsHub:SetVisibility(true)

			local t4 = {
				used_shortcut = if not t1 then nil else t1.usedShortcut
			}

			SettingsHub.Instance:SwitchToPage(ResetCharacterPage, true, nil, nil, nil, t4)

			return
		end

		SettingsHub:SetVisibility(true, false, ResetCharacterPage)
	end
}
