local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 12
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

function CreateSystemMessageLabel(p1, p2) -- line: 14
	-- upvalues: ChatLocalization (ref), ChatSettings (copy), Util (copy)
	local p1Message = p1.Message

	if ChatLocalization and ChatLocalization.LocalizeFormattedMessage then
		p1Message = ChatLocalization:LocalizeFormattedMessage(p1Message)
	end

	local v9 = p1.ExtraData or {}
	local v10 = v9.Font or ChatSettings.DefaultFont
	local v11 = v9.TextSize or ChatSettings.ChatWindowTextSize
	local v12 = v9.ChatColor or ChatSettings.DefaultMessageColor
	local v13 = v9.ChannelColor or v12
	local v14, v15 = Util:CreateBaseMessage(p1Message, v10, v11, v12)

	v15.AutoLocalize = true

	local v16 = nil

	if p2 ~= p1.OriginalChannel then
		local v18

		if ChatLocalization and p1.OriginalChannel == "System" then
			local v17 = ChatLocalization:Get("InGame.Chat.Label.SystemMessagePrefix", "System")

			v18 = string.format("{%s}", v17)
		elseif ChatLocalization and p1.OriginalChannel == "Team" then
			local v19 = ChatLocalization:Get("InGame.Chat.Label.TeamMessagePrefix", "System")

			v18 = string.format("{%s}", v19)
		else
			v18 = string.format("{%s}", p1.OriginalChannel)
		end

		v16 = Util:AddChannelButtonToBaseMessage(v15, v13, v18, p1.OriginalChannel)

		local v20 = Util:GetNumberOfSpaces(v18, v10, v11) + 1

		v15.Text = Util:CreateLeadingSpaces(v20) .. Util:SanitizeForRichText(p1Message)
	end

	local function GetHeightFunction(p3) -- line: 45
		-- upvalues: Util (copy), v15 (copy), v14 (copy)
		return Util:GetMessageHeight(v15, v14, p3)
	end

	local t1 = {
		[v15] = {
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

	if v16 then
		t1[v16] = {
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

	local v23, v24, v25 = Util:CreateFadeFunctions(t1)

	return {
		[Util.KEY_BASE_FRAME] = v14,
		[Util.KEY_BASE_MESSAGE] = v15,
		[Util.KEY_UPDATE_TEXT_FUNC] = nil,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v23,
		[Util.KEY_FADE_OUT] = v24,
		[Util.KEY_UPDATE_ANIMATION] = v25
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeSystem,
	[Util.KEY_CREATOR_FUNCTION] = CreateSystemMessageLabel
}
