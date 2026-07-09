local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local NotificationService = game:GetService("NotificationService")
local InsertService = game:GetService("InsertService")
local MaterialService = game:GetService("MaterialService")
local TweenService = game:GetService("TweenService")
local Modules = CoreGui.RobloxGui.Modules
local Signals = require(CorePackages.Packages.Signals)
local mutedError = require(Modules.LuaApp.mutedError)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getSceneOverridesStore = require(CorePackages.Workspace.Packages.Style).getSceneOverridesStore
local PhotoboothSceneData = require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothSceneData)
local PhotoboothStoreBridge = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).PhotoboothStoreBridge
local ParticleEffectManager = require(Modules.AvatarExperience.Common.Managers.ParticleEffectManager)
local FFlagUseUpdatedBackgroundSceneSettingsOnMobile = require(Modules.AvatarExperience.Flags.FFlagUseUpdatedBackgroundSceneSettingsOnMobile)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXBackgroundCycloramaRendering = AvatarExperienceFlags.FFlagAXBackgroundCycloramaRendering
local FFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local loadBackgroundAsset = AvatarExperienceCommon.Backgrounds.loadBackgroundAsset
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local FFlagEnableCoreContentTheme = SharedFlags.FFlagEnableCoreContentTheme
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local v26 = CFrame.new(0, 0, -6) * CFrame.Angles(0, 3.141592653589793, 0)
local PhotoboothScenes = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).Enums.PhotoboothScenes
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4) -- line: 131
	-- upvalues: t1 (copy), FFlagAXBackgroundsCycloramaVR (copy), ParticleEffectManager (copy), ReplicatedStorage (copy), FFlagAXBackgroundCycloramaRendering (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.store = p1
	t2.networking = p2
	t2.avatarRoute = p3
	t2.isSpatial = p4 or false
	t2.connections = {}
	t2.signals = {}

	if FFlagAXBackgroundsCycloramaVR and t2.isSpatial then
		t2.ParticleEffectManager = nil
		t2.managedLightingObjects = {}
		t2.originalLightingObjects = {}
		t2.managedMaterialVariants = {}
		t2.defaultScenes = {
			light = "",
			dark = ""
		}
		t2.currentScene = nil
		t2.changeSceneTask = nil
		t2:initCyclorama()

		return t2
	end

	t2.ParticleEffectManager = ParticleEffectManager.new(p1, p3)
	t2.managedLightingObjects = {}
	t2.originalLightingObjects = {}
	t2.managedMaterialVariants = {}
	t2.defaultScenes = {
		light = "BlockyLight",
		dark = "BlockyDark"
	}

	if not ReplicatedStorage:FindFirstChild("Scenes") then
		t2.scenesFolder = Instance.new("Folder")
		t2.scenesFolder.Parent = ReplicatedStorage
		t2.scenesFolder.Name = "Scenes"
	else
		t2.scenesFolder = ReplicatedStorage:FindFirstChild("Scenes")
	end

	t2:CleanupDefaultBackgroundScene()
	t2.currentScene = nil
	t2.changeSceneTask = nil

	if FFlagAXBackgroundCycloramaRendering then
		t2:initCyclorama()
	end

	return t2
end
function t1.initCyclorama(p5) -- line: 204
	-- upvalues: ReplicatedStorage (copy), mutedError (copy), FFlagAXBackgroundsCycloramaVR (copy), v26 (copy)
	local AvatarCyclorama = ReplicatedStorage:FindFirstChild("AvatarCyclorama")

	if not AvatarCyclorama or not AvatarCyclorama:IsA("Model") then
		mutedError("BackgroundSceneManager: AvatarCyclorama missing from ReplicatedStorage")

		return
	end

	local texture_mesh = AvatarCyclorama:FindFirstChild("texture_mesh")
	local color_mesh = AvatarCyclorama:FindFirstChild("color_mesh")
	local v39 = if not texture_mesh or not texture_mesh:IsA("BasePart") then nil else texture_mesh
	local v40 = if not color_mesh or not color_mesh:IsA("BasePart") then nil else color_mesh

	if not v39 or not v40 then
		mutedError(string.format("BackgroundSceneManager: AvatarCyclorama missing texture_mesh=%s color_mesh=%s", tostring(v39 ~= nil), (tostring(v40 ~= nil))))

		return
	end

	p5.cyclorama = AvatarCyclorama
	p5.cycloramaFront = v39
	p5.cycloramaBack = v40
	p5.cycloramaState = {
		activeToken = 0,
		currentAssetId = nil
	}
	v39.Anchored = true
	v40.Anchored = true
	v39.Transparency = 1
	v40.Transparency = 1

	if FFlagAXBackgroundsCycloramaVR and p5.isSpatial then
		AvatarCyclorama:PivotTo(v26)
	else
		AvatarCyclorama:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0))
	end

	AvatarCyclorama.Parent = workspace
