local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
require(parent.SduiCoreSystem)
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetOnlineFriends = FriendsHydrationReact.useGetOnlineFriends

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSocialDataMigrateOffLegacyPresence = SharedFlags.FFlagSduiSocialDataMigrateOffLegacyPresence

local function useOnlineFriendsInGameByUniverseId()
	local v = useGetOnlineFriends()

	return React.useMemo(function()
		local result = {}

		for _, v2 in v or {} do
			local presence = v2.presence

			if not (presence and presence.userPresenceType == PresenceType.InGame and presence.universeId and presence.universeId ~= "") then
				continue
			end

			local idsById = result[presence.universeId] or {}
			idsById[v2.id] = v2.id
			result[presence.universeId] = idsById
		end

		return result
	end, { v })
end

local function useFriendsInGame()
	local v = useSelector(function(p)
		return p.LocalUserId
	end)

	local v2 = useSelector(function(p)
		return p.InGameUsersByGame
	end)

	return React.useMemo(function()
		local result = {}

		for k, v3 in v2 do
			local v4 = {}

			for k2, _ in v3 do
				if k2 ~= tostring(v) then
					v4[k2] = k2
				end
			end

			if next(v4) then
				result[tostring(k)] = v4
			end
		end

		return result
	end, { v, v2 })
end

local function useSduiSocialData()
	local getInGameFriendsByGame, v = React.useMemo(function()
		return Signals.createSignal({})
	end, {})
	local v2

	if FFlagSduiSocialDataMigrateOffLegacyPresence then
		v2 = useOnlineFriendsInGameByUniverseId()
	else
		v2 = useFriendsInGame()
	end

	v(v2)

	return React.useMemo(function()
		return { getInGameFriendsByGame = getInGameFriendsByGame }
	end, { getInGameFriendsByGame })
end

return useSduiSocialData
