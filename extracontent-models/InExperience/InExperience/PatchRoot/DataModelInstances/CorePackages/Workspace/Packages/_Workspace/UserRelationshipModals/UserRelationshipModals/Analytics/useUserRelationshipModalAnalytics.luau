local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local React = require(Parent.React)
local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

require(script.Parent.RelationshipTypes)

local function useUserRelationshipModalAnalytics(p1, n1: number, n2: number) -- line: 14
	-- upvalues: React (copy), AnalyticsSetup (copy)
	return (React.useMemo(function() -- line: 19
		-- upvalues: AnalyticsSetup (copy), p1 (copy), n2 (copy)
		return AnalyticsSetup({
			infoForAllEvents = {
				relationshipType = p1,
				targetUserId = n2
			}
		})
	end, {
		p1,
		n1,
		n2
	}))
end

return useUserRelationshipModalAnalytics