end
function t1.applyBackground(p6, t3: {[any]: any}) -- line: 255
	-- upvalues: TweenService (copy), tweenInfo (copy), FFlagAXBackgroundsCycloramaVR (copy)
	local cycloramaFront = p6.cycloramaFront
	local cycloramaBack = p6.cycloramaBack

	if not cycloramaFront or not cycloramaBack then
		return
	end

	if cycloramaFront:IsA("MeshPart") then
		cycloramaFront.TextureContent = Content.fromUri(`rbxassetid://{ t3.imageId }`)
	end

	TweenService:Create(cycloramaFront, tweenInfo, {
		Transparency = 0.015
	}):Play()

	if FFlagAXBackgroundsCycloramaVR and p6.isSpatial then
		return
	end

	cycloramaBack.Color = t3.backgroundColor
	TweenService:Create(cycloramaBack, tweenInfo, {
		Transparency = 0
	}):Play()
	p6:hideCurrentSceneElements()
end
function t1.hideCurrentSceneElements(p7) -- line: 289
	-- upvalues: TweenService (copy), tweenInfo (copy)
	local currentScene = p7.currentScene

	if not currentScene then
		return
	end

	local Baseplate = currentScene:FindFirstChild("Baseplate")

	if Baseplate and Baseplate:IsA("BasePart") then
		TweenService:Create(Baseplate, tweenInfo, {
			Transparency = 1
		}):Play()
	end

	local LargerShapes = currentScene:FindFirstChild("LargerShapes")

	if LargerShapes and LargerShapes:IsA("BasePart") then
		if p7.cycloramaSavedLargerShapesPosition == nil then
			p7.cycloramaSavedLargerShapesPosition = LargerShapes.Position
		end

		LargerShapes.Position = Vector3.new(-62.89799880981445, -1000, -8.8149995803833)
	end

	local Clouds = currentScene:FindFirstChild("Clouds")

	if Clouds and Clouds:IsA("BasePart") then
		if p7.cycloramaSavedCloudsPosition == nil then
			p7.cycloramaSavedCloudsPosition = Clouds.Position
		end

		Clouds.Position = Vector3.new(-90, 1000, 0)
	end
end
function t1.hideBackground(p8) -- line: 315
	-- upvalues: TweenService (copy), tweenInfo (copy), FFlagAXBackgroundsCycloramaVR (copy)
	local cycloramaFront = p8.cycloramaFront
	local cycloramaBack = p8.cycloramaBack

	if not cycloramaFront or not cycloramaBack then
		return
	end

	TweenService:Create(cycloramaFront, tweenInfo, {
		Transparency = 1
	}):Play()

	if FFlagAXBackgroundsCycloramaVR and p8.isSpatial then
		return
	end

	TweenService:Create(cycloramaBack, tweenInfo, {
		Transparency = 1
	}):Play()

	local currentScene = p8.currentScene

	if currentScene then
		local Baseplate = currentScene:FindFirstChild("Baseplate")

		if Baseplate and Baseplate:IsA("BasePart") then
			TweenService:Create(Baseplate, tweenInfo, {
				Transparency = 0
			}):Play()
		end

		local LargerShapes = currentScene:FindFirstChild("LargerShapes")

		if LargerShapes and LargerShapes:IsA("BasePart") and p8.cycloramaSavedLargerShapesPosition then
			LargerShapes.Position = p8.cycloramaSavedLargerShapesPosition
			p8.cycloramaSavedLargerShapesPosition = nil
		end

		local Clouds = currentScene:FindFirstChild("Clouds")

		if Clouds and Clouds:IsA("BasePart") and p8.cycloramaSavedCloudsPosition then
			Clouds.Position = p8.cycloramaSavedCloudsPosition
			p8.cycloramaSavedCloudsPosition = nil
		end
	end
