local TextChatService = game:GetService("TextChatService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local v6 = require(ExpChatShared.Logger):new("ExpChat/Command/Whisper")
local Actions = ExpChatShared.Actions
local ChatInputBarActivatedWhisperMode = require(Actions.ChatInputBarActivatedWhisperMode)
local Commands = script:FindFirstAncestor("Commands")
local getAutocompletePlayersFromString = require(Commands.getAutocompletePlayersFromString)
local getNameFromWhisper = require(Commands.Whisper.getNameFromWhisper)

require(Commands.types)

return {
	name = script.Name,
	alias = {
		"/whisper",
		"/w"
	},
	clientRun = function(p1, n1: number, s1: string) -- line: 21
		-- upvalues: getNameFromWhisper (copy), Dictionary (copy), getAutocompletePlayersFromString (copy), v6 (copy), TextChatService (copy), RobloxReplicatedStorage (copy), ChatInputBarActivatedWhisperMode (copy)
		local v15 = p1:getState().AutoCastCommands[script.Name]
		local v16 = getNameFromWhisper(s1, v15)

		if v16 then
			local Players = p1:getState().Players
			local v18 = Dictionary.join(Players, {
				byUserId = Dictionary.removeKey(Players.byUserId, (tostring(n1)))
			})
			local v19 = getAutocompletePlayersFromString(v18, v16)

			if #v19 == 0 then
				v6:debug("Autocomplete: No matches!")

				local v20 = Players.byUserId[tostring(n1)]

				if v20 and (v16 == v20.displayName or v16 == "@" .. v20.username) then
					return {
						key = "InGame.UnknownNamespace.GameChat_PrivateMessaging_CannotWhisperToSelf",
						args = nil,
						metadata = "Roblox.Whisper.Error.CannotWhisperToSelf"
					}
				end

				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					metadata = "Roblox.Whisper.Error.TargetDoesNotExist",
					args = {
						RBX_NAME = v16 or ""
					}
				}
			end

			if #v19 ~= 1 then
				v6:debug("Autocomplete: Too many matches!")

				return {
					key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
					metadata = "Roblox.Whisper.Error.TooManyMatches"
				}
			end

			local v21 = v19[1]
			local num = tonumber(v21.userId)

			if num then
				local v23 = string.format("RBXWhisper:%d_%d", n1 < num and n1 or num, num < n1 and n1 or num)
				local v24 = TextChatService:FindFirstChild(v23, true)

				if not v24 then
					local ExperienceChat = RobloxReplicatedStorage:FindFirstChild("ExperienceChat")

					if not ExperienceChat then
						v6:error("Could not create whisper channel because RobloxReplicatedStorage.ExperienceChat is missing.")

						return {
							key = "",
							metadata = "Roblox.Whisper.Error.Unknown"
						}
					end

					local WhisperChat = ExperienceChat:FindFirstChild("WhisperChat")

					if not WhisperChat or not WhisperChat:IsA("RemoteFunction") then
						v6:error("Could not create whisper channel because WhisperChat RemoteFunction is missing.")

						return {
							key = "",
							metadata = "Roblox.Whisper.Error.Unknown"
						}
					end

					v24 = WhisperChat:InvokeServer(v21.userId)

					if not v24 then
						v6:error("Could not create whisper channel for some reason.")

						return {
							key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
							args = nil,
							metadata = "Roblox.Whisper.Error.Unknown"
						}
					end
				end

				p1:dispatch(ChatInputBarActivatedWhisperMode(nil, v24))

				return {
					key = "CoreScripts.TextChat.Notification.WhisperChat.Created",
					metadata = "Roblox.Whisper.Info.Success",
					args = {
						RBX_NAME = v16
					}
				}
			end
		end

		return {
			key = "",
			metadata = "Roblox.Whisper.Error.Unknown"
		}
	end
}
