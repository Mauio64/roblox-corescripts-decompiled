game:DefineFastString("UGCValidateCurveAnimationMinLength", "0")

local GetFStringUGCValidateCurveAnimationMinLength = {}

function GetFStringUGCValidateCurveAnimationMinLength.asString()
	return game:GetFastString("UGCValidateCurveAnimationMinLength")
end

function GetFStringUGCValidateCurveAnimationMinLength.asNumber()
	return (tonumber(GetFStringUGCValidateCurveAnimationMinLength.asString()))
end

return GetFStringUGCValidateCurveAnimationMinLength
