local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Presence.PresenceEnums.PresenceType

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").Hooks.RoactRodux.useSelector
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local useGetOnlineFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/FriendsHydrationReact").useGetOnlineFriends

local fFlagSduiSocialDataMigrateOffLegacyPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiSocialDataMigrateOffLegacyPresence

local function useOnlineFriendsInGameByUniverseId()
	local v5 = useGetOnlineFriends()

	return React.useMemo(function()
		local result = {}

		for k, v6 in v5 or {} do
			local presence = v6.presence

			if not (presence and presence.userPresenceType == presenceType.InGame and presence.universeId and presence.universeId ~= "") then
				continue
			end

			local idsById = result[presence.universeId] or {}
			idsById[v6.id] = v6.id
			result[presence.universeId] = idsById
		end

		return result
	end, { v5 })
end

local function useFriendsInGame()
	local v5 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v6 = useSelector(function(p2)
		return p2.InGameUsersByGame
	end)

	return React.useMemo(function()
		local result = {}

		for k, v7 in v6 do
			local v8 = {}

			for k2, v9 in v7 do
				if k2 ~= tostring(v5) then
					v8[k2] = k2
				end
			end

			if next(v8) then
				result[tostring(k)] = v8
			end
		end

		return result
	end, { v5, v6 })
end

local function useSduiSocialData()
	local v5, v6 = React.useMemo(function()
		return Signals.createSignal({})
	end, {})

	local v7 = if fFlagSduiSocialDataMigrateOffLegacyPresence then useOnlineFriendsInGameByUniverseId() else useFriendsInGame()

	v6(v7)

	return React.useMemo(function()
		return { getInGameFriendsByGame = v5 }
	end, { v5 })
end

return useSduiSocialData
