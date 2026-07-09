local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local IXPService = game:GetService("IXPService")
local useUserExperiment = require(ParentParentParent.RoactAppExperiment).useUserExperiment
local FStringPVCIAfterSignupLayer = require(ParentParent.Flags.FStringPVCIAfterSignupLayer)
local FStringPVCIAfterSignupVariantKey = require(ParentParent.Flags.FStringPVCIAfterSignupVariantKey)

local function v7(p1) -- line: 12
	-- upvalues: FStringPVCIAfterSignupLayer (copy), FStringPVCIAfterSignupVariantKey (copy)
	return (p1[FStringPVCIAfterSignupLayer] or {})[FStringPVCIAfterSignupVariantKey]
end

return {
	usePVAndCIAfterSignupVariant = function(t1: {[any]: any}) -- line: 18
		-- upvalues: useUserExperiment (copy), FStringPVCIAfterSignupLayer (copy), v7 (copy)
		local v10 = t1 or {
			isExposureEnabled = false
		}

		return (useUserExperiment({ FStringPVCIAfterSignupLayer }, v7, v10.isExposureEnabled))
	end,
	logExposure = function() -- line: 26
		-- upvalues: IXPService (copy), FStringPVCIAfterSignupLayer (copy)
		IXPService:LogUserLayerExposure(FStringPVCIAfterSignupLayer)
	end
}
