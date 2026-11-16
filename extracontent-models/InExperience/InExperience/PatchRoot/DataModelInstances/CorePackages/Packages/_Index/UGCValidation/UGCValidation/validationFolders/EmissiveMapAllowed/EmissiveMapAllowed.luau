local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateEmissiveMapAllowed = require(parent.flags.getFFlagUGCValidateEmissiveMapAllowed)
local getFFlagUGCValidateDecalBlockEmissives = require(parent.flags.getFFlagUGCValidateDecalBlockEmissives)

local EmissiveMapAllowed = {}

EmissiveMapAllowed.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH,
	ValidationEnums.UploadCategory.RIGID_ACCESSORY,
	ValidationEnums.UploadCategory.MAKEUP
}

EmissiveMapAllowed.requiredData = {
	ValidationEnums.SharedDataMember.consumerConfig,
	ValidationEnums.SharedDataMember.rootInstance
}

function EmissiveMapAllowed.fflag()
	return getFFlagUGCValidateEmissiveMapAllowed() or getFFlagUGCValidateDecalBlockEmissives()
end

EmissiveMapAllowed.expectedFailures = {}

local function hasEmissiveMask(p): boolean -- 2 equivalent calls inferred from this helper
	return p.EmissiveMaskContent.SourceType ~= Enum.ContentSourceType.None
end

local function isDecalEmissive(decal)
	local emissiveTint = decal.EmissiveTint

	return hasEmissiveMask(decal) -- inferred equivalent call
		or math.abs(decal.EmissiveStrength - 1) > 0.00001
		or math.abs(emissiveTint.R - 1) > 0.00001
		or math.abs(emissiveTint.G - 1) > 0.00001
		or math.abs(emissiveTint.B - 1) > 0.00001
end

local function reportEmissiveDecals(object, descendants)
	for _, decal in descendants do
		if decal:IsA("Decal") and isDecalEmissive(decal) then
			object:fail(ErrorSourceStrings.Keys.EmissiveMap_NotAllowedOnDecal, {
				InstancePath = decal:GetFullName()
			})
		end
	end
end

local function reportInExperienceEmissive(object, descendants, consumerConfig)
	if
		consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC
		and consumerConfig.backendConfigs.universeId == nil
	then
		return
	end

	for _, surfaceAppearance in descendants do
		if surfaceAppearance:IsA("SurfaceAppearance") and hasEmissiveMask(surfaceAppearance) then -- inferred equivalent call
			object:fail(ErrorSourceStrings.Keys.EmissiveMap_NotAllowedInExperience)
			break
		end
	end
end

function EmissiveMapAllowed.run(p, p2)
	local rootInstance = p2.rootInstance
	local descendants = rootInstance:GetDescendants()
	table.insert(descendants, rootInstance)

	if getFFlagUGCValidateDecalBlockEmissives() then
		reportEmissiveDecals(p, descendants)
	end

	if getFFlagUGCValidateEmissiveMapAllowed() then
		reportInExperienceEmissive(p, descendants, p2.consumerConfig)
	end
end

return EmissiveMapAllowed
