local Lighting = game:GetService("Lighting")
local Parent = script:FindFirstAncestor("SceneManagement").Parent
local Object = require(Parent.LuauPolyfill).Object
local t1 = {
	BloomEnabled = false,
	ColorCorrectionEnabled = false,
	LightingConfig = {
		Brightness = 1,
		ClockTime = 12,
		GeographicLatitude = 41.733,
		TimeOfDay = "12:00:00",
		FogEnd = 92,
		FogStart = 20,
		ColorShift_Bottom = Color3.fromRGB(232, 255, 146),
		ColorShift_Top = Color3.fromRGB(85, 136, 167),
		OutdoorAmbient = Color3.fromRGB(0, 0, 0),
		Ambient = Color3.fromRGB(170, 170, 170),
		FogColor = Color3.fromRGB(45, 46, 49)
	},
	SkyConfig = {
		CelestialBodiesShown = false,
		StarCount = 0,
		SkyboxAssetLocation = "rbxasset://textures/ui/AvatarExperience/AvatarExperienceSkyboxDarkTheme.png"
	},
	BloomConfig = {
		Intensity = 0.3,
		Size = 12,
		Threshold = 0.95
	},
	ColorCorrectionConfig = {
		Brightness = 0,
		Contrast = 0,
		Saturation = 0
	}
}

local function configureLighting(t2: {[any]: any}?) -- line: 81
	-- upvalues: Object (copy), t1 (copy), Lighting (copy)
	local v15 = Object.assign({}, t1.LightingConfig, t2 or {})

	Lighting.Brightness = v15.Brightness
	Lighting.ColorShift_Bottom = v15.ColorShift_Bottom
	Lighting.ColorShift_Top = v15.ColorShift_Top
	Lighting.OutdoorAmbient = v15.OutdoorAmbient
	Lighting.Ambient = v15.Ambient
	Lighting.ClockTime = v15.ClockTime
	Lighting.GeographicLatitude = v15.GeographicLatitude
	Lighting.TimeOfDay = v15.TimeOfDay
	Lighting.FogColor = v15.FogColor
	Lighting.FogEnd = v15.FogEnd
	Lighting.FogStart = v15.FogStart
end
local function getOrCreateSky() -- line: 96
	-- upvalues: Lighting (copy)
	local Sky = Lighting:FindFirstChild("Sky")

	if Sky == nil then
		Sky = Instance.new("Sky")
		Sky.Parent = Lighting
	end

	return Sky
end
local function configureSky(p1, t3: {[any]: any}?) -- line: 105
	-- upvalues: Object (copy), t1 (copy)
	local v19 = Object.assign({}, t1.SkyConfig, t3 or {})

	p1.CelestialBodiesShown = v19.CelestialBodiesShown
	p1.StarCount = v19.StarCount
	p1.SkyboxBk = v19.SkyboxAssetLocation
	p1.SkyboxDn = v19.SkyboxAssetLocation
	p1.SkyboxFt = v19.SkyboxAssetLocation
	p1.SkyboxLf = v19.SkyboxAssetLocation
	p1.SkyboxRt = v19.SkyboxAssetLocation
	p1.SkyboxUp = v19.SkyboxAssetLocation
end
local function getBloom() -- line: 117
	-- upvalues: Lighting (copy)
	return (Lighting:FindFirstChild("Bloom"))
end
local function getOrCreateBloom() -- line: 121
	-- upvalues: Lighting (copy)
	local Bloom = Lighting:FindFirstChild("Bloom")

	if Bloom == nil then
		Bloom = Instance.new("BloomEffect")
		Bloom.Parent = Lighting
	end

	return Bloom
end
local function configureBloom(p2, t4: {[any]: any}?) -- line: 130
	-- upvalues: Object (copy), t1 (copy)
	local v23 = Object.assign({}, t1.BloomConfig, t4 or {})

	p2.Enabled = true
	p2.Intensity = v23.Intensity
	p2.Size = v23.Size
	p2.Threshold = v23.Threshold
end
local function getColorCorrection() -- line: 138
	-- upvalues: Lighting (copy)
	return (Lighting:FindFirstChild("ColorCorrection"))
end
local function getOrCreateColorCorrection() -- line: 142
	-- upvalues: Lighting (copy)
	local ColorCorrection = Lighting:FindFirstChild("ColorCorrection")

	if ColorCorrection == nil then
		ColorCorrection = Instance.new("ColorCorrectionEffect")
		ColorCorrection.Parent = Lighting
	end

	return ColorCorrection
end
local function configureColorCorrection(p3, t5: {[any]: any}?) -- line: 151
	-- upvalues: Object (copy), t1 (copy)
	local v27 = Object.assign({}, t1.ColorCorrectionConfig, t5 or {})

	p3.Enabled = true
	p3.Brightness = v27.Brightness
	p3.Contrast = v27.Contrast
	p3.Saturation = v27.Saturation
end

return {
	configure = function(t6: {[any]: any}?) -- line: 162
		-- upvalues: t1 (copy), configureLighting (copy), Lighting (copy), configureSky (copy), configureBloom (copy), configureColorCorrection (copy)
		local v29 = t1.BloomEnabled or not not t6 and (t6.BloomEnabled or false)
		local v30 = t1.ColorCorrectionEnabled or not not t6 and (t6.ColorCorrectionEnabled or false)
		local v31 = if not t6 then nil else t6.LightingConfig
		local v32 = if not t6 then nil else t6.SkyConfig
		local v33 = if not t6 then nil else t6.BloomConfig
		local v34 = if not t6 then nil else t6.ColorCorrectionConfig

		configureLighting(v31)

		local Sky = Lighting:FindFirstChild("Sky")

		if Sky == nil then
			Sky = Instance.new("Sky")
			Sky.Parent = Lighting
		end

		configureSky(Sky, v32)

		if v29 then
			local Bloom = Lighting:FindFirstChild("Bloom")

			if Bloom == nil then
				Bloom = Instance.new("BloomEffect")
				Bloom.Parent = Lighting
			end

			configureBloom(Bloom, v33)
		else
			local Bloom = Lighting:FindFirstChild("Bloom")

			if Bloom ~= nil then
				Bloom.Enabled = false
			end
		end

		if v30 then
			local ColorCorrection = Lighting:FindFirstChild("ColorCorrection")

			if ColorCorrection == nil then
				ColorCorrection = Instance.new("ColorCorrectionEffect")
				ColorCorrection.Parent = Lighting
			end

			configureColorCorrection(ColorCorrection, v34)

			return
		end

		local ColorCorrection = Lighting:FindFirstChild("ColorCorrection")

		if ColorCorrection ~= nil then
			ColorCorrection.Enabled = false
		end
	end
}