end
function t1.updateActiveBackground(p9, p10) -- line: 352
	-- upvalues: selectActiveBackground (copy), loadBackgroundAsset (copy), mutedError (copy)
	local cycloramaState = p9.cycloramaState

	if not cycloramaState or not p9.cyclorama then
		return
	end

	local v60 = selectActiveBackground(p10)

	if v60 == cycloramaState.currentAssetId then
		return
	end

	cycloramaState.activeToken = cycloramaState.activeToken + 1

	local activeToken = cycloramaState.activeToken

	cycloramaState.currentAssetId = v60

	if v60 == nil then
		p9:hideBackground()

		return
	end

	loadBackgroundAsset.load(v60):andThen(function(p11) -- line: 374
		-- upvalues: activeToken (copy), cycloramaState (copy), p9 (copy)
		if activeToken ~= cycloramaState.activeToken then
			return
		end

		p9:applyBackground(p11)
	end):catch(function(p12) -- line: 380
		-- upvalues: activeToken (copy), cycloramaState (copy), mutedError (copy), v60 (copy), p9 (copy)
		if activeToken ~= cycloramaState.activeToken then
			return
		end

		mutedError("BackgroundSceneManager: cyclorama load failed for assetId=" .. tostring(v60) .. ": " .. tostring(p12))
		cycloramaState.currentAssetId = nil
		p9:hideBackground()
	end)
end
function t1.moveOriginalLightingToStorage(p13) -- line: 393
	-- upvalues: Lighting (copy)
	for _, child in Lighting:GetChildren() do
		table.insert(p13.originalLightingObjects, child)
		child.Parent = nil
	end
end
function t1.clearManagedLighting(p14) -- line: 402
	for _, v67 in p14.managedLightingObjects do
		v67:Destroy()
	end

	p14.managedLightingObjects = {}
end
function t1.restoreOriginalLighting(p15) -- line: 411
	-- upvalues: Lighting (copy)
	p15:clearManagedLighting()

	for _, v70 in p15.originalLightingObjects do
		v70.Parent = Lighting
	end

	p15.originalLightingObjects = {}
end
function t1.applyLightingFromConfig(p16, p17) -- line: 423
	-- upvalues: Lighting (copy)
	p16:clearManagedLighting()

	local LightingConfig = p17:FindFirstChild("LightingConfig")

	if not LightingConfig then
		return
	end

	for v74, v75 in (LightingConfig:GetAttributes()) do
		local ok, result = pcall(function() -- line: 436
			-- upvalues: Lighting (copy), v74 (copy), v75 (copy)
			Lighting[v74] = v75
		end)

		if not ok then
			warn("BackgroundSceneManager: Failed to apply lighting property", v74, ":", result)
		end
	end

	local LightingObjects = p17:FindFirstChild("LightingObjects")

	if LightingObjects then
		for _, child in LightingObjects:GetChildren() do
			local clone = child:Clone()

			clone.Parent = Lighting
			table.insert(p16.managedLightingObjects, clone)
		end
	end
end
function t1.clearManagedMaterialVariants(p18) -- line: 457
	for _, v84 in p18.managedMaterialVariants do
		v84:Destroy()
	end

	p18.managedMaterialVariants = {}
end
function t1.applyMaterialVariantsFromConfig(p19, p20) -- line: 466
	-- upvalues: MaterialService (copy)
	p19:clearManagedMaterialVariants()

	local MaterialVariants = p20:FindFirstChild("MaterialVariants")

	if MaterialVariants then
		for _, child in MaterialVariants:GetChildren() do
			if child:IsA("MaterialVariant") then
				local clone = child:Clone()

				clone.Parent = MaterialService
				table.insert(p19.managedMaterialVariants, clone)
			end
		end
	end
