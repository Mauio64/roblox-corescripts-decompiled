local parent = script.Parent.Parent
local parent2 = parent.Parent

local builderIcon = require(parent.Common.builderIcon)
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography

local v = {
	[Enum.FriendStatus.Friend] = builderIcon("two-people", "Filled"),
	[Enum.FriendStatus.FriendRequestReceived] = builderIcon("person-clock", "Filled")
}

local v2 = builderIcon("circle-slash")
local v3 = builderIcon("hammer-code", "Filled")
local v4 = builderIcon("person-check", "Filled")
local v5 = builderIcon("premium")

local function getSocialIcon(p) -- 1 equivalent call inferred from this helper
	if not p then
		return nil
	end

	if p.isBlocked then
		return v2
	end

	return v[p.friendStatus]
end

local function getPlayerBadgeIcon(p, data, p2, p3)
	if not p then
		return nil
	end

	local socialIcon = getSocialIcon(p3) -- inferred equivalent call

	if socialIcon then
		return socialIcon
	end

	if p2 and p2.isPlaceOwner then
		return v3
	end

	if p.CustomPlayerIcons and p.CustomPlayerIcons[data.UserId] then
		return p.CustomPlayerIcons[data.UserId]
	end

	if p2 and p2.specialGroupIcon then
		return p2.specialGroupIcon
	end

	if p3 and p3.isFollowing then
		return v4
	end

	local v6 = data.MembershipType == Enum.MembershipType.Premium

	if FFlagEnableBlackbirdCheck then
		if game:GetEngineFeature("ReadHasRobloxSubscriptionLua") and data.HasRobloxSubscription then
			return p.SubscriptionIcon
		end

		if not FFlagHidePremiumIconography and v6 then
			return v5
		end
	elseif v6 then
		return v5
	end

	return nil
end

return getPlayerBadgeIcon
