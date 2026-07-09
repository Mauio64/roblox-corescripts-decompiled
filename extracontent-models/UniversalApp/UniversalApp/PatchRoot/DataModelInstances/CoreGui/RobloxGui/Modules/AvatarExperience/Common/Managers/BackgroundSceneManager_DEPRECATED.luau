local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local NotificationService = game:GetService("NotificationService")
local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local AssetService = game:GetService("AssetService")
local ContentProvider = game:GetService("ContentProvider")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local LightUtility = require(CorePackages.Packages.Thumbnailing).LightUtility
local Signals = require(CorePackages.Packages.Signals)
local ParticleEffectManager = require(Modules.AvatarExperience.Common.Managers.ParticleEffectManager)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local GetFIntAvatarEditorParticleEmitterRateOverride = require(Modules.LuaApp.Flags.GetFIntAvatarEditorParticleEmitterRateOverride)
local FFlagUseUpdatedBackgroundSceneSettingsOnMobile = require(Modules.AvatarExperience.Flags.FFlagUseUpdatedBackgroundSceneSettingsOnMobile)
local FFlagAXGuardCharacterSpotLightSideAccess = require(Modules.AvatarExperience.Flags.FFlagAXGuardCharacterSpotLightSideAccess)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getSceneOverridesStore = require(CorePackages.Workspace.Packages.Style).getSceneOverridesStore
local v20 = game:DefineFastInt("AXSkyboxBlockerSizeX", 31)
local v21 = game:DefineFastInt("AXSkyboxBlockerSizeY", 175)
local v22 = game:DefineFastInt("AXSkyboxBlockerSizeZ", 400)
local v23 = game:DefineFastInt("AXSkyboxBlockerPositionX", -50)
local v24 = game:DefineFastInt("AXSkyboxBlockerPositionY", 77)
local v25 = game:DefineFastInt("AXSkyboxBlockerPositionZ", -9)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local FFlagAXBackgroundCycloramaRendering = AvatarExperienceFlags.FFlagAXBackgroundCycloramaRendering
local FFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local loadBackgroundAsset = AvatarExperienceCommon.Backgrounds.loadBackgroundAsset
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local mutedError = require(Modules.LuaApp.mutedError)
local PhotoboothSceneData = require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothSceneData)
local PhotoboothStoreBridge = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).PhotoboothStoreBridge
local Constants = require(Modules.AvatarExperience.Common.Constants)
local BackgroundType = Constants.BackgroundType
local ParticleType = Constants.ParticleType
local PagePlayParticleType = Constants.PagePlayParticleType
local PageBackgroundType = Constants.PageBackgroundType
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0.4)
local vector2 = Vector2.new(3, 3)
local v44 = CFrame.new(0, 0, -6) * CFrame.Angles(0, 3.141592653589793, 0)
local t1 = {}

t1.__index = t1

local t2 = {
	Lighting = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then {
		Brightness = 2,
		ClockTime = 12,
		GeographicLatitude = 41.733,
		TimeOfDay = "12:00:00",
		FogEnd = 92,
		FogStart = 20,
		ColorShift_Bottom = Color3.fromRGB(232, 255, 146),
		ColorShift_Top = Color3.fromRGB(85, 136, 167),
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		Ambient = Color3.fromRGB(170, 170, 170),
		FogColor = Color3.fromRGB(45, 46, 49),
		Sky = {
			CelestialBodiesShown = true,
			StarCount = 3000
		}
	} else {
		Brightness = 2,
		ClockTime = 11,
		FogEnd = 92,
		GeographicLatitude = 24,
		TimeOfDay = "11:00:00",
		ColorShift_Bottom = Color3.fromRGB(108, 94, 66),
		ColorShift_Top = Color3.fromRGB(94, 100, 172),
		OutdoorAmbient = Color3.fromRGB(0, 0, 0)
	},
	Bloom = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then {
		Intensity = 0.3,
		Size = 12,
		Threshold = 0.95
	} else {
		Intensity = 0.2,
		Size = 12,
		Threshold = 0.95
	},
	ColorCorrection = {
		Brightness = 0,
		Contrast = 0,
		Saturation = 0
	}
}
local t3 = {
	Lighting = {
		Brightness = 1,
		ClockTime = 14,
		GeographicLatitude = 41.733,
		TimeOfDay = "14:00:00",
		FogEnd = 100000,
		FogStart = 0,
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(127, 127, 127),
		Ambient = Color3.fromRGB(127, 127, 127),
		FogColor = Color3.fromRGB(192, 192, 192),
		Sky = {
			CelestialBodiesShown = true,
			StarCount = 3000
		}
	}
}
local t4 = {
	LightTheme = {
		CharacterSpotLightBrightness = 6,
		SkyboxAssetLocation = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
		AmbientLightColor = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else Color3.fromRGB(130, 130, 130),
		EnvironmentDiffuseScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 0.2,
		EnvironmentSpecularScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 1,
		FogStart = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 30,
		BackPanelTextureColor = Color3.fromRGB(213, 213, 213),
		CloudsTextureColor = Color3.fromRGB(222, 222, 222),
		LargerShapesTextureColor = Color3.fromRGB(222, 222, 222),
		BasePlateColor = Color3.fromRGB(213, 213, 213),
		FogColor = Color3.fromRGB(213, 213, 213),
		ParticleEmitterColorCatalogToAE = ColorSequence.new(Color3.fromRGB(171, 169, 161), Color3.fromRGB(158, 135, 120)),
		ParticleEmitterColorAEToCatalog = ColorSequence.new(Color3.fromRGB(158, 135, 120), Color3.fromRGB(171, 169, 161))
	},
	DarkTheme = {
		CharacterSpotLightBrightness = 12,
		SkyboxAssetLocation = "rbxasset://textures/ui/AvatarExperience/AvatarExperienceSkyboxDarkTheme.png",
		AmbientLightColor = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else Color3.fromRGB(180, 180, 180),
		EnvironmentDiffuseScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 1,
		EnvironmentSpecularScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 1,
		FogStart = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 20,
		BackPanelTextureColor = Color3.fromRGB(83, 80, 82),
		CloudsTextureColor = Color3.fromRGB(100, 101, 108),
		LargerShapesTextureColor = Color3.fromRGB(100, 101, 108),
		BasePlateColor = Color3.fromRGB(83, 80, 82),
		FogColor = Color3.fromRGB(55, 56, 59),
		ParticleEmitterColorCatalogToAE = ColorSequence.new(Color3.fromRGB(79, 75, 79), Color3.fromRGB(51, 49, 52)),
		ParticleEmitterColorAEToCatalog = ColorSequence.new(Color3.fromRGB(51, 49, 52), Color3.fromRGB(79, 75, 79))
	}
}
local t5 = {
	LargerShapes = {
		TextureWallTransparency = 1,
		LargerShapesPosition = Vector3.new(-62.89799880981445, 6.96999979019165, -8.8149995803833),
		CloudsPosition = Vector3.new(-90, 20, 0),
		BaseplateTransparency = 0
	},
	Walls = {
		TextureWallTransparency = 0,
		LargerShapesPosition = Vector3.new(-62.89799880981445, -12.300000190734863, -8.8149995803833),
		CloudsPosition = Vector3.new(-90, 80, 0),
		BaseplateTransparency = 0
	},
	NoShapesNoWalls = {
		TextureWallTransparency = 1,
		LargerShapesPosition = Vector3.new(-62.89799880981445, -1000, -8.8149995803833),
		CloudsPosition = Vector3.new(-90, 1000, 0),
		BaseplateTransparency = 1
	}
}

