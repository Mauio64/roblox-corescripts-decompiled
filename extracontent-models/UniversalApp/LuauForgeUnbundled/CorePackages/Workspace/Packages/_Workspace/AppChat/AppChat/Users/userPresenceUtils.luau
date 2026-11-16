local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxPresence").Enums.PresenceType
local component_assetscircle_25 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.ImageSet.Images["component_assets/circle_25"]

local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType

local v5 = {
	[presenceType.Offline] = "Common.Presence.Label.Offline",
	[presenceType.Online] = "Common.Presence.Label.Online",
	[presenceType.InGame] = "",
	[presenceType.InStudio] = ""
}

local v6 = {
	[presenceType.Offline] = "",
	[presenceType.Online] = component_assetscircle_25,
	[presenceType.InGame] = component_assetscircle_25,
	[presenceType.InStudio] = component_assetscircle_25
}

local v7 = {
	Offline = "Common.Presence.Label.Offline",
	Online = "Common.Presence.Label.Online",
	InGame = "",
	InStudio = ""
}

local v8 = {
	Offline = "",
	Online = component_assetscircle_25,
	InGame = component_assetscircle_25,
	InStudio = component_assetscircle_25
}

local function getUserPresenceTextFromStore(p2)
	local userPresenceType = p2.userPresenceType
	local lastLocation = p2.lastLocation

	if userPresenceType == presenceType2.Offline then
		return v7[presenceType2.Offline]
	end

	if userPresenceType == presenceType2.Online then
		return v7[presenceType2.Online]
	end

	if userPresenceType ~= presenceType2.InGame and userPresenceType ~= presenceType2.InStudio then
		return ""
	end

	if lastLocation and lastLocation ~= "" then
		return (tostring(lastLocation))
	end

	return v7[presenceType2.Online]
end

local function getUserDisplayPresenceFromStoreData(p2, p3)
	if not p2 then
		return { text = "" }
	end

	if p3 then
		return { text = v7[presenceType2.Online], image = v8[presenceType2.Online] }
	end

	local userPresenceType = p2.userPresenceType
	local lastLocation = p2.lastLocation
	local v10

	if userPresenceType == presenceType2.Offline then
		v10 = v7[presenceType2.Offline]
	elseif userPresenceType == presenceType2.Online then
		v10 = v7[presenceType2.Online]
	elseif userPresenceType == presenceType2.InGame or userPresenceType == presenceType2.InStudio then
		if lastLocation and lastLocation ~= "" then
			v10 = tostring(lastLocation)
		else
			v10 = v7[presenceType2.Online]
		end
	else
		v10 = ""
	end

	return { text = v10, image = v8[p2.userPresenceType] }
end

return {
	getUserDisplayPresence = not FFlagAppChatPresenceStoreMigration and function(p2, p3)
		if not p2 then
			return { text = "" }
		end

		local v10 = p3 and {
			text = v5[presenceType.Online],
			image = v6[presenceType.Online]
		}

		if v10 then
			return v10
		end

		v10 = { text = 0, image = 0 }
		local userPresenceType = p2.userPresenceType
		local lastLocation = p2.lastLocation
		local v11

		if userPresenceType == presenceType.Offline then
			v11 = v5[presenceType.Offline]
		elseif userPresenceType == presenceType.Online then
			v11 = v5[presenceType.Online]
		elseif userPresenceType == presenceType.InGame or userPresenceType == presenceType.InStudio then
			v11 = if lastLocation then tostring(lastLocation) else v5[presenceType.Online]
		else
			v11 = ""
		end

		v10.text = v11
		v10.image = v6[p2.userPresenceType]
		return v10
	end or getUserDisplayPresenceFromStoreData,
	getUserPresenceText = not FFlagAppChatPresenceStoreMigration and function(p2)
		local userPresenceType = p2.userPresenceType
		local lastLocation = p2.lastLocation

		if userPresenceType == presenceType.Offline then
			return v5[presenceType.Offline]
		end

		if userPresenceType == presenceType.Online then
			return v5[presenceType.Online]
		end

		if userPresenceType ~= presenceType.InGame and userPresenceType ~= presenceType.InStudio then
			return ""
		end

		if lastLocation then
			return (tostring(lastLocation))
		end

		return v5[presenceType.Online]
	end or getUserPresenceTextFromStore,
	userPresenceImage = v6,
	userPresenceText = v5,
	storePresenceImage = if FFlagAppChatPresenceStoreMigration then v8 else nil,
	storePresenceText = if FFlagAppChatPresenceStoreMigration then v7 else nil
}
