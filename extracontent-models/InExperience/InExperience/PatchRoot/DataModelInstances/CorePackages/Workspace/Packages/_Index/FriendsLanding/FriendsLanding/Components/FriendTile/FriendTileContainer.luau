local parent = script:FindFirstAncestor("FriendsLanding").Parent

local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local Dash = require(parent.Dash)
local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(parent.Signals)

local FriendTile = require(script.Parent.FriendTile)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsPageUserListEnabled = SharedFlags.FFlagFriendsPageUserListEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags2.FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function FriendTileContainer(p)
	local v2

	if not FFlagFriendsPageUserListEnabled then
		v2 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { p.user.id },
			query = UserProfiles.Queries.userProfilesFriendsLandingQueryByUserIds
		})
	end

	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		local v3

		if p.user and p.user.id then
			v3 = p.user.id
		end

		isRobloxSubscriber = useIsRobloxSubscriber(v3)
	end

	local useMemo = React.useMemo
	local function fn()
		return Signals.createComputed(function(p2)
			if p.user and p.user.id and p.user.id ~= "" then
				return (v.getIsTrustedConnection(p.user.id).data(p2))
			end

			return nil
		end)
	end

	local v3

	if p.user then
		v3 = p.user.id
	end

	local trustedConnection = useSignalState((useMemo(fn, { v3 })))

	local createElement = React.createElement

	local join = Dash.join
	local userProfile

	if not (FFlagFriendsPageUserListEnabled or not v2.data) then
		userProfile = v2.data.userProfiles[1]
	end

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	return createElement(
		FriendTile,
		join(p, {
			userProfile = userProfile,
			trustedConnection = trustedConnection,
			isRobloxSubscriber = isRobloxSubscriber
		})
	)
end

return FriendTileContainer
