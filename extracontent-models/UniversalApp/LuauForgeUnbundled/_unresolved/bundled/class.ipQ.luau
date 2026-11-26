local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local NotificationService = game:GetService("NotificationService")
local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local AssetService = game:GetService("AssetService")
local ContentProvider = game:GetService("ContentProvider")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local lightUtility = Thumbnailing.LightUtility

local module = require("@luauforge/bundled/ipR")
local module2 = require("@luauforge/bundled/ipS")
local module3 = require("@luauforge/bundled/fCe")

local module4 = require("@luauforge/bundled/ipT")

local module5 = require("@luauforge/bundled/dPO")

local module6 = require("@luauforge/bundled/ipU")
local defineFastFlag = game:DefineFastFlag("AXGuardParticleEmitterFolderAccess", false)
local fFlagQRCodePageVisualRefresh = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRCodePageVisualRefresh

local getSceneOverridesStore = require("@game/CorePackages/Workspace/Packages/Style").getSceneOverridesStore

local defineFastInt = game:DefineFastInt("AXSkyboxBlockerSizeX", 31)
local defineFastInt2 = game:DefineFastInt("AXSkyboxBlockerSizeY", 175)
local defineFastInt3 = game:DefineFastInt("AXSkyboxBlockerSizeZ", 400)
local defineFastInt4 = game:DefineFastInt("AXSkyboxBlockerPositionX", -50)
local defineFastInt5 = game:DefineFastInt("AXSkyboxBlockerPositionY", 77)
local defineFastInt6 = game:DefineFastInt("AXSkyboxBlockerPositionZ", -9)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local fFlagAXBackgroundCycloramaRendering = AvatarExperienceFlags.FFlagAXBackgroundCycloramaRendering
local fFlagAXBackgroundDisableFogWhileActive = AvatarExperienceFlags.FFlagAXBackgroundDisableFogWhileActive
local fFlagAXSkyboxFromBackgroundAsset = AvatarExperienceFlags.FFlagAXSkyboxFromBackgroundAsset
local fFlagAXFixCycloramaOrphanRemount = AvatarExperienceFlags.FFlagAXFixCycloramaOrphanRemount
local fFlagAXCycloramaAssetFallback = AvatarExperienceFlags.FFlagAXCycloramaAssetFallback
local fStringAXCycloramaFallbackAssetId = AvatarExperienceFlags.FStringAXCycloramaFallbackAssetId
local fFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXBringingItBack = AvatarExperienceFlags.FFlagAXBringingItBack

local v5 = if fFlagAXSkyboxFromBackgroundAsset then require("@luauforge/bundled/ipV") else nil

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local loadBackgroundAsset = AvatarExperienceCommon.Backgrounds.loadBackgroundAsset
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectActiveBackgroundPreview = AvatarExperienceCommon.Backgrounds.selectActiveBackgroundPreview
local previewImageRegistry = AvatarExperienceCommon.Backgrounds.previewImageRegistry

local module9 = require("@luauforge/bundled/dFs")

local module10 = require("@luauforge/bundled/dPN")
local backgroundType = module10.BackgroundType
local particleType = module10.ParticleType
local pagePlayParticleType = module10.PagePlayParticleType
local pageBackgroundType = module10.PageBackgroundType

local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0.4)

local fIntAXBackgroundFogDisabledDistance = AvatarExperienceFlags.FIntAXBackgroundFogDisabledDistance

local vector2 = Vector2.new(3, 3)

local v6 = CFrame.new(0, 0, -6) * CFrame.Angles(0, 3.141592653589793, 0)

local class = {}
class.__index = class

local v7 = { Lighting = 0, Bloom = 0, ColorCorrection = 0 }
local v8

if module5 then
	v8 = {
		Brightness = 2,
		ColorShift_Bottom = Color3.fromRGB(108, 94, 66),
		ColorShift_Top = Color3.fromRGB(94, 100, 172),
		ClockTime = 11,
		FogEnd = 92,
		GeographicLatitude = 24,
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		TimeOfDay = "11:00:00"
	}
else
	v8 = {
		Brightness = 2,
		ColorShift_Bottom = Color3.fromRGB(232, 255, 146),
		ColorShift_Top = Color3.fromRGB(85, 136, 167),
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		Ambient = Color3.fromRGB(170, 170, 170),
		ClockTime = 12,
		GeographicLatitude = 41.733,
		TimeOfDay = "12:00:00",
		FogColor = Color3.fromRGB(45, 46, 49),
		FogEnd = 92,
		FogStart = 20,
		Sky = { CelestialBodiesShown = true, StarCount = 3000 }
	}
end

v7.Lighting = v8

v7.Bloom = module5 and { Intensity = 0.2, Size = 12, Threshold = 0.95 }
	or { Intensity = 0.3, Size = 12, Threshold = 0.95 }

v7.ColorCorrection = { Brightness = 0, Contrast = 0, Saturation = 0 }

local v9 = {
	Lighting = {
		Brightness = 1,
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(127, 127, 127),
		Ambient = Color3.fromRGB(127, 127, 127),
		ClockTime = 14,
		GeographicLatitude = 41.733,
		TimeOfDay = "14:00:00",
		FogColor = Color3.fromRGB(192, 192, 192),
		FogEnd = 100000,
		FogStart = 0,
		Sky = { CelestialBodiesShown = true, StarCount = 3000 }
	}
}

local v10 = { LightTheme = 0, DarkTheme = 0 }

local v12 = if module5 then Color3.fromRGB(130, 130, 130) else nil
v10.LightTheme = {
	AmbientLightColor = v12,
	EnvironmentDiffuseScale = module5 and 0.2 or nil,
	EnvironmentSpecularScale = module5 and 1 or nil,
	FogStart = module5 and 30 or nil,
	BackPanelTextureColor = Color3.fromRGB(213, 213, 213),
	CloudsTextureColor = Color3.fromRGB(222, 222, 222),
	LargerShapesTextureColor = Color3.fromRGB(222, 222, 222),
	BasePlateColor = Color3.fromRGB(213, 213, 213),
	CharacterSpotLightBrightness = 6,
	FogColor = Color3.fromRGB(213, 213, 213),
	ParticleEmitterColorCatalogToAE = ColorSequence.new(
		Color3.fromRGB(171, 169, 161),
		Color3.fromRGB(158, 135, 120)
	),
	ParticleEmitterColorAEToCatalog = ColorSequence.new(
		Color3.fromRGB(158, 135, 120),
		Color3.fromRGB(171, 169, 161)
	)
}

