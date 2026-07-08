local Chrome = script:FindFirstAncestor("Chrome")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local CapturesApp = require(RobloxGui.Modules.Captures.CapturesApp)
local CapturesPolicy = require(CorePackages.Workspace.Packages.CapturesInExperience).CapturesPolicy
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local _ = Service.AvailabilitySignal.Available
local v17 = if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) and not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures) then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available
local v18 = MappedSignal.new(CapturesApp.onIsActiveChanged, function() -- line: 28
	-- upvalues: CapturesApp (copy)
	return CapturesApp.getIsActive()
end)
local v19 = Service:register({
	id = "camera_entrypoint",
	label = "Feature.SettingsHub.Label.Captures",
	initialAvailability = v17,
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 37
		-- upvalues: CapturesApp (copy)
		CapturesApp.onToggleActivationFromChrome()
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 42
		-- upvalues: v18 (copy)
		return v18:get()
	end or v18,
	components = {
		Icon = function(_) -- line: 46
			-- upvalues: CommonIcon (copy), v18 (copy)
			return CommonIcon("icons/controls/cameraOff", "icons/controls/cameraOn", v18)
		end
	}
})

ChromeUtils.setCoreGuiAvailability(v19, Enum.CoreGuiType.Captures)

if FFlagEnableConsoleExpControls then
	local v20 = CapturesPolicy.PolicyImplementation.read()

	if not v20 or not CapturesPolicy.Mapper(v20).eligibleForCapturesFeature() then
		v19.availability:forceUnavailable()
	end
end

return v19
