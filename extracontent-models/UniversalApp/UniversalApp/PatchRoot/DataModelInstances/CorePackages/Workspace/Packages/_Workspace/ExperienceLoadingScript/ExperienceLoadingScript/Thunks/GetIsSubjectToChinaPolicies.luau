local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local CachedPolicyService = require(ExperienceLoadingScriptParent.CachedPolicyService)
local SetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Actions.SetIsSubjectToChinaPolicies)

return function() -- line: 7
	-- upvalues: CachedPolicyService (copy), SetIsSubjectToChinaPolicies (copy)
	return function(p1) -- line: 8
		-- upvalues: CachedPolicyService (copy), SetIsSubjectToChinaPolicies (copy)
		coroutine.wrap(function() -- line: 9
			-- upvalues: CachedPolicyService (copy), p1 (copy), SetIsSubjectToChinaPolicies (copy)
			local v6 = CachedPolicyService:IsSubjectToChinaPolicies()

			p1:dispatch(SetIsSubjectToChinaPolicies(v6))
		end)()
	end
end