local v14 = if module5 then Color3.fromRGB(180, 180, 180) else nil
v10.DarkTheme = {
	AmbientLightColor = v14,
	EnvironmentDiffuseScale = module5 and 1 or nil,
	EnvironmentSpecularScale = module5 and 1 or nil,
	FogStart = module5 and 20 or nil,
	BackPanelTextureColor = Color3.fromRGB(83, 80, 82),
	CloudsTextureColor = Color3.fromRGB(100, 101, 108),
	LargerShapesTextureColor = Color3.fromRGB(100, 101, 108),
	BasePlateColor = Color3.fromRGB(83, 80, 82),
	CharacterSpotLightBrightness = 12,
	FogColor = Color3.fromRGB(55, 56, 59),
	ParticleEmitterColorCatalogToAE = ColorSequence.new(
		Color3.fromRGB(79, 75, 79),
		Color3.fromRGB(51, 49, 52)
	),
	ParticleEmitterColorAEToCatalog = ColorSequence.new(
		Color3.fromRGB(51, 49, 52),
		Color3.fromRGB(79, 75, 79)
	)
}

local v15 = {
	LargerShapes = {
		TextureWallTransparency = 1,
		LargerShapesPosition = Vector3.new(-62.898, 6.97, -8.815),
		CloudsPosition = Vector3.new(-90, 20, 0),
		BaseplateTransparency = 0
	},
	Walls = {
		TextureWallTransparency = 0,
		LargerShapesPosition = Vector3.new(-62.898, -12.3, -8.815),
		CloudsPosition = Vector3.new(-90, 80, 0),
		BaseplateTransparency = 0
	},
	NoShapesNoWalls = {
		TextureWallTransparency = 1,
		LargerShapesPosition = Vector3.new(-62.898, -1000, -8.815),
		CloudsPosition = Vector3.new(-90, 1000, 0),
		BaseplateTransparency = 1
	}
}

local function darkenPixelBuffer(buf, p2)
	for i = 0, buffer.len(buf) - 4, 4 do
		for j = 0, 2 do
			local v16 = math.clamp(math.round(buffer.readu8(buf, i + j) * p2), 0, 255)
			buffer.writeu8(buf, i + j, v16)
		end
	end
end

class.darkenPixelBuffer = darkenPixelBuffer

local function setSkyboxOverrideFromBackgroundAsset(p2)
	if v5 then
		v5.setSkyboxOverride(`rbxassetid://{p2}`)
	end
end

local function applyDownsampledColorTexture(part, p2, p3)
	if not part:IsA("MeshPart") then
		return
	end

	local activeToken = p2.activeToken

	task.spawn(function()
		local success, result = pcall(function()
			return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{p3}`))
		end)

		if not (success and result) then
			module9("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(p3))

			return
		end

		if activeToken ~= p2.activeToken then
			return
		end

		local editableImage = AssetService:CreateEditableImage({ Size = vector2 })

		if not editableImage then
			module9("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")
			return
		end

		local size = result.Size

		editableImage:DrawImageTransformed(
			Vector2.zero,
			Vector2.new(vector2.X / size.X, vector2.Y / size.Y),
			0,
			result,
			{ CombineType = Enum.ImageCombineType.Overwrite, PivotPoint = Vector2.zero }
		)

		local pixelsBuffer = editableImage:ReadPixelsBuffer(Vector2.zero, vector2)
		darkenPixelBuffer(pixelsBuffer, 0.5)
		editableImage:WritePixelsBuffer(Vector2.zero, vector2, pixelsBuffer)

		if activeToken ~= p2.activeToken then
			return
		end

		part.TextureContent = Content.fromObject(editableImage)
	end)
end

local function getActiveTextureBuffer(p2)
	return p2.textureBuffers[p2.activeTextureIndex]
end

local function getIdleTextureBuffer(p2)
	return p2.textureBuffers[3 - p2.activeTextureIndex]
end

local function cancelCrossfadeTweens(p2)
	if p2.crossfadeTweens then
		for k, crossfadeTween in p2.crossfadeTweens do
			crossfadeTween:Cancel()
		end

		p2.crossfadeTweens = nil
	end
end

local function stageCrossfade(cycloramaState, part, p2)
	local imageId = p2.imageId

	if part:IsA("MeshPart") then
		local activeToken = cycloramaState.activeToken

		task.spawn(function()
			local success, result = pcall(function()
				return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{imageId}`))
			end)

			if not (success and result) then
				module9("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(imageId))

				return
			end

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			local editableImage = AssetService:CreateEditableImage({ Size = vector2 })

			if not editableImage then
				module9("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")
				return
			end

			local size = result.Size

			editableImage:DrawImageTransformed(
				Vector2.zero,
				Vector2.new(vector2.X / size.X, vector2.Y / size.Y),
				0,
				result,
				{
					CombineType = Enum.ImageCombineType.Overwrite,
					PivotPoint = Vector2.zero
				}
			)

			local pixelsBuffer = editableImage:ReadPixelsBuffer(Vector2.zero, vector2)
			darkenPixelBuffer(pixelsBuffer, 0.5)
			editableImage:WritePixelsBuffer(Vector2.zero, vector2, pixelsBuffer)

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			part.TextureContent = Content.fromObject(editableImage)
		end)
	end

	if fFlagAXSkyboxFromBackgroundAsset then
		local imageId2 = p2.imageId

		if v5 then
			v5.setSkyboxOverride(`rbxassetid://{imageId2}`)
		end
	end

	local part2 = cycloramaState.textureBuffers[3 - cycloramaState.activeTextureIndex]

	part2.Transparency = 1

	if part2:IsA("MeshPart") then
		part2.TextureContent = Content.fromUri(`rbxassetid://{p2.imageId}`)
	end

	return part2
end

class.stageCrossfade = stageCrossfade

local function hideCycloramaSceneElements(newBackgroundScene, p2)
	TweenService:Create(newBackgroundScene.Baseplate, tweenInfo, { Transparency = 1 }):Play()

	if not p2 then
		newBackgroundScene.LargerShapes.Position = v15.NoShapesNoWalls.LargerShapesPosition
		newBackgroundScene.Clouds.Position = v15.NoShapesNoWalls.CloudsPosition
	end

	newBackgroundScene.BackPanel.TextureWall.Transparency = 1
	newBackgroundScene.BackPanel.TextureFloor.Transparency = 1
end

