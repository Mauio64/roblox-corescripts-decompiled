local t1 = {}
local Lighting = game:GetService("Lighting")
local ColorUtility = require(script.Parent.ColorUtility)
local VectorUtility = require(script.Parent.VectorUtility)

function t1.AddLight(t2: {[any]: any}, n1: number) -- line: 80
	local Part = Instance.new("Part")

	Part.Anchored = true
	Part.Transparency = 1
	Part.Shape = Enum.PartType.Ball
	Part.Color = t2.color
	Part.Name = "ThumbnailLightAnchor_" .. tostring(n1)
	Part.Parent = workspace

	local PointLight = Instance.new("PointLight")

	PointLight.Color = t2.color
	PointLight.Brightness = 3
	PointLight.Range = 10
	PointLight.Shadows = true
	PointLight.Name = "PointLight_" .. tostring(n1)
	PointLight.Parent = Part
	Part.Position = t2.worldPos
end
function t1.AddLightsFromExtraParams(t3: {[any]: any}?, cFrame: CFrame) -- line: 100
	-- upvalues: ColorUtility (copy), VectorUtility (copy), t1 (copy), Lighting (copy)
	local v11 = false
	local v12 = t3 and t3.pointLights

	if v12 then
		for i, v in ipairs(v12) do
			local t4 = {
				color = ColorUtility.Color3FromString(v.color),
				worldPos = cFrame * VectorUtility.Vector3FromJson(v.pos)
			}

			t1.AddLight(t4, i)
			v11 = true
		end
	end

	local v16 = t3 and t3.clockTime

	if v16 then
		Lighting.ClockTime = v16
		v11 = true
	end

	local v17 = t3 and t3.brightness

	if v17 then
		Lighting.Brightness = v17
		v11 = true
	end

	return v11
end
function t1.AddDefaultPointLightRelativeTo(cFrame: CFrame) -- line: 134
	-- upvalues: t1 (copy)
	local v19 = cFrame * Vector3.new(-5, 7, -5)
	local t5 = {
		color = Color3.new(1, 1, 1),
		worldPos = v19
	}

	t1.AddLight(t5, 0)
