local parent = script.Parent.Parent
local ChatSettings = require(parent:WaitForChild("ChatSettings"))
local ChatConstants = require(parent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

function CreateSetCoreMessageLabel(p, _)
	local message = p.Message
	local extraData = p.ExtraData or {}
	local font = extraData.Font or ChatSettings.DefaultFont
	local textSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local color = extraData.Color or ChatSettings.DefaultMessageColor

	local baseMessage, v = Util:CreateBaseMessage(message, font, textSize, color)

	local function GetHeightFunction(p2)
		return Util:GetMessageHeight(v, baseMessage, p2)
	end

	local v2 = {}
	v2[v] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	local fadeFunctions, v3, v4 = Util:CreateFadeFunctions(v2)

	return {
		[Util.KEY_BASE_FRAME] = baseMessage,
		[Util.KEY_BASE_MESSAGE] = v,
		[Util.KEY_UPDATE_TEXT_FUNC] = nil,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = fadeFunctions,
		[Util.KEY_FADE_OUT] = v3,
		[Util.KEY_UPDATE_ANIMATION] = v4
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeSetCore,
	[Util.KEY_CREATOR_FUNCTION] = CreateSetCoreMessageLabel
}
