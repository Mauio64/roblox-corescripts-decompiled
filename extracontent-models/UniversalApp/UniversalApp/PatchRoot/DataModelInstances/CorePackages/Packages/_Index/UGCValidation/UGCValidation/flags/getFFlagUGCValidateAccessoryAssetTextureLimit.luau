local ParentParent = script.Parent.Parent
local getEngineUGCValidateAssetTextureLimits = require(ParentParent.flags.getEngineUGCValidateAssetTextureLimits)

game:DefineFastFlag("UGCValidateAccessoryAssetTextureLimit", false)

return function() -- line: 7
	-- upvalues: getEngineUGCValidateAssetTextureLimits (copy)
	return getEngineUGCValidateAssetTextureLimits() and game:GetFastFlag("UGCValidateAccessoryAssetTextureLimit")
end