local function darkenPixelBuffer(p1: buffer, n1: number) -- line: 233
	for i = 0, buffer.len(p1) - 4, 4 do
		for j = 0, 2 do
			local v60 = math.clamp(math.round(buffer.readu8(p1, i + j) * n1), 0, 255)

			buffer.writeu8(p1, i + j, v60)
		end
	end
end

t1.darkenPixelBuffer = darkenPixelBuffer

local function applyDownsampledColorTexture(p2, p3, n2: number) -- line: 249
	-- upvalues: AssetService (copy), mutedError (copy), vector2 (copy), darkenPixelBuffer (copy)
	if not p2:IsA("MeshPart") then
		return
	end

	local activeToken = p3.activeToken

	task.spawn(function() -- line: 256
		-- upvalues: AssetService (copy), n2 (copy), mutedError (copy), activeToken (copy), p3 (copy), vector2 (copy), darkenPixelBuffer (copy), p2 (copy)
		local ok, result = pcall(function() -- line: 257
			-- upvalues: AssetService (copy), n2 (copy)
			return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{ n2 }`))
		end)

		if not ok or not result then
			mutedError("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(n2))

			return
		end

		if activeToken ~= p3.activeToken then
			return
		end

		local v230 = AssetService:CreateEditableImage({
			Size = vector2
		})

		if not v230 then
			mutedError("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")

			return
		end

		local resultSize = result.Size

		v230:DrawImageTransformed(Vector2.zero, Vector2.new(vector2.X / resultSize.X, vector2.Y / resultSize.Y), 0, result, {
			CombineType = Enum.ImageCombineType.Overwrite,
			PivotPoint = Vector2.zero
		})

		local v232 = v230:ReadPixelsBuffer(Vector2.zero, vector2)

		darkenPixelBuffer(v232, 0.5)
		v230:WritePixelsBuffer(Vector2.zero, vector2, v232)

		if activeToken ~= p3.activeToken then
			return
		end

		p2.TextureContent = Content.fromObject(v230)
	end)
end
local function getActiveTextureBuffer(p4) -- line: 313
	return p4.textureBuffers[p4.activeTextureIndex]
end
local function getIdleTextureBuffer(p5) -- line: 317
	return p5.textureBuffers[3 - p5.activeTextureIndex]
end
local function cancelCrossfadeTweens(p6) -- line: 324
	if p6.crossfadeTweens then
		for _, v69 in p6.crossfadeTweens do
			v69:Cancel()
		end

		p6.crossfadeTweens = nil
	end
end

function t1.stageCrossfade(p7, p8, p9) -- line: 337
	-- upvalues: AssetService (copy), mutedError (copy), vector2 (copy), darkenPixelBuffer (copy)
	local imageId = p9.imageId

	if p8:IsA("MeshPart") then
		local activeToken = p7.activeToken

		task.spawn(function() -- line: 256
			-- upvalues: AssetService (copy), imageId (copy), mutedError (copy), activeToken (copy), p7 (copy), vector2 (copy), darkenPixelBuffer (copy), p8 (copy)
			local ok, result = pcall(function() -- line: 257
				-- upvalues: AssetService (copy), imageId (copy)
				return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{ imageId }`))
			end)

			if not ok or not result then
				mutedError("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(imageId))

				return
			end

			if activeToken ~= p7.activeToken then
				return
			end

			local v235 = AssetService:CreateEditableImage({
				Size = vector2
			})

			if not v235 then
				mutedError("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")

				return
			end

			local resultSize = result.Size

			v235:DrawImageTransformed(Vector2.zero, Vector2.new(vector2.X / resultSize.X, vector2.Y / resultSize.Y), 0, result, {
				CombineType = Enum.ImageCombineType.Overwrite,
				PivotPoint = Vector2.zero
			})

			local v237 = v235:ReadPixelsBuffer(Vector2.zero, vector2)

			darkenPixelBuffer(v237, 0.5)
			v235:WritePixelsBuffer(Vector2.zero, vector2, v237)

			if activeToken ~= p7.activeToken then
				return
			end

			p8.TextureContent = Content.fromObject(v235)
		end)
	end

	local v75 = p7.textureBuffers[3 - p7.activeTextureIndex]

	v75.Transparency = 1

	if v75:IsA("MeshPart") then
		v75.TextureContent = Content.fromUri(`rbxassetid://{ p9.imageId }`)
	end

	return v75
end

local function hideCycloramaSceneElements(p10, b1: boolean?) -- line: 356
	-- upvalues: TweenService (copy), tweenInfo (copy), t5 (copy)
	TweenService:Create(p10.Baseplate, tweenInfo, {
		Transparency = 1
	}):Play()

	if not b1 then
		p10.LargerShapes.Position = t5.NoShapesNoWalls.LargerShapesPosition
		p10.Clouds.Position = t5.NoShapesNoWalls.CloudsPosition
	end

	p10.BackPanel.TextureWall.Transparency = 1
	p10.BackPanel.TextureFloor.Transparency = 1
end

