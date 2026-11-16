local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local React = require(parent.React)
local DataHydration = require(parent.DataHydration)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local useRealtimeNamespace = RealtimeDelivery.useRealtimeNamespace
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel

require(script.Parent.GameInviteFriendRow)
local FIntGameInviteOnlineFriendsRefetchThrottleSec = require(GameInvite.Flags.FIntGameInviteOnlineFriendsRefetchThrottleSec)

local function isOfflineReport(item): boolean -- 1 equivalent call inferred from this helper
	local presenceReport = item.PresenceReport
	return presenceReport ~= nil and presenceReport.userPresenceType == 0
end

local function hasListedFriendComeOnline(items, current): boolean
	for _, item in items do
		local v = current[tostring(item.UserId)]

		if v ~= nil and v.presence == UserModel.PresenceType.OFFLINE and not isOfflineReport(item) then -- inferred equivalent call
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

	local v = React.useCallback(function()
		ref3.current = nil
		ref2.current = os.clock()
		DataHydration.Friends.FriendsStore.get().RefetchOnlineFriends()
	end, {})

	useRealtimeNamespace("PresenceBulkNotifications", function(p)
		if type(p) ~= "table" or ref3.current ~= nil or not hasListedFriendComeOnline(p, ref.current) then
			return
		end

		local v2 = FIntGameInviteOnlineFriendsRefetchThrottleSec - (os.clock() - ref2.current)

		if v2 <= 0 then
			v()
		else
			ref3.current = task.delay(v2, v)
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
