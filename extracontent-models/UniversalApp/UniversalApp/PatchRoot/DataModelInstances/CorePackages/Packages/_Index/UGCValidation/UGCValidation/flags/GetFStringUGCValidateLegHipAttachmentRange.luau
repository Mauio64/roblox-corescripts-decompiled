game:DefineFastString("UGCValidateLegHipAttachmentRange", "0.25")

local GetFStringUGCValidateLegHipAttachmentRange = {}

function GetFStringUGCValidateLegHipAttachmentRange.asString()
	return game:GetFastString("UGCValidateLegHipAttachmentRange")
end

function GetFStringUGCValidateLegHipAttachmentRange.asNumber()
	return (tonumber(GetFStringUGCValidateLegHipAttachmentRange.asString()))
end

return GetFStringUGCValidateLegHipAttachmentRange
