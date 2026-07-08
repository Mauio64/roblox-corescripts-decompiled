local ParentParent = script.Parent.Parent
local getEngineUGCValidateTexturePackCPlusPlus = require(ParentParent.flags.getEngineUGCValidateTexturePackCPlusPlus)

game:DefineFastFlag("UGCValidateTexturePack", false)

return function() -- line: 7
	-- upvalues: getEngineUGCValidateTexturePackCPlusPlus (copy)
	return game:GetFastFlag("UGCValidateTexturePack") and getEngineUGCValidateTexturePackCPlusPlus()
end