end
function t1.pickScene(p21, s1: string?) -- line: 485
	-- upvalues: PhotoboothStoreBridge (copy), PhotoboothSceneData (copy), NotificationService (copy), FFlagEnableCoreContentTheme (copy), InsertService (copy), PhotoboothScenes (copy), mutedError (copy), FFlagAXBackgroundCycloramaRendering (copy)
	if not s1 then
		local v93 = PhotoboothStoreBridge.getStore()

		if v93 then
			s1 = v93.getSelectedSceneId(false)
		end
	end

	local v94 = s1 or ""
	local v95 = PhotoboothSceneData.PHOTOBOOTH_SCENES[v94]

	if not v95 then
		warn("BackgroundSceneManager: Unknown scene ID:", v94)

		return
	end

	if p21.currentScene then
		p21.currentScene.Parent = p21.scenesFolder
	end

	p21.currentScene = nil

	local v96 = (NotificationService.SelectedTheme or "Light"):lower() == "dark"

	if v94 == "" then
		local v97 = if not v96 then p21.defaultScenes.light else p21.defaultScenes.dark
		local v98 = nil

		if p21.scenesFolder then
			v98 = p21.scenesFolder:FindFirstChild(v97)
		end

		if v98 then
			p21.currentScene = v98
			v98.Parent = workspace
			p21:applyLightingFromConfig(v98)
			p21:applyMaterialVariantsFromConfig(v98)

			if FFlagEnableCoreContentTheme then
				p21:applyParticleColorOverrides()
			end
		end
	else
		local asset = v95.asset
		local position = v95.position
		local rotation = v95.rotation
		local u102 = v95.remote or false

		if v96 and v95.dark then
			asset = v95.dark.asset or v95.asset
			position = v95.dark.position or v95.position
			rotation = v95.dark.rotation or v95.rotation
			u102 = v95.dark.remote or (v95.remote or false)
		end

		if asset then
			local u103 = nil
			local v104 = v95.id .. ((not v96 or not v95.dark) and "_light" or "_dark")

			if p21.scenesFolder then
				u103 = p21.scenesFolder:FindFirstChild(v104)
			end

			if not u103 then
				local ok, result = pcall(function() -- line: 553
					-- upvalues: u102 (ref), asset (ref), InsertService (copy)
					if u102 then
						local v177 = asset

						if string.find(asset, "rbxassetid://") then
							v177 = string.gsub(asset, "rbxassetid://", "")
						end

						local num = tonumber(v177)

						if num then
							local v179 = InsertService:LoadAsset(num)
							local v180 = v179:GetChildren()[1]

							if v180 then
								v180.Parent = nil
								v179:Destroy()

								return v180
							end

							error("No content found in loaded remote asset: " .. asset)

							return
						end

						error("Invalid asset ID format: " .. asset)

						return
					end

					return InsertService:LoadLocalAsset(asset)
				end)

				if ok and result then
					u103 = result

					if u103 then
						u103.Name = v104
						u103.Parent = p21.scenesFolder
					end

					local v107 = position or Vector3.new(0, 0, 0)
					local v108 = rotation or CFrame.Angles(0, 0, 0)
					local ok2, result2 = pcall(function() -- line: 593
						-- upvalues: u103 (ref), v107 (copy), v108 (copy)
						if u103 then
							u103:PivotTo(CFrame.new(v107) * v108)
						end
					end)

					if not ok2 then
						warn("BackgroundSceneManager: Failed to set scene position for", v95.id, ":", result2)
					end
				else
					local v111 = if not u102 then PhotoboothScenes.LOCAL else PhotoboothScenes.REMOTE

					warn("BackgroundSceneManager: Failed to load", v111, "scene asset", asset, "for scene", v95.id)
					mutedError("BackgroundSceneManager failed to load scene asset.")

					if result then
						warn("BackgroundSceneManager: Error details:", result)
					end

					local v112 = if not v96 then p21.defaultScenes.light else p21.defaultScenes.dark

					if not p21.scenesFolder then
						warn("BackgroundSceneManager: No fallback scene available")

						return
					end

					local v113 = p21.scenesFolder:FindFirstChild(v112)

					if v113 then
						warn("BackgroundSceneManager: Falling back to default scene:", v112)
						u103 = v113
					end
				end
			end

			if u103 then
				p21.currentScene = u103
				p21.currentScene.Parent = workspace

				local ok, result = pcall(function() -- line: 643
					-- upvalues: p21 (copy), u103 (ref)
					p21:applyLightingFromConfig(u103)
				end)

				if not ok then
					warn("BackgroundSceneManager: Failed to apply lighting configuration for scene", v95.id, ":", result)
				end

				local ok3, result3 = pcall(function() -- line: 657
					-- upvalues: p21 (copy), u103 (ref)
					p21:applyMaterialVariantsFromConfig(u103)
				end)

				if not ok3 then
					warn("BackgroundSceneManager: Failed to apply material configuration for scene", v95.id, ":", result3)
				end

				if FFlagEnableCoreContentTheme then
					p21:applyParticleColorOverrides()
				end
			end
		end
	end

	local cycloramaState = p21.cycloramaState

	if FFlagAXBackgroundCycloramaRendering and cycloramaState and cycloramaState.currentAssetId ~= nil then
		p21:hideCurrentSceneElements()
	end
