local parent = script.Parent.Parent.Parent

local PolicyProvider = require(parent.PolicyProvider)

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

function v.Mapper(data)
	return {
		eligibleForCapturesFeature = function()
			return data.EligibleForCapturesFeature or false
		end,
		eligibleForVideoCapture = function()
			return data.EligibleForVideoCapture or false
		end,
		enableCapturesBulkManagement = function()
			return data.EnableCapturesBulkManagement or false
		end,
		enableShareCaptureCTA = function()
			return data.EnableShareCaptureCTA or false
		end,
		hasVideoCaptureCapability = function()
			return data.HasVideoCaptureCapability or false
		end
	}
end

v.PolicyImplementation = memStorageService

return v
