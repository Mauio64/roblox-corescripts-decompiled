local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v = success and result

local Players = game:GetService("Players")

local parent = script.Parent.Parent
local ChatSettings = require(parent:WaitForChild("ChatSettings"))
local ChatConstants = require(parent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))

local v2 = utf8.char(57344)

function IsPlayerVerified(p)
	local playerByUserId = Players:GetPlayerByUserId(p)

	if not playerByUserId then
		return false
	end

	local success2, result2 = pcall(function()
		return playerByUserId.HasVerifiedBadge
	end)
	return if success2 then result2 else false
end

function AppendVerifiedBadge(p)
	return p .. v2
end

function CreateMessageLabel(state, p, callback)
	local fromSpeaker = state.FromSpeaker
	local v3

	if ChatSettings.PlayerDisplayNamesEnabled and state.SpeakerDisplayName then
		v3 = state.SpeakerDisplayName
	else
		v3 = fromSpeaker
	end

	local speakerUserId = state.SpeakerUserId

	if IsPlayerVerified(speakerUserId) then
		v3 = AppendVerifiedBadge(v3)
	end

	local _message = state.Message

	local extraData = state.ExtraData or {}
	local font = extraData.Font or ChatSettings.DefaultFont
	local textSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local nameColor = extraData.NameColor or ChatSettings.DefaultNameColor
	local chatColor = extraData.ChatColor or ChatSettings.DefaultMessageColor
	local channelColor = extraData.ChannelColor or chatColor
	local tags = extraData.Tags or {}

	local v4 = string.format("[%s]:", v3)
	Util:GetStringTextBounds(v4, font, textSize)
	local v5 = Util:GetNumberOfSpaces(v4, font, textSize) + 1

	local baseMessage, v6 = Util:CreateBaseMessage("", font, textSize, chatColor)
	local v7 = Util:AddNameButtonToBaseMessage(v6, nameColor, v4, fromSpeaker)

	local udim = UDim2.new(0, 0, 0, 0)
	local v8

	if p ~= state.OriginalChannel then
		local v9 = string.format("{%s}", state.OriginalChannel)
		v8 = Util:AddChannelButtonToBaseMessage(v6, channelColor, v9, state.OriginalChannel)
		udim = UDim2.new(0, v8.Size.X.Offset + Util:GetStringTextBounds(" ", font, textSize).X, 0, 0)
		v5 = v5 + Util:GetNumberOfSpaces(v9, font, textSize) + 1
	end

	local v9 = {}

	for _, tag in pairs(tags) do
		local tagColor = tag.TagColor or Color3.fromRGB(255, 0, 255)
		local tagText = tag.TagText or "???"
		local v10 = string.format("[%s] ", tagText)
		local v11 = Util:AddTagLabelToBaseMessage(v6, tagColor, v10)
		v11.Position = udim

		v5 += Util:GetNumberOfSpaces(v10, font, textSize)
		udim += UDim2.new(0, v11.Size.X.Offset, 0, 0)

		table.insert(v9, v11)
	end

	v7.Position = udim

	local v10 = false
	local v11 = nil

	if v then
		pcall(function()
			v11 = Util:AddTranslationButtonToBaseMessage(v6)
			udim += UDim2.new(0, v7.Size.X.Offset + 2, 0, 0)
			v11.Position = udim
		end)
	end

	local function useOriginalText(data)
		v10 = false

		if state.IsFiltered then
			v6.Text = Util:CreateLeadingSpaces(v5) .. Util:SanitizeForRichText(data.Message)
			return
		end

		local messageLengthUtf8 = data.MessageLengthUtf8 or data.MessageLength
		v6.Text = Util:CreateLeadingSpaces(v5) .. string.rep("_", messageLengthUtf8)
	end

	local function useTranslatedText(p2) -- 2 equivalent calls inferred from this helper
		if v11 == nil then
			return
		end

		if v11.Visible == false then
			v5 += 6
		end

		v11.Visible = true
		v10 = true

		if p2.TranslatedMessage == "" then
			useOriginalText(p2)
		else
			v6.Text = Util:CreateLeadingSpaces(v5) .. Util:SanitizeForRichText(p2.TranslatedMessage)
		end
	end

	local function UpdateTextFunction_Chat(data) -- 1 equivalent call inferred from this helper
		state.TranslatedMessage = data.TranslatedMessage

		if not data.TranslatedMessage then
			useOriginalText(data)

			return
		end

		useTranslatedText(data) -- inferred equivalent call
	end

	local function UpdateTextFunction(data)
		if v then
			UpdateTextFunction_Chat(data) -- inferred equivalent call
		else
			if state.IsFiltered then
				v6.Text = Util:CreateLeadingSpaces(v5) .. Util:SanitizeForRichText(data.Message)
				return
			end

			local messageLengthUtf8 = data.MessageLengthUtf8 or data.MessageLength
			v6.Text = Util:CreateLeadingSpaces(v5) .. string.rep("_", messageLengthUtf8)
		end
	end

	local function toggleTranslation() -- 1 equivalent call inferred from this helper
		if v10 or not state.TranslatedMessage then
			useOriginalText(state)
		else
			useTranslatedText(state) -- inferred equivalent call
		end

		if callback then
			callback()
		end
	end

	if v and v11 ~= nil then
		local mouseButton1ClickConnection = v11.MouseButton1Click:connect(function()
			toggleTranslation() -- inferred equivalent call
		end)

		local changedConnection = nil
		changedConnection = v11.Changed:connect(function(p2)
			if p2 == "Parent" then
				mouseButton1ClickConnection:Disconnect()
				changedConnection:Disconnect()
			end
		end)
	end

	UpdateTextFunction(state)

	local function GetHeightFunction(p2)
		return Util:GetMessageHeight(v6, baseMessage, p2)
	end

	local v12 = {}
	v12[v7] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	if v and v11 ~= nil then
		v12[v11] = {
			ImageTransparency = { FadedIn = 0, FadedOut = 1 }
		}
	end

	v12[v6] = {
		TextTransparency = { FadedIn = 0, FadedOut = 1 },
		TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
	}

	for k, v13 in pairs(v9) do
		string.format("Tag%d", k)
		v12[v13] = {
			TextTransparency = { FadedIn = 0, FadedOut = 1 },
			TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
		}
	end

	if v8 then
		v12[v8] = {
			TextTransparency = { FadedIn = 0, FadedOut = 1 },
			TextStrokeTransparency = { FadedIn = 0.75, FadedOut = 1 }
		}
	end

	local fadeFunctions, v13, v14 = Util:CreateFadeFunctions(v12)

	return {
		[Util.KEY_BASE_FRAME] = baseMessage,
		[Util.KEY_BASE_MESSAGE] = v6,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = fadeFunctions,
		[Util.KEY_FADE_OUT] = v13,
		[Util.KEY_UPDATE_ANIMATION] = v14
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeDefault,
	[Util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
