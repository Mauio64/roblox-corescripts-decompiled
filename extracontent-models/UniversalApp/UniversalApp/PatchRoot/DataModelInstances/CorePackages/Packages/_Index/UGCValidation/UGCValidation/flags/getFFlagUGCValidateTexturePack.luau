local parent = script.Parent.Parent

local getEngineUGCValidateTexturePackCPlusPlus = require(parent.flags.getEngineUGCValidateTexturePackCPlusPlus)

game:DefineFastFlag("UGCValidateTexturePack", false)

return function()
	return game:GetFastFlag("UGCValidateTexturePack") and getEngineUGCValidateTexturePackCPlusPlus()
end
