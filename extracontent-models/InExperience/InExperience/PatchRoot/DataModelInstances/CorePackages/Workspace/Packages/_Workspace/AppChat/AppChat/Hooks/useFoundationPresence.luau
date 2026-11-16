local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(AppChat.types)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local DataHydration = require(parent.DataHydration)
local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId

local PresenceType = RoduxPresence.Enums.PresenceType
local presenceType

if FFlagAppChatPresenceStoreMigration then
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local v = {
	[PresenceType.InGame] = "Active",
	[PresenceType.Online] = "Active",
	[PresenceType.InStudio] = "Active",
	[PresenceType.Offline] = "None",
	[PresenceType.Invisible] = "None"
}

local v2 = { InGame = "Active", Online = "Active", InStudio = "Active", Offline = "None" }

local v3 = {
	[PresenceType.InGame] = "ingameStatusLabel",
	[PresenceType.Online] = "onlinePresenceText",
	[PresenceType.InStudio] = "studioStatusLabel",
	[PresenceType.Offline] = "offlinePresenceText",
	[PresenceType.Invisible] = "offlinePresenceText"
}

local v4 = {
	InGame = "ingameStatusLabel",
	Online = "onlinePresenceText",
	InStudio = "studioStatusLabel",
	Offline = "offlinePresenceText"
}

local v5 = {
	offlinePresenceText = "Common.Presence.Label.Offline",
	onlinePresenceText = "Common.Presence.Label.Online",
	studioStatusLabel = "Common.Presence.Label.RobloxStudio",
	ingameStatusLabel = "Common.Presence.Label.InExperience"
}

local function useFoundationPresence(p: string)
	local v6 = useLocalization(v5)

	local presenceText, v7 = React.useBinding(v6.offlinePresenceText)
	local state, setState = React.useState("None")
	local v8

	if FFlagAppChatPresenceStoreMigration then
		v8 = useGetPresenceByUserId(p)
	else
		v8 = useSelector(function(p2)
			if not p or p == "" then
				return nil
			end

			if
				p2 == nil
				or p2.ChatAppReducer == nil
				or p2.ChatAppReducer.Presence == nil
				or p2.ChatAppReducer.Presence.byUserId == nil
			then
				return nil
			end

			return RoduxPresence.Selectors.getUserPresenceByUserId(p2, p)
		end)
	end

	React.useEffect(function()
		local v9 = v6.offlinePresenceText
		local v10

		if FFlagAppChatPresenceStoreMigration then
			v10 = presenceType.Offline
		else
			v10 = PresenceType.Offline
		end

		if v8 then
			v10 = v8.userPresenceType
			local lastLocation = v8.lastLocation

			if FFlagAppChatPresenceStoreMigration then
				v9 = v6[v4[v10]]
			else
				v9 = v6[v3[v10]]
			end

			local v11

			if FFlagAppChatPresenceStoreMigration then
				v11 = v10 == presenceType.InGame
			else
				v11 = v10 == PresenceType.InGame
			end

			if v11 and lastLocation and lastLocation ~= "" then
				v9 = lastLocation
			end
		end

		local v11

		if FFlagAppChatPresenceStoreMigration then
			v11 = v2
		else
			v11 = v
		end

		setState(v11[v10] or "None")
		v7(v9)
	end, { v8, v6 })

	return React.useMemo(function()
		return { presence = state, presenceText = presenceText }
	end, { state, presenceText })
end

return useFoundationPresence
