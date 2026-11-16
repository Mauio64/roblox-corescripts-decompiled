game:DefineFastString("UGCValidateAnimationHeightTol", "-3.1")

local GetFStringUGCValidateAnimationHeightTol = {}

function GetFStringUGCValidateAnimationHeightTol.asString()
	return game:GetFastString("UGCValidateAnimationHeightTol")
end

function GetFStringUGCValidateAnimationHeightTol.asNumber()
	return (tonumber(GetFStringUGCValidateAnimationHeightTol.asString()))
end

return GetFStringUGCValidateAnimationHeightTol
