local UserInputService = game:GetService("UserInputService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = script.Parent.Parent
local Constants = require(parent.Resources.Constants)

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local InputTypeMap = Constants.InputTypeMap

return function(p, p2, options, p3, object)
	if object == nil then
		object = RbxAnalyticsService
	end

	local function reportSettingsForAnalytics()
		local gameSettings = UserSettings().GameSettings

		local v = {}

		if UserInputService.TouchEnabled then
			v.camera_mode_touch = tostring(gameSettings.TouchCameraMovementMode)
		else
			v.camera_mode_desktop = tostring(gameSettings.ComputerCameraMovementMode)
		end

		if UserInputService.TouchEnabled then
			v.movement_mode_touch = tostring(gameSettings.TouchMovementMode)
		else
			v.movement_mode_desktop = tostring(gameSettings.ComputerMovementMode)
		end

		if UserInputService.MouseEnabled then
			v.shift_lock_enabled = tostring(gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
		end

		if UserInputService.GamepadEnabled and gameSettings.IsUsingGamepadCameraSensitivity then
			v.camera_sensitivity_gamepad = string.format("%.2f", gameSettings.GamepadCameraSensitivity)
		end

		if UserInputService.MouseEnabled then
			v.camera_sensitivity_mouse = string.format("%.2f", gameSettings.MouseSensitivityFirstPerson.X)
		end

		v.camera_y_inverted = tostring(gameSettings.CameraYInverted)
		v.show_performance_stats = tostring(gameSettings.PerformanceStatsVisible)
		v.volume = tostring((math.floor(gameSettings.MasterVolume * 10 + 0.5)))
		v.gfx_quality_level = tostring(settings().Rendering.QualityLevel)
		v.fullscreen_enabled = tostring(gameSettings:InFullScreen())
		v.microprofiler_enabled = tostring(gameSettings.OnScreenProfilerEnabled)
		v.microprofiler_webserver_enabled = tostring(gameSettings.MicroProfilerWebServerEnabled)

		return v
	end

	if p3 == true then
		options = reportSettingsForAnalytics()
		p2 = Constants.AnalyticsSettingsChangeName
		p = Constants.AnalyticsInGameMenuName
	end

	local v = options or {}

	v.universeid = tostring(game.GameId)

	v.inputDevice = tostring(InputTypeMap[UserInputService:GetLastInputType()] or UserInputService:GetLastInputType())

	if v.playsessionid == nil and engineFeature then
		v.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	object:SetRBXEventStream(Constants.AnalyticsTargetName, p, p2, v)
end
