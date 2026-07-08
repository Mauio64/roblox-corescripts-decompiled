local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

function CreateMeCommandMessageLabel(p1, p2) -- line: 11
	-- upvalues: ChatSettings (copy), Util (copy)
	local _ = p1.Message
	local v8 = p1.ExtraData or {}
	local v9 = v8.Font or Enum.Font.SourceSansItalic
	local v10 = v8.TextSize or ChatSettings.ChatWindowTextSize
	local color3 = Color3.new(1, 1, 1)
	local v12 = v8.ChannelColor or color3
	local n1 = 0
	local v14, v15 = Util:CreateBaseMessage("", v9, v10, color3)
	local v16 = nil

	if p2 ~= p1.OriginalChannel then
		local v17 = string.format("{%s}", p1.OriginalChannel)

		v16 = Util:AddChannelButtonToBaseMessage(v15, v12, v17, p1.OriginalChannel)
		n1 = Util:GetNumberOfSpaces(v17, v9, v10) + 1
	end

	local function UpdateTextFunction(p3) -- line: 29
		-- upvalues: p1 (copy), v15 (copy), Util (copy), n1 (ref)
		if p1.IsFiltered then
			v15.Text = Util:CreateLeadingSpaces(n1) .. Util:SanitizeForRichText(p3.FromSpeaker .. " " .. string.sub(p3.Message, 5))

			return
		end

		local v25 = p3.MessageLengthUtf8 or p3.MessageLength
		local v26 = utf8.len(utf8.nfcnormalize(p3.FromSpeaker)) + v25 - 4

		v15.Text = Util:CreateLeadingSpaces(n1) .. string.rep("_", v26)
	end

	UpdateTextFunction(p1)

	local function GetHeightFunction(p4) -- line: 41
		-- upvalues: Util (copy), v15 (copy), v14 (copy)
		return Util:GetMessageHeight(v15, v14, p4)
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

	local v21, v22, v23 = Util:CreateFadeFunctions(t1)

	return {
		[Util.KEY_BASE_FRAME] = v14,
		[Util.KEY_BASE_MESSAGE] = v15,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v21,
		[Util.KEY_FADE_OUT] = v22,
		[Util.KEY_UPDATE_ANIMATION] = v23
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeMeCommand,
	[Util.KEY_CREATOR_FUNCTION] = CreateMeCommandMessageLabel
}
