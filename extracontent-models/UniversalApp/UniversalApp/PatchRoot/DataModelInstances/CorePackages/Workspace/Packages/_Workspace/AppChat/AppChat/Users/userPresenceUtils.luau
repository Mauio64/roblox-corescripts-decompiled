local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local PresenceType = require(AppChat.Http.RoduxPresence).Enums.PresenceType
local v4 = require(AppChatParent.UIBlox).App.ImageSet.Images["component_assets/circle_25"]
local t1 = {
	[PresenceType.Offline] = "Common.Presence.Label.Offline",
	[PresenceType.Online] = "Common.Presence.Label.Online",
	[PresenceType.InGame] = "",
	[PresenceType.InStudio] = ""
}
local t2 = {
	[PresenceType.Offline] = "",
	[PresenceType.Online] = v4,
	[PresenceType.InGame] = v4,
	[PresenceType.InStudio] = v4
}

return {
	getUserDisplayPresence = function(p1, b1: boolean?) -- line: 41
		-- upvalues: t1 (copy), PresenceType (copy), t2 (copy)
		if not p1 then
			return {
				text = ""
			}
		end

		local t3

		if b1 then
			t3 = {
				text = t1[PresenceType.Online],
				image = t2[PresenceType.Online]
			}

			if t3 then
				return t3
			end
		end

		t3 = {}

		local userPresenceType = p1.userPresenceType
		local lastLocation = p1.lastLocation

		t3.text = if userPresenceType ~= PresenceType.Offline then if userPresenceType ~= PresenceType.Online then userPresenceType ~= PresenceType.InGame and userPresenceType ~= PresenceType.InStudio and "" or if not lastLocation then t1[PresenceType.Online] else tostring(lastLocation) else t1[PresenceType.Online] else t1[PresenceType.Offline]
		t3.image = t2[p1.userPresenceType]

		return t3
	end,
	getUserPresenceText = function(p2) -- line: 22
		-- upvalues: PresenceType (copy), t1 (copy)
		local userPresenceType = p2.userPresenceType
		local lastLocation = p2.lastLocation

		if userPresenceType == PresenceType.Offline then
			return t1[PresenceType.Offline]
		end

		if userPresenceType == PresenceType.Online then
			return t1[PresenceType.Online]
		end

		if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
			if lastLocation then
				return (tostring(lastLocation))
			end

			return t1[PresenceType.Online]
		end

		return ""
	end,
	userPresenceImage = t2,
	userPresenceText = t1
}
