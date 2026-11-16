local TextChatService = game:GetService("TextChatService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local ExpChatShared = script:FindFirstAncestor("ExpChatShared")

local parent = ExpChatShared.Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/Command/Whisper")

local Actions = ExpChatShared.Actions
local ChatInputBarActivatedWhisperMode = require(Actions.ChatInputBarActivatedWhisperMode)

local Commands = script:FindFirstAncestor("Commands")
local getAutocompletePlayersFromString = require(Commands.getAutocompletePlayersFromString)
local getNameFromWhisper = require(Commands.Whisper.getNameFromWhisper)
require(Commands.types)

return {
	name = script.Name,
	alias = { "/whisper", "/w" },
	clientRun = function(object, p: number, p2: string)
		local nameFromWhisper = getNameFromWhisper(p2, object:getState().AutoCastCommands[script.Name])

		if nameFromWhisper then
			local players = object:getState().Players
			local autocompletePlayersFromString = getAutocompletePlayersFromString(
				dictionary.join(players, {
					byUserId = dictionary.removeKey(players.byUserId, (tostring(p)))
				}),
				nameFromWhisper
			)

			if #autocompletePlayersFromString == 0 then
				v:debug("Autocomplete: No matches!")

				local v2 = players.byUserId[tostring(p)]

				if v2 and (nameFromWhisper == v2.displayName or nameFromWhisper == "@" .. v2.username) then
					return {
						key = "InGame.UnknownNamespace.GameChat_PrivateMessaging_CannotWhisperToSelf",
						args = nil,
						metadata = "Roblox.Whisper.Error.CannotWhisperToSelf"
					}
				end

				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = {
						RBX_NAME = nameFromWhisper or ""
					},
					metadata = "Roblox.Whisper.Error.TargetDoesNotExist"
				}
			else
				if #autocompletePlayersFromString ~= 1 then
					v:debug("Autocomplete: Too many matches!")
					return {
						key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
						metadata = "Roblox.Whisper.Error.TooManyMatches"
					}
				end

				local v2 = autocompletePlayersFromString[1]

				local v3 = tonumber(v2.userId)

				if v3 then
					local v4 = p < v3 and p or v3
					v3 = v3 < p and p or v3
					local v5 = TextChatService:FindFirstChild(string.format("RBXWhisper:%d_%d", v4, v3), true)

					if not v5 then
						local experienceChat = RobloxReplicatedStorage:FindFirstChild("ExperienceChat")

						if not experienceChat then
							v:error("Could not create whisper channel because RobloxReplicatedStorage.ExperienceChat is missing.")

							return { key = "", metadata = "Roblox.Whisper.Error.Unknown" }
						end

						local whisperChat = experienceChat:FindFirstChild("WhisperChat")

						if not (whisperChat and whisperChat:IsA("RemoteFunction")) then
							v:error("Could not create whisper channel because WhisperChat RemoteFunction is missing.")

							return { key = "", metadata = "Roblox.Whisper.Error.Unknown" }
						end

						v5 = whisperChat:InvokeServer(v2.userId)

						if not v5 then
							v:error("Could not create whisper channel for some reason.")
							return {
								key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
								args = nil,
								metadata = "Roblox.Whisper.Error.Unknown"
							}
						end
					end

					object:dispatch(ChatInputBarActivatedWhisperMode(nil, v5))

					return {
						key = "CoreScripts.TextChat.Notification.WhisperChat.Created",
						args = { RBX_NAME = nameFromWhisper },
						metadata = "Roblox.Whisper.Info.Success"
					}
				end
			end
		end

		return { key = "", metadata = "Roblox.Whisper.Error.Unknown" }
	end
}
