local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateCurveAnimAttributes = require(parent.flags.getFFlagUGCValidateCurveAnimAttributes)
local getFFlagUGCValidateMakeupCategoryParity = require(parent.flags.getFFlagUGCValidateMakeupCategoryParity)
local getFFlagUGCValidateR15FixedAttributes = require(parent.flags.getFFlagUGCValidateR15FixedAttributes)

game:DefineFastFlag("UGCValidateAllowEmoteAttributes", false)

local set = {
	[Constants.EmoteIsUGCAttributeName] = true,
	[Constants.EmoteMaxPartTranslationAttributeName] = true
}
local categories

if getFFlagUGCValidateMakeupCategoryParity() then
	categories = Constants.AllAssetUploadCategories
else
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup
end

local AttributesAllowed = {}
AttributesAllowed.categories = categories
AttributesAllowed.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.consumerConfig,
	ValidationEnums.SharedDataMember.hsrAssets
}

if getFFlagUGCValidateCurveAnimAttributes() then
	table.insert(AttributesAllowed.requiredData, ValidationEnums.SharedDataMember.curveAnimations)
end

AttributesAllowed.expectedFailures = {}

local function hasOnlyAllowedAttribute(attributes, flag: boolean, p): boolean
	for k, item in attributes do
		if not (not flag or k ~= Constants.AlternateMeshIdAttributeName) or p and p[k] then
			continue
		end

		if
			k ~= Constants.GUIDAttributeName
			or typeof(item) ~= "string"
			or string.len(item) > Constants.GUIDAttributeMaxLength
		then
			return false
		end
	end

	return true
end

local function reportInstanceWithDisallowedAttributes(object, instance) -- 2 equivalent calls inferred from this helper
	object:fail(ErrorSourceStrings.Keys.NoAttributes, {
		RootInstanceName = instance.Name,
		InstanceNameList = instance:GetFullName()
	})
end

local function walkInstanceTree(object, folder, flag: boolean, p)
	if not hasOnlyAllowedAttribute(folder:GetAttributes(), flag, p) then
		reportInstanceWithDisallowedAttributes(object, folder) -- inferred equivalent call
	end

	for _, descendant in folder:GetDescendants() do
		if
			flag and descendant:GetAttribute(Constants.AlternateMeshIdAttributeName)
			or next(descendant:GetAttributes()) == nil
		then
			continue
		end

		reportInstanceWithDisallowedAttributes(object, descendant) -- inferred equivalent call
	end
end

function AttributesAllowed.run(p, data)
	local v = data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC

	walkInstanceTree(p, data.rootInstance, v)

	if
		getFFlagUGCValidateR15FixedAttributes()
		and data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
		and data.r15LegacyDuplicateRoot ~= nil
	then
		walkInstanceTree(p, data.r15LegacyDuplicateRoot, v)
	end

	for _, hsrAsset in data.hsrAssets do
		for _, v2 in hsrAsset do
			walkInstanceTree(p, v2, v)
		end
	end

	if getFFlagUGCValidateCurveAnimAttributes() then
		local v2

		if
			game:GetFastFlag("UGCValidateAllowEmoteAttributes")
			and data.uploadCategory == ValidationEnums.UploadCategory.EMOTE_ANIMATION
		then
			v2 = set
		end

		for _, curveAnimation in data.curveAnimations do
			walkInstanceTree(p, curveAnimation, v, v2)
		end
	end
end

return AttributesAllowed