end
function t1.createLightingConfiguration(_, p23) -- line: 685
	-- upvalues: Lighting (copy)
	local Configuration = Instance.new("Configuration")

	Configuration.Name = "LightingConfig"
	Configuration.Parent = p23
	Configuration:SetAttribute("Brightness", Lighting.Brightness)
	Configuration:SetAttribute("ClockTime", Lighting.ClockTime)
	Configuration:SetAttribute("EnvironmentDiffuseScale", Lighting.EnvironmentDiffuseScale)
	Configuration:SetAttribute("EnvironmentSpecularScale", Lighting.EnvironmentSpecularScale)
	Configuration:SetAttribute("FogEnd", Lighting.FogEnd)
	Configuration:SetAttribute("FogStart", Lighting.FogStart)
	Configuration:SetAttribute("GeographicLatitude", Lighting.GeographicLatitude)
	Configuration:SetAttribute("ShadowSoftness", Lighting.ShadowSoftness)
	Configuration:SetAttribute("Ambient", Lighting.Ambient)
	Configuration:SetAttribute("ColorShift_Bottom", Lighting.ColorShift_Bottom)
	Configuration:SetAttribute("ColorShift_Top", Lighting.ColorShift_Top)
	Configuration:SetAttribute("FogColor", Lighting.FogColor)
	Configuration:SetAttribute("OutdoorAmbient", Lighting.OutdoorAmbient)
	Configuration:SetAttribute("TimeOfDay", Lighting.TimeOfDay)
	Configuration:SetAttribute("GlobalShadows", Lighting.GlobalShadows)

	return Configuration
end

local t4 = {
	"CatalogToAvatarEditorPFX",
	"AvatarEditorToCatalogPFX"
}

function t1.applyParticleColorOverrides(p24) -- line: 712
	-- upvalues: SharedFlags (copy), getSceneOverridesStore (copy), t4 (copy)
	if not SharedFlags.FFlagEnableCoreContentTheme then
		return
	end

	local currentScene = p24.currentScene

	if not currentScene then
		return
	end

	local v124 = getSceneOverridesStore().getSceneOverrides()

	if not v124 then
		return
	end

	local colorSequence = ColorSequence.new(v124.AvatarParticles)

	for _, v127 in t4 do
		local v128 = currentScene:FindFirstChild(v127)

		if v128 then
			for _, descendant in v128:GetDescendants() do
				if descendant:IsA("ParticleEmitter") then
					descendant.Color = colorSequence
				end
			end
		end
	end
