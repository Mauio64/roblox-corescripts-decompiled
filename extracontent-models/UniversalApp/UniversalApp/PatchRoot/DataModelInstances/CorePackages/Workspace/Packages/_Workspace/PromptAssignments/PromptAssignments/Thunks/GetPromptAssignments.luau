local PromptAssignments = script:FindFirstAncestor("PromptAssignments")
local PromptAssignmentsParent = PromptAssignments.Parent
local PerformFetch = require(PromptAssignmentsParent.Http).PerformFetch
local GetPromptAssignments = require(PromptAssignments.Requests.GetPromptAssignments)

return function(p1) -- line: 6
	-- upvalues: PerformFetch (copy), GetPromptAssignments (copy)
	return PerformFetch.Single("GetPromptAssignments", function(_) -- line: 7
		-- upvalues: GetPromptAssignments (copy), p1 (copy)
		return GetPromptAssignments(p1):andThen(function(p3) -- line: 8
			return p3.responseBody
		end)
	end)
end
