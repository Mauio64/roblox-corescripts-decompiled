game:DefineFastString("UGCValidateMaxAnimationMovement", "0.3")

local GetFStringUGCValidateMaxAnimationMovement = {}

function GetFStringUGCValidateMaxAnimationMovement.asString()
	return game:GetFastString("UGCValidateMaxAnimationMovement")
end

function GetFStringUGCValidateMaxAnimationMovement.asNumber()
	return (tonumber(GetFStringUGCValidateMaxAnimationMovement.asString()))
end

return GetFStringUGCValidateMaxAnimationMovement
