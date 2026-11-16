local TextChatService = game:GetService("TextChatService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/Command/Whisper")

local ChatInputBarActivatedWhisperMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ChatInputBarActivatedWhisperMode")

local getAutocompletePlayersFromString = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/getAutocompletePlayersFromString")
local getNameFromWhisper = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/Whisper/getNameFromWhisper")
require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

return {
	name = "RBXWhisperCommand",
	alias = { "/whisper", "/w" },
	clientRun = function(object, p2, p3)
		local v6 = getNameFromWhisper(p3, object:getState().AutoCastCommands.RBXWhisperCommand)

		if v6 then
			local players = object:getState().Players
			local v7 = getAutocompletePlayersFromString(
				dictionary.join(players, {
					byUserId = dictionary.removeKey(players.byUserId, (tostring(p2)))
				}),
				v6
			)

			if #v7 == 0 then
				v5:debug("Autocomplete: No matches!")

				local v8 = players.byUserId[tostring(p2)]

				if v8 and (v6 == v8.displayName or v6 == "@" .. v8.username) then
					return {
						key = "InGame.UnknownNamespace.GameChat_PrivateMessaging_CannotWhisperToSelf",
						args = nil,
						metadata = "Roblox.Whisper.Error.CannotWhisperToSelf"
					}
				end

				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = {
						RBX_NAME = v6 or ""
					},
					metadata = "Roblox.Whisper.Error.TargetDoesNotExist"
				}
			else
				if #v7 ~= 1 then
					v5:debug("Autocomplete: Too many matches!")
					return {
						key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
						metadata = "Roblox.Whisper.Error.TooManyMatches"
					}
				end

				local v8 = v7[1]

				local v9 = tonumber(v8.userId)

				if v9 then
					local format = string.format

					local v11 = p2 < v9 and p2 or v9
					v9 = v9 < p2 and p2 or v9
					local v13 = TextChatService:FindFirstChild(format("RBXWhisper:%d_%d", v11, v9), true)

					if not v13 then
						local experienceChat = RobloxReplicatedStorage:FindFirstChild("ExperienceChat")

						if not experienceChat then
							v5:error("Could not create whisper channel because RobloxReplicatedStorage.ExperienceChat is missing.")

							return {
								key = "",
								metadata = "Roblox.Whisper.Error.Unknown"
							}
						end

						local whisperChat = experienceChat:FindFirstChild("WhisperChat")

						if not (whisperChat and whisperChat:IsA("RemoteFunction")) then
							v5:error("Could not create whisper channel because WhisperChat RemoteFunction is missing.")

							return {
								key = "",
								metadata = "Roblox.Whisper.Error.Unknown"
							}
						end

						v13 = whisperChat:InvokeServer(v8.userId)

						if not v13 then
							v5:error("Could not create whisper channel for some reason.")
							return {
								key = "CoreScripts.TextChat.Whisper.Error.CannotChat",
								args = nil,
								metadata = "Roblox.Whisper.Error.Unknown"
							}
						end
					end

					object:dispatch(ChatInputBarActivatedWhisperMode(nil, v13))

					return {
						key = "CoreScripts.TextChat.Notification.WhisperChat.Created",
						args = { RBX_NAME = v6 },
						metadata = "Roblox.Whisper.Info.Success"
					}
				end
			end
		end

		return { key = "", metadata = "Roblox.Whisper.Error.Unknown" }
	end
}
