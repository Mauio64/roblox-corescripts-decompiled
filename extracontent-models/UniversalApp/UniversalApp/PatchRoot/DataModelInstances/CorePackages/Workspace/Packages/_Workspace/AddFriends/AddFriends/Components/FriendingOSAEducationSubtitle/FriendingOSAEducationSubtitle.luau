local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local Text = require(AddFriendsParent.Foundation).Text
local useAppPolicy = require(AddFriendsParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local EventNames = require(AddFriends.Analytics.EventNames)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local FriendingOSAEducationImpressionCache = require(script.Parent.FriendingOSAEducationImpressionCache)
local useFriendingOSAEducationSubtitle = require(script.Parent.useFriendingOSAEducationSubtitle)
local FFlagConnectionsToFriendsRenameP1_v1 = require(AddFriendsParent.SharedFlags).FFlagConnectionsToFriendsRenameP1_v1
local v12 = game:DefineFastFlag("FriendingOSAUseHook", false)

local function isHiddenOnInit() -- line: 25
	-- upvalues: FriendingOSAEducationImpressionCache (copy)
	return FriendingOSAEducationImpressionCache.getValue() ~= 0
end
local function FriendingOSAEducationSubtitle(t1: {[any]: any}) -- line: 30
	-- upvalues: v12 (copy), useFriendingOSAEducationSubtitle (copy), React (copy), Text (copy), isHiddenOnInit (copy), useFireAnalyticsEvent (copy), useAppPolicy (copy), useLocalization (copy), FFlagConnectionsToFriendsRenameP1_v1 (copy), EventNames (copy), FriendingOSAEducationImpressionCache (copy)
	local layoutOrder = t1.layoutOrder

	if v12 then
		local v17 = useFriendingOSAEducationSubtitle()

		if v17 then
			return (React.createElement(Text, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				Text = v17,
				LayoutOrder = layoutOrder
			}))
		end

		return nil
	end

	local v18 = React.useState(isHiddenOnInit)
	local v19 = useFireAnalyticsEvent()
	local v20 = useAppPolicy(function(p1) -- line: 48
		return p1.getRequiresOSAFriendingEducation()
	end)
	local v21 = useLocalization({
		educationText = not FFlagConnectionsToFriendsRenameP1_v1 and "Feature.Friends.Subtitle.ConnectionsEducation" or "Feature.Friends.Subtitle.FriendsEducation"
	})
	local v22 = v20 and not v18
	local v23 = React.useCallback(function() -- line: 60
		-- upvalues: v19 (copy), EventNames (copy), FriendingOSAEducationImpressionCache (copy)
		v19(EventNames.FriendingOSAEducationSubtitleImpression)
		FriendingOSAEducationImpressionCache.incrementValue()
	end, { v19 })

	React.useEffect(function() -- line: 66
		-- upvalues: v22 (copy), v23 (copy)
		if v22 then
			v23()
		end
	end, { v22 })

	if v22 then
		return (React.createElement(Text, {
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = v21.educationText,
			LayoutOrder = layoutOrder
		}))
	end

	return nil
end

return FriendingOSAEducationSubtitle
