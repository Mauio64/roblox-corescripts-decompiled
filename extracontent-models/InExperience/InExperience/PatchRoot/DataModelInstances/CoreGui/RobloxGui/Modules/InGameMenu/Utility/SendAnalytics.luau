local UserInputService = game:GetService("UserInputService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local InputTypeMap = Constants.InputTypeMap

return function(p1, p2, p3, p4, p5) -- line: 11
	-- upvalues: RbxAnalyticsService (copy), UserInputService (copy), Constants (copy), InputTypeMap (copy), EngineFeature (copy)
	if p5 == nil then
		p5 = RbxAnalyticsService
	end

	local function reportSettingsForAnalytics() -- line: 17
		-- upvalues: UserInputService (copy)
		local GameSettings = UserSettings().GameSettings
		local t1 = {}

		if UserInputService.TouchEnabled then
			t1.camera_mode_touch = tostring(GameSettings.TouchCameraMovementMode)
		else
			t1.camera_mode_desktop = tostring(GameSettings.ComputerCameraMovementMode)
		end

		if UserInputService.TouchEnabled then
			t1.movement_mode_touch = tostring(GameSettings.TouchMovementMode)
		else
			t1.movement_mode_desktop = tostring(GameSettings.ComputerMovementMode)
		end

		if UserInputService.MouseEnabled then
			t1.shift_lock_enabled = tostring(GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
		end

		if UserInputService.GamepadEnabled and GameSettings.IsUsingGamepadCameraSensitivity then
			t1.camera_sensitivity_gamepad = string.format("%.2f", GameSettings.GamepadCameraSensitivity)
		end

		if UserInputService.MouseEnabled then
			t1.camera_sensitivity_mouse = string.format("%.2f", GameSettings.MouseSensitivityFirstPerson.X)
		end

		t1.camera_y_inverted = tostring(GameSettings.CameraYInverted)
		t1.show_performance_stats = tostring(GameSettings.PerformanceStatsVisible)
		t1.volume = tostring((math.floor(GameSettings.MasterVolume * 10 + 0.5)))
		t1.gfx_quality_level = tostring(settings().Rendering.QualityLevel)
		t1.fullscreen_enabled = tostring(GameSettings:InFullScreen())
		t1.microprofiler_enabled = tostring(GameSettings.OnScreenProfilerEnabled)
		t1.microprofiler_webserver_enabled = tostring(GameSettings.MicroProfilerWebServerEnabled)

		return t1
	end

	if p4 == true then
		p3 = reportSettingsForAnalytics()
		p2 = Constants.AnalyticsSettingsChangeName
		p1 = Constants.AnalyticsInGameMenuName
	end

	if not p3 then
		p3 = {}
	end

	p3.universeid = tostring(game.GameId)
	p3.inputDevice = tostring(InputTypeMap[UserInputService:GetLastInputType()] or UserInputService:GetLastInputType())

	if p3.playsessionid == nil and EngineFeature then
		p3.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	p5:SetRBXEventStream(Constants.AnalyticsTargetName, p1, p2, p3)
end
