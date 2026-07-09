local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization

require(AppChat.types)

local RoduxPresence = require(AppChat.Http.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local t1 = {
	[PresenceType.InGame] = "Active",
	[PresenceType.Online] = "Active",
	[PresenceType.InStudio] = "Active",
	[PresenceType.Offline] = "None",
	[PresenceType.Invisible] = "None"
}
local t2 = {
	[PresenceType.InGame] = "ingameStatusLabel",
	[PresenceType.Online] = "onlinePresenceText",
	[PresenceType.InStudio] = "studioStatusLabel",
	[PresenceType.Offline] = "offlinePresenceText",
	[PresenceType.Invisible] = "offlinePresenceText"
}
local t3 = {
	offlinePresenceText = "Common.Presence.Label.Offline",
	onlinePresenceText = "Common.Presence.Label.Online",
	studioStatusLabel = "Common.Presence.Label.RobloxStudio",
	ingameStatusLabel = "Common.Presence.Label.InExperience"
}

local function useFoundationPresence(s1: string) -- line: 43
	-- upvalues: useLocalization (copy), t3 (copy), React (copy), useSelector (copy), RoduxPresence (copy), PresenceType (copy), t2 (copy), t1 (copy)
	local v13 = useLocalization(t3)
	local v14, v15 = React.useBinding(v13.offlinePresenceText)
	local v16, v17 = React.useState("None")
	local v18 = useSelector(function(p1) -- line: 49
		-- upvalues: s1 (copy), RoduxPresence (copy)
		if not s1 or s1 == "" then
			return nil
		end

		if p1 == nil or p1.ChatAppReducer == nil or p1.ChatAppReducer.Presence == nil or p1.ChatAppReducer.Presence.byUserId == nil then
			return nil
		end

		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, s1)
	end)

	React.useEffect(function() -- line: 64
		-- upvalues: v13 (copy), PresenceType (copy), v18 (copy), t2 (copy), t1 (copy), v17 (copy), v15 (copy)
		local offlinePresenceText = v13.offlinePresenceText
		local Offline = PresenceType.Offline

		if v18 then
			Offline = v18.userPresenceType

			local lastLocation = v18.lastLocation

			offlinePresenceText = v13[t2[Offline]]

			if Offline == PresenceType.InGame and lastLocation and lastLocation ~= "" then
				offlinePresenceText = lastLocation
			end
		end

		local v23 = t1

		v17(v23[Offline] or "None")
		v15(offlinePresenceText)
	end, {
		v18,
		v13
	})

	return React.useMemo(function() -- line: 84
		-- upvalues: v16 (copy), v14 (copy)
		return {
			presence = v16,
			presenceText = v14
		}
	end, {
		v16,
		v14
	})
end

return useFoundationPresence
