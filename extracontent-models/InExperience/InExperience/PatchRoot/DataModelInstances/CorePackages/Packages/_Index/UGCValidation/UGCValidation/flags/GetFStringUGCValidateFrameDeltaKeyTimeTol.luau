game:DefineFastString("UGCValidateFrameDeltaKeyTimeTol", "0.85")

local GetFStringUGCValidateFrameDeltaKeyTimeTol = {}

function GetFStringUGCValidateFrameDeltaKeyTimeTol.asString()
	return game:GetFastString("UGCValidateFrameDeltaKeyTimeTol")
end

function GetFStringUGCValidateFrameDeltaKeyTimeTol.asNumber()
	return (tonumber(GetFStringUGCValidateFrameDeltaKeyTimeTol.asString()))
end

return GetFStringUGCValidateFrameDeltaKeyTimeTol
