local ParentParent = script.Parent.Parent
local getEngineFeatureUGCValidateHSRMeshIds = require(ParentParent.flags.getEngineFeatureUGCValidateHSRMeshIds)

game:DefineFastFlag("UGCValidateHSRMeshIdsLuaFlag", false)

return function() -- line: 7
	-- upvalues: getEngineFeatureUGCValidateHSRMeshIds (copy)
	return game:GetFastFlag("UGCValidateHSRMeshIdsLuaFlag") and getEngineFeatureUGCValidateHSRMeshIds()
end
