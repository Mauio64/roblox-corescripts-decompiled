game:DefineFastString("UGCValidationMaxAnimationDeltas", "1.5")

local GetFStringUGCValidationMaxAnimationDeltas = {}

function GetFStringUGCValidationMaxAnimationDeltas.asString()
	return game:GetFastString("UGCValidationMaxAnimationDeltas")
end

function GetFStringUGCValidationMaxAnimationDeltas.asNumber()
	return (tonumber(GetFStringUGCValidationMaxAnimationDeltas.asString()))
end

return GetFStringUGCValidationMaxAnimationDeltas