function t1.new(p11, p12, p13, p14) -- line: 372
	-- upvalues: t1 (copy), FFlagAXBackgroundsCycloramaVR (copy), ParticleEffectManager (copy), Lighting (copy), ReplicatedStorage (copy), FFlagAXPhotoboothFunctionality (copy), ParticleType (copy), t5 (copy), NotificationService (copy), FFlagAXBackgroundCycloramaRendering (copy)
	local t6 = {}

	setmetatable(t6, t1)
	t6.connections = {}
	t6.store = p11
	t6.networking = p12
	t6.avatarRoute = p13
	t6.isSpatial = p14 or false

	if FFlagAXBackgroundsCycloramaVR and t6.isSpatial then
		t6:initCyclorama()

		return t6
	end

	t6.ParticleEffectManager = ParticleEffectManager.new(p11, p13)
	t6.colorCorrection = Lighting:FindFirstChild("ColorCorrection")

	if not t6.colorCorrection then
		t6.colorCorrection = Instance.new("ColorCorrectionEffect")
		t6.colorCorrection.Parent = Lighting
	end

	t6.bloom = Lighting:FindFirstChild("Bloom")

	if not t6.bloom then
		t6.bloom = Instance.new("BloomEffect")
		t6.bloom.Parent = Lighting
	end

	t6.newBackgroundScene = ReplicatedStorage:WaitForChild("AvatarSceneNew")
	t6.currentScene = nil

	if FFlagAXPhotoboothFunctionality then
		t6.currentSceneLighting = nil
	end

	t6.particleStorage = {
		[ParticleType.CatalogToAvatarEditor] = {
			largeParticleEmitter = t6.newBackgroundScene.CatalogToAvatarEditorPFX.BIGBOIS,
			smallParticleEmitter = t6.newBackgroundScene.CatalogToAvatarEditorPFX.SmolBois
		},
		[ParticleType.AvatarEditorToCatalog] = {
			largeParticleEmitter = t6.newBackgroundScene.AvatarEditorToCatalogPFX.BIGBOIS,
			smallParticleEmitter = t6.newBackgroundScene.AvatarEditorToCatalogPFX.SmolBois
		}
	}
	t6.newBackgroundScene.BackPanel.Transparency = t5.LargerShapes.TextureWallTransparency
	t6:setupTweening()

	local v83 = NotificationService.SelectedTheme or nil

	t6:updateTheme(string.lower(v83))

	if FFlagAXBackgroundCycloramaRendering then
		t6:initCyclorama()
	end

	return t6
end
function t1.initCyclorama(p15) -- line: 439
	-- upvalues: ReplicatedStorage (copy), mutedError (copy), FFlagAXBackgroundsCycloramaVR (copy), v44 (copy)
	local AvatarCyclorama = ReplicatedStorage:FindFirstChild("AvatarCyclorama")

	if not AvatarCyclorama then
		mutedError("BackgroundSceneManager: AvatarCyclorama missing from ReplicatedStorage")

		return
	end

	local texture_mesh = AvatarCyclorama:FindFirstChild("texture_mesh")
	local color_mesh = AvatarCyclorama:FindFirstChild("color_mesh")

	if not texture_mesh or not color_mesh then
		mutedError(string.format("BackgroundSceneManager: AvatarCyclorama missing texture_mesh=%s color_mesh=%s", tostring(texture_mesh ~= nil), (tostring(color_mesh ~= nil))))

		return
	end

	local clone = texture_mesh:Clone()

	clone.Name = "texture_mesh_buffer"
	clone.Parent = AvatarCyclorama
	p15.cyclorama = AvatarCyclorama
	p15.cycloramaFront = texture_mesh
	p15.cycloramaBack = color_mesh
	p15.cycloramaState = {
		activeToken = 0,
		currentAssetId = nil,
		activeTextureIndex = 1,
		textureBuffers = {
			texture_mesh,
			clone
		}
	}
	texture_mesh.Anchored = true
	color_mesh.Anchored = true
	clone.Anchored = true
	texture_mesh.Transparency = 1
	color_mesh.Transparency = 1
	clone.Transparency = 1

	if FFlagAXBackgroundsCycloramaVR and p15.isSpatial then
		AvatarCyclorama:PivotTo(v44)
	else
		AvatarCyclorama:PivotTo(CFrame.new(0, 0.01, 0) * CFrame.Angles(0, -1.5707963267948966, 0))
	end

	AvatarCyclorama.Parent = workspace
end
function t1.applyBackground(p16, p17) -- line: 499
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy), TweenService (copy), tweenInfo (copy), AssetService (copy), mutedError (copy), vector2 (copy), darkenPixelBuffer (copy), tweenInfo2 (copy), hideCycloramaSceneElements (copy)
	if not p16.cyclorama then
		return
	end

	if p16.cycloramaFront:IsA("MeshPart") then
		p16.cycloramaFront.TextureContent = Content.fromUri(`rbxassetid://{ p17.imageId }`)
	end

	if FFlagAXBackgroundsCycloramaVR and p16.isSpatial then
		TweenService:Create(p16.cycloramaFront, tweenInfo, {
			Transparency = 0.015
		}):Play()

		return
	end

	p16.cycloramaBack.Color = p17.backgroundColor

	local cycloramaBack = p16.cycloramaBack
	local cycloramaState = p16.cycloramaState
	local imageId = p17.imageId

	if cycloramaBack:IsA("MeshPart") then
		local activeToken = cycloramaState.activeToken

		task.spawn(function() -- line: 256
			-- upvalues: AssetService (copy), imageId (copy), mutedError (copy), activeToken (copy), cycloramaState (copy), vector2 (copy), darkenPixelBuffer (copy), cycloramaBack (copy)
			local ok, result = pcall(function() -- line: 257
				-- upvalues: AssetService (copy), imageId (copy)
				return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{ imageId }`))
			end)

			if not ok or not result then
				mutedError("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(imageId))

				return
			end

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			local v240 = AssetService:CreateEditableImage({
				Size = vector2
			})

			if not v240 then
				mutedError("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")

				return
			end

			local resultSize = result.Size

			v240:DrawImageTransformed(Vector2.zero, Vector2.new(vector2.X / resultSize.X, vector2.Y / resultSize.Y), 0, result, {
				CombineType = Enum.ImageCombineType.Overwrite,
				PivotPoint = Vector2.zero
			})

			local v242 = v240:ReadPixelsBuffer(Vector2.zero, vector2)

			darkenPixelBuffer(v242, 0.5)
			v240:WritePixelsBuffer(Vector2.zero, vector2, v242)

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			cycloramaBack.TextureContent = Content.fromObject(v240)
		end)
	end

	TweenService:Create(p16.cycloramaBack, tweenInfo, {
		Transparency = 0
	}):Play()
	TweenService:Create(p16.cycloramaFront, tweenInfo2, {
		Transparency = 0.015
	}):Play()

	local v95 = p16:currentPageHasBlocks()

	if v95 then
		p16.largerShapesDisappearTween:Play()
		p16.cloudsDisappearTween:Play()
	end

	hideCycloramaSceneElements(p16.newBackgroundScene, v95)
end
function t1.crossfadeToBackground(t7: {[any]: any}, p18, n3: number) -- line: 553
	-- upvalues: AssetService (copy), mutedError (copy), vector2 (copy), darkenPixelBuffer (copy), FFlagAXBackgroundsCycloramaVR (copy), hideCycloramaSceneElements (copy), ContentProvider (copy), TweenService (copy), tweenInfo (copy)
	if not t7.cyclorama then
		return
	end

	local cycloramaState = t7.cycloramaState

	if cycloramaState.crossfadeTweens then
		for _, v101 in cycloramaState.crossfadeTweens do
			v101:Cancel()
		end

		cycloramaState.crossfadeTweens = nil
	end

	local cycloramaState2 = t7.cycloramaState
	local v103 = cycloramaState2.textureBuffers[cycloramaState2.activeTextureIndex]
	local cycloramaState3 = t7.cycloramaState
	local cycloramaBack = t7.cycloramaBack
	local imageId = p18.imageId

	if cycloramaBack:IsA("MeshPart") then
		local activeToken = cycloramaState3.activeToken

		task.spawn(function() -- line: 256
			-- upvalues: AssetService (copy), imageId (copy), mutedError (copy), activeToken (copy), cycloramaState3 (copy), vector2 (copy), darkenPixelBuffer (copy), cycloramaBack (copy)
			local ok, result = pcall(function() -- line: 257
				-- upvalues: AssetService (copy), imageId (copy)
				return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{ imageId }`))
			end)

			if not ok or not result then
				mutedError("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(imageId))

				return
			end

			if activeToken ~= cycloramaState3.activeToken then
				return
			end

			local v245 = AssetService:CreateEditableImage({
				Size = vector2
			})

			if not v245 then
				mutedError("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")

				return
			end

			local resultSize = result.Size

			v245:DrawImageTransformed(Vector2.zero, Vector2.new(vector2.X / resultSize.X, vector2.Y / resultSize.Y), 0, result, {
				CombineType = Enum.ImageCombineType.Overwrite,
				PivotPoint = Vector2.zero
			})

			local v247 = v245:ReadPixelsBuffer(Vector2.zero, vector2)

			darkenPixelBuffer(v247, 0.5)
			v245:WritePixelsBuffer(Vector2.zero, vector2, v247)

			if activeToken ~= cycloramaState3.activeToken then
				return
			end

			cycloramaBack.TextureContent = Content.fromObject(v245)
		end)
	end

	local v108 = cycloramaState3.textureBuffers[3 - cycloramaState3.activeTextureIndex]

	v108.Transparency = 1

	if v108:IsA("MeshPart") then
		v108.TextureContent = Content.fromUri(`rbxassetid://{ p18.imageId }`)
	end

	local v109 = v108

	v103.Transparency = 0.015

	if not FFlagAXBackgroundsCycloramaVR or not t7.isSpatial then
		hideCycloramaSceneElements(t7.newBackgroundScene)
	end

	task.spawn(function() -- line: 575
		-- upvalues: ContentProvider (copy), v109 (copy), mutedError (copy), p18 (copy), n3 (copy), t7 (copy), TweenService (copy), tweenInfo (copy), v103 (copy)
		if not pcall(function() -- line: 578
			-- upvalues: ContentProvider (copy), v109 (copy)
			ContentProvider:PreloadAsync({ v109 })
		end) then
			mutedError("BackgroundSceneManager: cyclorama crossfade preload failed for assetId=" .. tostring(p18.imageId))
		end

		if n3 ~= t7.cycloramaState.activeToken then
			return
		end

		local tween = TweenService:Create(v109, tweenInfo, {
			Transparency = 0.015
		})
		local tween2 = TweenService:Create(v103, tweenInfo, {
			Transparency = 1
		})

		t7.cycloramaState.crossfadeTweens = {
			tween,
			tween2
		}
		tween:Play()
		tween2:Play()
		t7.cycloramaState.activeTextureIndex = 3 - t7.cycloramaState.activeTextureIndex
		t7.cycloramaFront = v109
	end)
