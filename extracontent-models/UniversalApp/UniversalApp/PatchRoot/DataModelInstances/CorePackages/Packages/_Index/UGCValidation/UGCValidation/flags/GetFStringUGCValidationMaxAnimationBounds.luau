game:DefineFastString("UGCValidationMaxAnimationBounds", "25")

local GetFStringUGCValidationMaxAnimationBounds = {}

function GetFStringUGCValidationMaxAnimationBounds.asString()
	return game:GetFastString("UGCValidationMaxAnimationBounds")
end

function GetFStringUGCValidationMaxAnimationBounds.asNumber()
	return (tonumber(GetFStringUGCValidationMaxAnimationBounds.asString()))
end

return GetFStringUGCValidationMaxAnimationBounds
