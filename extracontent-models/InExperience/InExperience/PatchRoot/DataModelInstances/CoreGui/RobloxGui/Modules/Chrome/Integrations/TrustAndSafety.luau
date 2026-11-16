local Chrome = script:FindFirstAncestor("Chrome")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon

local v = false
local v2 = Signal.new()
local isActivated = MappedSignal.new(v2, function()
	return v
end)

task.defer(function()
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	SettingsHub.CurrentPageSignal:connect(function(p)
		v = p == SettingsHub.Instance.ReportAbusePage.Page.Name
		v2:fire()
	end)
end)

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Available,
	id = "trust_and_safety",
	label = "CoreScripts.InGameMenu.QuickActions.Report",
	sideSheetPlacement = SideSheetPlacement.AboveFold,
	activated = function(_)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if not SettingsHub:GetVisibility() then
			SettingsHub:SetVisibility(true, false, SettingsHub.Instance.ReportAbusePage)
		elseif v then
			SettingsHub:SetVisibility(false)
		else
			SettingsHub:SwitchToPage(SettingsHub.Instance.ReportAbusePage, true)
		end
	end,
	isActivated = isActivated,
	components = {
		Icon = function(_)
			if FFlagStandardizeSafetyIcon then
				return CommonIcon("Flag", nil, isActivated)
			end

			return CommonIcon("icons/menu/safety_off", "icons/menu/safety_on", isActivated)
		end
	}
})