end
function t1.hideBackground(p19) -- line: 609
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy), TweenService (copy), tweenInfo (copy), tweenInfo2 (copy), t5 (copy)
	if not p19.cyclorama then
		return
	end

	local cycloramaState = p19.cycloramaState

	if cycloramaState.crossfadeTweens then
		for _, v113 in cycloramaState.crossfadeTweens do
			v113:Cancel()
		end

		cycloramaState.crossfadeTweens = nil
	end

	if FFlagAXBackgroundsCycloramaVR and p19.isSpatial then
		for _, v115 in p19.cycloramaState.textureBuffers do
			TweenService:Create(v115, tweenInfo, {
				Transparency = 1
			}):Play()
		end

		return
	end

	for _, v117 in p19.cycloramaState.textureBuffers do
		TweenService:Create(v117, tweenInfo, {
			Transparency = 1
		}):Play()
	end

	TweenService:Create(p19.cycloramaBack, tweenInfo2, {
		Transparency = 1
	}):Play()

	local v118 = p19:getModelInformationForAppPage(p19:getCurrentPage())

	if v118 then
		TweenService:Create(p19.newBackgroundScene.Baseplate, tweenInfo, {
			Transparency = v118.BaseplateTransparency
		}):Play()

		if p19:currentPageHasBlocks() then
			p19.newBackgroundScene.LargerShapes.Position = t5.Walls.LargerShapesPosition
			p19.newBackgroundScene.Clouds.Position = t5.Walls.CloudsPosition
			p19.largerShapesAppearTween:Play()
			p19.cloudsAppearTween:Play()
		else
			p19.newBackgroundScene.LargerShapes.Position = v118.LargerShapesPosition
			p19.newBackgroundScene.Clouds.Position = v118.CloudsPosition
		end

		p19.newBackgroundScene.BackPanel.TextureWall.Transparency = v118.TextureWallTransparency
		p19.newBackgroundScene.BackPanel.TextureFloor.Transparency = v118.TextureWallTransparency

		return
	end

	TweenService:Create(p19.newBackgroundScene.Baseplate, tweenInfo, {
		Transparency = 0
	}):Play()
	p19.newBackgroundScene.BackPanel.TextureWall.Transparency = 1
	p19.newBackgroundScene.BackPanel.TextureFloor.Transparency = 1
end
function t1.updateActiveBackground(p20, p21) -- line: 664
	-- upvalues: selectActiveBackground (copy), loadBackgroundAsset (copy), mutedError (copy)
	if not p20.cyclorama then
		return
	end

	local v121 = selectActiveBackground(p21)

	if v121 == p20.cycloramaState.currentAssetId then
		return
	end

	local currentAssetId = p20.cycloramaState.currentAssetId
	local cycloramaState = p20.cycloramaState

	cycloramaState.activeToken = cycloramaState.activeToken + 1

	local activeToken = p20.cycloramaState.activeToken

	p20.cycloramaState.currentAssetId = v121

	if v121 == nil then
		p20:hideBackground()

		return
	end

	loadBackgroundAsset.load(v121):andThen(function(p22) -- line: 686
		-- upvalues: activeToken (copy), p20 (copy), currentAssetId (copy)
		if activeToken ~= p20.cycloramaState.activeToken then
			return
		end

		if currentAssetId == nil then
			p20:applyBackground(p22)

			return
		end

		p20:crossfadeToBackground(p22, activeToken)
	end):catch(function(p23) -- line: 698
		-- upvalues: activeToken (copy), p20 (copy), mutedError (copy), v121 (copy)
		if activeToken ~= p20.cycloramaState.activeToken then
			return
		end

		mutedError("BackgroundSceneManager: cyclorama load failed for assetId=" .. tostring(v121) .. ": " .. tostring(p23))
		p20.cycloramaState.currentAssetId = nil
		p20:hideBackground()
	end)
