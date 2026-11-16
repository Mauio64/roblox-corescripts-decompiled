local parent = script.Parent.Parent

local getEngineUGCValidateAssetTextureLimits = require(parent.flags.getEngineUGCValidateAssetTextureLimits)

game:DefineFastFlag("UGCValidateDecalTextureLimits", false)

return function()
	return getEngineUGCValidateAssetTextureLimits() and game:GetFastFlag("UGCValidateDecalTextureLimits")
end