end
function t1.SetupSunlightWithJsonConfig(t6: {[any]: any}) -- line: 143
	-- upvalues: Lighting (copy)
	local v22 = t6 or {
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

	Lighting.Brightness = v22.brightness and tonumber(v22.brightness) or 1

	local v23 = v22.ambient and v22.ambient:split(",") or {
		"124",
		"124",
		"124"
	}

	Lighting.Ambient = Color3.fromRGB(tonumber(v23[1]), tonumber(v23[2]), (tonumber(v23[3])))

	local v24 = v22.colorShiftBottom and v22.colorShiftBottom:split(",") or {
		"108",
		"94",
		"66"
	}
	local v25 = v22.colorShiftTop and v22.colorShiftTop:split(",") or {
		"94",
		"100",
		"172"
	}

	Lighting.ColorShift_Bottom = Color3.fromRGB(tonumber(v24[1]), tonumber(v24[2]), (tonumber(v24[3])))
	Lighting.ColorShift_Top = Color3.fromRGB(tonumber(v25[1]), tonumber(v25[2]), (tonumber(v25[3])))
	Lighting.EnvironmentDiffuseScale = v22.environmentDiffuseScale and tonumber(v22.environmentDiffuseScale) or 0
	Lighting.EnvironmentSpecularScale = v22.environmentSpecularScale and tonumber(v22.environmentSpecularScale) or 1
	Lighting.GlobalShadows = not not v22.globalShadows and (v22.globalShadows == "true" or false)
	Lighting.ShadowSoftness = v22.shadowSoftness and tonumber(v22.shadowSoftness) or 0

	local v26 = v22.outdoorAmbient and v22.outdoorAmbient:split(",") or {
		"0",
		"0",
		"0"
	}

	Lighting.OutdoorAmbient = Color3.fromRGB(tonumber(v26[1]), tonumber(v26[2]), (tonumber(v26[3])))
	Lighting.ClockTime = v22.clockTime and tonumber(v22.clockTime) or 9.5
	Lighting.GeographicLatitude = v22.geographicLatitude and tonumber(v22.geographicLatitude) or 330
	Lighting.ExposureCompensation = v22.exposureCompensation and tonumber(v22.exposureCompensation) or 0
	Lighting.TimeOfDay = v22.timeOfDay or "09:30:00"
end
function t1.SetupSceneLight(t7: {[any]: any}, s1: string?) -- line: 190
	local v29 = t7 or {}
	local v30 = v29.lightType or "SpotLight"
	local v31 = s1 or v30
	local Part = Instance.new("Part")

	Part.Anchored = true
	Part.Transparency = 1
	Part.Size = v29.partSize or Vector3.new(4, 1, 2)
	Part.Shape = v29.partType or Enum.PartType.Block
	Part.Name = "ThumbnailLightAnchor_" .. tostring(v31)
	Part.Parent = workspace

	local v33 = Instance.new(v30)

	v33.Enabled = v29.enabled == nil or v29.enabled
	v33.Color = v29.color or Color3.fromRGB(255, 255, 255)
	v33.Brightness = v29.brightness or 10
	v33.Range = v29.range or 12
	v33.Angle = v29.angle or 30
	v33.Shadows = v29.shadows == nil or v29.shadows
	v33.Name = tostring(v31)
	v33.Parent = Part
	Part.CFrame = v29.partCFrame
end
function t1.SetupSpotLight(t8: {[any]: any}, s2: string?) -- line: 215
	-- upvalues: t1 (copy)
	local v36 = t8 or {}

	v36.lightType = "SpotLight"
	t1.SetupSceneLight(v36, s2)
end
function t1.SetupSpotLightsIn3PointLighting(t9: {[any]: any}) -- line: 225
	-- upvalues: t1 (copy)
	local v38 = t9 or {
		keyLight = {
			brightness = 11.2,
			range = 12,
			angle = 54,
			partCFrame = CFrame.new(2.219, 103.178, 4.675) * CFrame.Angles(30, 60, -90),
			color = Color3.fromRGB(218, 196, 144)
		},
		fillLight = {
			brightness = 1.6,
			range = 12,
			angle = 36,
			partCFrame = CFrame.new(3.554, 107.01, -1.036) * CFrame.Angles(-15, 90, -90),
			color = Color3.fromRGB(255, 255, 255)
		}
	}

	if v38.keyLight then
		t1.SetupSpotLight(v38.keyLight, "KeyLight")
	end

	if v38.fillLight then
		t1.SetupSpotLight(v38.fillLight, "FillLight")
	end
end
function t1.SetupSpotLightsIn3PointLightingWithJsonConfig(t10: {[any]: any}) -- line: 251
	-- upvalues: t1 (copy)
	local v40 = t10 or {
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
	local v41 = v40.rotation and tonumber(v40.rotation) or 105
	local cFrame = CFrame.Angles(0, math.rad(v41), 0)
	local v43 = v40.keyCFrame and v40.keyCFrame:split(",") or {
		"2.219",
		"103.178",
		"4.675",
		"30",
		"60",
		"-90"
	}
	local v44 = cFrame:ToWorldSpace(CFrame.new(tonumber(v43[1]) or 0, tonumber(v43[2]) or 0, tonumber(v43[3]) or 0) * CFrame.Angles(math.rad(tonumber(v43[4]) or 0), math.rad(tonumber(v43[5]) or 0), (math.rad(tonumber(v43[6]) or 0))))
	local v45 = v40.fillCFrame and v40.fillCFrame:split(",") or {
		"3.554",
		"107.01",
		"-1.036",
		"-15",
		"90",
		"-90"
	}
	local v46 = cFrame:ToWorldSpace(CFrame.new(tonumber(v45[1]) or 0, tonumber(v45[2]) or 0, tonumber(v45[3]) or 0) * CFrame.Angles(math.rad(tonumber(v45[4]) or 0), math.rad(tonumber(v45[5]) or 0), (math.rad(tonumber(v45[6]) or 0))))
	local v47 = v40.keyBrightness and tonumber(v40.keyBrightness) or 11.2
	local v48 = v40.keyRange and tonumber(v40.keyRange) or 12
	local v49 = v40.keyAngle and tonumber(v40.keyAngle) or 54
	local v50 = v40.keyColor and v40.keyColor:split(",") or {
		"218",
		"196",
		"144"
	}
	local v51 = v40.fillBrightness and tonumber(v40.fillBrightness) or 1.6
	local v52 = v40.fillRange and tonumber(v40.fillRange) or 12
	local v53 = v40.fillAngle and tonumber(v40.fillAngle) or 36
	local v54 = v40.fillColor and v40.fillColor:split(",") or {
		"255",
		"255",
		"255"
	}

	t1.SetupSpotLightsIn3PointLighting({
		keyLight = {
			partCFrame = v44,
			color = Color3.fromRGB(tonumber(v50[1]), tonumber(v50[2]), (tonumber(v50[3]))),
			brightness = v47,
			range = v48,
			angle = v49
		},
		fillLight = {
			partCFrame = v46,
			color = Color3.fromRGB(tonumber(v54[1]), tonumber(v54[2]), (tonumber(v54[3]))),
			brightness = v51,
			range = v52,
			angle = v53
		}
	})
end

return t1
