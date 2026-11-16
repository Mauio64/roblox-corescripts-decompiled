local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local UIBlox = require(parent.UIBlox)
local component_assetscircle_25 = UIBlox.App.ImageSet.Images["component_assets/circle_25"]

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local presenceType = DataHydration.Presence.PresenceEnums.PresenceType

local userPresenceText = {
	[PresenceType.Offline] = "Common.Presence.Label.Offline",
	[PresenceType.Online] = "Common.Presence.Label.Online",
	[PresenceType.InGame] = "",
	[PresenceType.InStudio] = ""
}

local userPresenceImage = {
	[PresenceType.Offline] = "",
	[PresenceType.Online] = component_assetscircle_25,
	[PresenceType.InGame] = component_assetscircle_25,
	[PresenceType.InStudio] = component_assetscircle_25
}

local v = {
	Offline = "Common.Presence.Label.Offline",
	Online = "Common.Presence.Label.Online",
	InGame = "",
	InStudio = ""
}

local v2 = {
	Offline = "",
	Online = component_assetscircle_25,
	InGame = component_assetscircle_25,
	InStudio = component_assetscircle_25
}

local function getUserPresenceTextFromStore(p) -- 1 equivalent call inferred from this helper
	local userPresenceType = p.userPresenceType
	local lastLocation = p.lastLocation

	if userPresenceType == presenceType.Offline then
		return v[presenceType.Offline]
	end

	if userPresenceType == presenceType.Online then
		return v[presenceType.Online]
	end

	if userPresenceType ~= presenceType.InGame and userPresenceType ~= presenceType.InStudio then
		return ""
	end

	if lastLocation and lastLocation ~= "" then
		return (tostring(lastLocation))
	end

	return v[presenceType.Online]
end

local function getUserDisplayPresenceFromStoreData(p, flag: boolean?)
	if not p then
		return { text = "" }
	end

	if flag then
		return { text = v[presenceType.Online], image = v2[presenceType.Online] }
	end

	return {
		text = getUserPresenceTextFromStore(p), -- inferred equivalent call
		image = v2[p.userPresenceType]
	}
end

local UserPresenceUtils = {
	getUserDisplayPresence = not FFlagAppChatPresenceStoreMigration and function(p, flag: boolean?)
		if not p then
			return { text = "" }
		end

		local v3 = flag
			and {
				text = userPresenceText[PresenceType.Online],
				image = userPresenceImage[PresenceType.Online]
			}

		if v3 then
			return v3
		end

		v3 = { text = 0, image = 0 }
		local userPresenceType = p.userPresenceType
		local lastLocation = p.lastLocation
		local text

		if userPresenceType == PresenceType.Offline then
			text = userPresenceText[PresenceType.Offline]
		elseif userPresenceType == PresenceType.Online then
			text = userPresenceText[PresenceType.Online]
		elseif userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
			if lastLocation then
				text = tostring(lastLocation)
			else
				text = userPresenceText[PresenceType.Online]
			end
		else
			text = ""
		end

		v3.text = text
		v3.image = userPresenceImage[p.userPresenceType]
		return v3
	end or getUserDisplayPresenceFromStoreData,
	getUserPresenceText = not FFlagAppChatPresenceStoreMigration and function(p)
		local userPresenceType = p.userPresenceType
		local lastLocation = p.lastLocation

		if userPresenceType == PresenceType.Offline then
			return userPresenceText[PresenceType.Offline]
		end

		if userPresenceType == PresenceType.Online then
			return userPresenceText[PresenceType.Online]
		end

		if userPresenceType ~= PresenceType.InGame and userPresenceType ~= PresenceType.InStudio then
			return ""
		end

		if lastLocation then
			return (tostring(lastLocation))
		end

		return userPresenceText[PresenceType.Online]
	end or getUserPresenceTextFromStore,
	userPresenceImage = userPresenceImage,
	userPresenceText = userPresenceText,
	storePresenceImage = 0,
	storePresenceText = 0
}
local storePresenceImage

if FFlagAppChatPresenceStoreMigration then
	storePresenceImage = v2
end

UserPresenceUtils.storePresenceImage = storePresenceImage
local storePresenceText

if FFlagAppChatPresenceStoreMigration then
	storePresenceText = v
end

UserPresenceUtils.storePresenceText = storePresenceText
return UserPresenceUtils
