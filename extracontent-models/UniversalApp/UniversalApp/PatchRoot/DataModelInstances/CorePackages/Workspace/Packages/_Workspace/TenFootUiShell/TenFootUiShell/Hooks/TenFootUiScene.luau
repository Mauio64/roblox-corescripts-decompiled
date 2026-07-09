local Lighting = game:GetService("Lighting")
local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local Constants = require(TenFootUiShell.Constants)
local Constants2 = require(TenFootUiShell.ReactNavigationExtend.Views.Constants)
local TenFootUiShellParent = TenFootUiShell.Parent
local SceneManagement = require(TenFootUiShellParent.SceneManagement)
local Lighting2 = SceneManagement.Lighting
local BackgroundScene = SceneManagement.BackgroundScene
local Otter = require(TenFootUiShellParent.Otter)
local SharedFlags = require(TenFootUiShellParent.SharedFlags)
local FFlagEnableCoreContentTheme = SharedFlags.FFlagEnableCoreContentTheme
local FFlagEnableCoreContentThemeConsole = SharedFlags.FFlagEnableCoreContentThemeConsole
local FFlagUseDefaultOverrideColorsFor10ftModels = SharedFlags.FFlagUseDefaultOverrideColorsFor10ftModels
local getSceneOverridesStore = require(TenFootUiShellParent.Style).getSceneOverridesStore
local BACKGROUND_MODEL_NAME = Constants.BACKGROUND_MODEL_NAME
local v16 = game:DefineFastInt("TenFootSkyboxBlockerSizeX", 2048)
local v17 = game:DefineFastInt("TenFootSkyboxBlockerSizeY", 2048)
local v18 = game:DefineFastInt("TenFootSkyboxBlockerSizeZ", 2)
local v19 = game:DefineFastInt("TenFootSkyboxBlockerPositionX", 0)
local v20 = game:DefineFastInt("TenFootSkyboxBlockerPositionY", 27)
local v21 = game:DefineFastInt("TenFootSkyboxBlockerPositionZ", -300)
local color3 = Color3.fromRGB(66, 63, 65)
local color3_2 = Color3.fromRGB(90, 91, 98)
local color3_3 = Color3.fromRGB(55, 56, 59)
local t1 = {
	BackgroundConfigs = {
		PositionOffset = Vector3.new(10, 0, 0),
		RotationOffset = Vector3.new(0, 50, 0),
		BackgroundModelName = BACKGROUND_MODEL_NAME,
		DistanceToCamera = Constants2.DEFAULT_BACKGROUND_DISTANCE_TO_CAMERA
	},
	CameraConfigs = {
		FieldOfView = 50,
		Position = Constants.CAMERA_POSITION
	}
}
local t2 = {
	positionX = Otter.createSingleMotor(0),
	positionZ = Otter.createSingleMotor(0)
}
local t3 = {}
local u28 = nil

local function shutDownMotors() -- line: 73
	-- upvalues: t3 (ref)
	for _, v37 in t3 do
		v37()
	end

	table.clear(t3)
end
local function getOrCreateSkyboxBlocker(p1) -- line: 80
	-- upvalues: v16 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy)
	local SkyboxBlocker = p1:FindFirstChild("SkyboxBlocker")

	if SkyboxBlocker and SkyboxBlocker:IsA("BasePart") then
		return SkyboxBlocker
	end

	local Part = Instance.new("Part")

	Part.Name = "SkyboxBlocker"
	Part.Material = Enum.Material.SmoothPlastic
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Size = Vector3.new(v16, v17, v18)
	Part.Position = Vector3.new(v19, v20, v21)
	Part.Transparency = 1
	Part.Parent = p1

	return Part
