game:DefineFastString("UGCValidationMaxCageDistance", "0.3")

local GetFStringUGCValidationMaxCageDistance = {}

function GetFStringUGCValidationMaxCageDistance.asString()
	return game:GetFastString("UGCValidationMaxCageDistance")
end

function GetFStringUGCValidationMaxCageDistance.asNumber()
	return (tonumber(GetFStringUGCValidationMaxCageDistance.asString()))
end

return GetFStringUGCValidationMaxCageDistance
