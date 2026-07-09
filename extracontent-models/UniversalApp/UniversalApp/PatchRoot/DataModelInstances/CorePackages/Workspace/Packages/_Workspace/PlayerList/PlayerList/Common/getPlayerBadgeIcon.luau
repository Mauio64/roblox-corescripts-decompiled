local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local builderIcon = require(ParentParent.Common.builderIcon)
local SharedFlags = require(ParentParentParent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local t1 = {
	[Enum.FriendStatus.Friend] = builderIcon("two-people", "Filled"),
	[Enum.FriendStatus.FriendRequestReceived] = builderIcon("person-clock", "Filled")
}
local v8 = builderIcon("circle-slash")
local v9 = builderIcon("hammer-code", "Filled")
local v10 = builderIcon("person-check", "Filled")
local v11 = builderIcon("premium")

local function getSocialIcon(p1) -- line: 20
	-- upvalues: v8 (copy), t1 (copy)
	if not p1 then
		return nil
	end

	if p1.isBlocked then
		return v8
	end

	return t1[p1.friendStatus]
end
local function getPlayerBadgeIcon(p2, p3, p4, p5) -- line: 30
	-- upvalues: v8 (copy), t1 (copy), v9 (copy), v10 (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), v11 (copy)
	if not p2 then
		return nil
	end

	local v19 = if p5 then if not p5.isBlocked then t1[p5.friendStatus] else v8 else nil

	if v19 then
		return v19
	end

	if p4 and p4.isPlaceOwner then
		return v9
	end

	if p2.CustomPlayerIcons and p2.CustomPlayerIcons[p3.UserId] then
		return p2.CustomPlayerIcons[p3.UserId]
	end

	if p4 and p4.specialGroupIcon then
		return p4.specialGroupIcon
	end

	if p5 and p5.isFollowing then
		return v10
	end

	local v20 = p3.MembershipType == Enum.MembershipType.Premium

	if FFlagEnableBlackbirdCheck then
		if game:GetEngineFeature("ReadHasRobloxSubscriptionLua") and p3.HasRobloxSubscription then
			return p2.SubscriptionIcon
		end

		if not FFlagHidePremiumIconography and v20 then
			return v11
		end
	elseif v20 then
		return v11
	end

	return nil
end

return getPlayerBadgeIcon