end
function t1.CleanupDefaultBackgroundScene(p25) -- line: 741
	-- upvalues: ReplicatedStorage (copy), FFlagUseUpdatedBackgroundSceneSettingsOnMobile (copy), FFlagAXBackgroundCycloramaRendering (copy)
	local AvatarSceneNew = ReplicatedStorage:WaitForChild("AvatarSceneNew")
	local t5 = {
		Brightness = 2,
		FogEnd = 92,
		GlobalShadows = true,
		ShadowSoftness = 0.2,
		BloomEnabled = true,
		BloomSize = 12,
		BloomThreshold = 0.95,
		ColorCorrectionEnabled = true,
		ColorCorrectionBrightness = 0,
		ColorCorrectionContrast = 0,
		ColorCorrectionSaturation = 0,
		SkyboxAssetLocation = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
		ColorShift_Bottom = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(232, 255, 146) else Color3.fromRGB(108, 94, 66),
		ColorShift_Top = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(85, 136, 167) else Color3.fromRGB(94, 100, 172),
		ClockTime = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 12 or 11,
		GeographicLatitude = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 41.733 or 24,
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		TimeOfDay = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and "12:00:00" or "11:00:00",
		Ambient = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(170, 170, 170) else Color3.fromRGB(130, 130, 130),
		EnvironmentDiffuseScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 0.2,
		EnvironmentSpecularScale = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then nil else 1,
		FogStart = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 20 or 30,
		FogColor = Color3.fromRGB(213, 213, 213),
		BloomIntensity = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 0.3 or 0.2,
		ColorCorrectionTintColor = Color3.fromRGB(255, 255, 255),
		BackPanelTextureColor = Color3.fromRGB(213, 213, 213),
		CloudsTextureColor = Color3.fromRGB(222, 222, 222),
		LargerShapesTextureColor = Color3.fromRGB(222, 222, 222),
		BasePlateColor = Color3.fromRGB(213, 213, 213)
	}
	local t6 = {
		Brightness = 2,
		FogEnd = 92,
		GlobalShadows = true,
		ShadowSoftness = 0.2,
		BloomEnabled = true,
		BloomSize = 12,
		BloomThreshold = 0.95,
		ColorCorrectionEnabled = true,
		ColorCorrectionBrightness = 0,
		ColorCorrectionContrast = 0,
		ColorCorrectionSaturation = 0,
		SkyboxAssetLocation = "rbxasset://textures/ui/AvatarExperience/AvatarExperienceSkyboxDarkTheme.png",
		ColorShift_Bottom = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(232, 255, 146) else Color3.fromRGB(108, 94, 66),
		ColorShift_Top = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(85, 136, 167) else Color3.fromRGB(94, 100, 172),
		ClockTime = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 12 or 11,
		GeographicLatitude = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 41.733 or 24,
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		TimeOfDay = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and "12:00:00" or "11:00:00",
		Ambient = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(170, 170, 170) else Color3.fromRGB(180, 180, 180),
		EnvironmentDiffuseScale = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 1 or 1,
		EnvironmentSpecularScale = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 1 or 1,
		FogStart = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 20 or 20,
		FogColor = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then Color3.fromRGB(45, 46, 49) else Color3.fromRGB(55, 56, 59),
		BloomIntensity = not FFlagUseUpdatedBackgroundSceneSettingsOnMobile and 0.3 or 0.2,
		ColorCorrectionTintColor = Color3.fromRGB(255, 255, 255),
		BackPanelTextureColor = Color3.fromRGB(83, 80, 82),
		CloudsTextureColor = Color3.fromRGB(100, 101, 108),
		LargerShapesTextureColor = Color3.fromRGB(100, 101, 108),
		BasePlateColor = Color3.fromRGB(83, 80, 82)
	}

	for _, v136 in {
		{
			name = p25.defaultScenes.light,
			theme = t5
		},
		{
			name = p25.defaultScenes.dark,
			theme = t6
		}
	} do
		local clone = AvatarSceneNew:Clone()

		clone.Name = v136.name
		clone.Parent = p25.scenesFolder

		if FFlagAXBackgroundCycloramaRendering then
			local AvatarCyclorama = clone:FindFirstChild("AvatarCyclorama")

			if AvatarCyclorama then
				AvatarCyclorama:Destroy()
			end
		end

		local BlobShadow = clone:FindFirstChild("BlobShadow")

		if BlobShadow then
			clone.PrimaryPart = BlobShadow
			BlobShadow.CFrame = CFrame.new(0, 0, 0)
		end

		local theme = v136.theme
		local BackPanel = clone:FindFirstChild("BackPanel")

		if BackPanel then
			BackPanel.Transparency = 1

			for _, child in BackPanel:GetChildren() do
				if child:IsA("BasePart") then
					child.Color = theme.BackPanelTextureColor
				else
					pcall(function() -- line: 877
						-- upvalues: child (copy), theme (copy)
						child.Color3 = theme.BackPanelTextureColor
					end)
				end

				child.Transparency = 1
			end
		end

		local Clouds = clone:FindFirstChild("Clouds")

		if Clouds then
			for _, child in Clouds:GetChildren() do
				if child:IsA("BasePart") then
					child.Color = theme.CloudsTextureColor
				else
					pcall(function() -- line: 891
						-- upvalues: child (copy), theme (copy)
						child.Color3 = theme.CloudsTextureColor
					end)
				end
			end
		end

		local LargerShapes = clone:FindFirstChild("LargerShapes")

		if LargerShapes then
			for _, child in LargerShapes:GetChildren() do
				if child:IsA("BasePart") then
					child.Color = theme.LargerShapesTextureColor
				else
					pcall(function() -- line: 904
						-- upvalues: child (copy), theme (copy)
						child.Color3 = theme.LargerShapesTextureColor
					end)
				end
			end
		end

		local Baseplate = clone:FindFirstChild("Baseplate")

		if Baseplate and Baseplate:IsA("BasePart") then
			Baseplate.Color = theme.BasePlateColor
		end

		local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
		local BloomEffect = Instance.new("BloomEffect")
		local Sky = Instance.new("Sky")

		Sky.CelestialBodiesShown = true
		Sky.StarCount = 3000
		Sky.SkyboxBk = theme.SkyboxAssetLocation
		Sky.SkyboxDn = theme.SkyboxAssetLocation
		Sky.SkyboxFt = theme.SkyboxAssetLocation
		Sky.SkyboxLf = theme.SkyboxAssetLocation
		Sky.SkyboxRt = theme.SkyboxAssetLocation
		Sky.SkyboxUp = theme.SkyboxAssetLocation
		BloomEffect.Enabled = theme.BloomEnabled
		BloomEffect.Intensity = theme.BloomIntensity
		BloomEffect.Size = theme.BloomSize
		BloomEffect.Threshold = theme.BloomThreshold
		ColorCorrectionEffect.Enabled = theme.ColorCorrectionEnabled
		ColorCorrectionEffect.Brightness = theme.ColorCorrectionBrightness
		ColorCorrectionEffect.Contrast = theme.ColorCorrectionContrast
		ColorCorrectionEffect.Saturation = theme.ColorCorrectionSaturation
		ColorCorrectionEffect.TintColor = theme.ColorCorrectionTintColor

		local Folder = Instance.new("Folder")

		Folder.Name = "LightingObjects"
		Folder.Parent = clone
		ColorCorrectionEffect.Parent = Folder
		BloomEffect.Parent = Folder
		Sky.Parent = Folder
		p25:createLightingConfiguration(clone)

		local LightingConfig = clone:FindFirstChild("LightingConfig")

		if LightingConfig then
			for v156, v157 in theme do
				if v157 ~= nil and LightingConfig:GetAttribute(v156) ~= nil then
					LightingConfig:SetAttribute(v156, v157)
				end
			end
		end
	end

	AvatarSceneNew:Destroy()
