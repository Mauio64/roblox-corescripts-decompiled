game:DefineFastString("UGCValidateAllowedLegOverlapMultiplier", "0.25")

local GetFStringUGCValidateAllowedLegOverlapMultiplier = {}

function GetFStringUGCValidateAllowedLegOverlapMultiplier.asString()
	return game:GetFastString("UGCValidateAllowedLegOverlapMultiplier")
end

function GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()
	return (tonumber(GetFStringUGCValidateAllowedLegOverlapMultiplier.asString()))
end

return GetFStringUGCValidateAllowedLegOverlapMultiplier
