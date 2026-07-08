local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

function CreateSetCoreMessageLabel(p1, _) -- line: 11
	-- upvalues: ChatSettings (copy), Util (copy)
	local p1Message = p1.Message
	local v8 = p1.ExtraData or {}
	local v9 = v8.Font or ChatSettings.DefaultFont
	local v10 = v8.TextSize or ChatSettings.ChatWindowTextSize
	local v11 = v8.Color or ChatSettings.DefaultMessageColor
	local v12, v13 = Util:CreateBaseMessage(p1Message, v9, v10, v11)

	local function GetHeightFunction(p3) -- line: 20
		-- upvalues: Util (copy), v13 (copy), v12 (copy)
		return Util:GetMessageHeight(v13, v12, p3)
	end

	local t1 = {
		[v13] = {
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
	local v16, v17, v18 = Util:CreateFadeFunctions(t1)

	return {
		[Util.KEY_BASE_FRAME] = v12,
		[Util.KEY_BASE_MESSAGE] = v13,
		[Util.KEY_UPDATE_TEXT_FUNC] = nil,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v16,
		[Util.KEY_FADE_OUT] = v17,
		[Util.KEY_UPDATE_ANIMATION] = v18
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeSetCore,
	[Util.KEY_CREATOR_FUNCTION] = CreateSetCoreMessageLabel
}