end
function t1.start(p26) -- line: 973
	-- upvalues: FFlagAXBackgroundCycloramaRendering (copy), FFlagAXBackgroundsCycloramaVR (copy), NotificationService (copy), Signals (copy), PhotoboothStoreBridge (copy), FFlagEnableCoreContentTheme (copy), getSceneOverridesStore (copy)
	if FFlagAXBackgroundCycloramaRendering and p26.cyclorama then
		p26.cyclorama.Parent = workspace
	end

	if FFlagAXBackgroundsCycloramaVR and p26.isSpatial then
		table.insert(p26.connections, p26.store.changed:connect(function(p27, _) -- line: 984
			-- upvalues: p26 (copy)
			if p26.cyclorama then
				p26:updateActiveBackground(p27)
			end
		end))

		if p26.cyclorama then
			p26:updateActiveBackground(p26.store:getState())
		end

		return
	end

	p26:moveOriginalLightingToStorage()
	p26:pickScene()
	table.insert(p26.connections, p26.store.changed:connect(function(p29, p30) -- line: 1003
		-- upvalues: p26 (copy), FFlagAXBackgroundCycloramaRendering (copy)
		local avatarRoute = p26.avatarRoute

		p26:update(p29, p30, avatarRoute, avatarRoute)

		if FFlagAXBackgroundCycloramaRendering and p26.cyclorama then
			p26:updateActiveBackground(p29)
		end
	end))

	if FFlagAXBackgroundCycloramaRendering and p26.cyclorama then
		p26:updateActiveBackground(p26.store:getState())
	end

	table.insert(p26.connections, NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 1018
		-- upvalues: p26 (copy)
		if p26.changeSceneTask then
			task.cancel(p26.changeSceneTask)
		end

		p26.changeSceneTask = task.spawn(function() -- line: 1023
			-- upvalues: p26 (copy)
			p26:pickScene()
		end)
	end))
	table.insert(p26.signals, Signals.createEffect(function(p31) -- line: 1031
		-- upvalues: PhotoboothStoreBridge (copy), p26 (copy)
		local v187 = PhotoboothStoreBridge.getStore()

		if not v187 then
			return
		end

		v187.getSelectedSceneId(p31)

		if p26.changeSceneTask then
			task.cancel(p26.changeSceneTask)
		end

		p26.changeSceneTask = task.spawn(function() -- line: 1044
			-- upvalues: p26 (copy)
			p26:pickScene()
		end)
	end))

	if FFlagEnableCoreContentTheme then
		table.insert(p26.connections, {
			disconnect = getSceneOverridesStore().subscribe(function(_) -- line: 1054
				-- upvalues: p26 (copy)
				p26:applyParticleColorOverrides()
			end)
		})
	end

	p26.ParticleEffectManager:start()
