local LightUtility = {}

local Lighting = game:GetService("Lighting")

local ColorUtility = require(script.Parent.ColorUtility)
local VectorUtility = require(script.Parent.VectorUtility)

function LightUtility.AddLight(p, p2: number)
	local part = Instance.new("Part")
	part.Anchored = true
	part.Transparency = 1
	part.Shape = Enum.PartType.Ball
	part.Color = p.color
	part.Name = "ThumbnailLightAnchor_" .. tostring(p2)
	part.Parent = workspace

	local pointLight = Instance.new("PointLight")
	pointLight.Color = p.color
	pointLight.Brightness = 3
	pointLight.Range = 10
	pointLight.Shadows = true
	pointLight.Name = "PointLight_" .. tostring(p2)
	pointLight.Parent = part

	part.Position = p.worldPos
end

function LightUtility.AddLightsFromExtraParams(data, cframe: CFrame)
	local v = false
	local pointLights = data and data.pointLights

	if pointLights then
		for i, pointLight in ipairs(pointLights) do
			local v2 = {
				color = ColorUtility.Color3FromString(pointLight.color),
				worldPos = cframe * VectorUtility.Vector3FromJson(pointLight.pos)
			}

			LightUtility.AddLight(v2, i)
			v = true
		end
	end

	local clockTime = data and data.clockTime

	if clockTime then
		Lighting.ClockTime = clockTime
		v = true
	end

	local brightness = data and data.brightness

	if brightness then
		Lighting.Brightness = brightness
		return true
	end

	return v
end

function LightUtility.AddDefaultPointLightRelativeTo(cframe: CFrame)
	local worldPos = cframe * Vector3.new(-5, 7, -5)
	local v = { color = Color3.new(1, 1, 1), worldPos = worldPos }

	LightUtility.AddLight(v, 0)
end

function LightUtility.SetupSunlightWithJsonConfig(p)
	local v = p or {
		brightness = "1",
		ambient = "124,124,124",
		colorShiftBottom = "108,94,66",
		colorShiftTop = "94,100,172",
		environmentDiffuseScale = "0",
		environmentSpecularScale = "1",
		globalShadows = "true",
		shadowSoftness = "0",
		outdoorAmbient = "0,0,0",
		clockTime = "9.5",
		geographicLatitude = "330",
		exposureCompensation = "0",
		timeOfDay = "09:30:00"
	}

	Lighting.Brightness = v.brightness and tonumber(v.brightness) or 1

	local v2 = v.ambient and v.ambient:split(",") or { "124", "124", "124" }
	Lighting.Ambient = Color3.fromRGB(tonumber(v2[1]), tonumber(v2[2]), (tonumber(v2[3])))

	local v3 = v.colorShiftBottom and v.colorShiftBottom:split(",") or { "108", "94", "66" }
	local v4 = v.colorShiftTop and v.colorShiftTop:split(",") or { "94", "100", "172" }
	Lighting.ColorShift_Bottom = Color3.fromRGB(tonumber(v3[1]), tonumber(v3[2]), (tonumber(v3[3])))
	Lighting.ColorShift_Top = Color3.fromRGB(tonumber(v4[1]), tonumber(v4[2]), (tonumber(v4[3])))

	Lighting.EnvironmentDiffuseScale = v.environmentDiffuseScale and tonumber(v.environmentDiffuseScale) or 0
	Lighting.EnvironmentSpecularScale = v.environmentSpecularScale and tonumber(v.environmentSpecularScale) or 1

	Lighting.GlobalShadows = v.globalShadows and v.globalShadows == "true" and true or false
	Lighting.ShadowSoftness = v.shadowSoftness and tonumber(v.shadowSoftness) or 0

	local v5 = v.outdoorAmbient and v.outdoorAmbient:split(",") or { "0", "0", "0" }
	Lighting.OutdoorAmbient = Color3.fromRGB(tonumber(v5[1]), tonumber(v5[2]), (tonumber(v5[3])))
	Lighting.ClockTime = v.clockTime and tonumber(v.clockTime) or 9.5
	Lighting.GeographicLatitude = v.geographicLatitude and tonumber(v.geographicLatitude) or 330
	Lighting.ExposureCompensation = v.exposureCompensation and tonumber(v.exposureCompensation) or 0
	Lighting.TimeOfDay = v.timeOfDay or "09:30:00"
end