end
function t1.setupTweening(p24) -- line: 711
	-- upvalues: TweenService (copy), t5 (copy)
	local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0)
	local tweenInfo4 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.In, 0, false, 0)
	local tweenInfo5 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
	local t8 = {
		Transparency = 0
	}
	local t9 = {
		Transparency = 1
	}

	p24.wallAppearTween = TweenService:Create(p24.newBackgroundScene.BackPanel.TextureWall, tweenInfo5, t8)
	p24.wallDisappearTween = TweenService:Create(p24.newBackgroundScene.BackPanel.TextureWall, tweenInfo5, t9)
	p24.floorAppearTween = TweenService:Create(p24.newBackgroundScene.BackPanel.TextureFloor, tweenInfo5, t8)
	p24.floorDisappearTween = TweenService:Create(p24.newBackgroundScene.BackPanel.TextureFloor, tweenInfo5, t9)
	p24.largerShapesAppearTween = TweenService:Create(p24.newBackgroundScene.LargerShapes, tweenInfo3, {
		Position = t5.LargerShapes.LargerShapesPosition
	})
	p24.largerShapesDisappearTween = TweenService:Create(p24.newBackgroundScene.LargerShapes, tweenInfo4, {
		Position = t5.Walls.LargerShapesPosition
	})
	p24.cloudsAppearTween = TweenService:Create(p24.newBackgroundScene.Clouds, tweenInfo3, {
		Position = t5.LargerShapes.CloudsPosition
	})
	p24.cloudsDisappearTween = TweenService:Create(p24.newBackgroundScene.Clouds, tweenInfo4, {
		Position = t5.Walls.CloudsPosition
	})
	p24.allTweens = {
		p24.wallAppearTween,
		p24.wallDisappearTween,
		p24.floorAppearTween,
		p24.floorDisappearTween,
		p24.largerShapesAppearTween,
		p24.largerShapesDisappearTween,
		p24.cloudsAppearTween,
		p24.cloudsDisappearTween
	}
end
function t1.updateTheme(p25, p26) -- line: 774
	-- upvalues: t4 (copy), SharedFlags (copy), getSceneOverridesStore (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy), Lighting (copy), ParticleType (copy)
	p25.theme = p26

	local LightTheme = t4.LightTheme

	if p26 == "dark" then
		LightTheme = t4.DarkTheme
	end

	if SharedFlags.FFlagEnableCoreContentTheme then
		p25.sceneOverrides = getSceneOverridesStore().getSceneOverrides()

		if p25.sceneOverrides then
			LightTheme = table.clone(LightTheme)
			LightTheme.BackPanelTextureColor = p25.sceneOverrides.BackPanel
			LightTheme.CloudsTextureColor = p25.sceneOverrides.Clouds
			LightTheme.LargerShapesTextureColor = p25.sceneOverrides.LargerShapes
			LightTheme.BasePlateColor = p25.sceneOverrides.Baseplate
			LightTheme.FogStart = p25.sceneOverrides.FogStart
			LightTheme.FogEnd = p25.sceneOverrides.FogEnd
			LightTheme.FogColor = p25.sceneOverrides.FogColor

			local colorSequence = ColorSequence.new(p25.sceneOverrides.AvatarParticles)

			LightTheme.ParticleEmitterColorAEToCatalog = colorSequence
			LightTheme.ParticleEmitterColorCatalogToAE = colorSequence
		end
	end

	for _, child in p25.newBackgroundScene.BackPanel:GetChildren() do
		child.Color3 = LightTheme.BackPanelTextureColor
	end

	for _, child in p25.newBackgroundScene.Clouds:GetChildren() do
		child.Color3 = LightTheme.CloudsTextureColor
	end

	for _, child in p25.newBackgroundScene.LargerShapes:GetChildren() do
		child.Color3 = LightTheme.LargerShapesTextureColor
	end

	p25.newBackgroundScene.Baseplate.Color = LightTheme.BasePlateColor

	local SkyboxBlocker = p25.newBackgroundScene:FindFirstChild("SkyboxBlocker")

	if SkyboxBlocker then
		if SharedFlags.FFlagEnableCoreContentTheme and p25.sceneOverrides then
			SkyboxBlocker.Transparency = p25.sceneOverrides.SkyboxBlockerTransparency
			SkyboxBlocker.Color = p25.sceneOverrides.SkyboxBlockerColor
		else
			SkyboxBlocker.Transparency = 1
		end
	end

	if FFlagUseUpdatedBackgroundSceneSettingsOnMobile or SharedFlags.FFlagEnableCoreContentTheme then
		if LightTheme.AmbientLightColor ~= nil then
			Lighting.Ambient = LightTheme.AmbientLightColor
		end

		if LightTheme.EnvironmentDiffuseScale ~= nil then
			Lighting.EnvironmentDiffuseScale = LightTheme.EnvironmentDiffuseScale
		end

		if LightTheme.EnvironmentSpecularScale ~= nil then
			Lighting.EnvironmentSpecularScale = LightTheme.EnvironmentSpecularScale
		end

		if LightTheme.FogStart ~= nil then
			Lighting.FogStart = LightTheme.FogStart
		end

		if LightTheme.FogEnd ~= nil then
			Lighting.FogEnd = LightTheme.FogEnd
		end
	else
		p25.newBackgroundScene.CharacterSpotLight.SpotLight.Brightness = LightTheme.CharacterSpotLightBrightness
	end

	Lighting.FogColor = LightTheme.FogColor

	for v142, v143 in p25.particleStorage do
		for _, v145 in v143 do
			v145.Color = if v142 ~= ParticleType.AvatarEditorToCatalog then LightTheme.ParticleEmitterColorCatalogToAE else LightTheme.ParticleEmitterColorAEToCatalog
		end
	end
