game:DefineFastString("UGCValidationMaxAnimationLength", "10")

local GetFStringUGCValidationMaxAnimationLength = {}

function GetFStringUGCValidationMaxAnimationLength.asString()
	return game:GetFastString("UGCValidationMaxAnimationLength")
end

function GetFStringUGCValidationMaxAnimationLength.asNumber()
	return (tonumber(GetFStringUGCValidationMaxAnimationLength.asString()))
end

return GetFStringUGCValidationMaxAnimationLength