function class.new(store, networking, avatarRoute, p2, p3)
	local class2 = {}
	setmetatable(class2, class)
	class2.connections = {}

	class2.store = store
	class2.networking = networking
	class2.avatarRoute = avatarRoute
	class2.isSpatial = p2 or false

	local v16 = if fFlagAXBringingItBack then class2.isSpatial else nil
	class2.liveIsSpatial = v16
	local v17 = if fFlagAXBringingItBack then p3 or false else nil
	class2.isClassicTheme = v17

	if fFlagAXBackgroundsCycloramaVR and class2.isSpatial then
		class2:initCyclorama()
		return class2
	end

	class2.ParticleEffectManager = module.new(store, avatarRoute)
	local v18 = if fFlagAXBringingItBack then module2.resolve() else nil
	class2.classicAvatarScene = v18

	class2.colorCorrection = Lighting:FindFirstChild("ColorCorrection")

	if not class2.colorCorrection then
		class2.colorCorrection = Instance.new("ColorCorrectionEffect")
		class2.colorCorrection.Parent = Lighting
	end

	class2.bloom = Lighting:FindFirstChild("Bloom")

	if not class2.bloom then
		class2.bloom = Instance.new("BloomEffect")
		class2.bloom.Parent = Lighting
	end

	class2.newBackgroundScene = ReplicatedStorage:WaitForChild("AvatarSceneNew")

	class2.particleStorage = {
		[particleType.CatalogToAvatarEditor] = {
			largeParticleEmitter = class2.newBackgroundScene.CatalogToAvatarEditorPFX.BIGBOIS,
			smallParticleEmitter = class2.newBackgroundScene.CatalogToAvatarEditorPFX.SmolBois
		},
		[particleType.AvatarEditorToCatalog] = {
			largeParticleEmitter = class2.newBackgroundScene.AvatarEditorToCatalogPFX.BIGBOIS,
			smallParticleEmitter = class2.newBackgroundScene.AvatarEditorToCatalogPFX.SmolBois
		}
	}

	class2.newBackgroundScene.BackPanel.Transparency = v15.LargerShapes.TextureWallTransparency

	class2:setupTweening()

	local selectedTheme = NotificationService.SelectedTheme or nil
	class2:updateTheme(string.lower(selectedTheme))

	if fFlagAXBackgroundCycloramaRendering then
		class2:initCyclorama()
	end

	return class2
end

function class:syncClassicAvatarScene(p2)
	if not self.classicAvatarScene then
		return
	end

	module2.sync(
		self.classicAvatarScene,
		self.newBackgroundScene,
		ReplicatedStorage,
		p2,
		true,
		self.isClassicTheme,
		self.liveIsSpatial
	)
end

function class:setClassicAvatarSceneContext(liveIsSpatial, isClassicTheme)
	self.liveIsSpatial = liveIsSpatial
	self.isClassicTheme = isClassicTheme
end

function class._loadCycloramaAsset()
	local v16 = tonumber(fStringAXCycloramaFallbackAssetId)
	assert(v16 ~= nil, "FStringAXCycloramaFallbackAssetId must be a numeric asset id")
	return InsertService:LoadAsset(v16)
end

function class.loadCycloramaFallbackModel()
	local v16 = fStringAXCycloramaFallbackAssetId
	local success, result = pcall(class._loadCycloramaAsset)

	if not success then
		module9(string.format(
			"BackgroundSceneManager: AvatarCyclorama fallback asset failed to load assetId=%s error=%s",
			tostring(v16),
			(tostring(result))
		))

		return nil
	end

	if typeof(result) ~= "Instance" then
		module9(string.format(
			"BackgroundSceneManager: AvatarCyclorama fallback asset failed to load assetId=%s gotType=%s",
			tostring(v16),
			(typeof(result))
		))

		return nil
	end

	local avatarCyclorama = result:FindFirstChildWhichIsA("Model")

	if avatarCyclorama then
		avatarCyclorama.Name = "AvatarCyclorama"
		avatarCyclorama.Parent = ReplicatedStorage
		result:Destroy()
		return avatarCyclorama
	else
		local v17 = {}

		for i, child in result:GetChildren() do
			table.insert(v17, string.format("%s(%s)", child.Name, child.ClassName))
		end

		result:Destroy()
		module9(string.format(
			"BackgroundSceneManager: AvatarCyclorama fallback asset missing model assetId=%s children=[%s]",
			tostring(v16),
			table.concat(v17, ",")
		))

		return nil
	end
end

function class:initCyclorama()
	local v16 = ReplicatedStorage:FindFirstChild("AvatarCyclorama")

	if fFlagAXFixCycloramaOrphanRemount then
		v16 = v16 or Workspace:FindFirstChild("AvatarCyclorama")
	end

	if fFlagAXCycloramaAssetFallback and not v16 then
		v16 = class.loadCycloramaFallbackModel()
	end

	if v16 then
		local texture_mesh = v16:FindFirstChild("texture_mesh")
		local color_mesh = v16:FindFirstChild("color_mesh")

		if not (texture_mesh and color_mesh) then
			module9(string.format(
				"BackgroundSceneManager: AvatarCyclorama missing texture_mesh=%s color_mesh=%s",
				tostring(texture_mesh ~= nil),
				(tostring(color_mesh ~= nil))
			))

			return
		end

		local texture_mesh_buffer = texture_mesh:Clone()
		texture_mesh_buffer.Name = "texture_mesh_buffer"
		texture_mesh_buffer.Parent = v16

		self.cyclorama = v16
		self.cycloramaFront = texture_mesh
		self.cycloramaBack = color_mesh
		self.cycloramaState = {
			activeToken = 0,
			currentAssetId = nil,
			currentPreviewKey = nil,
			textureBuffers = { texture_mesh, texture_mesh_buffer },
			activeTextureIndex = 1
		}

		texture_mesh.Anchored = true
		color_mesh.Anchored = true
		texture_mesh_buffer.Anchored = true
		texture_mesh.Transparency = 1
		color_mesh.Transparency = 1
		texture_mesh_buffer.Transparency = 1

		if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
			v16:PivotTo(v6)
		else
			v16:PivotTo(CFrame.new(0, 0.01, 0) * CFrame.Angles(0, -1.5707963267948966, 0))
		end

		if fFlagAXFixCycloramaOrphanRemount then
			if v16.Parent ~= ReplicatedStorage then
				v16.Parent = ReplicatedStorage
			end
		else
			v16.Parent = workspace
		end
	elseif fFlagAXFixCycloramaOrphanRemount then
		module9("BackgroundSceneManager: AvatarCyclorama missing from ReplicatedStorage/Workspace")
	else
		module9("BackgroundSceneManager: AvatarCyclorama missing from ReplicatedStorage")
	end
end

local function cancelFogTweens(p2)
	if p2.cycloramaFogTweens then
		for k, cycloramaFogTween in p2.cycloramaFogTweens do
			cycloramaFogTween:Cancel()
		end

		p2.cycloramaFogTweens = nil
	end
end

function class:disableFogForBackground(data)
	if self.cycloramaSavedFog == nil then
		self.cycloramaSavedFog = {
			FogStart = Lighting.FogStart,
			FogEnd = Lighting.FogEnd,
			FogColor = Lighting.FogColor
		}
	elseif data then
		local cycloramaSavedFog = self.cycloramaSavedFog
		self.cycloramaSavedFog = {
			FogStart = data.FogStart or cycloramaSavedFog.FogStart,
			FogEnd = data.FogEnd or cycloramaSavedFog.FogEnd,
			FogColor = data.FogColor or cycloramaSavedFog.FogColor
		}
	end

	if self.cycloramaFogTweens then
		for k, cycloramaFogTween in self.cycloramaFogTweens do
			cycloramaFogTween:Cancel()
		end

		self.cycloramaFogTweens = nil
	end

	local v16 = {
		FogStart = fIntAXBackgroundFogDisabledDistance,
		FogEnd = fIntAXBackgroundFogDisabledDistance
	}

	if data then
		Lighting.FogStart = v16.FogStart
		Lighting.FogEnd = v16.FogEnd
	else
		local tween = TweenService:Create(Lighting, tweenInfo, v16)
		self.cycloramaFogTweens = { tween }
		tween:Play()
	end
