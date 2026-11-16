local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/UserProfiles")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Dash")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/DataHydration")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SignalsReact").useSignalState
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Signals")

local FriendTile = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendTile/FriendTile")

local fFlagFriendsPageUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageUserListEnabled
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function FriendTileContainer(p2)
	local v6

	if not fFlagFriendsPageUserListEnabled then
		v6 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { p2.user.id },
			query = UserProfiles.Queries.userProfilesFriendsLandingQueryByUserIds
		})
	end

	local v7

	if fFlagEnableBlackbirdCheck then
		local v9 = if p2.user and p2.user.id then p2.user.id else nil
		v7 = useIsRobloxSubscriber(v9)
	end

	local function fn()
		return Signals.createComputed(function(p3)
			if p2.user and p2.user.id and p2.user.id ~= "" then
				return (v5.getIsTrustedConnection(p2.user.id).data(p3))
			end

			return nil
		end)
	end

	local v11 = useSignalState((React.useMemo(fn, { if p2.user then p2.user.id else nil })))

	local createElement = React.createElement

	local join = Dash.join

	local v14 = if not (fFlagFriendsPageUserListEnabled or not v6.data) then v6.data.userProfiles[1] else nil

	if not fFlagEnableBlackbirdCheck then
		v7 = nil
	end

	return createElement(
		FriendTile,
		join(p2, { userProfile = v14, trustedConnection = v11, isRobloxSubscriber = v7 })
	)
end

return FriendTileContainer
