local parent = script.Parent.Parent
local ChatSettings = require(parent:WaitForChild("ChatSettings"))
local ChatConstants = require(parent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

function CreateMeCommandMessageLabel(data, p)
	local _message = data.Message
	local extraData = data.ExtraData or {}
	local font = extraData.Font or Enum.Font.SourceSansItalic
	local textSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local color = Color3.new(1, 1, 1)
	local channelColor = extraData.ChannelColor or color

	local baseMessage, v = Util:CreateBaseMessage("", font, textSize, color)
	local v2, v3

	if p == data.OriginalChannel then
		v2 = 0
	else
		local v4 = string.format("{%s}", data.OriginalChannel)
		v3 = Util:AddChannelButtonToBaseMessage(v, channelColor, v4, data.OriginalChannel)
		v2 = Util:GetNumberOfSpaces(v4, font, textSize) + 1
	end

	local function UpdateTextFunction(data2)
		if data.IsFiltered then
			v.Text = Util:CreateLeadingSpaces(v2) .. Util:SanitizeForRichText(data2.FromSpeaker .. " " .. string.sub(data2.Message, 5))
			return
		end

		local messageLengthUtf8 = data2.MessageLengthUtf8 or data2.MessageLength
		local v4 = utf8.len(utf8.nfcnormalize(data2.FromSpeaker)) + messageLengthUtf8 - 4
		v.Text = Util:CreateLeadingSpaces(v2) .. string.rep("_", v4)
	end

	UpdateTextFunction(data)

	local function GetHeightFunction(p2)
		return Util:GetMessageHeight(v, baseMessage, p2)
	end

	local v4 = {}
	v4[v] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	if v3 then
		v4[v3] = {
			TextTransparency = { FadedIn = 0, FadedOut = 1 },
			TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
		}
	end

	local fadeFunctions, v5, v6 = Util:CreateFadeFunctions(v4)

	return {
		[Util.KEY_BASE_FRAME] = baseMessage,
		[Util.KEY_BASE_MESSAGE] = v,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = fadeFunctions,
		[Util.KEY_FADE_OUT] = v5,
		[Util.KEY_UPDATE_ANIMATION] = v6
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeMeCommand,
	[Util.KEY_CREATOR_FUNCTION] = CreateMeCommandMessageLabel
}
