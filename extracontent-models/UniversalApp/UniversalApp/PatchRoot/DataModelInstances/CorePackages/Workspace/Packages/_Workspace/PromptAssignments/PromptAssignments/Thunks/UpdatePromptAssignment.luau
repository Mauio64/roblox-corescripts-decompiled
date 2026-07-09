local PromptAssignments = script:FindFirstAncestor("PromptAssignments")
local PostUpdatePromptAssignments = require(PromptAssignments.Requests.PostUpdatePromptAssignments)
local PromptType = require(PromptAssignments.Enum.PromptType)
local PromptAssignmentAction = require(PromptAssignments.Enum.PromptAssignmentAction)

return function(p1, p2, p3) -- line: 7
	-- upvalues: PromptType (copy), PostUpdatePromptAssignments (copy), PromptAssignmentAction (copy)
	return function(_) -- line: 8
		-- upvalues: PromptType (copy), p2 (copy), PostUpdatePromptAssignments (copy), p1 (copy), PromptAssignmentAction (copy), p3 (copy)
		local v9 = PromptType.toRawValue(p2)

		if v9 == nil then
			v9 = p2
		end

		return PostUpdatePromptAssignments(p1, v9, PromptAssignmentAction.toRawValue(p3)):andThen(function(p5) -- line: 16
			return p5.responseBody
		end)
	end
end