end
function t1.stop(p33) -- line: 1064
	-- upvalues: FFlagAXBackgroundCycloramaRendering (copy), ReplicatedStorage (copy), FFlagAXBackgroundsCycloramaVR (copy)
	for _, v161 in p33.connections do
		v161:disconnect()
	end

	for _, v163 in p33.signals do
		v163()
	end

	if FFlagAXBackgroundCycloramaRendering and p33.cyclorama then
		if p33.cycloramaFront then
			p33.cycloramaFront.Transparency = 1
		end

		if p33.cycloramaBack then
			p33.cycloramaBack.Transparency = 1
		end

		p33.cyclorama.Parent = ReplicatedStorage

		local cycloramaState = p33.cycloramaState

		if cycloramaState then
			cycloramaState.activeToken = cycloramaState.activeToken + 1
			cycloramaState.currentAssetId = nil
		end
	end

	if FFlagAXBackgroundsCycloramaVR and p33.isSpatial then
		p33.connections = {}
		p33.signals = {}

		return
	end

	if p33.currentScene then
		p33.currentScene.Parent = p33.scenesFolder
	end

	p33:restoreOriginalLighting()
	p33:clearManagedMaterialVariants()

	if p33.changeSceneTask then
		task.cancel(p33.changeSceneTask)
		p33.changeSceneTask = nil
	end

	p33.connections = {}
	p33.signals = {}
	p33.ParticleEffectManager:stop()
end
function t1.onDestroy(p34) -- line: 1116
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy)
	p34:stop()

	if FFlagAXBackgroundsCycloramaVR and p34.isSpatial then
		return
	end

	p34.ParticleEffectManager:onDestroy()
end
function t1.update(p35, _, _, p38, _) -- line: 1125
	-- upvalues: FFlagAXBackgroundsCycloramaVR (copy)
	if FFlagAXBackgroundsCycloramaVR and p35.isSpatial then
		return
	end

	p35.ParticleEffectManager:setAvatarRoute(p38)
end
function t1.updateAvatarRoute(p40, p41, p42) -- line: 1134
	p40.avatarRoute = p41

	local v174 = p40.store:getState()

	p40:update(v174, v174, p41, p42)
end

return t1
