local parent = script:FindFirstAncestor("UserRelationshipModals").Parent

local React = require(parent.React)

local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

require(script.Parent.RelationshipTypes)

local function useUserRelationshipModalAnalytics(relationshipType, p: number, targetUserId: number)
	return (React.useMemo(function()
		return AnalyticsSetup({
			infoForAllEvents = { relationshipType = relationshipType, targetUserId = targetUserId }
		})
	end, { relationshipType, p, targetUserId }))
end

return useUserRelationshipModalAnalytics
