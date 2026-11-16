local parent = script.Parent.Parent

local getEngineUGCValidateTexturePackCPlusPlus = require(parent.flags.getEngineUGCValidateTexturePackCPlusPlus)

game:DefineFastFlag("UGCValidateCheckTexturePackOwner", false)

return function()
	return game:GetFastFlag("UGCValidateCheckTexturePackOwner") and getEngineUGCValidateTexturePackCPlusPlus()
end
