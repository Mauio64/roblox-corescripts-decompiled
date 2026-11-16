local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxPresence")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsCommon").Hooks.useGetPresenceByUserId

local presenceType = RoduxPresence.Enums.PresenceType

local presenceType2 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceEnums.PresenceType else nil

local v5 = {
	[presenceType.InGame] = "Active",
	[presenceType.Online] = "Active",
	[presenceType.InStudio] = "Active",
	[presenceType.Offline] = "None",
	[presenceType.Invisible] = "None"
}

local v6 = {
	InGame = "Active",
	Online = "Active",
	InStudio = "Active",
	Offline = "None"
}

local v7 = {
	[presenceType.InGame] = "ingameStatusLabel",
	[presenceType.Online] = "onlinePresenceText",
	[presenceType.InStudio] = "studioStatusLabel",
	[presenceType.Offline] = "offlinePresenceText",
	[presenceType.Invisible] = "offlinePresenceText"
}

local v8 = {
	InGame = "ingameStatusLabel",
	Online = "onlinePresenceText",
	InStudio = "studioStatusLabel",
	Offline = "offlinePresenceText"
}

local v9 = {
	offlinePresenceText = "Common.Presence.Label.Offline",
	onlinePresenceText = "Common.Presence.Label.Online",
	studioStatusLabel = "Common.Presence.Label.RobloxStudio",
	ingameStatusLabel = "Common.Presence.Label.InExperience"
}

local function useFoundationPresence(p2)
	local v10 = useLocalization(v9)

	local v11, v12 = React.useBinding(v10.offlinePresenceText)
	local state, setState = React.useState("None")
	local v13

	if FFlagAppChatPresenceStoreMigration then
		v13 = useGetPresenceByUserId(p2)
	else
		v13 = useSelector(function(p3)
			if not p2 or p2 == "" then
				return nil
			end

			if
				p3 == nil
				or p3.ChatAppReducer == nil
				or p3.ChatAppReducer.Presence == nil
				or p3.ChatAppReducer.Presence.byUserId == nil
			then
				return nil
			end

			return RoduxPresence.Selectors.getUserPresenceByUserId(p3, p2)
		end)
	end

	React.useEffect(function()
		local v14 = v10.offlinePresenceText

		local v15 = if FFlagAppChatPresenceStoreMigration then presenceType2.Offline else presenceType.Offline

		if v13 then
			v15 = v13.userPresenceType
			local lastLocation = v13.lastLocation

			v14 = if FFlagAppChatPresenceStoreMigration then v10[v8[v15]] else v10[v7[v15]]

			local v16 = if FFlagAppChatPresenceStoreMigration then v15 == presenceType2.InGame else v15 == presenceType.InGame

			if v16 and lastLocation and lastLocation ~= "" then
				v14 = lastLocation
			end
		end

		setState((if FFlagAppChatPresenceStoreMigration then v6 else v5)[v15] or "None")
		v12(v14)
	end, { v13, v10 })

	return React.useMemo(function()
		return { presence = state, presenceText = v11 }
	end, { state, v11 })
end

return useFoundationPresence
