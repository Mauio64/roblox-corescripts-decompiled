local Chat = game:GetService("Chat")
local Players = game:GetService("Players")

local parent = script.Parent
local Util = require(parent:WaitForChild("Util"))

local v = nil
pcall(function()
	local ChatLocalization = require(Chat.ClientChatModules.ChatLocalization)
	v = ChatLocalization
end)

if v == nil then
	v = {
		Get = function(self, _, p)
			return p
		end
	}
end

local LocalPlayer = Players.LocalPlayer

local v2 = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local _ = {
	NotSupported = "InGame.Chat.Response.EmotesNotSupported",
	R15Only = "InGame.Chat.Response.EmotesWrongAvatarType",
	SwitchToR15 = "InGame.Chat.ErrorMessageSwitchToR15",
	NoMatchingEmote = "InGame.Chat.Response.EmoteNotAvailable",
	TemporarilyUnavailable = "InGame.Chat.Response.EmotesTemporarilyUnavailable",
	AnimationPlaying = "InGame.Chat.ErrorMessageAnimationPlaying"
}

local v3 = {
	["InGame.Chat.Response.EmotesNotSupported"] = "You can't use Emotes here.",
	["InGame.Chat.Response.EmotesWrongAvatarType"] = "Only R15 avatars can use Emotes.",
	["InGame.Chat.ErrorMessageSwitchToR15"] = "Switch to your R15 avatar to play Emote.",
	["InGame.Chat.Response.EmoteNotAvailable"] = "You can't use that Emote.",
	["InGame.Chat.Response.EmotesTemporarilyUnavailable"] = "You can't use Emotes right now.",
	["InGame.Chat.ErrorMessageAnimationPlaying"] = "You cannot play Emotes during this action."
}

local color = Color3.fromRGB(245, 50, 50)

local function getEmoteName(value) -- 1 equivalent call inferred from this helper
	if string.sub(value, 1, 3) == "/e " then
		return (string.sub(value, 4))
	end

	if string.sub(value, 1, 7) == "/emote " then
		return (string.sub(value, 8))
	end

	return nil
end

local function sendErrorMessage(currentChannel, p) -- 9 equivalent calls inferred from this helper
	Util:SendSystemMessageToSelf(v:Get(p, v3[p]), currentChannel, { ChatColor = color })
end

local function ProcessMessage(value, object, _): boolean
	local emoteName = getEmoteName(value) -- inferred equivalent call

	if not emoteName then
		return false
	end

	if v2[emoteName] then
		return true
	end

	local currentChannel = object:GetCurrentChannel()

	if not currentChannel then
		return true
	end

	local character = LocalPlayer.Character

	if not character then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesTemporarilyUnavailable") -- inferred equivalent call
		return true
	end

	local animate = character:FindFirstChild("Animate")

	if not animate then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesNotSupported") -- inferred equivalent call
		return true
	end

	if not animate:FindFirstChild("PlayEmote") then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesNotSupported") -- inferred equivalent call
		return true
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesTemporarilyUnavailable") -- inferred equivalent call
		return true
	end

	if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesWrongAvatarType") -- inferred equivalent call
		return true
	end

	local humanoidDescription = humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not humanoidDescription then
		sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesTemporarilyUnavailable") -- inferred equivalent call
		return true
	end

	local emotes = humanoidDescription:GetEmotes()
	local v4 = {}

	for k, _ in pairs(emotes) do
		v4[string.lower(k)] = k
	end

	local v5 = tonumber(emoteName)

	if v5 then
		local equippedEmotes = humanoidDescription:GetEquippedEmotes()

		for _, equippedEmote in pairs(equippedEmotes) do
			if equippedEmote.Slot == v5 then
				emoteName = equippedEmote.Name
			end
		end
	end

	local v6 = v4[string.lower(emoteName)]

	if v6 then
		spawn(function()
			local success, result = pcall(function()
				return humanoid:PlayEmote(v6)
			end)

			if success then
				if not result then
					sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesTemporarilyUnavailable") -- inferred equivalent call
				end
			else
				sendErrorMessage(currentChannel, "InGame.Chat.Response.EmotesNotSupported") -- inferred equivalent call
			end
		end)

		return true
	end

	sendErrorMessage(currentChannel, "InGame.Chat.Response.EmoteNotAvailable") -- inferred equivalent call
	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
