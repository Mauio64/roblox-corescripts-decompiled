local Parent = script:FindFirstAncestor("FriendsLanding").Parent
local React = require(Parent.React)
local UserProfiles = require(Parent.UserProfiles)
local Dash = require(Parent.Dash)
local DataHydration = require(Parent.DataHydration)
local useSignalState = require(Parent.SignalsReact).useSignalState
local Signals = require(Parent.Signals)
local FriendTile = require(script.Parent.FriendTile)
local FFlagFriendsPageUserListEnabled = require(Parent.SharedFlags).FFlagFriendsPageUserListEnabled
local FFlagEnableBlackbirdCheck = require(Parent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local v12 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function FriendTileContainer(p1) -- line: 19
	-- upvalues: FFlagFriendsPageUserListEnabled (copy), UserProfiles (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), React (copy), Signals (copy), v12 (copy), useSignalState (copy), FriendTile (copy), Dash (copy)
	local v15 = if not FFlagFriendsPageUserListEnabled then UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p1.user.id },
		query = UserProfiles.Queries.userProfilesFriendsLandingQueryByUserIds
	}) else nil
	local v16 = nil

	if FFlagEnableBlackbirdCheck then
		v16 = useIsRobloxSubscriber(if not p1.user or not p1.user.id then nil else p1.user.id)
	end

	local v17 = React.useMemo(function() -- line: 33
		-- upvalues: Signals (copy), p1 (copy), v12 (copy)
		return Signals.createComputed(function(p2) -- line: 34
			-- upvalues: p1 (copy), v12 (copy)
			if p1.user and (p1.user.id and p1.user.id ~= "") then
				return (v12.getIsTrustedConnection(p1.user.id).data(p2))
			end

			return nil
		end)
	end, { if not p1.user then nil else p1.user.id })
	local v18 = useSignalState(v17)

	return React.createElement(FriendTile, Dash.join(p1, {
		userProfile = if not FFlagFriendsPageUserListEnabled then if not v15.data then nil else v15.data.userProfiles[1] else nil,
		trustedConnection = v18,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v16
	}))
end

return FriendTileContainer
