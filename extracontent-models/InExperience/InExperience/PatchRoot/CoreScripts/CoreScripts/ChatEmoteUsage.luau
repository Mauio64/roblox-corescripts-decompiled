local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
game:GetService("CorePackages")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local Constants = require(CoreGui.RobloxGui.Modules.EmotesMenu.Constants)

local MaybeSendEmoteFailureAnalyticsFromPlayer = require(CoreGui.RobloxGui.Modules.EmotesMenu.Utility.MaybeSendEmoteFailureAnalyticsFromPlayer)

while Players.LocalPlayer == nil do
	wait()
end

local LocalPlayer = Players.LocalPlayer

local function reportEmoteUsed(p)
	local v = {
		pid = tostring(game.PlaceId),
		uid = tostring(LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		assetID = 0,
		slotNumber = 0
	}
	local assetID

	if p.AssetId then
		assetID = tostring(p.AssetId)
	end

	v.assetID = assetID
	local slotNumber

	if p.Slot then
		slotNumber = tostring(p.Slot)
	end

	v.slotNumber = slotNumber
	RbxAnalyticsService:SetRBXEventStream("client", "chat", "emoteTriggered", v)
end

local function reportEmoteFailed(errorType: string, p)
	local v = {
		pid = tostring(game.PlaceId),
		uid = tostring(LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		assetID = 0,
		slotNumber = 0,
		errorType = 0,
		invokedByCoreGui = false
	}
	local assetID

	if p and p.AssetId then
		assetID = tostring(p.AssetId)
	end

	v.assetID = assetID
	local slotNumber

	if p and p.Slot then
		slotNumber = tostring(p.Slot)
	end

	v.slotNumber = slotNumber
	v.errorType = errorType
	RbxAnalyticsService:SendEventDeferred("client", "chat", "emoteTriggerFailed", v)
end

local function getHumanoidFromPlayer(player) -- 2 equivalent calls inferred from this helper
	local character = player.Character

	if character then
		return character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

local function getHumanoidDescriptionFromPlayer(localPlayer) -- 1 equivalent call inferred from this helper
	local humanoidFromPlayer = getHumanoidFromPlayer(localPlayer) -- inferred equivalent call

	if humanoidFromPlayer then
		return humanoidFromPlayer:FindFirstChildOfClass("HumanoidDescription")
	end

	return nil
end

local function getEmoteFromMessage(value: string) -- 1 equivalent call inferred from this helper
	if string.sub(value, 1, 3) == "/e " then
		return string.sub(value, 4):lower()
	end

	if string.sub(value, 1, 7) == "/emote " then
		return string.sub(value, 8):lower()
	end

	return nil
end

local function getEquippedEmoteFromSlot(object, p: number) -- 1 equivalent call inferred from this helper
	local equippedEmotes = object:GetEquippedEmotes()

	for _, equippedEmote in ipairs(equippedEmotes) do
		if equippedEmote.Slot == p then
			return equippedEmote
		end
	end

	return nil
end

local function getEmoteFromEquippedEmote(object, equippedEmoteFromSlot)
	local emotes = object:GetEmotes()

	for k, emote in pairs(emotes) do
		if string.lower(equippedEmoteFromSlot.Name) == string.lower(k) then
			return { Name = k, Slot = equippedEmoteFromSlot.Slot, AssetId = emote[1] }
		end
	end

	return nil
end

local function getEmoteFromName(object, value: string)
	local emotes = object:GetEmotes()

	for k, emote in pairs(emotes) do
		if string.lower(value) == string.lower(k) then
			return { Name = k, Slot = nil, AssetId = emote[1] }
		end
	end

	return nil
end

local function getEmoteUsed(humanoidDescriptionFromPlayer, emoteFromMessage: string) -- 1 equivalent call inferred from this helper
	local v = tonumber(emoteFromMessage)

	if not v then
		return getEmoteFromName(humanoidDescriptionFromPlayer, emoteFromMessage)
	end

	local equippedEmoteFromSlot = getEquippedEmoteFromSlot(humanoidDescriptionFromPlayer, v) -- inferred equivalent call

	if equippedEmoteFromSlot then
		return getEmoteFromEquippedEmote(humanoidDescriptionFromPlayer, equippedEmoteFromSlot)
	end

	return nil
end

local v = {
	wave = { R6 = 128777973, R15 = 507770239 },
	point = { R6 = 128853357, R15 = 507770453 },
	dance = { R6 = 182435998, R15 = 507771019 },
	dance2 = { R6 = 182436842, R15 = 507776043 },
	dance3 = { R6 = 182436935, R15 = 507777268 },
	laugh = { R6 = 129423131, R15 = 507770818 },
	cheer = { R6 = 129423030, R15 = 507770677 }
}

local function getLegacyEmoteUsed(p, name: string, p2)
	local assetId

	if p.RigType == Enum.HumanoidRigType.R15 then
		assetId = p2.R15
	else
		assetId = p2.R6
	end

	return { Name = name, Slot = nil, AssetId = assetId }
end

LocalPlayer.Chatted:Connect(function(value: string, _)
	local emoteFromMessage = getEmoteFromMessage(value) -- inferred equivalent call

	if emoteFromMessage then
		local v2 = nil

		local v3 = v[emoteFromMessage]

		if v3 then
			local humanoidFromPlayer = getHumanoidFromPlayer(LocalPlayer) -- inferred equivalent call

			if humanoidFromPlayer then
				v2 = { Name = emoteFromMessage, Slot = nil, AssetId = 0 }
				local assetId

				if humanoidFromPlayer.RigType == Enum.HumanoidRigType.R15 then
					assetId = v3.R15
				else
					assetId = v3.R6
				end

				v2.AssetId = assetId
			end
		else
			local humanoidDescriptionFromPlayer = getHumanoidDescriptionFromPlayer(LocalPlayer) -- inferred equivalent call

			if humanoidDescriptionFromPlayer then
				v2 = getEmoteUsed(humanoidDescriptionFromPlayer, emoteFromMessage) -- inferred equivalent call
			end
		end

		if v2 then
			reportEmoteUsed(v2)
			MaybeSendEmoteFailureAnalyticsFromPlayer(LocalPlayer, function(errorType)
				reportEmoteFailed(errorType, v2)
			end)
		else
			local noMatchingEmote = Constants.ErrorTypes.NoMatchingEmote
			RbxAnalyticsService:SendEventDeferred("client", "chat", "emoteTriggerFailed", {
				pid = tostring(game.PlaceId),
				uid = tostring(LocalPlayer.UserId),
				btid = Stats:GetBrowserTrackerId(),
				assetID = nil,
				slotNumber = nil,
				errorType = noMatchingEmote,
				invokedByCoreGui = false
			})
		end
	end
end)
