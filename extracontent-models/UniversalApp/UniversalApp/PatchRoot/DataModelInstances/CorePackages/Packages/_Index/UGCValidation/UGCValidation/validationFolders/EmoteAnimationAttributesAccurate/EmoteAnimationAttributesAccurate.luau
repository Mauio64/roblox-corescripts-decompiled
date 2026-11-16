local parent = script.Parent.Parent.Parent

local PublishService = game:GetService("PublishService")

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

game:DefineFastFlag("UGCValidateEmoteAttributes", false)

local EmoteIsUGCAttributeName = Constants.EmoteIsUGCAttributeName
local EmoteMaxPartTranslationAttributeName = Constants.EmoteMaxPartTranslationAttributeName

local function toFiniteNumber(attribute) -- 2 equivalent calls inferred from this helper
	if typeof(attribute) == "number" and attribute > -1e999 and attribute < 1e999 then
		return attribute
	end

	return nil
end

local EmoteAnimationAttributesAccurate = {}
EmoteAnimationAttributesAccurate.categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
EmoteAnimationAttributesAccurate.requiredData = {}
EmoteAnimationAttributesAccurate.conditionalData = { ValidationEnums.SharedDataMember.curveAnimations }

function EmoteAnimationAttributesAccurate.fflag()
	return game:GetFastFlag("UGCValidateEmoteAttributes") and game:GetEngineFeature("EngineTagEmoteMaxPartTranslation")
end

EmoteAnimationAttributesAccurate.expectedFailures = {}
EmoteAnimationAttributesAccurate.prereqTests = {}

function EmoteAnimationAttributesAccurate.run(object, p)
	for _, curveAnimation in p.curveAnimations do
		if curveAnimation:GetAttribute(EmoteIsUGCAttributeName) ~= true then
			object:fail(ErrorSourceStrings.Keys.EmoteAnimation_InvalidUGCAttribute)
			break
		end

		local finiteNumber = toFiniteNumber(curveAnimation:GetAttribute(EmoteMaxPartTranslationAttributeName)) -- inferred equivalent call

		if finiteNumber == nil then
			object:fail(ErrorSourceStrings.Keys.EmoteAnimation_InvalidMaxPartTranslationAttribute)
			break
		end

		local clone = curveAnimation:Clone()
		PublishService:TagEmoteAnimation(clone)
		local finiteNumber2 = toFiniteNumber(clone:GetAttribute(EmoteMaxPartTranslationAttributeName)) -- inferred equivalent call
		clone:Destroy()

		if finiteNumber2 == nil then
			object:fail(ErrorSourceStrings.Keys.EmoteAnimation_MaxPartTranslationCalcFailed)
			break
		end

		if math.abs(finiteNumber - finiteNumber2) > 0.00001 then
			object:fail(ErrorSourceStrings.Keys.EmoteAnimation_MaxPartTranslationMismatch, {
				taggedTranslation = tostring(finiteNumber),
				calculatedTranslation = tostring(finiteNumber2)
			})
			break
		end
	end
end

return EmoteAnimationAttributesAccurate
