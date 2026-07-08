local ParentParent = script.Parent.Parent
local getEngineUGCValidateTexturePackCPlusPlus = require(ParentParent.flags.getEngineUGCValidateTexturePackCPlusPlus)

game:DefineFastFlag("UGCValidateCheckTexturePackOwner", false)

return function() -- line: 7
	-- upvalues: getEngineUGCValidateTexturePackCPlusPlus (copy)
	return game:GetFastFlag("UGCValidateCheckTexturePackOwner") and getEngineUGCValidateTexturePackCPlusPlus()
end