end

function class:restoreFogAfterBackground(p2)
	local cycloramaSavedFog = self.cycloramaSavedFog

	if cycloramaSavedFog then
		if self.cycloramaFogTweens then
			for k, cycloramaFogTween in self.cycloramaFogTweens do
				cycloramaFogTween:Cancel()
			end

			self.cycloramaFogTweens = nil
		end

		local v16 = {
			FogStart = cycloramaSavedFog.FogStart,
			FogEnd = cycloramaSavedFog.FogEnd,
			FogColor = cycloramaSavedFog.FogColor
		}

		if p2 then
			Lighting.FogStart = v16.FogStart
			Lighting.FogEnd = v16.FogEnd
			Lighting.FogColor = v16.FogColor
			self.cycloramaSavedFog = nil
		else
			local tween = TweenService:Create(Lighting, tweenInfo, v16)
			self.cycloramaFogTweens = { tween }
			tween.Completed:Connect(function(p3)
				if
					p3 == Enum.PlaybackState.Completed
					and self.cycloramaFogTweens
					and self.cycloramaFogTweens[1] == tween
				then
					self.cycloramaSavedFog = nil
					self.cycloramaFogTweens = nil
				end
			end)
			tween:Play()
		end
	elseif self.cycloramaFogTweens then
		for k, cycloramaFogTween in self.cycloramaFogTweens do
			cycloramaFogTween:Cancel()
		end

		self.cycloramaFogTweens = nil
	end
end

function class:reconcileFogForLighting(p2)
	local cycloramaState = self.cycloramaState

	if
		cycloramaState
		and (cycloramaState.currentAssetId ~= nil or fFlagAXBackgroundGeneration and cycloramaState.currentPreviewKey ~= nil)
	then
		class.disableFogForBackground(self, p2)
	elseif self.cycloramaSavedFog ~= nil then
		if self.cycloramaFogTweens then
			for k, cycloramaFogTween in self.cycloramaFogTweens do
				cycloramaFogTween:Cancel()
			end

			self.cycloramaFogTweens = nil
		end

		self.cycloramaSavedFog = nil
	end
end

function class:applyBackground(p2)
	if not self.cyclorama then
		return
	end

	if fFlagAXBackgroundDisableFogWhileActive then
		class.disableFogForBackground(self)
	end

	if self.cycloramaFront:IsA("MeshPart") then
		self.cycloramaFront.TextureContent = Content.fromUri(`rbxassetid://{p2.imageId}`)
	end

	if fFlagAXSkyboxFromBackgroundAsset then
		local imageId = p2.imageId

		if v5 then
			v5.setSkyboxOverride(`rbxassetid://{imageId}`)
		end
	end

	if fFlagAXBackgroundGeneration then
		class.destroyActivePreviewImage(self)
	end

	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		TweenService:Create(self.cycloramaFront, tweenInfo, { Transparency = 0.015 }):Play()
		return
	end

	self.cycloramaBack.Color = p2.backgroundColor
	local cycloramaBack = self.cycloramaBack
	local cycloramaState = self.cycloramaState
	local imageId = p2.imageId

	if cycloramaBack:IsA("MeshPart") then
		local activeToken = cycloramaState.activeToken

		task.spawn(function()
			local success, result = pcall(function()
				return AssetService:CreateEditableImageAsync(Content.fromUri(`rbxassetid://{imageId}`))
			end)

			if not (success and result) then
				module9("BackgroundSceneManager: cyclorama downsample failed to load texture for imageId=" .. tostring(imageId))

				return
			end

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			local editableImage = AssetService:CreateEditableImage({ Size = vector2 })

			if not editableImage then
				module9("BackgroundSceneManager: cyclorama downsample exceeded the EditableImage budget")
				return
			end

			local size = result.Size

			editableImage:DrawImageTransformed(
				Vector2.zero,
				Vector2.new(vector2.X / size.X, vector2.Y / size.Y),
				0,
				result,
				{
					CombineType = Enum.ImageCombineType.Overwrite,
					PivotPoint = Vector2.zero
				}
			)

			local pixelsBuffer = editableImage:ReadPixelsBuffer(Vector2.zero, vector2)
			darkenPixelBuffer(pixelsBuffer, 0.5)
			editableImage:WritePixelsBuffer(Vector2.zero, vector2, pixelsBuffer)

			if activeToken ~= cycloramaState.activeToken then
				return
			end

			cycloramaBack.TextureContent = Content.fromObject(editableImage)
		end)
	end

	TweenService:Create(self.cycloramaBack, tweenInfo, { Transparency = 0 }):Play()
	TweenService:Create(self.cycloramaFront, tweenInfo2, { Transparency = 0.015 }):Play()

	local currentPageHasBlocks = self:currentPageHasBlocks()

	if currentPageHasBlocks then
		self.largerShapesDisappearTween:Play()
		self.cloudsDisappearTween:Play()
	end

	hideCycloramaSceneElements(self.newBackgroundScene, currentPageHasBlocks)
end

function class.destroyActivePreviewImage(p2)
	local currentPreviewKey = p2.cycloramaState.currentPreviewKey

	if currentPreviewKey ~= nil then
		p2.cycloramaState.currentPreviewKey = nil
		previewImageRegistry.destroy(currentPreviewKey)
	end
end

function class:applyPreviewBackground(p2, currentPreviewKey)
	if not self.cyclorama then
		return
	end

	local cycloramaState = self.cycloramaState

	if cycloramaState.crossfadeTweens then
		for k, crossfadeTween in cycloramaState.crossfadeTweens do
			crossfadeTween:Cancel()
		end

		cycloramaState.crossfadeTweens = nil
	end

	if fFlagAXBackgroundDisableFogWhileActive then
		class.disableFogForBackground(self)
	end

	local currentPreviewKey2 = self.cycloramaState.currentPreviewKey

	if self.cycloramaFront:IsA("MeshPart") then
		self.cycloramaFront.TextureContent = Content.fromObject(p2)
	end

	for k, instance in self.cycloramaState.textureBuffers do
		TweenService:Create(instance, tweenInfo, {
			Transparency = instance == self.cycloramaFront and 0.015 or 1
		}):Play()
	end

	self.cycloramaState.currentPreviewKey = currentPreviewKey

	if not (fFlagAXBackgroundsCycloramaVR and self.isSpatial) then
		TweenService:Create(self.cycloramaBack, tweenInfo, { Transparency = 1 }):Play()
		hideCycloramaSceneElements(self.newBackgroundScene)
	end

	if currentPreviewKey2 and currentPreviewKey2 ~= currentPreviewKey then
		previewImageRegistry.destroy(currentPreviewKey2)
	end
