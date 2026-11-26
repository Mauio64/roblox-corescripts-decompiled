local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/types")

return {
	name = "GlobalMuteCommand",
	alias = { "/mute", "/m" },
	clientRun = function(p2, p3, value, p4)
		local v5 = string.split(value, " ")[2]
		local v6 = not (v5 == nil) and string.sub(v5, 1, 1) == "@"

		if v6 then
			v5 = string.sub(v5, 2)
		end

		if not v5 or #v5 < 3 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				args = {
					RBX_NAME = v5 or ""
				},
				metadata = "Roblox.GlobalMute.Error.PlayerNotFound"
			}
		end

		if not (p4 and p4.globalMutedUsersStore) then
			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				args = {},
				metadata = "Roblox.GlobalMute.Error.ContextNotAvailable"
			}
		end

		if not v6 then
			p4.globalMutedUsersStore.muteGlobalDisplayName(v5)
			return {
				key = "CoreScripts.TextChat.Mute.Success",
				args = { RBX_NAME = v5 },
				metadata = "Roblox.GlobalMute.Info.Success"
			}
		end

		local v7 = string.lower(v5)

		if Players.LocalPlayer and string.lower(Players.LocalPlayer.Name) == v7 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
				args = {},
				metadata = "Roblox.GlobalMute.Error.CannotMuteSelf"
			}
		end

		p4.globalMutedUsersStore.muteGlobalUsername(v7)
		return {
			key = "CoreScripts.TextChat.Mute.Success",
			args = {
				RBX_NAME = "@" .. v7
			},
			metadata = "Roblox.GlobalMute.Info.Success"
		}
	end
}