end
local function applySceneOverrides(p2, t4: {[any]: any}?) -- line: 106
	-- upvalues: FFlagUseDefaultOverrideColorsFor10ftModels (copy), color3 (copy), color3_2 (copy), FFlagEnableCoreContentTheme (copy), Lighting (copy), color3_3 (copy)
	local SkyboxBlocker = p2:FindFirstChild("SkyboxBlocker")

	if not t4 then
		if SkyboxBlocker and SkyboxBlocker:IsA("BasePart") then
			SkyboxBlocker.Transparency = 1
		end

		if not FFlagUseDefaultOverrideColorsFor10ftModels then
			return
		end
	end

	if (not FFlagUseDefaultOverrideColorsFor10ftModels or t4) and SkyboxBlocker and SkyboxBlocker:IsA("BasePart") then
		SkyboxBlocker.Color = t4.SkyboxBlockerColor
		SkyboxBlocker.Transparency = t4.SkyboxBlockerTransparency
	end

	local Baseplate = p2:FindFirstChild("Baseplate")

	if Baseplate and Baseplate:IsA("BasePart") then
		Baseplate.Color = if not not FFlagUseDefaultOverrideColorsFor10ftModels and not t4 then color3 else t4.Baseplate
	end

	local Clouds = p2:FindFirstChild("Clouds")

	if Clouds and Clouds:IsA("BasePart") then
		local v46 = if not not FFlagUseDefaultOverrideColorsFor10ftModels and not t4 then color3_2 else t4.Clouds

		Clouds.Color = v46

		for _, child in Clouds:GetChildren() do
			if child:IsA("Texture") then
				child.Color3 = v46
			end
		end
	end

	local LargerShapes = p2:FindFirstChild("LargerShapes")

	if LargerShapes and LargerShapes:IsA("BasePart") then
		local v50 = if not not FFlagUseDefaultOverrideColorsFor10ftModels and not t4 then color3_2 else t4.LargerShapes

		LargerShapes.Color = v50

		for _, child in LargerShapes:GetChildren() do
			if child:IsA("Texture") then
				child.Color3 = v50
			end
		end
	end

	if FFlagEnableCoreContentTheme then
		Lighting.FogColor = if not not FFlagUseDefaultOverrideColorsFor10ftModels and not t4 then color3_3 else t4.FogColor
	end
end
local function cleanUpSceneOverrides() -- line: 167
	-- upvalues: u28 (ref)
	if u28 then
		u28()
		u28 = nil
	end
end
local function startUpSceneOverrides(p3) -- line: 174
	-- upvalues: u28 (ref), getOrCreateSkyboxBlocker (copy), getSceneOverridesStore (copy), applySceneOverrides (copy)
	if u28 then
		u28()
		u28 = nil
	end

	getOrCreateSkyboxBlocker(p3)

	local v54 = getSceneOverridesStore()
	local v55 = v54.getSceneOverrides()

	applySceneOverrides(p3, v55)
	u28 = v54.subscribe(function(p4) -- line: 182
		-- upvalues: applySceneOverrides (copy), p3 (copy)
		applySceneOverrides(p3, p4)
	end)
end
local function startUpMotors(p5) -- line: 187
	-- upvalues: t3 (ref), t2 (ref), BackgroundScene (copy), BACKGROUND_MODEL_NAME (copy)
	for _, v58 in t3 do
		v58()
	end

	table.clear(t3)

	local Position = p5:GetPivot().Position

	t3 = {
		t2.positionX:onStep(function(p6) -- line: 193
			-- upvalues: BackgroundScene (copy), BACKGROUND_MODEL_NAME (copy), Position (copy)
			BackgroundScene.updateXPosition(BACKGROUND_MODEL_NAME, Position.X + p6)
		end),
		t2.positionZ:onStep(function(p7) -- line: 196
			-- upvalues: BackgroundScene (copy), BACKGROUND_MODEL_NAME (copy), Position (copy)
			BackgroundScene.updateZPosition(BACKGROUND_MODEL_NAME, Position.Z + p7)
		end)
	}
end
local function deinitialize() -- line: 213
	-- upvalues: t3 (ref), u28 (ref)
	for _, v64 in t3 do
		v64()
	end

	table.clear(t3)

	if u28 then
		u28()
		u28 = nil
	end
end

return {
	initialize = function(t5: {[any]: any}?) -- line: 202
		-- upvalues: Lighting2 (copy), t2 (ref), BackgroundScene (copy), t1 (copy), startUpMotors (copy), FFlagEnableCoreContentTheme (copy), FFlagEnableCoreContentThemeConsole (copy), startUpSceneOverrides (copy)
		Lighting2.configure()
		t2 = t5 or t2

		local v61, v62 = BackgroundScene.initialize(t1)

		startUpMotors(v61)

		if FFlagEnableCoreContentTheme and FFlagEnableCoreContentThemeConsole then
			startUpSceneOverrides(v61)
		end

		return v61, v62
	end,
	deinitialize = if not FFlagEnableCoreContentTheme or not FFlagEnableCoreContentThemeConsole then shutDownMotors else deinitialize,
	updateXPosition = function(n1: number) -- line: 222
		-- upvalues: t2 (ref), Otter (copy), Constants2 (copy)
		t2.positionX:setGoal(Otter.spring(n1, Constants2.X_DIRECTION_ANIMATION_SPRING_CONFIG))
	end,
	updateZPosition = function(n2: number) -- line: 226
		-- upvalues: t2 (ref), Otter (copy), Constants2 (copy)
		t2.positionZ:setGoal(Otter.spring(n2, Constants2.Z_DIRECTION_ANIMATION_SPRING_CONFIG))
	end,
	getBackgroundInstance = function() -- line: 218
		-- upvalues: BackgroundScene (copy), BACKGROUND_MODEL_NAME (copy)
		return BackgroundScene.getBackgroundInstance(BACKGROUND_MODEL_NAME)
	end
}