end

function class:crossfadeToBackground(p2, p3)
	if not self.cyclorama then
		return
	end

	local cycloramaState = self.cycloramaState

	if cycloramaState.crossfadeTweens then
		for k, crossfadeTween in cycloramaState.crossfadeTweens do
			crossfadeTween:Cancel()
		end

		cycloramaState.crossfadeTweens = nil
	end

	local cycloramaState2 = self.cycloramaState
	local textureBuffer = cycloramaState2.textureBuffers[cycloramaState2.activeTextureIndex]

	local v16 = stageCrossfade(self.cycloramaState, self.cycloramaBack, p2)

	textureBuffer.Transparency = 0.015

	if not (fFlagAXBackgroundsCycloramaVR and self.isSpatial) then
		hideCycloramaSceneElements(self.newBackgroundScene)
	end

	task.spawn(function()
		if not pcall(function()
			ContentProvider:PreloadAsync({ v16 })
		end) then
			module9("BackgroundSceneManager: cyclorama crossfade preload failed for assetId=" .. tostring(p2.imageId))
		end

		if p3 ~= self.cycloramaState.activeToken then
			return
		end

		local tween = TweenService:Create(v16, tweenInfo, { Transparency = 0.015 })

		local tween2 = TweenService:Create(textureBuffer, tweenInfo, {
			Transparency = 1
		})
		self.cycloramaState.crossfadeTweens = { tween, tween2 }
		tween:Play()
		tween2:Play()

		self.cycloramaState.activeTextureIndex = 3 - self.cycloramaState.activeTextureIndex
		self.cycloramaFront = v16
	end)
end

function class:hideBackground()
	if not self.cyclorama then
		return
	end

	if fFlagAXBackgroundDisableFogWhileActive then
		class.restoreFogAfterBackground(self)
	end

	if fFlagAXSkyboxFromBackgroundAsset and v5 then
		v5.clearSkyboxOverride()
	end

	local cycloramaState = self.cycloramaState

	if cycloramaState.crossfadeTweens then
		for k, crossfadeTween in cycloramaState.crossfadeTweens do
			crossfadeTween:Cancel()
		end

		cycloramaState.crossfadeTweens = nil
	end

	if fFlagAXBackgroundGeneration then
		class.destroyActivePreviewImage(self)
	end

	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		for k, instance in self.cycloramaState.textureBuffers do
			TweenService:Create(instance, tweenInfo, { Transparency = 1 }):Play()
		end
	else
		for k, instance in self.cycloramaState.textureBuffers do
			TweenService:Create(instance, tweenInfo, { Transparency = 1 }):Play()
		end

		TweenService:Create(self.cycloramaBack, tweenInfo2, { Transparency = 1 }):Play()

		local modelInformationForAppPage = self:getModelInformationForAppPage(self:getCurrentPage())

		if modelInformationForAppPage then
			TweenService:Create(self.newBackgroundScene.Baseplate, tweenInfo, {
				Transparency = modelInformationForAppPage.BaseplateTransparency
			}):Play()

			if self:currentPageHasBlocks() then
				self.newBackgroundScene.LargerShapes.Position = v15.Walls.LargerShapesPosition
				self.newBackgroundScene.Clouds.Position = v15.Walls.CloudsPosition
				self.largerShapesAppearTween:Play()
				self.cloudsAppearTween:Play()
			else
				self.newBackgroundScene.LargerShapes.Position = modelInformationForAppPage.LargerShapesPosition
				self.newBackgroundScene.Clouds.Position = modelInformationForAppPage.CloudsPosition
			end

			self.newBackgroundScene.BackPanel.TextureWall.Transparency = modelInformationForAppPage.TextureWallTransparency
			self.newBackgroundScene.BackPanel.TextureFloor.Transparency = modelInformationForAppPage.TextureWallTransparency
		else
			TweenService:Create(self.newBackgroundScene.Baseplate, tweenInfo, {
				Transparency = 0
			}):Play()

			self.newBackgroundScene.BackPanel.TextureWall.Transparency = 1
			self.newBackgroundScene.BackPanel.TextureFloor.Transparency = 1
		end
	end
end

function class:updateActiveBackground(p2)
	if not self.cyclorama then
		return
	end

	if fFlagQRCodePageVisualRefresh and self.avatarRoute.current.params.hideAvatarBackground then
		if self.cycloramaState.currentAssetId ~= nil then
			self.cycloramaState.activeToken += 1
			self.cycloramaState.currentAssetId = nil
			self:hideBackground()
		end
	else
		if fFlagAXBackgroundGeneration then
			local v16 = selectActiveBackgroundPreview(p2)

			if v16 == nil then
				if self.cycloramaState.currentPreviewKey ~= nil and selectActiveBackground(p2) == nil then
					self.cycloramaState.activeToken += 1
					self:hideBackground()
					return
				end
			else
				if v16 == self.cycloramaState.currentPreviewKey then
					return
				end

				self.cycloramaState.activeToken += 1
				self.cycloramaState.currentAssetId = nil
				local resolved = previewImageRegistry.resolve(v16)

				if resolved then
					self:applyPreviewBackground(resolved, v16)
					return
				end

				module9("BackgroundSceneManager: preview image missing for key=" .. tostring(v16))
				self.cycloramaState.currentPreviewKey = nil

				return
			end
		end

		local v16 = selectActiveBackground(p2)

		if v16 == self.cycloramaState.currentAssetId then
			return
		end

		local currentAssetId = self.cycloramaState.currentAssetId
		self.cycloramaState.activeToken += 1
		local activeToken = self.cycloramaState.activeToken
		self.cycloramaState.currentAssetId = v16

		if v16 == nil then
			self:hideBackground()
		else
			loadBackgroundAsset.load(v16):andThen(function(p3)
				if activeToken ~= self.cycloramaState.activeToken then
					return
				end

				if currentAssetId == nil then
					self:applyBackground(p3)
				else
					self:crossfadeToBackground(p3, activeToken)
				end
			end):catch(function(p3)
				if activeToken ~= self.cycloramaState.activeToken then
					return
				end

				module9("BackgroundSceneManager: cyclorama load failed for assetId=" .. tostring(v16) .. ": " .. tostring(p3))

				self.cycloramaState.currentAssetId = nil
				self:hideBackground()
			end)
		end
	end
end

