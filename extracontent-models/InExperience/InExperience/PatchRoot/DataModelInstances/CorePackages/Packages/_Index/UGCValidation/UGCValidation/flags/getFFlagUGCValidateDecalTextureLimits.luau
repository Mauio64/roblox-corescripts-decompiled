local ParentParent = script.Parent.Parent
local getEngineUGCValidateAssetTextureLimits = require(ParentParent.flags.getEngineUGCValidateAssetTextureLimits)

game:DefineFastFlag("UGCValidateDecalTextureLimits", false)

return function() -- line: 7
	-- upvalues: getEngineUGCValidateAssetTextureLimits (copy)
	return getEngineUGCValidateAssetTextureLimits() and game:GetFastFlag("UGCValidateDecalTextureLimits")
end
