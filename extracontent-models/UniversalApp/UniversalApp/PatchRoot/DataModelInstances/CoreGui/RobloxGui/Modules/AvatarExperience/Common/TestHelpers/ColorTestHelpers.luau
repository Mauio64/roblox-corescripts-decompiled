local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DefaultBodyColorRanges = require(Modules.AvatarExperience.AvatarEditor.Reducers.DefaultBodyColorRanges)
local SetDefaultBodyColorRanges = require(Modules.AvatarExperience.AvatarEditor.Actions.SetDefaultBodyColorRanges)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)

require(Modules.AvatarExperience.Common.Types)

local t1 = {
	RawBodyColorRanges = {
		{
			Color3.fromRGB(255, 0, 0),
			Color3.fromRGB(255, 50, 50),
			Color3.fromRGB(255, 100, 100)
		},
		{
			Color3.fromRGB(0, 255, 0),
			Color3.fromRGB(50, 255, 50),
			Color3.fromRGB(100, 255, 100)
		},
		{
			Color3.fromRGB(0, 0, 255),
			Color3.fromRGB(50, 50, 255),
			Color3.fromRGB(100, 100, 255)
		},
		{
			Color3.fromHex("0f0f0f"),
			Color3.fromHex("888888"),
			Color3.fromHex("e0e0e0")
		}
	}
}

t1.DefaultBodyColorRanges = DefaultBodyColorRanges(nil, SetDefaultBodyColorRanges(t1.RawBodyColorRanges))
t1.ExpectedColorData = {
	range_red_100 = {
		sliderValue = 1,
		rangeId = "ff0000",
		color3 = Color3.fromRGB(255, 100, 100)
	},
	range_red_050 = {
		sliderValue = 0.5,
		rangeId = "ff0000",
		color3 = Color3.fromRGB(255, 50, 50)
	},
	range_red_025 = {
		sliderValue = 0.25,
		rangeId = "ff0000",
		color3 = Color3.fromRGB(255, 25, 25)
	},
	range_green_050 = {
		sliderValue = 0.5,
		rangeId = "00ff00",
		color3 = Color3.fromRGB(50, 255, 50)
	},
	range_green_075 = {
		sliderValue = 0.75,
		rangeId = "00ff00",
		color3 = Color3.fromRGB(75, 255, 75)
	},
	range_blue_000 = {
		sliderValue = 0,
		rangeId = "0000ff",
		color3 = Color3.fromRGB(0, 0, 255)
	},
	range_white = {
		rangeId = "0f0f0f",
		sliderValue = 1,
		color3 = Color3.fromRGB(255, 255, 255)
	},
	range_black = {
		rangeId = "0f0f0f",
		sliderValue = 0,
		color3 = Color3.fromRGB(0, 0, 0)
	}
}
t1.VariedBodyColorDatas = {
	headColor3 = t1.ExpectedColorData.range_red_100,
	torsoColor3 = t1.ExpectedColorData.range_green_075,
	rightLegColor3 = t1.ExpectedColorData.range_blue_000,
	leftLegColor3 = t1.ExpectedColorData.range_red_025,
	rightArmColor3 = t1.ExpectedColorData.range_white,
	leftArmColor3 = t1.ExpectedColorData.range_black
}
t1.VariedBodyColor3s = {}

for v6, v7 in t1.VariedBodyColorDatas do
	t1.VariedBodyColor3s[v6] = v7.color3
end

function t1.makeBodyColor3s(p1) -- line: 107
	-- upvalues: Constants (copy)
	local t2 = {}

	for _, v11 in Constants.allBodyPartForSkinColoringIds do
		t2[v11] = p1.color3
	end

	return t2
end
function t1.makeBodyPartRangeIds(p2) -- line: 115
	-- upvalues: Constants (copy)
	local t3 = {}

	for _, v15 in Constants.allBodyPartForSkinColoringIds do
		t3[v15] = p2.rangeId
	end

	return t3
end
function t1.makeRangeIdToBodyPartsToSliderAndColor3Values(p3) -- line: 123
	-- upvalues: Constants (copy)
	local t4 = {}

	for _, v19 in Constants.allBodyPartForSkinColoringIds do
		local color3 = p3.color3
		local rangeId = p3.rangeId
		local sliderValue = p3.sliderValue
		local v23 = t4[rangeId] or {}

		v23[v19] = {
			sliderValue = sliderValue,
			color3 = color3
		}
		t4[rangeId] = v23
	end

	return t4
end

return t1
