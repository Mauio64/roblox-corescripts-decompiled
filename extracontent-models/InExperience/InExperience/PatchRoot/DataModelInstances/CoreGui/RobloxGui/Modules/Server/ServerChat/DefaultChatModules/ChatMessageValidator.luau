local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))

local v = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {}
end

if not (v.FormatMessageToSend and v.LocalizeFormattedMessage) then
	function v:FormatMessageToSend(_, p)
		return p
	end
end

local v2 = not ChatSettings.DisallowedWhiteSpace and { "\n", "\r", "\t", "\11", "\f" }
	or ChatSettings.DisallowedWhiteSpace

local function isMessageValidServer(value): boolean
	if value:len() > ChatSettings.MaximumMessageLength * 6 or utf8.len(value) == nil then
		return false
	end

	return not (utf8.len(utf8.nfcnormalize(value)) > ChatSettings.MaximumMessageLength)
end

local function CanUserChat(player) -- 1 equivalent call inferred from this helper
	if RunService:IsStudio() then
		return true
	end

	local success, result = pcall(function()
		return Chat:CanUserChatAsync(player.UserId)
	end)

	return success and result
end

local function Run(object)
	local function ValidateChatFunction(p, value, p2): boolean
		local speaker = object:GetSpeaker(p)
		local player = speaker:GetPlayer()

		if not (speaker and player) then
			return false
		end

		if not RunService:IsStudio() and player.UserId < 1 then
			return true
		end

		if not CanUserChat(player) then -- inferred equivalent call
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatMessageValidator_SettingsError",
					"Your chat settings prevent you from sending messages."
				),
				p2
			)

			return true
		end

		if not isMessageValidServer(value) then
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatMessageValidator_MaxLengthError",
					"Your message exceeds the maximum message length."
				),
				p2
			)
			return true
		end

		for _, v3 in pairs(v2) do
			if value:find(v3) then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_ChatMessageValidator_WhitespaceError",
						"Your message contains whitespace that is not allowed."
					),
					p2
				)

				return true
			end
		end

		return false
	end

	object:RegisterProcessCommandsFunction("message_validation", ValidateChatFunction, ChatConstants.VeryHighPriority)
end

return Run
