local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local DataHydration = require(parent.DataHydration)
local FFlagFriendsChatFacePileGroupPresence = require(FriendsChat.Flags.FFlagFriendsChatFacePileGroupPresence)

local UserPresence = Foundation.Enums.UserPresence
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType

local v = DataHydration.Presence.PresenceStore.get()

local function toUserPresence(p) -- 1 equivalent call inferred from this helper
	if p == PresenceType.InGame then
		return UserPresence.InExperience
	end

	if p == PresenceType.InStudio or p == PresenceType.Online then
		return UserPresence.Active
	end

	return UserPresence.None
end

local function aggregateGroupPresence(list, p)
	local flag = false
	local flag2 = false

	for _, item in list do
		local data = v.GetPresenceByUserId((tostring(item))).data(p)

		if not data then
			continue
		end

		local userPresenceType = data.userPresenceType

		if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
			flag = true
		elseif userPresenceType == PresenceType.Online then
			flag2 = true
		end
	end

	if flag then
		return UserPresence.InExperience
	end

	return if flag2 then UserPresence.Active else UserPresence.None
end

local function useFacePilePresence(list)
	local item = list[1]

	local v2 = FFlagFriendsChatFacePileGroupPresence and #list >= 2
	local v3

	if v2 then
		v3 = table.concat(list, ",")
	else
		v3 = item == nil and "" or tostring(item)
	end

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v2 then
				return aggregateGroupPresence(list, p)
			end

			if item == nil then
				return UserPresence.None
			end

			local data = v.GetPresenceByUserId((tostring(item))).data(p)
			local v4

			if data then
				v4 = data.userPresenceType
			end

			return toUserPresence(v4) -- inferred equivalent call
		end)
	end, { v3 })

	return (SignalsReact.useSignalState(v4))
end

return useFacePilePresence
