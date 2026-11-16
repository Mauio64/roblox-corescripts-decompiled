local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local UserProfiles = require(parent.UserProfiles)
local useVerifiedBadge = UserProfiles.Hooks.useVerifiedBadge

local VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore

local function PlayerVerifiedBadge(p)
	local v

	if FFlagEnableVerifiedBadgeStore then
		v = useVerifiedBadge(p.player)
	else
		v = p.player.HasVerifiedBadge
	end

	if v then
		return React.createElement(VerifiedBadge, { LayoutOrder = p.layoutOrder })
	end

	return nil
end

return React.memo(PlayerVerifiedBadge)
