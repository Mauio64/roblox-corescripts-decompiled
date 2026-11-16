game:DefineFastString("UGCValidateMaxJointRotation", "180")

local GetFStringUGCValidateMaxJointRotation = {}

function GetFStringUGCValidateMaxJointRotation.asString()
	return game:GetFastString("UGCValidateMaxJointRotation")
end

function GetFStringUGCValidateMaxJointRotation.asNumber()
	return (tonumber(GetFStringUGCValidateMaxJointRotation.asString()))
end

return GetFStringUGCValidateMaxJointRotation