function class:setupTweening()
	local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0)

	local tweenInfo4 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.In, 0, false, 0)

	local tweenInfo5 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
	local v16 = { Transparency = 0 }
	local v17 = { Transparency = 1 }

	self.wallAppearTween = TweenService:Create(
		self.newBackgroundScene.BackPanel.TextureWall,
		tweenInfo5,
		v16
	)

	self.wallDisappearTween = TweenService:Create(
		self.newBackgroundScene.BackPanel.TextureWall,
		tweenInfo5,
		v17
	)

	self.floorAppearTween = TweenService:Create(
		self.newBackgroundScene.BackPanel.TextureFloor,
		tweenInfo5,
		v16
	)

	self.floorDisappearTween = TweenService:Create(
		self.newBackgroundScene.BackPanel.TextureFloor,
		tweenInfo5,
		v17
	)

	self.largerShapesAppearTween = TweenService:Create(self.newBackgroundScene.LargerShapes, tweenInfo3, {
		Position = v15.LargerShapes.LargerShapesPosition
	})

	self.largerShapesDisappearTween = TweenService:Create(
		self.newBackgroundScene.LargerShapes,
		tweenInfo4,
		{ Position = v15.Walls.LargerShapesPosition }
	)

	self.cloudsAppearTween = TweenService:Create(self.newBackgroundScene.Clouds, tweenInfo3, {
		Position = v15.LargerShapes.CloudsPosition
	})

	self.cloudsDisappearTween = TweenService:Create(self.newBackgroundScene.Clouds, tweenInfo4, {
		Position = v15.Walls.CloudsPosition
	})

	self.allTweens = {
		self.wallAppearTween,
		self.wallDisappearTween,
		self.floorAppearTween,
		self.floorDisappearTween,
		self.largerShapesAppearTween,
		self.largerShapesDisappearTween,
		self.cloudsAppearTween,
		self.cloudsDisappearTween
	}
end

function class:updateTheme(theme)
	self.theme = theme

	local v16 = v10.LightTheme

	if theme == "dark" then
		v16 = v10.DarkTheme
	end

	self.sceneOverrides = getSceneOverridesStore().getSceneOverrides()

	if self.sceneOverrides then
		v16 = table.clone(v16)
		v16.BackPanelTextureColor = self.sceneOverrides.BackPanel
		v16.CloudsTextureColor = self.sceneOverrides.Clouds
		v16.LargerShapesTextureColor = self.sceneOverrides.LargerShapes
		v16.BasePlateColor = self.sceneOverrides.Baseplate
		v16.FogStart = self.sceneOverrides.FogStart
		v16.FogEnd = self.sceneOverrides.FogEnd
		v16.FogColor = self.sceneOverrides.FogColor

		local colorSequence = ColorSequence.new(self.sceneOverrides.AvatarParticles)
		v16.ParticleEmitterColorAEToCatalog = colorSequence
		v16.ParticleEmitterColorCatalogToAE = colorSequence
	end

	for i, child in self.newBackgroundScene.BackPanel:GetChildren() do
		child.Color3 = v16.BackPanelTextureColor
	end

	for i, child in self.newBackgroundScene.Clouds:GetChildren() do
		child.Color3 = v16.CloudsTextureColor
	end

	for i, child in self.newBackgroundScene.LargerShapes:GetChildren() do
		child.Color3 = v16.LargerShapesTextureColor
	end

	self.newBackgroundScene.Baseplate.Color = v16.BasePlateColor

	local skyboxBlocker = self.newBackgroundScene:FindFirstChild("SkyboxBlocker")

	if skyboxBlocker then
		if self.sceneOverrides then
			skyboxBlocker.Transparency = self.sceneOverrides.SkyboxBlockerTransparency
			skyboxBlocker.Color = self.sceneOverrides.SkyboxBlockerColor
		else
			skyboxBlocker.Transparency = 1
		end
	end

	if v16.AmbientLightColor ~= nil then
		Lighting.Ambient = v16.AmbientLightColor
	end

	if v16.EnvironmentDiffuseScale ~= nil then
		Lighting.EnvironmentDiffuseScale = v16.EnvironmentDiffuseScale
	end

	if v16.EnvironmentSpecularScale ~= nil then
		Lighting.EnvironmentSpecularScale = v16.EnvironmentSpecularScale
	end

	if v16.FogStart ~= nil then
		Lighting.FogStart = v16.FogStart
	end

	if v16.FogEnd ~= nil then
		Lighting.FogEnd = v16.FogEnd
	end

	Lighting.FogColor = v16.FogColor

	if fFlagAXBackgroundDisableFogWhileActive and self.cycloramaState then
		class.reconcileFogForLighting(self, {
			FogStart = v16.FogStart,
			FogEnd = v16.FogEnd,
			FogColor = v16.FogColor
		})
	end

	for k, v17 in self.particleStorage do
		for k2, v18 in v17 do
			local v19 = if k == particleType.AvatarEditorToCatalog then v16.ParticleEmitterColorAEToCatalog else v16.ParticleEmitterColorCatalogToAE
			v18.Color = v19
		end
	end
end

function class:setLighting(data2)
	Lighting.Brightness = data2.Lighting.Brightness
	Lighting.ColorShift_Bottom = data2.Lighting.ColorShift_Bottom
	Lighting.ColorShift_Top = data2.Lighting.ColorShift_Top
	Lighting.OutdoorAmbient = data2.Lighting.OutdoorAmbient

	if not module5 then
		Lighting.Ambient = data2.Lighting.Ambient
	end

	Lighting.ClockTime = data2.Lighting.ClockTime
	Lighting.GeographicLatitude = data2.Lighting.GeographicLatitude
	Lighting.TimeOfDay = data2.Lighting.TimeOfDay
	local v16 = Lighting
	local v17 = if self.sceneOverrides then self.sceneOverrides.FogEnd else data2.Lighting.FogEnd
	v16.FogEnd = v17

	if not module5 then
		local v18 = Lighting
		local v19 = if self.sceneOverrides then self.sceneOverrides.FogStart else data2.Lighting.FogStart
		v18.FogStart = v19
	end

	if fFlagAXBackgroundDisableFogWhileActive and self.cycloramaState then
		local reconcileFogForLighting = class.reconcileFogForLighting
		local v19 = if not module5 then Lighting.FogStart else nil
		reconcileFogForLighting(self, { FogStart = v19, FogEnd = Lighting.FogEnd })
	end

	if module5 then
		self.newBackgroundScene.CharacterSpotLight.SpotLight.Enabled = false

		if module6 then
			local characterSpotLight_Left = self.newBackgroundScene:FindFirstChild("CharacterSpotLight_Left")

			if characterSpotLight_Left and characterSpotLight_Left:FindFirstChild("SpotLight") then
				characterSpotLight_Left.SpotLight.Enabled = true
			end

			local characterSpotLight_Right = self.newBackgroundScene:FindFirstChild("CharacterSpotLight_Right")

			if characterSpotLight_Right and characterSpotLight_Right:FindFirstChild("SpotLight") then
				characterSpotLight_Right.SpotLight.Enabled = true
			end
		else
			self.newBackgroundScene.CharacterSpotLight_Left.SpotLight.Enabled = true
			self.newBackgroundScene.CharacterSpotLight_Right.SpotLight.Enabled = true
		end
	end

	if data2.Bloom then
		if self.bloom then
			self.bloom.Enabled = true
			self.bloom.Intensity = data2.Bloom.Intensity
			self.bloom.Size = data2.Bloom.Size
			self.bloom.Threshold = data2.Bloom.Threshold
		end
	elseif self.bloom then
		self.bloom.Enabled = false
	end

	if data2.ColorCorrection then
		if self.colorCorrection then
			self.colorCorrection.Enabled = true
			self.colorCorrection.Brightness = data2.ColorCorrection.Brightness
			self.colorCorrection.Contrast = data2.ColorCorrection.Contrast
			self.colorCorrection.Saturation = data2.ColorCorrection.Saturation
		end
	elseif self.colorCorrection then
		self.colorCorrection.Enabled = false
	end
