local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

pcall(function() -- line: 12
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

function CreateWelcomeMessageLabel(p1, p2) -- line: 14
	-- upvalues: ChatSettings (copy), Util (copy)
	local p1Message = p1.Message

	if ChatLocalization and ChatLocalization.LocalizeFormattedMessage then
		p1Message = ChatLocalization:LocalizeFormattedMessage(p1Message)
	end

	local v8 = p1.ExtraData or {}
	local v9 = v8.Font or ChatSettings.DefaultFont
	local v10 = v8.FontSize or ChatSettings.ChatWindowTextSize
	local v11 = v8.ChatColor or ChatSettings.DefaultMessageColor
	local v12 = v8.ChannelColor or v11
	local v13, v14 = Util:CreateBaseMessage(p1Message, v9, v10, v11)
	local v15 = nil

	if p2 ~= p1.OriginalChannel then
		local OriginalChannel = p1.OriginalChannel

		if ChatLocalization.tryLocalize then
			OriginalChannel = ChatLocalization:tryLocalize(p1.OriginalChannel)
		end

		local v17 = string.format("{%s}", OriginalChannel)

		v15 = Util:AddChannelButtonToBaseMessage(v14, v12, v17, p1.OriginalChannel)

		local v18 = Util:GetNumberOfSpaces(v17, v9, v10) + 1

		v14.Text = Util:CreateLeadingSpaces(v18) .. Util:SanitizeForRichText(p1Message)
	end

	local function GetHeightFunction(p3) -- line: 39
		-- upvalues: Util (copy), v14 (copy), v13 (copy)
		return Util:GetMessageHeight(v14, v13, p3)
	end

	local t1 = {
		[v14] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		}
	}

	if v15 then
		t1[v15] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		}
	end

	local v21, v22, v23 = Util:CreateFadeFunctions(t1)

	return {
		[Util.KEY_BASE_FRAME] = v13,
		[Util.KEY_BASE_MESSAGE] = v14,
		[Util.KEY_UPDATE_TEXT_FUNC] = nil,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v21,
		[Util.KEY_FADE_OUT] = v22,
		[Util.KEY_UPDATE_ANIMATION] = v23
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeWelcome,
	[Util.KEY_CREATOR_FUNCTION] = CreateWelcomeMessageLabel
}
