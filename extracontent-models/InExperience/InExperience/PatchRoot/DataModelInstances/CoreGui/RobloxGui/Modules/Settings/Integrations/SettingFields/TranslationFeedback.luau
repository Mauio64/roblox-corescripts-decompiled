local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Settings = script:FindFirstAncestor("Settings")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local SafetyService = game:GetService("SafetyService")
local Constants = require(Settings.Integrations.Constants)
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local v12 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function TranslationFeedbackValue() -- line: 24
	-- upvalues: ValueChangedSignal (copy), ExperienceStateCaptureService (copy), SafetyService (copy)
	local v18 = ValueChangedSignal.new()

	v18:connect(function() -- line: 27
		-- upvalues: ExperienceStateCaptureService (copy), SafetyService (copy)
		if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not ExperienceStateCaptureService:CanEnterCaptureMode() then
			return
		end

		local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

		if SettingsHub then
			SettingsHub:SetVisibility(false)
		end

		if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
			SafetyService.IsCaptureModeForReport = false
		end

		if game:GetEngineFeature("CaptureModeEnabled") then
			ExperienceStateCaptureService:ToggleCaptureMode()
		end
	end)

	return v18
end
local function TranslationFeedbackAvailability() -- line: 53
	-- upvalues: AvailabilitySignal (copy), RunService (copy), v12 (copy)
	local v19 = AvailabilitySignal.new(true)

	if RunService:IsStudio() or (game:GetEngineFeature("CaptureModeEnabled") == false or v12) then
		v19:set(false)
	end

	return v19
end

local v16 = ValueChangedSignal.new()

v16:connect(function() -- line: 27
	-- upvalues: ExperienceStateCaptureService (copy), SafetyService (copy)
	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not ExperienceStateCaptureService:CanEnterCaptureMode() then
		return
	end

	local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

	if SettingsHub then
		SettingsHub:SetVisibility(false)
	end

	if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
		SafetyService.IsCaptureModeForReport = false
	end

	if game:GetEngineFeature("CaptureModeEnabled") then
		ExperienceStateCaptureService:ToggleCaptureMode()
	end
end)

local v17 = AvailabilitySignal.new(true)

if RunService:IsStudio() or (game:GetEngineFeature("CaptureModeEnabled") == false or v12) then
	v17:set(false)
end

return {
	id = "translation-feedback",
	label = "CoreScripts.InGameMenu.GameSettings.GiveTranslationFeedback",
	text = "CoreScripts.InGameMenu.GameSettings.GiveFeedback",
	alreadyLocalized = false,
	field_type = SettingEnum.TextButton,
	onActivated = v16,
	layoutOrder = LAYOUT_ORDER.FeedbackModeButton,
	availability = v17
}