end
function t1.setLighting(p27, p28) -- line: 856
	-- upvalues: Lighting (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy), SharedFlags (copy), FFlagAXGuardCharacterSpotLightSideAccess (copy)
	Lighting.Brightness = p28.Lighting.Brightness
	Lighting.ColorShift_Bottom = p28.Lighting.ColorShift_Bottom
	Lighting.ColorShift_Top = p28.Lighting.ColorShift_Top
	Lighting.OutdoorAmbient = p28.Lighting.OutdoorAmbient

	if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then
		Lighting.Ambient = p28.Lighting.Ambient
	end

	Lighting.ClockTime = p28.Lighting.ClockTime
	Lighting.GeographicLatitude = p28.Lighting.GeographicLatitude
	Lighting.TimeOfDay = p28.Lighting.TimeOfDay
	Lighting.FogEnd = if not SharedFlags.FFlagEnableCoreContentTheme or not p27.sceneOverrides then p28.Lighting.FogEnd else p27.sceneOverrides.FogEnd

	if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then
		Lighting.FogStart = if not SharedFlags.FFlagEnableCoreContentTheme or not p27.sceneOverrides then p28.Lighting.FogStart else p27.sceneOverrides.FogStart
	end

	if FFlagUseUpdatedBackgroundSceneSettingsOnMobile then
		p27.newBackgroundScene.CharacterSpotLight.SpotLight.Enabled = false

		if FFlagAXGuardCharacterSpotLightSideAccess then
			local CharacterSpotLight_Left = p27.newBackgroundScene:FindFirstChild("CharacterSpotLight_Left")

			if CharacterSpotLight_Left and CharacterSpotLight_Left:FindFirstChild("SpotLight") then
				CharacterSpotLight_Left.SpotLight.Enabled = true
			end

			local CharacterSpotLight_Right = p27.newBackgroundScene:FindFirstChild("CharacterSpotLight_Right")

			if CharacterSpotLight_Right and CharacterSpotLight_Right:FindFirstChild("SpotLight") then
				CharacterSpotLight_Right.SpotLight.Enabled = true
			end
		else
			p27.newBackgroundScene.CharacterSpotLight_Left.SpotLight.Enabled = true
			p27.newBackgroundScene.CharacterSpotLight_Right.SpotLight.Enabled = true
		end
	end

	if p28.Bloom then
		if p27.bloom then
			p27.bloom.Enabled = true
			p27.bloom.Intensity = p28.Bloom.Intensity
			p27.bloom.Size = p28.Bloom.Size
			p27.bloom.Threshold = p28.Bloom.Threshold
		end
	elseif p27.bloom then
		p27.bloom.Enabled = false
	end

	if p28.ColorCorrection then
		if p27.colorCorrection then
			p27.colorCorrection.Enabled = true
			p27.colorCorrection.Brightness = p28.ColorCorrection.Brightness
			p27.colorCorrection.Contrast = p28.ColorCorrection.Contrast
			p27.colorCorrection.Saturation = p28.ColorCorrection.Saturation

			return
		end
	elseif p27.colorCorrection then
		p27.colorCorrection.Enabled = false
	end
end
function t1.startLighting(p29) -- line: 928
	-- upvalues: t2 (copy)
	p29:setLighting(t2)
end
function t1.updateLighting(p30, p31) -- line: 932
	-- upvalues: AvatarScreen (copy), t3 (copy), LightUtility (copy), t2 (copy)
	if p31 == AvatarScreen.ProfilePictureEditorFinal then
		p30:setLighting(t3)

		if not game.Workspace:FindFirstChild("ThumbnailLightAnchor_0") then
			local CurrentCharacter = p30.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

			if CurrentCharacter then
				LightUtility.AddDefaultPointLightRelativeTo(CurrentCharacter.HumanoidRootPart.CFrame)

				return
			end
		end
	else
		p30:setLighting(t2)

		local ThumbnailLightAnchor_0 = game.Workspace:FindFirstChild("ThumbnailLightAnchor_0")

		if ThumbnailLightAnchor_0 then
			ThumbnailLightAnchor_0:Destroy()
		end
	end
end
function t1.playParticleEmitters(p32, p33) -- line: 955
	-- upvalues: PagePlayParticleType (copy), ParticleType (copy)
	if PagePlayParticleType[p33] == ParticleType.CatalogToAvatarEditor then
		task.spawn(function() -- line: 957
			-- upvalues: p32 (copy), ParticleType (copy)
			for _, v253 in p32.particleStorage[ParticleType.CatalogToAvatarEditor] do
				v253.Parent = p32.newBackgroundScene.CatalogToAvatarEditorPFX
				v253.Enabled = true
			end

			wait(1)

			for _, v255 in p32.particleStorage[ParticleType.CatalogToAvatarEditor] do
				v255.Enabled = false
			end
		end)

		return
	end

	if PagePlayParticleType[p33] == ParticleType.AvatarEditorToCatalog then
		task.spawn(function() -- line: 969
			-- upvalues: p32 (copy), ParticleType (copy)
			for _, v257 in p32.particleStorage[ParticleType.AvatarEditorToCatalog] do
				v257.Parent = p32.newBackgroundScene.AvatarEditorToCatalogPFX
				v257.Enabled = true
			end

			wait(1)

			for _, v259 in p32.particleStorage[ParticleType.AvatarEditorToCatalog] do
				v259.Enabled = false
			end
		end)
	end
end
function t1.getCurrentPage(p34) -- line: 983
	return p34.avatarRoute.current.name
end
function t1.currentPageHasBlocks(p35) -- line: 990
	-- upvalues: PageBackgroundType (copy), BackgroundType (copy)
	return PageBackgroundType[p35:getCurrentPage()] == BackgroundType.LargerShapes
end
function t1.animateBackground(p36, p37) -- line: 994
	task.spawn(function() -- line: 995
		-- upvalues: p36 (copy), p37 (copy)
		p36.wallDisappearTween:Play()
		p36.floorDisappearTween:Play()
		p36:playParticleEmitters(p37)
		wait(0.2)
		p36.largerShapesAppearTween:Play()
		wait(0.2)
		p36.cloudsAppearTween:Play()
	end)
end
function t1.transitionWithTweens(p38, p39) -- line: 1006
	-- upvalues: AvatarScreen (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy)
	if p39 == AvatarScreen.AvatarEditor or p39 == AvatarScreen.MySharedAvatars then
		p38:animateBackground(AvatarScreen.AvatarEditor)

		if p39 == AvatarScreen.MySharedAvatars then
			p38:animateBackground(AvatarScreen.MySharedAvatars)
		end
	elseif p39 == AvatarScreen.ProfilePictureEditorEmotes then
		p38:animateBackground(AvatarScreen.ProfilePictureEditorEmotes)
	elseif FFlagUseUpdatedBackgroundSceneSettingsOnMobile and p39 == AvatarScreen.Catalog then
		p38:animateBackground(AvatarScreen.Catalog)
	elseif p39 == AvatarScreen.Catalog or p39 == AvatarScreen.AvatarExperienceLandingPage then
		task.spawn(function() -- line: 1017
			-- upvalues: p39 (copy), AvatarScreen (copy), p38 (copy)
			if p39 ~= AvatarScreen.AvatarExperienceLandingPage then
				p38:playParticleEmitters(AvatarScreen.Catalog)
			end

			p38.largerShapesDisappearTween:Play()
			wait(0.2)
			p38.cloudsDisappearTween:Play()
			wait(0.1)
			p38.wallAppearTween:Play()
			p38.floorAppearTween:Play()
		end)
	end

	local v163 = p38:getModelInformationForAppPage(p39)

	if v163 then
		p38.newBackgroundScene.Baseplate.Transparency = v163.BaseplateTransparency

		return
	end

	p38.newBackgroundScene.Baseplate.Transparency = 0
