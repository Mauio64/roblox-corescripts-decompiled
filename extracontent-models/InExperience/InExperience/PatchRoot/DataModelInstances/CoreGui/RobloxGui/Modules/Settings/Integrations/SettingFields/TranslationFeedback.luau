local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
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

local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function TranslationFeedbackValue()
	local v = ValueChangedSignal.new()

	v:connect(function()
		if
			game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
			and not ExperienceStateCaptureService:CanEnterCaptureMode()
		then
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

	return v
end

local function TranslationFeedbackAvailability() -- 1 equivalent call inferred from this helper
	local v = AvailabilitySignal.new(true)

	if RunService:IsStudio() or game:GetEngineFeature("CaptureModeEnabled") == false or isEnabled then
		v:set(false)
	end

	return v
end

local onActivated = ValueChangedSignal.new()

onActivated:connect(function()
	if
		game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
		and not ExperienceStateCaptureService:CanEnterCaptureMode()
	then
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
local availability = TranslationFeedbackAvailability() -- inferred equivalent call
return {
	field_type = SettingEnum.TextButton,
	id = "translation-feedback",
	onActivated = onActivated,
	label = "CoreScripts.InGameMenu.GameSettings.GiveTranslationFeedback",
	text = "CoreScripts.InGameMenu.GameSettings.GiveFeedback",
	layoutOrder = LAYOUT_ORDER.FeedbackModeButton,
	alreadyLocalized = false,
	availability = availability
}