end

function class:startLighting()
	self:setLighting(v7)
end

function class:updateLighting(p2)
	if p2 == avatarScreen.ProfilePictureEditorFinal then
		self:setLighting(v9)

		local currentCharacter = not game.Workspace:FindFirstChild("ThumbnailLightAnchor_0")
			and self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

		if currentCharacter then
			lightUtility.AddDefaultPointLightRelativeTo(currentCharacter.HumanoidRootPart.CFrame)
		end
	else
		self:setLighting(v7)

		local thumbnailLightAnchor_0 = game.Workspace:FindFirstChild("ThumbnailLightAnchor_0")

		if thumbnailLightAnchor_0 then
			thumbnailLightAnchor_0:Destroy()
		end
	end
end

function class:playParticleEmitters(p3)
	if pagePlayParticleType[p3] == particleType.CatalogToAvatarEditor then
		task.spawn(function()
			for k, v16 in self.particleStorage[particleType.CatalogToAvatarEditor] do
				v16.Parent = self.newBackgroundScene.CatalogToAvatarEditorPFX
				v16.Enabled = true
			end

			wait(1)

			for k, v16 in self.particleStorage[particleType.CatalogToAvatarEditor] do
				v16.Enabled = false
			end
		end)
	elseif pagePlayParticleType[p3] == particleType.AvatarEditorToCatalog then
		task.spawn(function()
			for k, v16 in self.particleStorage[particleType.AvatarEditorToCatalog] do
				v16.Parent = self.newBackgroundScene.AvatarEditorToCatalogPFX
				v16.Enabled = true
			end

			wait(1)

			for k, v16 in self.particleStorage[particleType.AvatarEditorToCatalog] do
				v16.Enabled = false
			end
		end)
	end
end

function class.getCurrentPage(p2)
	return p2.avatarRoute.current.name
end

function class:currentPageHasBlocks(): boolean
	return pageBackgroundType[self:getCurrentPage()] == backgroundType.LargerShapes
end

function class:animateBackground(p2)
	task.spawn(function()
		self.wallDisappearTween:Play()
		self.floorDisappearTween:Play()
		self:playParticleEmitters(p2)
		wait(0.2)
		self.largerShapesAppearTween:Play()
		wait(0.2)
		self.cloudsAppearTween:Play()
	end)
end

function class:transitionWithTweens(p2)
	if p2 == avatarScreen.AvatarEditor or p2 == avatarScreen.MySharedAvatars then
		self:animateBackground(avatarScreen.AvatarEditor)

		if p2 == avatarScreen.MySharedAvatars then
			self:animateBackground(avatarScreen.MySharedAvatars)
		end
	elseif p2 == avatarScreen.ProfilePictureEditorEmotes then
		self:animateBackground(avatarScreen.ProfilePictureEditorEmotes)
	elseif module5 and p2 == avatarScreen.Catalog then
		self:animateBackground(avatarScreen.Catalog)
	elseif p2 == avatarScreen.Catalog or p2 == avatarScreen.AvatarExperienceLandingPage then
		task.spawn(function()
			if p2 ~= avatarScreen.AvatarExperienceLandingPage then
				self:playParticleEmitters(avatarScreen.Catalog)
			end

			self.largerShapesDisappearTween:Play()
			wait(0.2)
			self.cloudsDisappearTween:Play()
			wait(0.1)
			self.wallAppearTween:Play()
			self.floorAppearTween:Play()
		end)
	end

	local modelInformationForAppPage = self:getModelInformationForAppPage(p2)

	if modelInformationForAppPage then
		self.newBackgroundScene.Baseplate.Transparency = modelInformationForAppPage.BaseplateTransparency
	else
		self.newBackgroundScene.Baseplate.Transparency = 0
	end
end

function class:getModelInformationForAppPage(p3)
	if pageBackgroundType[p3] == backgroundType.LargerShapes then
		return v15.LargerShapes
	end

	if pageBackgroundType[p3] == backgroundType.NoShapesNoWalls then
		return v15.NoShapesNoWalls
	end

	if pageBackgroundType[p3] == backgroundType.Walls then
		return v15.Walls
	end

	return nil
end

function class:transitionInstant(p2)
	for k, allTween in self.allTweens do
		allTween:Cancel()
	end

	if pagePlayParticleType[p2] == particleType.None then
		for k, v16 in self.particleStorage do
			for k2, v17 in v16 do
				v17.Enabled = false
				v17.Parent = nil
			end
		end
	end

	local modelInformationForAppPage = self:getModelInformationForAppPage(p2)

	if modelInformationForAppPage then
		self.newBackgroundScene.BackPanel.TextureFloor.Transparency = modelInformationForAppPage.TextureWallTransparency
		self.newBackgroundScene.BackPanel.TextureWall.Transparency = modelInformationForAppPage.TextureWallTransparency
		self.newBackgroundScene.LargerShapes.Position = modelInformationForAppPage.LargerShapesPosition
		self.newBackgroundScene.Clouds.Position = modelInformationForAppPage.CloudsPosition
		self.newBackgroundScene.Baseplate.Transparency = modelInformationForAppPage.BaseplateTransparency
	end
end

