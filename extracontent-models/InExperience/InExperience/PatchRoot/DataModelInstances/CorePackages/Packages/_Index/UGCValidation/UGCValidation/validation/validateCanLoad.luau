local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

require(parent.util.Types)

local function validateCanLoad(p: string, p2)
	local success, result = pcall(function()
		return UGCValidationService:CanLoadAsset(p)
	end)

	if success and result then
		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateCanLoad, nil, p2)
	return false, { "Asset could not be loaded" }
end

return validateCanLoad
