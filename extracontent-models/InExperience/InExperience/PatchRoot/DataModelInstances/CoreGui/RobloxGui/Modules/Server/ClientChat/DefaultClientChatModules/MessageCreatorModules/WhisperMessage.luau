local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))
local v7 = utf8.char(57344)
local ChatLocalization = nil

pcall(function() -- line: 22
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

function IsPlayerVerified(p1) -- line: 24
	-- upvalues: Players (copy)
	local PlayerByUserId = Players:GetPlayerByUserId(p1)

	if not PlayerByUserId then
		return false
	end

	local ok, result = pcall(function() -- line: 31
		-- upvalues: PlayerByUserId (copy)
		return PlayerByUserId.HasVerifiedBadge
	end)

	if ok then
		return result
	end

	return false
end
function AppendVerifiedBadge(p2) -- line: 38
	-- upvalues: v7 (copy)
	return p2 .. v7
end
function CreateMessageLabel(p3, p4) -- line: 42
	-- upvalues: ChatSettings (copy), Util (copy), LocalPlayer (ref), ChatLocalization (ref)
	local FromSpeaker = p3.FromSpeaker
	local v17 = if not ChatSettings.PlayerDisplayNamesEnabled or not p3.SpeakerDisplayName then FromSpeaker else p3.SpeakerDisplayName
	local SpeakerUserId = p3.SpeakerUserId

	if IsPlayerVerified(SpeakerUserId) then
		v17 = AppendVerifiedBadge(v17)
	end

	local _ = p3.Message
	local v20 = p3.ExtraData or {}
	local v21 = v20.Font or ChatSettings.DefaultFont
	local v22 = v20.TextSize or ChatSettings.ChatWindowTextSize
	local v23 = v20.NameColor or ChatSettings.DefaultNameColor
	local v24 = v20.ChatColor or ChatSettings.DefaultMessageColor
	local v25 = v20.ChannelColor or v24
	local v26 = string.format("[%s]:", v17)

	Util:GetStringTextBounds(v26, v21, v22)

	local u27 = Util:GetNumberOfSpaces(v26, v21, v22) + 1
	local v28, v29 = Util:CreateBaseMessage("", v21, v22, v24)
	local v30 = Util:AddNameButtonToBaseMessage(v29, v23, v26, FromSpeaker)
	local v31 = nil

	if p4 ~= p3.OriginalChannel then
		local OriginalChannel = p3.OriginalChannel

		if p3.FromSpeaker ~= LocalPlayer.Name then
			OriginalChannel = string.format("From %s", p3.FromSpeaker)
		end

		if ChatLocalization.tryLocalize then
			OriginalChannel = ChatLocalization:tryLocalize(OriginalChannel)
		end

		local v33 = string.format("{%s}", OriginalChannel)

		v31 = Util:AddChannelButtonToBaseMessage(v29, v25, v33, p3.OriginalChannel)
		v30.Position = UDim2.new(0, v31.Size.X.Offset + Util:GetStringTextBounds(" ", v21, v22).X, 0, 0)
		u27 = u27 + Util:GetNumberOfSpaces(v33, v21, v22) + 1
	end

	local function UpdateTextFunction(p5) -- line: 92
		-- upvalues: p3 (copy), v29 (copy), Util (copy), u27 (ref)
		if p3.IsFiltered then
			v29.Text = Util:CreateLeadingSpaces(u27) .. Util:SanitizeForRichText(p5.Message)

			return
		end

		local v41 = p5.MessageLengthUtf8 or p5.MessageLength

		v29.Text = Util:CreateLeadingSpaces(u27) .. string.rep("_", v41)
	end

	UpdateTextFunction(p3)

	local function GetHeightFunction(p6) -- line: 103
		-- upvalues: Util (copy), v29 (copy), v28 (copy)
		return Util:GetMessageHeight(v29, v28, p6)
	end

	local t1 = {
		[v30] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		},
		[v29] = {
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

	if v31 then
		t1[v31] = {
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

	local v37, v38, v39 = Util:CreateFadeFunctions(t1)

	return {
		[Util.KEY_BASE_FRAME] = v28,
		[Util.KEY_BASE_MESSAGE] = v29,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v37,
		[Util.KEY_FADE_OUT] = v38,
		[Util.KEY_UPDATE_ANIMATION] = v39
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeWhisper,
	[Util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
