local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(parent.util.BoundsCalculator)

local getFFlagUGCValidateNoMeshBelowFeet = require(parent.flags.getFFlagUGCValidateNoMeshBelowFeet)

game:DefineFastString("UGCValidateMaxMeshBelowFeet", "0.1")

local NoMeshBelowFeet = {}

NoMeshBelowFeet.categories = { ValidationEnums.UploadCategory.FULL_BODY }

NoMeshBelowFeet.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.renderMeshesData
}
NoMeshBelowFeet.fflag = getFFlagUGCValidateNoMeshBelowFeet
NoMeshBelowFeet.expectedFailures = {}

local v = {
	Constants.NAMED_R15_BODY_PARTS.LeftUpperLeg,
	Constants.NAMED_R15_BODY_PARTS.LeftLowerLeg,
	Constants.NAMED_R15_BODY_PARTS.LeftFoot,
	Constants.NAMED_R15_BODY_PARTS.RightUpperLeg,
	Constants.NAMED_R15_BODY_PARTS.RightLowerLeg,
	Constants.NAMED_R15_BODY_PARTS.RightFoot
}

local v2 = {
	Constants.NAMED_R15_BODY_PARTS.Head,
	Constants.NAMED_R15_BODY_PARTS.UpperTorso,
	Constants.NAMED_R15_BODY_PARTS.LowerTorso,
	Constants.NAMED_R15_BODY_PARTS.LeftUpperArm,
	Constants.NAMED_R15_BODY_PARTS.LeftLowerArm,
	Constants.NAMED_R15_BODY_PARTS.LeftHand,
	Constants.NAMED_R15_BODY_PARTS.RightUpperArm,
	Constants.NAMED_R15_BODY_PARTS.RightLowerArm,
	Constants.NAMED_R15_BODY_PARTS.RightHand
}

local function getMeshBottom(p, p2: string) -- 2 equivalent calls inferred from this helper
	local v3 = p[p2]
	local minMeshCorner = v3 and v3.boundsData.minMeshCorner
	return if minMeshCorner then minMeshCorner.Y else nil
end

function NoMeshBelowFeet.run(object, p)
	local partsByName = {}

	for _, part in p.rootInstance:GetChildren() do
		if part:IsA("MeshPart") then
			partsByName[part.Name] = part
		end
	end

	local individualFullBodyPartsDataFromData, _, v3 = BoundsCalculator.calculateIndividualFullBodyPartsDataFromData(
		partsByName,
		p.renderMeshesData
	)

	if not individualFullBodyPartsDataFromData then
		object:fetchError("Failed to calculate full body part bounds")
		return
	end

	local v4 = nil

	for _, v5 in v do
		local meshBottom = getMeshBottom(v3, v5) -- inferred equivalent call

		if meshBottom and (v4 == nil or meshBottom < v4) then
			v4 = meshBottom
		end
	end

	if v4 == nil then
		return
	end

	local fastString = tonumber(game:GetFastString("UGCValidateMaxMeshBelowFeet"))

	for _, partName in v2 do
		local meshBottom = getMeshBottom(v3, partName) -- inferred equivalent call

		if meshBottom == nil then
			continue
		end

		local v5 = v4 - meshBottom

		if fastString < v5 then
			object:fail(
				ErrorSourceStrings.Keys.NoMeshBelowFeet_PartBelowFeet,
				{
					partName = partName,
					distance = string.format("%.2f", v5),
					maxDistance = string.format("%.2f", fastString)
				},
				partsByName[partName]
			)
		end
	end
end

return NoMeshBelowFeet