end
function t1.getModelInformationForAppPage(_, p41) -- line: 1039
	-- upvalues: PageBackgroundType (copy), BackgroundType (copy), t5 (copy)
	if PageBackgroundType[p41] == BackgroundType.LargerShapes then
		return t5.LargerShapes
	end

	if PageBackgroundType[p41] == BackgroundType.NoShapesNoWalls then
		return t5.NoShapesNoWalls
	end

	if PageBackgroundType[p41] == BackgroundType.Walls then
		return t5.Walls
	end

	return nil
end
function t1.transitionInstant(p42, p43) -- line: 1050
	-- upvalues: PagePlayParticleType (copy), ParticleType (copy)
	for _, v169 in p42.allTweens do
		v169:Cancel()
	end

	if PagePlayParticleType[p43] == ParticleType.None then
		for _, v171 in p42.particleStorage do
			for _, v173 in v171 do
				v173.Enabled = false
				v173.Parent = nil
			end
		end
	end

	local v174 = p42:getModelInformationForAppPage(p43)

	if v174 then
		p42.newBackgroundScene.BackPanel.TextureFloor.Transparency = v174.TextureWallTransparency
		p42.newBackgroundScene.BackPanel.TextureWall.Transparency = v174.TextureWallTransparency
		p42.newBackgroundScene.LargerShapes.Position = v174.LargerShapesPosition
		p42.newBackgroundScene.Clouds.Position = v174.CloudsPosition
		p42.newBackgroundScene.Baseplate.Transparency = v174.BaseplateTransparency
	end
end
function t1.update(p44, _, _, p47, p48) -- line: 1084
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy), AvatarScreen (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy), Utils (copy), FFlagAXBackgroundCycloramaRendering (copy), hideCycloramaSceneElements (copy), FFlagAXPhotoboothFunctionality (copy)
	if FFlagAXBackgroundsCycloramaVR and p44.isSpatial then
		return
	end

	local name = p47.current.name
	local name2 = p48.current.name
	local name3 = p48.opaque.name
	local t10 = {
		[AvatarScreen.Catalog] = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile,
		[AvatarScreen.AvatarEditor] = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile,
		[AvatarScreen.MySharedAvatars] = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile,
		[AvatarScreen.ProfilePictureEditorEmotes] = true
	}
	local v184 = false

	if t10[name] then
		if name ~= name2 and t10[name2] then
			v184 = true
		elseif name ~= name3 and t10[name3] then
			v184 = true
		end
	end

	p44.ParticleEffectManager:setAvatarRoute(p47)

	local v185 = name == AvatarScreen.AvatarExperienceLandingPage or name2 == AvatarScreen.AvatarExperienceLandingPage
	local v186 = name == AvatarScreen.AvatarEditor or name2 == AvatarScreen.AvatarEditor
	local v187 = name == AvatarScreen.Catalog or name2 == AvatarScreen.Catalog
	local v188 = Utils.isAvatarBackground(name)
	local v189 = name == AvatarScreen.ProfilePictureEditorEmotes or name2 == AvatarScreen.ProfilePictureEditorEmotes
	local v190 = v185 and (v187 or (v186 or v189))
	local v191 = FFlagAXBackgroundCycloramaRendering and (p44.cyclorama and p44.cycloramaState.currentAssetId ~= nil)

	if name ~= name2 then
		if (v184 or v190) and not v191 then
			p44:transitionWithTweens(name)
		else
			p44:transitionInstant(name)

			if v188 then
				p44:playParticleEmitters(name)
			end
		end

		if v191 then
			hideCycloramaSceneElements(p44.newBackgroundScene)
		end
	end

	if name ~= name2 then
		if FFlagAXPhotoboothFunctionality and p44.currentSceneLighting then
			return
		end

		p44:updateLighting(name)
	end
end
function t1.start(p49) -- line: 1162
	-- upvalues: FFlagAXBackgroundCycloramaRendering (copy), FFlagAXBackgroundsCycloramaVR (copy), SharedFlags (copy), v20 (copy), v21 (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), NotificationService (copy), FFlagAXPhotoboothFunctionality (copy), getSceneOverridesStore (copy), Signals (copy), PhotoboothStoreBridge (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy), GetFIntAvatarEditorParticleEmitterRateOverride (copy), ReplicatedStorage (copy), AvatarScreen (copy), Utils (copy)
	if FFlagAXBackgroundCycloramaRendering and p49.cyclorama then
		p49.cyclorama.Parent = workspace
	end

	if FFlagAXBackgroundsCycloramaVR and p49.isSpatial then
		table.insert(p49.connections, p49.store.changed:connect(function(p50, _) -- line: 1173
			-- upvalues: p49 (copy)
			if p49.cyclorama then
				p49:updateActiveBackground(p50)
			end
		end))

		if p49.cyclorama then
			p49:updateActiveBackground(p49.store:getState())
		end

		return
	end

	p49.colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)

	if SharedFlags.FFlagEnableCoreContentTheme and not p49.newBackgroundScene:FindFirstChild("SkyboxBlocker") then
		local clone = p49.newBackgroundScene.BackPanel:Clone()

		clone.Name = "SkyboxBlocker"
		clone.Material = Enum.Material.SmoothPlastic
		clone.Size = Vector3.new(v20, v21, v22)
		clone.Position = Vector3.new(v23, v24, v25)

		for _, child in clone:GetChildren() do
			child:Destroy()
		end

		clone.Parent = p49.newBackgroundScene
	end

	p49:updateTheme(p49.theme)

	local name = p49.avatarRoute.current.name
	local v197 = string.lower(NotificationService.SelectedTheme)

	if v197 ~= p49.theme then
		p49:updateTheme(v197)
	end

	table.insert(p49.connections, p49.store.changed:connect(function(p52, p53) -- line: 1213
		-- upvalues: p49 (copy), FFlagAXBackgroundCycloramaRendering (copy)
		local avatarRoute = p49.avatarRoute

		p49:update(p52, p53, avatarRoute, avatarRoute)

		if FFlagAXBackgroundCycloramaRendering and p49.cyclorama then
			p49:updateActiveBackground(p52)
		end
	end))

	if FFlagAXBackgroundCycloramaRendering and p49.cyclorama then
		p49:updateActiveBackground(p49.store:getState())
	end

	table.insert(p49.connections, NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 1228
		-- upvalues: FFlagAXPhotoboothFunctionality (copy), p49 (copy), NotificationService (copy)
		if FFlagAXPhotoboothFunctionality and (p49.currentScene and p49.currentSceneLighting) then
			return
		end

		p49:updateTheme(string.lower(NotificationService.SelectedTheme))
	end))

	if SharedFlags.FFlagEnableCoreContentTheme then
		table.insert(p49.connections, {
			disconnect = getSceneOverridesStore().subscribe(function(_) -- line: 1242
				-- upvalues: p49 (copy)
				p49:updateTheme(p49.theme)
			end)
		})
	end

	if FFlagAXPhotoboothFunctionality then
		table.insert(p49.connections, Signals.createEffect(function(p55) -- line: 1252
			-- upvalues: PhotoboothStoreBridge (copy), p49 (copy)
			local v267 = PhotoboothStoreBridge.getStore()

			if not v267 then
				return
			end

			local v268 = v267.getSelectedSceneId(p55)

			p49.changeSceneTask = task.spawn(function() -- line: 1260
				-- upvalues: p49 (copy), v268 (copy)
				p49:pickScene(v268)
			end)
		end))
	end

	local n4 = 20

	p49.newBackgroundScene.BlobShadow.Decal.Transparency = 0.4

	if FFlagUseUpdatedBackgroundSceneSettingsOnMobile then
		local BlobShadowSize = p49.newBackgroundScene.BlobShadow.Size
		local v200 = math.sqrt(BlobShadowSize.X * BlobShadowSize.Z * 0.7)

		p49.newBackgroundScene.BlobShadow.Size = Vector3.new(v200, BlobShadowSize.Y, v200)
		p49.newBackgroundScene.BlobShadow.Position = Vector3.new(0, -0.10000000149011612, 0)
	end

	local num = tonumber(GetFIntAvatarEditorParticleEmitterRateOverride())

	if num > 0 then
		n4 = num
	end

	for _, v203 in p49.particleStorage do
		for _, v205 in v203 do
			v205.Rate = n4
		end
	end

	p49:startLighting()

	if FFlagAXPhotoboothFunctionality then
		if not ReplicatedStorage:FindFirstChild("PhotoboothScenes") then
			p49.scenesFolder = Instance.new("Folder")
			p49.scenesFolder.Parent = ReplicatedStorage
			p49.scenesFolder.Name = "PhotoboothScenes"
		end

		p49:pickScene()
	else
		p49.newBackgroundScene.Parent = game.Workspace
	end

	if name == AvatarScreen.AvatarEditor or name == AvatarScreen.AvatarExperienceLandingPage or name == AvatarScreen.Catalog or Utils.isAvatarBackground(name) or name == AvatarScreen.ProfilePictureEditorEmotes then
		p49:transitionInstant(name)
	end

	p49.ParticleEffectManager:start()

	if Utils.isAvatarBackground(name) then
		p49:playParticleEmitters(name)
	end
