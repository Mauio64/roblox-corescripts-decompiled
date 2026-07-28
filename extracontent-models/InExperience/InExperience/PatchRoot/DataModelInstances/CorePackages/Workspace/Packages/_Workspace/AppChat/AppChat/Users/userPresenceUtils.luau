local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local DataHydration = require(AppChatParent.DataHydration)
local PresenceType = require(AppChat.Http.RoduxPresence).Enums.PresenceType
local v5 = require(AppChatParent.UIBlox).App.ImageSet.Images["component_assets/circle_25"]
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local PresenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
local t1 = {
	[PresenceType.Offline] = "Common.Presence.Label.Offline",
	[PresenceType.Online] = "Common.Presence.Label.Online",
	[PresenceType.InGame] = "",
	[PresenceType.InStudio] = ""
}
local t2 = {
	[PresenceType.Offline] = "",
	[PresenceType.Online] = v5,
	[PresenceType.InGame] = v5,
	[PresenceType.InStudio] = v5
}
local t3 = {
	Offline = "Common.Presence.Label.Offline",
	Online = "Common.Presence.Label.Online",
	InGame = "",
	InStudio = ""
}
local t4 = {
	Offline = "",
	Online = v5,
	InGame = v5,
	InStudio = v5
}

local function getUserPresenceTextFromStore(p1) -- line: 63
	-- upvalues: PresenceType2 (copy), t3 (copy)
	local userPresenceType = p1.userPresenceType
	local lastLocation = p1.lastLocation

	if userPresenceType == PresenceType2.Offline then
		return t3[PresenceType2.Offline]
	end

	if userPresenceType == PresenceType2.Online then
		return t3[PresenceType2.Online]
	end

	if userPresenceType == PresenceType2.InGame or userPresenceType == PresenceType2.InStudio then
		if lastLocation and lastLocation ~= "" then
			return (tostring(lastLocation))
		end

		return t3[PresenceType2.Online]
	end

	return ""
end
local function getUserDisplayPresenceFromStoreData(p2, b1: boolean?) -- line: 99
	-- upvalues: t3 (copy), PresenceType2 (copy), t4 (copy)
	if not p2 then
		return {
			text = ""
		}
	end

	if b1 then
		return {
			text = t3[PresenceType2.Online],
			image = t4[PresenceType2.Online]
		}
	end

	local t5 = {}
	local userPresenceType = p2.userPresenceType
	local lastLocation = p2.lastLocation

	t5.text = if userPresenceType ~= PresenceType2.Offline then if userPresenceType ~= PresenceType2.Online then userPresenceType ~= PresenceType2.InGame and userPresenceType ~= PresenceType2.InStudio and "" or if not lastLocation or lastLocation == "" then t3[PresenceType2.Online] else tostring(lastLocation) else t3[PresenceType2.Online] else t3[PresenceType2.Offline]
	t5.image = t4[p2.userPresenceType]

	return t5
end

return {
	getUserDisplayPresence = not FFlagAppChatPresenceStoreMigration and function(p3, b2: boolean?) -- line: 82
		-- upvalues: t1 (copy), PresenceType (copy), t2 (copy)
		if not p3 then
			return {
				text = ""
			}
		end

		local t6

		if b2 then
			t6 = {
				text = t1[PresenceType.Online],
				image = t2[PresenceType.Online]
			}

			if t6 then
				return t6
			end
		end

		t6 = {}

		local userPresenceType = p3.userPresenceType
		local lastLocation = p3.lastLocation

		t6.text = if userPresenceType ~= PresenceType.Offline then if userPresenceType ~= PresenceType.Online then userPresenceType ~= PresenceType.InGame and userPresenceType ~= PresenceType.InStudio and "" or if not lastLocation then t1[PresenceType.Online] else tostring(lastLocation) else t1[PresenceType.Online] else t1[PresenceType.Offline]
		t6.image = t2[p3.userPresenceType]

		return t6
	end or getUserDisplayPresenceFromStoreData,
	getUserPresenceText = not FFlagAppChatPresenceStoreMigration and function(p4) -- line: 44
		-- upvalues: PresenceType (copy), t1 (copy)
		local userPresenceType = p4.userPresenceType
		local lastLocation = p4.lastLocation

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
	end or getUserPresenceTextFromStore,
	userPresenceImage = t2,
	userPresenceText = t1,
	storePresenceImage = if not FFlagAppChatPresenceStoreMigration then nil else t4,
	storePresenceText = if not FFlagAppChatPresenceStoreMigration then nil else t3
}