function LightUtility.SetupSceneLight(options, p: string?)
	local v = options or {}
	local lightType = v.lightType or "SpotLight"
	p = p or lightType
	local part = Instance.new("Part")
	part.Anchored = true
	part.Transparency = 1
	part.Size = v.partSize or Vector3.new(4, 1, 2)
	part.Shape = v.partType or Enum.PartType.Block
	part.Name = "ThumbnailLightAnchor_" .. tostring(p)
	part.Parent = workspace

	local instance = Instance.new(lightType)
	instance.Enabled = v.enabled == nil or v.enabled
	instance.Color = v.color or Color3.fromRGB(255, 255, 255)
	instance.Brightness = v.brightness or 10
	instance.Range = v.range or 12
	instance.Angle = v.angle or 30
	instance.Shadows = v.shadows == nil or v.shadows
	instance.Name = tostring(p)
	instance.Parent = part

	part.CFrame = v.partCFrame
end

function LightUtility.SetupSpotLight(options, p: string?)
	local v = options or {}
	v.lightType = "SpotLight"
	LightUtility.SetupSceneLight(v, p)
end

function LightUtility.SetupSpotLightsIn3PointLighting(p)
	local v = p or {
		keyLight = {
			partCFrame = CFrame.new(2.219, 103.178, 4.675) * CFrame.Angles(30, 60, -90),
			color = Color3.fromRGB(218, 196, 144),
			brightness = 11.2,
			range = 12,
			angle = 54
		},
		fillLight = {
			partCFrame = CFrame.new(3.554, 107.01, -1.036) * CFrame.Angles(-15, 90, -90),
			color = Color3.fromRGB(255, 255, 255),
			brightness = 1.6,
			range = 12,
			angle = 36
		}
	}

	if v.keyLight then
		LightUtility.SetupSpotLight(v.keyLight, "KeyLight")
	end

	if v.fillLight then
		LightUtility.SetupSpotLight(v.fillLight, "FillLight")
	end
end

function LightUtility.SetupSpotLightsIn3PointLightingWithJsonConfig(p)
	local v = p or {
		rotation = "105",
		keyCFrame = "2.219,103.178,4.675,30,60,-90",
		keyBrightness = "11.2",
		keyRange = "12",
		keyAngle = "54",
		keyColor = "218,196,144",
		fillCFrame = "3.554,107.01,-1.036,-15,90,-90",
		fillBrightness = "1.6",
		fillRange = "12",
		fillAngle = "36",
		fillColor = "255,255,255"
	}

	local rotation = v.rotation and tonumber(v.rotation) or 105
	local cframe = CFrame.Angles(0, math.rad(rotation), 0)

	local v2 = v.keyCFrame and v.keyCFrame:split(",") or {
		"2.219",
		"103.178",
		"4.675",
		"30",
		"60",
		"-90"
	}
	local worldSpace = cframe:ToWorldSpace(CFrame.new(tonumber(v2[1]) or 0, tonumber(v2[2]) or 0, tonumber(v2[3]) or 0) * CFrame.Angles(
		math.rad(tonumber(v2[4]) or 0),
		math.rad(tonumber(v2[5]) or 0),
		(math.rad(tonumber(v2[6]) or 0))
	))

	local v3 = v.fillCFrame and v.fillCFrame:split(",") or {
		"3.554",
		"107.01",
		"-1.036",
		"-15",
		"90",
		"-90"
	}
	local worldSpace2 = cframe:ToWorldSpace(CFrame.new(tonumber(v3[1]) or 0, tonumber(v3[2]) or 0, tonumber(v3[3]) or 0) * CFrame.Angles(
		math.rad(tonumber(v3[4]) or 0),
		math.rad(tonumber(v3[5]) or 0),
		(math.rad(tonumber(v3[6]) or 0))
	))

	local keyBrightness = v.keyBrightness and tonumber(v.keyBrightness) or 11.2
	local keyRange = v.keyRange and tonumber(v.keyRange) or 12
	local keyAngle = v.keyAngle and tonumber(v.keyAngle) or 54
	local v4 = v.keyColor and v.keyColor:split(",") or { "218", "196", "144" }

	local fillBrightness = v.fillBrightness and tonumber(v.fillBrightness) or 1.6
	local fillRange = v.fillRange and tonumber(v.fillRange) or 12
	local fillAngle = v.fillAngle and tonumber(v.fillAngle) or 36
	local v5 = v.fillColor and v.fillColor:split(",") or { "255", "255", "255" }

	LightUtility.SetupSpotLightsIn3PointLighting({
		keyLight = {
			partCFrame = worldSpace,
			color = Color3.fromRGB(tonumber(v4[1]), tonumber(v4[2]), (tonumber(v4[3]))),
			brightness = keyBrightness,
			range = keyRange,
			angle = keyAngle
		},
		fillLight = {
			partCFrame = worldSpace2,
			color = Color3.fromRGB(tonumber(v5[1]), tonumber(v5[2]), (tonumber(v5[3]))),
			brightness = fillBrightness,
			range = fillRange,
			angle = fillAngle
		}
	})
end

return LightUtility
