local Chrome = script:FindFirstAncestor("Chrome")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local u13 = false
local v14 = Signal.new()
local v15 = MappedSignal.new(v14, function() -- line: 27
	-- upvalues: u13 (ref)
	return u13
end)

task.defer(function() -- line: 32
	-- upvalues: RobloxGui (copy), u13 (ref), v14 (copy)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	SettingsHub.CurrentPageSignal:connect(function(p1) -- line: 34
		-- upvalues: u13 (ref), SettingsHub (copy), v14 (copy)
		u13 = p1 == SettingsHub.Instance.ReportAbusePage.Page.Name
		v14:fire()
	end)
end)

return Service:register({
	id = "trust_and_safety",
	label = "CoreScripts.InGameMenu.QuickActions.Report",
	initialAvailability = Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 45
		-- upvalues: RobloxGui (copy), u13 (ref)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if SettingsHub:GetVisibility() then
			if u13 then
				SettingsHub:SetVisibility(false)

				return
			end

			SettingsHub:SwitchToPage(SettingsHub.Instance.ReportAbusePage, true)

			return
		end

		SettingsHub:SetVisibility(true, false, SettingsHub.Instance.ReportAbusePage)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 59
		-- upvalues: v15 (copy)
		return v15:get()
	end or v15,
	components = {
		Icon = function(_) -- line: 63
			-- upvalues: FFlagStandardizeSafetyIcon (copy), CommonIcon (copy), v15 (copy)
			if FFlagStandardizeSafetyIcon then
				return CommonIcon("Flag", nil, v15)
			end

			return CommonIcon("icons/menu/safety_off", "icons/menu/safety_on", v15)
		end
	}
})
