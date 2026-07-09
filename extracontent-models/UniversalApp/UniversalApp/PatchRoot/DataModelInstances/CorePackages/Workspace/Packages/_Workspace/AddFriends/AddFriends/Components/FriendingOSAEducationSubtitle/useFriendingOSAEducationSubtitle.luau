local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useAppPolicy = require(AddFriendsParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local EventNames = require(AddFriends.Analytics.EventNames)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local FriendingOSAEducationImpressionCache = require(script.Parent.FriendingOSAEducationImpressionCache)
local FFlagConnectionsToFriendsRenameP1_v1 = require(AddFriendsParent.SharedFlags).FFlagConnectionsToFriendsRenameP1_v1

local function isHiddenOnInit() -- line: 16
	-- upvalues: FriendingOSAEducationImpressionCache (copy)
	return FriendingOSAEducationImpressionCache.getValue() ~= 0
end
local function useFriendingOSAEducationSubtitle() -- line: 21
	-- upvalues: React (copy), isHiddenOnInit (copy), useFireAnalyticsEvent (copy), useAppPolicy (copy), useLocalization (copy), FFlagConnectionsToFriendsRenameP1_v1 (copy), EventNames (copy), FriendingOSAEducationImpressionCache (copy)
	local v12 = React.useState(isHiddenOnInit)
	local v13 = useFireAnalyticsEvent()
	local v14 = useAppPolicy(function(p1) -- line: 26
		return p1.getRequiresOSAFriendingEducation()
	end)
	local v15 = useLocalization({
		educationText = not FFlagConnectionsToFriendsRenameP1_v1 and "Feature.Friends.Subtitle.ConnectionsEducation" or "Feature.Friends.Subtitle.FriendsEducation"
	})
	local v16 = v14 and not v12
	local v17 = React.useCallback(function() -- line: 38
		-- upvalues: v13 (copy), EventNames (copy), FriendingOSAEducationImpressionCache (copy)
		v13(EventNames.FriendingOSAEducationSubtitleImpression)
		FriendingOSAEducationImpressionCache.incrementValue()
	end, { v13 })

	React.useEffect(function() -- line: 44
		-- upvalues: v16 (copy), v17 (copy)
		if v16 then
			v17()
		end
	end, { v16 })

	if v16 then
		return v15.educationText
	end

	return nil
end

return useFriendingOSAEducationSubtitle
