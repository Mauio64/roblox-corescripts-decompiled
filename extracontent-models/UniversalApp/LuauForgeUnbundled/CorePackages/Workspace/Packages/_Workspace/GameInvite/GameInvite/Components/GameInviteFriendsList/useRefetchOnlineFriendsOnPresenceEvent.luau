local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")
local useRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RealtimeDelivery").useRealtimeNamespace
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserLib").Models.UserModel

require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteFriendRow")
local FIntGameInviteOnlineFriendsRefetchThrottleSec = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FIntGameInviteOnlineFriendsRefetchThrottleSec")

local function isOfflineReport(p2): boolean
	local presenceReport = p2.PresenceReport
	return presenceReport ~= nil and presenceReport.userPresenceType == 0
end

local function hasListedFriendComeOnline(items, current): boolean
	for k, item in items do
		local v5 = current[tostring(item.UserId)]

		if not (v5 ~= nil and v5.presence == userModel.PresenceType.OFFLINE) then
			continue
		end

		local presenceReport = item.PresenceReport
		local v6 = not (presenceReport == nil) and presenceReport.userPresenceType == 0

		if not v6 then
			return true
		end
	end

	return false
end

local function useRefetchOnlineFriendsOnPresenceEvent(current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(os.clock())
	local ref3 = React.useRef(nil)

	local v5 = React.useCallback(function()
		ref3.current = nil
		ref2.current = os.clock()
		DataHydration.Friends.FriendsStore.get().RefetchOnlineFriends()
	end, {})

	useRealtimeNamespace("PresenceBulkNotifications", function(p2)
		if type(p2) ~= "table" or ref3.current ~= nil or not hasListedFriendComeOnline(p2, ref.current) then
			return
		end

		local v6 = FIntGameInviteOnlineFriendsRefetchThrottleSec - (os.clock() - ref2.current)

		if v6 <= 0 then
			v5()
		else
			ref3.current = task.delay(v6, v5)
		end
	end, {})

	React.useEffect(function()
		return function()
			local current2 = ref3.current

			if current2 ~= nil then
				task.cancel(current2)
				ref3.current = nil
			end
		end
	end, {})
end

return useRefetchOnlineFriendsOnPresenceEvent
