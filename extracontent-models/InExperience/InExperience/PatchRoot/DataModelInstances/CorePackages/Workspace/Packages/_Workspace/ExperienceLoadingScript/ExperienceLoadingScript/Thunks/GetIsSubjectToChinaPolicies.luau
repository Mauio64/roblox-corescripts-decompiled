local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local parent = ExperienceLoadingScript.Parent

local CachedPolicyService = require(parent.CachedPolicyService)
local SetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Actions.SetIsSubjectToChinaPolicies)

return function()
	return function(object)
		coroutine.wrap(function()
			object:dispatch(SetIsSubjectToChinaPolicies((CachedPolicyService:IsSubjectToChinaPolicies())))
		end)()
	end
end
