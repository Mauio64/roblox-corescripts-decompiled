local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization

require(AppChat.types)

local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local DataHydration = require(AppChatParent.DataHydration)
local useGetPresenceByUserId = require(AppChatParent.FriendsCommon).Hooks.useGetPresenceByUserId
local PresenceType = RoduxPresence.Enums.PresenceType
local v11 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local t1 = {
	[PresenceType.InGame] = "Active",
	[PresenceType.Online] = "Active",
	[PresenceType.InStudio] = "Active",
	[PresenceType.Offline] = "None",
	[PresenceType.Invisible] = "None"
}
local t2 = {
	InGame = "Active",
	Online = "Active",
	InStudio = "Active",
	Offline = "None"
}
local t3 = {
	[PresenceType.InGame] = "ingameStatusLabel",
	[PresenceType.Online] = "onlinePresenceText",
	[PresenceType.InStudio] = "studioStatusLabel",
	[PresenceType.Offline] = "offlinePresenceText",
	[PresenceType.Invisible] = "offlinePresenceText"
}
local t4 = {
	InGame = "ingameStatusLabel",
	Online = "onlinePresenceText",
	InStudio = "studioStatusLabel",
	Offline = "offlinePresenceText"
}
local t5 = {
	offlinePresenceText = "Common.Presence.Label.Offline",
	onlinePresenceText = "Common.Presence.Label.Online",
	studioStatusLabel = "Common.Presence.Label.RobloxStudio",
	ingameStatusLabel = "Common.Presence.Label.InExperience"
}

local function useFoundationPresence(s1: string) -- line: 65
	-- upvalues: useLocalization (copy), t5 (copy), React (copy), FFlagAppChatPresenceStoreMigration (copy), useGetPresenceByUserId (copy), useSelector (copy), RoduxPresence (copy), v11 (copy), PresenceType (copy), t4 (copy), t3 (copy), t2 (copy), t1 (copy)
	local v19 = useLocalization(t5)
	local v20, v21 = React.useBinding(v19.offlinePresenceText)
	local v22, v23 = React.useState("None")
	local u24 = if not FFlagAppChatPresenceStoreMigration then useSelector(function(p1) -- line: 75
		-- upvalues: s1 (copy), RoduxPresence (copy)
		if not s1 or s1 == "" then
			return nil
		end

		if p1 == nil or p1.ChatAppReducer == nil or p1.ChatAppReducer.Presence == nil or p1.ChatAppReducer.Presence.byUserId == nil then
			return nil
		end

		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, s1)
	end) else useGetPresenceByUserId(s1)

	React.useEffect(function() -- line: 91
		-- upvalues: v19 (copy), FFlagAppChatPresenceStoreMigration (copy), v11 (copy), PresenceType (copy), u24 (ref), t4 (copy), t3 (copy), t2 (copy), t1 (copy), v23 (copy), v21 (copy)
		local offlinePresenceText = v19.offlinePresenceText
		local v27 = if not FFlagAppChatPresenceStoreMigration then PresenceType.Offline else v11.Offline

		if u24 then
			v27 = u24.userPresenceType

			local lastLocation = u24.lastLocation

			offlinePresenceText = if not FFlagAppChatPresenceStoreMigration then v19[t3[v27]] else v19[t4[v27]]

			if ((if not FFlagAppChatPresenceStoreMigration then v27 == PresenceType.InGame else v27 == v11.InGame)) and lastLocation and lastLocation ~= "" then
				offlinePresenceText = lastLocation
			end
		end

		local v29 = if not FFlagAppChatPresenceStoreMigration then t1 else t2

		v23(v29[v27] or "None")
		v21(offlinePresenceText)
	end, {
		u24,
		v19
	})

	return React.useMemo(function() -- line: 119
		-- upvalues: v22 (copy), v20 (copy)
		return {
			presence = v22,
			presenceText = v20
		}
	end, {
		v22,
		v20
	})
end

return useFoundationPresence