end

if FFlagAXPhotoboothFunctionality then
	function t1.updateSceneLighting(p56, p57) -- line: 1320
		-- upvalues: Lighting (copy)
		if not p57 then
			p56.currentSceneLighting = nil
			p56:startLighting()
			p56:updateTheme(p56.theme)

			return
		end

		p56.currentSceneLighting = p57

		for _, v209 in {
			"Brightness",
			"Ambient",
			"ColorShift_Top",
			"ColorShift_Bottom",
			"OutdoorAmbient",
			"ShadowSoftness",
			"ClockTime",
			"FogStart",
			"FogEnd",
			"FogColor"
		} do
			if p57[v209] ~= nil then
				Lighting[v209] = p57[v209]
			end
		end
	end
	function t1.pickScene(t11: {[any]: any}, s1: string) -- line: 1354
		-- upvalues: PhotoboothStoreBridge (copy), PhotoboothSceneData (copy), ReplicatedStorage (copy), InsertService (copy)
		if t11.changeSceneTask then
			task.cancel(t11.changeSceneTask)
		end

		if not s1 then
			local v212 = PhotoboothStoreBridge.getStore()

			s1 = not v212 and "" or v212.getSelectedSceneId(false)
		end

		local v213 = PhotoboothSceneData.PHOTOBOOTH_SCENES[s1]

		if not v213 then
			warn("BackgroundSceneManager: Unknown scene ID:", s1)

			return
		end

		if t11.currentScene then
			t11.currentScene.Parent = t11.scenesFolder
			t11.currentScene = nil
		end

		if s1 == "" then
			t11.newBackgroundScene.Parent = game.Workspace
			t11.currentScene = nil
			t11:updateSceneLighting(nil)
			t11:updateTheme(t11.theme)
		else
			t11.newBackgroundScene.Parent = ReplicatedStorage

			if v213.asset then
				local id

				if t11.scenesFolder:FindFirstChild(v213.id) then
					id = t11.scenesFolder:FindFirstChild(v213.id)
				else
					id = InsertService:LoadLocalAsset(v213.asset)
					id.Name = v213.id
					id.Parent = t11.scenesFolder

					if v213.position then
						id:SetPrimaryPartCFrame(CFrame.new(v213.position))
					end

					if v213.rotation then
						id:SetPrimaryPartCFrame(id:GetPrimaryPartCFrame() * v213.rotation)
					end
				end

				t11.currentScene = id
				t11.currentScene.Parent = game.Workspace

				if v213.lighting then
					t11:updateSceneLighting(v213.lighting)
				else
					t11:updateSceneLighting(nil)
					t11:updateTheme(t11.theme)
				end
			end
		end

		t11.changeSceneTask = nil
	end
end

function t1.stop(p58) -- line: 1430
	-- upvalues: FFlagAXPhotoboothFunctionality (copy), FFlagAXBackgroundCycloramaRendering (copy), ReplicatedStorage (copy), FFlagAXBackgroundsCycloramaVR (copy), ParticleType (copy)
	for _, v217 in p58.connections do
		if FFlagAXPhotoboothFunctionality and typeof(v217) == "function" then
			v217()
		else
			v217:disconnect()
		end
	end

	if FFlagAXPhotoboothFunctionality and p58.currentScene then
		p58.currentScene.Parent = p58.scenesFolder
	end

	if FFlagAXBackgroundCycloramaRendering and p58.cyclorama then
		p58.cycloramaFront.Transparency = 1
		p58.cycloramaBack.Transparency = 1
		p58.cyclorama.Parent = ReplicatedStorage

		local cycloramaState = p58.cycloramaState

		cycloramaState.activeToken = cycloramaState.activeToken + 1
		p58.cycloramaState.currentAssetId = nil
	end

	p58.connections = {}

	if FFlagAXBackgroundsCycloramaVR and p58.isSpatial then
		return
	end

	p58.newBackgroundScene.Parent = ReplicatedStorage
	p58.ParticleEffectManager:stop()

	for v219, v220 in p58.particleStorage do
		for _, v222 in v220 do
			v222.Parent = if v219 ~= ParticleType.AvatarEditorToCatalog then p58.newBackgroundScene.CatalogToAvatarEditorPFX else p58.newBackgroundScene.AvatarEditorToCatalogPFX
		end
	end
end
function t1.onDestroy(p59) -- line: 1471
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy)
	if FFlagAXBackgroundsCycloramaVR and p59.isSpatial then
		return
	end

	p59.ParticleEffectManager:onDestroy()
end
function t1.updateAvatarRoute(p60, p61, p62) -- line: 1479
	p60.avatarRoute = p61

	local v227 = p60.store:getState()

	p60:update(v227, v227, p61, p62)
end

return t1