function class:update(p2, p3, p4, p5)
	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		return
	end

	local name = p4.current.name
	local name2 = p5.current.name
	local name3 = p5.opaque.name

	local v16 = {
		[avatarScreen.Catalog] = not module5,
		[avatarScreen.AvatarEditor] = not module5,
		[avatarScreen.MySharedAvatars] = not module5,
		[avatarScreen.ProfilePictureEditorEmotes] = true
	}

	local v17 = false

	if v16[name] then
		v17 = name ~= name2 and v16[name2] and true or name ~= name3 and v16[name3] and true or false
	end

	self.ParticleEffectManager:setAvatarRoute(p4)

	local v18 = name == avatarScreen.AvatarExperienceLandingPage
		or name2 == avatarScreen.AvatarExperienceLandingPage

	local v19 = name == avatarScreen.AvatarEditor or name2 == avatarScreen.AvatarEditor
	local v20 = name == avatarScreen.Catalog or name2 == avatarScreen.Catalog
	local avatarBackground = module3.isAvatarBackground(name)
	local v21 = name == avatarScreen.ProfilePictureEditorEmotes
		or name2 == avatarScreen.ProfilePictureEditorEmotes
	local v22 = v18 and (v20 or v19 or v21)
	local v23 = fFlagAXBackgroundCycloramaRendering
		and self.cyclorama
		and self.cycloramaState.currentAssetId ~= nil

	if name ~= name2 then
		if (v17 or v22) and not v23 then
			self:transitionWithTweens(name)
		else
			self:transitionInstant(name)

			if avatarBackground then
				self:playParticleEmitters(name)
			end
		end

		if v23 then
			hideCycloramaSceneElements(self.newBackgroundScene)
		end

		self:updateLighting(name)
	end
end

function class:start()
	if fFlagAXBackgroundCycloramaRendering and self.cyclorama then
		self.cyclorama.Parent = workspace
	end

	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		table.insert(self.connections, self.store.changed:connect(function(p2, p3)
			if self.cyclorama then
				self:updateActiveBackground(p2)
			end
		end))

		if self.cyclorama then
			self:updateActiveBackground(self.store:getState())
		end
	else
		self.colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)

		if not self.newBackgroundScene:FindFirstChild("SkyboxBlocker") then
			local skyboxBlocker = self.newBackgroundScene.BackPanel:Clone()
			skyboxBlocker.Name = "SkyboxBlocker"
			skyboxBlocker.Material = Enum.Material.SmoothPlastic
			skyboxBlocker.Size = Vector3.new(defineFastInt, defineFastInt2, defineFastInt3)
			skyboxBlocker.Position = Vector3.new(defineFastInt4, defineFastInt5, defineFastInt6)

			for i, child in skyboxBlocker:GetChildren() do
				child:Destroy()
			end

			skyboxBlocker.Parent = self.newBackgroundScene
		end

		self:updateTheme(self.theme)

		local name = self.avatarRoute.current.name
		local selectedTheme = string.lower(NotificationService.SelectedTheme)

		if self.theme ~= selectedTheme then
			self:updateTheme(selectedTheme)
		end

		table.insert(self.connections, self.store.changed:connect(function(p2, p3)
			local avatarRoute = self.avatarRoute
			self:update(p2, p3, avatarRoute, avatarRoute)

			if fFlagAXBackgroundCycloramaRendering and self.cyclorama then
				self:updateActiveBackground(p2)
			end

			if fFlagAXBringingItBack then
				self:syncClassicAvatarScene(p2)
			end
		end))

		if fFlagAXBackgroundCycloramaRendering and self.cyclorama then
			self:updateActiveBackground(self.store:getState())
		end

		table.insert(
			self.connections,
			NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function()
				self:updateTheme(string.lower(NotificationService.SelectedTheme))
			end)
		)

		table.insert(self.connections, {
			disconnect = getSceneOverridesStore().subscribe(function(p2)
				self:updateTheme(self.theme)
			end)
		})

		local v16 = 20
		self.newBackgroundScene.BlobShadow.Decal.Transparency = 0.4

		if module5 then
			local size = self.newBackgroundScene.BlobShadow.Size
			local v17 = math.sqrt(size.X * size.Z * 0.7)

			self.newBackgroundScene.BlobShadow.Size = Vector3.new(v17, size.Y, v17)
			self.newBackgroundScene.BlobShadow.Position = Vector3.new(0, -0.1, 0)
		end

		local v17 = tonumber(module4())

		if v17 > 0 then
			v16 = v17
		end

		for k, v18 in self.particleStorage do
			for k2, v19 in v18 do
				v19.Rate = v16
			end
		end

		self:startLighting()
		self.newBackgroundScene.Parent = game.Workspace

		if
			name == avatarScreen.AvatarEditor
			or name == avatarScreen.AvatarExperienceLandingPage
			or name == avatarScreen.Catalog
			or module3.isAvatarBackground(name)
			or name == avatarScreen.ProfilePictureEditorEmotes
			or fFlagEnableSplitPane and name == module10.SplitPaneBackgroundPage
		then
			self:transitionInstant(name)
		end

		self.ParticleEffectManager:start()

		if module3.isAvatarBackground(name) then
			self:playParticleEmitters(name)
		end

		if fFlagAXBringingItBack then
			self:syncClassicAvatarScene(self.store:getState())
		end
	end
end

function class:stop()
	for k, connection in self.connections do
		connection:disconnect()
	end

	if fFlagAXBackgroundCycloramaRendering and self.cyclorama then
		self.cycloramaFront.Transparency = 1
		self.cycloramaBack.Transparency = 1
		self.cyclorama.Parent = ReplicatedStorage
		self.cycloramaState.activeToken += 1
		self.cycloramaState.currentAssetId = nil

		if fFlagAXSkyboxFromBackgroundAsset and v5 then
			v5.clearSkyboxOverride()
		end

		if fFlagAXBackgroundGeneration then
			class.destroyActivePreviewImage(self)
		end
	end

	if fFlagAXBackgroundDisableFogWhileActive then
		class.restoreFogAfterBackground(self, true)
	end

	self.connections = {}

	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		return
	end

	if fFlagAXBringingItBack and self.classicAvatarScene then
		module2.hide(self.classicAvatarScene)
	end

	self.newBackgroundScene.Parent = ReplicatedStorage
	self.ParticleEffectManager:stop()

	if defineFastFlag then
		for k, v16 in self.particleStorage do
			local child = self.newBackgroundScene:FindFirstChild(k == particleType.AvatarEditorToCatalog and "AvatarEditorToCatalogPFX" or "CatalogToAvatarEditorPFX")

			if not child then
				continue
			end

			for k2, v17 in v16 do
				v17.Parent = child
			end
		end
	else
		for k, v16 in self.particleStorage do
			for k2, v17 in v16 do
				local v18 = if k == particleType.AvatarEditorToCatalog then self.newBackgroundScene.AvatarEditorToCatalogPFX else self.newBackgroundScene.CatalogToAvatarEditorPFX
				v17.Parent = v18
			end
		end
	end
end

function class:onDestroy()
	if fFlagAXFixCycloramaOrphanRemount then
		self:stop()
	end

	if fFlagAXBackgroundsCycloramaVR and self.isSpatial then
		return
	end

	self.ParticleEffectManager:onDestroy()
end

function class:updateAvatarRoute(avatarRoute, p2)
	self.avatarRoute = avatarRoute
	local state = self.store:getState()
	self:update(state, state, avatarRoute, p2)
end

return class
