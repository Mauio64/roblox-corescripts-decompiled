local ParentParent = script.Parent.Parent.Parent
local PolicyProvider = require(ParentParent.PolicyProvider)
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(p1) -- line: 9
	return {
		eligibleForCapturesFeature = function() -- line: 11
			-- upvalues: p1 (copy)
			return p1.EligibleForCapturesFeature or false
		end,
		eligibleForVideoCapture = function() -- line: 14
			-- upvalues: p1 (copy)
			return p1.EligibleForVideoCapture or false
		end,
		enableCapturesBulkManagement = function() -- line: 17
			-- upvalues: p1 (copy)
			return p1.EnableCapturesBulkManagement or false
		end,
		enableShareCaptureCTA = function() -- line: 20
			-- upvalues: p1 (copy)
			return p1.EnableShareCaptureCTA or false
		end,
		hasVideoCaptureCapability = function() -- line: 23
			-- upvalues: p1 (copy)
			return p1.HasVideoCaptureCapability or false
		end
	}
end

v4.PolicyImplementation = v3

return v4
