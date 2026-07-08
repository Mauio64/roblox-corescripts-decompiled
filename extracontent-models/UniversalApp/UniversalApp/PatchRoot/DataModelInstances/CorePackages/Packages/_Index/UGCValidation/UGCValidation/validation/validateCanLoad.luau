local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function validateCanLoad(s1: string, p1) -- line: 9
	-- upvalues: UGCValidationService (copy), Analytics (copy)
	local ok, result = pcall(function() -- line: 10
		-- upvalues: UGCValidationService (copy), s1 (copy)
		return UGCValidationService:CanLoadAsset(s1)
	end)

	if not ok or not result then
		Analytics.reportFailure(Analytics.ErrorType.validateCanLoad, nil, p1)

		return false, { "Asset could not be loaded" }
	end

	return true
end

return validateCanLoad
