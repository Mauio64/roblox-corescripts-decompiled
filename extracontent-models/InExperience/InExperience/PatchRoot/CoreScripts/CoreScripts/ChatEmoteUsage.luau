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

local function reportEmoteUsed(t1: {[any]: any}) -- line: 30
	-- upvalues: RbxAnalyticsService (copy), LocalPlayer (copy), Stats (copy)
	RbxAnalyticsService:SetRBXEventStream("client", "chat", "emoteTriggered", {
		pid = tostring(game.PlaceId),
		uid = tostring(LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		assetID = if not t1.AssetId then nil else tostring(t1.AssetId),
		slotNumber = if not t1.Slot then nil else tostring(t1.Slot)
	})
end
local function reportEmoteFailed(s1: string, t2: {[any]: any}?) -- line: 40
	-- upvalues: RbxAnalyticsService (copy), LocalPlayer (copy), Stats (copy)
	RbxAnalyticsService:SendEventDeferred("client", "chat", "emoteTriggerFailed", {
		invokedByCoreGui = false,
		pid = tostring(game.PlaceId),
		uid = tostring(LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		assetID = if not t2 or not t2.AssetId then nil else tostring(t2.AssetId),
		slotNumber = if not t2 or not t2.Slot then nil else tostring(t2.Slot),
		errorType = s1
	})
end
local function getHumanoidFromPlayer(p1) -- line: 52
	local Character = p1.Character

	if Character then
		return Character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end
local function getHumanoidDescriptionFromPlayer(p2) -- line: 61
	local Character = p2.Character
	local v26 = if not Character then nil else Character:FindFirstChildOfClass("Humanoid")

	if v26 then
		return v26:FindFirstChildOfClass("HumanoidDescription")
	end

	return nil
end
local function getEmoteFromMessage(s2: string) -- line: 70
	if string.sub(s2, 1, 3) == "/e " then
		return string.sub(s2, 4):lower()
	end

	if string.sub(s2, 1, 7) == "/emote " then
		return string.sub(s2, 8):lower()
	end

	return nil
end
local function getEquippedEmoteFromSlot(p3, n1: number) -- line: 80
	local EquippedEmotes = p3:GetEquippedEmotes()

	for _, v in ipairs(EquippedEmotes) do
		if n1 == v.Slot then
			return v
		end
	end

	return nil
end
local function getEmoteFromEquippedEmote(p4, t3: {[any]: any}) -- line: 91
	local Emotes = p4:GetEmotes()

	for k, v in pairs(Emotes) do
		if string.lower(t3.Name) == string.lower(k) then
			return {
				Name = k,
				Slot = t3.Slot,
				AssetId = v[1]
			}
		end
	end

	return nil
end
local function getEmoteFromName(p5, s3: string) -- line: 106
	local Emotes = p5:GetEmotes()

	for k, v in pairs(Emotes) do
		if string.lower(s3) == string.lower(k) then
			return {
				Slot = nil,
				Name = k,
				AssetId = v[1]
			}
		end
	end

	return nil
end
local function getEmoteUsed(p6, s4: string) -- line: 121
	-- upvalues: getEmoteFromEquippedEmote (copy), getEmoteFromName (copy)
	local num = tonumber(s4)

	if num then
		local EquippedEmotes = p6:GetEquippedEmotes()
		local g50 = nil
		local v49 = nil

		for _, v in ipairs(EquippedEmotes) do
			if num == v.Slot then
				v49 = v
				g50 = true
			end

			if g50 then
				break
			end
		end

		if not g50 then
			v49 = nil
		end

		g50 = false

		if v49 then
			return (getEmoteFromEquippedEmote(p6, v49))
		end

		return nil
	end

	return (getEmoteFromName(p6, s4))
end

local t4 = {
	wave = {
		R6 = 128777973,
		R15 = 507770239
	},
	point = {
		R6 = 128853357,
		R15 = 507770453
	},
	dance = {
		R6 = 182435998,
		R15 = 507771019
	},
	dance2 = {
		R6 = 182436842,
		R15 = 507776043
	},
	dance3 = {
		R6 = 182436935,
		R15 = 507777268
	},
	laugh = {
		R6 = 129423131,
		R15 = 507770818
	},
	cheer = {
		R6 = 129423030,
		R15 = 507770677
	}
}

local function getLegacyEmoteUsed(p7, s5: string, t5: {[any]: any}) -- line: 166
	local v54 = p7.RigType == Enum.HumanoidRigType.R15

	return {
		Slot = nil,
		Name = s5,
		AssetId = if not v54 then t5.R6 else t5.R15
	}
end

LocalPlayer.Chatted:Connect(function(message: string, _) -- line: 175
	-- upvalues: t4 (copy), LocalPlayer (copy), getEmoteFromEquippedEmote (copy), getEmoteFromName (copy), reportEmoteUsed (copy), MaybeSendEmoteFailureAnalyticsFromPlayer (copy), reportEmoteFailed (copy), Constants (copy), RbxAnalyticsService (copy), Stats (copy)
	local v57 = if string.sub(message, 1, 3) ~= "/e " then if string.sub(message, 1, 7) ~= "/emote " then nil else string.sub(message, 8):lower() else string.sub(message, 4):lower()

	if v57 then
		local t6 = nil
		local v59 = t4[v57]

		if v59 then
			local Character = LocalPlayer.Character
			local v61 = if not Character then nil else Character:FindFirstChildOfClass("Humanoid")

			if v61 then
				local v62 = v61.RigType == Enum.HumanoidRigType.R15

				t6 = {
					Slot = nil,
					Name = v57,
					AssetId = if not v62 then v59.R6 else v59.R15
				}
			end
		else
			local Character = LocalPlayer.Character
			local v64 = if not Character then nil else Character:FindFirstChildOfClass("Humanoid")
			local v65 = if not v64 then nil else v64:FindFirstChildOfClass("HumanoidDescription")

			if v65 then
				local num = tonumber(v57)

				if num then
					local EquippedEmotes = v65:GetEquippedEmotes()
					local g71 = nil
					local v70 = nil

					for _, v in ipairs(EquippedEmotes) do
						if num == v.Slot then
							v70 = v
							g71 = true
						end

						if g71 then
							break
						end
					end

					if not g71 then
						v70 = nil
					end

					g71 = false
					t6 = if not v70 then nil else getEmoteFromEquippedEmote(v65, v70)
				else
					t6 = getEmoteFromName(v65, v57)
				end
			end
		end

		if t6 then
			reportEmoteUsed(t6)
			MaybeSendEmoteFailureAnalyticsFromPlayer(LocalPlayer, function(p9) -- line: 195
				-- upvalues: reportEmoteFailed (copy), t6 (ref)
				reportEmoteFailed(p9, t6)
			end)
		else
			local NoMatchingEmote = Constants.ErrorTypes.NoMatchingEmote

			RbxAnalyticsService:SendEventDeferred("client", "chat", "emoteTriggerFailed", {
				assetID = nil,
				slotNumber = nil,
				invokedByCoreGui = false,
				pid = tostring(game.PlaceId),
				uid = tostring(LocalPlayer.UserId),
				btid = Stats:GetBrowserTrackerId(),
				errorType = NoMatchingEmote
			})
		end
	end
end)
