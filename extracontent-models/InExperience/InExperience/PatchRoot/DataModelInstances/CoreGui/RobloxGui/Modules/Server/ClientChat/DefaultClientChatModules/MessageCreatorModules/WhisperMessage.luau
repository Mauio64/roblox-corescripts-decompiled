local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local parent = script.Parent.Parent
local ChatSettings = require(parent:WaitForChild("ChatSettings"))
local ChatConstants = require(parent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

local v = utf8.char(57344)

local ChatLocalization = nil

pcall(function()
	local Chat = game:GetService("Chat")
	ChatLocalization = require(Chat.ClientChatModules.ChatLocalization)
end)

function IsPlayerVerified(p)
	local playerByUserId = Players:GetPlayerByUserId(p)

	if not playerByUserId then
		return false
	end

	local success, result = pcall(function()
		return playerByUserId.HasVerifiedBadge
	end)
	return if success then result else false
end

function AppendVerifiedBadge(p)
	return p .. v
end

function CreateMessageLabel(data, p)
	local fromSpeaker = data.FromSpeaker
	local v2

	if ChatSettings.PlayerDisplayNamesEnabled and data.SpeakerDisplayName then
		v2 = data.SpeakerDisplayName
	else
		v2 = fromSpeaker
	end

	local speakerUserId = data.SpeakerUserId

	if IsPlayerVerified(speakerUserId) then
		v2 = AppendVerifiedBadge(v2)
	end

	local _message = data.Message

	local extraData = data.ExtraData or {}
	local font = extraData.Font or ChatSettings.DefaultFont
	local textSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local nameColor = extraData.NameColor or ChatSettings.DefaultNameColor
	local chatColor = extraData.ChatColor or ChatSettings.DefaultMessageColor
	local channelColor = extraData.ChannelColor or chatColor

	local v3 = string.format("[%s]:", v2)
	Util:GetStringTextBounds(v3, font, textSize)
	local v4 = Util:GetNumberOfSpaces(v3, font, textSize) + 1

	local baseMessage, v5 = Util:CreateBaseMessage("", font, textSize, chatColor)
	local v6 = Util:AddNameButtonToBaseMessage(v5, nameColor, v3, fromSpeaker)
	local v7

	if p ~= data.OriginalChannel then
		local v8 = data.OriginalChannel

		if data.FromSpeaker ~= LocalPlayer.Name then
			v8 = string.format("From %s", data.FromSpeaker)
		end

		if ChatLocalization.tryLocalize then
			v8 = ChatLocalization:tryLocalize(v8)
		end

		local v9 = string.format("{%s}", v8)
		v7 = Util:AddChannelButtonToBaseMessage(v5, channelColor, v9, data.OriginalChannel)
		v6.Position = UDim2.new(0, v7.Size.X.Offset + Util:GetStringTextBounds(" ", font, textSize).X, 0, 0)
		v4 = v4 + Util:GetNumberOfSpaces(v9, font, textSize) + 1
	end

	local function UpdateTextFunction(data2)
		if data.IsFiltered then
			v5.Text = Util:CreateLeadingSpaces(v4) .. Util:SanitizeForRichText(data2.Message)
			return
		end

		local messageLengthUtf8 = data2.MessageLengthUtf8 or data2.MessageLength
		v5.Text = Util:CreateLeadingSpaces(v4) .. string.rep("_", messageLengthUtf8)
	end

	UpdateTextFunction(data)

	local function GetHeightFunction(p2)
		return Util:GetMessageHeight(v5, baseMessage, p2)
	end

	local v8 = {}
	v8[v6] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	v8[v5] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	if v7 then
		v8[v7] = {
			TextTransparency = { FadedIn = 0, FadedOut = 1 },
			TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
		}
	end

	local fadeFunctions, v9, v10 = Util:CreateFadeFunctions(v8)

	return {
		[Util.KEY_BASE_FRAME] = baseMessage,
		[Util.KEY_BASE_MESSAGE] = v5,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = fadeFunctions,
		[Util.KEY_FADE_OUT] = v9,
		[Util.KEY_UPDATE_ANIMATION] = v10
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeWhisper,
	[Util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
