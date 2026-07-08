local ParentParent = script.Parent.Parent
local getEngineUGCValidateAssetTextureLimits = require(ParentParent.flags.getEngineUGCValidateAssetTextureLimits)

game:DefineFastFlag("UGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits", false)

return function() -- line: 7
	-- upvalues: getEngineUGCValidateAssetTextureLimits (copy)
	return getEngineUGCValidateAssetTextureLimits() and game:GetFastFlag("UGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits")
end
